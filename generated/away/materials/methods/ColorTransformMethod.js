/** Compiled by the Randori compiler v0.2.6.2 on Sun Sep 22 12:28:45 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.materials == "undefined")
	away.materials = {};
if (typeof away.materials.methods == "undefined")
	away.materials.methods = {};

away.materials.methods.ColorTransformMethod = function() {
	this._colorTransform = null;
	away.materials.methods.EffectMethodBase.call(this);
};

away.materials.methods.ColorTransformMethod.prototype.get_colorTransform = function() {
	return this._colorTransform;
};

away.materials.methods.ColorTransformMethod.prototype.set_colorTransform = function(value) {
	this._colorTransform = value;
};

away.materials.methods.ColorTransformMethod.prototype.iGetFragmentCode = function(vo, regCache, targetReg) {
	var code = "";
	var colorMultReg = regCache.getFreeFragmentConstant();
	var colorOffsReg = regCache.getFreeFragmentConstant();
	vo.fragmentConstantsIndex = colorMultReg.get_index() * 4;
	code += "mul " + targetReg.toString() + ", " + targetReg.toString() + ", " + colorMultReg.toString() + "\n" + "add " + targetReg.toString() + ", " + targetReg.toString() + ", " + colorOffsReg.toString() + "\n";
	return code;
};

away.materials.methods.ColorTransformMethod.prototype.iActivate = function(vo, stage3DProxy) {
	var inv = 1 / 0xff;
	var index = vo.fragmentConstantsIndex;
	var data = vo.fragmentData;
	data[index] = this._colorTransform.redMultiplier;
	data[index + 1] = this._colorTransform.greenMultiplier;
	data[index + 2] = this._colorTransform.blueMultiplier;
	data[index + 3] = this._colorTransform.alphaMultiplier;
	data[index + 4] = this._colorTransform.redOffset * inv;
	data[index + 5] = this._colorTransform.greenOffset * inv;
	data[index + 6] = this._colorTransform.blueOffset * inv;
	data[index + 7] = this._colorTransform.alphaOffset * inv;
};

$inherit(away.materials.methods.ColorTransformMethod, away.materials.methods.EffectMethodBase);

away.materials.methods.ColorTransformMethod.className = "away.materials.methods.ColorTransformMethod";

away.materials.methods.ColorTransformMethod.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.materials.methods.ColorTransformMethod.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.materials.methods.ColorTransformMethod.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 1:
			p = away.materials.methods.EffectMethodBase.injectionPoints(t);
			break;
		case 2:
			p = away.materials.methods.EffectMethodBase.injectionPoints(t);
			break;
		case 3:
			p = away.materials.methods.EffectMethodBase.injectionPoints(t);
			break;
		default:
			p = [];
			break;
	}
	return p;
};

