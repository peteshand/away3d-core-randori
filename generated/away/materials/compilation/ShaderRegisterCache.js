/** Compiled by the Randori compiler v0.2.6.2 on Mon Sep 02 23:32:29 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.materials == "undefined")
	away.materials = {};
if (typeof away.materials.compilation == "undefined")
	away.materials.compilation = {};

away.materials.compilation.ShaderRegisterCache = function(profile) {
	this._vertexConstantOffset = 0;
	this._numUsedTextures = 0;
	this._varyingCache = null;
	this._fragmentConstantOffset = 0;
	this._vertexOutputRegister = null;
	this._vertexTempCache = null;
	this._varyingsOffset = 0;
	this._numUsedVertexConstants = 0;
	this._vertexAttributesOffset = 0;
	this._fragmentTempCache = null;
	this._numUsedFragmentConstants = 0;
	this._fragmentOutputRegister = null;
	this._profile = null;
	this._fragmentConstantsCache = null;
	this._numUsedStreams = 0;
	this._textureCache = null;
	this._numUsedVaryings = 0;
	this._vertexAttributesCache = null;
	this._vertexConstantsCache = null;
	this._profile = profile;
};

away.materials.compilation.ShaderRegisterCache.prototype.reset = function() {
	this._fragmentTempCache = new away.materials.compilation.RegisterPool("ft", 8, false);
	this._vertexTempCache = new away.materials.compilation.RegisterPool("vt", 8, false);
	this._varyingCache = new away.materials.compilation.RegisterPool("v", 8, true);
	this._textureCache = new away.materials.compilation.RegisterPool("fs", 8, true);
	this._vertexAttributesCache = new away.materials.compilation.RegisterPool("va", 8, true);
	this._fragmentConstantsCache = new away.materials.compilation.RegisterPool("fc", 28, true);
	this._vertexConstantsCache = new away.materials.compilation.RegisterPool("vc", 128, true);
	this._fragmentOutputRegister = new away.materials.compilation.ShaderRegisterElement("oc", -1, -1);
	this._vertexOutputRegister = new away.materials.compilation.ShaderRegisterElement("op", -1, -1);
	this._numUsedVertexConstants = 0;
	this._numUsedStreams = 0;
	this._numUsedTextures = 0;
	this._numUsedVaryings = 0;
	this._numUsedFragmentConstants = 0;
	var i;
	for (i = 0; i < this._vertexAttributesOffset; ++i)
		this.getFreeVertexAttribute();
	for (i = 0; i < this._vertexConstantOffset; ++i)
		this.getFreeVertexConstant();
	for (i = 0; i < this._varyingsOffset; ++i)
		this.getFreeVarying();
	for (i = 0; i < this._fragmentConstantOffset; ++i)
		this.getFreeFragmentConstant();
};

away.materials.compilation.ShaderRegisterCache.prototype.dispose = function() {
	this._fragmentTempCache.dispose();
	this._vertexTempCache.dispose();
	this._varyingCache.dispose();
	this._fragmentConstantsCache.dispose();
	this._vertexAttributesCache.dispose();
	this._fragmentTempCache = null;
	this._vertexTempCache = null;
	this._varyingCache = null;
	this._fragmentConstantsCache = null;
	this._vertexAttributesCache = null;
	this._fragmentOutputRegister = null;
	this._vertexOutputRegister = null;
};

away.materials.compilation.ShaderRegisterCache.prototype.addFragmentTempUsages = function(register, usageCount) {
	this._fragmentTempCache.addUsage(register, usageCount);
};

away.materials.compilation.ShaderRegisterCache.prototype.removeFragmentTempUsage = function(register) {
	this._fragmentTempCache.removeUsage(register);
};

away.materials.compilation.ShaderRegisterCache.prototype.addVertexTempUsages = function(register, usageCount) {
	this._vertexTempCache.addUsage(register, usageCount);
};

away.materials.compilation.ShaderRegisterCache.prototype.removeVertexTempUsage = function(register) {
	this._vertexTempCache.removeUsage(register);
};

away.materials.compilation.ShaderRegisterCache.prototype.getFreeFragmentVectorTemp = function() {
	return this._fragmentTempCache.requestFreeVectorReg();
};

away.materials.compilation.ShaderRegisterCache.prototype.getFreeFragmentSingleTemp = function() {
	return this._fragmentTempCache.requestFreeRegComponent();
};

away.materials.compilation.ShaderRegisterCache.prototype.getFreeVarying = function() {
	++this._numUsedVaryings;
	return this._varyingCache.requestFreeVectorReg();
};

away.materials.compilation.ShaderRegisterCache.prototype.getFreeFragmentConstant = function() {
	++this._numUsedFragmentConstants;
	return this._fragmentConstantsCache.requestFreeVectorReg();
};

away.materials.compilation.ShaderRegisterCache.prototype.getFreeVertexConstant = function() {
	++this._numUsedVertexConstants;
	return this._vertexConstantsCache.requestFreeVectorReg();
};

away.materials.compilation.ShaderRegisterCache.prototype.getFreeVertexVectorTemp = function() {
	return this._vertexTempCache.requestFreeVectorReg();
};

away.materials.compilation.ShaderRegisterCache.prototype.getFreeVertexSingleTemp = function() {
	return this._vertexTempCache.requestFreeRegComponent();
};

away.materials.compilation.ShaderRegisterCache.prototype.getFreeVertexAttribute = function() {
	++this._numUsedStreams;
	return this._vertexAttributesCache.requestFreeVectorReg();
};

away.materials.compilation.ShaderRegisterCache.prototype.getFreeTextureReg = function() {
	++this._numUsedTextures;
	return this._textureCache.requestFreeVectorReg();
};

away.materials.compilation.ShaderRegisterCache.prototype.get_vertexConstantOffset = function() {
	return this._vertexConstantOffset;
};

away.materials.compilation.ShaderRegisterCache.prototype.set_vertexConstantOffset = function(vertexConstantOffset) {
	this._vertexConstantOffset = vertexConstantOffset;
};

away.materials.compilation.ShaderRegisterCache.prototype.get_vertexAttributesOffset = function() {
	return this._vertexAttributesOffset;
};

away.materials.compilation.ShaderRegisterCache.prototype.set_vertexAttributesOffset = function(value) {
	this._vertexAttributesOffset = value;
};

away.materials.compilation.ShaderRegisterCache.prototype.get_varyingsOffset = function() {
	return this._varyingsOffset;
};

away.materials.compilation.ShaderRegisterCache.prototype.set_varyingsOffset = function(value) {
	this._varyingsOffset = value;
};

away.materials.compilation.ShaderRegisterCache.prototype.get_fragmentConstantOffset = function() {
	return this._fragmentConstantOffset;
};

away.materials.compilation.ShaderRegisterCache.prototype.set_fragmentConstantOffset = function(value) {
	this._fragmentConstantOffset = value;
};

away.materials.compilation.ShaderRegisterCache.prototype.get_fragmentOutputRegister = function() {
	return this._fragmentOutputRegister;
};

away.materials.compilation.ShaderRegisterCache.prototype.get_numUsedVertexConstants = function() {
	return this._numUsedVertexConstants;
};

away.materials.compilation.ShaderRegisterCache.prototype.get_numUsedFragmentConstants = function() {
	return this._numUsedFragmentConstants;
};

away.materials.compilation.ShaderRegisterCache.prototype.get_numUsedStreams = function() {
	return this._numUsedStreams;
};

away.materials.compilation.ShaderRegisterCache.prototype.get_numUsedTextures = function() {
	return this._numUsedTextures;
};

away.materials.compilation.ShaderRegisterCache.prototype.get_numUsedVaryings = function() {
	return this._numUsedVaryings;
};

away.materials.compilation.ShaderRegisterCache.className = "away.materials.compilation.ShaderRegisterCache";

away.materials.compilation.ShaderRegisterCache.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.materials.compilation.RegisterPool');
	p.push('away.materials.compilation.ShaderRegisterElement');
	return p;
};

away.materials.compilation.ShaderRegisterCache.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.materials.compilation.ShaderRegisterCache.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'profile', t:'String'});
			break;
		default:
			p = [];
			break;
	}
	return p;
};

