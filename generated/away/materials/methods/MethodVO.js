/** Compiled by the Randori compiler v0.2.6.2 on Tue Sep 10 22:28:11 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.materials == "undefined")
	away.materials = {};
if (typeof away.materials.methods == "undefined")
	away.materials.methods = {};

away.materials.methods.MethodVO = function() {
this.fragmentConstantsIndex = 0;
this.needsUV = null;
this.needsTangents = null;
this.useMipmapping = null;
this.numLights = 0;
this.repeatTextures = null;
this.fragmentData = null;
this.needsNormals = null;
this.vertexConstantsIndex = 0;
this.needsGlobalFragmentPos = null;
this.secondaryTexturesIndex = 0;
this.useSmoothTextures = null;
this.needsGlobalVertexPos = null;
this.useLightFallOff = true;
this.secondaryVertexConstantsIndex = 0;
this.needsView = null;
this.needsProjection = null;
this.needsSecondaryUV = null;
this.vertexData = null;
this.secondaryFragmentConstantsIndex = 0;
this.texturesIndex = 0;
};

away.materials.methods.MethodVO.prototype.reset = function() {
	this.texturesIndex = -1;
	this.vertexConstantsIndex = -1;
	this.fragmentConstantsIndex = -1;
	this.useMipmapping = true;
	this.useSmoothTextures = true;
	this.repeatTextures = false;
	this.needsProjection = false;
	this.needsView = false;
	this.needsNormals = false;
	this.needsTangents = false;
	this.needsUV = false;
	this.needsSecondaryUV = false;
	this.needsGlobalVertexPos = false;
	this.needsGlobalFragmentPos = false;
	this.numLights = 0;
	this.useLightFallOff = true;
};

away.materials.methods.MethodVO.className = "away.materials.methods.MethodVO";

away.materials.methods.MethodVO.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.materials.methods.MethodVO.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.materials.methods.MethodVO.injectionPoints = function(t) {
	return [];
};
