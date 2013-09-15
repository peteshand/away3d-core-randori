/** Compiled by the Randori compiler v0.2.6.2 on Fri Sep 13 21:20:09 EST 2013 */

if (typeof aglsl == "undefined")
	var aglsl = {};

aglsl.AGALTokenizer = function() {
};

aglsl.AGALTokenizer.prototype.decribeAGALByteArray = function(bytes) {
	var header = new aglsl.Header();
	if (bytes.readUnsignedByte() != 0xa0) {
		throw "Bad AGAL: Missing 0xa0 magic byte.";
	}
	header.version = bytes.readUnsignedInt();
	if (header.version >= 0x10) {
		bytes.readUnsignedByte();
		header.version >>= 1;
	}
	if (bytes.readUnsignedByte() != 0xa1) {
		throw "Bad AGAL: Missing 0xa1 magic byte.";
	}
	header.progid = bytes.readUnsignedByte();
	switch (header.progid) {
		case 1:
			header.type = "fragment";
			break;
		case 0:
			header.type = "vertex";
			break;
		case 2:
			header.type = "cpu";
			break;
		default:
			header.type = "";
			break;
	}
	var desc = new aglsl.Description();
	var tokens = [];
	while (bytes.position < bytes.length) {
		var token = new aglsl.Token();
		token.opcode = bytes.readUnsignedInt();
		var lutentry = aglsl.Mapping.get_agal2glsllut()[token.opcode];
		if (!lutentry) {
			throw "Opcode not valid or not implemented yet: " + token.opcode;
		}
		if (lutentry.matrixheight) {
			desc.hasmatrix = true;
		}
		if (lutentry.dest) {
			token.dest.regnum = bytes.readUnsignedShort();
			token.dest.mask = bytes.readUnsignedByte();
			token.dest.regtype = bytes.readUnsignedByte();
			desc.regwrite[token.dest.regtype][token.dest.regnum] |= token.dest.mask;
		} else {
			token.dest = null;
			bytes.readUnsignedInt();
		}
		if (lutentry.a) {
			this.readReg(token.a, 1, desc, bytes);
		} else {
			token.a = null;
			bytes.readUnsignedInt();
			bytes.readUnsignedInt();
		}
		if (lutentry.b) {
			this.readReg(token.b, lutentry.matrixheight | 0, desc, bytes);
		} else {
			token.b = null;
			bytes.readUnsignedInt();
			bytes.readUnsignedInt();
		}
		tokens.push(token);
	}
	desc.header = header;
	desc.tokens = tokens;
	return desc;
};

aglsl.AGALTokenizer.prototype.readReg = function(s, mh, desc, bytes) {
	s.regnum = bytes.readUnsignedShort();
	s.indexoffset = bytes.readByte();
	s.swizzle = bytes.readUnsignedByte();
	s.regtype = bytes.readUnsignedByte();
	desc.regread[s.regtype][s.regnum] = 0xf;
	if (s.regtype == 0x5) {
		s.lodbiad = s.indexoffset;
		s.indexoffset = undefined;
		s.swizzle = undefined;
		s.readmode = bytes.readUnsignedByte();
		s.dim = s.readmode >> 4;
		s.readmode &= 0xf;
		s.special = bytes.readUnsignedByte();
		s.wrap = s.special >> 4;
		s.special &= 0xf;
		s.mipmap = bytes.readUnsignedByte();
		s.filter = s.mipmap >> 4;
		s.mipmap &= 0xf;
		desc.samplers[s.regnum] = s;
	} else {
		s.indexregtype = bytes.readUnsignedByte();
		s.indexselect = bytes.readUnsignedByte();
		s.indirectflag = bytes.readUnsignedByte();
	}
	if (s.indirectflag) {
		desc.hasindirect = true;
	}
	if (!s.indirectflag && mh) {
		for (var mhi = 0; mhi < mh; mhi++) {
			desc.regread[s.regtype][s.regnum + mhi] = desc.regread[s.regtype][s.regnum];
		}
	}
};

aglsl.AGALTokenizer.className = "aglsl.AGALTokenizer";

aglsl.AGALTokenizer.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('aglsl.Description');
	p.push('aglsl.Header');
	p.push('aglsl.Token');
	p.push('aglsl.Mapping');
	return p;
};

aglsl.AGALTokenizer.getStaticDependencies = function(t) {
	var p;
	return [];
};

aglsl.AGALTokenizer.injectionPoints = function(t) {
	return [];
};
