/** Compiled by the Randori compiler v0.2.6.2 on Sat Sep 28 11:54:57 EST 2013 */

if (typeof aglsl == "undefined")
	var aglsl = {};
if (typeof aglsl.assembler == "undefined")
	aglsl.assembler = {};

aglsl.assembler.AGALMiniAssembler = function() {
	this.r = null;
	this.cur = null;
	this.r = {};
	this.cur = new aglsl.assembler.Part();
};

aglsl.assembler.AGALMiniAssembler.prototype.assemble = function(source, ext_part, ext_version) {
	ext_part = ext_part || null;
	ext_version = ext_version || 1;
	if (!ext_version) {
		ext_version = 1;
	}
	if (ext_part) {
		this.addHeader(ext_part, ext_version);
	}
	var lines = source.replace(/[\f\n\r\v]+/g, "\n").split("\n", 4.294967295E9);
	for (var i in lines) {
		this.processLine(lines[i], i);
	}
	return this.r;
};

aglsl.assembler.AGALMiniAssembler.prototype.processLine = function(line, linenr) {
	var startcomment = line.search("\/\/");
	if (startcomment != -1) {
		line = line.slice(0, startcomment);
	}
	line = line.replace(/^\s+|\s+$/g, "");
	if (!(line.length > 0)) {
		return;
	}
	var optsi = line.search(/<.*>/g);
	var opts = null;
	if (optsi != -1) {
		opts = line.slice(optsi, 2147483647).match(/([\w\.\-\+]+)/gi);
		line = line.slice(0, optsi);
	}
	var tokens = line.match(/([\w\.\+\[\]]+)/gi);
	if (!tokens || tokens.length < 1) {
		if (line.length >= 3) {
			console.log("Warning: bad line " + linenr + ": " + line);
		}
		return;
	}
	switch (tokens[0]) {
		case "part":
			this.addHeader(tokens[1], tokens[2]);
			break;
		case "endpart":
			if (!this.cur) {
				throw "Unexpected endpart";
			}
			this.cur.data.position = 0;
			this.cur = null;
			return;
		default:
			if (!this.cur) {
				console.log("Warning: bad line " + linenr + ": " + line + " (Outside of any part definition)");
				return;
			}
			if (this.cur.name == "comment") {
				return;
			}
			var op = aglsl.assembler.OpcodeMap.get_map()[tokens[0]];
			if (!op) {
				throw "Bad opcode " + tokens[0] + " " + linenr + ": " + line;
			}
			this.emitOpcode(this.cur, op.opcode);
			var ti = 1;
			if (op.dest && op.dest != "none") {
				if (!this.emitDest(this.cur, tokens[ti++], op.dest)) {
					throw "Bad destination register " + tokens[ti - 1] + " " + linenr + ": " + line;
				}
			} else {
				this.emitZeroDword(this.cur);
			}
			if (op.a && op.a.format != "none") {
				if (!this.emitSource(this.cur, tokens[ti++], op.a))
					throw "Bad source register " + tokens[ti - 1] + " " + linenr + ": " + line;
			} else {
				this.emitZeroQword(this.cur);
			}
			if (op.b && op.b.format != "none") {
				if (op.b.format == "sampler") {
					if (!this.emitSampler(this.cur, tokens[ti++], op.b, opts)) {
						throw "Bad sampler register " + tokens[ti - 1] + " " + linenr + ": " + line;
					}
				} else {
					if (!this.emitSource(this.cur, tokens[ti++], op.b)) {
						throw "Bad source register " + tokens[ti - 1] + " " + linenr + ": " + line;
					}
				}
			} else {
				this.emitZeroQword(this.cur);
			}
			break;
	}
};

aglsl.assembler.AGALMiniAssembler.prototype.emitHeader = function(pr) {
	pr.data.writeUnsignedByte(0xa0);
	pr.data.writeUnsignedInt(pr.version);
	if (pr.version >= 0x10) {
		pr.data.writeUnsignedByte(0);
	}
	pr.data.writeUnsignedByte(0xa1);
	switch (pr.name) {
		case "fragment":
			pr.data.writeUnsignedByte(1);
			break;
		case "vertex":
			pr.data.writeUnsignedByte(0);
			break;
		case "cpu":
			pr.data.writeUnsignedByte(2);
			break;
		default:
			pr.data.writeUnsignedByte(0xff);
			break;
	}
};

aglsl.assembler.AGALMiniAssembler.prototype.emitOpcode = function(pr, opcode) {
	pr.data.writeUnsignedInt(opcode);
};

aglsl.assembler.AGALMiniAssembler.prototype.emitZeroDword = function(pr) {
	pr.data.writeUnsignedInt(0);
};

aglsl.assembler.AGALMiniAssembler.prototype.emitZeroQword = function(pr) {
	pr.data.writeUnsignedInt(0);
	pr.data.writeUnsignedInt(0);
};

aglsl.assembler.AGALMiniAssembler.prototype.emitDest = function(pr, token, opdest) {
	var reg = token.match(/([fov]?[tpocidavs])(\d*)(\.[xyzw]{1,4})?/i);
	if (!aglsl.assembler.RegMap.get_map()[reg[1]])
		return false;
	var em = {num:reg[2] ? reg[2] : 0, code:aglsl.assembler.RegMap.get_map()[reg[1]].code, mask:this.stringToMask(reg[3])};
	pr.data.writeUnsignedShort(em.num);
	pr.data.writeUnsignedByte(em.mask);
	pr.data.writeUnsignedByte(em.code);
	return true;
};

