/** Compiled by the Randori compiler v0.2.5.2 on Wed Oct 09 20:30:36 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.utils == "undefined")
	away.utils = {};

away.utils.ColorUtils = function() {
	
};

away.utils.ColorUtils.float32ColorToARGB = function(float32Color) {
	var a = (float32Color & 0xff000000) >>> 24;
	var r = (float32Color & 0xff0000) >>> 16;
	var g = (float32Color & 0xff00) >>> 8;
	var b = float32Color & 0xff;
	var result = [a, r, g, b];
	return result;
};

away.utils.ColorUtils.componentToHex = function(c) {
	var hex = c.toString(16);
	return hex.length == 1 ? "0" + hex : hex;
};

away.utils.ColorUtils.RGBToHexString = function(argb) {
	return "#" + away.utils.ColorUtils.componentToHex(argb[1]) + away.utils.ColorUtils.componentToHex(argb[2]) + away.utils.ColorUtils.componentToHex(argb[3]);
};

away.utils.ColorUtils.ARGBToHexString = function(argb) {
	return "#" + away.utils.ColorUtils.componentToHex(argb[0]) + away.utils.ColorUtils.componentToHex(argb[1]) + away.utils.ColorUtils.componentToHex(argb[2]) + away.utils.ColorUtils.componentToHex(argb[3]);
};

away.utils.ColorUtils.className = "away.utils.ColorUtils";

away.utils.ColorUtils.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.utils.ColorUtils.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.utils.ColorUtils.injectionPoints = function(t) {
	return [];
};
