/** Compiled by the Randori compiler v0.2.6.2 on Wed Sep 04 21:18:34 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.utils == "undefined")
	away.utils = {};

away.utils.TextureUtils = function() {
	this.MAX_SIZE = 2048;
	
};

away.utils.TextureUtils.MAX_SIZE = 2048;

away.utils.TextureUtils.isBitmapDataValid = function(bitmapData) {
	if (bitmapData == null) {
		return true;
	}
	return away.utils.TextureUtils.isDimensionValid(bitmapData.get_width()) && away.utils.TextureUtils.isDimensionValid(bitmapData.get_height());
};

away.utils.TextureUtils.isHTMLImageElementValid = function(image) {
	if (image == null) {
		return true;
	}
	return away.utils.TextureUtils.isDimensionValid(image.width) && away.utils.TextureUtils.isDimensionValid(image.height);
};

away.utils.TextureUtils.isDimensionValid = function(d) {
	return d >= 1 && d <= away.utils.TextureUtils.MAX_SIZE && away.utils.TextureUtils.isPowerOfTwo(d);
};

away.utils.TextureUtils.isPowerOfTwo = function(value) {
	return value ? ((value & -value) == value) : false;
};

away.utils.TextureUtils.getBestPowerOf2 = function(value) {
	var p = 1;
	while (p < value)
		p <<= 1;
	if (p > away.utils.TextureUtils.MAX_SIZE)
		p = away.utils.TextureUtils.MAX_SIZE;
	return p;
};

away.utils.TextureUtils.className = "away.utils.TextureUtils";

away.utils.TextureUtils.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.display.BitmapData');
	return p;
};

away.utils.TextureUtils.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.utils.TextureUtils.injectionPoints = function(t) {
	return [];
};
