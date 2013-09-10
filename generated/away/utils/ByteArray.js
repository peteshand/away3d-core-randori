/** Compiled by the Randori compiler v0.2.6.2 on Tue Sep 10 22:28:04 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.utils == "undefined")
	away.utils = {};

away.utils.ByteArray = function() {
	this.unalignedarraybytestemp = undefined;
	this.arraybytes = undefined;
	this.maxlength = 0;
	away.utils.ByteArrayBase.call(this);
	this._mode = "Typed array";
	this.maxlength = 4;
	this.arraybytes = new ArrayBuffer();
	this.unalignedarraybytestemp = new ArrayBuffer();
};

away.utils.ByteArray.prototype.ensureWriteableSpace = function(n) {
	this.ensureSpace(n + this.position);
};

away.utils.ByteArray.prototype.setArrayBuffer = function(aBuffer) {
	this.maxlength = this.length = aBuffer.byteLength;
	this.arraybytes = aBuffer;
};

away.utils.ByteArray.prototype.getBytesAvailable = function() {
	return this.arraybytes.byteLength - this.position;
};

away.utils.ByteArray.prototype.ensureSpace = function(n) {
	if (n > this.maxlength) {
		var newmaxlength = (n + 255) & ~255;
		var newarraybuffer = new ArrayBuffer();
		var view = new Uint8Array(this.arraybytes, 0, this.length);
		var newview = new Uint8Array(newarraybuffer, 0, this.length);
		newview.set(view);
		this.arraybytes = newarraybuffer;
		this.maxlength = newmaxlength;
	}
};

away.utils.ByteArray.prototype.writeByte = function(b) {
	this.ensureWriteableSpace(1);
	var view = new Int8Array(this.arraybytes);
	view[this.position++] = ~~b;
	if (this.position > this.length) {
		this.length = this.position;
	}
};

away.utils.ByteArray.prototype.readByte = function() {
	if (this.position >= this.length) {
		throw "ByteArray out of bounds read. Positon=" + this.position + ", Length=" + this.length;
	}
	var view = new Int8Array(this.arraybytes);
	return view[this.position++];
};

away.utils.ByteArray.prototype.readBytes = function(bytes, start, end) {
	var uintArr = new Uint8Array(this.arraybytes);
	if (end == start || end <= start) {
		end = uintArr.length;
	}
	var result = new ArrayBuffer();
	var resultArray = new Uint8Array(result);
	for (var i = 0; i < resultArray.length; i++) {
		resultArray[i] = uintArr[i + start];
	}
	bytes.setArrayBuffer(result);
};

away.utils.ByteArray.prototype.writeUnsignedByte = function(b) {
	this.ensureWriteableSpace(1);
	var view = new Uint8Array(this.arraybytes);
	view[this.position++] = ~~b & 0xff;
	if (this.position > this.length) {
		this.length = this.position;
	}
};

away.utils.ByteArray.prototype.readUnsignedByte = function() {
	if (this.position >= this.length) {
		throw "ByteArray out of bounds read. Positon=" + this.position + ", Length=" + this.length;
	}
	var view = new Uint8Array(this.arraybytes);
	return view[this.position++];
};

away.utils.ByteArray.prototype.writeUnsignedShort = function(b) {
	this.ensureWriteableSpace(2);
	if ((this.position & 1) == 0) {
		var view = new Uint16Array(this.arraybytes);
		view[this.position >> 1] = ~~b & 0xffff;
	} else {
		var view = new Uint16Array(this.unalignedarraybytestemp, 0, 1);
		view[0] = ~~b & 0xffff;
		var view2 = new Uint8Array(this.arraybytes, this.position, 2);
		var view3 = new Uint8Array(this.unalignedarraybytestemp, 0, 2);
		view2.set(view3);
	}
	this.position += 2;
	if (this.position > this.length) {
		this.length = this.position;
	}
};

away.utils.ByteArray.prototype.readUnsignedShort = function() {
	if (this.position > this.length + 2) {
		throw "ByteArray out of bounds read. Positon=" + this.position + ", Length=" + this.length;
	}
	if ((this.position & 1) == 0) {
		var view = new Uint16Array(this.arraybytes);
		var pa = this.position >> 1;
		this.position += 2;
		return view[pa];
	} else {
		var view = new Uint16Array(this.unalignedarraybytestemp, 0, 1);
		var view2 = new Uint8Array(this.arraybytes, this.position, 2);
		var view3 = new Uint8Array(this.unalignedarraybytestemp, 0, 2);
		view3.set(view2);
		this.position += 2;
		return view[0];
	}
};

away.utils.ByteArray.prototype.writeUnsignedInt = function(b) {
	this.ensureWriteableSpace(4);
	if ((this.position & 3) == 0) {
		var view = new Uint32Array(this.arraybytes);
		view[this.position >> 2] = ~~b & 0xffffffff;
	} else {
		var view = new Uint32Array(this.unalignedarraybytestemp, 0, 1);
		view[0] = ~~b & 0xffffffff;
		var view2 = new Uint8Array(this.arraybytes, this.position, 4);
		var view3 = new Uint8Array(this.unalignedarraybytestemp, 0, 4);
		view2.set(view3);
	}
	this.position += 4;
	if (this.position > this.length) {
		this.length = this.position;
	}
};

away.utils.ByteArray.prototype.readUnsignedInteger = function() {
	if (this.position > this.length + 4) {
		throw "ByteArray out of bounds read. Position=" + this.position + ", Length=" + this.length;
	}
	var view = new Uint32Array(this.unalignedarraybytestemp, 0, 1);
	var view2 = new Uint8Array(this.arraybytes, this.position, 4);
	var view3 = new Uint8Array(this.unalignedarraybytestemp, 0, 4);
	view3.set(view2);
	this.position += 4;
	return view[0];
};

away.utils.ByteArray.prototype.readUnsignedInt = function() {
	if (this.position > this.length + 4) {
		throw "ByteArray out of bounds read. Position=" + this.position + ", Length=" + this.length;
	}
	if ((this.position & 3) == 0) {
		var view = new Uint32Array(this.arraybytes);
		var pa = this.position >> 2;
		this.position += 4;
		return view[pa];
	} else {
		var view = new Uint32Array(this.unalignedarraybytestemp, 0, 1);
		var view2 = new Uint8Array(this.arraybytes, this.position, 4);
		var view3 = new Uint8Array(this.unalignedarraybytestemp, 0, 4);
		view3.set(view2);
		this.position += 4;
		return view[0];
	}
};

away.utils.ByteArray.prototype.writeFloat = function(b) {
	this.ensureWriteableSpace(4);
	if ((this.position & 3) == 0) {
		var view = new Float32Array(this.arraybytes);
		view[this.position >> 2] = b;
	} else {
		var view = new Float32Array(this.unalignedarraybytestemp, 0, 1);
		view[0] = b;
		var view2 = new Uint8Array(this.arraybytes, this.position, 4);
		var view3 = new Uint8Array(this.unalignedarraybytestemp, 0, 4);
		view2.set(view3);
	}
	this.position += 4;
	if (this.position > this.length) {
		this.length = this.position;
	}
};

away.utils.ByteArray.prototype.readFloat = function(b) {
	if (this.position > this.length + 4) {
		throw "ByteArray out of bounds read. Positon=" + this.position + ", Length=" + this.length;
	}
	if ((this.position & 3) == 0) {
		var view = new Float32Array(this.arraybytes);
		var pa = this.position >> 2;
		this.position += 4;
		return view[pa];
	} else {
		var view = new Float32Array(this.unalignedarraybytestemp, 0, 1);
		var view2 = new Uint8Array(this.arraybytes, this.position, 4);
		var view3 = new Uint8Array(this.unalignedarraybytestemp, 0, 4);
		view3.set(view2);
		this.position += 4;
		return view[0];
	}
};

$inherit(away.utils.ByteArray, away.utils.ByteArrayBase);

away.utils.ByteArray.className = "away.utils.ByteArray";

away.utils.ByteArray.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('Int8Array');
	p.push('Uint32Array');
	p.push('Float32Array');
	p.push('Uint8Array');
	p.push('Uint16Array');
	return p;
};

away.utils.ByteArray.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.utils.ByteArray.injectionPoints = function(t) {
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

