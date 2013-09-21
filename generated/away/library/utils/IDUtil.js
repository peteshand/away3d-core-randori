/** Compiled by the Randori compiler v0.2.6.2 on Sat Sep 21 16:02:03 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.library == "undefined")
	away.library = {};
if (typeof away.library.utils == "undefined")
	away.library.utils = {};

away.library.utils.IDUtil = function() {
	this.ALPHA_CHAR_CODES = [48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 65, 66, 67, 68, 69, 70];
	
};

away.library.utils.IDUtil.ALPHA_CHAR_CODES = [48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 65, 66, 67, 68, 69, 70];

away.library.utils.IDUtil.createUID = function() {
	var uid = [36];
	var index = 0;
	var i;
	var j;
	for (i = 0; i < 8; i++)
		uid[index++] = away.library.utils.IDUtil.ALPHA_CHAR_CODES[Math.floor(Math.random() * 16)];
	for (i = 0; i < 3; i++) {
		uid[index++] = 45;
		for (j = 0; j < 4; j++)
			uid[index++] = away.library.utils.IDUtil.ALPHA_CHAR_CODES[Math.floor(Math.random() * 16)];
	}
	uid[index++] = 45;
	var time = new Date().getTime();
	var timeString = ("0000000" + time.toString(16).toUpperCase()).substr(-8, 2147483647);
	for (i = 0; i < 8; i++)
		uid[index++] = timeString.charCodeAt(i);
	for (i = 0; i < 4; i++)
		uid[index++] = away.library.utils.IDUtil.ALPHA_CHAR_CODES[Math.floor(Math.random() * 16)];
	return String.fromCharCode.apply(null, uid);
};

away.library.utils.IDUtil.className = "away.library.utils.IDUtil";

away.library.utils.IDUtil.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.library.utils.IDUtil.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.library.utils.IDUtil.injectionPoints = function(t) {
	return [];
};
