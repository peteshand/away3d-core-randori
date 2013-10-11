/** Compiled by the Randori compiler v0.2.5.2 on Sat Oct 12 02:16:07 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.materials == "undefined")
	away.materials = {};
if (typeof away.materials.methods == "undefined")
	away.materials.methods = {};

away.materials.methods.SimpleShadowMapMethodBase = function(castingLight) {
	this._pUsePoint = false;
	this._pDepthMapCoordReg = null;
	this._pUsePoint = (castingLight instanceof away.lights.PointLight);
	away.materials.methods.ShadowMapMethodBase.call(this, castingLight);
};

away.materials.methods.SimpleShadowMapMethodBase.prototype.iInitVO = function(vo) {
	vo.needsView = true;
	vo.needsGlobalVertexPos = true;
	vo.needsGlobalFragmentPos = this._pUsePoint;
	vo.needsNormals = vo.numLights > 0;
};

away.materials.methods.SimpleShadowMapMethodBase.prototype.iInitConstants = function(vo) {
	var fragmentData = vo.fragmentData;
	var vertexData = vo.vertexData;
	var index = vo.fragmentConstantsIndex;
	fragmentData[index] = 1.0;
	fragmentData[index + 1] = 1 / 255.0;
	fragmentData[index + 2] = 1 / 65025.0;
	fragmentData[index + 3] = 1 / 16581375.0;
	fragmentData[index + 6] = 0;
	fragmentData[index + 7] = 1;
	if (this._pUsePoint) {
		fragmentData[index + 8] = 0;
		fragmentData[index + 9] = 0;
		fragmentData[index + 10] = 0;
		fragmentData[index + 11] = 1;
	}
	index = vo.vertexConstantsIndex;
	if (index != -1) {
		vertexData[index] = .5;
		vertexData[index + 1] = -.5;
		vertexData[index + 2] = 0.0;
		vertexData[index + 3] = 1.0;
	}
};

away.materials.methods.SimpleShadowMapMethodBase.prototype.get__iDepthMapCoordReg = function() {
	return this._pDepthMapCoordReg;
};

away.materials.methods.SimpleShadowMapMethodBase.prototype.set__iDepthMapCoordReg = function(value) {
	this._pDepthMapCoordReg = value;
};

away.materials.methods.SimpleShadowMapMethodBase.prototype.iCleanCompilationData = function() {
	away.materials.methods.ShadowMapMethodBase.prototype.iCleanCompilationData.call(this);
	this._pDepthMapCoordReg = null;
};

away.materials.methods.SimpleShadowMapMethodBase.prototype.iGetVertexCode = function(vo, regCache) {
	return this._pUsePoint ? this._pGetPointVertexCode(vo, regCache) : this.pGetPlanarVertexCode(vo, regCache);
};

away.materials.methods.SimpleShadowMapMethodBase.prototype._pGetPointVertexCode = function(vo, regCache) {
	vo.vertexConstantsIndex = -1;
	return "";
};

away.materials.methods.SimpleShadowMapMethodBase.prototype.pGetPlanarVertexCode = function(vo, regCache) {
	var code = "";
	var temp = regCache.getFreeVertexVectorTemp();
	var dataReg = regCache.getFreeVertexConstant();
	var depthMapProj = regCache.getFreeVertexConstant();
	regCache.getFreeVertexConstant();
	regCache.getFreeVertexConstant();
	regCache.getFreeVertexConstant();
	this._pDepthMapCoordReg = regCache.getFreeVarying();
	vo.vertexConstantsIndex = dataReg.get_index() * 4;
	code += "m44 " + temp + ", " + this._sharedRegisters.globalPositionVertex + ", " + depthMapProj + "\n" + "div " + temp + ", " + temp + ", " + temp + ".w\n" + "mul " + temp + ".xy, " + temp + ".xy, " + dataReg + ".xy\n" + "add " + this._pDepthMapCoordReg + ", " + temp + ", " + dataReg + ".xxwz\n";
	return code;
};

away.materials.methods.SimpleShadowMapMethodBase.prototype.iGetFragmentCode = function(vo, regCache, targetReg) {
	var code = this._pUsePoint ? this._pGetPointFragmentCode(vo, regCache, targetReg) : this._pGetPlanarFragmentCode(vo, regCache, targetReg);
	code += "add " + targetReg + ".w, " + targetReg + ".w, fc" + (vo.fragmentConstantsIndex / 4 + 1) + ".y\n" + "sat " + targetReg + ".w, " + targetReg + ".w\n";
	return code;
};

away.materials.methods.SimpleShadowMapMethodBase.prototype._pGetPlanarFragmentCode = function(vo, regCache, targetReg) {
	throw new away.errors.AbstractMethodError(null, 0);
	return "";
};

away.materials.methods.SimpleShadowMapMethodBase.prototype._pGetPointFragmentCode = function(vo, regCache, targetReg) {
	throw new away.errors.AbstractMethodError(null, 0);
	return "";
};

away.materials.methods.SimpleShadowMapMethodBase.prototype.iSetRenderState = function(vo, renderable, stage3DProxy, camera) {
	if (!this._pUsePoint)
		this._pShadowMapper.get_iDepthProjection().copyRawDataTo(vo.vertexData, vo.vertexConstantsIndex + 4, true);
};

away.materials.methods.SimpleShadowMapMethodBase.prototype._iGetCascadeFragmentCode = function(vo, regCache, decodeRegister, depthTexture, depthProjection, targetRegister) {
	throw new Error("This shadow method is incompatible with cascade shadows", 0);
};

away.materials.methods.SimpleShadowMapMethodBase.prototype.iActivate = function(vo, stage3DProxy) {
	var fragmentData = vo.fragmentData;
	var index = vo.fragmentConstantsIndex;
	if (this._pUsePoint)
		fragmentData[index + 4] = -Math.pow(1 / (this._pCastingLight.get_fallOff() * this._pEpsilon), 2);
	else
		vo.vertexData[vo.vertexConstantsIndex + 3] = -1 / (this._pShadowMapper.get_depth() * this._pEpsilon);
	fragmentData[index + 5] = 1 - this._pAlpha;
	if (this._pUsePoint) {
		var pos = this._pCastingLight.get_scenePosition();
		fragmentData[index + 8] = pos.x;
		fragmentData[index + 9] = pos.y;
		fragmentData[index + 10] = pos.z;
		var f = this._pCastingLight.get_fallOff();
		fragmentData[index + 11] = 1 / (2 * f * f);
	}
	stage3DProxy._iContext3D.setTextureAt(vo.texturesIndex, this._pCastingLight.get_shadowMapper().get_depthMap().getTextureForStage3D(stage3DProxy));
};

away.materials.methods.SimpleShadowMapMethodBase.prototype.iActivateForCascade = function(vo, stage3DProxy) {
	throw new Error("This shadow method is incompatible with cascade shadows", 0);
};

$inherit(away.materials.methods.SimpleShadowMapMethodBase, away.materials.methods.ShadowMapMethodBase);

away.materials.methods.SimpleShadowMapMethodBase.className = "away.materials.methods.SimpleShadowMapMethodBase";

away.materials.methods.SimpleShadowMapMethodBase.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.lights.PointLight');
	p.push('away.errors.AbstractMethodError');
	p.push('away.materials.methods.MethodVO');
	return p;
};

away.materials.methods.SimpleShadowMapMethodBase.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.materials.methods.SimpleShadowMapMethodBase.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'castingLight', t:'away.lights.LightBase'});
			break;
		case 1:
			p = away.materials.methods.ShadowMapMethodBase.injectionPoints(t);
			break;
		case 2:
			p = away.materials.methods.ShadowMapMethodBase.injectionPoints(t);
			break;
		case 3:
			p = away.materials.methods.ShadowMapMethodBase.injectionPoints(t);
			break;
		default:
			p = [];
			break;
	}
	return p;
};

