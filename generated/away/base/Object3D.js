/** Compiled by the Randori compiler v0.2.6.2 on Mon Sep 02 23:32:27 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.base == "undefined")
	away.base = {};

away.base.Object3D = function() {
	this._positionChanged = null;
	this._pScaleX = 1;
	this._zOffset = 0;
	this._transformComponents = null;
	this._pivotPoint = new away.geom.Vector3D(0, 0, 0, 0);
	this.extra = null;
	this._listenToScaleChanged = null;
	this._iController = null;
	this._pPos = new away.geom.Vector3D(0, 0, 0, 0);
	this._pScaleZ = 1;
	this._pScaleY = 1;
	this._rotationChanged = null;
	this._transformDirty = true;
	this._rot = new away.geom.Vector3D(0, 0, 0, 0);
	this._smallestNumber = 0.0000000000000000000001;
	this._rotationX = 0;
	this._rotationZ = 0;
	this._rotationY = 0;
	this._pTransform = new away.geom.Matrix3D();
	this._x = 0;
	this._scaleChanged = null;
	this._y = 0;
	this._z = 0;
	this._sca = new away.geom.Vector3D(0, 0, 0, 0);
	this._rotationDirty = true;
	this._listenToRotationChanged = null;
	this._scaleDirty = true;
	this._positionDirty = true;
	this._eulers = new away.geom.Vector3D(0, 0, 0, 0);
	this._listenToPositionChanged = null;
	this._pivotZero = true;
	this._flipY = new away.geom.Matrix3D();
	away.library.assets.NamedAssetBase.call(this);
	this._transformComponents = [null, null, null];
	this._transformComponents[0] = this._pPos;
	this._transformComponents[1] = this._rot;
	this._transformComponents[2] = this._sca;
	this._pTransform.identity();
	this._flipY.appendScale(1, -1, 1);
};

away.base.Object3D.prototype.invalidatePivot = function() {
	this._pivotZero = (this._pivotPoint.x == 0) && (this._pivotPoint.y == 0) && (this._pivotPoint.z == 0);
	this.iInvalidateTransform();
};

away.base.Object3D.prototype.invalidatePosition = function() {
	if (this._positionDirty)
		return;
	this._positionDirty = true;
	this.iInvalidateTransform();
	if (this._listenToPositionChanged)
		this.notifyPositionChanged();
};

away.base.Object3D.prototype.notifyPositionChanged = function() {
	if (!this._positionChanged) {
		this._positionChanged = new away.events.Object3DEvent(away.events.Object3DEvent.POSITION_CHANGED, this);
	}
	this.dispatchEvent(this._positionChanged);
};

away.base.Object3D.prototype.addEventListener = function(type, listener, target) {
	away.library.assets.NamedAssetBase.prototype.addEventListener.call(this,type, $createStaticDelegate(this, listener), target);
	switch (type) {
		case away.events.Object3DEvent.POSITION_CHANGED:
			this._listenToPositionChanged = true;
			break;
		case away.events.Object3DEvent.ROTATION_CHANGED:
			this._listenToRotationChanged = true;
			break;
		case away.events.Object3DEvent.SCALE_CHANGED:
			this._listenToRotationChanged = true;
			break;
	}
};

away.base.Object3D.prototype.removeEventListener = function(type, listener, target) {
	away.library.assets.NamedAssetBase.prototype.removeEventListener.call(this,type, $createStaticDelegate(this, listener), target);
	if (this.hasEventListener(type, $createStaticDelegate(this, listener), target))
		return;
	switch (type) {
		case away.events.Object3DEvent.POSITION_CHANGED:
			this._listenToPositionChanged = false;
			break;
		case away.events.Object3DEvent.ROTATION_CHANGED:
			this._listenToRotationChanged = false;
			break;
		case away.events.Object3DEvent.SCALE_CHANGED:
			this._listenToScaleChanged = false;
			break;
	}
};

away.base.Object3D.prototype.invalidateRotation = function() {
	if (this._rotationDirty) {
		return;
	}
	this._rotationDirty = true;
	this.iInvalidateTransform();
	if (this._listenToRotationChanged)
		this.notifyRotationChanged();
};

away.base.Object3D.prototype.notifyRotationChanged = function() {
	if (!this._rotationChanged)
		this._rotationChanged = new away.events.Object3DEvent(away.events.Object3DEvent.ROTATION_CHANGED, this);
	this.dispatchEvent(this._rotationChanged);
};

away.base.Object3D.prototype.invalidateScale = function() {
	if (this._scaleDirty) {
		return;
	}
	this._scaleDirty = true;
	this.iInvalidateTransform();
	if (this._listenToScaleChanged)
		this.notifyScaleChanged();
};

away.base.Object3D.prototype.notifyScaleChanged = function() {
	if (!this._scaleChanged)
		this._scaleChanged = new away.events.Object3DEvent(away.events.Object3DEvent.SCALE_CHANGED, this);
	this.dispatchEvent(this._scaleChanged);
};

away.base.Object3D.prototype.get_x = function() {
	return this._x;
};

away.base.Object3D.prototype.set_x = function(val) {
	if (this._x == val) {
		return;
	}
	this._x = val;
	this.invalidatePosition();
};

away.base.Object3D.prototype.get_y = function() {
	return this._y;
};

away.base.Object3D.prototype.set_y = function(val) {
	if (this._y == val) {
		return;
	}
	this._y = val;
	this.invalidatePosition();
};

away.base.Object3D.prototype.get_z = function() {
	return this._z;
};

away.base.Object3D.prototype.set_z = function(val) {
	if (this._z == val) {
		return;
	}
	this._z = val;
	this.invalidatePosition();
};

away.base.Object3D.prototype.get_rotationX = function() {
	return this._rotationX * away.math.MathConsts.RADIANS_TO_DEGREES;
};

away.base.Object3D.prototype.set_rotationX = function(val) {
	if (this.get_rotationX() == val) {
		return;
	}
	this._rotationX = val * away.math.MathConsts.DEGREES_TO_RADIANS;
	this.invalidateRotation();
};

away.base.Object3D.prototype.get_rotationY = function() {
	return this._rotationY * away.math.MathConsts.RADIANS_TO_DEGREES;
};

away.base.Object3D.prototype.set_rotationY = function(val) {
	if (this.get_rotationY() == val) {
		return;
	}
	this._rotationY = val * away.math.MathConsts.DEGREES_TO_RADIANS;
	this.invalidateRotation();
};

away.base.Object3D.prototype.get_rotationZ = function() {
	return this._rotationZ * away.math.MathConsts.RADIANS_TO_DEGREES;
};

away.base.Object3D.prototype.set_rotationZ = function(val) {
	if (this.get_rotationZ() == val) {
		return;
	}
	this._rotationZ = val * away.math.MathConsts.DEGREES_TO_RADIANS;
	this.invalidateRotation();
};

away.base.Object3D.prototype.get_scaleX = function() {
	return this._pScaleX;
};

away.base.Object3D.prototype.set_scaleX = function(val) {
	if (this._pScaleX == val) {
		return;
	}
	this._pScaleX = val;
	this.invalidateScale();
};

away.base.Object3D.prototype.get_scaleY = function() {
	return this._pScaleY;
};

away.base.Object3D.prototype.set_scaleY = function(val) {
	if (this._pScaleY == val) {
		return;
	}
	this._pScaleY = val;
	this.invalidateScale();
};

away.base.Object3D.prototype.get_scaleZ = function() {
	return this._pScaleZ;
};

away.base.Object3D.prototype.set_scaleZ = function(val) {
	if (this._pScaleZ == val) {
		return;
	}
	this._pScaleZ = val;
	this.invalidateScale();
};

away.base.Object3D.prototype.get_eulers = function() {
	this._eulers.x = this._rotationX * away.math.MathConsts.RADIANS_TO_DEGREES;
	this._eulers.y = this._rotationY * away.math.MathConsts.RADIANS_TO_DEGREES;
	this._eulers.z = this._rotationZ * away.math.MathConsts.RADIANS_TO_DEGREES;
	return this._eulers;
};

away.base.Object3D.prototype.set_eulers = function(value) {
	this._rotationX = value.x * away.math.MathConsts.DEGREES_TO_RADIANS;
	this._rotationY = value.y * away.math.MathConsts.DEGREES_TO_RADIANS;
	this._rotationZ = value.z * away.math.MathConsts.DEGREES_TO_RADIANS;
	this.invalidateRotation();
};

away.base.Object3D.prototype.get_transform = function() {
	if (this._transformDirty) {
		this.pUpdateTransform();
	}
	return this._pTransform;
};

away.base.Object3D.prototype.set_transform = function(val) {
	if (!val.rawData[0]) {
		var raw = away.math.Matrix3DUtils.RAW_DATA_CONTAINER;
		val.copyRawDataTo(raw, 0, false);
		raw[0] = this._smallestNumber;
		val.copyRawDataFrom(raw, 0, false);
	}
	var elements = val.decompose();
	var vec;
	vec = elements[0];
	if (this._x != vec.x || this._y != vec.y || this._z != vec.z) {
		this._x = vec.x;
		this._y = vec.y;
		this._z = vec.z;
		this.invalidatePosition();
	}
	vec = elements[1];
	if (this._rotationX != vec.x || this._rotationY != vec.y || this._rotationZ != vec.z) {
		this._rotationX = vec.x;
		this._rotationY = vec.y;
		this._rotationZ = vec.z;
		this.invalidateRotation();
	}
	vec = elements[2];
	if (this._pScaleX != vec.x || this._pScaleY != vec.y || this._pScaleZ != vec.z) {
		this._pScaleX = vec.x;
		this._pScaleY = vec.y;
		this._pScaleZ = vec.z;
		this.invalidateScale();
	}
};

away.base.Object3D.prototype.get_pivotPoint = function() {
	return this._pivotPoint;
};

away.base.Object3D.prototype.set_pivotPoint = function(pivot) {
	this._pivotPoint = pivot.clone();
	this.invalidatePivot();
};

away.base.Object3D.prototype.get_position = function() {
	this._pTransform.copyColumnTo(3, this._pPos);
	return this._pPos.clone();
};

away.base.Object3D.prototype.set_position = function(value) {
	this._x = value.x;
	this._y = value.y;
	this._z = value.z;
	this.invalidatePosition();
};

away.base.Object3D.prototype.get_forwardVector = function() {
	return away.math.Matrix3DUtils.getForward(this.get_transform());
};

away.base.Object3D.prototype.get_rightVector = function() {
	return away.math.Matrix3DUtils.getRight(this.get_transform());
};

away.base.Object3D.prototype.get_upVector = function() {
	return away.math.Matrix3DUtils.getUp(this.get_transform());
};

away.base.Object3D.prototype.get_backVector = function() {
	var director = away.math.Matrix3DUtils.getForward(this.get_transform());
	director.negate();
	return director;
};

away.base.Object3D.prototype.get_leftVector = function() {
	var director = away.math.Matrix3DUtils.getRight(this.get_transform());
	director.negate();
	return director;
};

away.base.Object3D.prototype.get_downVector = function() {
	var director = away.math.Matrix3DUtils.getUp(this.get_transform());
	director.negate();
	return director;
};

away.base.Object3D.prototype.scale = function(value) {
	this._pScaleX *= value;
	this._pScaleY *= value;
	this._pScaleZ *= value;
	this.invalidateScale();
};

away.base.Object3D.prototype.moveForward = function(distance) {
	this.translateLocal(away.geom.Vector3D.Z_AXIS, distance);
};

away.base.Object3D.prototype.moveBackward = function(distance) {
	this.translateLocal(away.geom.Vector3D.Z_AXIS, -distance);
};

away.base.Object3D.prototype.moveLeft = function(distance) {
	this.translateLocal(away.geom.Vector3D.X_AXIS, -distance);
};

away.base.Object3D.prototype.moveRight = function(distance) {
	this.translateLocal(away.geom.Vector3D.X_AXIS, distance);
};

away.base.Object3D.prototype.moveUp = function(distance) {
	this.translateLocal(away.geom.Vector3D.Y_AXIS, distance);
};

away.base.Object3D.prototype.moveDown = function(distance) {
	this.translateLocal(away.geom.Vector3D.Y_AXIS, -distance);
};

away.base.Object3D.prototype.moveTo = function(dx, dy, dz) {
	if (this._x == dx && this._y == dy && this._z == dz) {
		return;
	}
	this._x = dx;
	this._y = dy;
	this._z = dz;
	this.invalidatePosition();
};

away.base.Object3D.prototype.movePivot = function(dx, dy, dz) {
	if (this._pivotPoint == null) {
		this._pivotPoint = new away.geom.Vector3D(0, 0, 0, 0);
	}
	this._pivotPoint.x += dx;
	this._pivotPoint.y += dy;
	this._pivotPoint.z += dz;
	this.invalidatePivot();
};

away.base.Object3D.prototype.translate = function(axis, distance) {
	var x = axis.x, y = axis.y, z = axis.z;
	var len = distance / Math.sqrt(x * x + y * y + z * z);
	this._x += x * len;
	this._y += y * len;
	this._z += z * len;
	this.invalidatePosition();
};

away.base.Object3D.prototype.translateLocal = function(axis, distance) {
	var x = axis.x, y = axis.y, z = axis.z;
	var len = distance / Math.sqrt(x * x + y * y + z * z);
	this.get_transform().prependTranslation(x * len, y * len, z * len);
	this._pTransform.copyColumnTo(3, this._pPos);
	this._x = this._pPos.x;
	this._y = this._pPos.y;
	this._z = this._pPos.z;
	this.invalidatePosition();
};

away.base.Object3D.prototype.pitch = function(angle) {
	this.rotate(away.geom.Vector3D.X_AXIS, angle);
};

away.base.Object3D.prototype.yaw = function(angle) {
	this.rotate(away.geom.Vector3D.Y_AXIS, angle);
};

away.base.Object3D.prototype.roll = function(angle) {
	this.rotate(away.geom.Vector3D.Z_AXIS, angle);
};

away.base.Object3D.prototype.clone = function() {
	var clone = new away.base.Object3D();
	clone.set_pivotPoint($createStaticDelegate(this, this.get_pivotPoint));
	clone.set_transform($createStaticDelegate(this, this.get_transform));
	clone.set_name($createStaticDelegate(this, this.get_name));
	return clone;
};

away.base.Object3D.prototype.rotateTo = function(ax, ay, az) {
	this._rotationX = ax * away.math.MathConsts.DEGREES_TO_RADIANS;
	this._rotationY = ay * away.math.MathConsts.DEGREES_TO_RADIANS;
	this._rotationZ = az * away.math.MathConsts.DEGREES_TO_RADIANS;
	this.invalidateRotation();
};

away.base.Object3D.prototype.rotate = function(axis, angle) {
	this.get_transform().prependRotation(angle, axis);
	this.set_transform($createStaticDelegate(this, this.get_transform));
};

away.base.Object3D.prototype.lookAt = function(target, upAxis) {
	var yAxis;
	var zAxis;
	var xAxis;
	var raw;
	if (upAxis == null) {
		upAxis = away.geom.Vector3D.Y_AXIS;
	}
	zAxis = target.subtract(this.get_position());
	zAxis.normalize();
	xAxis = upAxis.crossProduct(zAxis);
	xAxis.normalize();
	if (xAxis.get_length() < .05)
		xAxis = upAxis.crossProduct(away.geom.Vector3D.Z_AXIS);
	yAxis = zAxis.crossProduct(xAxis);
	raw = away.math.Matrix3DUtils.RAW_DATA_CONTAINER;
	raw[0] = this._pScaleX * xAxis.x;
	raw[1] = this._pScaleX * xAxis.y;
	raw[2] = this._pScaleX * xAxis.z;
	raw[3] = 0;
	raw[4] = this._pScaleY * yAxis.x;
	raw[5] = this._pScaleY * yAxis.y;
	raw[6] = this._pScaleY * yAxis.z;
	raw[7] = 0;
	raw[8] = this._pScaleZ * zAxis.x;
	raw[9] = this._pScaleZ * zAxis.y;
	raw[10] = this._pScaleZ * zAxis.z;
	raw[11] = 0;
	raw[12] = this._x;
	raw[13] = this._y;
	raw[14] = this._z;
	raw[15] = 1;
	this._pTransform.copyRawDataFrom(raw, 0, false);
	this.set_transform($createStaticDelegate(this, this.get_transform));
	if (zAxis.z < 0) {
		this.set_rotationY((180 - $createStaticDelegate(this, this.get_rotationY)));
		this.set_rotationX(this.get_rotationX() - 180);
		this.set_rotationZ(this.get_rotationZ() - 180);
	}
};

away.base.Object3D.prototype.dispose = function() {
};

away.base.Object3D.prototype.disposeAsset = function() {
	this.dispose();
};

away.base.Object3D.prototype.iInvalidateTransform = function() {
	this._transformDirty = true;
};

away.base.Object3D.prototype.pUpdateTransform = function() {
	this._pPos.x = this._x;
	this._pPos.y = this._y;
	this._pPos.z = this._z;
	this._rot.x = this._rotationX;
	this._rot.y = this._rotationY;
	this._rot.z = this._rotationZ;
	this._sca.x = this._pScaleX;
	this._sca.y = this._pScaleY;
	this._sca.z = this._pScaleZ;
	this._pTransform.recompose(this._transformComponents);
	if (!this._pivotZero) {
		this._pTransform.prependTranslation(-this._pivotPoint.x, -this._pivotPoint.y, -this._pivotPoint.z);
		this._pTransform.appendTranslation(this._pivotPoint.x, this._pivotPoint.y, this._pivotPoint.z);
	}
	this._transformDirty = false;
	this._positionDirty = false;
	this._rotationDirty = false;
	this._scaleDirty = false;
};

away.base.Object3D.prototype.get_zOffset = function() {
	return this._zOffset;
};

away.base.Object3D.prototype.set_zOffset = function(value) {
	this._zOffset = value;
};

$inherit(away.base.Object3D, away.library.assets.NamedAssetBase);

away.base.Object3D.className = "away.base.Object3D";

away.base.Object3D.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.math.MathConsts');
	p.push('away.geom.Vector3D');
	p.push('away.events.Object3DEvent');
	p.push('away.math.Matrix3DUtils');
	return p;
};

away.base.Object3D.getStaticDependencies = function(t) {
	var p;
	p = [];
	p.push('away.geom.Vector3D');
	p.push('away.geom.Matrix3D');
	return p;
};

away.base.Object3D.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 1:
			p = away.library.assets.NamedAssetBase.injectionPoints(t);
			break;
		case 2:
			p = away.library.assets.NamedAssetBase.injectionPoints(t);
			break;
		case 3:
			p = away.library.assets.NamedAssetBase.injectionPoints(t);
			break;
		default:
			p = [];
			break;
	}
	return p;
};

