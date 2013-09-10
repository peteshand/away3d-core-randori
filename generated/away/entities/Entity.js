/** Compiled by the Randori compiler v0.2.6.2 on Tue Sep 10 22:28:06 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.entities == "undefined")
	away.entities = {};

away.entities.Entity = function() {
	this._worldBoundsInvalid = true;
	this._iPickingCollisionVO = null;
	this._iStaticNode = null;
	this._worldBounds = null;
	this._pBounds = null;
	this._showBounds = null;
	this._boundsIsShown = null;
	this._pBoundsInvalid = true;
	this._iPickingCollider = null;
	this._shaderPickingDetails = null;
	this._partitionNode = null;
	away.containers.ObjectContainer3D.call(this);
	this._pBounds = this.pGetDefaultBoundingVolume();
	this._worldBounds = this.pGetDefaultBoundingVolume();
};

away.entities.Entity.prototype.setIgnoreTransform = function(value) {
	if (this._pScene) {
		this._pScene.iInvalidateEntityBounds(this);
	}
	away.containers.ObjectContainer3D.prototype.setIgnoreTransform.call(this,value);
};

away.entities.Entity.prototype.get_shaderPickingDetails = function() {
	return this._shaderPickingDetails;
};

away.entities.Entity.prototype.get_staticNode = function() {
	return this._iStaticNode;
};

away.entities.Entity.prototype.set_staticNode = function(value) {
	this._iStaticNode = value;
};

away.entities.Entity.prototype.get_pickingCollisionVO = function() {
	if (!this._iPickingCollisionVO) {
		this._iPickingCollisionVO = new away.pick.PickingCollisionVO(this);
	}
	return this._iPickingCollisionVO;
};

away.entities.Entity.prototype.iCollidesBefore = function(shortestCollisionDistance, findClosest) {
	shortestCollisionDistance = shortestCollisionDistance;
	findClosest = findClosest;
	return true;
};

away.entities.Entity.prototype.get_showBounds = function() {
	return this._showBounds;
};

away.entities.Entity.prototype.set_showBounds = function(value) {
	if (value == this._showBounds) {
		return;
	}
	this._showBounds = value;
	if (this._showBounds) {
		this.addBounds();
	} else {
		this.removeBounds();
	}
};

away.entities.Entity.prototype.get_minX = function() {
	if (this._pBoundsInvalid) {
		this.pUpdateBounds();
	}
	return this._pBounds.get_min().x;
};

away.entities.Entity.prototype.get_minY = function() {
	if (this._pBoundsInvalid) {
		this.pUpdateBounds();
	}
	return this._pBounds.get_min().y;
};

away.entities.Entity.prototype.get_minZ = function() {
	if (this._pBoundsInvalid) {
		this.pUpdateBounds();
	}
	return this._pBounds.get_min().z;
};

away.entities.Entity.prototype.get_maxX = function() {
	if (this._pBoundsInvalid) {
		this.pUpdateBounds();
	}
	return this._pBounds.get_max().x;
};

away.entities.Entity.prototype.get_maxY = function() {
	if (this._pBoundsInvalid) {
		this.pUpdateBounds();
	}
	return this._pBounds.get_max().y;
};

away.entities.Entity.prototype.get_maxZ = function() {
	if (this._pBoundsInvalid) {
		this.pUpdateBounds();
	}
	return this._pBounds.get_max().z;
};

away.entities.Entity.prototype.getBounds = function() {
	if (this._pBoundsInvalid) {
		this.pUpdateBounds();
	}
	return this._pBounds;
};

away.entities.Entity.prototype.get_bounds = function() {
	return this.getBounds();
};

away.entities.Entity.prototype.set_bounds = function(value) {
	this.removeBounds();
	this._pBounds = value;
	this._worldBounds = value.clone();
	this.pInvalidateBounds();
	if (this._showBounds) {
		this.addBounds();
	}
};

away.entities.Entity.prototype.get_worldBounds = function() {
	if (this._worldBoundsInvalid) {
		this.updateWorldBounds();
	}
	return this._worldBounds;
};

away.entities.Entity.prototype.updateWorldBounds = function() {
	this._worldBounds.transformFrom(this.getBounds(), this.get_sceneTransform());
	this._worldBoundsInvalid = false;
};

away.entities.Entity.prototype.iSetImplicitPartition = function(value) {
	if (value == this._pImplicitPartition) {
		return;
	}
	if (this._pImplicitPartition) {
		this.notifyPartitionUnassigned();
	}
	away.containers.ObjectContainer3D.prototype.iSetImplicitPartition.call(this,value);
	this.notifyPartitionAssigned();
};

away.entities.Entity.prototype.set_scene = function(value) {
	if (value == this._pScene) {
		return;
	}
	if (this._pScene) {
		this._pScene.iUnregisterEntity(this);
	}
	if (value) {
		value.iRegisterEntity(this);
	}
	away.containers.ObjectContainer3D.prototype.setScene.call(this,value);
};

away.entities.Entity.prototype.get_assetType = function() {
	return away.library.assets.AssetType.ENTITY;
};

away.entities.Entity.prototype.get_pickingCollider = function() {
	return this._iPickingCollider;
};

away.entities.Entity.prototype.set_pickingCollider = function(value) {
	this.setPickingCollider(value);
};

away.entities.Entity.prototype.setPickingCollider = function(value) {
	this._iPickingCollider = value;
};

away.entities.Entity.prototype.getEntityPartitionNode = function() {
	if (!this._partitionNode) {
		this._partitionNode = this.pCreateEntityPartitionNode();
	}
	return this._partitionNode;
};

away.entities.Entity.prototype.isIntersectingRay = function(rayPosition, rayDirection) {
	var localRayPosition = this.get_inverseSceneTransform().transformVector(rayPosition);
	var localRayDirection = this.get_inverseSceneTransform().deltaTransformVector(rayDirection);
	if (!this._iPickingCollisionVO.localNormal) {
		this._iPickingCollisionVO.localNormal = new away.geom.Vector3D(0, 0, 0, 0);
	}
	var rayEntryDistance = this._pBounds.rayIntersection(localRayPosition, localRayDirection, this._iPickingCollisionVO.localNormal);
	if (rayEntryDistance < 0) {
		return false;
	}
	this._iPickingCollisionVO.rayEntryDistance = rayEntryDistance;
	this._iPickingCollisionVO.localRayPosition = localRayPosition;
	this._iPickingCollisionVO.localRayDirection = localRayDirection;
	this._iPickingCollisionVO.rayPosition = rayPosition;
	this._iPickingCollisionVO.rayDirection = rayDirection;
	this._iPickingCollisionVO.rayOriginIsInsideBounds = rayEntryDistance == 0;
	return true;
};

away.entities.Entity.prototype.pCreateEntityPartitionNode = function() {
	throw new away.errors.AbstractMethodError(null, 0);
};

away.entities.Entity.prototype.pGetDefaultBoundingVolume = function() {
	return new away.bounds.AxisAlignedBoundingBox();
};

away.entities.Entity.prototype.pUpdateBounds = function() {
	throw new away.errors.AbstractMethodError(null, 0);
};

away.entities.Entity.prototype.pInvalidateSceneTransform = function() {
	if (!this._pIgnoreTransform) {
		away.containers.ObjectContainer3D.prototype.pInvalidateSceneTransform.call(this);
		this._worldBoundsInvalid = true;
		this.notifySceneBoundsInvalid();
	}
};

away.entities.Entity.prototype.pInvalidateBounds = function() {
	this._pBoundsInvalid = true;
	this._worldBoundsInvalid = true;
	this.notifySceneBoundsInvalid();
};

away.entities.Entity.prototype.pUpdateMouseChildren = function() {
	if (this._pParent && !this.get_pickingCollider()) {
		if (this._pParent instanceof away.entities.Entity) {
			var parentEntity = this._pParent;
			var collider = parentEntity.get_pickingCollider();
			if (collider) {
				this.set_pickingCollider(collider);
			}
		}
	}
	away.containers.ObjectContainer3D.prototype.pUpdateMouseChildren.call(this);
};

away.entities.Entity.prototype.notifySceneBoundsInvalid = function() {
	if (this._pScene) {
		this._pScene.iInvalidateEntityBounds(this);
	}
};

away.entities.Entity.prototype.notifyPartitionAssigned = function() {
	if (this._pScene) {
		this._pScene.iRegisterPartition(this);
	}
};

away.entities.Entity.prototype.notifyPartitionUnassigned = function() {
	if (this._pScene) {
		this._pScene.iUnregisterPartition(this);
	}
};

away.entities.Entity.prototype.addBounds = function() {
	if (!this._boundsIsShown) {
		this._boundsIsShown = true;
		this.addChild(this._pBounds.get_boundingRenderable());
	}
};

away.entities.Entity.prototype.removeBounds = function() {
	if (!this._boundsIsShown) {
		this._boundsIsShown = false;
		this.removeChild(this._pBounds.get_boundingRenderable());
		this._pBounds.disposeRenderable();
	}
};

away.entities.Entity.prototype.iInternalUpdate = function() {
	if (this._iController) {
		this._iController.update(true);
	}
};

$inherit(away.entities.Entity, away.containers.ObjectContainer3D);

away.entities.Entity.className = "away.entities.Entity";

away.entities.Entity.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.bounds.AxisAlignedBoundingBox');
	p.push('away.pick.PickingCollisionVO');
	p.push('away.geom.Vector3D');
	p.push('away.errors.AbstractMethodError');
	p.push('away.bounds.BoundingVolumeBase');
	p.push('away.library.assets.AssetType');
	return p;
};

away.entities.Entity.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.entities.Entity.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 1:
			p = away.containers.ObjectContainer3D.injectionPoints(t);
			break;
		case 2:
			p = away.containers.ObjectContainer3D.injectionPoints(t);
			break;
		case 3:
			p = away.containers.ObjectContainer3D.injectionPoints(t);
			break;
		default:
			p = [];
			break;
	}
	return p;
};

