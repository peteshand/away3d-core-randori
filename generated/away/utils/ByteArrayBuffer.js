/** Compiled by the Randori compiler v0.2.6.2 on Mon Sep 02 23:32:14 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.utils == "undefined")
	away.utils = {};

away.utils.ByteArrayBuffer = function() {
	this._bytes = null;
	away.utils.ByteArrayBase.call(this);
	this._bytes = [];
	this._mode = "Array";
};

away.utils.ByteArrayBuffer.prototype.writeByte = function(b) {
	var bi = ~~b;
	this._bytes[this.position++] = bi;
	if (this.position > this.length) {
		this.length = this.position;
	}
};

away.utils.ByteArrayBuffer.prototype.readByte = function() {
	if (this.position >= this.length) {
		throw "ByteArray out of bounds read. Position=" + this.position + ", Length=" + this.length;
	}
	return this._bytes[this.position++];
};

away.utils.ByteArrayBuffer.prototype.writeUnsignedByte = function(b) {
	var bi = ~~b;
	this._bytes[this.position++] = bi & 0xff;
	if (this.position > this.length) {
		this.length = this.position;
	}
};

away.utils.ByteArrayBuffer.prototype.readUnsignedByte = function() {
	if (this.position >= this.length) {
		throw "ByteArray out of bounds read. Position=" + this.position + ", Length=" + this.length;
	}
	return this._bytes[this.position++];
};

away.utils.ByteArrayBuffer.prototype.writeUnsignedShort = function(b) {
	var bi = ~~b;
	this._bytes[this.position++] = bi & 0xff;
	this._bytes[this.position++] = (bi >> 8) & 0xff;
	if (this.position > this.length) {
		this.length = this.position;
	}
};

away.utils.ByteArrayBuffer.prototype.readUnsignedShort = function() {
	if (this.position + 2 > this.length) {
		throw "ByteArray out of bounds read. Position=" + this.position + ", Length=" + this.length;
	}
	var r = this._bytes[this.position] | (this._bytes[this.position + 1] << 8);
	this.position += 2;
	return r;
};

away.utils.ByteArrayBuffer.prototype.writeUnsignedInt = function(b) {
	var bi = ~~b;
	this._bytes[this.position++] = bi & 0xff;
	this._bytes[this.position++] = (bi >>> 8) & 0xff;
	this._bytes[this.position++] = (bi >>> 16) & 0xff;
	this._bytes[this.position++] = (bi >>> 24) & 0xff;
	if (this.position > this.length) {
		this.length = this.position;
	}
};

away.utils.ByteArrayBuffer.prototype.readUnsignedInt = function() {
	if (this.position + 4 > this.length) {
		throw "ByteArray out of bounds read. Position=" + this.position + ", Length=" + this.length;
	}
	var r = this._bytes[this.position] | (this._bytes[this.position + 1] << 8) | (this._bytes[this.position + 2] << 16) | (this._bytes[this.position + 3] << 24);
	this.position += 4;
	return r >>> 0;
};

away.utils.ByteArrayBuffer.prototype.writeFloat = function(b) {
	this.writeUnsignedInt(this.toFloatBits(b));
};

away.utils.ByteArrayBuffer.prototype.toFloatBits = function(x) {
	if (x == 0) {
		return 0;
	}
	var sign = 0;
	if (x < 0) {
		x = -x;
		sign = 1;
	} else {
		sign = 0;
	}
	var exponent = Math.log(x) / Math.log(2);
	exponent = Math.floor(exponent);
	x = x * Math.pow(2, 23 - exponent);
	var mantissa = Math.floor(x) - 0x800000;
	exponent = exponent + 127;
	return ((sign << 31) >>> 0) | (exponent << 23) | mantissa;
};

away.utils.ByteArrayBuffer.prototype.readFloat = function(b) {
	return this.fromFloatBits(this.readUnsignedInt());
};

away.utils.ByteArrayBuffer.prototype.fromFloatBits = function(x) {
	if (x == 0) {
		return 0;
	}
	var exponent = (x >>> 23) & 0xff;
	var mantissa = (x & 0x7fffff) | 0x800000;
	var y = Math.pow(2, (exponent - 127) - 23) * mantissa;
	if (x >>> 31 != 0) {
		y = -y;
	}
	return y;
};

$inherit(away.utils.ByteArrayBuffer, away.utils.ByteArrayBase);

away.utils.ByteArrayBuffer.className = "away.utils.ByteArrayBuffer";

away.utils.ByteArrayBuffer.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.utils.ByteArrayBuffer.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.utils.ByteArrayBuffer.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 1:
			p = away.utils.ByteArrayBase.injectionPoints(t);
			break;
		case 2:
			p = away.utils.ByteArrayBase.injectionPoints(t);
			break;
		case 3:
			p = away.utils.ByteArrayBase.injectionPoints(t);
			break;
		default:
			p = [];
			break;
	}
	return p;
};

