/** Compiled by the Randori compiler v0.2.6.2 on Tue Sep 24 23:06:42 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.materials == "undefined")
	away.materials = {};
if (typeof away.materials.compilation == "undefined")
	away.materials.compilation = {};

away.materials.compilation.MethodDependencyCounter = function() {
this._tangentDependencies = 0;
this._usesGlobalPosFragment = false;
this._lightSourceMask = 0;
this._uvDependencies = 0;
this._secondaryUVDependencies = 0;
this._numPointLights = 0;
this._normalDependencies = 0;
this._projectionDependencies = 0;
this._globalPosDependencies = 0;
this._viewDirDependencies = 0;
};

away.materials.compilation.MethodDependencyCounter.prototype.reset = function() {
	this._projectionDependencies = 0;
	this._normalDependencies = 0;
	this._viewDirDependencies = 0;
	this._uvDependencies = 0;
	this._secondaryUVDependencies = 0;
	this._globalPosDependencies = 0;
	this._tangentDependencies = 0;
	this._usesGlobalPosFragment = false;
};

away.materials.compilation.MethodDependencyCounter.prototype.setPositionedLights = function(numPointLights, lightSourceMask) {
	this._numPointLights = numPointLights;
	this._lightSourceMask = lightSourceMask;
};

away.materials.compilation.MethodDependencyCounter.prototype.includeMethodVO = function(methodVO) {
	if (methodVO.needsProjection) {
		++this._projectionDependencies;
	}
	if (methodVO.needsGlobalVertexPos) {
		++this._globalPosDependencies;
		if (methodVO.needsGlobalFragmentPos) {
			this._usesGlobalPosFragment = true;
		}
	} else if (methodVO.needsGlobalFragmentPos) {
		++this._globalPosDependencies;
		this._usesGlobalPosFragment = true;
	}
	if (methodVO.needsNormals) {
		++this._normalDependencies;
	}
	if (methodVO.needsTangents) {
		++this._tangentDependencies;
	}
	if (methodVO.needsView) {
		++this._viewDirDependencies;
	}
	if (methodVO.needsUV) {
		++this._uvDependencies;
	}
	if (methodVO.needsSecondaryUV) {
		++this._secondaryUVDependencies;
	}
};

away.materials.compilation.MethodDependencyCounter.prototype.get_tangentDependencies = function() {
	return this._tangentDependencies;
};

away.materials.compilation.MethodDependencyCounter.prototype.get_usesGlobalPosFragment = function() {
	return this._usesGlobalPosFragment;
};

away.materials.compilation.MethodDependencyCounter.prototype.get_projectionDependencies = function() {
	return this._projectionDependencies;
};

away.materials.compilation.MethodDependencyCounter.prototype.get_normalDependencies = function() {
	return this._normalDependencies;
};

away.materials.compilation.MethodDependencyCounter.prototype.get_viewDirDependencies = function() {
	return this._viewDirDependencies;
};

away.materials.compilation.MethodDependencyCounter.prototype.get_uvDependencies = function() {
	return this._uvDependencies;
};

away.materials.compilation.MethodDependencyCounter.prototype.get_secondaryUVDependencies = function() {
	return this._secondaryUVDependencies;
};

away.materials.compilation.MethodDependencyCounter.prototype.get_globalPosDependencies = function() {
	return this._globalPosDependencies;
};

away.materials.compilation.MethodDependencyCounter.prototype.addWorldSpaceDependencies = function(fragmentLights) {
	if (this._viewDirDependencies > 0) {
		++this._globalPosDependencies;
	}
	if (this._numPointLights > 0 && (this._lightSourceMask & away.materials.LightSources.LIGHTS)) {
		++this._globalPosDependencies;
		if (fragmentLights) {
			this._usesGlobalPosFragment = true;
		}
	}
};

away.materials.compilation.MethodDependencyCounter.className = "away.materials.compilation.MethodDependencyCounter";

away.materials.compilation.MethodDependencyCounter.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.materials.LightSources');
	return p;
};

away.materials.compilation.MethodDependencyCounter.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.materials.compilation.MethodDependencyCounter.injectionPoints = function(t) {
	return [];
};
