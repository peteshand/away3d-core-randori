/** Compiled by the Randori compiler v0.2.5.2 on Wed Oct 09 20:30:38 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.materials == "undefined")
	away.materials = {};
if (typeof away.materials.methods == "undefined")
	away.materials.methods = {};

away.materials.methods.EnvMapMethod = function(envMap, alpha) {
	this._mask = null;
	this._alpha = 0;
	this._cubeTexture = null;
	alpha = alpha || 1;
	away.materials.methods.EffectMethodBase.call(this);
	this._cubeTexture = envMap;
	this._alpha = alpha;
};

away.materials.methods.EnvMapMethod.prototype.get_mask = function() {
	return this._mask;
};

away.materials.methods.EnvMapMethod.prototype.set_mask = function(value) {
	if (value != this._mask || (value && this._mask && (value.get_hasMipMaps() != this._mask.get_hasMipMaps() || value.get_format() != this._mask.get_format()))) {
		this.iInvalidateShaderProgram();
	}
	this._mask = value;
};

away.materials.methods.EnvMapMethod.prototype.iInitVO = function(vo) {
	vo.needsNormals = true;
	vo.needsView = true;
	vo.needsUV = this._mask != null;
};

away.materials.methods.EnvMapMethod.prototype.get_envMap = function() {
	return this._cubeTexture;
};

away.materials.methods.EnvMapMethod.prototype.set_envMap = function(value) {
	this._cubeTexture = value;
};

away.materials.methods.EnvMapMethod.prototype.dispose = function() {
};

away.materials.methods.EnvMapMethod.prototype.get_alpha = function() {
	return this._alpha;
};

away.materials.methods.EnvMapMethod.prototype.set_alpha = function(value) {
	this._alpha = value;
};

away.materials.methods.EnvMapMethod.prototype.iActivate = function(vo, stage3DProxy) {
	var context = stage3DProxy._iContext3D;
	vo.fragmentData[vo.fragmentConstantsIndex] = this._alpha;
	context.setTextureAt(vo.texturesIndex, this._cubeTexture.getTextureForStage3D(stage3DProxy));
	if (this._mask) {
		context.setTextureAt(vo.texturesIndex + 1, this._mask.getTextureForStage3D(stage3DProxy));
	}
};

away.materials.methods.EnvMapMethod.prototype.iGetFragmentCode = function(vo, regCache, targetReg) {
	var dataRegister = regCache.getFreeFragmentConstant();
	var temp = regCache.getFreeFragmentVectorTemp();
	var code = "";
	var cubeMapReg = regCache.getFreeTextureReg();
	vo.texturesIndex = cubeMapReg.get_index();
	vo.fragmentConstantsIndex = dataRegister.get_index() * 4;
	regCache.addFragmentTempUsages(temp, 1);
	var temp2 = regCache.getFreeFragmentVectorTemp();
	code += "dp3 " + temp + ".w, " + this._sharedRegisters.viewDirFragment + ".xyz, " + this._sharedRegisters.normalFragment + ".xyz\t\t\n" + "add " + temp + ".w, " + temp + ".w, " + temp + ".w\t\t\t\t\t\t\t\t\t\t\t\n" + "mul " + temp + ".xyz, " + this._sharedRegisters.normalFragment + ".xyz, " + temp + ".w\t\t\t\t\t\t\n" + "sub " + temp + ".xyz, " + temp + ".xyz, " + this._sharedRegisters.viewDirFragment + ".xyz\t\t\t\t\t\n" + this.pGetTexCubeSampleCode(vo, temp, cubeMapReg, this._cubeTexture, temp) + "sub " + temp2 + ".w, " + temp + ".w, fc0.x\t\t\t\t\t\t\t\t\t\n" + "kil " + temp2 + ".w\n" + "sub " + temp + ", " + temp + ", " + targetReg + "\t\t\t\t\t\t\t\t\t\t\t\n";
	if (this._mask) {
		var maskReg = regCache.getFreeTextureReg();
		code += this.pGetTex2DSampleCode(vo, temp2, maskReg, this._mask, this._sharedRegisters.uvVarying) + "mul " + temp + ", " + temp2 + ", " + temp + "\n";
	}
	code += "mul " + temp + ", " + temp + ", " + dataRegister + ".x\t\t\t\t\t\t\t\t\t\t\n" + "add " + targetReg + ", " + targetReg + ", " + temp + "\t\t\t\t\t\t\t\t\t\t\n";
	regCache.removeFragmentTempUsage(temp);
	return code;
};

$inherit(away.materials.methods.EnvMapMethod, away.materials.methods.EffectMethodBase);

away.materials.methods.EnvMapMethod.className = "away.materials.methods.EnvMapMethod";

away.materials.methods.EnvMapMethod.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.materials.compilation.ShaderRegisterData');
	p.push('away.materials.methods.MethodVO');
	return p;
};

away.materials.methods.EnvMapMethod.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.materials.methods.EnvMapMethod.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'envMap', t:'away.textures.CubeTextureBase'});
			p.push({n:'alpha', t:'Number'});
			break;
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

