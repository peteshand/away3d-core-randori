/** Compiled by the Randori compiler v0.2.6.2 on Thu Sep 05 22:21:02 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.materials == "undefined")
	away.materials = {};

away.materials.MaterialBase = function() {
	this._distanceBasedDepthRender = null;
	this._iClassification = null;
	this._animationSet = null;
	this._pBlendMode = away.display.BlendMode.NORMAL;
	this._pMipmap = true;
	this._alphaPremultiplied = null;
	this._pDistancePass = null;
	this._bothSides = false;
	this._pDepthPass = null;
	this.extra = null;
	this._pLightPicker = null;
	this._iUniqueId = 0;
	this._numPasses = 0;
	this._owners = null;
	this._pDepthCompareMode = away.display3D.Context3DCompareMode.LESS_EQUAL;
	this._smooth = true;
	this._iDepthPassId = 0;
	this._repeat = false;
	this._passes = null;
	this._iRenderOrderId = 0;
	this.MATERIAL_ID_COUNT = 0;
	away.library.assets.NamedAssetBase.call(this);
	this._owners = [];
	this._passes = [];
	this._pDepthPass = new away.materials.passes.DepthMapPass();
	this._pDistancePass = new away.materials.passes.DistanceMapPass();
	this._pDepthPass.addEventListener(away.events.Event.CHANGE, $createStaticDelegate(this, this.onDepthPassChange), this);
	this._pDistancePass.addEventListener(away.events.Event.CHANGE, $createStaticDelegate(this, this.onDistancePassChange), this);
	this.set_alphaPremultiplied(true);
	this._iUniqueId = away.materials.MaterialBase.MATERIAL_ID_COUNT++;
};

away.materials.MaterialBase.MATERIAL_ID_COUNT = 0;

away.materials.MaterialBase.prototype.get_assetType = function() {
	return away.library.assets.AssetType.MATERIAL;
};

away.materials.MaterialBase.prototype.get_lightPicker = function() {
	return this._pLightPicker;
};

away.materials.MaterialBase.prototype.set_lightPicker = function(value) {
	this.setLightPicker(value);
};

away.materials.MaterialBase.prototype.setLightPicker = function(value) {
	if (value != this._pLightPicker) {
		this._pLightPicker = value;
		var len = this._passes.length;
		for (var i = 0; i < len; ++i) {
			this._passes[i].lightPicker = this._pLightPicker;
		}
	}
};

away.materials.MaterialBase.prototype.get_mipmap = function() {
	return this._pMipmap;
};

away.materials.MaterialBase.prototype.set_mipmap = function(value) {
	this.setMipMap(value);
};

away.materials.MaterialBase.prototype.setMipMap = function(value) {
	this._pMipmap = value;
	for (var i = 0; i < this._numPasses; ++i) {
		this._passes[i].mipmap = value;
	}
};

away.materials.MaterialBase.prototype.get_smooth = function() {
	return this._smooth;
};

away.materials.MaterialBase.prototype.set_smooth = function(value) {
	this._smooth = value;
	for (var i = 0; i < this._numPasses; ++i) {
		this._passes[i].smooth = value;
	}
};

away.materials.MaterialBase.prototype.get_depthCompareMode = function() {
	return this._pDepthCompareMode;
};

away.materials.MaterialBase.prototype.set_depthCompareMode = function(value) {
	this.setDepthCompareMode(value);
};

away.materials.MaterialBase.prototype.setDepthCompareMode = function(value) {
	this._pDepthCompareMode = value;
};

away.materials.MaterialBase.prototype.get_repeat = function() {
	return this._repeat;
};

away.materials.MaterialBase.prototype.set_repeat = function(value) {
	this._repeat = value;
	for (var i = 0; i < this._numPasses; ++i) {
		this._passes[i].repeat = value;
	}
};

away.materials.MaterialBase.prototype.dispose = function() {
	var i;
	for (i = 0; i < this._numPasses; ++i) {
		this._passes[i].dispose();
	}
	this._pDepthPass.dispose();
	this._pDistancePass.dispose();
	this._pDepthPass.removeEventListener(away.events.Event.CHANGE, $createStaticDelegate(this, this.onDepthPassChange), this);
	this._pDistancePass.removeEventListener(away.events.Event.CHANGE, $createStaticDelegate(this, this.onDistancePassChange), this);
};

away.materials.MaterialBase.prototype.get_bothSides = function() {
	return this._bothSides;
};

away.materials.MaterialBase.prototype.set_bothSides = function(value) {
	this._bothSides = value;
	for (var i = 0; i < this._numPasses; ++i) {
		this._passes[i].bothSides = value;
	}
	this._pDepthPass.set_bothSides(value);
	this._pDistancePass.set_bothSides(value);
};

away.materials.MaterialBase.prototype.get_blendMode = function() {
	return this.getBlendMode();
};

away.materials.MaterialBase.prototype.getBlendMode = function() {
	return this._pBlendMode;
};

away.materials.MaterialBase.prototype.set_blendMode = function(value) {
	this.setBlendMode(value);
};

away.materials.MaterialBase.prototype.setBlendMode = function(value) {
	this._pBlendMode = value;
};

away.materials.MaterialBase.prototype.get_alphaPremultiplied = function() {
	return this._alphaPremultiplied;
};

away.materials.MaterialBase.prototype.set_alphaPremultiplied = function(value) {
	this._alphaPremultiplied = value;
	for (var i = 0; i < this._numPasses; ++i) {
		this._passes[i].alphaPremultiplied = value;
	}
};

away.materials.MaterialBase.prototype.get_requiresBlending = function() {
	return this.getRequiresBlending();
};

away.materials.MaterialBase.prototype.getRequiresBlending = function() {
	return this._pBlendMode != away.display.BlendMode.NORMAL;
};

away.materials.MaterialBase.prototype.get_uniqueId = function() {
	return this._iUniqueId;
};

away.materials.MaterialBase.prototype.get__iNumPasses = function() {
	return this._numPasses;
};

away.materials.MaterialBase.prototype.iHasDepthAlphaThreshold = function() {
	return this._pDepthPass.get_alphaThreshold() > 0;
};

away.materials.MaterialBase.prototype.iActivateForDepth = function(stage3DProxy, camera, distanceBased) {
	this._distanceBasedDepthRender = distanceBased;
	if (distanceBased) {
		this._pDistancePass.iActivate(stage3DProxy, camera);
	} else {
		this._pDepthPass.iActivate(stage3DProxy, camera);
	}
};

away.materials.MaterialBase.prototype.iDeactivateForDepth = function(stage3DProxy) {
	if (this._distanceBasedDepthRender) {
		this._pDistancePass.iDeactivate(stage3DProxy);
	} else {
		this._pDepthPass.iDeactivate(stage3DProxy);
	}
};

away.materials.MaterialBase.prototype.iRenderDepth = function(renderable, stage3DProxy, camera, viewProjection) {
	if (this._distanceBasedDepthRender) {
		if (renderable.get_animator()) {
			this._pDistancePass.iUpdateAnimationState(renderable, stage3DProxy, camera);
		}
		this._pDistancePass.iRender(renderable, stage3DProxy, camera, viewProjection);
	} else {
		if (renderable.get_animator()) {
			this._pDepthPass.iUpdateAnimationState(renderable, stage3DProxy, camera);
		}
		this._pDepthPass.iRender(renderable, stage3DProxy, camera, viewProjection);
	}
};

away.materials.MaterialBase.prototype.iPassRendersToTexture = function(index) {
	return this._passes[index].renderToTexture;
};

away.materials.MaterialBase.prototype.iActivatePass = function(index, stage3DProxy, camera) {
	this._passes[index].iActivate(stage3DProxy, camera);
};

away.materials.MaterialBase.prototype.iDeactivatePass = function(index, stage3DProxy) {
	this._passes[index].iDeactivate(stage3DProxy);
};

away.materials.MaterialBase.prototype.iRenderPass = function(index, renderable, stage3DProxy, entityCollector, viewProjection) {
	if (this._pLightPicker) {
		this._pLightPicker.collectLights(renderable, entityCollector);
	}
	var pass = this._passes[index];
	if (renderable.get_animator()) {
		pass.iUpdateAnimationState(renderable, stage3DProxy, entityCollector.get_camera());
	}
	pass.iRender(renderable, stage3DProxy, entityCollector.get_camera(), viewProjection);
};

away.materials.MaterialBase.prototype.iAddOwner = function(owner) {
	this._owners.push(owner);
	if (owner.get_animator()) {
		if (this._animationSet && owner.get_animator().get_animationSet() != this._animationSet) {
			throw new Error("A Material instance cannot be shared across renderables with different animator libraries", 0);
		} else {
			if (this._animationSet != owner.get_animator().get_animationSet()) {
				this._animationSet = owner.get_animator().get_animationSet();
				for (var i = 0; i < this._numPasses; ++i) {
					this._passes[i].animationSet = this._animationSet;
				}
				this._pDepthPass.set_animationSet(this._animationSet);
				this._pDistancePass.set_animationSet(this._animationSet);
				this.iInvalidatePasses(null);
			}
		}
	}
};

away.materials.MaterialBase.prototype.iRemoveOwner = function(owner) {
	this._owners.splice(this._owners.indexOf(owner, 0), 1);
	if (this._owners.length == 0) {
		this._animationSet = null;
		for (var i = 0; i < this._numPasses; ++i) {
			this._passes[i].animationSet = this._animationSet;
		}
		this._pDepthPass.set_animationSet(this._animationSet);
		this._pDistancePass.set_animationSet(this._animationSet);
		this.iInvalidatePasses(null);
	}
};

away.materials.MaterialBase.prototype.get_iOwners = function() {
	return this._owners;
};

away.materials.MaterialBase.prototype.iUpdateMaterial = function(context) {
};

away.materials.MaterialBase.prototype.iDeactivate = function(stage3DProxy) {
	this._passes[this._numPasses - 1].iDeactivate(stage3DProxy);
};

away.materials.MaterialBase.prototype.iInvalidatePasses = function(triggerPass) {
	var owner;
	var l;
	var c;
	this._pDepthPass.iInvalidateShaderProgram(true);
	this._pDistancePass.iInvalidateShaderProgram(true);
	if (this._animationSet) {
		this._animationSet.resetGPUCompatibility();
		l = this._owners.length;
		for (c = 0; c < l; c++) {
			owner = this._owners[c];
			if (owner.get_animator()) {
				owner.get_animator().testGPUCompatibility(this._pDepthPass);
				owner.get_animator().testGPUCompatibility(this._pDistancePass);
			}
		}
	}
	for (var i = 0; i < this._numPasses; ++i) {
		if (this._passes[i] != triggerPass) {
			this._passes[i].iInvalidateShaderProgram(false);
		}
		if (this._animationSet) {
			l = this._owners.length;
			for (c = 0; c < l; c++) {
				owner = this._owners[c];
				if (owner.get_animator()) {
					owner.get_animator().testGPUCompatibility(this._passes[i]);
				}
			}
		}
	}
};

away.materials.MaterialBase.prototype.pRemovePass = function(pass) {
	this._passes.splice(this._passes.indexOf(pass, 0), 1);
	--this._numPasses;
};

away.materials.MaterialBase.prototype.pClearPasses = function() {
	for (var i = 0; i < this._numPasses; ++i) {
		this._passes[i].removeEventListener(away.events.Event.CHANGE, $createStaticDelegate(this, this.onPassChange), this);
	}
	this._passes.length = 0;
	this._numPasses = 0;
};

away.materials.MaterialBase.prototype.pAddPass = function(pass) {
	this._passes[this._numPasses++] = pass;
	pass.set_animationSet(this._animationSet);
	pass.set_alphaPremultiplied(this._alphaPremultiplied);
	pass.set_mipmap(this._pMipmap);
	pass.set_smooth(this._smooth);
	pass.set_repeat(this._repeat);
	pass.set_lightPicker(this._pLightPicker);
	pass.set_bothSides(this._bothSides);
	pass.addEventListener(away.events.Event.CHANGE, $createStaticDelegate(this, this.onPassChange), this);
	this.iInvalidatePasses(null);
};

away.materials.MaterialBase.prototype.onPassChange = function(event) {
	var mult = 1;
	var ids;
	var len;
	this._iRenderOrderId = 0;
	for (var i = 0; i < this._numPasses; ++i) {
		ids = this._passes[i]._iProgram3Dids;
		len = ids.length;
		for (var j = 0; j < len; ++j) {
			if (ids[j] != -1) {
				this._iRenderOrderId += mult * ids[j];
				j = len;
			}
		}
		mult *= 1000;
	}
};

away.materials.MaterialBase.prototype.onDistancePassChange = function(event) {
	var ids = this._pDistancePass._iProgram3Dids;
	var len = ids.length;
	this._iDepthPassId = 0;
	for (var j = 0; j < len; ++j) {
		if (ids[j] != -1) {
			this._iDepthPassId += ids[j];
			j = len;
		}
	}
};

away.materials.MaterialBase.prototype.onDepthPassChange = function(event) {
	var ids = this._pDepthPass._iProgram3Dids;
	var len = ids.length;
	this._iDepthPassId = 0;
	for (var j = 0; j < len; ++j) {
		if (ids[j] != -1) {
			this._iDepthPassId += ids[j];
			j = len;
		}
	}
};

$inherit(away.materials.MaterialBase, away.library.assets.NamedAssetBase);

away.materials.MaterialBase.className = "away.materials.MaterialBase";

away.materials.MaterialBase.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.traverse.EntityCollector');
	p.push('away.materials.passes.DistanceMapPass');
	p.push('away.events.Event');
	p.push('away.display.BlendMode');
	p.push('away.materials.passes.DepthMapPass');
	p.push('away.library.assets.AssetType');
	return p;
};

away.materials.MaterialBase.getStaticDependencies = function(t) {
	var p;
	p = [];
	p.push('away.display.BlendMode');
	p.push('away.display3D.Context3DCompareMode');
	return p;
};

away.materials.MaterialBase.injectionPoints = function(t) {
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

