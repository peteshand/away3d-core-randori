/** Compiled by the Randori compiler v0.2.6.2 on Sat Sep 21 16:02:35 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.materials == "undefined")
	away.materials = {};
if (typeof away.materials.passes == "undefined")
	away.materials.passes = {};

away.materials.passes.SegmentPass = function(thickness) {
	this._thickness = 0;
	this._calcMatrix = null;
	this._constants = [0, 0, 0, 0];
	away.materials.passes.MaterialPassBase.call(this, false);
	this._calcMatrix = new away.geom.Matrix3D();
	this._thickness = thickness;
	this._constants[1] = 1 / 255;
};

away.materials.passes.SegmentPass.pONE_VECTOR = [1, 1, 1, 1];

away.materials.passes.SegmentPass.pFRONT_VECTOR = [0, 0, -1, 0];

away.materials.passes.SegmentPass.prototype.iGetVertexCode = function() {
	return "m44 vt0, va0, vc8\t\t\t\n" + "m44 vt1, va1, vc8\t\t\t\n" + "sub vt2, vt1, vt0 \t\t\t\n" + "slt vt5.x, vt0.z, vc7.z\t\t\t\n" + "sub vt5.y, vc5.x, vt5.x\t\t\t\n" + "add vt4.x, vt0.z, vc7.z\t\t\t\n" + "sub vt4.y, vt0.z, vt1.z\t\t\t\n" + "seq vt4.z, vt4.y vc6.x\t\t\t\n" + "add vt4.y, vt4.y, vt4.z\t\t\t\n" + "div vt4.z, vt4.x, vt4.y\t\t\t\n" + "mul vt4.xyz, vt4.zzz, vt2.xyz\t\n" + "add vt3.xyz, vt0.xyz, vt4.xyz\t\n" + "mov vt3.w, vc5.x\t\t\t\n" + "mul vt0, vt0, vt5.yyyy\t\t\t\n" + "mul vt3, vt3, vt5.xxxx\t\t\t\n" + "add vt0, vt0, vt3\t\t\t\t\n" + "sub vt2, vt1, vt0 \t\t\t\n" + "nrm vt2.xyz, vt2.xyz\t\t\t\n" + "nrm vt5.xyz, vt0.xyz\t\t\t\n" + "mov vt5.w, vc5.x\t\t\t\t\n" + "crs vt3.xyz, vt2, vt5\t\t\t\n" + "nrm vt3.xyz, vt3.xyz\t\t\t\n" + "mul vt3.xyz, vt3.xyz, va2.xxx\t\n" + "mov vt3.w, vc5.x\t\t\t\n" + "dp3 vt4.x, vt0, vc6\t\t\t\n" + "mul vt4.x, vt4.x, vc7.x\t\t\t\n" + "mul vt3.xyz, vt3.xyz, vt4.xxx\t\n" + "add vt0.xyz, vt0.xyz, vt3.xyz\t\n" + "m44 op, vt0, vc0\t\t\t\n" + "mov v0, va3\t\t\t\t\n";
};

away.materials.passes.SegmentPass.prototype.iGetFragmentCode = function(animationCode) {
	return "mov oc, v0\n";
};

away.materials.passes.SegmentPass.prototype.iRender = function(renderable, stage3DProxy, camera, viewProjection) {
	var context = stage3DProxy._iContext3D;
	this._calcMatrix.copyFrom(renderable.get_sourceEntity().get_sceneTransform());
	this._calcMatrix.append(camera.get_inverseSceneTransform());
	var ss = renderable;
	var subSetCount = ss.get_iSubSetCount();
	if (ss.get_hasData()) {
		for (var i = 0; i < subSetCount; ++i) {
			renderable.activateVertexBuffer(i, stage3DProxy);
			context.setProgramConstantsFromMatrix(away.display3D.Context3DProgramType.VERTEX, 8, this._calcMatrix, true);
			context.drawTriangles(renderable.getIndexBuffer(stage3DProxy), 0, renderable.get_numTriangles());
		}
	}
};

away.materials.passes.SegmentPass.prototype.iActivate = function(stage3DProxy, camera) {
	var context = stage3DProxy._iContext3D;
	away.materials.passes.MaterialPassBase.prototype.iActivate.call(this,stage3DProxy, camera);
	if (stage3DProxy.get_scissorRect())
		this._constants[0] = this._thickness / Math.min(stage3DProxy.get_scissorRect().width, stage3DProxy.get_scissorRect().height);
	else
		this._constants[0] = this._thickness / Math.min(stage3DProxy.get_width(), stage3DProxy.get_height());
	this._constants[2] = camera.get_lens().get_near();
	context.setProgramConstantsFromArray(away.display3D.Context3DProgramType.VERTEX, 5, away.materials.passes.SegmentPass.pONE_VECTOR, -1);
	context.setProgramConstantsFromArray(away.display3D.Context3DProgramType.VERTEX, 6, away.materials.passes.SegmentPass.pFRONT_VECTOR, -1);
	context.setProgramConstantsFromArray(away.display3D.Context3DProgramType.VERTEX, 7, this._constants, -1);
	context.setProgramConstantsFromMatrix(away.display3D.Context3DProgramType.VERTEX, 0, camera.get_lens().get_matrix(), true);
};

away.materials.passes.SegmentPass.prototype.pDeactivate = function(stage3DProxy) {
	var context = stage3DProxy._iContext3D;
	context.setVertexBufferAt(0, null, 0);
	context.setVertexBufferAt(1, null, 0);
	context.setVertexBufferAt(2, null, 0);
	context.setVertexBufferAt(3, null, 0);
};

$inherit(away.materials.passes.SegmentPass, away.materials.passes.MaterialPassBase);

away.materials.passes.SegmentPass.className = "away.materials.passes.SegmentPass";

away.materials.passes.SegmentPass.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.materials.passes.SegmentPass');
	p.push('away.geom.Matrix3D');
	p.push('*away.base.IRenderable');
	p.push('away.display3D.Context3DProgramType');
	p.push('away.geom.Rectangle');
	p.push('away.cameras.Camera3D');
	p.push('away.entities.Entity');
	p.push('away.cameras.lenses.LensBase');
	p.push('away.managers.Stage3DProxy');
	return p;
};

away.materials.passes.SegmentPass.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.materials.passes.SegmentPass.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'thickness', t:'Number'});
			break;
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

