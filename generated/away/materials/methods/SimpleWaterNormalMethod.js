/** Compiled by the Randori compiler v0.2.6.2 on Sun Sep 22 12:28:44 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.materials == "undefined")
	away.materials = {};
if (typeof away.materials.methods == "undefined")
	away.materials.methods = {};

away.materials.methods.SimpleWaterNormalMethod = function(waveMap1, waveMap2) {
	this._normalTextureRegister2 = null;
	this._water1OffsetY = 0;
	this._useSecondNormalMap = false;
	this._water1OffsetX = 0;
	this._water2OffsetX = 0;
	this._water2OffsetY = 0;
	this._texture2 = null;
	away.materials.methods.BasicNormalMethod.call(this);
	this.set_normalMap(waveMap1);
	this.set_secondaryNormalMap(waveMap2);
};

away.materials.methods.SimpleWaterNormalMethod.prototype.iInitConstants = function(vo) {
	var index = vo.fragmentConstantsIndex;
	vo.fragmentData[index] = .5;
	vo.fragmentData[index + 1] = 0;
	vo.fragmentData[index + 2] = 0;
	vo.fragmentData[index + 3] = 1;
};

away.materials.methods.SimpleWaterNormalMethod.prototype.iInitVO = function(vo) {
	away.materials.methods.BasicNormalMethod.prototype.iInitVO.call(this,vo);
	this._useSecondNormalMap = this.get_normalMap() != this.get_secondaryNormalMap();
};

away.materials.methods.SimpleWaterNormalMethod.prototype.get_water1OffsetX = function() {
	return this._water1OffsetX;
};

away.materials.methods.SimpleWaterNormalMethod.prototype.set_water1OffsetX = function(value) {
	this._water1OffsetX = value;
};

away.materials.methods.SimpleWaterNormalMethod.prototype.get_water1OffsetY = function() {
	return this._water1OffsetY;
};

away.materials.methods.SimpleWaterNormalMethod.prototype.set_water1OffsetY = function(value) {
	this._water1OffsetY = value;
};

away.materials.methods.SimpleWaterNormalMethod.prototype.get_water2OffsetX = function() {
	return this._water2OffsetX;
};

away.materials.methods.SimpleWaterNormalMethod.prototype.set_water2OffsetX = function(value) {
	this._water2OffsetX = value;
};

away.materials.methods.SimpleWaterNormalMethod.prototype.get_water2OffsetY = function() {
	return this._water2OffsetY;
};

away.materials.methods.SimpleWaterNormalMethod.prototype.set_water2OffsetY = function(value) {
	this._water2OffsetY = value;
};

away.materials.methods.SimpleWaterNormalMethod.prototype.set_normalMap = function(value) {
	if (!value) {
		return;
	}
	this.setNormalMap(value);
};

away.materials.methods.SimpleWaterNormalMethod.prototype.get_secondaryNormalMap = function() {
	return this._texture2;
};

away.materials.methods.SimpleWaterNormalMethod.prototype.set_secondaryNormalMap = function(value) {
	this._texture2 = value;
};

away.materials.methods.SimpleWaterNormalMethod.prototype.iCleanCompilationData = function() {
	away.materials.methods.BasicNormalMethod.prototype.iCleanCompilationData.call(this);
	this._normalTextureRegister2 = null;
};

away.materials.methods.SimpleWaterNormalMethod.prototype.dispose = function() {
	away.materials.methods.BasicNormalMethod.prototype.dispose.call(this);
	this._texture2 = null;
};

away.materials.methods.SimpleWaterNormalMethod.prototype.iActivate = function(vo, stage3DProxy) {
	away.materials.methods.BasicNormalMethod.prototype.iActivate.call(this,vo, stage3DProxy);
	var data = vo.fragmentData;
	var index = vo.fragmentConstantsIndex;
	data[index + 4] = this._water1OffsetX;
	data[index + 5] = this._water1OffsetY;
	data[index + 6] = this._water2OffsetX;
	data[index + 7] = this._water2OffsetY;
	if (this._useSecondNormalMap)
		stage3DProxy._iContext3D.setTextureAt(vo.texturesIndex + 1, this._texture2.getTextureForStage3D(stage3DProxy));
};

away.materials.methods.SimpleWaterNormalMethod.prototype.getFragmentCode = function(vo, regCache, targetReg) {
	var temp = regCache.getFreeFragmentVectorTemp();
	var dataReg = regCache.getFreeFragmentConstant();
	var dataReg2 = regCache.getFreeFragmentConstant();
	this._pNormalTextureRegister = regCache.getFreeTextureReg();
	this._normalTextureRegister2 = this._useSecondNormalMap ? regCache.getFreeTextureReg() : this._pNormalTextureRegister;
	vo.texturesIndex = this._pNormalTextureRegister.get_index();
	vo.fragmentConstantsIndex = dataReg.get_index() * 4;
	return "add " + temp + ", " + this._sharedRegisters.uvVarying + ", " + dataReg2 + ".xyxy\n" + this.pGetTex2DSampleCode(vo, targetReg, this._pNormalTextureRegister, this.get_normalMap(), temp) + "add " + temp + ", " + this._sharedRegisters.uvVarying + ", " + dataReg2 + ".zwzw\n" + this.pGetTex2DSampleCode(vo, temp, this._normalTextureRegister2, this._texture2, temp) + "add " + targetReg + ", " + targetReg + ", " + temp + "\t\t\n" + "mul " + targetReg + ", " + targetReg + ", " + dataReg + ".x\t\n" + "sub " + targetReg + ".xyz, " + targetReg + ".xyz, " + this._sharedRegisters.commons + ".xxx\t\n" + "nrm " + targetReg + ".xyz, " + targetReg + ".xyz\t\t\t\t\t\t\t\n";
};

$inherit(away.materials.methods.SimpleWaterNormalMethod, away.materials.methods.BasicNormalMethod);

away.materials.methods.SimpleWaterNormalMethod.className = "away.materials.methods.SimpleWaterNormalMethod";

away.materials.methods.SimpleWaterNormalMethod.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.materials.methods.SimpleWaterNormalMethod.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.materials.methods.SimpleWaterNormalMethod.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'waveMap1', t:'away.textures.Texture2DBase'});
			p.push({n:'waveMap2', t:'away.textures.Texture2DBase'});
			break;
		case 1:
			p = away.materials.methods.BasicNormalMethod.injectionPoints(t);
			break;
		case 2:
			p = away.materials.methods.BasicNormalMethod.injectionPoints(t);
			break;
		case 3:
			p = away.materials.methods.BasicNormalMethod.injectionPoints(t);
			break;
		default:
			p = [];
			break;
	}
	return p;
};

