/** Compiled by the Randori compiler v0.2.5.2 on Sat Oct 12 02:16:07 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.materials == "undefined")
	away.materials = {};
if (typeof away.materials.methods == "undefined")
	away.materials.methods = {};

away.materials.methods.FilteredShadowMapMethod = function(castingLight) {
	away.materials.methods.SimpleShadowMapMethodBase.call(this, castingLight);
};

away.materials.methods.FilteredShadowMapMethod.prototype.iInitConstants = function(vo) {
	away.materials.methods.SimpleShadowMapMethodBase.prototype.iInitConstants.call(this,vo);
	var fragmentData = vo.fragmentData;
	var index = vo.fragmentConstantsIndex;
	fragmentData[index + 8] = .5;
	var size = this.get_castingLight().get_shadowMapper().get_depthMapSize();
	fragmentData[index + 9] = size;
	fragmentData[index + 10] = 1 / size;
};

away.materials.methods.FilteredShadowMapMethod.prototype._pGetPlanarFragmentCode = function(vo, regCache, targetReg) {
	var depthMapRegister = regCache.getFreeTextureReg();
	var decReg = regCache.getFreeFragmentConstant();
	var dataReg = regCache.getFreeFragmentConstant();
	dataReg = dataReg;
	var customDataReg = regCache.getFreeFragmentConstant();
	var depthCol = regCache.getFreeFragmentVectorTemp();
	var uvReg;
	var code = "";
	vo.fragmentConstantsIndex = decReg.get_index() * 4;
	regCache.addFragmentTempUsages(depthCol, 1);
	uvReg = regCache.getFreeFragmentVectorTemp();
	regCache.addFragmentTempUsages(uvReg, 1);
	code += "mov " + uvReg + ", " + this._pDepthMapCoordReg + "\n" + "tex " + depthCol + ", " + this._pDepthMapCoordReg + ", " + depthMapRegister + " <2d, nearest, clamp>\n" + "dp4 " + depthCol + ".z, " + depthCol + ", " + decReg + "\n" + "slt " + uvReg + ".z, " + this._pDepthMapCoordReg + ".z, " + depthCol + ".z\n" + "add " + uvReg + ".x, " + this._pDepthMapCoordReg + ".x, " + customDataReg + ".z\n" + "tex " + depthCol + ", " + uvReg + ", " + depthMapRegister + " <2d, nearest, clamp>\n" + "dp4 " + depthCol + ".z, " + depthCol + ", " + decReg + "\n" + "slt " + uvReg + ".w, " + this._pDepthMapCoordReg + ".z, " + depthCol + ".z\n" + "mul " + depthCol + ".x, " + this._pDepthMapCoordReg + ".x, " + customDataReg + ".y\n" + "frc " + depthCol + ".x, " + depthCol + ".x\n" + "sub " + uvReg + ".w, " + uvReg + ".w, " + uvReg + ".z\n" + "mul " + uvReg + ".w, " + uvReg + ".w, " + depthCol + ".x\n" + "add " + targetReg + ".w, " + uvReg + ".z, " + uvReg + ".w\n" + "mov " + uvReg + ".x, " + this._pDepthMapCoordReg + ".x\n" + "add " + uvReg + ".y, " + this._pDepthMapCoordReg + ".y, " + customDataReg + ".z\n" + "tex " + depthCol + ", " + uvReg + ", " + depthMapRegister + " <2d, nearest, clamp>\n" + "dp4 " + depthCol + ".z, " + depthCol + ", " + decReg + "\n" + "slt " + uvReg + ".z, " + this._pDepthMapCoordReg + ".z, " + depthCol + ".z\n" + "add " + uvReg + ".x, " + this._pDepthMapCoordReg + ".x, " + customDataReg + ".z\n" + "tex " + depthCol + ", " + uvReg + ", " + depthMapRegister + " <2d, nearest, clamp>\n" + "dp4 " + depthCol + ".z, " + depthCol + ", " + decReg + "\n" + "slt " + uvReg + ".w, " + this._pDepthMapCoordReg + ".z, " + depthCol + ".z\n" + "mul " + depthCol + ".x, " + this._pDepthMapCoordReg + ".x, " + customDataReg + ".y\n" + "frc " + depthCol + ".x, " + depthCol + ".x\n" + "sub " + uvReg + ".w, " + uvReg + ".w, " + uvReg + ".z\n" + "mul " + uvReg + ".w, " + uvReg + ".w, " + depthCol + ".x\n" + "add " + uvReg + ".w, " + uvReg + ".z, " + uvReg + ".w\n" + "mul " + depthCol + ".x, " + this._pDepthMapCoordReg + ".y, " + customDataReg + ".y\n" + "frc " + depthCol + ".x, " + depthCol + ".x\n" + "sub " + uvReg + ".w, " + uvReg + ".w, " + targetReg + ".w\n" + "mul " + uvReg + ".w, " + uvReg + ".w, " + depthCol + ".x\n" + "add " + targetReg + ".w, " + targetReg + ".w, " + uvReg + ".w\n";
	regCache.removeFragmentTempUsage(depthCol);
	regCache.removeFragmentTempUsage(uvReg);
	vo.texturesIndex = depthMapRegister.get_index();
	return code;
};

away.materials.methods.FilteredShadowMapMethod.prototype.iActivateForCascade = function(vo, stage3DProxy) {
	var size = this.get_castingLight().get_shadowMapper().get_depthMapSize();
	var index = vo.secondaryFragmentConstantsIndex;
	var data = vo.fragmentData;
	data[index] = size;
	data[index + 1] = 1 / size;
};

away.materials.methods.FilteredShadowMapMethod.prototype._iGetCascadeFragmentCode = function(vo, regCache, decodeRegister, depthTexture, depthProjection, targetRegister) {
	var code;
	var dataReg = regCache.getFreeFragmentConstant();
	vo.secondaryFragmentConstantsIndex = dataReg.get_index() * 4;
	var temp = regCache.getFreeFragmentVectorTemp();
	regCache.addFragmentTempUsages(temp, 1);
	var predicate = regCache.getFreeFragmentVectorTemp();
	regCache.addFragmentTempUsages(predicate, 1);
	code = "tex " + temp + ", " + depthProjection + ", " + depthTexture + " <2d, nearest, clamp>\n" + "dp4 " + temp + ".z, " + temp + ", " + decodeRegister + "\n" + "slt " + predicate + ".x, " + depthProjection + ".z, " + temp + ".z\n" + "add " + depthProjection + ".x, " + depthProjection + ".x, " + dataReg + ".y\n" + "tex " + temp + ", " + depthProjection + ", " + depthTexture + " <2d, nearest, clamp>\n" + "dp4 " + temp + ".z, " + temp + ", " + decodeRegister + "\n" + "slt " + predicate + ".z, " + depthProjection + ".z, " + temp + ".z\n" + "add " + depthProjection + ".y, " + depthProjection + ".y, " + dataReg + ".y\n" + "tex " + temp + ", " + depthProjection + ", " + depthTexture + " <2d, nearest, clamp>\n" + "dp4 " + temp + ".z, " + temp + ", " + decodeRegister + "\n" + "slt " + predicate + ".w, " + depthProjection + ".z, " + temp + ".z\n" + "sub " + depthProjection + ".x, " + depthProjection + ".x, " + dataReg + ".y\n" + "tex " + temp + ", " + depthProjection + ", " + depthTexture + " <2d, nearest, clamp>\n" + "dp4 " + temp + ".z, " + temp + ", " + decodeRegister + "\n" + "slt " + predicate + ".y, " + depthProjection + ".z, " + temp + ".z\n" + "mul " + temp + ".xy, " + depthProjection + ".xy, " + dataReg + ".x\n" + "frc " + temp + ".xy, " + temp + ".xy\n" + "sub " + depthProjection + ", " + predicate + ".xyzw, " + predicate + ".zwxy\n" + "mul " + depthProjection + ", " + depthProjection + ", " + temp + ".x\n" + "add " + predicate + ".xy, " + predicate + ".xy, " + depthProjection + ".zw\n" + "sub " + predicate + ".y, " + predicate + ".y, " + predicate + ".x\n" + "mul " + predicate + ".y, " + predicate + ".y, " + temp + ".y\n" + "add " + targetRegister + ".w, " + predicate + ".x, " + predicate + ".y\n";
	regCache.removeFragmentTempUsage(temp);
	regCache.removeFragmentTempUsage(predicate);
	return code;
};

$inherit(away.materials.methods.FilteredShadowMapMethod, away.materials.methods.SimpleShadowMapMethodBase);

away.materials.methods.FilteredShadowMapMethod.className = "away.materials.methods.FilteredShadowMapMethod";

away.materials.methods.FilteredShadowMapMethod.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.materials.methods.FilteredShadowMapMethod.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.materials.methods.FilteredShadowMapMethod.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'castingLight', t:'away.lights.DirectionalLight'});
			break;
		case 1:
			p = away.materials.methods.SimpleShadowMapMethodBase.injectionPoints(t);
			break;
		case 2:
			p = away.materials.methods.SimpleShadowMapMethodBase.injectionPoints(t);
			break;
		case 3:
			p = away.materials.methods.SimpleShadowMapMethodBase.injectionPoints(t);
			break;
		default:
			p = [];
			break;
	}
	return p;
};

