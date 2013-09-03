/** Compiled by the Randori compiler v0.2.6.2 on Mon Sep 02 23:32:25 EST 2013 */

if (typeof aglsl == "undefined")
	var aglsl = {};

aglsl.AGLSLParser = function() {
	
};

aglsl.AGLSLParser.prototype.parse = function(desc) {
	var header = "";
	var body = "";
	header += "precision mediump float;\n";
	var tag = desc.header.type[0];
	if (desc.header.type == "vertex") {
		header += "uniform float yflip;\n";
	}
	if (!desc.hasindirect) {
		for (var i = 0; i < desc.regread[0x1].length; i++) {
			if (desc.regread[0x1][i]) {
				header += "uniform vec4 " + tag + "c" + i + ";\n";
			}
		}
	} else {
		header += "uniform vec4 " + tag + "carrr[" + aglsl.Context3D.maxvertexconstants + "];\n";
	}
	for (var i = 0; i < desc.regread[0x2].length || i < desc.regwrite[0x2].length; i++) {
		if (desc.regread[0x2][i] || desc.regwrite[0x2][i]) {
			header += "vec4 " + tag + "t" + i + ";\n";
		}
	}
	for (var i = 0; i < desc.regread[0x0].length; i++) {
		if (desc.regread[0x0][i]) {
			header += "attribute vec4 va" + i + ";\n";
		}
	}
	for (var i = 0; i < desc.regread[0x4].length || i < desc.regwrite[0x4].length; i++) {
		if (desc.regread[0x4][i] || desc.regwrite[0x4][i]) {
			header += "varying vec4 vi" + i + ";\n";
		}
	}
	var samptype = ["2D", "Cube", "3D", ""];
	for (var i = 0; i < desc.samplers.length; i++) {
		if (desc.samplers[i]) {
			header += "uniform sampler" + samptype[desc.samplers[i].dim & 3] + " fs" + i + ";\n";
		}
	}
	if (desc.header.type == "vertex") {
		header += "vec4 outpos;\n";
	}
	if (desc.writedepth) {
		header += "vec4 tmp_FragDepth;\n";
	}
	body += "void main() {\n";
	for (var i = 0; i < desc.tokens.length; i++) {
		var lutentry = aglsl.Mapping.get_agal2glsllut()[desc.tokens[i].opcode];
		if (!lutentry) {
			throw "Opcode not valid or not implemented yet: ";
		}
		var sublines = lutentry.matrixheight || 1;
		for (var sl = 0; sl < sublines; sl++) {
			var line = "  " + lutentry.s;
			if (desc.tokens[i].dest) {
				if (lutentry.matrixheight) {
					if (((desc.tokens[i].dest.mask >> sl) & 1) != 1) {
						continue;
					}
					var destregstring = this.regtostring(desc.tokens[i].dest.regtype, desc.tokens[i].dest.regnum, desc, tag);
					var destcaststring = "float";
					var destmaskstring = ["x", "y", "z", "w"][sl];
					destregstring += "." + destmaskstring;
				} else {
					var destregstring = this.regtostring(desc.tokens[i].dest.regtype, desc.tokens[i].dest.regnum, desc, tag);
					var destcaststring;
					var destmaskstring;
					if (desc.tokens[i].dest.mask != 0xf) {
						var ndest = 0;
						destmaskstring = "";
						if (desc.tokens[i].dest.mask & 1) {
							ndest++;
							destmaskstring += "x";
						}
						if (desc.tokens[i].dest.mask & 2) {
							ndest++;
							destmaskstring += "y";
						}
						if (desc.tokens[i].dest.mask & 4) {
							ndest++;
							destmaskstring += "z";
						}
						if (desc.tokens[i].dest.mask & 8) {
							ndest++;
							destmaskstring += "w";
						}
						destregstring += "." + destmaskstring;
						switch (ndest) {
							case 1:
								destcaststring = "float";
								break;
							case 2:
								destcaststring = "vec2";
								break;
							case 3:
								destcaststring = "vec3";
								break;
							default:
								throw "Unexpected destination mask";
						}
					} else {
						destcaststring = "vec4";
						destmaskstring = "xyzw";
					}
				}
				line = line.replace("%dest", destregstring);
				line = line.replace("%cast", destcaststring);
				line = line.replace("%dm", destmaskstring);
			}
			var dwm = 0xf;
			if (!lutentry.ndwm && lutentry.dest && desc.tokens[i].dest) {
				dwm = desc.tokens[i].dest.mask;
			}
			if (desc.tokens[i].a) {
				line = line.replace("%a", this.sourcetostring(desc.tokens[i].a, 0, dwm, lutentry.scalar, desc, tag));
			}
			if (desc.tokens[i].b) {
				line = line.replace("%b", this.sourcetostring(desc.tokens[i].b, sl, dwm, lutentry.scalar, desc, tag));
				if (desc.tokens[i].b.regtype == 0x5) {
					var texdim = ["2D", "Cube", "3D"][desc.tokens[i].b.dim];
					var texsize = ["vec2", "vec3", "vec3"][desc.tokens[i].b.dim];
					line = line.replace("%texdim", texdim);
					line = line.replace("%texsize", texsize);
					var texlod = "";
					line = line.replace("%lod", texlod);
				}
			}
			body += line;
		}
	}
	if (desc.header.type == "vertex") {
		body += "  gl_Position = vec4(outpos.x, yflip*outpos.y, outpos.z*2.0 - outpos.w, outpos.w);\n";
	}
	if (desc.writedepth) {
		body += "  gl_FragDepth = clamp(tmp_FragDepth,0.0,1.0);\n";
	}
	body += "}\n";
	return header + body;
};

