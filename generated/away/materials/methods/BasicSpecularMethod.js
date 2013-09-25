/** Compiled by the Randori compiler v0.2.6.2 on Wed Sep 25 08:00:55 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.materials == "undefined")
	away.materials = {};
if (typeof away.materials.methods == "undefined")
	away.materials.methods = {};

away.materials.methods.BasicSpecularMethod = function() {
	this._useTexture = false;
	this._iSpecularG = 1;
	this._shadowRegister = null;
	this._specularDataRegister = null;
	this._specular = 1;
	this._iSpecularB = 1;
	this._specularTextureRegister = null;
	this._totalLightColorReg = null;
	this._specularColor = 0xffffff;
	this._specularTexData = null;
	this._gloss = 50;
	this._texture = null;
	this._isFirstLight = false;
	this._iSpecularR = 1;
	away.materials.methods.LightingMethodBase.call(this);
};

away.materials.methods.BasicSpecularMethod.prototype.iInitVO = function(vo) {
	vo.needsUV = this._useTexture;
	vo.needsNormals = vo.numLights > 0;
	vo.needsView = vo.numLights > 0;
};

away.materials.methods.BasicSpecularMethod.prototype.get_gloss = function() {
	return this._gloss;
};

away.materials.methods.BasicSpecularMethod.prototype.set_gloss = function(value) {
	this._gloss = value;
};

away.materials.methods.BasicSpecularMethod.prototype.get_specular = function() {
	return this._specular;
};

away.materials.methods.BasicSpecularMethod.prototype.set_specular = function(value) {
	if (value == this._specular)
		return;
	this._specular = value;
	this.updateSpecular();
};

away.materials.methods.BasicSpecularMethod.prototype.get_specularColor = function() {
	return this._specularColor;
};

away.materials.methods.BasicSpecularMethod.prototype.set_specularColor = function(value) {
	if (this._specularColor == value)
		return;
	if (this._specularColor == 0 || value == 0)
		this.iInvalidateShaderProgram();
	this._specularColor = value;
	this.updateSpecular();
};

away.materials.methods.BasicSpecularMethod.prototype.get_texture = function() {
	return this._texture;
};

away.materials.methods.BasicSpecularMethod.prototype.set_texture = function(value) {
	var b = (value != null);
	if (b != this._useTexture || (value && this._texture && (value.get_hasMipMaps() != this._texture.get_hasMipMaps() || value.get_format() != this._texture.get_format()))) {
		this.iInvalidateShaderProgram();
	}
	this._useTexture = b;
	this._texture = value;
};

away.materials.methods.BasicSpecularMethod.prototype.copyFrom = function(method) {
	var m = method;
	var bsm = method;
	var spec = bsm;
	this.set_texture(spec.get_texture());
	this.set_specular(spec.get_specular());
	this.set_specularColor(spec.get_specularColor());
	this.set_gloss(spec.get_gloss());
};

away.materials.methods.BasicSpecularMethod.prototype.iCleanCompilationData = function() {
	away.materials.methods.LightingMethodBase.prototype.iCleanCompilationData.call(this);
	this._shadowRegister = null;
	this._totalLightColorReg = null;
	this._specularTextureRegister = null;
	this._specularTexData = null;
	this._specularDataRegister = null;
};

away.materials.methods.BasicSpecularMethod.prototype.iGetFragmentPreLightingCode = function(vo, regCache) {
	var code = "";
	this._isFirstLight = true;
	if (vo.numLights > 0) {
		this._specularDataRegister = regCache.getFreeFragmentConstant();
		vo.fragmentConstantsIndex = this._specularDataRegister.get_index() * 4;
		if (this._useTexture) {
			this._specularTexData = regCache.getFreeFragmentVectorTemp();
			regCache.addFragmentTempUsages(this._specularTexData, 1);
			this._specularTextureRegister = regCache.getFreeTextureReg();
			vo.texturesIndex = this._specularTextureRegister.get_index();
			code = this.pGetTex2DSampleCode(vo, this._specularTexData, this._specularTextureRegister, this._texture);
		} else {
			this._specularTextureRegister = null;
		}
		this._totalLightColorReg = regCache.getFreeFragmentVectorTemp();
		regCache.addFragmentTempUsages(this._totalLightColorReg, 1);
	}
	return code;
};

away.materials.methods.BasicSpecularMethod.prototype.iGetFragmentCodePerLight = function(vo, lightDirReg, lightColReg, regCache) {
	var code = "";
	var t;
	if (this._isFirstLight) {
		t = this._totalLightColorReg;
	} else {
		t = regCache.getFreeFragmentVectorTemp();
		regCache.addFragmentTempUsages(t, 1);
	}
	var viewDirReg = this._sharedRegisters.viewDirFragment;
	var normalReg = this._sharedRegisters.normalFragment;
	code += "add " + t.toString() + ", " + lightDirReg.toString() + ", " + viewDirReg.toString() + "\n" + "nrm " + t.toString() + ".xyz, " + t.toString() + "\n" + "dp3 " + t.toString() + ".w, " + normalReg.toString() + ", " + t.toString() + "\n" + "sat " + t.toString() + ".w, " + t.toString() + ".w\n";
	if (this._useTexture) {
		code += "mul " + this._specularTexData.toString() + ".w, " + this._specularTexData.toString() + ".y, " + this._specularDataRegister.toString() + ".w\n" + "pow " + t + ".w, " + t + ".w, " + this._specularTexData.toString() + ".w\n";
	} else {
		code += "pow " + t.toString() + ".w, " + t.toString() + ".w, " + this._specularDataRegister.toString() + ".w\n";
	}
	if (vo.useLightFallOff) {
		code += "mul " + t.toString() + ".w, " + t.toString() + ".w, " + lightDirReg.toString() + ".w\n";
	}
	if (this._iModulateMethod != null) {
		if (this._iModulateMethodScope != null) {
			code += this._iModulateMethod.apply(this._iModulateMethodScope, [vo, t, regCache, this._sharedRegisters]);
		} else {
			throw "Modulated methods needs a scope";
		}
	}
	code += "mul " + t.toString() + ".xyz, " + lightColReg.toString() + ", " + t.toString() + ".w\n";
	if (!this._isFirstLight) {
		code += "add " + this._totalLightColorReg.toString() + ".xyz, " + this._totalLightColorReg.toString() + ", " + t.toString() + "\n";
		regCache.removeFragmentTempUsage(t);
	}
	this._isFirstLight = false;
	return code;
};

away.materials.methods.BasicSpecularMethod.prototype.iGetFragmentCodePerProbe = function(vo, cubeMapReg, weightRegister, regCache) {
	var code = "";
	var t;
	if (this._isFirstLight) {
		t = this._totalLightColorReg;
	} else {
		t = regCache.getFreeFragmentVectorTemp();
		regCache.addFragmentTempUsages(t, 1);
	}
	var normalReg = this._sharedRegisters.normalFragment;
	var viewDirReg = this._sharedRegisters.viewDirFragment;
	code += "dp3 " + t.toString() + ".w, " + normalReg.toString() + ", " + viewDirReg.toString() + "\n" + "add " + t.toString() + ".w, " + t.toString() + ".w, " + t.toString() + ".w\n" + "mul " + t.toString() + ", " + t.toString() + ".w, " + normalReg.toString() + "\n" + "sub " + t.toString() + ", " + t.toString() + ", " + viewDirReg.toString() + "\n" + "tex " + t.toString() + ", " + t.toString() + ", " + cubeMapReg.toString() + " <cube," + vo.useSmoothTextures ? "linear" : "nearest" + ",miplinear>\n" + "mul " + t.toString() + ".xyz, " + t.toString() + ", " + weightRegister.toString() + "\n";
	if (this._iModulateMethod != null) {
		if (this._iModulateMethodScope != null) {
			code += this._iModulateMethod.apply(this._iModulateMethodScope, [vo, t, regCache, this._sharedRegisters]);
		} else {
			throw "Modulated methods needs a scope";
		}
	}
	if (!this._isFirstLight) {
		code += "add " + this._totalLightColorReg.toString() + ".xyz, " + this._totalLightColorReg.toString() + ", " + t.toString() + "\n";
		regCache.removeFragmentTempUsage(t);
	}
	this._isFirstLight = false;
	return code;
};

away.materials.methods.BasicSpecularMethod.prototype.iGetFragmentPostLightingCode = function(vo, regCache, targetReg) {
	var code = "";
	if (vo.numLights == 0)
		return code;
	if (this._shadowRegister) {
		code += "mul " + this._totalLightColorReg.toString() + ".xyz, " + this._totalLightColorReg.toString() + ", " + this._shadowRegister.toString() + ".w\n";
	}
	if (this._useTexture) {
		code += "mul " + this._totalLightColorReg.toString() + ".xyz, " + this._totalLightColorReg.toString() + ", " + this._specularTexData.toString() + ".x\n";
		regCache.removeFragmentTempUsage(this._specularTexData);
	}
	code += "mul " + this._totalLightColorReg.toString() + ".xyz, " + this._totalLightColorReg.toString() + ", " + this._specularDataRegister.toString() + "\n" + "add " + targetReg.toString() + ".xyz, " + targetReg.toString() + ", " + this._totalLightColorReg.toString() + "\n";
	regCache.removeFragmentTempUsage(this._totalLightColorReg);
	return code;
};

away.materials.methods.BasicSpecularMethod.prototype.iActivate = function(vo, stage3DProxy) {
	if (vo.numLights == 0)
		return;
	if (this._useTexture) {
		stage3DProxy._iContext3D.setSamplerStateAt(vo.texturesIndex, vo.repeatTextures ? away.display3D.Context3DWrapMode.REPEAT : away.display3D.Context3DWrapMode.CLAMP, vo.useSmoothTextures ? away.display3D.Context3DTextureFilter.LINEAR : away.display3D.Context3DTextureFilter.NEAREST, vo.useMipmapping ? away.display3D.Context3DMipFilter.MIPLINEAR : away.display3D.Context3DMipFilter.MIPNONE);
		stage3DProxy._iContext3D.setTextureAt(vo.texturesIndex, this._texture.getTextureForStage3D(stage3DProxy));
	}
	var index = vo.fragmentConstantsIndex;
	var data = vo.fragmentData;
	data[index] = this._iSpecularR;
	data[index + 1] = this._iSpecularG;
	data[index + 2] = this._iSpecularB;
	data[index + 3] = this._gloss;
};

away.materials.methods.BasicSpecularMethod.prototype.updateSpecular = function() {
	this._iSpecularR = ((this._specularColor >> 16) & 0xff) / 0xff * this._specular;
	this._iSpecularG = ((this._specularColor >> 8) & 0xff) / 0xff * this._specular;
	this._iSpecularB = (this._specularColor & 0xff) / 0xff * this._specular;
};

away.materials.methods.BasicSpecularMethod.prototype.set_iShadowRegister = function(shadowReg) {
	this._shadowRegister = shadowReg;
};

away.materials.methods.BasicSpecularMethod.prototype.setIShadowRegister = function(shadowReg) {
	this._shadowRegister = shadowReg;
};

$inherit(away.materials.methods.BasicSpecularMethod, away.materials.methods.LightingMethodBase);

away.materials.methods.BasicSpecularMethod.className = "away.materials.methods.BasicSpecularMethod";

away.materials.methods.BasicSpecularMethod.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.display3D.Context3DMipFilter');
	p.push('away.display3D.Context3DWrapMode');
	p.push('away.display3D.Context3DTextureFilter');
	p.push('away.materials.methods.MethodVO');
	return p;
};

away.materials.methods.BasicSpecularMethod.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.materials.methods.BasicSpecularMethod.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 1:
			p = away.materials.methods.LightingMethodBase.injectionPoints(t);
			break;
		case 2:
			p = away.materials.methods.LightingMethodBase.injectionPoints(t);
			break;
		case 3:
			p = away.materials.methods.LightingMethodBase.injectionPoints(t);
			break;
		default:
			p = [];
			break;
	}
	return p;
};

