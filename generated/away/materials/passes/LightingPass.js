/** Compiled by the Randori compiler v0.2.6.2 on Wed Sep 25 20:35:39 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.materials == "undefined")
	away.materials = {};
if (typeof away.materials.passes == "undefined")
	away.materials.passes = {};

away.materials.passes.LightingPass = function(material) {
	this._includeCasters = true;
	this._pointLightsOffset = 0;
	this._lightProbesOffset = 0;
	this._inverseSceneMatrix = away.utils.VectorInit.Num(0, 0);
	this._directionalLightsOffset = 0;
	this._lightVertexConstantIndex = 0;
	this._maxLights = 3;
	this._tangentSpace = false;
	away.materials.passes.CompiledPass.call(this, material);
};

away.materials.passes.LightingPass.prototype.get_directionalLightsOffset = function() {
	return this._directionalLightsOffset;
};

away.materials.passes.LightingPass.prototype.set_directionalLightsOffset = function(value) {
	this._directionalLightsOffset = value;
};

away.materials.passes.LightingPass.prototype.get_pointLightsOffset = function() {
	return this._pointLightsOffset;
};

away.materials.passes.LightingPass.prototype.set_pointLightsOffset = function(value) {
	this._pointLightsOffset = value;
};

away.materials.passes.LightingPass.prototype.get_lightProbesOffset = function() {
	return this._lightProbesOffset;
};

away.materials.passes.LightingPass.prototype.set_lightProbesOffset = function(value) {
	this._lightProbesOffset = value;
};

away.materials.passes.LightingPass.prototype.pCreateCompiler = function(profile) {
	this._maxLights = profile == "baselineConstrained" ? 1 : 3;
	return new away.materials.compilation.LightingShaderCompiler(profile);
};

away.materials.passes.LightingPass.prototype.get_includeCasters = function() {
	return this._includeCasters;
};

away.materials.passes.LightingPass.prototype.set_includeCasters = function(value) {
	if (this._includeCasters == value)
		return;
	this._includeCasters = value;
	this.iInvalidateShaderProgram(true);
};

away.materials.passes.LightingPass.prototype.pUpdateLights = function() {
	away.materials.passes.CompiledPass.prototype.pUpdateLights.call(this);
	var numDirectionalLights;
	var numPointLights = 0;
	var numLightProbes = 0;
	if (this._pLightPicker) {
		numDirectionalLights = this.calculateNumDirectionalLights(this._pLightPicker.get_numDirectionalLights());
		numPointLights = this.calculateNumPointLights(this._pLightPicker.get_numPointLights());
		numLightProbes = this.calculateNumProbes(this._pLightPicker.get_numLightProbes());
		if (this._includeCasters) {
			numPointLights += this._pLightPicker.get_numCastingPointLights();
			numDirectionalLights += this._pLightPicker.get_numCastingDirectionalLights();
		}
	} else {
		numDirectionalLights = 0;
		numPointLights = 0;
		numLightProbes = 0;
	}
	if (numPointLights != this._pNumPointLights || numDirectionalLights != this._pNumDirectionalLights || numLightProbes != this._pNumLightProbes) {
		this._pNumPointLights = numPointLights;
		this._pNumDirectionalLights = numDirectionalLights;
		this._pNumLightProbes = numLightProbes;
		this.iInvalidateShaderProgram(true);
	}
};

away.materials.passes.LightingPass.prototype.calculateNumDirectionalLights = function(numDirectionalLights) {
	return Math.min(numDirectionalLights - this._directionalLightsOffset, this._maxLights);
};

away.materials.passes.LightingPass.prototype.calculateNumPointLights = function(numPointLights) {
	var numFree = this._maxLights - this._pNumDirectionalLights;
	return Math.min(numPointLights - this._pointLightsOffset, numFree);
};

away.materials.passes.LightingPass.prototype.calculateNumProbes = function(numLightProbes) {
	var numChannels = 0;
	if ((this._pSpecularLightSources & away.materials.LightSources.PROBES) != 0) {
		++numChannels;
	}
	if ((this._pDiffuseLightSources & away.materials.LightSources.PROBES) != 0)
		++numChannels;
	return Math.min(numLightProbes - this._lightProbesOffset, (4 / numChannels) | 0);
};

away.materials.passes.LightingPass.prototype.pUpdateShaderProperties = function() {
	away.materials.passes.CompiledPass.prototype.pUpdateShaderProperties.call(this);
	var compilerV = this._pCompiler;
	this._tangentSpace = compilerV.get_tangentSpace();
};

away.materials.passes.LightingPass.prototype.pUpdateRegisterIndices = function() {
	away.materials.passes.CompiledPass.prototype.pUpdateRegisterIndices.call(this);
	var compilerV = this._pCompiler;
	this._lightVertexConstantIndex = compilerV.get_lightVertexConstantIndex();
};

away.materials.passes.LightingPass.prototype.iRender = function(renderable, stage3DProxy, camera, viewProjection) {
	renderable.get_inverseSceneTransform().copyRawDataTo(this._inverseSceneMatrix, 0, false);
	if (this._tangentSpace && this._pCameraPositionIndex >= 0) {
		var pos = camera.get_scenePosition();
		var x = pos.x;
		var y = pos.y;
		var z = pos.z;
		this._pVertexConstantData[this._pCameraPositionIndex] = this._inverseSceneMatrix[0] * x + this._inverseSceneMatrix[4] * y + this._inverseSceneMatrix[8] * z + this._inverseSceneMatrix[12];
		this._pVertexConstantData[this._pCameraPositionIndex + 1] = this._inverseSceneMatrix[1] * x + this._inverseSceneMatrix[5] * y + this._inverseSceneMatrix[9] * z + this._inverseSceneMatrix[13];
		this._pVertexConstantData[this._pCameraPositionIndex + 2] = this._inverseSceneMatrix[2] * x + this._inverseSceneMatrix[6] * y + this._inverseSceneMatrix[10] * z + this._inverseSceneMatrix[14];
	}
	away.materials.passes.CompiledPass.prototype.iRender.call(this,renderable, stage3DProxy, camera, viewProjection);
};

away.materials.passes.LightingPass.prototype.iActivate = function(stage3DProxy, camera) {
	away.materials.passes.CompiledPass.prototype.iActivate.call(this,stage3DProxy, camera);
	if (!this._tangentSpace && this._pCameraPositionIndex >= 0) {
		var pos = camera.get_scenePosition();
		this._pVertexConstantData[this._pCameraPositionIndex] = pos.x;
		this._pVertexConstantData[this._pCameraPositionIndex + 1] = pos.y;
		this._pVertexConstantData[this._pCameraPositionIndex + 2] = pos.z;
	}
};

away.materials.passes.LightingPass.prototype.usesProbesForSpecular = function() {
	return this._pNumLightProbes > 0 && (this._pSpecularLightSources & away.materials.LightSources.PROBES) != 0;
};

away.materials.passes.LightingPass.prototype.usesProbesForDiffuse = function() {
	return this._pNumLightProbes > 0 && (this._pDiffuseLightSources & away.materials.LightSources.PROBES) != 0;
};

away.materials.passes.LightingPass.prototype.pUpdateLightConstants = function() {
	var dirLight;
	var pointLight;
	var i = 0;
	var k = 0;
	var len;
	var dirPos;
	var total = 0;
	var numLightTypes = this._includeCasters ? 2 : 1;
	var l;
	var offset;
	l = this._lightVertexConstantIndex;
	k = this._pLightFragmentConstantIndex;
	var cast = 0;
	var dirLights = this._pLightPicker.get_directionalLights();
	offset = this._directionalLightsOffset;
	len = this._pLightPicker.get_directionalLights().length;
	if (offset > len) {
		cast = 1;
		offset -= len;
	}
	for (; cast < numLightTypes; ++cast) {
		if (cast)
			dirLights = this._pLightPicker.get_castingDirectionalLights();
		len = dirLights.length;
		if (len > this._pNumDirectionalLights)
			len = this._pNumDirectionalLights;
		for (i = 0; i < len; ++i) {
			dirLight = dirLights[offset + i];
			dirPos = dirLight.get_sceneDirection();
			this._pAmbientLightR += dirLight._iAmbientR;
			this._pAmbientLightG += dirLight._iAmbientG;
			this._pAmbientLightB += dirLight._iAmbientB;
			if (this._tangentSpace) {
				var x = -dirPos.x;
				var y = -dirPos.y;
				var z = -dirPos.z;
				this._pVertexConstantData[l++] = this._inverseSceneMatrix[0] * x + this._inverseSceneMatrix[4] * y + this._inverseSceneMatrix[8] * z;
				this._pVertexConstantData[l++] = this._inverseSceneMatrix[1] * x + this._inverseSceneMatrix[5] * y + this._inverseSceneMatrix[9] * z;
				this._pVertexConstantData[l++] = this._inverseSceneMatrix[2] * x + this._inverseSceneMatrix[6] * y + this._inverseSceneMatrix[10] * z;
				this._pVertexConstantData[l++] = 1;
			} else {
				this._pFragmentConstantData[k++] = -dirPos.x;
				this._pFragmentConstantData[k++] = -dirPos.y;
				this._pFragmentConstantData[k++] = -dirPos.z;
				this._pFragmentConstantData[k++] = 1;
			}
			this._pFragmentConstantData[k++] = dirLight._iDiffuseR;
			this._pFragmentConstantData[k++] = dirLight._iDiffuseG;
			this._pFragmentConstantData[k++] = dirLight._iDiffuseB;
			this._pFragmentConstantData[k++] = 1;
			this._pFragmentConstantData[k++] = dirLight._iSpecularR;
			this._pFragmentConstantData[k++] = dirLight._iSpecularG;
			this._pFragmentConstantData[k++] = dirLight._iSpecularB;
			this._pFragmentConstantData[k++] = 1;
			if (++total == this._pNumDirectionalLights) {
				i = len;
				cast = numLightTypes;
			}
		}
	}
	if (this._pNumDirectionalLights > total) {
		i = k + (this._pNumDirectionalLights - total) * 12;
		while (k < i) {
			this._pFragmentConstantData[k++] = 0;
		}
	}
	total = 0;
	var pointLights = this._pLightPicker.get_pointLights();
	offset = this._pointLightsOffset;
	len = this._pLightPicker.get_pointLights().length;
	if (offset > len) {
		cast = 1;
		offset -= len;
	} else {
		cast = 0;
	}
	for (; cast < numLightTypes; ++cast) {
		if (cast) {
			pointLights = this._pLightPicker.get_castingPointLights();
		}
		len = pointLights.length;
		for (i = 0; i < len; ++i) {
			pointLight = pointLights[offset + i];
			dirPos = pointLight.get_scenePosition();
			this._pAmbientLightR += pointLight._iAmbientR;
			this._pAmbientLightG += pointLight._iAmbientG;
			this._pAmbientLightB += pointLight._iAmbientB;
			if (this._tangentSpace) {
				x = dirPos.x;
				y = dirPos.y;
				z = dirPos.z;
				this._pVertexConstantData[l++] = this._inverseSceneMatrix[0] * x + this._inverseSceneMatrix[4] * y + this._inverseSceneMatrix[8] * z + this._inverseSceneMatrix[12];
				this._pVertexConstantData[l++] = this._inverseSceneMatrix[1] * x + this._inverseSceneMatrix[5] * y + this._inverseSceneMatrix[9] * z + this._inverseSceneMatrix[13];
				this._pVertexConstantData[l++] = this._inverseSceneMatrix[2] * x + this._inverseSceneMatrix[6] * y + this._inverseSceneMatrix[10] * z + this._inverseSceneMatrix[14];
			} else {
				this._pVertexConstantData[l++] = dirPos.x;
				this._pVertexConstantData[l++] = dirPos.y;
				this._pVertexConstantData[l++] = dirPos.z;
			}
			this._pVertexConstantData[l++] = 1;
			this._pFragmentConstantData[k++] = pointLight._iDiffuseR;
			this._pFragmentConstantData[k++] = pointLight._iDiffuseG;
			this._pFragmentConstantData[k++] = pointLight._iDiffuseB;
			var radius = pointLight._pRadius;
			this._pFragmentConstantData[k++] = radius * radius;
			this._pFragmentConstantData[k++] = pointLight._iSpecularR;
			this._pFragmentConstantData[k++] = pointLight._iSpecularG;
			this._pFragmentConstantData[k++] = pointLight._iSpecularB;
			this._pFragmentConstantData[k++] = pointLight._pFallOffFactor;
			if (++total == this._pNumPointLights) {
				i = len;
				cast = numLightTypes;
			}
		}
	}
	if (this._pNumPointLights > total) {
		i = k + (total - this._pNumPointLights) * 12;
		for (; k < i; ++k) {
			this._pFragmentConstantData[k] = 0;
		}
	}
};

away.materials.passes.LightingPass.prototype.pUpdateProbes = function(stage3DProxy) {
	var context = stage3DProxy._iContext3D;
	var probe;
	var lightProbes = this._pLightPicker.get_lightProbes();
	var weights = this._pLightPicker.get_lightProbeWeights();
	var len = lightProbes.length - this._lightProbesOffset;
	var addDiff = this.usesProbesForDiffuse();
	var addSpec = (this._pMethodSetup._iSpecularMethod && this.usesProbesForSpecular());
	if (!(addDiff || addSpec))
		return;
	if (len > this._pNumLightProbes) {
		len = this._pNumLightProbes;
	}
	for (var i = 0; i < len; ++i) {
		probe = lightProbes[this._lightProbesOffset + i];
		if (addDiff) {
			context.setTextureAt(this._pLightProbeDiffuseIndices[i], probe.get_diffuseMap().getTextureForStage3D(stage3DProxy));
		}
		if (addSpec) {
			context.setTextureAt(this._pLightProbeSpecularIndices[i], probe.get_specularMap().getTextureForStage3D(stage3DProxy));
		}
	}
	for (i = 0; i < len; ++i)
		this._pFragmentConstantData[this._pProbeWeightsIndex + i] = weights[this._lightProbesOffset + i];
};

$inherit(away.materials.passes.LightingPass, away.materials.passes.CompiledPass);

away.materials.passes.LightingPass.className = "away.materials.passes.LightingPass";

away.materials.passes.LightingPass.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.materials.compilation.LightingShaderCompiler');
	p.push('away.materials.lightpickers.LightPickerBase');
	p.push('away.materials.LightSources');
	return p;
};

away.materials.passes.LightingPass.getStaticDependencies = function(t) {
	var p;
	p = [];
	p.push('away.utils.VectorInit');
	return p;
};

away.materials.passes.LightingPass.injectionPoints = function(t) {
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