aglsl.AGLSLParser.prototype.regtostring = function(regtype, regnum, desc, tag) {
	switch (regtype) {
		case 0x0:
			return "va" + regnum;
		case 0x1:
			if (desc.hasindirect && desc.header.type == "vertex") {
				return "vcarrr[" + regnum + "]";
			} else {
				return tag + "c" + regnum;
			}
		case 0x2:
			return tag + "t" + regnum;
		case 0x3:
			return desc.header.type == "vertex" ? "outpos" : "gl_FragColor";
		case 0x4:
			return "vi" + regnum;
		case 0x5:
			return "fs" + regnum;
		case 0x6:
			return "tmp_FragDepth";
		default:
			throw "Unknown register type";
	}
};

aglsl.AGLSLParser.prototype.sourcetostring = function(s, subline, dwm, isscalar, desc, tag) {
	var swiz = ["x", "y", "z", "w"];
	var r;
	if (s.indirectflag) {
		r = "vcarrr[int(" + this.regtostring(s.indexregtype, s.regnum, desc, tag) + "." + swiz[s.indexselect] + ")";
		var realofs = subline + s.indexoffset;
		if (realofs < 0)
			r += realofs.toString();
		if (realofs > 0)
			r += "+" + realofs.toString();
		r += "]";
	} else {
		r = this.regtostring(s.regtype, s.regnum + subline, desc, tag);
	}
	if (s.regtype == 0x5) {
		return r;
	}
	if (isscalar) {
		return r + "." + swiz[(s.swizzle >> 0) & 3];
	}
	if (s.swizzle == 0xe4 && dwm == 0xf) {
		return r;
	}
	r += ".";
	if (dwm & 1)
		r += swiz[(s.swizzle >> 0) & 3];
	if (dwm & 2)
		r += swiz[(s.swizzle >> 2) & 3];
	if (dwm & 4)
		r += swiz[(s.swizzle >> 4) & 3];
	if (dwm & 8)
		r += swiz[(s.swizzle >> 6) & 3];
	return r;
};

aglsl.AGLSLParser.className = "aglsl.AGLSLParser";

aglsl.AGLSLParser.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('Object');
	p.push('aglsl.Context3D');
	p.push('aglsl.Mapping');
	return p;
};

aglsl.AGLSLParser.getStaticDependencies = function(t) {
	var p;
	return [];
};

aglsl.AGLSLParser.injectionPoints = function(t) {
	return [];
};
