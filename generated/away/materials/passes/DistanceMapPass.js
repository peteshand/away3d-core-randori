/** Compiled by the Randori compiler v0.2.6.2 on Thu Sep 05 22:19:24 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.materials == "undefined")
	away.materials = {};
if (typeof away.materials.passes == "undefined")
	away.materials.passes = {};

away.materials.passes.DistanceMapPass = function() {
	this._alphaMask = null;
	this._vertexData = null;
	this._fragmentData = null;
	this._alphaThreshold = 0;
	away.materials.passes.MaterialPassBase.call(thisfalse);
	this._fragmentData = [1.0, 255.0, 65025.0, 16581375.0, 1.0 / 255.0, 1.0 / 255.0, 1.0 / 255.0, 0.0, 0.0, 0.0, 0.0, 0.0];
	this._vertexData = [0, 0, 0, 0];
	this._vertexData[3] = 1;
	this._pNumUsedVertexConstants = 9;
};

away.materials.passes.DistanceMapPass.prototype.get_alphaThreshold = function() {
	return this._alphaThreshold;
};

away.materials.passes.DistanceMapPass.prototype.set_alphaThreshold = function(value) {
	if (value < 0) {
		value = 0;
	} else if (value > 1) {
		value = 1;
	}
	if (value == this._alphaThreshold) {
		return;
	}
	if (value == 0 || this._alphaThreshold == 0) {
		this.iInvalidateShaderProgram(true);
	}
	this._alphaThreshold = value;
	this._fragmentData[8] = this._alphaThreshold;
};

away.materials.passes.DistanceMapPass.prototype.get_alphaMask = function() {
	return this._alphaMask;
};

away.materials.passes.DistanceMapPass.prototype.set_alphaMask = function(value) {
	this._alphaMask = value;
};

away.materials.passes.DistanceMapPass.prototype.iGetVertexCode = function() {
	var code;
	code = "m44 op, vt0, vc0\t\t\n" + "m44 vt1, vt0, vc5\t\t\n" + "sub v0, vt1, vc9\t\t\n";
	if (this._alphaThreshold > 0) {
		code += "mov v1, va1\n";
		this._pNumUsedTextures = 1;
		this._pNumUsedStreams = 2;
	} else {
		this._pNumUsedTextures = 0;
		this._pNumUsedStreams = 1;
	}
	return code;
};

away.materials.passes.DistanceMapPass.prototype.iGetFragmentCode = function(animationCode) {
	animationCode = animationCode;
	var code;
	var wrap = this._pRepeat ? "wrap" : "clamp";
	var filter;
	if (this._pSmooth) {
		filter = this._pMipmap ? "linear,miplinear" : "linear";
	} else {
		filter = this._pMipmap ? "nearest,mipnearest" : "nearest";
	}
	code = "dp3 ft2.z, v0.xyz, v0.xyz\t\n" + "mul ft0, fc0, ft2.z\t\n" + "frc ft0, ft0\t\t\t\n" + "mul ft1, ft0.yzww, fc1\t\n";
	if (this._alphaThreshold > 0) {
		var format;
		switch (this._alphaMask.get_format()) {
			case away.display3D.Context3DTextureFormat.COMPRESSED:
				format = "dxt1,";
				break;
			case "compressedAlpha":
				format = "dxt5,";
				break;
			default:
				format = "";
		}
		code += "tex ft3, v1, fs0 <2d," + filter + "," + format + wrap + ">\n" + "sub ft3.w, ft3.w, fc2.x\n" + "kil ft3.w\n";
	}
	code += "sub oc, ft0, ft1\t\t\n";
	return code;
};

away.materials.passes.DistanceMapPass.prototype.iRender = function(renderable, stage3DProxy, camera, viewProjection) {
	var context = stage3DProxy._iContext3D;
	var pos = camera.get_scenePosition();
	this._vertexData[0] = pos.x;
	this._vertexData[1] = pos.y;
	this._vertexData[2] = pos.z;
	this._vertexData[3] = 1;
	var sceneTransform = renderable.getRenderSceneTransform(camera);
	context.setProgramConstantsFromMatrix(away.display3D.Context3DProgramType.VERTEX, 5, sceneTransform, true);
	context.setProgramConstantsFromArray(away.display3D.Context3DProgramType.VERTEX, 9, this._vertexData, 1);
	if (this._alphaThreshold > 0) {
		renderable.activateUVBuffer(1, stage3DProxy);
	}
	var matrix = away.math.Matrix3DUtils.CALCULATION_MATRIX;
	matrix.copyFrom(sceneTransform);
	matrix.append(viewProjection);
	context.setProgramConstantsFromMatrix(away.display3D.Context3DProgramType.VERTEX, 0, matrix, true);
	renderable.activateVertexBuffer(0, stage3DProxy);
	context.drawTriangles(renderable.getIndexBuffer(stage3DProxy), 0, renderable.get_numTriangles());
};

away.materials.passes.DistanceMapPass.prototype.iActivate = function(stage3DProxy, camera) {
	var context = stage3DProxy._iContext3D;
	away.materials.passes.MaterialPassBase.prototype.iActivate.call(this,stage3DProxy, camera);
	var f = camera.get_lens().get_far();
	f = 1 / (2 * f * f);
	this._fragmentData[0] = 1 * f;
	this._fragmentData[1] = 255.0 * f;
	this._fragmentData[2] = 65025.0 * f;
	this._fragmentData[3] = 16581375.0 * f;
	if (this._alphaThreshold > 0) {
		context.setTextureAt(0, this._alphaMask.getTextureForStage3D(stage3DProxy));
		context.setProgramConstantsFromArray(away.display3D.Context3DProgramType.FRAGMENT, 0, this._fragmentData, 3);
	} else {
		context.setProgramConstantsFromArray(away.display3D.Context3DProgramType.FRAGMENT, 0, this._fragmentData, 2);
	}
};

$inherit(away.materials.passes.DistanceMapPass, away.materials.passes.MaterialPassBase);

away.materials.passes.DistanceMapPass.className = "away.materials.passes.DistanceMapPass";

away.materials.passes.DistanceMapPass.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('*away.base.IRenderable');
	p.push('away.math.Matrix3DUtils');
	p.push('away.display3D.Context3DProgramType');
	p.push('away.display3D.Context3DTextureFormat');
	return p;
};

away.materials.passes.DistanceMapPass.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.materials.passes.DistanceMapPass.injectionPoints = function(t) {
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

