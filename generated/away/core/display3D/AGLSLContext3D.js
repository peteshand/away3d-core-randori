/** Compiled by the Randori compiler v0.2.5.2 on Sat Oct 12 02:16:05 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.core == "undefined")
	away.core = {};
if (typeof away.core.display3D == "undefined")
	away.core.display3D = {};

away.core.display3D.AGLSLContext3D = function(canvas) {
	this._yFlip = -1;
	away.core.display3D.Context3D.call(this, canvas);
};

away.core.display3D.AGLSLContext3D.prototype.setProgramConstantsFromMatrix = function(programType, firstRegister, matrix, transposedMatrix) {
	var d = matrix.rawData;
	if (transposedMatrix) {
		this.setProgramConstantsFromArray(programType, firstRegister, [d[0], d[4], d[8], d[12]], 1);
		this.setProgramConstantsFromArray(programType, firstRegister + 1, [d[1], d[5], d[9], d[13]], 1);
		this.setProgramConstantsFromArray(programType, firstRegister + 2, [d[2], d[6], d[10], d[14]], 1);
		this.setProgramConstantsFromArray(programType, firstRegister + 3, [d[3], d[7], d[11], d[15]], 1);
	} else {
		this.setProgramConstantsFromArray(programType, firstRegister, [d[0], d[1], d[2], d[3]], 1);
		this.setProgramConstantsFromArray(programType, firstRegister + 1, [d[4], d[5], d[6], d[7]], 1);
		this.setProgramConstantsFromArray(programType, firstRegister + 2, [d[8], d[9], d[10], d[11]], 1);
		this.setProgramConstantsFromArray(programType, firstRegister + 3, [d[12], d[13], d[14], d[15]], 1);
	}
};

away.core.display3D.AGLSLContext3D.prototype.drawTriangles = function(indexBuffer, firstIndex, numTriangles) {
	firstIndex = firstIndex || 0;
	numTriangles = numTriangles || -1;
	var location = this._gl.getUniformLocation(this._currentProgram.get_glProgram(), "yflip");
	this._gl.uniform1f(location, this._yFlip);
	away.core.display3D.Context3D.prototype.drawTriangles.call(this,indexBuffer, firstIndex, numTriangles);
};

away.core.display3D.AGLSLContext3D.prototype.setCulling = function(triangleFaceToCull) {
	switch (triangleFaceToCull) {
		case away.core.display3D.Context3DTriangleFace.FRONT:
			this._yFlip = -1;
			break;
		case away.core.display3D.Context3DTriangleFace.BACK:
			this._yFlip = 1;
			break;
		case away.core.display3D.Context3DTriangleFace.FRONT_AND_BACK:
			this._yFlip = 1;
			break;
		case away.core.display3D.Context3DTriangleFace.NONE:
			this._yFlip = 1;
			break;
		default:
			throw "Unknown culling mode " + triangleFaceToCull + ".";
			break;
	}
};

$inherit(away.core.display3D.AGLSLContext3D, away.core.display3D.Context3D);

away.core.display3D.AGLSLContext3D.className = "away.core.display3D.AGLSLContext3D";

away.core.display3D.AGLSLContext3D.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.core.display3D.Program3D');
	p.push('away.core.display3D.Context3DTriangleFace');
	return p;
};

away.core.display3D.AGLSLContext3D.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.core.display3D.AGLSLContext3D.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'canvas', t:'HTMLCanvasElement'});
			break;
		case 1:
			p = away.core.display3D.Context3D.injectionPoints(t);
			break;
		case 2:
			p = away.core.display3D.Context3D.injectionPoints(t);
			break;
		case 3:
			p = away.core.display3D.Context3D.injectionPoints(t);
			break;
		default:
			p = [];
			break;
	}
	return p;
};

