/** Compiled by the Randori compiler v0.2.6.2 on Sun Sep 22 12:31:04 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.materials == "undefined")
	away.materials = {};
if (typeof away.materials.passes == "undefined")
	away.materials.passes = {};

away.materials.passes.DepthMapPass = function() {
	this._alphaMask = null;
	this._data = null;
	this._alphaThreshold = 0;
	away.materials.passes.MaterialPassBase.call(this, false);
	this._data = [1, 255.0, 65025.0, 16581375.0, 1.0 / 255.0, 1.0 / 255.0, 1.0 / 255.0, 0.0, 0.0, 0.0, 0, 0];
};

away.materials.passes.DepthMapPass.prototype.get_alphaThreshold = function() {
	return this._alphaThreshold;
};

away.materials.passes.DepthMapPass.prototype.set_alphaThreshold = function(value) {
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
	this._data[8] = this._alphaThreshold;
};

away.materials.passes.DepthMapPass.prototype.get_alphaMask = function() {
	return this._alphaMask;
};

away.materials.passes.DepthMapPass.prototype.set_alphaMask = function(value) {
	this._alphaMask = value;
};

away.materials.passes.DepthMapPass.prototype.iGetVertexCode = function() {
	var code = "";
	code = "m44 vt1, vt0, vc0\t\t\n" + "mov op, vt1\t\n";
	if (this._alphaThreshold > 0) {
		this._pNumUsedTextures = 1;
		this._pNumUsedStreams = 2;
		code += "mov v0, vt1\n" + "mov v1, va1\n";
	} else {
		this._pNumUsedTextures = 0;
		this._pNumUsedStreams = 1;
		code += "mov v0, vt1\n";
	}
	return code;
};

away.materials.passes.DepthMapPass.prototype.iGetFragmentCode = function(code) {
	var wrap = this._pRepeat ? "wrap" : "clamp";
	var filter;
	if (this._pSmooth) {
		filter = this._pMipmap ? "linear,miplinear" : "linear";
	} else {
		filter = this._pMipmap ? "nearest,mipnearest" : "nearest";
	}
	var codeF = "div ft2, v0, v0.w\t\t\n" + "mul ft0, fc0, ft2.z\t\n" + "frc ft0, ft0\t\t\t\n" + "mul ft1, ft0.yzww, fc1\t\n";
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
		codeF += "tex ft3, v1, fs0 <2d," + filter + "," + format + wrap + ">\n" + "sub ft3.w, ft3.w, fc2.x\n" + "kil ft3.w\n";
	}
	codeF += "sub oc, ft0, ft1\t\t\n";
	return codeF;
};

away.materials.passes.DepthMapPass.prototype.iRender = function(renderable, stage3DProxy, camera, viewProjection) {
	if (this._alphaThreshold > 0) {
		renderable.activateUVBuffer(1, stage3DProxy);
	}
	var context = stage3DProxy._iContext3D;
	var matrix = away.math.Matrix3DUtils.CALCULATION_MATRIX;
	matrix.copyFrom(renderable.getRenderSceneTransform(camera));
	matrix.append(viewProjection);
	context.setProgramConstantsFromMatrix(away.display3D.Context3DProgramType.VERTEX, 0, matrix, true);
	renderable.activateVertexBuffer(0, stage3DProxy);
	context.drawTriangles(renderable.getIndexBuffer(stage3DProxy), 0, renderable.get_numTriangles());
};

away.materials.passes.DepthMapPass.prototype.iActivate = function(stage3DProxy, camera) {
	var context = stage3DProxy._iContext3D;
	away.materials.passes.MaterialPassBase.prototype.iActivate.call(this,stage3DProxy, camera);
	if (this._alphaThreshold > 0) {
		context.setTextureAt(0, this._alphaMask.getTextureForStage3D(stage3DProxy));
		context.setProgramConstantsFromArray(away.display3D.Context3DProgramType.FRAGMENT, 0, this._data, 3);
	} else {
		context.setProgramConstantsFromArray(away.display3D.Context3DProgramType.FRAGMENT, 0, this._data, 2);
	}
};

$inherit(away.materials.passes.DepthMapPass, away.materials.passes.MaterialPassBase);

away.materials.passes.DepthMapPass.className = "away.materials.passes.DepthMapPass";

away.materials.passes.DepthMapPass.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('*away.base.IRenderable');
	p.push('away.display3D.Context3DProgramType');
	p.push('away.math.Matrix3DUtils');
	p.push('away.display3D.Context3DTextureFormat');
	return p;
};

away.materials.passes.DepthMapPass.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.materials.passes.DepthMapPass.injectionPoints = function(t) {
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

