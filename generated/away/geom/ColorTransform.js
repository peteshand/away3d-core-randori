/** Compiled by the Randori compiler v0.2.6.2 on Mon Sep 02 23:32:28 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.geom == "undefined")
	away.geom = {};

away.geom.ColorTransform = function(inRedMultiplier, inGreenMultiplier, inBlueMultiplier, inAlphaMultiplier, inRedOffset, inGreenOffset, inBlueOffset, inAlphaOffset) {
	this.redOffset = 0;
	this.redMultiplier = 0;
	this.blueMultiplier = 0;
	this.greenMultiplier = 0;
	this.alphaMultiplier = 0;
	this.blueOffset = 0;
	this.alphaOffset = 0;
	this.greenOffset = 0;
	this.redMultiplier = inRedMultiplier;
	this.greenMultiplier = inGreenMultiplier;
	this.blueMultiplier = inBlueMultiplier;
	this.alphaMultiplier = inAlphaMultiplier;
	this.redOffset = inRedOffset;
	this.greenOffset = inGreenOffset;
	this.blueOffset = inBlueOffset;
	this.alphaOffset = inAlphaOffset;
};

away.geom.ColorTransform.prototype.concat = function(second) {
	this.redMultiplier += second.redMultiplier;
	this.greenMultiplier += second.greenMultiplier;
	this.blueMultiplier += second.blueMultiplier;
	this.alphaMultiplier += second.alphaMultiplier;
};

away.geom.ColorTransform.prototype.get_color = function() {
	return ((this.redOffset << 16) | (this.greenOffset << 8) | this.blueOffset);
};

away.geom.ColorTransform.prototype.set_color = function(value) {
	var argb = away.utils.ColorUtils.float32ColorToARGB(value);
	this.redOffset = argb[1];
	this.greenOffset = argb[2];
	this.blueOffset = argb[3];
	this.redMultiplier = 0;
	this.greenMultiplier = 0;
	this.blueMultiplier = 0;
};

away.geom.ColorTransform.className = "away.geom.ColorTransform";

away.geom.ColorTransform.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.utils.ColorUtils');
	return p;
};

away.geom.ColorTransform.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.geom.ColorTransform.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'inRedMultiplier', t:'Number'});
			p.push({n:'inGreenMultiplier', t:'Number'});
			p.push({n:'inBlueMultiplier', t:'Number'});
			p.push({n:'inAlphaMultiplier', t:'Number'});
			p.push({n:'inRedOffset', t:'Number'});
			p.push({n:'inGreenOffset', t:'Number'});
			p.push({n:'inBlueOffset', t:'Number'});
			p.push({n:'inAlphaOffset', t:'Number'});
			break;
		default:
			p = [];
			break;
	}
	return p;
};

