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
			return this._steps;
		}
		
		public function set steps(val:Number):void
		{
			val = (val < 1)? 1 : val;
			
			if (this._steps == val)
				return;

            this._steps = val;

            this.pNotifyUpdate();
		}
		
		/**		 * Rotation of the camera in degrees around the y axis. Defaults to 0.		 */
		public function get panAngle():Number
		{
			return this._panAngle;
		}
		
		public function set panAngle(val:Number):void
		{
			if (this._panAngle == val)
				return;

            this._panAngle = val;
			
			this.pNotifyUpdate();
		}
		
		/**		 * Elevation angle of the camera in degrees. Defaults to 90.		 */
		public function get tiltAngle():Number
		{
			return this._tiltAngle;
		}
		
		public function set tiltAngle(val:Number):void
		{
			val = Math.max(this._minTiltAngle, Math.min(this._maxTiltAngle, val));
			
			if (this._tiltAngle == val)
				return;

            this._tiltAngle = val;

            this.pNotifyUpdate();
		}
		
		/**		 * Minimum bounds for the <code>tiltAngle</code>. Defaults to -90.		 *		 * @see    #tiltAngle		 */
		public function get minTiltAngle():Number
		{
			return this._minTiltAngle;
		}
		
		public function set minTiltAngle(val:Number):void
		{
			if (this._minTiltAngle == val)
				return;

            this._minTiltAngle = val;

            this.tiltAngle = Math.max(this._minTiltAngle, Math.min(this._maxTiltAngle, this._tiltAngle));
		}
		
		/**		 * Maximum bounds for the <code>tiltAngle</code>. Defaults to 90.		 *		 * @see    #tiltAngle		 */
		public function get maxTiltAngle():Number
		{
			return this._maxTiltAngle;
		}
		
		public function set maxTiltAngle(val:Number):void
		{
			if (this._maxTiltAngle == val)
				return;

            this._maxTiltAngle = val;

            this.tiltAngle = Math.max(this._minTiltAngle, Math.min(this._maxTiltAngle, this._tiltAngle));
		}
		
		
		/**		 * Defines whether the value of the pan angle wraps when over 360 degrees or under 0 degrees. Defaults to false.		 */
		public function get wrapPanAngle():Boolean
		{
			return this._wrapPanAngle;
		}
		
		public function set wrapPanAngle(val:Boolean):void
		{
			if (this._wrapPanAngle == val)
				return;

            this._wrapPanAngle = val;

            this.pNotifyUpdate();
		}
		
		/**		 * Creates a new <code>HoverController</code> object.		 */
		public function FirstPersonController(targetObject:Entity = null, panAngle:Number = 0, tiltAngle:Number = 90, minTiltAngle:Number = -90, maxTiltAngle:Number = 90, steps:Number = 8, wrapPanAngle:Boolean = false):void
		{
			super(targetObject);
			
			this.panAngle = panAngle;
			this.tiltAngle = tiltAngle;
			this.minTiltAngle = minTiltAngle;
			this.maxTiltAngle = maxTiltAngle;
			this.steps = steps;
			this.wrapPanAngle = wrapPanAngle;
			
			//values passed in contrustor are applied immediately
            this._iCurrentPanAngle = this._panAngle;
            this._iCurrentTiltAngle = this._tiltAngle;
		}
		
		/**		 * Updates the current tilt angle and pan angle values.		 *		 * Values are calculated using the defined <code>tiltAngle</code>, <code>panAngle</code> and <code>steps</code> variables.		 *		 * @param interpolate   If the update to a target pan- or tiltAngle is interpolated. Default is true.		 *		 * @see    #tiltAngle		 * @see    #panAngle		 * @see    #steps		 */
		override public function update(interpolate:Boolean = true):void
		{
			if (this._tiltAngle != this._iCurrentTiltAngle || this._panAngle != this._iCurrentPanAngle) {
				
				this.pNotifyUpdate();
				
				if (this._wrapPanAngle) {
					if (this._panAngle < 0) {
                        this._iCurrentPanAngle += this._panAngle%360 + 360 - this._panAngle;
                        this._panAngle =this. _panAngle%360 + 360;
					} else {
                        this._iCurrentPanAngle += this._panAngle%360 - this._panAngle;
                        this._panAngle = this._panAngle%360;
					}
					
					while (this._panAngle - this._iCurrentPanAngle < -180)
                        this._iCurrentPanAngle -= 360;
					
					while (this._panAngle - this._iCurrentPanAngle > 180)
                        this._iCurrentPanAngle += 360;
				}
				
				if (interpolate)
                {
                    this._iCurrentTiltAngle += (this._tiltAngle - this._iCurrentTiltAngle)/(this.steps + 1);
                    this._iCurrentPanAngle += (this._panAngle - this._iCurrentPanAngle)/(this.steps + 1);
				} else {
                    this._iCurrentTiltAngle = this._tiltAngle;
                    this._iCurrentPanAngle = this._panAngle;
				}
				
				//snap coords if angle differences are close
				if ((Math.abs(this.tiltAngle - this._iCurrentTiltAngle) < 0.01) && (Math.abs(this._panAngle - this._iCurrentPanAngle) < 0.01)) {
                    this._iCurrentTiltAngle = this._tiltAngle;
                    this._iCurrentPanAngle = this._panAngle;
				}
			}

            this.targetObject.rotationX = this._iCurrentTiltAngle;
            this.targetObject.rotationY = this._iCurrentPanAngle;
			
			if (this._walkIncrement)
            {
				if (this.fly)
                    this.targetObject.moveForward(this._walkIncrement);
				else {
                    this.targetObject.x += this._walkIncrement*Math.sin(this._panAngle*MathConsts.DEGREES_TO_RADIANS);
                    this.targetObject.z += this._walkIncrement*Math.cos(this._panAngle*MathConsts.DEGREES_TO_RADIANS);
				}
				this._walkIncrement = 0;
			}
			
			if (this._strafeIncrement) {
                this.targetObject.moveRight(this._strafeIncrement);
                this._strafeIncrement = 0;
			}
		
		}
		
		public function incrementWalk(val:Number):void
		{
			if (val == 0)
				return;

            this._walkIncrement += val;

            this.pNotifyUpdate();
		}
		
		public function incrementStrafe(val:Number):void
		{
			if (val == 0)
				return;

            this._strafeIncrement += val;

            this.pNotifyUpdate();
		}
	
	}
}
