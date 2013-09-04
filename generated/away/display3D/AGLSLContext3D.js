/** Compiled by the Randori compiler v0.2.6.2 on Wed Sep 04 21:18:42 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.display3D == "undefined")
	away.display3D = {};

away.display3D.AGLSLContext3D = function(canvas) {
	this._yFlip = -1;
	away.display3D.Context3D.call(this, canvas);
};

away.display3D.AGLSLContext3D.prototype.setProgramConstantsFromMatrix = function(programType, firstRegister, matrix, transposedMatrix) {
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

away.display3D.AGLSLContext3D.prototype.drawTriangles = function(indexBuffer, firstIndex, numTriangles) {
	var location = this._gl.getUniformLocation(this._currentProgram.get_glProgram(), "yflip");
	this._gl.uniform1f(location, this._yFlip);
	away.display3D.Context3D.prototype.drawTriangles.call(this,indexBuffer, firstIndex, numTriangles);
};

away.display3D.AGLSLContext3D.prototype.setCulling = function(triangleFaceToCull) {
	switch (triangleFaceToCull) {
		case away.display3D.Context3DTriangleFace.FRONT:
			this._yFlip = 1;
			break;
		case away.display3D.Context3DTriangleFace.BACK:
			this._yFlip = -1;
			break;
	}
	away.display3D.Context3D.prototype.setCulling.call(this,triangleFaceToCull);
};

$inherit(away.display3D.AGLSLContext3D, away.display3D.Context3D);

away.display3D.AGLSLContext3D.className = "away.display3D.AGLSLContext3D";

away.display3D.AGLSLContext3D.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.display3D.Program3D');
	p.push('away.display3D.Context3DTriangleFace');
	return p;
};

away.display3D.AGLSLContext3D.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.display3D.AGLSLContext3D.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'canvas', t:'HTMLCanvasElement'});
			break;
		case 1:
			p = away.display3D.Context3D.injectionPoints(t);
			break;
		case 2:
			p = away.display3D.Context3D.injectionPoints(t);
			break;
		case 3:
			p = away.display3D.Context3D.injectionPoints(t);
			break;
		default:
			p = [];
			break;
	}
	return p;
};

