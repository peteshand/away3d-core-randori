/** Compiled by the Randori compiler v0.2.6.2 on Wed Sep 25 08:08:27 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.materials == "undefined")
	away.materials = {};
if (typeof away.materials.methods == "undefined")
	away.materials.methods = {};

away.materials.methods.ShadingMethodBase = function() {
	this._sharedRegisters = null;
	this._passes = null;
	away.library.assets.NamedAssetBase.call(this, null);
};

away.materials.methods.ShadingMethodBase.prototype.iInitVO = function(vo) {
};

away.materials.methods.ShadingMethodBase.prototype.iInitConstants = function(vo) {
};

away.materials.methods.ShadingMethodBase.prototype.get_iSharedRegisters = function() {
	return this._sharedRegisters;
};

away.materials.methods.ShadingMethodBase.prototype.set_iSharedRegisters = function(value) {
	this._sharedRegisters = value;
};

away.materials.methods.ShadingMethodBase.prototype.setISharedRegisters = function(value) {
	this._sharedRegisters = value;
};

away.materials.methods.ShadingMethodBase.prototype.get_passes = function() {
	return this._passes;
};

away.materials.methods.ShadingMethodBase.prototype.dispose = function() {
};

away.materials.methods.ShadingMethodBase.prototype.iCreateMethodVO = function() {
	return new away.materials.methods.MethodVO();
};

away.materials.methods.ShadingMethodBase.prototype.iReset = function() {
	this.iCleanCompilationData();
};

away.materials.methods.ShadingMethodBase.prototype.iCleanCompilationData = function() {
};

away.materials.methods.ShadingMethodBase.prototype.iGetVertexCode = function(vo, regCache) {
	return "";
};

away.materials.methods.ShadingMethodBase.prototype.iActivate = function(vo, stage3DProxy) {
};

away.materials.methods.ShadingMethodBase.prototype.iSetRenderState = function(vo, renderable, stage3DProxy, camera) {
};

away.materials.methods.ShadingMethodBase.prototype.iDeactivate = function(vo, stage3DProxy) {
};

away.materials.methods.ShadingMethodBase.prototype.pGetTex2DSampleCode = function(vo, targetReg, inputReg, texture, uvReg, forceWrap) {
	uvReg = uvReg || null;
	forceWrap = forceWrap || null;
	var wrap = forceWrap || vo.repeatTextures ? "wrap" : "clamp";
	var filter;
	var format = this.getFormatStringForTexture(texture);
	var enableMipMaps = vo.useMipmapping && texture.get_hasMipMaps();
	if (vo.useSmoothTextures)
		filter = enableMipMaps ? "linear,miplinear" : "linear";
	else
		filter = enableMipMaps ? "nearest,mipnearest" : "nearest";
	if (uvReg == null) {
		uvReg = this._sharedRegisters.uvVarying;
	}
	return "tex " + targetReg.toString() + ", " + uvReg.toString() + ", " + inputReg.toString() + " <2d," + filter + "," + format + wrap + ">\n";
};

away.materials.methods.ShadingMethodBase.prototype.pGetTexCubeSampleCode = function(vo, targetReg, inputReg, texture, uvReg) {
	var filter;
	var format = this.getFormatStringForTexture(texture);
	var enableMipMaps = vo.useMipmapping && texture.get_hasMipMaps();
	if (vo.useSmoothTextures)
		filter = enableMipMaps ? "linear,miplinear" : "linear";
	else
		filter = enableMipMaps ? "nearest,mipnearest" : "nearest";
	return "tex " + targetReg.toString() + ", " + uvReg.toString() + ", " + inputReg.toString() + " <cube," + format + filter + ">\n";
};

away.materials.methods.ShadingMethodBase.prototype.getFormatStringForTexture = function(texture) {
	switch (texture.get_format()) {
		case away.display3D.Context3DTextureFormat.COMPRESSED:
			return "dxt1,";
			break;
		case "compressedAlpha":
			return "dxt5,";
			break;
		default:
			return "";
	}
};

away.materials.methods.ShadingMethodBase.prototype.iInvalidateShaderProgram = function() {
	this.dispatchEvent(new away.events.ShadingMethodEvent(away.events.ShadingMethodEvent.SHADER_INVALIDATED));
};

away.materials.methods.ShadingMethodBase.prototype.copyFrom = function(method) {
};

$inherit(away.materials.methods.ShadingMethodBase, away.library.assets.NamedAssetBase);

away.materials.methods.ShadingMethodBase.className = "away.materials.methods.ShadingMethodBase";

away.materials.methods.ShadingMethodBase.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.events.ShadingMethodEvent');
	p.push('away.display3D.Context3DTextureFormat');
	p.push('away.materials.methods.MethodVO');
	return p;
};

away.materials.methods.ShadingMethodBase.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.materials.methods.ShadingMethodBase.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 1:
			p = away.library.assets.NamedAssetBase.injectionPoints(t);
			break;
		case 2:
			p = away.library.assets.NamedAssetBase.injectionPoints(t);
			break;
		case 3:
			p = away.library.assets.NamedAssetBase.injectionPoints(t);
			break;
		default:
			p = [];
			break;
	}
	return p;
};

