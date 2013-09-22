/** Compiled by the Randori compiler v0.2.6.2 on Sun Sep 22 12:28:41 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.loaders == "undefined")
	away.loaders = {};
if (typeof away.loaders.parsers == "undefined")
	away.loaders.parsers = {};
if (typeof away.loaders.parsers.utils == "undefined")
	away.loaders.parsers.utils = {};

away.loaders.parsers.utils.ParserUtil = function() {
	
};

away.loaders.parsers.utils.ParserUtil.byteArrayToImage = function(data) {
	var byteStr = "";
	var bytes = new Uint8Array(data.arraybytes);
	var len = bytes.byteLength;
	for (var i = 0; i < len; i++) {
		byteStr += String.fromCharCode(bytes[i]);
	}
	var base64Image = window.btoa(byteStr);
	var str = "data:image\/png;base64," + base64Image;
	var img = document.createElement('img');
	img.src = str;
	return img;
};

away.loaders.parsers.utils.ParserUtil.toByteArray = function(data) {
	var b = new away.utils.ByteArray();
	b.setArrayBuffer(data);
	return b;
};

away.loaders.parsers.utils.ParserUtil.toString = function(data, length) {
	length = length || 0;
	if (typeof(data) === "string")
	
	var s = data;
	if (s["substr"] != null) {
		return s.substr(0, s.length);
	}
	if (data instanceof away.utils.ByteArray) {
		var ba = data;
		ba.position = 0;
		return ba.readUTFBytes(Math.min(ba.getBytesAvailable(), length));
	}
	return null;
};

away.loaders.parsers.utils.ParserUtil.className = "away.loaders.parsers.utils.ParserUtil";

away.loaders.parsers.utils.ParserUtil.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.utils.ByteArray');
	return p;
};

away.loaders.parsers.utils.ParserUtil.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.loaders.parsers.utils.ParserUtil.injectionPoints = function(t) {
	return [];
};
