/** Compiled by the Randori compiler v0.2.6.2 on Thu Sep 05 22:19:24 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.materials == "undefined")
	away.materials = {};
if (typeof away.materials.passes == "undefined")
	away.materials.passes = {};

away.materials.passes.SkyBoxPass = function() {
	this._vertexData = null;
	this._cubeTexture = null;
	away.materials.passes.MaterialPassBase.call(thisfalse);
	this.set_mipmap(false);
	this._pNumUsedTextures = 1;
	this._vertexData = [0, 0, 0, 0, 1, 1, 1, 1];
};

away.materials.passes.SkyBoxPass.prototype.get_cubeTexture = function() {
	return this._cubeTexture;
};

away.materials.passes.SkyBoxPass.prototype.set_cubeTexture = function(value) {
	this._cubeTexture = value;
};

away.materials.passes.SkyBoxPass.prototype.iGetVertexCode = function() {
	return "mul vt0, va0, vc5\t\t\n" + "add vt0, vt0, vc4\t\t\n" + "m44 op, vt0, vc0\t\t\n" + "mov v0, va0\n";
};

away.materials.passes.SkyBoxPass.prototype.iGetFragmentCode = function(animationCode) {
	var format;
	switch (this._cubeTexture.get_format()) {
		case away.display3D.Context3DTextureFormat.COMPRESSED:
			format = "dxt1,";
			break;
		case "compressedAlpha":
			format = "dxt5,";
			break;
		default:
			format = "";
	}
	var mip = ",mipnone";
	if (this._cubeTexture.get_hasMipMaps()) {
		mip = ",miplinear";
	}
	return "tex ft0, v0, fs0 <cube," + format + "linear,clamp" + mip + ">\t\n" + "mov oc, ft0\t\t\t\t\t\t\t\n";
};

away.materials.passes.SkyBoxPass.prototype.iRender = function(renderable, stage3DProxy, camera, viewProjection) {
	var context = stage3DProxy._iContext3D;
	var pos = camera.get_scenePosition();
	this._vertexData[0] = pos.x;
	this._vertexData[1] = pos.y;
	this._vertexData[2] = pos.z;
	this._vertexData[4] = this._vertexData[5] = this._vertexData[6] = camera.get_lens().get_far() / Math.sqrt(3);
	context.setProgramConstantsFromMatrix(away.display3D.Context3DProgramType.VERTEX, 0, viewProjection, true);
	context.setProgramConstantsFromArray(away.display3D.Context3DProgramType.VERTEX, 4, this._vertexData, 2);
	renderable.activateVertexBuffer(0, stage3DProxy);
	context.drawTriangles(renderable.getIndexBuffer(stage3DProxy), 0, renderable.get_numTriangles());
};

away.materials.passes.SkyBoxPass.prototype.iActivate = function(stage3DProxy, camera) {
	away.materials.passes.MaterialPassBase.prototype.iActivate.call(this,stage3DProxy, camera);
	var context = stage3DProxy._iContext3D;
	context.setDepthTest(false, away.display3D.Context3DCompareMode.LESS);
	context.setTextureAt(0, this._cubeTexture.getTextureForStage3D(stage3DProxy));
};

$inherit(away.materials.passes.SkyBoxPass, away.materials.passes.MaterialPassBase);

away.materials.passes.SkyBoxPass.className = "away.materials.passes.SkyBoxPass";

away.materials.passes.SkyBoxPass.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('*away.base.IRenderable');
	p.push('away.display3D.Context3DProgramType');
	p.push('away.display3D.Context3DTextureFormat');
	p.push('away.display3D.Context3DCompareMode');
	return p;
};

away.materials.passes.SkyBoxPass.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.materials.passes.SkyBoxPass.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 1:
			p = away.materials.passes.MaterialPassBase.injectionPoints(t);
			break;
		case 2:
			p = away.materials.passes.MaterialPassBase.injectionPoints(t);
			break;
		case 3:
			p = away.materials.passes.MaterialPassBase.injectionPoints(t);
			break;
		default:
			p = [];
			break;
	}
	return p;
};

