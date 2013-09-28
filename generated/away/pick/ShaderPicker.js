/** Compiled by the Randori compiler v0.2.6.2 on Sat Sep 28 11:54:58 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.pick == "undefined")
	away.pick = {};

away.pick.ShaderPicker = function() {
	this._hitRenderable = null;
	this._context = null;
	this._triangleProgram3D = null;
	this.MOUSE_SCISSOR_RECT = new away.geom.Rectangle(0, 0, 1, 1);
	this._potentialFound = false;
	this._hitColor = 0;
	this._id = null;
	this._interactiveId = 0;
	this._rayPos = new away.geom.Vector3D(0, 0, 0, 0);
	this._subGeometryIndex = 0;
	this._faceIndex = 0;
	this._rayDir = new away.geom.Vector3D(0, 0, 0, 0);
	this._interactives = [];
	this._stage3DProxy = null;
	this._localHitNormal = new away.geom.Vector3D(0, 0, 0, 0);
	this._onlyMouseEnabled = true;
	this._hitUV = new away.geom.Point(0, 0);
	this._hitEntity = null;
	this._objectProgram3D = null;
	this._viewportData = null;
	this._bitmapData = null;
	this._projY = 0;
	this._projX = 0;
	this._localHitPosition = new away.geom.Vector3D(0, 0, 0, 0);
	this._boundOffsetScale = null;
	this._id = away.utils.VectorInit.Num(4, 0);
	this._viewportData = away.utils.VectorInit.Num(4, 0);
	this._boundOffsetScale = away.utils.VectorInit.Num(8, 0);
	this._boundOffsetScale[3] = 0;
	this._boundOffsetScale[7] = 1;
};

away.pick.ShaderPicker.MOUSE_SCISSOR_RECT = new away.geom.Rectangle(0, 0, 1, 1);

away.pick.ShaderPicker.prototype.get_onlyMouseEnabled = function() {
	return this._onlyMouseEnabled;
};

away.pick.ShaderPicker.prototype.set_onlyMouseEnabled = function(value) {
	this._onlyMouseEnabled = value;
};

away.pick.ShaderPicker.prototype.getViewCollision = function(x, y, view) {
	away.utils.Debug.throwPIR("ShaderPicker", "getViewCollision", "implement");
	return null;
	var collector = view.get_iEntityCollector();
	this._stage3DProxy = view.get_stage3DProxy();
	if (!this._stage3DProxy)
		return null;
	this._context = this._stage3DProxy._iContext3D;
	this._viewportData[0] = view.get_width();
	this._viewportData[1] = view.get_height();
	this._projX = 2 * x / view.get_width() - 1;
	this._viewportData[2] = -this._projX;
	this._viewportData[3] = 2 * y / view.get_height() - 1;
	this._projY = 2 * y / view.get_height() - 1;
	this._potentialFound = false;
	this.pDraw(collector, null);
	this._context.setVertexBufferAt(0, null, 0);
	if (!this._context || !this._potentialFound) {
		return null;
	}
	if (!this._bitmapData)
		this._bitmapData = new away.display.BitmapData(1, 1, false, 0);
	this._context.drawToBitmapData(this._bitmapData);
	this._hitColor = this._bitmapData.getPixel(0, 0);
	if (!this._hitColor) {
		this._context.present();
		return null;
	}
	this._hitRenderable = this._interactives[this._hitColor - 1];
	this._hitEntity = this._hitRenderable.get_sourceEntity();
	if (this._onlyMouseEnabled && (!this._hitEntity._iAncestorsAllowMouseEnabled || !this._hitEntity.get_mouseEnabled())) {
		return null;
	}
	var _collisionVO = this._hitEntity.get_pickingCollisionVO();
	if (this._hitRenderable.get_shaderPickingDetails()) {
		this.getHitDetails(view.get_camera());
		_collisionVO.localPosition = this._localHitPosition;
		_collisionVO.localNormal = this._localHitNormal;
		_collisionVO.uv = this._hitUV;
		_collisionVO.index = this._faceIndex;
		_collisionVO.subGeometryIndex = this._subGeometryIndex;
	} else {
		_collisionVO.localPosition = null;
		_collisionVO.localNormal = null;
		_collisionVO.uv = null;
		_collisionVO.index = 0;
		_collisionVO.subGeometryIndex = 0;
	}
	return _collisionVO;
};

away.pick.ShaderPicker.prototype.getSceneCollision = function(position, direction, scene) {
	return null;
};

away.pick.ShaderPicker.prototype.pDraw = function(entityCollector, target) {
	var camera = entityCollector.get_camera();
	this._context.clear(0, 0, 0, 1, 1, 0, 17664);
	this._stage3DProxy.set_scissorRect(away.pick.ShaderPicker.MOUSE_SCISSOR_RECT);
	this._interactives.length = 0;
	this._interactiveId = 0;
	if (!this._objectProgram3D) {
		this.initObjectProgram3D();
	}
	this._context.setBlendFactors(away.display3D.Context3DBlendFactor.ONE, away.display3D.Context3DBlendFactor.ZERO);
	this._context.setDepthTest(true, away.display3D.Context3DCompareMode.LESS);
	this._context.setProgram(this._objectProgram3D);
	this._context.setProgramConstantsFromArray(away.display3D.Context3DProgramType.VERTEX, 4, this._viewportData, 1);
	this.drawRenderables(entityCollector.get_opaqueRenderableHead(), camera);
	this.drawRenderables(entityCollector.get_blendedRenderableHead(), camera);
};

away.pick.ShaderPicker.prototype.drawRenderables = function(item, camera) {
	away.utils.Debug.throwPIR("ShaderPicker", "drawRenderables", "implement");
	var matrix = away.math.Matrix3DUtils.CALCULATION_MATRIX;
	var renderable;
	var viewProjection = camera.get_viewProjection();
	while (item) {
		renderable = item.renderable;
		if (!renderable.get_sourceEntity().get_scene() || (!renderable.get_mouseEnabled() && this._onlyMouseEnabled)) {
			item = item.next;
			continue;
		}
		this._potentialFound = true;
		this._context.setCulling(renderable.get_material().get_bothSides() ? away.display3D.Context3DTriangleFace.NONE : away.display3D.Context3DTriangleFace.BACK);
		this._interactives[this._interactiveId++] = renderable;
		this._id[1] = (this._interactiveId >> 8) / 255;
		this._id[2] = (this._interactiveId & 0xff) / 255;
		matrix.copyFrom(renderable.getRenderSceneTransform(camera));
		matrix.append(viewProjection);
		this._context.setProgramConstantsFromMatrix(away.display3D.Context3DProgramType.VERTEX, 0, matrix, true);
		this._context.setProgramConstantsFromArray(away.display3D.Context3DProgramType.FRAGMENT, 0, this._id, 1);
		renderable.activateVertexBuffer(0, this._stage3DProxy);
		this._context.drawTriangles(renderable.getIndexBuffer(this._stage3DProxy), 0, renderable.get_numTriangles());
		item = item.next;
	}
};

away.pick.ShaderPicker.prototype.updateRay = function(camera) {
	this._rayPos = camera.get_scenePosition();
	this._rayDir = camera.getRay(this._projX, this._projY, 1);
	this._rayDir.normalize();
};

away.pick.ShaderPicker.prototype.initObjectProgram3D = function() {
	var vertexCode;
	var fragmentCode;
	this._objectProgram3D = this._context.createProgram();
	vertexCode = "m44 vt0, va0, vc0\t\t\t\n" + "mul vt1.xy, vt0.w, vc4.zw\t\n" + "add vt0.xy, vt0.xy, vt1.xy\t\n" + "mul vt0.xy, vt0.xy, vc4.xy\t\n" + "mov op, vt0\t\n";
	fragmentCode = "mov oc, fc0";
	away.utils.Debug.throwPIR("ShaderPicker", "initTriangleProgram3D", "Dependency: initObjectProgram3D");
};

away.pick.ShaderPicker.prototype.initTriangleProgram3D = function() {
	var vertexCode;
	var fragmentCode;
	this._triangleProgram3D = this._context.createProgram();
	vertexCode = "add vt0, va0, vc5 \t\t\t\n" + "mul vt0, vt0, vc6 \t\t\t\n" + "mov v0, vt0\t\t\t\t\n" + "m44 vt0, va0, vc0\t\t\t\n" + "mul vt1.xy, vt0.w, vc4.zw\t\n" + "add vt0.xy, vt0.xy, vt1.xy\t\n" + "mul vt0.xy, vt0.xy, vc4.xy\t\n" + "mov op, vt0\t\n";
	fragmentCode = "mov oc, v0";
	var vertCompiler = new aglsl.AGLSLCompiler();
	var fragCompiler = new aglsl.AGLSLCompiler();
	var vertString = vertCompiler.compile(away.display3D.Context3DProgramType.VERTEX, vertexCode);
	var fragString = fragCompiler.compile(away.display3D.Context3DProgramType.FRAGMENT, fragmentCode);
	this._triangleProgram3D.upload(vertString, fragString);
};

away.pick.ShaderPicker.prototype.getHitDetails = function(camera) {
	this.getApproximatePosition(camera);
	this.getPreciseDetails(camera);
};

away.pick.ShaderPicker.prototype.getApproximatePosition = function(camera) {
	var entity = this._hitRenderable.get_sourceEntity();
	var col;
	var scX, scY, scZ;
	var offsX, offsY, offsZ;
	var localViewProjection = away.math.Matrix3DUtils.CALCULATION_MATRIX;
	localViewProjection.copyFrom(this._hitRenderable.getRenderSceneTransform(camera));
	localViewProjection.append(camera.get_viewProjection());
	if (!this._triangleProgram3D) {
		this.initTriangleProgram3D();
	}
	scX = entity.get_maxX() - entity.get_minX();
	scY = entity.get_maxY() - entity.get_minY();
	scZ = entity.get_maxZ() - entity.get_minZ();
	this._boundOffsetScale[4] = 1 / scX;
	this._boundOffsetScale[5] = 1 / scY;
	this._boundOffsetScale[6] = 1 / scZ;
	this._boundOffsetScale[0] = -entity.get_minX();
	offsX = -entity.get_minX();
	this._boundOffsetScale[1] = -entity.get_minY();
	offsY = -entity.get_minY();
	this._boundOffsetScale[2] = -entity.get_minZ();
	offsZ = -entity.get_minZ();
	this._context.setProgram(this._triangleProgram3D);
	this._context.clear(0, 0, 0, 0, 1, 0, away.display3D.Context3DClearMask.DEPTH);
	this._context.setScissorRectangle(away.pick.ShaderPicker.MOUSE_SCISSOR_RECT);
	this._context.setProgramConstantsFromMatrix(away.display3D.Context3DProgramType.VERTEX, 0, localViewProjection, true);
	this._context.setProgramConstantsFromArray(away.display3D.Context3DProgramType.VERTEX, 5, this._boundOffsetScale, 2);
	this._hitRenderable.activateVertexBuffer(0, this._stage3DProxy);
	this._context.drawTriangles(this._hitRenderable.getIndexBuffer(this._stage3DProxy), 0, this._hitRenderable.get_numTriangles());
	this._context.drawToBitmapData(this._bitmapData);
	col = this._bitmapData.getPixel(0, 0);
	this._localHitPosition.x = ((col >> 16) & 0xff) * scX / 255 - offsX;
	this._localHitPosition.y = ((col >> 8) & 0xff) * scY / 255 - offsY;
	this._localHitPosition.z = (col & 0xff) * scZ / 255 - offsZ;
};

away.pick.ShaderPicker.prototype.getPreciseDetails = function(camera) {
	var subMesh = this._hitRenderable;
	var subGeom = subMesh.get_subGeometry();
	var indices = subGeom.get_indexData();
	var vertices = subGeom.get_vertexData();
	var len = indices.length;
	var x1, y1, z1;
	var x2, y2, z2;
	var x3, y3, z3;
	var i = 0, j = 1, k = 2;
	var t1, t2, t3;
	var v0x, v0y, v0z;
	var v1x, v1y, v1z;
	var v2x, v2y, v2z;
	var dot00, dot01, dot02, dot11, dot12;
	var s, t, invDenom;
	var uvs = subGeom.get_UVData();
	var normals = subGeom.get_faceNormals();
	var x = this._localHitPosition.x, y = this._localHitPosition.y, z = this._localHitPosition.z;
	var u, v;
	var ui1, ui2, ui3;
	var s0x, s0y, s0z;
	var s1x, s1y, s1z;
	var nl;
	var stride = subGeom.get_vertexStride();
	var vertexOffset = subGeom.get_vertexOffset();
	this.updateRay(camera);
	while (i < len) {
		t1 = vertexOffset + indices[i] * stride;
		t2 = vertexOffset + indices[j] * stride;
		t3 = vertexOffset + indices[k] * stride;
		x1 = vertices[t1];
		y1 = vertices[t1 + 1];
		z1 = vertices[t1 + 2];
		x2 = vertices[t2];
		y2 = vertices[t2 + 1];
		z2 = vertices[t2 + 2];
		x3 = vertices[t3];
		y3 = vertices[t3 + 1];
		z3 = vertices[t3 + 2];
		if (!((x < x1 && x < x2 && x < x3) || (y < y1 && y < y2 && y < y3) || (z < z1 && z < z2 && z < z3) || (x > x1 && x > x2 && x > x3) || (y > y1 && y > y2 && y > y3) || (z > z1 && z > z2 && z > z3))) {
			v0x = x3 - x1;
			v0y = y3 - y1;
			v0z = z3 - z1;
			v1x = x2 - x1;
			v1y = y2 - y1;
			v1z = z2 - z1;
			v2x = x - x1;
			v2y = y - y1;
			v2z = z - z1;
			dot00 = v0x * v0x + v0y * v0y + v0z * v0z;
			dot01 = v0x * v1x + v0y * v1y + v0z * v1z;
			dot02 = v0x * v2x + v0y * v2y + v0z * v2z;
			dot11 = v1x * v1x + v1y * v1y + v1z * v1z;
			dot12 = v1x * v2x + v1y * v2y + v1z * v2z;
			invDenom = 1 / (dot00 * dot11 - dot01 * dot01);
			s = (dot11 * dot02 - dot01 * dot12) * invDenom;
			t = (dot00 * dot12 - dot01 * dot02) * invDenom;
			if (s >= 0 && t >= 0 && (s + t) <= 1) {
				this.getPrecisePosition(this._hitRenderable.get_inverseSceneTransform(), normals[i], normals[i + 1], normals[i + 2], x1, y1, z1);
				v2x = this._localHitPosition.x - x1;
				v2y = this._localHitPosition.y - y1;
				v2z = this._localHitPosition.z - z1;
				s0x = x2 - x1;
				s0y = y2 - y1;
				s0z = z2 - z1;
				s1x = x3 - x1;
				s1y = y3 - y1;
				s1z = z3 - z1;
				this._localHitNormal.x = s0y * s1z - s0z * s1y;
				this._localHitNormal.y = s0z * s1x - s0x * s1z;
				this._localHitNormal.z = s0x * s1y - s0y * s1x;
				nl = 1 / Math.sqrt(this._localHitNormal.x * this._localHitNormal.x + this._localHitNormal.y * this._localHitNormal.y + this._localHitNormal.z * this._localHitNormal.z);
				this._localHitNormal.x *= nl;
				this._localHitNormal.y *= nl;
				this._localHitNormal.z *= nl;
				dot02 = v0x * v2x + v0y * v2y + v0z * v2z;
				dot12 = v1x * v2x + v1y * v2y + v1z * v2z;
				s = (dot11 * dot02 - dot01 * dot12) * invDenom;
				t = (dot00 * dot12 - dot01 * dot02) * invDenom;
				ui1 = indices[i] << 1;
				ui2 = indices[j] << 1;
				ui3 = indices[k] << 1;
				u = uvs[ui1];
				v = uvs[ui1 + 1];
				this._hitUV.x = u + t * (uvs[ui2] - u) + s * (uvs[ui3] - u);
				this._hitUV.y = v + t * (uvs[ui2 + 1] - v) + s * (uvs[ui3 + 1] - v);
				this._faceIndex = i;
				this._subGeometryIndex = away.utils.GeometryUtils.getMeshSubMeshIndex(subMesh);
				return;
			}
		}
		i += 3;
		j += 3;
		k += 3;
	}
};

away.pick.ShaderPicker.prototype.getPrecisePosition = function(invSceneTransform, nx, ny, nz, px, py, pz) {
	var rx, ry, rz;
	var ox, oy, oz;
	var t;
	var raw = away.math.Matrix3DUtils.RAW_DATA_CONTAINER;
	var cx = this._rayPos.x, cy = this._rayPos.y, cz = this._rayPos.z;
	ox = this._rayDir.x;
	oy = this._rayDir.y;
	oz = this._rayDir.z;
	invSceneTransform.copyRawDataTo(raw, 0, false);
	rx = raw[0] * ox + raw[4] * oy + raw[8] * oz;
	ry = raw[1] * ox + raw[5] * oy + raw[9] * oz;
	rz = raw[2] * ox + raw[6] * oy + raw[10] * oz;
	ox = raw[0] * cx + raw[4] * cy + raw[8] * cz + raw[12];
	oy = raw[1] * cx + raw[5] * cy + raw[9] * cz + raw[13];
	oz = raw[2] * cx + raw[6] * cy + raw[10] * cz + raw[14];
	t = ((px - ox) * nx + (py - oy) * ny + (pz - oz) * nz) / (rx * nx + ry * ny + rz * nz);
	this._localHitPosition.x = ox + rx * t;
	this._localHitPosition.y = oy + ry * t;
	this._localHitPosition.z = oz + rz * t;
};

away.pick.ShaderPicker.prototype.dispose = function() {
	this._bitmapData.dispose();
	if (this._triangleProgram3D) {
		this._triangleProgram3D.dispose();
	}
	if (this._objectProgram3D) {
		this._objectProgram3D.dispose();
	}
	this._triangleProgram3D = null;
	this._objectProgram3D = null;
	this._bitmapData = null;
	this._hitRenderable = null;
	this._hitEntity = null;
};

away.pick.ShaderPicker.className = "away.pick.ShaderPicker";

away.pick.ShaderPicker.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.utils.Debug');
	p.push('away.traverse.EntityCollector');
	p.push('away.display3D.Context3DTriangleFace');
	p.push('away.containers.View3D');
	p.push('away.display3D.Context3DProgramType');
	p.push('away.math.Matrix3DUtils');
	p.push('*away.base.IRenderable');
	p.push('aglsl.AGLSLCompiler');
	p.push('away.cameras.Camera3D');
	p.push('away.pick.ShaderPicker');
	p.push('away.display3D.Context3DCompareMode');
	p.push('away.utils.GeometryUtils');
	p.push('away.display3D.Context3DBlendFactor');
	p.push('away.display3D.Context3DClearMask');
	p.push('away.display.BitmapData');
	p.push('away.utils.VectorInit');
	return p;
};

away.pick.ShaderPicker.getStaticDependencies = function(t) {
	var p;
	p = [];
	p.push('away.geom.Point');
	p.push('away.geom.Vector3D');
	p.push('away.geom.Rectangle');
	return p;
};

away.pick.ShaderPicker.injectionPoints = function(t) {
	return [];
};