aglsl.assembler.AGALMiniAssembler.prototype.stringToMask = function(s) {
	if (!s)
		return 0xf;
	var r = 0;
	if (s.indexOf("x", 0) != -1)
		r |= 1;
	if (s.indexOf("y", 0) != -1)
		r |= 2;
	if (s.indexOf("z", 0) != -1)
		r |= 4;
	if (s.indexOf("w", 0) != -1)
		r |= 8;
	return r;
};

aglsl.assembler.AGALMiniAssembler.prototype.stringToSwizzle = function(s) {
	if (!s) {
		return 0xe4;
	}
	var chartoindex = {x:0, y:1, z:2, w:3};
	var sw = 0;
	if (s.charAt(0) != ".") {
		throw "Missing . for swizzle";
	}
	if (s.length > 1) {
		sw |= chartoindex[s.charAt(1)];
	}
	if (s.length > 2) {
		sw |= chartoindex[s.charAt(2)] << 2;
	} else {
		sw |= (sw & 3) << 2;
	}
	if (s.length > 3) {
		sw |= chartoindex[s.charAt(3)] << 4;
	} else {
		sw |= (sw & (3 << 2)) << 2;
	}
	if (s.length > 4) {
		sw |= chartoindex[s.charAt(4)] << 6;
	} else {
		sw |= (sw & (3 << 4)) << 2;
	}
	return sw;
};

aglsl.assembler.AGALMiniAssembler.prototype.emitSampler = function(pr, token, opsrc, opts) {
	var reg = token.match(/fs(\d*)/i);
	if (!reg || !reg[1]) {
		return false;
	}
	pr.data.writeUnsignedShort(reg[1]);
	pr.data.writeUnsignedByte(0);
	pr.data.writeUnsignedByte(0);
	var samplerbits = 0x5;
	var sampleroptset = 0;
	for (var i = 0; i < opts.length; i++) {
		var o = aglsl.assembler.SamplerMap.get_map()[opts[i].toLowerCase()];
		if (o) {
			if (((sampleroptset >> o.shift) & o.mask) != 0) {
				console.log("Warning, duplicate sampler option");
			}
			sampleroptset |= o.mask << o.shift;
			samplerbits &= ~(o.mask << o.shift);
			samplerbits |= o.value << o.shift;
		} else {
			console.log("Warning, unknown sampler option: ", opts[i]);
		}
	}
	pr.data.writeUnsignedInt(samplerbits);
	return true;
};

aglsl.assembler.AGALMiniAssembler.prototype.emitSource = function(pr, token, opsrc) {
	var indexed = token.match(/vc\[(v[tcai])(\d+)\.([xyzw])([\+\-]\d+)?\](\.[xyzw]{1,4})?/i);
	var reg;
	if (indexed) {
		if (!aglsl.assembler.RegMap.get_map()[indexed[1]]) {
			return false;
		}
		var selindex = {x:0, y:1, z:2, w:3};
		var em = {num:indexed[2] | 0, code:aglsl.assembler.RegMap.get_map()[indexed[1]].code, swizzle:this.stringToSwizzle(indexed[5]), select:selindex[indexed[3]], offset:indexed[4] | 0};
		pr.data.writeUnsignedShort(em.num);
		pr.data.writeByte(em.offset);
		pr.data.writeUnsignedByte(em.swizzle);
		pr.data.writeUnsignedByte(0x1);
		pr.data.writeUnsignedByte(em.code);
		pr.data.writeUnsignedByte(em.select);
		pr.data.writeUnsignedByte(1 << 7);
	} else {
		reg = token.match(/([fov]?[tpocidavs])(\d*)(\.[xyzw]{1,4})?/i);
		if (!aglsl.assembler.RegMap.get_map()[reg[1]]) {
			return false;
		}
		var em = {num:reg[2] | 0, code:aglsl.assembler.RegMap.get_map()[reg[1]].code, swizzle:this.stringToSwizzle(reg[3])};
		pr.data.writeUnsignedShort(em.num);
		pr.data.writeUnsignedByte(0);
		pr.data.writeUnsignedByte(em.swizzle);
		pr.data.writeUnsignedByte(em.code);
		pr.data.writeUnsignedByte(0);
		pr.data.writeUnsignedByte(0);
		pr.data.writeUnsignedByte(0);
	}
	return true;
};

aglsl.assembler.AGALMiniAssembler.prototype.addHeader = function(partname, version) {
	if (!version) {
		version = 1;
	}
	if (this.r[partname] == undefined) {
		this.r[partname] = new aglsl.assembler.Part(partname, version);
		this.emitHeader(this.r[partname]);
	} else if (this.r[partname].version != version) {
		throw "Multiple versions for part " + partname;
	}
	this.cur = this.r[partname];
};

aglsl.assembler.AGALMiniAssembler.className = "aglsl.assembler.AGALMiniAssembler";

aglsl.assembler.AGALMiniAssembler.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('aglsl.assembler.Part');
	p.push('aglsl.assembler.SamplerMap');
	p.push('aglsl.assembler.OpcodeMap');
	p.push('aglsl.assembler.RegMap');
	p.push('aglsl.assembler.Opcode');
	return p;
};

aglsl.assembler.AGALMiniAssembler.getStaticDependencies = function(t) {
	var p;
	return [];
};

aglsl.assembler.AGALMiniAssembler.injectionPoints = function(t) {
	return [];
};
