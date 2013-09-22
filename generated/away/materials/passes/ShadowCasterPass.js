/** Compiled by the Randori compiler v0.2.6.2 on Sun Sep 22 12:28:45 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.materials == "undefined")
	away.materials = {};
if (typeof away.materials.passes == "undefined")
	away.materials.passes = {};

away.materials.passes.ShadowCasterPass = function(material) {
	this._inverseSceneMatrix = away.utils.VectorNumber.init(0, 0);
	this._lightVertexConstantIndex = 0;
	this._tangentSpace = null;
	away.materials.passes.CompiledPass.call(this, material);
};

away.materials.passes.ShadowCasterPass.prototype.pCreateCompiler = function(profile) {
	return new away.materials.compilation.LightingShaderCompiler(profile);
};

away.materials.passes.ShadowCasterPass.prototype.pUpdateLights = function() {
	away.materials.passes.CompiledPass.prototype.pUpdateLights.call(this);
	var numPointLights = 0;
	var numDirectionalLights = 0;
	if (this._pLightPicker) {
		numPointLights = this._pLightPicker.get_numCastingPointLights() > 0 ? 1 : 0;
		numDirectionalLights = this._pLightPicker.get_numCastingDirectionalLights() > 0 ? 1 : 0;
	} else {
		numPointLights = 0;
		numDirectionalLights = 0;
	}
	this._pNumLightProbes = 0;
	if (numPointLights + numDirectionalLights > 1) {
		throw new Error("Must have exactly one light!", 0);
	}
	if (numPointLights != this._pNumPointLights || numDirectionalLights != this._pNumDirectionalLights) {
		this._pNumPointLights = numPointLights;
		this._pNumDirectionalLights = numDirectionalLights;
		this.iInvalidateShaderProgram(true);
	}
};

away.materials.passes.ShadowCasterPass.prototype.pUpdateShaderProperties = function() {
	away.materials.passes.CompiledPass.prototype.pUpdateShaderProperties.call(this);
	var c = this._pCompiler;
	this._tangentSpace = c.get_tangentSpace();
};

away.materials.passes.ShadowCasterPass.prototype.pUpdateRegisterIndices = function() {
	away.materials.passes.CompiledPass.prototype.pUpdateRegisterIndices.call(this);
	var c = this._pCompiler;
	this._lightVertexConstantIndex = c.get_lightVertexConstantIndex();
};

away.materials.passes.ShadowCasterPass.prototype.iRender = function(renderable, stage3DProxy, camera, viewProjection) {
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

away.materials.passes.ShadowCasterPass.prototype.iActivate = function(stage3DProxy, camera) {
	away.materials.passes.CompiledPass.prototype.iActivate.call(this,stage3DProxy, camera);
	if (!this._tangentSpace && this._pCameraPositionIndex >= 0) {
		var pos = camera.get_scenePosition();
		this._pVertexConstantData[this._pCameraPositionIndex] = pos.x;
		this._pVertexConstantData[this._pCameraPositionIndex + 1] = pos.y;
		this._pVertexConstantData[this._pCameraPositionIndex + 2] = pos.z;
	}
};

away.materials.passes.ShadowCasterPass.prototype.pUpdateLightConstants = function() {
	var dirLight;
	var pointLight;
	var k = 0;
	var l = 0;
	var dirPos;
	l = this._lightVertexConstantIndex;
	k = this._pLightFragmentConstantIndex;
	if (this._pNumDirectionalLights > 0) {
		dirLight = this._pLightPicker.get_castingDirectionalLights()[0];
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
		return;
	}
	if (this._pNumPointLights > 0) {
		pointLight = this._pLightPicker.get_castingPointLights()[0];
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
		this._pFragmentConstantData[k++] = pointLight._pRadius * pointLight._pRadius;
		this._pFragmentConstantData[k++] = pointLight._iSpecularR;
		this._pFragmentConstantData[k++] = pointLight._iSpecularG;
		this._pFragmentConstantData[k++] = pointLight._iSpecularB;
		this._pFragmentConstantData[k++] = pointLight._pFallOffFactor;
	}
};

away.materials.passes.ShadowCasterPass.prototype.pUsesProbes = function() {
	return false;
};

away.materials.passes.ShadowCasterPass.prototype.pUsesLights = function() {
	return true;
};

away.materials.passes.ShadowCasterPass.prototype.pUpdateProbes = function(stage3DProxy) {
};

$inherit(away.materials.passes.ShadowCasterPass, away.materials.passes.CompiledPass);

away.materials.passes.ShadowCasterPass.className = "away.materials.passes.ShadowCasterPass";

away.materials.passes.ShadowCasterPass.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.materials.compilation.LightingShaderCompiler');
	return p;
};

away.materials.passes.ShadowCasterPass.getStaticDependencies = function(t) {
	var p;
	p = [];
	p.push('away.utils.VectorNumber');
	return p;
};

away.materials.passes.ShadowCasterPass.injectionPoints = function(t) {
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

