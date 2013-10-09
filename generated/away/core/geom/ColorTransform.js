/** Compiled by the Randori compiler v0.2.5.2 on Wed Oct 09 20:30:39 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.core == "undefined")
	away.core = {};
if (typeof away.core.geom == "undefined")
	away.core.geom = {};

away.core.geom.ColorTransform = function(inRedMultiplier, inGreenMultiplier, inBlueMultiplier, inAlphaMultiplier, inRedOffset, inGreenOffset, inBlueOffset, inAlphaOffset) {
	this.redOffset = 0;
	this.redMultiplier = 0;
	this.blueMultiplier = 0;
	this.greenMultiplier = 0;
	this.alphaMultiplier = 0;
	this.blueOffset = 0;
	this.alphaOffset = 0;
	this.greenOffset = 0;
	inRedMultiplier = inRedMultiplier || 1.0;
	inGreenMultiplier = inGreenMultiplier || 1.0;
	inBlueMultiplier = inBlueMultiplier || 1.0;
	inAlphaMultiplier = inAlphaMultiplier || 1.0;
	inRedOffset = inRedOffset || 0.0;
	inGreenOffset = inGreenOffset || 0.0;
	inBlueOffset = inBlueOffset || 0.0;
	inAlphaOffset = inAlphaOffset || 0.0;
	this.redMultiplier = inRedMultiplier;
	this.greenMultiplier = inGreenMultiplier;
	this.blueMultiplier = inBlueMultiplier;
	this.alphaMultiplier = inAlphaMultiplier;
	this.redOffset = inRedOffset;
	this.greenOffset = inGreenOffset;
	this.blueOffset = inBlueOffset;
	this.alphaOffset = inAlphaOffset;
};

away.core.geom.ColorTransform.prototype.concat = function(second) {
	this.redMultiplier += second.redMultiplier;
	this.greenMultiplier += second.greenMultiplier;
	this.blueMultiplier += second.blueMultiplier;
	this.alphaMultiplier += second.alphaMultiplier;
};

away.core.geom.ColorTransform.prototype.get_color = function() {
	return ((this.redOffset << 16) | (this.greenOffset << 8) | this.blueOffset);
};

away.core.geom.ColorTransform.prototype.set_color = function(value) {
	var argb = away.utils.ColorUtils.float32ColorToARGB(value);
	this.redOffset = argb[1];
	this.greenOffset = argb[2];
	this.blueOffset = argb[3];
	this.redMultiplier = 0;
	this.greenMultiplier = 0;
	this.blueMultiplier = 0;
};

away.core.geom.ColorTransform.className = "away.core.geom.ColorTransform";

away.core.geom.ColorTransform.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.utils.ColorUtils');
	return p;
};

away.core.geom.ColorTransform.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.core.geom.ColorTransform.injectionPoints = function(t) {
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

