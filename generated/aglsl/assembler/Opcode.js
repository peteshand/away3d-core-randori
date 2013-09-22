/** Compiled by the Randori compiler v0.2.6.2 on Sun Sep 22 11:19:44 EST 2013 */

if (typeof aglsl == "undefined")
	var aglsl = {};
if (typeof aglsl.assembler == "undefined")
	aglsl.assembler = {};

aglsl.assembler.Opcode = function(dest, aformat, asize, bformat, bsize, opcode, simple, horizontal, fragonly, matrix) {
	this.a = null;
	this.b = null;
	this.flags = null;
	this.a = new aglsl.assembler.FS();
	this.b = new aglsl.assembler.FS();
	this.flags = new aglsl.assembler.Flags();
	this.dest = dest;
	this.a.format = aformat;
	this.a.size = asize;
	this.b.format = bformat;
	this.b.size = bsize;
	this.opcode = opcode;
	this.flags.simple = simple;
	this.flags.horizontal = horizontal;
	this.flags.fragonly = fragonly;
	this.flags.matrix = matrix;
};

aglsl.assembler.Opcode.className = "aglsl.assembler.Opcode";

aglsl.assembler.Opcode.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('aglsl.assembler.FS');
	p.push('aglsl.assembler.Flags');
	return p;
};

aglsl.assembler.Opcode.getStaticDependencies = function(t) {
	var p;
	return [];
};

aglsl.assembler.Opcode.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'dest', t:'String'});
			p.push({n:'aformat', t:'String'});
			p.push({n:'asize', t:'Number'});
			p.push({n:'bformat', t:'String'});
			p.push({n:'bsize', t:'Number'});
			p.push({n:'opcode', t:'Number'});
			p.push({n:'simple', t:'Boolean'});
			p.push({n:'horizontal', t:'Boolean'});
			p.push({n:'fragonly', t:'Boolean'});
			p.push({n:'matrix', t:'Boolean'});
			break;
		default:
			p = [];
			break;
	}
	return p;
};

