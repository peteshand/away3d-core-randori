///<reference path="../_definitions.ts" />

package away.controllers
{
	import away.entities.Entity;
	import away.math.MathConsts;

	/**	 * Extended camera used to hover round a specified target object.	 *	 * @see    away3d.containers.View3D	 */
	public class FirstPersonController extends ControllerBase
	{
		public var _iCurrentPanAngle:Number = 0;
        public var _iCurrentTiltAngle:Number = 90;
		
		private var _panAngle:Number = 0;
		private var _tiltAngle:Number = 90;
		private var _minTiltAngle:Number = -90;
		private var _maxTiltAngle:Number = 90;
		private var _steps:Number = 8;
		private var _walkIncrement:Number = 0;
		private var _strafeIncrement:Number = 0;
		private var _wrapPanAngle:Boolean = false;
		
		public var fly:Boolean = false;
		
		/**		 * Fractional step taken each time the <code>hover()</code> method is called. Defaults to 8.		 *		 * Affects the speed at which the <code>tiltAngle</code> and <code>panAngle</code> resolve to their targets.		 *		 * @see    #tiltAngle		 * @see    #panAngle		 */
		public function get steps():Number
		{
			return _steps;
		}
		
		public function set steps(val:Number):void
		{
			val = (val < 1)? 1 : val;
			
			if (_steps == val)
				return;

            _steps = val;

            pNotifyUpdate();
		}
		
		/**		 * Rotation of the camera in degrees around the y axis. Defaults to 0.		 */
		public function get panAngle():Number
		{
			return _panAngle;
		}
		
		public function set panAngle(val:Number):void
		{
			if (_panAngle == val)
				return;

            _panAngle = val;
			
			pNotifyUpdate();
		}
		
		/**		 * Elevation angle of the camera in degrees. Defaults to 90.		 */
		public function get tiltAngle():Number
		{
			return _tiltAngle;
		}
		
		public function set tiltAngle(val:Number):void
		{
			val = Math.max(_minTiltAngle, Math.min(_maxTiltAngle, val));
			
			if (_tiltAngle == val)
				return;

            _tiltAngle = val;

            pNotifyUpdate();
		}
		
		/**		 * Minimum bounds for the <code>tiltAngle</code>. Defaults to -90.		 *		 * @see    #tiltAngle		 */
		public function get minTiltAngle():Number
		{
			return _minTiltAngle;
		}
		
		public function set minTiltAngle(val:Number):void
		{
			if (_minTiltAngle == val)
				return;

            _minTiltAngle = val;

            tiltAngle = Math.max(_minTiltAngle, Math.min(_maxTiltAngle, _tiltAngle));
		}
		
		/**		 * Maximum bounds for the <code>tiltAngle</code>. Defaults to 90.		 *		 * @see    #tiltAngle		 */
		public function get maxTiltAngle():Number
		{
			return _maxTiltAngle;
		}
		
		public function set maxTiltAngle(val:Number):void
		{
			if (_maxTiltAngle == val)
				return;

            _maxTiltAngle = val;

            tiltAngle = Math.max(_minTiltAngle, Math.min(_maxTiltAngle, _tiltAngle));
		}
		
		
		/**		 * Defines whether the value of the pan angle wraps when over 360 degrees or under 0 degrees. Defaults to false.		 */
		public function get wrapPanAngle():Boolean
		{
			return _wrapPanAngle;
		}
		
		public function set wrapPanAngle(val:Boolean):void
		{
			if (_wrapPanAngle == val)
				return;

            _wrapPanAngle = val;

            pNotifyUpdate();
		}
		
		/**		 * Creates a new <code>HoverController</code> object.		 */
		public function FirstPersonController(targetObject:Entity = null, panAngle:Number = 0, tiltAngle:Number = 90, minTiltAngle:Number = -90, maxTiltAngle:Number = 90, steps:Number = 8, wrapPanAngle:Boolean = false):void
		{
			super(targetObject);
			
			panAngle = panAngle;
			tiltAngle = tiltAngle;
			minTiltAngle = minTiltAngle;
			maxTiltAngle = maxTiltAngle;
			steps = steps;
			wrapPanAngle = wrapPanAngle;
			
			//values passed in contrustor are applied immediately
            _iCurrentPanAngle = _panAngle;
            _iCurrentTiltAngle = _tiltAngle;
		}
		
		/**		 * Updates the current tilt angle and pan angle values.		 *		 * Values are calculated using the defined <code>tiltAngle</code>, <code>panAngle</code> and <code>steps</code> variables.		 *		 * @param interpolate   If the update to a target pan- or tiltAngle is interpolated. Default is true.		 *		 * @see    #tiltAngle		 * @see    #panAngle		 * @see    #steps		 */
		override public function update(interpolate:Boolean = true):void
		{
			if (_tiltAngle != _iCurrentTiltAngle || _panAngle != _iCurrentPanAngle) {
				
				pNotifyUpdate();
				
				if (_wrapPanAngle) {
					if (_panAngle < 0) {
                        _iCurrentPanAngle += _panAngle%360 + 360 - _panAngle;
                        _panAngle =this. _panAngle%360 + 360;
					} else {
                        _iCurrentPanAngle += _panAngle%360 - _panAngle;
                        _panAngle = _panAngle%360;
					}
					
					while (_panAngle - _iCurrentPanAngle < -180)
                        _iCurrentPanAngle -= 360;
					
					while (_panAngle - _iCurrentPanAngle > 180)
                        _iCurrentPanAngle += 360;
				}
				
				if (interpolate)
                {
                    _iCurrentTiltAngle += (_tiltAngle - _iCurrentTiltAngle)/(steps + 1);
                    _iCurrentPanAngle += (_panAngle - _iCurrentPanAngle)/(steps + 1);
				} else {
                    _iCurrentTiltAngle = _tiltAngle;
                    _iCurrentPanAngle = _panAngle;
				}
				
				//snap coords if angle differences are close
				if ((Math.abs(tiltAngle - _iCurrentTiltAngle) < 0.01) && (Math.abs(_panAngle - _iCurrentPanAngle) < 0.01)) {
                    _iCurrentTiltAngle = _tiltAngle;
                    _iCurrentPanAngle = _panAngle;
				}
			}

            targetObject.rotationX = _iCurrentTiltAngle;
            targetObject.rotationY = _iCurrentPanAngle;
			
			if (_walkIncrement)
            {
				if (fly)
                    targetObject.moveForward(_walkIncrement);
				else {
                    targetObject.x += _walkIncrement*Math.sin(_panAngle*MathConsts.DEGREES_TO_RADIANS);
                    targetObject.z += _walkIncrement*Math.cos(_panAngle*MathConsts.DEGREES_TO_RADIANS);
				}
				_walkIncrement = 0;
			}
			
			if (_strafeIncrement) {
                targetObject.moveRight(_strafeIncrement);
                _strafeIncrement = 0;
			}
		
		}
		
		public function incrementWalk(val:Number):void
		{
			if (val == 0)
				return;

            _walkIncrement += val;

            pNotifyUpdate();
		}
		
		public function incrementStrafe(val:Number):void
		{
			if (val == 0)
				return;

            _strafeIncrement += val;

            pNotifyUpdate();
		}
	
	}
}
