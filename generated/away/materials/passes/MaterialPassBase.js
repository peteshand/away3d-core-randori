/** Compiled by the Randori compiler v0.2.6.2 on Wed Sep 25 20:35:40 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.materials == "undefined")
	away.materials = {};
if (typeof away.materials.passes == "undefined")
	away.materials.passes = {};

away.materials.passes.MaterialPassBase = function(renderToTexture) {
	this._iProgram3Ds = away.utils.VectorInit.AnyClass(away.display3D.Program3D, 8);
	this._pSmooth = true;
	this._pMaterial = null;
	this._pRepeat = false;
	this._animationSet = null;
	this._pAlphaPremultiplied = false;
	this._pMipmap = true;
	this._oldRect = null;
	this._pBothSides = false;
	this._pUVTarget = null;
	this._pNumUsedVaryings = 0;
	this._pLightPicker = null;
	this._pAnimationTargetRegisters = away.utils.VectorInit.Str(0, "");
	this._oldSurface = 0;
	this._pAnimatableAttributes = away.utils.VectorInit.Str(0, "");
	this._pNumUsedFragmentConstants = 0;
	this._previousUsedTexs = [0, 0, 0, 0, 0, 0, 0, 0];
	this._blendFactorDest = away.display3D.Context3DBlendFactor.ZERO;
	this._pNeedUVAnimation = false;
	this._previousUsedStreams = [0, 0, 0, 0, 0, 0, 0, 0];
	this._pNumUsedStreams = 0;
	this._defaultCulling = away.display3D.Context3DTriangleFace.BACK;
	this._pNeedFragmentAnimation = false;
	this._pNumUsedTextures = 0;
	this._context3Ds = away.utils.VectorInit.AnyClass(away.display3D.Context3D, 8);
	this._pUVSource = null;
	this._blendFactorSource = away.display3D.Context3DBlendFactor.ONE;
	this._writeDepth = true;
	this._pNumUsedVertexConstants = 0;
	this._renderToTexture = false;
	this._depthCompareMode = away.display3D.Context3DCompareMode.LESS_EQUAL;
	this._oldDepthStencil = false;
	this._pShadedTarget = "ft0";
	this._oldTarget = null;
	this._pEnableBlending = false;
	this._iProgram3Dids = [-1, -1, -1, -1, -1, -1, -1, -1];
	away.events.EventDispatcher.call(this);
	this._pAnimatableAttributes.push("va0");
	this._pAnimationTargetRegisters.push("vt0");
	this._renderToTexture = renderToTexture;
	this._pNumUsedStreams = 1;
	this._pNumUsedVertexConstants = 5;
};

away.materials.passes.MaterialPassBase._previousUsedStreams = [0, 0, 0, 0, 0, 0, 0, 0];

away.materials.passes.MaterialPassBase._previousUsedTexs = [0, 0, 0, 0, 0, 0, 0, 0];

away.materials.passes.MaterialPassBase.prototype.get_material = function() {
	return this._pMaterial;
};

away.materials.passes.MaterialPassBase.prototype.set_material = function(value) {
	this._pMaterial = value;
};

away.materials.passes.MaterialPassBase.prototype.get_writeDepth = function() {
	return this._writeDepth;
};

away.materials.passes.MaterialPassBase.prototype.set_writeDepth = function(value) {
	this._writeDepth = value;
};

away.materials.passes.MaterialPassBase.prototype.get_mipmap = function() {
	return this._pMipmap;
};

away.materials.passes.MaterialPassBase.prototype.set_mipmap = function(value) {
	this.setMipMap(value);
};

away.materials.passes.MaterialPassBase.prototype.setMipMap = function(value) {
	if (this._pMipmap == value) {
		return;
	}
	this._pMipmap = value;
	this.iInvalidateShaderProgram(true);
};

away.materials.passes.MaterialPassBase.prototype.get_smooth = function() {
	return this._pSmooth;
};

away.materials.passes.MaterialPassBase.prototype.set_smooth = function(value) {
	if (this._pSmooth == value) {
		return;
	}
	this._pSmooth = value;
	this.iInvalidateShaderProgram(true);
};

away.materials.passes.MaterialPassBase.prototype.get_repeat = function() {
	return this._pRepeat;
};

away.materials.passes.MaterialPassBase.prototype.set_repeat = function(value) {
	if (this._pRepeat == value) {
		return;
	}
	this._pRepeat = value;
	this.iInvalidateShaderProgram(true);
};

away.materials.passes.MaterialPassBase.prototype.get_bothSides = function() {
	return this._pBothSides;
};

away.materials.passes.MaterialPassBase.prototype.set_bothSides = function(value) {
	this._pBothSides = value;
};

away.materials.passes.MaterialPassBase.prototype.get_depthCompareMode = function() {
	return this._depthCompareMode;
};

away.materials.passes.MaterialPassBase.prototype.set_depthCompareMode = function(value) {
	this._depthCompareMode = value;
};

away.materials.passes.MaterialPassBase.prototype.get_animationSet = function() {
	return this._animationSet;
};

away.materials.passes.MaterialPassBase.prototype.set_animationSet = function(value) {
	if (this._animationSet == value) {
		return;
	}
	this._animationSet = value;
	this.iInvalidateShaderProgram(true);
};

away.materials.passes.MaterialPassBase.prototype.get_renderToTexture = function() {
	return this._renderToTexture;
};

away.materials.passes.MaterialPassBase.prototype.dispose = function() {
	if (this._pLightPicker) {
		this._pLightPicker.removeEventListener(away.events.Event.CHANGE, $createStaticDelegate(this, this.onLightsChange), this);
	}
	for (var i = 0; i < 8; ++i) {
		if (this._iProgram3Ds[i]) {
			away.managers.AGALProgram3DCache.getInstanceFromIndex(i).freeProgram3D(this._iProgram3Dids[i]);
			this._iProgram3Ds[i] = null;
		}
	}
};

away.materials.passes.MaterialPassBase.prototype.get_numUsedStreams = function() {
	return this._pNumUsedStreams;
};

away.materials.passes.MaterialPassBase.prototype.get_numUsedVertexConstants = function() {
	return this._pNumUsedVertexConstants;
};

away.materials.passes.MaterialPassBase.prototype.get_numUsedVaryings = function() {
	return this._pNumUsedVaryings;
};

away.materials.passes.MaterialPassBase.prototype.get_numUsedFragmentConstants = function() {
	return this._pNumUsedFragmentConstants;
};

away.materials.passes.MaterialPassBase.prototype.get_needFragmentAnimation = function() {
	return this._pNeedFragmentAnimation;
};

away.materials.passes.MaterialPassBase.prototype.get_needUVAnimation = function() {
	return this._pNeedUVAnimation;
};

away.materials.passes.MaterialPassBase.prototype.iUpdateAnimationState = function(renderable, stage3DProxy, camera) {
	renderable.get_animator().setRenderState(stage3DProxy, renderable, this._pNumUsedVertexConstants, this._pNumUsedStreams, camera);
};

away.materials.passes.MaterialPassBase.prototype.iRender = function(renderable, stage3DProxy, camera, viewProjection) {
	throw new away.errors.AbstractMethodError(null, 0);
};

away.materials.passes.MaterialPassBase.prototype.iGetVertexCode = function() {
	throw new away.errors.AbstractMethodError(null, 0);
};

away.materials.passes.MaterialPassBase.prototype.iGetFragmentCode = function(fragmentAnimatorCode) {
	throw new away.errors.AbstractMethodError(null, 0);
};

away.materials.passes.MaterialPassBase.prototype.setBlendMode = function(value) {
	switch (value) {
		case away.display.BlendMode.NORMAL:
			this._blendFactorSource = away.display3D.Context3DBlendFactor.ONE;
			this._blendFactorDest = away.display3D.Context3DBlendFactor.ZERO;
			this._pEnableBlending = false;
			break;
		case away.display.BlendMode.LAYER:
			this._blendFactorSource = away.display3D.Context3DBlendFactor.SOURCE_ALPHA;
			this._blendFactorDest = away.display3D.Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA;
			this._pEnableBlending = true;
			break;
		case away.display.BlendMode.MULTIPLY:
			this._blendFactorSource = away.display3D.Context3DBlendFactor.ZERO;
			this._blendFactorDest = away.display3D.Context3DBlendFactor.SOURCE_COLOR;
			this._pEnableBlending = true;
			break;
		case away.display.BlendMode.ADD:
			this._blendFactorSource = away.display3D.Context3DBlendFactor.SOURCE_ALPHA;
			this._blendFactorDest = away.display3D.Context3DBlendFactor.ONE;
			this._pEnableBlending = true;
			break;
		case away.display.BlendMode.ALPHA:
			this._blendFactorSource = away.display3D.Context3DBlendFactor.ZERO;
			this._blendFactorDest = away.display3D.Context3DBlendFactor.SOURCE_ALPHA;
			this._pEnableBlending = true;
			break;
		default:
			throw new away.errors.ArgumentError("Unsupported blend mode!", 0);
	}
};

away.materials.passes.MaterialPassBase.prototype.iActivate = function(stage3DProxy, camera) {
	var contextIndex = stage3DProxy._iStage3DIndex;
	var context = stage3DProxy._iContext3D;
	context.setDepthTest((this._writeDepth && !this._pEnableBlending), this._depthCompareMode);
	if (this._pEnableBlending) {
		context.setBlendFactors(this._blendFactorSource, this._blendFactorDest);
	}
	if (this._context3Ds[contextIndex] != context || !this._iProgram3Ds[contextIndex]) {
		this._context3Ds[contextIndex] = context;
		this.iUpdateProgram(stage3DProxy);
		this.dispatchEvent(new away.events.Event(away.events.Event.CHANGE));
	}
	var prevUsed = away.materials.passes.MaterialPassBase._previousUsedStreams[contextIndex];
	var i;
	for (i = this._pNumUsedStreams; i < prevUsed; ++i) {
		context.setVertexBufferAt(i, null, 0);
	}
	prevUsed = away.materials.passes.MaterialPassBase._previousUsedTexs[contextIndex];
	for (i = this._pNumUsedTextures; i < prevUsed; ++i) {
		context.setTextureAt(i, null);
	}
	if (this._animationSet && !this._animationSet.get_usesCPU()) {
		this._animationSet.activate(stage3DProxy, this);
	}
	context.setProgram(this._iProgram3Ds[contextIndex]);
	context.setCulling(this._pBothSides ? away.display3D.Context3DTriangleFace.NONE : this._defaultCulling);
	if (this._renderToTexture) {
		this._oldTarget = stage3DProxy.get_renderTarget();
		this._oldSurface = stage3DProxy.get_renderSurfaceSelector();
		this._oldDepthStencil = stage3DProxy.get_enableDepthAndStencil();
		this._oldRect = stage3DProxy.get_scissorRect();
	}
};

away.materials.passes.MaterialPassBase.prototype.iDeactivate = function(stage3DProxy) {
	var index = stage3DProxy._iStage3DIndex;
	away.materials.passes.MaterialPassBase._previousUsedStreams[index] = this._pNumUsedStreams;
	away.materials.passes.MaterialPassBase._previousUsedTexs[index] = this._pNumUsedTextures;
	if (this._animationSet && !this._animationSet.get_usesCPU()) {
		this._animationSet.deactivate(stage3DProxy, this);
	}
	if (this._renderToTexture) {
		stage3DProxy.setRenderTarget(this._oldTarget, this._oldDepthStencil, this._oldSurface);
		stage3DProxy.set_scissorRect(this._oldRect);
	}
	stage3DProxy._iContext3D.setDepthTest(true, away.display3D.Context3DCompareMode.LESS_EQUAL);
};

away.materials.passes.MaterialPassBase.prototype.iInvalidateShaderProgram = function(updateMaterial) {
	updateMaterial = updateMaterial || true;
	for (var i = 0; i < 8; ++i) {
		this._iProgram3Ds[i] = null;
	}
	if (this._pMaterial && updateMaterial) {
		this._pMaterial.iInvalidatePasses(this);
	}
};

away.materials.passes.MaterialPassBase.prototype.iUpdateProgram = function(stage3DProxy) {
	var animatorCode = "";
	var UVAnimatorCode = "";
	var fragmentAnimatorCode = "";
	var vertexCode = this.iGetVertexCode();
	if (this._animationSet && !this._animationSet.get_usesCPU()) {
		animatorCode = this._animationSet.getAGALVertexCode(this, this._pAnimatableAttributes, this._pAnimationTargetRegisters, stage3DProxy.get_profile());
		if (this._pNeedFragmentAnimation) {
			fragmentAnimatorCode = this._animationSet.getAGALFragmentCode(this, this._pShadedTarget, stage3DProxy.get_profile());
		}
		if (this._pNeedUVAnimation) {
			UVAnimatorCode = this._animationSet.getAGALUVCode(this, this._pUVSource, this._pUVTarget);
		}
		this._animationSet.doneAGALCode(this);
	} else {
		var len = this._pAnimatableAttributes.length;
		for (var i = 0; i < len; ++i) {
			animatorCode += "mov " + this._pAnimationTargetRegisters[i] + ", " + this._pAnimatableAttributes[i] + "\n";
		}
		if (this._pNeedUVAnimation) {
			UVAnimatorCode = "mov " + this._pUVTarget + "," + this._pUVSource + "\n";
		}
	}
	vertexCode = animatorCode + UVAnimatorCode + vertexCode;
	var fragmentCode = this.iGetFragmentCode(fragmentAnimatorCode);
	away.managers.AGALProgram3DCache.getInstance(stage3DProxy).setProgram3D(this, vertexCode, fragmentCode);
};

away.materials.passes.MaterialPassBase.prototype.get_lightPicker = function() {
	return this._pLightPicker;
};

away.materials.passes.MaterialPassBase.prototype.set_lightPicker = function(value) {
	if (this._pLightPicker) {
		this._pLightPicker.removeEventListener(away.events.Event.CHANGE, $createStaticDelegate(this, this.onLightsChange), this);
	}
	this._pLightPicker = value;
	if (this._pLightPicker) {
		this._pLightPicker.addEventListener(away.events.Event.CHANGE, $createStaticDelegate(this, this.onLightsChange), this);
	}
	this.pUpdateLights();
};

away.materials.passes.MaterialPassBase.prototype.onLightsChange = function(event) {
	this.pUpdateLights();
};

away.materials.passes.MaterialPassBase.prototype.pUpdateLights = function() {
};

away.materials.passes.MaterialPassBase.prototype.get_alphaPremultiplied = function() {
	return this._pAlphaPremultiplied;
};

away.materials.passes.MaterialPassBase.prototype.set_alphaPremultiplied = function(value) {
	this._pAlphaPremultiplied = value;
	this.iInvalidateShaderProgram(false);
};

$inherit(away.materials.passes.MaterialPassBase, away.events.EventDispatcher);

away.materials.passes.MaterialPassBase.className = "away.materials.passes.MaterialPassBase";

away.materials.passes.MaterialPassBase.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.events.Event');
	p.push('away.display3D.Context3DBlendFactor');
	p.push('away.display3D.Context3DTriangleFace');
	p.push('away.errors.AbstractMethodError');
	p.push('away.display.BlendMode');
	p.push('away.managers.AGALProgram3DCache');
	p.push('away.display3D.Context3DCompareMode');
	p.push('away.managers.Stage3DProxy');
	return p;
};

away.materials.passes.MaterialPassBase.getStaticDependencies = function(t) {
	var p;
	p = [];
	p.push('away.display3D.Program3D');
	p.push('away.display3D.Context3DBlendFactor');
	p.push('away.display3D.Context3DTriangleFace');
	p.push('away.display3D.Context3D');
	p.push('away.display3D.Context3DCompareMode');
	p.push('away.utils.VectorInit');
	return p;
};

away.materials.passes.MaterialPassBase.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'renderToTexture', t:'Boolean'});
			break;
		case 1:
			p = away.events.EventDispatcher.injectionPoints(t);
			break;
		case 2:
			p = away.events.EventDispatcher.injectionPoints(t);
			break;
		case 3:
			p = away.events.EventDispatcher.injectionPoints(t);
			break;
		default:
			p = [];
			break;
	}
	return p;
};

