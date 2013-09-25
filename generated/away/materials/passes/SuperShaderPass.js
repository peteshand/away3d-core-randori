/** Compiled by the Randori compiler v0.2.6.2 on Wed Sep 25 20:35:40 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.materials == "undefined")
	away.materials = {};
if (typeof away.materials.passes == "undefined")
	away.materials.passes = {};

away.materials.passes.SuperShaderPass = function(material) {
	this._includeCasters = true;
	this._ignoreLights = false;
	away.materials.passes.CompiledPass.call(this, material);
	this._pNeedFragmentAnimation = true;
};

away.materials.passes.SuperShaderPass.prototype.pCreateCompiler = function(profile) {
	return new away.materials.compilation.SuperShaderCompiler(profile);
};

away.materials.passes.SuperShaderPass.prototype.get_includeCasters = function() {
	return this._includeCasters;
};

away.materials.passes.SuperShaderPass.prototype.set_includeCasters = function(value) {
	if (this._includeCasters == value)
		return;
	this._includeCasters = value;
	this.iInvalidateShaderProgram(true);
};

away.materials.passes.SuperShaderPass.prototype.get_colorTransform = function() {
	return this._pMethodSetup._iColorTransformMethod ? this._pMethodSetup._iColorTransformMethod.get_colorTransform() : null;
};

away.materials.passes.SuperShaderPass.prototype.set_colorTransform = function(value) {
	if (value) {
		if (this.get_colorTransformMethod() == null) {
			this.set_colorTransformMethod(new away.materials.methods.ColorTransformMethod());
		}
		this._pMethodSetup._iColorTransformMethod.set_colorTransform(value);
	} else if (!value) {
		if (this._pMethodSetup._iColorTransformMethod) {
			this.set_colorTransformMethod(null);
		}
		this.set_colorTransformMethod(null);
		this._pMethodSetup._iColorTransformMethod = null;
	}
};

away.materials.passes.SuperShaderPass.prototype.get_colorTransformMethod = function() {
	return this._pMethodSetup._iColorTransformMethod;
};

away.materials.passes.SuperShaderPass.prototype.set_colorTransformMethod = function(value) {
	this._pMethodSetup.set_iColorTransformMethod(value);
};

away.materials.passes.SuperShaderPass.prototype.addMethod = function(method) {
	this._pMethodSetup.addMethod(method);
};

away.materials.passes.SuperShaderPass.prototype.get_numMethods = function() {
	return this._pMethodSetup.get_numMethods();
};

away.materials.passes.SuperShaderPass.prototype.hasMethod = function(method) {
	return this._pMethodSetup.hasMethod(method);
};

away.materials.passes.SuperShaderPass.prototype.getMethodAt = function(index) {
	return this._pMethodSetup.getMethodAt(index);
};

away.materials.passes.SuperShaderPass.prototype.addMethodAt = function(method, index) {
	this._pMethodSetup.addMethodAt(method, index);
};

away.materials.passes.SuperShaderPass.prototype.removeMethod = function(method) {
	this._pMethodSetup.removeMethod(method);
};

away.materials.passes.SuperShaderPass.prototype.pUpdateLights = function() {
	if (this._pLightPicker && !this._ignoreLights) {
		this._pNumPointLights = this._pLightPicker.get_numPointLights();
		this._pNumDirectionalLights = this._pLightPicker.get_numDirectionalLights();
		this._pNumLightProbes = this._pLightPicker.get_numLightProbes();
		if (this._includeCasters) {
			this._pNumPointLights += this._pLightPicker.get_numCastingPointLights();
			this._pNumDirectionalLights += this._pLightPicker.get_numCastingDirectionalLights();
		}
	} else {
		this._pNumPointLights = 0;
		this._pNumDirectionalLights = 0;
		this._pNumLightProbes = 0;
	}
	this.iInvalidateShaderProgram(true);
};

away.materials.passes.SuperShaderPass.prototype.iActivate = function(stage3DProxy, camera) {
	away.materials.passes.CompiledPass.prototype.iActivate.call(this,stage3DProxy, camera);
	if (this._pMethodSetup._iColorTransformMethod)
		this._pMethodSetup._iColorTransformMethod.iActivate(this._pMethodSetup._iColorTransformMethodVO, stage3DProxy);
	var methods = this._pMethodSetup._iMethods;
	var len = methods.length;
	for (var i = 0; i < len; ++i) {
		var aset = methods[i];
		aset.method.iActivate(aset.data, stage3DProxy);
	}
	if (this._pCameraPositionIndex >= 0) {
		var pos = camera.get_scenePosition();
		this._pVertexConstantData[this._pCameraPositionIndex] = pos.x;
		this._pVertexConstantData[this._pCameraPositionIndex + 1] = pos.y;
		this._pVertexConstantData[this._pCameraPositionIndex + 2] = pos.z;
	}
};

away.materials.passes.SuperShaderPass.prototype.iDeactivate = function(stage3DProxy) {
	away.materials.passes.CompiledPass.prototype.iDeactivate.call(this,stage3DProxy);
	if (this._pMethodSetup._iColorTransformMethod) {
		this._pMethodSetup._iColorTransformMethod.iDeactivate(this._pMethodSetup._iColorTransformMethodVO, stage3DProxy);
	}
	var aset;
	var methods = this._pMethodSetup._iMethods;
	var len = methods.length;
	for (var i = 0; i < len; ++i) {
		aset = methods[i];
		aset.method.iDeactivate(aset.data, stage3DProxy);
	}
};

away.materials.passes.SuperShaderPass.prototype.pAddPassesFromMethods = function() {
	away.materials.passes.CompiledPass.prototype.pAddPassesFromMethods.call(this);
	if (this._pMethodSetup._iColorTransformMethod) {
		this.pAddPasses(this._pMethodSetup._iColorTransformMethod.get_passes());
	}
	var methods = this._pMethodSetup._iMethods;
	for (var i = 0; i < methods.length; ++i) {
		this.pAddPasses(methods[i].method.passes);
	}
};

away.materials.passes.SuperShaderPass.prototype.usesProbesForSpecular = function() {
	return this._pNumLightProbes > 0 && (this._pSpecularLightSources & away.materials.LightSources.PROBES) != 0;
};

away.materials.passes.SuperShaderPass.prototype.usesProbesForDiffuse = function() {
	return this._pNumLightProbes > 0 && (this._pDiffuseLightSources & away.materials.LightSources.PROBES) != 0;
};

away.materials.passes.SuperShaderPass.prototype.pUpdateMethodConstants = function() {
	away.materials.passes.CompiledPass.prototype.pUpdateMethodConstants.call(this);
	if (this._pMethodSetup._iColorTransformMethod) {
		this._pMethodSetup._iColorTransformMethod.iInitConstants(this._pMethodSetup._iColorTransformMethodVO);
	}
	var methods = this._pMethodSetup._iMethods;
	var len = methods.length;
	for (var i = 0; i < len; ++i) {
		methods[i].method.iInitConstants(methods[i].data);
	}
};

away.materials.passes.SuperShaderPass.prototype.pUpdateLightConstants = function() {
	var dirLight;
	var pointLight;
	var i, k;
	var len;
	var dirPos;
	var total = 0;
	var numLightTypes = this._includeCasters ? 2 : 1;
	k = this._pLightFragmentConstantIndex;
	for (var cast = 0; cast < numLightTypes; ++cast) {
		var dirLights = cast ? this._pLightPicker.get_castingDirectionalLights() : this._pLightPicker.get_directionalLights();
		len = dirLights.length;
		total += len;
		for (i = 0; i < len; ++i) {
			dirLight = dirLights[i];
			dirPos = dirLight.get_sceneDirection();
			this._pAmbientLightR += dirLight._iAmbientR;
			this._pAmbientLightG += dirLight._iAmbientG;
			this._pAmbientLightB += dirLight._iAmbientB;
			this._pFragmentConstantData[k++] = -dirPos.x;
			this._pFragmentConstantData[k++] = -dirPos.y;
			this._pFragmentConstantData[k++] = -dirPos.z;
			this._pFragmentConstantData[k++] = 1;
			this._pFragmentConstantData[k++] = dirLight._iDiffuseR;
			this._pFragmentConstantData[k++] = dirLight._iDiffuseG;
			this._pFragmentConstantData[k++] = dirLight._iDiffuseB;
			this._pFragmentConstantData[k++] = 1;
			this._pFragmentConstantData[k++] = dirLight._iSpecularR;
			this._pFragmentConstantData[k++] = dirLight._iSpecularG;
			this._pFragmentConstantData[k++] = dirLight._iSpecularB;
			this._pFragmentConstantData[k++] = 1;
		}
	}
	if (this._pNumDirectionalLights > total) {
		i = k + (this._pNumDirectionalLights - total) * 12;
		while (k < i) {
			this._pFragmentConstantData[k++] = 0;
		}
	}
	total = 0;
	for (cast = 0; cast < numLightTypes; ++cast) {
		var pointLights = cast ? this._pLightPicker.get_castingPointLights() : this._pLightPicker.get_pointLights();
		len = pointLights.length;
		for (i = 0; i < len; ++i) {
			pointLight = pointLights[i];
			dirPos = pointLight.get_scenePosition();
			this._pAmbientLightR += pointLight._iAmbientR;
			this._pAmbientLightG += pointLight._iAmbientG;
			this._pAmbientLightB += pointLight._iAmbientB;
			this._pFragmentConstantData[k++] = dirPos.x;
			this._pFragmentConstantData[k++] = dirPos.y;
			this._pFragmentConstantData[k++] = dirPos.z;
			this._pFragmentConstantData[k++] = 1;
			this._pFragmentConstantData[k++] = pointLight._iDiffuseR;
			this._pFragmentConstantData[k++] = pointLight._iDiffuseG;
			this._pFragmentConstantData[k++] = pointLight._iDiffuseB;
			this._pFragmentConstantData[k++] = pointLight._pRadius * pointLight._pRadius;
			this._pFragmentConstantData[k++] = pointLight._iSpecularR;
			this._pFragmentConstantData[k++] = pointLight._iSpecularG;
			this._pFragmentConstantData[k++] = pointLight._iSpecularB;
			this._pFragmentConstantData[k++] = pointLight._pFallOffFactor;
		}
	}
	if (this._pNumPointLights > total) {
		i = k + (total - this._pNumPointLights) * 12;
		for (; k < i; ++k) {
			this._pFragmentConstantData[k] = 0;
		}
	}
};

away.materials.passes.SuperShaderPass.prototype.pUpdateProbes = function(stage3DProxy) {
	var probe;
	var lightProbes = this._pLightPicker.get_lightProbes();
	var weights = this._pLightPicker.get_lightProbeWeights();
	var len = lightProbes.length;
	var addDiff = this.usesProbesForDiffuse();
	var addSpec = (this._pMethodSetup._iSpecularMethod && this.usesProbesForSpecular());
	var context = stage3DProxy._iContext3D;
	if (!(addDiff || addSpec)) {
		return;
	}
	for (var i = 0; i < len; ++i) {
		probe = lightProbes[i];
		if (addDiff) {
			context.setTextureAt(this._pLightProbeSpecularIndices[i], probe.get_diffuseMap().getTextureForStage3D(stage3DProxy));
		}
		if (addSpec) {
			context.setTextureAt(this._pLightProbeSpecularIndices[i], probe.get_specularMap().getTextureForStage3D(stage3DProxy));
		}
	}
	this._pFragmentConstantData[this._pProbeWeightsIndex] = weights[0];
	this._pFragmentConstantData[this._pProbeWeightsIndex + 1] = weights[1];
	this._pFragmentConstantData[this._pProbeWeightsIndex + 2] = weights[2];
	this._pFragmentConstantData[this._pProbeWeightsIndex + 3] = weights[3];
};

away.materials.passes.SuperShaderPass.prototype.set_iIgnoreLights = function(ignoreLights) {
	this._ignoreLights = ignoreLights;
};

away.materials.passes.SuperShaderPass.prototype.get_iIgnoreLights = function() {
	return this._ignoreLights;
};

$inherit(away.materials.passes.SuperShaderPass, away.materials.passes.CompiledPass);

away.materials.passes.SuperShaderPass.className = "away.materials.passes.SuperShaderPass";

away.materials.passes.SuperShaderPass.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.materials.methods.ColorTransformMethod');
	p.push('away.materials.methods.MethodVOSet');
	p.push('away.materials.compilation.SuperShaderCompiler');
	p.push('away.materials.LightSources');
	p.push('away.materials.methods.ShaderMethodSetup');
	return p;
};

away.materials.passes.SuperShaderPass.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.materials.passes.SuperShaderPass.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'material', t:'away.materials.MaterialBase'});
			break;
		case 1:
			p = away.materials.passes.CompiledPass.injectionPoints(t);
			break;
		case 2:
			p = away.materials.passes.CompiledPass.injectionPoints(t);
			break;
		case 3:
			p = away.materials.passes.CompiledPass.injectionPoints(t);
			break;
		default:
			p = [];
			break;
	}
	return p;
};

