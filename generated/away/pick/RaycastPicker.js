/** Compiled by the Randori compiler v0.2.6.2 on Fri Sep 13 21:41:39 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.pick == "undefined")
	away.pick = {};

away.pick.RaycastPicker = function(findClosestCollision) {
	this._numEntities = 0;
	this._onlyMouseEnabled = true;
	this._entities = null;
	this._ignoredEntities = [];
	this._hasCollisions = null;
	this._findClosestCollision = null;
	this._raycastCollector = new away.traverse.RaycastCollector();
	this._findClosestCollision = findClosestCollision;
	this._entities = [];
};

away.pick.RaycastPicker.prototype.get_onlyMouseEnabled = function() {
	return this._onlyMouseEnabled;
};

away.pick.RaycastPicker.prototype.set_onlyMouseEnabled = function(value) {
	this._onlyMouseEnabled = value;
};

away.pick.RaycastPicker.prototype.getViewCollision = function(x, y, view) {
	var collector = view.get_iEntityCollector();
	if (collector.get_numMouseEnableds() == 0)
		return null;
	var rayPosition = view.unproject(x, y, 0);
	var rayDirection = view.unproject(x, y, 1);
	rayDirection = rayDirection.subtract(rayPosition);
	this._numEntities = 0;
	var node = collector.get_entityHead();
	var entity;
	while (node) {
		entity = node.entity;
		if (this.isIgnored(entity)) {
			node = node.next;
			continue;
		}
		if (entity.get__iIsVisible() && entity.isIntersectingRay(rayPosition, rayDirection))
			this._entities[this._numEntities++] = entity;
		node = node.next;
	}
	if (!this._numEntities)
		return null;
	return this.getPickingCollisionVO();
};

away.pick.RaycastPicker.prototype.getSceneCollision = function(position, direction, scene) {
	this._raycastCollector.clear();
	this._raycastCollector.set_rayPosition(position);
	this._raycastCollector.set_rayDirection(direction);
	scene.traversePartitions(this._raycastCollector);
	this._numEntities = 0;
	var node = this._raycastCollector.get_entityHead();
	var entity;
	while (node) {
		entity = node.entity;
		if (this.isIgnored(entity)) {
			node = node.next;
			continue;
		}
		this._entities[this._numEntities++] = entity;
		node = node.next;
	}
	if (!this._numEntities)
		return null;
	return this.getPickingCollisionVO();
};

away.pick.RaycastPicker.prototype.getEntityCollision = function(position, direction, entities) {
	position = position;
	direction = direction;
	this._numEntities = 0;
	var entity;
	var l = entities.length;
	for (var c = 0; c < l; c++) {
		entity = entities[c];
		if (entity.isIntersectingRay(position, direction)) {
			this._entities[this._numEntities++] = entity;
		}
	}
	return this.getPickingCollisionVO();
};

away.pick.RaycastPicker.prototype.setIgnoreList = function(entities) {
	this._ignoredEntities = entities;
};

away.pick.RaycastPicker.prototype.isIgnored = function(entity) {
	if (this._onlyMouseEnabled && (!entity._iAncestorsAllowMouseEnabled || !entity.get_mouseEnabled())) {
		return true;
	}
	var ignoredEntity;
	var l = this._ignoredEntities.length;
	for (var c = 0; c < l; c++) {
		ignoredEntity = this._ignoredEntities[c];
		if (ignoredEntity == entity) {
			return true;
		}
	}
	return false;
};

away.pick.RaycastPicker.prototype.sortOnNearT = function(entity1, entity2) {
	return entity1.get_pickingCollisionVO().rayEntryDistance > entity2.get_pickingCollisionVO().rayEntryDistance ? 1 : -1;
};

away.pick.RaycastPicker.prototype.getPickingCollisionVO = function() {
	this._entities.length = this._numEntities;
	this._entities = this._entities.sort($createStaticDelegate(this, this.sortOnNearT));
	var shortestCollisionDistance = 1.7976931348623157E308;
	var bestCollisionVO;
	var pickingCollisionVO;
	var entity;
	var i;
	for (i = 0; i < this._numEntities; ++i) {
		entity = this._entities[i];
		pickingCollisionVO = entity._iPickingCollisionVO;
		if (entity.get_pickingCollider()) {
			if ((bestCollisionVO == null || pickingCollisionVO.rayEntryDistance < bestCollisionVO.rayEntryDistance) && entity.iCollidesBefore(shortestCollisionDistance, this._findClosestCollision)) {
				shortestCollisionDistance = pickingCollisionVO.rayEntryDistance;
				bestCollisionVO = pickingCollisionVO;
				if (!this._findClosestCollision) {
					this.updateLocalPosition(pickingCollisionVO);
					return pickingCollisionVO;
				}
			}
		} else if (bestCollisionVO == null || pickingCollisionVO.rayEntryDistance < bestCollisionVO.rayEntryDistance) {
			if (!pickingCollisionVO.rayOriginIsInsideBounds) {
				this.updateLocalPosition(pickingCollisionVO);
				return pickingCollisionVO;
			}
		}
	}
	return bestCollisionVO;
};

away.pick.RaycastPicker.prototype.updateLocalPosition = function(pickingCollisionVO) {
	var collisionPos = (pickingCollisionVO.localPosition == null) ? new away.geom.Vector3D(0, 0, 0, 0) : pickingCollisionVO.localPosition;
	var rayDir = pickingCollisionVO.localRayDirection;
	var rayPos = pickingCollisionVO.localRayPosition;
	var t = pickingCollisionVO.rayEntryDistance;
	collisionPos.x = rayPos.x + t * rayDir.x;
	collisionPos.y = rayPos.y + t * rayDir.y;
	collisionPos.z = rayPos.z + t * rayDir.z;
};

away.pick.RaycastPicker.prototype.dispose = function() {
};

away.pick.RaycastPicker.className = "away.pick.RaycastPicker";

away.pick.RaycastPicker.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.geom.Vector3D');
	return p;
};

away.pick.RaycastPicker.getStaticDependencies = function(t) {
	var p;
	p = [];
	p.push('away.traverse.RaycastCollector');
	return p;
};

away.pick.RaycastPicker.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'findClosestCollision', t:'Boolean'});
			break;
		default:
			p = [];
			break;
	}
	return p;
};

