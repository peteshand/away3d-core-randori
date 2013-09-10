/** Compiled by the Randori compiler v0.2.6.2 on Tue Sep 10 22:28:14 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.materials == "undefined")
	away.materials = {};
if (typeof away.materials.methods == "undefined")
	away.materials.methods = {};

away.materials.methods.BasicDiffuseMethod = function() {
	this._diffuseColor = 0xffffff;
	this._useTexture = null;
	this._shadowRegister = null;
	this._alphaThreshold = 0;
	this._totalLightColorReg = null;
	this._diffuseA = 1;
	this._useAmbientTexture = null;
	this._diffuseB = 1;
	this._diffuseR = 1;
	this._diffuseG = 1;
	this._diffuseInputRegister = null;
	this._texture = null;
	this._isFirstLight = null;
	away.materials.methods.LightingMethodBase.call(this);
};

away.materials.methods.BasicDiffuseMethod.prototype.get_iUseAmbientTexture = function() {
	return this._useAmbientTexture;
};

away.materials.methods.BasicDiffuseMethod.prototype.set_iUseAmbientTexture = function(value) {
	if (this._useAmbientTexture == value)
		return;
	this._useAmbientTexture = value;
	this.iInvalidateShaderProgram();
};

away.materials.methods.BasicDiffuseMethod.prototype.iInitVO = function(vo) {
	vo.needsUV = this._useTexture;
	vo.needsNormals = vo.numLights > 0;
};

away.materials.methods.BasicDiffuseMethod.prototype.generateMip = function(stage3DProxy) {
	if (this._useTexture)
		this._texture.getTextureForStage3D(stage3DProxy);
};

away.materials.methods.BasicDiffuseMethod.prototype.get_diffuseAlpha = function() {
	return this._diffuseA;
};

away.materials.methods.BasicDiffuseMethod.prototype.set_diffuseAlpha = function(value) {
	this._diffuseA = value;
};

away.materials.methods.BasicDiffuseMethod.prototype.get_diffuseColor = function() {
	return this._diffuseColor;
};

away.materials.methods.BasicDiffuseMethod.prototype.set_diffuseColor = function(diffuseColor) {
	this._diffuseColor = diffuseColor;
	this.updateDiffuse();
};

away.materials.methods.BasicDiffuseMethod.prototype.get_texture = function() {
	return this._texture;
};

away.materials.methods.BasicDiffuseMethod.prototype.set_texture = function(value) {
	away.utils.Debug.throwPIR("BasicDiffuseMethod", "set texture", "TRICKY - Odd boolean assignment - needs testing");
	var b = (value != null);
	if (b != this._useTexture || (value && this._texture && (value.get_hasMipMaps() != this._texture.get_hasMipMaps() || value.get_format() != this._texture.get_format()))) {
		this.iInvalidateShaderProgram();
	}
	this._useTexture = b;
	this._texture = value;
};

away.materials.methods.BasicDiffuseMethod.prototype.get_alphaThreshold = function() {
	return this._alphaThreshold;
};

away.materials.methods.BasicDiffuseMethod.prototype.set_alphaThreshold = function(value) {
	if (value < 0)
		value = 0;
	else if (value > 1)
		value = 1;
	if (value == this._alphaThreshold)
		return;
	if (value == 0 || this._alphaThreshold == 0)
		this.iInvalidateShaderProgram();
	this._alphaThreshold = value;
};

away.materials.methods.BasicDiffuseMethod.prototype.dispose = function() {
	this._texture = null;
};

away.materials.methods.BasicDiffuseMethod.prototype.copyFrom = function(method) {
	var m = method;
	var diff = m;
	this.set_alphaThreshold(diff.get_alphaThreshold());
	this.set_texture(diff.get_texture());
	this.set_iUseAmbientTexture(diff.get_iUseAmbientTexture());
	this.set_diffuseAlpha(diff.get_diffuseAlpha());
	this.set_diffuseColor(diff.get_diffuseColor());
};

away.materials.methods.BasicDiffuseMethod.prototype.iCleanCompilationData = function() {
	away.materials.methods.LightingMethodBase.prototype.iCleanCompilationData.call(this);
	this._shadowRegister = null;
	this._totalLightColorReg = null;
	this._diffuseInputRegister = null;
};

away.materials.methods.BasicDiffuseMethod.prototype.iGetFragmentPreLightingCode = function(vo, regCache) {
	var code = "";
	this._isFirstLight = true;
	if (vo.numLights > 0) {
		this._totalLightColorReg = regCache.getFreeFragmentVectorTemp();
		regCache.addFragmentTempUsages(this._totalLightColorReg, 1);
	}
	return code;
};

away.materials.methods.BasicDiffuseMethod.prototype.iGetFragmentCodePerLight = function(vo, lightDirReg, lightColReg, regCache) {
	var code = "";
	var t;
	if (this._isFirstLight) {
		t = this._totalLightColorReg;
	} else {
		t = regCache.getFreeFragmentVectorTemp();
		regCache.addFragmentTempUsages(t, 1);
	}
	code += "dp3 " + t + ".x, " + lightDirReg.toString() + ", " + this._sharedRegisters.normalFragment.toString() + "\n" + "max " + t.toString() + ".w, " + t.toString() + ".x, " + this._sharedRegisters.commons.toString() + ".y\n";
	if (vo.useLightFallOff) {
		code += "mul " + t.toString() + ".w, " + t.toString() + ".w, " + lightDirReg.toString() + ".w\n";
	}
	if (this._iModulateMethod != null) {
		code += this._iModulateMethod(vo, t, regCache, this._sharedRegisters);
	}
	code += "mul " + t.toString() + ", " + t.toString() + ".w, " + lightColReg.toString() + "\n";
	if (!this._isFirstLight) {
		code += "add " + this._totalLightColorReg.toString() + ".xyz, " + this._totalLightColorReg.toString() + ", " + t.toString() + "\n";
		regCache.removeFragmentTempUsage(t);
	}
	this._isFirstLight = false;
	return code;
};

away.materials.methods.BasicDiffuseMethod.prototype.iGetFragmentCodePerProbe = function(vo, cubeMapReg, weightRegister, regCache) {
	var code = "";
	var t;
	if (this._isFirstLight) {
		t = this._totalLightColorReg;
	} else {
		t = regCache.getFreeFragmentVectorTemp();
		regCache.addFragmentTempUsages(t, 1);
	}
	code += "tex " + t.toString() + ", " + this._sharedRegisters.normalFragment.toString() + ", " + cubeMapReg.toString() + " <cube,linear,miplinear>\n" + "mul " + t.toString() + ".xyz, " + t.toString() + ".xyz, " + weightRegister + "\n";
	if (this._iModulateMethod != null) {
		code += this._iModulateMethod(vo, t, regCache, this._sharedRegisters);
	}
	if (!this._isFirstLight) {
		code += "add " + this._totalLightColorReg + ".xyz, " + this._totalLightColorReg + ", " + t.toString() + "\n";
		regCache.removeFragmentTempUsage(t);
	}
	this._isFirstLight = false;
	return code;
};

away.materials.methods.BasicDiffuseMethod.prototype.iGetFragmentPostLightingCode = function(vo, regCache, targetReg) {
	var code = "";
	var albedo;
	var cutOffReg;
	if (vo.numLights > 0) {
		if (this._shadowRegister)
			code += this.pApplyShadow(vo, regCache);
		albedo = regCache.getFreeFragmentVectorTemp();
		regCache.addFragmentTempUsages(albedo, 1);
	} else {
		albedo = targetReg;
	}
	if (this._useTexture) {
		this._diffuseInputRegister = regCache.getFreeTextureReg();
		vo.texturesIndex = this._diffuseInputRegister.get_index();
		code += this.pGetTex2DSampleCode(vo, albedo, this._diffuseInputRegister, this._texture);
		if (this._alphaThreshold > 0) {
			cutOffReg = regCache.getFreeFragmentConstant();
			vo.fragmentConstantsIndex = cutOffReg.get_index() * 4;
			code += "sub " + albedo.toString() + ".w, " + albedo.toString() + ".w, " + cutOffReg.toString() + ".x\n" + "kil " + albedo.toString() + ".w\n" + "add " + albedo.toString() + ".w, " + albedo.toString() + ".w, " + cutOffReg.toString() + ".x\n";
		}
	} else {
		this._diffuseInputRegister = regCache.getFreeFragmentConstant();
		vo.fragmentConstantsIndex = this._diffuseInputRegister.get_index() * 4;
		code += "mov " + albedo.toString() + ", " + this._diffuseInputRegister.toString() + "\n";
	}
	if (vo.numLights == 0)
		return code;
	code += "sat " + this._totalLightColorReg.toString() + ", " + this._totalLightColorReg.toString() + "\n";
	if (this._useAmbientTexture) {
		code += "mul " + albedo.toString() + ".xyz, " + albedo.toString() + ", " + this._totalLightColorReg.toString() + "\n" + "mul " + this._totalLightColorReg.toString() + ".xyz, " + targetReg.toString() + ", " + this._totalLightColorReg.toString() + "\n" + "sub " + targetReg.toString() + ".xyz, " + targetReg.toString() + ", " + this._totalLightColorReg.toString() + "\n" + "add " + targetReg.toString() + ".xyz, " + albedo.toString() + ", " + targetReg.toString() + "\n";
	} else {
		code += "add " + targetReg.toString() + ".xyz, " + this._totalLightColorReg.toString() + ", " + targetReg.toString() + "\n";
		if (this._useTexture) {
			code += "mul " + targetReg.toString() + ".xyz, " + albedo.toString() + ", " + targetReg.toString() + "\n" + "mov " + targetReg + ".w, " + albedo + ".w\n";
		} else {
			code += "mul " + targetReg.toString() + ".xyz, " + this._diffuseInputRegister.toString() + ", " + targetReg.toString() + "\n" + "mov " + targetReg.toString() + ".w, " + this._diffuseInputRegister.toString() + ".w\n";
		}
	}
	regCache.removeFragmentTempUsage(this._totalLightColorReg);
	regCache.removeFragmentTempUsage(albedo);
	return code;
};

away.materials.methods.BasicDiffuseMethod.prototype.pApplyShadow = function(vo, regCache) {
	return "mul " + this._totalLightColorReg.toString() + ".xyz, " + this._totalLightColorReg.toString() + ", " + this._shadowRegister.toString() + ".w\n";
};

away.materials.methods.BasicDiffuseMethod.prototype.iActivate = function(vo, stage3DProxy) {
	if (this._useTexture) {
		stage3DProxy._iContext3D.setSamplerStateAt(vo.texturesIndex, vo.repeatTextures ? away.display3D.Context3DWrapMode.REPEAT : away.display3D.Context3DWrapMode.CLAMP, vo.useSmoothTextures ? away.display3D.Context3DTextureFilter.LINEAR : away.display3D.Context3DTextureFilter.NEAREST, vo.useMipmapping ? away.display3D.Context3DMipFilter.MIPLINEAR : away.display3D.Context3DMipFilter.MIPNONE);
		stage3DProxy._iContext3D.setTextureAt(vo.texturesIndex, this._texture.getTextureForStage3D(stage3DProxy));
		if (this._alphaThreshold > 0)
			vo.fragmentData[vo.fragmentConstantsIndex] = this._alphaThreshold;
	} else {
		var index = vo.fragmentConstantsIndex;
		var data = vo.fragmentData;
		data[index] = this._diffuseR;
		data[index + 1] = this._diffuseG;
		data[index + 2] = this._diffuseB;
		data[index + 3] = this._diffuseA;
	}
};

away.materials.methods.BasicDiffuseMethod.prototype.updateDiffuse = function() {
	this._diffuseR = ((this._diffuseColor >> 16) & 0xff) / 0xff;
	this._diffuseG = ((this._diffuseColor >> 8) & 0xff) / 0xff;
	this._diffuseB = (this._diffuseColor & 0xff) / 0xff;
};

away.materials.methods.BasicDiffuseMethod.prototype.set_iShadowRegister = function(value) {
	this._shadowRegister = value;
};

$inherit(away.materials.methods.BasicDiffuseMethod, away.materials.methods.LightingMethodBase);

away.materials.methods.BasicDiffuseMethod.className = "away.materials.methods.BasicDiffuseMethod";

away.materials.methods.BasicDiffuseMethod.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.utils.Debug');
	p.push('away.display3D.Context3DMipFilter');
	p.push('away.display3D.Context3DWrapMode');
	p.push('away.display3D.Context3DTextureFilter');
	p.push('away.materials.methods.MethodVO');
	return p;
};

away.materials.methods.BasicDiffuseMethod.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.materials.methods.BasicDiffuseMethod.injectionPoints = function(t) {
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

