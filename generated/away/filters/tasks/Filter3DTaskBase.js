/** Compiled by the Randori compiler v0.2.6.2 on Sat Sep 21 16:02:35 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.filters == "undefined")
	away.filters = {};
if (typeof away.filters.tasks == "undefined")
	away.filters.tasks = {};

away.filters.tasks.Filter3DTaskBase = function(requireDepthRender) {
	this._textureScale = 0;
	this._textureHeight = -1;
	this._textureWidth = -1;
	this._program3DInvalid = true;
	this._scaledTextureHeight = -1;
	this._textureDimensionsInvalid = true;
	this._requireDepthRender = null;
	this._program3D = null;
	this._scaledTextureWidth = -1;
	this._mainInputTexture = null;
	this._target = null;
	this._requireDepthRender = requireDepthRender;
};

away.filters.tasks.Filter3DTaskBase.prototype.get_textureScale = function() {
	return this._textureScale;
};

away.filters.tasks.Filter3DTaskBase.prototype.set_textureScale = function(value) {
	if (this._textureScale == value) {
		return;
	}
	this._textureScale = value;
	this._scaledTextureWidth = this._textureWidth >> this._textureScale;
	this._scaledTextureHeight = this._textureHeight >> this._textureScale;
	this._textureDimensionsInvalid = true;
};

away.filters.tasks.Filter3DTaskBase.prototype.get_target = function() {
	return this._target;
};

away.filters.tasks.Filter3DTaskBase.prototype.set_target = function(value) {
	this._target = value;
};

away.filters.tasks.Filter3DTaskBase.prototype.get_textureWidth = function() {
	return this._textureWidth;
};

away.filters.tasks.Filter3DTaskBase.prototype.set_textureWidth = function(value) {
	if (this._textureWidth == value) {
		return;
	}
	this._textureWidth = value;
	this._scaledTextureWidth = this._textureWidth >> this._textureScale;
	this._textureDimensionsInvalid = true;
};

away.filters.tasks.Filter3DTaskBase.prototype.get_textureHeight = function() {
	return this._textureHeight;
};

away.filters.tasks.Filter3DTaskBase.prototype.set_textureHeight = function(value) {
	if (this._textureHeight == value) {
		return;
	}
	this._textureHeight = value;
	this._scaledTextureHeight = this._textureHeight >> this._textureScale;
	this._textureDimensionsInvalid = true;
};

away.filters.tasks.Filter3DTaskBase.prototype.getMainInputTexture = function(stage) {
	if (this._textureDimensionsInvalid) {
		this.pUpdateTextures(stage);
	}
	return this._mainInputTexture;
};

away.filters.tasks.Filter3DTaskBase.prototype.dispose = function() {
	if (this._mainInputTexture) {
		this._mainInputTexture.dispose();
	}
	if (this._program3D) {
		this._program3D.dispose();
	}
};

away.filters.tasks.Filter3DTaskBase.prototype.pInvalidateProgram3D = function() {
	this._program3DInvalid = true;
};

away.filters.tasks.Filter3DTaskBase.prototype.pUpdateProgram3D = function(stage) {
	if (this._program3D) {
		this._program3D.dispose();
	}
	this._program3D = stage._iContext3D.createProgram();
	var vertCompiler = new aglsl.AGLSLCompiler();
	var fragCompiler = new aglsl.AGLSLCompiler();
	var vertString = vertCompiler.compile(away.display3D.Context3DProgramType.VERTEX, this.pGetVertexCode());
	var fragString = fragCompiler.compile(away.display3D.Context3DProgramType.FRAGMENT, this.pGetFragmentCode());
	this._program3D.upload(vertString, fragString);
	this._program3DInvalid = false;
};

away.filters.tasks.Filter3DTaskBase.prototype.pGetVertexCode = function() {
	return "mov op, va0\n" + "mov v0, va1\n";
};

away.filters.tasks.Filter3DTaskBase.prototype.pGetFragmentCode = function() {
	throw new away.errors.AbstractMethodError(null, 0);
	return null;
};

away.filters.tasks.Filter3DTaskBase.prototype.pUpdateTextures = function(stage) {
	if (this._mainInputTexture) {
		this._mainInputTexture.dispose();
	}
	this._mainInputTexture = stage._iContext3D.createTexture(this._scaledTextureWidth, this._scaledTextureHeight, away.display3D.Context3DTextureFormat.BGRA, true, 0);
	this._textureDimensionsInvalid = false;
};

away.filters.tasks.Filter3DTaskBase.prototype.getProgram3D = function(stage3DProxy) {
	if (this._program3DInvalid) {
		this.pUpdateProgram3D(stage3DProxy);
	}
	return this._program3D;
};

away.filters.tasks.Filter3DTaskBase.prototype.activate = function(stage3DProxy, camera, depthTexture) {
};

away.filters.tasks.Filter3DTaskBase.prototype.deactivate = function(stage3DProxy) {
};

away.filters.tasks.Filter3DTaskBase.prototype.get_requireDepthRender = function() {
	return this._requireDepthRender;
};

away.filters.tasks.Filter3DTaskBase.className = "away.filters.tasks.Filter3DTaskBase";

away.filters.tasks.Filter3DTaskBase.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.errors.AbstractMethodError');
	p.push('away.display3D.Context3DProgramType');
	p.push('aglsl.AGLSLCompiler');
	p.push('away.display3D.Context3DTextureFormat');
	return p;
};

away.filters.tasks.Filter3DTaskBase.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.filters.tasks.Filter3DTaskBase.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'requireDepthRender', t:'Boolean'});
			break;
		default:
			p = [];
			break;
	}
	return p;
};

