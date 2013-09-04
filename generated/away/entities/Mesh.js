/** Compiled by the Randori compiler v0.2.6.2 on Wed Sep 04 21:18:42 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.entities == "undefined")
	away.entities = {};

away.entities.Mesh = function(geometry, material) {
	this._castsShadows = true;
	this._animator = null;
	this._subMeshes = null;
	this._geometry = null;
	this._material = null;
	this._shareAnimationGeometry = true;
	away.entities.Entity.call(this);
	this._subMeshes = [];
	if (geometry == null) {
		this.set_geometry(new away.base.Geometry());
	} else {
		this.set_geometry(geometry);
	}
	if (material == null) {
		this.set_material(away.materials.utils.DefaultMaterialManager.getDefaultMaterial(this));
	} else {
		this.set_material(material);
	}
};

away.entities.Mesh.prototype.bakeTransformations = function() {
	this.get_geometry().applyTransformation(this.get_transform());
	this.get_transform().identity();
};

away.entities.Mesh.prototype.get_assetType = function() {
	return away.library.assets.AssetType.MESH;
};

away.entities.Mesh.prototype.onGeometryBoundsInvalid = function(event) {
	this.pInvalidateBounds();
};

away.entities.Mesh.prototype.get_castsShadows = function() {
	return this._castsShadows;
};

away.entities.Mesh.prototype.set_castsShadows = function(value) {
	this._castsShadows = value;
};

away.entities.Mesh.prototype.get_animator = function() {
	return this._animator;
};

away.entities.Mesh.prototype.set_animator = function(value) {
	away.utils.Debug.throwPIR("Mesh", "set animator", "Partial Implementation");
};

away.entities.Mesh.prototype.get_geometry = function() {
	return this._geometry;
};

away.entities.Mesh.prototype.set_geometry = function(value) {
	var i;
	if (this._geometry) {
		this._geometry.removeEventListener(away.events.GeometryEvent.BOUNDS_INVALID, $createStaticDelegate(, this.onGeometryBoundsInvalid), this);
		this._geometry.removeEventListener(away.events.GeometryEvent.SUB_GEOMETRY_ADDED, $createStaticDelegate(, this.onSubGeometryAdded), this);
		this._geometry.removeEventListener(away.events.GeometryEvent.SUB_GEOMETRY_REMOVED, $createStaticDelegate(, this.onSubGeometryRemoved), this);
		for (i = 0; i < this._subMeshes.length; ++i) {
			this._subMeshes[i].dispose();
		}
		this._subMeshes.length = 0;
	}
	this._geometry = value;
	if (this._geometry) {
		this._geometry.addEventListener(away.events.GeometryEvent.BOUNDS_INVALID, $createStaticDelegate(, this.onGeometryBoundsInvalid), this);
		this._geometry.addEventListener(away.events.GeometryEvent.SUB_GEOMETRY_ADDED, $createStaticDelegate(, this.onSubGeometryAdded), this);
		this._geometry.addEventListener(away.events.GeometryEvent.SUB_GEOMETRY_REMOVED, $createStaticDelegate(, this.onSubGeometryRemoved), this);
		var subGeoms = this._geometry.get_subGeometries();
		for (i = 0; i < subGeoms.length; ++i) {
			this.addSubMesh(subGeoms[i]);
		}
	}
	if (this._material) {
		this._material.iRemoveOwner(this);
		this._material.iAddOwner(this);
	}
};

away.entities.Mesh.prototype.get_material = function() {
	return this._material;
};

away.entities.Mesh.prototype.set_material = function(value) {
	if (value == this._material) {
		return;
	}
	if (this._material) {
		this._material.iRemoveOwner(this);
	}
	this._material = value;
	if (this._material) {
		this._material.iAddOwner(this);
	}
};

away.entities.Mesh.prototype.get_subMeshes = function() {
	this._geometry.iValidate();
	return this._subMeshes;
};

away.entities.Mesh.prototype.get_shareAnimationGeometry = function() {
	return this._shareAnimationGeometry;
};

away.entities.Mesh.prototype.set_shareAnimationGeometry = function(value) {
	this._shareAnimationGeometry = value;
};

away.entities.Mesh.prototype.clearAnimationGeometry = function() {
	away.utils.Debug.throwPIR("away.entities.Mesh", "away.entities.Mesh", "Missing Dependency: IAnimator");
};

away.entities.Mesh.prototype.dispose = function() {
	away.entities.Entity.prototype.dispose.call(this);
	this.set_material(null);
	this.set_geometry(null);
};

away.entities.Mesh.prototype.disposeWithAnimatorAndChildren = function() {
	this.disposeWithChildren();
	away.utils.Debug.throwPIR("away.entities.Mesh", "away.entities.Mesh", "Missing Dependency: IAnimator");
};

away.entities.Mesh.prototype.clone = function() {
	var clone = new away.entities.Mesh(this._geometry, this._material);
	clone.set_transform($createStaticDelegate(this, this.get_transform));
	clone.set_pivotPoint($createStaticDelegate(this, this.get_pivotPoint));
	clone.set_partition($createStaticDelegate(this, this.get_partition));
	clone.set_bounds(this._pBounds.clone());
	clone.set_name($createStaticDelegate(this, this.get_name));
	clone.set_castsShadows($createStaticDelegate(this, this.get_castsShadows));
	clone.set_shareAnimationGeometry($createStaticDelegate(this, this.get_shareAnimationGeometry));
	clone.set_mouseEnabled($createStaticDelegate(this, this.get_mouseEnabled));
	clone.set_mouseChildren($createStaticDelegate(this, this.get_mouseChildren));
	clone.extra = this.extra;
	var len = this._subMeshes.length;
	for (var i = 0; i < len; ++i) {
		clone._subMeshes[i].material = this._subMeshes[i].material;
	}
	len = $createStaticDelegate(this, this.get_numChildren);
	var obj;
	for (i = 0; i < len; ++i) {
		obj = this.getChildAt(i).clone();
		clone.addChild(obj);
	}
	away.utils.Debug.throwPIR("away.entities.Mesh", "away.entities.Mesh", "Missing Dependency: IAnimator");
	return clone;
};

away.entities.Mesh.prototype.pUpdateBounds = function() {
	this._pBounds.fromGeometry(this._geometry);
	this._pBoundsInvalid = false;
};

away.entities.Mesh.prototype.pCreateEntityPartitionNode = function() {
	return new away.partition.MeshNode(this);
};

away.entities.Mesh.prototype.onSubGeometryAdded = function(event) {
	this.addSubMesh(event.get_subGeometry());
};

away.entities.Mesh.prototype.onSubGeometryRemoved = function(event) {
	var subMesh;
	var subGeom = event.get_subGeometry();
	var len = this._subMeshes.length;
	var i;
	for (i = 0; i < len; ++i) {
		subMesh = this._subMeshes[i];
		if (subMesh.get_subGeometry() == subGeom) {
			subMesh.dispose();
			this._subMeshes.splice(i, 1);
			break;
		}
	}
	--len;
	for (; i < len; ++i) {
		this._subMeshes[i]._iIndex = i;
	}
};

away.entities.Mesh.prototype.addSubMesh = function(subGeometry) {
	var subMesh = new away.base.SubMesh(subGeometry, this, null);
	var len = this._subMeshes.length;
	subMesh._iIndex = len;
	this._subMeshes[len] = subMesh;
	this.pInvalidateBounds();
};

away.entities.Mesh.prototype.getSubMeshForSubGeometry = function(subGeometry) {
	return this._subMeshes[this._geometry.get_subGeometries().indexOf(subGeometry, 0)];
};

away.entities.Mesh.prototype.iCollidesBefore = function(shortestCollisionDistance, findClosest) {
	this._iPickingCollider.setLocalRay(this._iPickingCollisionVO.localRayPosition, this._iPickingCollisionVO.localRayDirection);
	this._iPickingCollisionVO.renderable = null;
	var len = this._subMeshes.length;
	for (var i = 0; i < len; ++i) {
		var subMesh = this._subMeshes[i];
		if (this._iPickingCollider.testSubMeshCollision(subMesh, this._iPickingCollisionVO, shortestCollisionDistance)) {
			shortestCollisionDistance = this._iPickingCollisionVO.rayEntryDistance;
			this._iPickingCollisionVO.renderable = subMesh;
			if (!findClosest) {
				return true;
			}
		}
	}
	return this._iPickingCollisionVO.renderable != null;
};

$inherit(away.entities.Mesh, away.entities.Entity);

away.entities.Mesh.className = "away.entities.Mesh";

away.entities.Mesh.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.utils.Debug');
	p.push('away.pick.PickingCollisionVO');
	p.push('away.base.Geometry');
	p.push('away.base.SubMesh');
	p.push('away.events.GeometryEvent');
	p.push('away.partition.MeshNode');
	p.push('away.library.assets.AssetType');
	p.push('away.materials.utils.DefaultMaterialManager');
	return p;
};

away.entities.Mesh.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.entities.Mesh.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'geometry', t:'away.base.Geometry'});
			p.push({n:'material', t:'away.materials.MaterialBase'});
			break;
		case 1:
			p = away.entities.Entity.injectionPoints(t);
			break;
		case 2:
			p = away.entities.Entity.injectionPoints(t);
			break;
		case 3:
			p = away.entities.Entity.injectionPoints(t);
			break;
		default:
			p = [];
			break;
	}
	return p;
};

