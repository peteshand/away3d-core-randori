///<reference path="../_definitions.ts" />
package away.base
{
	import away.library.assets.NamedAssetBase;
	import away.controllers.ControllerBase;
	import away.events.Object3DEvent;
	import away.geom.Vector3D;
	import away.geom.Matrix3D;
	import away.math.MathConsts;
	import away.math.Matrix3DUtils;
	//import away3d.arcane;
	//import away3d.controllers.*;
	//import away3d.core.math.*;
	//import away3d.events.*;
	//import away3d.library.assets.*;
	
	//import flash.geom.Matrix3D;
	//import flash.geom.Vector3D;
	
	//use namespace arcane;
	
	/**
	 * Dispatched when the position of the 3d object changes.
	 *
	 * @eventType away3d.events.Object3DEvent
	 */
	//[Event(name="positionChanged", type="away3d.events.Object3DEvent")]
	
	/**
	 * Dispatched when the scale of the 3d object changes.
	 *
	 * @eventType away3d.events.Object3DEvent
	 */
	//[Event(name="scaleChanged", type="away3d.events.Object3DEvent")]
	
	/**
	 * Dispatched when the rotation of the 3d object changes.
	 *
	 * @eventType away3d.events.Object3DEvent
	 */
	//[Event(name="rotationChanged", type="away3d.events.Object3DEvent")]
	
	/**
	 * Object3D provides a base class for any 3D object that has a (local) transformation.<br/><br/>
	 *
	 * Standard Transform:
	 * <ul>
	 *     <li> The standard order for transformation is [parent transform] * (Translate+Pivot) * (Rotate) * (-Pivot) * (Scale) * [child transform] </li>
	 *     <li> This is the order of matrix multiplications, left-to-right. </li>
	 *     <li> The order of transformation is right-to-left, however!
	 *          (Scale) happens before (-Pivot) happens before (Rotate) happens before (Translate+Pivot)
	 *          with no pivot, the above transform works out to [parent transform] * Translate * Rotate * Scale * [child transform]
	 *          (Scale) happens before (Rotate) happens before (Translate) </li>
	 *     <li> This is based on code in updateTransform and ObjectContainer3D.updateSceneTransform(). </li>
	 *     <li> Matrix3D prepend = operator on rhs - e.g. transform' = transform * rhs; </li>
	 *     <li> Matrix3D append =  operator on lhr - e.g. transform' = lhs * transform; </li>
	 * </ul>
	 *
	 * To affect Scale:
	 * <ul>
	 *     <li> set scaleX/Y/Z directly, or call scale(delta) </li>
	 * </ul>
	 *
	 * To affect Pivot:
	 * <ul>
	 *     <li> set pivotPoint directly, or call movePivot() </li>
	 * </ul>
	 *
	 * To affect Rotate:
	 * <ul>
	 *    <li> set rotationX/Y/Z individually (using degrees), set eulers [all 3 angles] (using radians), or call rotateTo()</li>
	 *    <li> call pitch()/yaw()/roll()/rotate() to add an additional rotation *before* the current transform.
	 *         rotationX/Y/Z will be reset based on these operations. </li>
	 * </ul>
	 *
	 * To affect Translate (post-rotate translate):
	 *
	 * <ul>
	 *    <li> set x/y/z/position or call moveTo(). </li>
	 *    <li> call translate(), which modifies x/y/z based on a delta vector. </li>
	 *    <li> call moveForward()/moveBackward()/moveLeft()/moveRight()/moveUp()/moveDown()/translateLocal() to add an
	 *         additional translate *before* the current transform. x/y/z will be reset based on these operations. </li>
	 * </ul>
	 */
	public class Object3D extends NamedAssetBase
	{
		/** @private */
		public var _iController:ControllerBase; // Arcane
		
		private var _smallestNumber:Number = 0.0000000000000000000001;
		private var _transformDirty:Boolean = true;
		
		private var _positionDirty:Boolean = true;
		private var _rotationDirty:Boolean = true;
		private var _scaleDirty:Boolean = true;
		
		// TODO: not used
		// private var _positionValuesDirty:boolean;
		// private var _rotationValuesDirty:boolean;
		// private var _scaleValuesDirty:boolean;

		private var _positionChanged:Object3DEvent;
		private var _rotationChanged:Object3DEvent;
		private var _scaleChanged:Object3DEvent;

		private var _rotationX:Number = 0;
		private var _rotationY:Number = 0;
		private var _rotationZ:Number = 0;
		private var _eulers:Vector3D = new Vector3D();
		private var _flipY:Matrix3D = new Matrix3D();

		private var _listenToPositionChanged:Boolean;
		private var _listenToRotationChanged:Boolean;
		private var _listenToScaleChanged:Boolean;
		private var _zOffset:Number = 0;
		
		private function invalidatePivot():void
		{
			_pivotZero = (_pivotPoint.x == 0) && (_pivotPoint.y == 0) && (_pivotPoint.z == 0);
			iInvalidateTransform();

		}
		
		private function invalidatePosition():void
		{
			if (_positionDirty)
				return;
			
			_positionDirty = true;
			
			iInvalidateTransform();

			if (_listenToPositionChanged)
				notifyPositionChanged();

		}

		private function notifyPositionChanged():void
		{
			if (!_positionChanged)
            {


				_positionChanged = new Object3DEvent(Object3DEvent.POSITION_CHANGED, this);

            }
			dispatchEvent( _positionChanged );
		}


		override public function addEventListener(type:String, listener:Function, target:Object):void
		{
			super.addEventListener(type, listener, target ) ;//, priority, useWeakReference);

			switch (type) {
				case Object3DEvent.POSITION_CHANGED:
                    _listenToPositionChanged = true;
					break;
				case Object3DEvent.ROTATION_CHANGED:
                    _listenToRotationChanged = true;
					break;
				case Object3DEvent.SCALE_CHANGED:
					_listenToRotationChanged = true;
					break;
			}
		}

		override public function removeEventListener(type:String, listener:Function, target:Object):void
		{
			super.removeEventListener(type, listener, target);
			
			if (hasEventListener(type , listener , target ))
				return;
			
			switch (type) {

				case Object3DEvent.POSITION_CHANGED:
					_listenToPositionChanged = false;
					break;

				case Object3DEvent.ROTATION_CHANGED:
                    _listenToRotationChanged = false;
					break;

				case Object3DEvent.SCALE_CHANGED:
                    _listenToScaleChanged = false;
					break;
			}
		}

		private function invalidateRotation():void
		{
			if (_rotationDirty)
            {

                return;

            }

			_rotationDirty = true;
			
			iInvalidateTransform();


			if (_listenToRotationChanged)
				notifyRotationChanged();


		}

		private function notifyRotationChanged():void
		{
			if (!_rotationChanged)
				_rotationChanged = new Object3DEvent(Object3DEvent.ROTATION_CHANGED, this);
			
			dispatchEvent(_rotationChanged);
		}

		private function invalidateScale():void
		{
			if (_scaleDirty)
            {

                return;

            }

			_scaleDirty = true;
			
			iInvalidateTransform();

			if (_listenToScaleChanged)
                notifyScaleChanged();

		}

		private function notifyScaleChanged():void
		{
			if (!_scaleChanged)
				_scaleChanged = new Object3DEvent(Object3DEvent.SCALE_CHANGED, this);
			
			dispatchEvent(_scaleChanged);
		}

		public var _pTransform:Matrix3D = new Matrix3D();
        public var _pScaleX:Number = 1;
        public var _pScaleY:Number = 1;
        public var _pScaleZ:Number = 1;
		private var _x:Number = 0;
		private var _y:Number = 0;
		private var _z:Number = 0;
		private var _pivotPoint:Vector3D = new Vector3D();
		private var _pivotZero:Boolean = true;
		public var _pPos:Vector3D = new Vector3D();
		private var _rot:Vector3D = new Vector3D();
		private var _sca:Vector3D = new Vector3D();
        private var _transformComponents:Vector.<Vector3D>;
		
		/**
		 * An object that can contain any extra data.
		 */
		public var extra:Object;
		
		/**
		 * Defines the x coordinate of the 3d object relative to the local coordinates of the parent <code>ObjectContainer3D</code>.
		 */
		public function get x():Number
		{
			return _x;
		}
		
		public function set x(val:Number):void
		{
			if (_x == val)
            {

                return;

            }


			_x = val;
			invalidatePosition();

		}
		
		/**
		 * Defines the y coordinate of the 3d object relative to the local coordinates of the parent <code>ObjectContainer3D</code>.
		 */
		public function get y():Number
		{
			return _y;
		}
		
		public function set y(val:Number):void
		{
			if (_y == val)
            {

                return;

            }

			_y = val;
			invalidatePosition();

		}
		
		/**
		 * Defines the z coordinate of the 3d object relative to the local coordinates of the parent <code>ObjectContainer3D</code>.
		 */
		public function get z():Number
		{
			return _z;
		}
		
		public function set z(val:Number):void
		{
			if (_z == val)
            {

                return;

            }

			_z = val;
			invalidatePosition();

		}
		
		/**
		 * Defines the euler angle of rotation of the 3d object around the x-axis, relative to the local coordinates of the parent <code>ObjectContainer3D</code>.
		 */
		public function get rotationX():Number
		{
			return _rotationX*MathConsts.RADIANS_TO_DEGREES;
		}
		
		public function set rotationX(val:Number):void
		{
			if (rotationX == val)
            {

                return;

            }

			
			_rotationX = val*MathConsts.DEGREES_TO_RADIANS;
			invalidateRotation();
		}
		
		/**
		 * Defines the euler angle of rotation of the 3d object around the y-axis, relative to the local coordinates of the parent <code>ObjectContainer3D</code>.
		 */
		public function get rotationY():Number
		{
			return _rotationY*MathConsts.RADIANS_TO_DEGREES;
		}
		
		public function set rotationY(val:Number):void
		{
			if (rotationY == val)
            {

                return;

            }

			_rotationY = val*MathConsts.DEGREES_TO_RADIANS;
			
			invalidateRotation();
		}
		
		/**
		 * Defines the euler angle of rotation of the 3d object around the z-axis, relative to the local coordinates of the parent <code>ObjectContainer3D</code>.
		 */
		public function get rotationZ():Number
		{
			return _rotationZ*MathConsts.RADIANS_TO_DEGREES;
		}
		
		public function set rotationZ(val:Number):void
		{
			if (rotationZ == val)
            {

                return;

            }

			
			_rotationZ = val*MathConsts.DEGREES_TO_RADIANS;
			
			invalidateRotation();
		}
		
		/**
		 * Defines the scale of the 3d object along the x-axis, relative to local coordinates.
		 */
		public function get scaleX():Number
		{
			return _pScaleX;
		}
		
		public function set scaleX(val:Number):void
		{
			if (_pScaleX == val)
            {

                return;

            }

			_pScaleX = val;
			
			invalidateScale();
		}
		
		/**
		 * Defines the scale of the 3d object along the y-axis, relative to local coordinates.
		 */
		public function get scaleY():Number
		{
			return _pScaleY;
		}
		
		public function set scaleY(val:Number):void
		{
			if (_pScaleY == val)
            {

                return;

            }

            _pScaleY = val;

            invalidateScale();

		}
		
		/**
		 * Defines the scale of the 3d object along the z-axis, relative to local coordinates.
		 */
		public function get scaleZ():Number
		{
			return _pScaleZ;
		}
		
		public function set scaleZ(val:Number):void
		{
			if (_pScaleZ == val)
            {

                return;

            }

			_pScaleZ = val;
			invalidateScale();

		}
		
		/**
		 * Defines the rotation of the 3d object as a <code>Vector3D</code> object containing euler angles for rotation around x, y and z axis.
		 */
		public function get eulers():Vector3D
		{
			_eulers.x = _rotationX*MathConsts.RADIANS_TO_DEGREES;
            _eulers.y = _rotationY*MathConsts.RADIANS_TO_DEGREES;
            _eulers.z = _rotationZ*MathConsts.RADIANS_TO_DEGREES;
			
			return _eulers;
		}
		
		public function set eulers(value:Vector3D):void
		{
			_rotationX = value.x*MathConsts.DEGREES_TO_RADIANS;
            _rotationY = value.y*MathConsts.DEGREES_TO_RADIANS;
            _rotationZ = value.z*MathConsts.DEGREES_TO_RADIANS;

            invalidateRotation();
		}
		
		/**
		 * The transformation of the 3d object, relative to the local coordinates of the parent <code>ObjectContainer3D</code>.
		 */

		public function get transform():Matrix3D
		{
			if (_transformDirty)
            {

                pUpdateTransform()

            }

			
			return _pTransform;
		}

		public function set transform(val:Matrix3D):void
		{

            // TODO: From AS3 - Do we still need this in JS ?
            //ridiculous matrix error
            //*
            if (!val.rawData[0])
            {

                var raw:Vector.<Number> = Matrix3DUtils.RAW_DATA_CONTAINER;
                val.copyRawDataTo( raw );
                raw[0] = _smallestNumber;
                val.copyRawDataFrom(raw);
            }
            //*/
			var elements:Vector.<Vector3D>= val.decompose();
			var vec:Vector3D;
			
			vec = elements[0];
			
			if (_x != vec.x || _y != vec.y || _z != vec.z)
            {
                _x = vec.x;
                _y = vec.y;
                _z = vec.z;
				
				invalidatePosition();
			}
			
			vec = elements[1];
			
			if (_rotationX != vec.x || _rotationY != vec.y || _rotationZ != vec.z)
            {
                _rotationX = vec.x;
                _rotationY = vec.y;
                _rotationZ = vec.z;

                invalidateRotation();
			}
			
			vec = elements[2];
			
			if (_pScaleX != vec.x || _pScaleY != vec.y || _pScaleZ != vec.z) {
                _pScaleX = vec.x;
                _pScaleY = vec.y;
                _pScaleZ = vec.z;

                invalidateScale();
			}
		}


		/**
		 * Defines the local point around which the object rotates.
		 */

		public function get pivotPoint():Vector3D
		{
			return _pivotPoint;
		}


		public function set pivotPoint(pivot:Vector3D):void
		{
			_pivotPoint = pivot.clone();

            invalidatePivot();
		}

		/**
		 * Defines the position of the 3d object, relative to the local coordinates of the parent <code>ObjectContainer3D</code>.
		 */
		public function get position():Vector3D
		{
			_pTransform.copyColumnTo(3, _pPos);
			
			return _pPos.clone();
		}
		
		public function set position(value:Vector3D):void
		{
			_x = value.x;
            _y = value.y;
            _z = value.z;

            invalidatePosition();
		}
		
		/**
		 *
		 */
		public function get forwardVector():Vector3D
		{
			return Matrix3DUtils.getForward( transform );
		}
		/**
		 *
		 */
		public function get rightVector():Vector3D
		{
			return Matrix3DUtils.getRight( transform );
		}
		/**
		 *
		 */
		public function get upVector():Vector3D
		{
			return Matrix3DUtils.getUp( transform );
		}
		/**
		 *
		 */
		public function get backVector():Vector3D
		{
			var director:Vector3D = Matrix3DUtils.getForward( transform);
			director.negate();
			
			return director;
		}
		/**
		 *
		 */
		public function get leftVector():Vector3D
		{
			var director:Vector3D = Matrix3DUtils.getRight( transform );
			director.negate();
			
			return director;
		}
		/**
		 *
		 */
		public function get downVector():Vector3D
		{
			var director:Vector3D = Matrix3DUtils.getUp( transform );
			director.negate();
			
			return director;
		}
		/**
		 * Creates an Object3D object.
		 */
		public function Object3D():void
		{

            super();

			// Cached vector of transformation components used when
			// recomposing the transform matrix in updateTransform()

            _transformComponents = new Vector.<Vector3D>(3);//_transformComponents = new Vector.<Vector3D>(3, true);

			_transformComponents[0] = _pPos;
            _transformComponents[1] = _rot;
            _transformComponents[2] = _sca;

            _pTransform.identity();

			_flipY.appendScale(1, -1, 1);
		}
		
		/**
		 * Appends a uniform scale to the current transformation.
		 * @param value The amount by which to scale.
		 */
		public function scale(value:Number):void
		{
			_pScaleX *= value;
            _pScaleY *= value;
            _pScaleZ *= value;

            invalidateScale();
		}
		/**
		 * Moves the 3d object forwards along it's local z axis
		 *
		 * @param    distance    The length of the movement
		 */
		public function moveForward(distance:Number):void
		{
			translateLocal(Vector3D.Z_AXIS, distance);
		}
		/**
		 * Moves the 3d object backwards along it's local z axis
		 *
		 * @param    distance    The length of the movement
		 */
		public function moveBackward(distance:Number):void
		{
			translateLocal(Vector3D.Z_AXIS, -distance);
		}
		/**
		 * Moves the 3d object backwards along it's local x axis
		 *
		 * @param    distance    The length of the movement
		 */

		public function moveLeft(distance:Number):void
		{
			translateLocal(Vector3D.X_AXIS, -distance);
		}

		/**
		 * Moves the 3d object forwards along it's local x axis
		 *
		 * @param    distance    The length of the movement
		 */
		public function moveRight(distance:Number):void
		{
			translateLocal(Vector3D.X_AXIS, distance);
		}
		/**
		 * Moves the 3d object forwards along it's local y axis
		 *
		 * @param    distance    The length of the movement
		 */
		public function moveUp(distance:Number):void
		{
			translateLocal(Vector3D.Y_AXIS, distance);
		}
		/**
		 * Moves the 3d object backwards along it's local y axis
		 *
		 * @param    distance    The length of the movement
		 */
		public function moveDown(distance:Number):void
		{
			translateLocal(Vector3D.Y_AXIS, -distance);
		}

		/**
		 * Moves the 3d object directly to a point in space
		 *
		 * @param    dx        The amount of movement along the local x axis.
		 * @param    dy        The amount of movement along the local y axis.
		 * @param    dz        The amount of movement along the local z axis.
		 */

		public function moveTo(dx:Number, dy:Number, dz:Number):void
		{
			if (_x == dx && _y == dy && _z == dz)
            {

                return;

            }

            _x = dx;
            _y = dy;
            _z = dz;

            invalidatePosition();
		}

		/**
		 * Moves the local point around which the object rotates.
		 *
		 * @param    dx        The amount of movement along the local x axis.
		 * @param    dy        The amount of movement along the local y axis.
		 * @param    dz        The amount of movement along the local z axis.
		 */
		public function movePivot(dx:Number, dy:Number, dz:Number):void
		{

            if ( _pivotPoint == null )
            {

                _pivotPoint = new Vector3D();

            }

			_pivotPoint.x += dx;
            _pivotPoint.y += dy;
            _pivotPoint.z += dz;

            invalidatePivot();
		}
		/**
		 * Moves the 3d object along a vector by a defined length
		 *
		 * @param    axis        The vector defining the axis of movement
		 * @param    distance    The length of the movement
		 */
		public function translate(axis:Vector3D, distance:Number):void
		{
			var x:Number = axis.x, y:Number = axis.y, z:Number = axis.z;
			var len:Number = distance/Math.sqrt(x*x + y*y + z*z);
			
			_x += x*len;
            _y += y*len;
            _z += z*len;
			
			invalidatePosition();
		}
		/**
		 * Moves the 3d object along a vector by a defined length
		 *
		 * @param    axis        The vector defining the axis of movement
		 * @param    distance    The length of the movement
		 */
		public function translateLocal(axis:Vector3D, distance:Number):void
		{
			var x:Number = axis.x, y:Number = axis.y, z:Number = axis.z;
			var len:Number = distance/Math.sqrt(x*x + y*y + z*z);
			
			transform.prependTranslation(x*len, y*len, z*len);
			
			_pTransform.copyColumnTo(3, _pPos);
			
			_x = _pPos.x;
            _y = _pPos.y;
            _z = _pPos.z;

            invalidatePosition();
		}
		/**
		 * Rotates the 3d object around it's local x-axis
		 *
		 * @param    angle        The amount of rotation in degrees
		 */
		public function pitch(angle:Number):void
		{
            rotate(Vector3D.X_AXIS, angle);
		}
		/**
		 * Rotates the 3d object around it's local y-axis
		 *
		 * @param    angle        The amount of rotation in degrees
		 */
		public function yaw(angle:Number):void
		{
			rotate(Vector3D.Y_AXIS, angle);
		}
		/**
		 * Rotates the 3d object around it's local z-axis
		 *
		 * @param    angle        The amount of rotation in degrees
		 */
		public function roll(angle:Number):void
		{
			rotate(Vector3D.Z_AXIS, angle);
		}
		public function clone():Object3D
		{
			var clone:Object3D = new Object3D();
		    	clone.pivotPoint = pivotPoint;
			    clone.transform = _pTransform;
			    clone.name = name;
			// todo: implement for all subtypes
			return clone;
		}
		/**
		 * Rotates the 3d object directly to a euler angle
		 *
		 * @param    ax        The angle in degrees of the rotation around the x axis.
		 * @param    ay        The angle in degrees of the rotation around the y axis.
		 * @param    az        The angle in degrees of the rotation around the z axis.
		 */
		public function rotateTo(ax:Number, ay:Number, az:Number):void
		{
			_rotationX = ax*MathConsts.DEGREES_TO_RADIANS;
            _rotationY = ay*MathConsts.DEGREES_TO_RADIANS;
            _rotationZ = az*MathConsts.DEGREES_TO_RADIANS;
			
			invalidateRotation();
		}
		/**
		 * Rotates the 3d object around an axis by a defined angle
		 *
		 * @param    axis        The vector defining the axis of rotation
		 * @param    angle        The amount of rotation in degrees
		 */
		public function rotate(axis:Vector3D, angle:Number):void
		{
			transform.prependRotation(angle, axis);
			transform = _pTransform;

		}
		/**
		 * Rotates the 3d object around to face a point defined relative to the local coordinates of the parent <code>ObjectContainer3D</code>.
		 *
		 * @param    target        The vector defining the point to be looked at
		 * @param    upAxis        An optional vector used to define the desired up orientation of the 3d object after rotation has occurred
		 */
		public function lookAt(target:Vector3D, upAxis:Vector3D = null):void
		{

			var yAxis:Vector3D;
            var zAxis:Vector3D;
            var xAxis:Vector3D;
			var raw:Vector.<Number>;

            if ( upAxis == null)
            {
                upAxis = Vector3D.Y_AXIS;
            }

			zAxis = target.subtract(position);
			zAxis.normalize();
			
			xAxis = upAxis.crossProduct(zAxis);
			xAxis.normalize();
			
			if (xAxis.length < .05)
				xAxis = upAxis.crossProduct(Vector3D.Z_AXIS);
			
			yAxis = zAxis.crossProduct(xAxis);
			
			raw = Matrix3DUtils.RAW_DATA_CONTAINER;
			
			raw[0] = _pScaleX*xAxis.x;
			raw[1] = _pScaleX*xAxis.y;
			raw[2] = _pScaleX*xAxis.z;
			raw[3] = 0;
			
			raw[4] = _pScaleY*yAxis.x;
			raw[5] = _pScaleY*yAxis.y;
			raw[6] = _pScaleY*yAxis.z;
			raw[7] = 0;
			
			raw[8] = _pScaleZ*zAxis.x;
			raw[9] = _pScaleZ*zAxis.y;
			raw[10] = _pScaleZ*zAxis.z;
			raw[11] = 0;
			
			raw[12] = _x;
			raw[13] = _y;
			raw[14] = _z;
			raw[15] = 1;

            _pTransform.copyRawDataFrom(raw);

            transform = _pTransform;
			
			if (zAxis.z < 0)
            {
                rotationY = (180 - rotationY);
                rotationX -= 180;
                rotationZ -= 180;
			}

		}
		/**
		 * Cleans up any resources used by the current object.
		 */
		override public function dispose():void
		{
		}
		/**
		 * @inheritDoc
		 */
		public function disposeAsset():void
		{
			dispose();
		}
		/**
		 * Invalidates the transformation matrix, causing it to be updated upon the next request
		 */

		public function iInvalidateTransform():void
		{
			_transformDirty = true;
		}


		public function pUpdateTransform():void
		{

			_pPos.x = _x;
            _pPos.y = _y;
            _pPos.z = _z;

            _rot.x = _rotationX;
            _rot.y = _rotationY;
            _rot.z = _rotationZ;

            _sca.x = _pScaleX;
            _sca.y = _pScaleY;
            _sca.z = _pScaleZ;

            _pTransform.recompose(_transformComponents);

			if (!_pivotZero)
            {
                _pTransform.prependTranslation(-_pivotPoint.x, -_pivotPoint.y, -_pivotPoint.z);
                _pTransform.appendTranslation(_pivotPoint.x, _pivotPoint.y, _pivotPoint.z);
			}

            _transformDirty = false;
            _positionDirty = false;
            _rotationDirty = false;
            _scaleDirty = false;

		}

		public function get zOffset():Number
		{
			return _zOffset;
		}
		
		public function set zOffset(value:Number):void
		{
			_zOffset = value;
		}
	}

}
