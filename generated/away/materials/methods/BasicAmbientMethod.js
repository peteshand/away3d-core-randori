/** Compiled by the Randori compiler v0.2.6.2 on Sat Sep 28 11:54:51 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.materials == "undefined")
	away.materials = {};
if (typeof away.materials.methods == "undefined")
	away.materials.methods = {};

away.materials.methods.BasicAmbientMethod = function() {
	this._iLightAmbientB = 0;
	this._useTexture = false;
	this._ambientB = 0;
	this._ambientG = 0;
	this._ambientColor = 0xffffff;
	this._iLightAmbientG = 0;
	this._texture = null;
	this._ambientR = 0;
	this._ambient = 1;
	this._iLightAmbientR = 0;
	this._ambientInputRegister = null;
	away.materials.methods.ShadingMethodBase.call(this);
};

away.materials.methods.BasicAmbientMethod.prototype.iInitVO = function(vo) {
	vo.needsUV = this._useTexture;
};

away.materials.methods.BasicAmbientMethod.prototype.iInitConstants = function(vo) {
	vo.fragmentData[vo.fragmentConstantsIndex + 3] = 1;
};

away.materials.methods.BasicAmbientMethod.prototype.get_ambient = function() {
	return this._ambient;
};

away.materials.methods.BasicAmbientMethod.prototype.set_ambient = function(value) {
	this._ambient = value;
};

away.materials.methods.BasicAmbientMethod.prototype.get_ambientColor = function() {
	return this._ambientColor;
};

away.materials.methods.BasicAmbientMethod.prototype.set_ambientColor = function(value) {
	this._ambientColor = value;
};

away.materials.methods.BasicAmbientMethod.prototype.get_texture = function() {
	return this._texture;
};

away.materials.methods.BasicAmbientMethod.prototype.set_texture = function(value) {
	var b = (value != null);
	if (b != this._useTexture || (value && this._texture && (value.get_hasMipMaps() != this._texture.get_hasMipMaps() || value.get_format() != this._texture.get_format()))) {
		this.iInvalidateShaderProgram();
	}
	this._useTexture = b;
	this._texture = value;
};

away.materials.methods.BasicAmbientMethod.prototype.copyFrom = function(method) {
	var m = method;
	var b = m;
	var diff = b;
	this.set_ambient(diff.get_ambient());
	this.set_ambientColor(diff.get_ambientColor());
};

away.materials.methods.BasicAmbientMethod.prototype.iCleanCompilationData = function() {
	away.materials.methods.ShadingMethodBase.prototype.iCleanCompilationData.call(this);
	this._ambientInputRegister = null;
};

away.materials.methods.BasicAmbientMethod.prototype.iGetFragmentCode = function(vo, regCache, targetReg) {
	var code = "";
	if (this._useTexture) {
		this._ambientInputRegister = regCache.getFreeTextureReg();
		vo.texturesIndex = this._ambientInputRegister.get_index();
		code += this.pGetTex2DSampleCode(vo, targetReg, this._ambientInputRegister, this._texture) + "div " + targetReg.toString() + ".xyz, " + targetReg.toString() + ".xyz, " + targetReg.toString() + ".w\n";
	} else {
		this._ambientInputRegister = regCache.getFreeFragmentConstant();
		vo.fragmentConstantsIndex = this._ambientInputRegister.get_index() * 4;
		code += "mov " + targetReg.toString() + ", " + this._ambientInputRegister.toString() + "\n";
	}
	return code;
};

away.materials.methods.BasicAmbientMethod.prototype.iActivate = function(vo, stage3DProxy) {
	if (this._useTexture) {
		stage3DProxy._iContext3D.setSamplerStateAt(vo.texturesIndex, vo.repeatTextures ? away.display3D.Context3DWrapMode.REPEAT : away.display3D.Context3DWrapMode.CLAMP, vo.useSmoothTextures ? away.display3D.Context3DTextureFilter.LINEAR : away.display3D.Context3DTextureFilter.NEAREST, vo.useMipmapping ? away.display3D.Context3DMipFilter.MIPLINEAR : away.display3D.Context3DMipFilter.MIPNONE);
		stage3DProxy._iContext3D.setTextureAt(vo.texturesIndex, this._texture.getTextureForStage3D(stage3DProxy));
	}
};

away.materials.methods.BasicAmbientMethod.prototype.updateAmbient = function() {
	this._ambientR = ((this._ambientColor >> 16) & 0xff) / 0xff * this._ambient * this._iLightAmbientR;
	this._ambientG = ((this._ambientColor >> 8) & 0xff) / 0xff * this._ambient * this._iLightAmbientG;
	this._ambientB = (this.get_ambientColor() & 0xff) / 0xff * this._ambient * this._iLightAmbientB;
};

away.materials.methods.BasicAmbientMethod.prototype.iSetRenderState = function(vo, renderable, stage3DProxy, camera) {
	this.updateAmbient();
	if (!this._useTexture) {
		var index = vo.fragmentConstantsIndex;
		var data = vo.fragmentData;
		data[index] = this._ambientR;
		data[index + 1] = this._ambientG;
		data[index + 2] = this._ambientB;
	}
};

$inherit(away.materials.methods.BasicAmbientMethod, away.materials.methods.ShadingMethodBase);

away.materials.methods.BasicAmbientMethod.className = "away.materials.methods.BasicAmbientMethod";

away.materials.methods.BasicAmbientMethod.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.display3D.Context3DMipFilter');
	p.push('away.display3D.Context3DWrapMode');
	p.push('away.display3D.Context3DTextureFilter');
	p.push('away.materials.methods.MethodVO');
	return p;
};

away.materials.methods.BasicAmbientMethod.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.materials.methods.BasicAmbientMethod.injectionPoints = function(t) {
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

