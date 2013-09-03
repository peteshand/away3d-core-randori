/** Compiled by the Randori compiler v0.2.6.2 on Mon Sep 02 23:32:26 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.materials == "undefined")
	away.materials = {};
if (typeof away.materials.methods == "undefined")
	away.materials.methods = {};

away.materials.methods.BasicNormalMethod = function() {
	this._useTexture = null;
	this._normalTextureRegister = null;
	this._texture = null;
	away.materials.methods.ShadingMethodBase.call(this);
};

away.materials.methods.BasicNormalMethod.prototype.iInitVO = function(vo) {
	if (this._texture) {
		vo.needsUV = true;
	} else {
		vo.needsUV = false;
	}
};

away.materials.methods.BasicNormalMethod.prototype.get_iTangentSpace = function() {
	return true;
};

away.materials.methods.BasicNormalMethod.prototype.get_iHasOutput = function() {
	return this._useTexture;
};

away.materials.methods.BasicNormalMethod.prototype.copyFrom = function(method) {
	var s = method;
	var bnm = method;
	this.set_normalMap(bnm.get_normalMap());
};

away.materials.methods.BasicNormalMethod.prototype.get_normalMap = function() {
	return this._texture;
};

away.materials.methods.BasicNormalMethod.prototype.set_normalMap = function(value) {
	var b = (value != null);
	if (b != this._useTexture || (value && this._texture && (value.get_hasMipMaps() != this._texture.get_hasMipMaps() || value.get_format() != this._texture.get_format()))) {
		this.iInvalidateShaderProgram();
	}
	this._useTexture = value;
	this._texture = value;
};

away.materials.methods.BasicNormalMethod.prototype.iCleanCompilationData = function() {
	away.materials.methods.ShadingMethodBase.prototype.iCleanCompilationData.call(this);
	this._normalTextureRegister = null;
};

away.materials.methods.BasicNormalMethod.prototype.dispose = function() {
	if (this._texture) {
		this._texture = null;
	}
};

away.materials.methods.BasicNormalMethod.prototype.iActivate = function(vo, stage3DProxy) {
	if (vo.texturesIndex >= 0) {
		stage3DProxy._iContext3D.setTextureAt(vo.texturesIndex, this._texture.getTextureForStage3D(stage3DProxy));
	}
};

away.materials.methods.BasicNormalMethod.prototype.iGetFragmentCode = function(vo, regCache, targetReg) {
	this._normalTextureRegister = regCache.getFreeTextureReg();
	vo.texturesIndex = this._normalTextureRegister.get_index();
	return this.pGetTex2DSampleCode(vo, targetReg, this._normalTextureRegister, this._texture) + "sub " + targetReg.toString() + ".xyz, " + targetReg.toString() + ".xyz, " + this._sharedRegisters.commons.toString() + ".xxx\t\n" + "nrm " + targetReg.toString() + ".xyz, " + targetReg.toString() + ".xyz\t\t\t\t\t\t\t\n";
};

$inherit(away.materials.methods.BasicNormalMethod, away.materials.methods.ShadingMethodBase);

away.materials.methods.BasicNormalMethod.className = "away.materials.methods.BasicNormalMethod";

away.materials.methods.BasicNormalMethod.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.materials.methods.MethodVO');
	return p;
};

away.materials.methods.BasicNormalMethod.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.materials.methods.BasicNormalMethod.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 1:
			p = away.materials.methods.ShadingMethodBase.injectionPoints(t);
			break;
		case 2:
			p = away.materials.methods.ShadingMethodBase.injectionPoints(t);
			break;
		case 3:
			p = away.materials.methods.ShadingMethodBase.injectionPoints(t);
			break;
		default:
			p = [];
			break;
	}
	return p;
};
