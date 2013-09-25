/** Compiled by the Randori compiler v0.2.6.2 on Wed Sep 25 08:00:54 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.containers == "undefined")
	away.containers = {};

away.containers.ObjectContainer3D = function() {
	this._pSceneTransform = new away.geom.Matrix3D();
	this._listenToSceneTransformChanged = false;
	this._pIgnoreTransform = false;
	this._inverseSceneTransformDirty = true;
	this._scenechanged = null;
	this._iIsRoot = false;
	this._iAncestorsAllowMouseEnabled = false;
	this._pExplicitPartition = null;
	this._inverseSceneTransform = new away.geom.Matrix3D();
	this._pSceneTransformDirty = true;
	this._implicitVisibility = true;
	this._listenToSceneChanged = false;
	this._explicitVisibility = true;
	this._pScene = null;
	this._scenePosition = new away.geom.Vector3D(0, 0, 0, 0);
	this._oldScene = null;
	this._sceneTransformChanged = null;
	this._scenePositionDirty = true;
	this._children = [];
	this._pParent = null;
	this._mouseChildren = true;
	this._pMouseEnabled = false;
	this._pImplicitPartition = null;
	away.base.Object3D.call(this);
};

away.containers.ObjectContainer3D.prototype.getIgnoreTransform = function() {
	return this._pIgnoreTransform;
};

away.containers.ObjectContainer3D.prototype.setIgnoreTransform = function(value) {
	this._pIgnoreTransform = value;
	this._pSceneTransformDirty = !value;
	this._inverseSceneTransformDirty = !value;
	this._scenePositionDirty = !value;
	if (value) {
		this._pSceneTransform.identity();
		this._scenePosition.setTo(0, 0, 0);
	}
};

away.containers.ObjectContainer3D.prototype.iGetImplicitPartition = function() {
	return this._pImplicitPartition;
};

away.containers.ObjectContainer3D.prototype.iSetImplicitPartition = function(value) {
	if (value == this._pImplicitPartition)
		return;
	var i = 0;
	var len = this._children.length;
	var child;
	this._pImplicitPartition = value;
	while (i < len) {
		child = this._children[i++];
		if (!child._pExplicitPartition)
			child._pImplicitPartition = value;
	}
};

away.containers.ObjectContainer3D.prototype.get__iIsVisible = function() {
	return this._implicitVisibility && this._explicitVisibility;
};

away.containers.ObjectContainer3D.prototype.iSetParent = function(value) {
	this._pParent = value;
	this.pUpdateMouseChildren();
	if (value == null) {
		this.set_scene(null);
		return;
	}
	this.notifySceneTransformChange();
	this.notifySceneChange();
};

away.containers.ObjectContainer3D.prototype.notifySceneTransformChange = function() {
	if (this._pSceneTransformDirty || this._pIgnoreTransform) {
		return;
	}
	this.pInvalidateSceneTransform();
	var i = 0;
	var len = this._children.length;
	while (i < len) {
		this._children[i++].notifySceneTransformChange();
	}
	if (this._listenToSceneTransformChanged) {
		if (!this._sceneTransformChanged) {
			this._sceneTransformChanged = new away.events.Object3DEvent(away.events.Object3DEvent.SCENETRANSFORM_CHANGED, this);
		}
		this.dispatchEvent(this._sceneTransformChanged);
	}
};

away.containers.ObjectContainer3D.prototype.notifySceneChange = function() {
	this.notifySceneTransformChange();
	var i;
	var len = this._children.length;
	while (i < len) {
		this._children[i++].notifySceneChange();
	}
	if (this._listenToSceneChanged) {
		if (!this._scenechanged) {
			this._scenechanged = new away.events.Object3DEvent(away.events.Object3DEvent.SCENE_CHANGED, this);
		}
		this.dispatchEvent(this._scenechanged);
	}
};

away.containers.ObjectContainer3D.prototype.pUpdateMouseChildren = function() {
	if (this._pParent && !this._pParent._iIsRoot) {
		this._iAncestorsAllowMouseEnabled = this._pParent._iAncestorsAllowMouseEnabled && this._pParent.get_mouseChildren();
	} else {
		this._iAncestorsAllowMouseEnabled = this.get_mouseChildren();
	}
	var len = this._children.length;
	for (var i = 0; i < len; ++i) {
		this._children[i].pUpdateMouseChildren();
	}
};

away.containers.ObjectContainer3D.prototype.get_mouseEnabled = function() {
	return this._pMouseEnabled;
};

away.containers.ObjectContainer3D.prototype.set_mouseEnabled = function(value) {
	this._pMouseEnabled = value;
	this.pUpdateMouseChildren();
};

away.containers.ObjectContainer3D.prototype.iInvalidateTransform = function() {
	away.base.Object3D.prototype.iInvalidateTransform.call(this);
	this.notifySceneTransformChange();
};

away.containers.ObjectContainer3D.prototype.pInvalidateSceneTransform = function() {
	this._pSceneTransformDirty = !this._pIgnoreTransform;
	this._inverseSceneTransformDirty = !this._pIgnoreTransform;
	this._scenePositionDirty = !this._pIgnoreTransform;
};

away.containers.ObjectContainer3D.prototype.pUpdateSceneTransform = function() {
	if (this._pParent && !this._pParent._iIsRoot) {
		this._pSceneTransform.copyFrom(this._pParent.get_sceneTransform());
		this._pSceneTransform.prepend(this.get_transform());
	} else {
		this._pSceneTransform.copyFrom(this.get_transform());
	}
	this._pSceneTransformDirty = false;
};

away.containers.ObjectContainer3D.prototype.get_mouseChildren = function() {
	return this._mouseChildren;
};

away.containers.ObjectContainer3D.prototype.set_mouseChildren = function(value) {
	this._mouseChildren = value;
	this.pUpdateMouseChildren();
};

away.containers.ObjectContainer3D.prototype.get_visible = function() {
	return this._explicitVisibility;
};

away.containers.ObjectContainer3D.prototype.set_visible = function(value) {
	var len = this._children.length;
	this._explicitVisibility = value;
	for (var i = 0; i < len; ++i) {
		this._children[i].updateImplicitVisibility();
	}
};

away.containers.ObjectContainer3D.prototype.get_assetType = function() {
	return away.library.assets.AssetType.CONTAINER;
};

away.containers.ObjectContainer3D.prototype.get_scenePosition = function() {
	if (this._scenePositionDirty) {
		this.get_sceneTransform().copyColumnTo(3, this._scenePosition);
		this._scenePositionDirty = false;
	}
	return this._scenePosition;
};

away.containers.ObjectContainer3D.prototype.get_minX = function() {
	var i;
	var len = this._children.length;
	var min = Infinity;
	var m;
	while (i < len) {
		var child = this._children[i++];
		m = child.get_minX() + child.get_x();
		if (m < min) {
			min = m;
		}
	}
	return min;
};

away.containers.ObjectContainer3D.prototype.get_minY = function() {
	var i;
	var len = this._children.length;
	var min = Infinity;
	var m;
	while (i < len) {
		var child = this._children[i++];
		m = child.get_minY() + child.get_y();
		if (m < min) {
			min = m;
		}
	}
	return min;
};

away.containers.ObjectContainer3D.prototype.get_minZ = function() {
	var i;
	var len = this._children.length;
	var min = Infinity;
	var m;
	while (i < len) {
		var child = this._children[i++];
		m = child.get_minZ() + child.get_z();
		if (m < min) {
			min = m;
		}
	}
	return min;
};

away.containers.ObjectContainer3D.prototype.get_maxX = function() {
	var i;
	var len = this._children.length;
	var max = -Infinity;
	var m;
	while (i < len) {
		var child = this._children[i++];
		m = child.get_maxX() + child.get_x();
		if (m > max) {
			max = m;
		}
	}
	return max;
};

away.containers.ObjectContainer3D.prototype.get_maxY = function() {
	var i;
	var len = this._children.length;
	var max = -Infinity;
	var m;
	while (i < len) {
		var child = this._children[i++];
		m = child.get_maxY() + child.get_y();
		if (m > max) {
			max = m;
		}
	}
	return max;
};

away.containers.ObjectContainer3D.prototype.get_maxZ = function() {
	var i;
	var len = this._children.length;
	var max = -Infinity;
	var m;
	while (i < len) {
		var child = this._children[i++];
		m = child.get_maxZ() + child.get_z();
		if (m > max) {
			max = m;
		}
	}
	return max;
};

away.containers.ObjectContainer3D.prototype.get_partition = function() {
	return this._pExplicitPartition;
};

away.containers.ObjectContainer3D.prototype.set_partition = function(value) {
	this._pExplicitPartition = value;
	this.iSetImplicitPartition(value ? value : this._pParent ? this._pParent.iGetImplicitPartition() : null);
};

away.containers.ObjectContainer3D.prototype.get_sceneTransform = function() {
	if (this._pSceneTransformDirty) {
		this.pUpdateSceneTransform();
	}
	return this._pSceneTransform;
};

away.containers.ObjectContainer3D.prototype.get_scene = function() {
	return this._pScene;
};

away.containers.ObjectContainer3D.prototype.set_scene = function(value) {
	this.setScene(value);
};

away.containers.ObjectContainer3D.prototype.setScene = function(value) {
	var i = 0;
	var len = this._children.length;
	while (i < len) {
		this._children[i++].scene = value;
	}
	if (this._pScene == value)
		return;
	if (value == null)
		this._oldScene = this._pScene;
	if (this._pExplicitPartition && this._oldScene && this._oldScene != this._pScene)
		this.set_partition(null);
	if (value) {
		this._oldScene = null;
	}
	this._pScene = value;
	if (this._pScene) {
		this._pScene.dispatchEvent(new away.events.Scene3DEvent(away.events.Scene3DEvent.ADDED_TO_SCENE, this));
	} else if (this._oldScene) {
		this._oldScene.dispatchEvent(new away.events.Scene3DEvent(away.events.Scene3DEvent.REMOVED_FROM_SCENE, this));
	}
};

away.containers.ObjectContainer3D.prototype.get_inverseSceneTransform = function() {
	if (this._inverseSceneTransformDirty) {
		this._inverseSceneTransform.copyFrom(this.get_sceneTransform());
		this._inverseSceneTransform.invert();
		this._inverseSceneTransformDirty = false;
	}
	return this._inverseSceneTransform;
};

away.containers.ObjectContainer3D.prototype.get_parent = function() {
	return this._pParent;
};

away.containers.ObjectContainer3D.prototype.contains = function(child) {
	return this._children.indexOf(child, 0) >= 0;
};

away.containers.ObjectContainer3D.prototype.addChild = function(child) {
	if (child == null) {
		throw new away.errors.Error("Parameter child cannot be null.", 0, "");
	}
	if (child._pParent) {
		child._pParent.removeChild(child);
	}
	if (!child._pExplicitPartition) {
		child.iSetImplicitPartition(this._pImplicitPartition);
	}
	child.iSetParent(this);
	child.set_scene(this._pScene);
	child.notifySceneTransformChange();
	child.pUpdateMouseChildren();
	child.updateImplicitVisibility();
	this._children.push(child);
	return child;
};

away.containers.ObjectContainer3D.prototype.addChildren = function(childarray) {
	for (var child in childarray) {
		this.addChild(child);
	}
};

away.containers.ObjectContainer3D.prototype.removeChild = function(child) {
	if (child == null) {
		throw new away.errors.Error("Parameter child cannot be null", 0, "");
	}
	var childIndex = this._children.indexOf(child, 0);
	if (childIndex == -1) {
		throw new away.errors.Error("Parameter is not a child of the caller", 0, "");
	}
	this.removeChildInternal(childIndex, child);
};

away.containers.ObjectContainer3D.prototype.removeChildAt = function(index) {
	var child = this._children[index];
	this.removeChildInternal(index, child);
};

away.containers.ObjectContainer3D.prototype.removeChildInternal = function(childIndex, child) {
	this._children.splice(childIndex, 1);
	child.iSetParent(null);
	if (!child._pExplicitPartition) {
		child.iSetImplicitPartition(null);
	}
};

away.containers.ObjectContainer3D.prototype.getChildAt = function(index) {
	return this._children[index];
};

away.containers.ObjectContainer3D.prototype.get_numChildren = function() {
	return this._children.length;
};

away.containers.ObjectContainer3D.prototype.lookAt = function(target, upAxis) {
	upAxis = upAxis || null;
	away.base.Object3D.prototype.lookAt.call(this,target, upAxis);
	this.notifySceneTransformChange();
};

away.containers.ObjectContainer3D.prototype.translateLocal = function(axis, distance) {
	away.base.Object3D.prototype.translateLocal.call(this,axis, distance);
	this.notifySceneTransformChange();
};

away.containers.ObjectContainer3D.prototype.dispose = function() {
	if (this.get_parent()) {
		this.get_parent().removeChild(this);
	}
};

away.containers.ObjectContainer3D.prototype.disposeWithChildren = function() {
	this.dispose();
	while (this.get_numChildren() > 0) {
		this.getChildAt(0).dispose();
	}
};

away.containers.ObjectContainer3D.prototype.clone = function() {
	var clone = new away.containers.ObjectContainer3D();
	clone.set_pivotPoint(this.get_pivotPoint());
	clone.set_transform(this.get_transform());
	clone.set_partition(this.get_partition());
	clone.set_name($createStaticDelegate(this, this.get_name));
	var len = this._children.length;
	for (var i = 0; i < len; ++i) {
		clone.addChild(this._children[i].clone());
	}
	return clone;
};

away.containers.ObjectContainer3D.prototype.rotate = function(axis, angle) {
	away.base.Object3D.prototype.rotate.call(this,axis, angle);
	this.notifySceneTransformChange();
};

away.containers.ObjectContainer3D.prototype.updateImplicitVisibility = function() {
	var len = this._children.length;
	this._implicitVisibility = this._pParent._explicitVisibility && this._pParent._implicitVisibility;
	for (var i = 0; i < len; ++i) {
		this._children[i].updateImplicitVisibility();
	}
};

$inherit(away.containers.ObjectContainer3D, away.base.Object3D);

away.containers.ObjectContainer3D.className = "away.containers.ObjectContainer3D";

away.containers.ObjectContainer3D.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.events.Object3DEvent');
	p.push('away.events.Scene3DEvent');
	p.push('away.library.assets.AssetType');
	return p;
};

away.containers.ObjectContainer3D.getStaticDependencies = function(t) {
	var p;
	p = [];
	p.push('away.geom.Vector3D');
	p.push('away.geom.Matrix3D');
	return p;
};

away.containers.ObjectContainer3D.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 1:
			p = away.base.Object3D.injectionPoints(t);
			break;
		case 2:
			p = away.base.Object3D.injectionPoints(t);
			break;
		case 3:
			p = away.base.Object3D.injectionPoints(t);
			break;
		default:
			p = [];
			break;
	}
	return p;
};

