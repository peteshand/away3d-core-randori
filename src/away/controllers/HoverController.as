///<reference path="../_definitions.ts" />

package away.controllers
{
	import away.entities.Entity;
	import away.containers.ObjectContainer3D;
	import away.geom.Vector3D;
	import away.math.MathConsts;

	/**	 * Extended camera used to hover round a specified target object.	 *	 * @see    away3d.containers.View3D	 */
	public class HoverController extends LookAtController
	{
        public var _iCurrentPanAngle:Number = 0;
		public var _iCurrentTiltAngle:Number = 90;
		
		private var _panAngle:Number = 0;
		private var _tiltAngle:Number = 90;
		private var _distance:Number = 1000;
		private var _minPanAngle:Number = -Infinity;
		private var _maxPanAngle:Number = Infinity;
		private var _minTiltAngle:Number = -90;
		private var _maxTiltAngle:Number = 90;
		private var _steps:Number = 8;
		private var _yFactor:Number = 2;
		private var _wrapPanAngle:Boolean = false;
		
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
			val = Math.max(this._minPanAngle, Math.min(this._maxPanAngle, val));
			
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
		
		/**		 * Distance between the camera and the specified target. Defaults to 1000.		 */
		public function get distance():Number
		{
			return this._distance;
		}
		
		public function set distance(val:Number):void
		{
			if (this._distance == val)
				return;

            this._distance = val;

            this.pNotifyUpdate();
		}
		
		/**		 * Minimum bounds for the <code>panAngle</code>. Defaults to -Infinity.		 *		 * @see    #panAngle		 */
		public function get minPanAngle():Number
		{
			return this._minPanAngle;
		}
		
		public function set minPanAngle(val:Number):void
		{
			if (this._minPanAngle == val)
				return;

            this._minPanAngle = val;

            this.panAngle = Math.max(this._minPanAngle, Math.min(this._maxPanAngle, this._panAngle));
		}
		
		/**		 * Maximum bounds for the <code>panAngle</code>. Defaults to Infinity.		 *		 * @see    #panAngle		 */
		public function get maxPanAngle():Number
		{
			return this._maxPanAngle;
		}
		
		public function set maxPanAngle(val:Number):void
		{
			if (this._maxPanAngle == val)
				return;

            this._maxPanAngle = val;

            this.panAngle = Math.max(this._minPanAngle, Math.min(this._maxPanAngle, this._panAngle));
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
		
		/**		 * Fractional difference in distance between the horizontal camera orientation and vertical camera orientation. Defaults to 2.		 *		 * @see    #distance		 */
		public function get yFactor():Number
		{
			return this._yFactor;
		}
		
		public function set yFactor(val:Number):void
		{
			if (this._yFactor == val)
				return;

            this._yFactor = val;

            this.pNotifyUpdate();
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
		public function HoverController(targetObject:Entity = null, lookAtObject:ObjectContainer3D = null, panAngle:Number = 0, tiltAngle:Number = 90, distance:Number = 1000, minTiltAngle:Number = -90, maxTiltAngle:Number = 90, minPanAngle:Number = NaN, maxPanAngle:Number = NaN, steps:Number = 8, yFactor:Number = 2, wrapPanAngle:Boolean = false):void
		{
			targetObject = targetObject || null;
			lookAtObject = lookAtObject || null;
			panAngle = panAngle || 0;
			tiltAngle = tiltAngle || 90;
			distance = distance || 1000;
			minTiltAngle = minTiltAngle || -90;
			maxTiltAngle = maxTiltAngle || 90;
			minPanAngle = minPanAngle || NaN;
			maxPanAngle = maxPanAngle || NaN;
			steps = steps || 8;
			yFactor = yFactor || 2;
			wrapPanAngle = wrapPanAngle || false;

			super(targetObject, lookAtObject);
			
			this.distance = distance;
			this.panAngle = panAngle;
			this.tiltAngle = tiltAngle;
			this.minPanAngle = minPanAngle || -Infinity;
			this.maxPanAngle = maxPanAngle || Infinity;
			this.minTiltAngle = minTiltAngle;
			this.maxTiltAngle = maxTiltAngle;
			this.steps = steps;
			this.yFactor = yFactor;
			this.wrapPanAngle = wrapPanAngle;
			
			//values passed in contrustor are applied immediately
			this._iCurrentPanAngle = this._panAngle;
            this._iCurrentTiltAngle = this._tiltAngle;
		}
		
		/**		 * Updates the current tilt angle and pan angle values.		 *		 * Values are calculated using the defined <code>tiltAngle</code>, <code>panAngle</code> and <code>steps</code> variables.		 *		 * @param interpolate   If the update to a target pan- or tiltAngle is interpolated. Default is true.		 *		 * @see    #tiltAngle		 * @see    #panAngle		 * @see    #steps		 */
		override public function update(interpolate:Boolean = true):void
		{
			interpolate = interpolate || true;

			if (this._tiltAngle != this._iCurrentTiltAngle || this._panAngle != this._iCurrentPanAngle)
            {

                this.pNotifyUpdate();
				
				if (this._wrapPanAngle)
                {
					if (this._panAngle < 0)
                    {
                        this._iCurrentPanAngle += this._panAngle%360 + 360 - this._panAngle;
                        this._panAngle = this._panAngle%360 + 360;
					} else {
                        this._iCurrentPanAngle += this._panAngle%360 - this._panAngle;
                        this._panAngle = this._panAngle%360;
					}
					
					while (this._panAngle - this._iCurrentPanAngle < -180)
                        this._iCurrentPanAngle -= 360;
					
					while (this._panAngle - this._iCurrentPanAngle > 180)
                        this._iCurrentPanAngle += 360;
				}
				
				if (interpolate) {
                    this._iCurrentTiltAngle += (this._tiltAngle - this._iCurrentTiltAngle)/(this.steps + 1);
                    this._iCurrentPanAngle += (this._panAngle - this._iCurrentPanAngle)/(this.steps + 1);
				} else {
                    this._iCurrentPanAngle = this._panAngle;
                    this._iCurrentTiltAngle = this._tiltAngle;
				}
				
				//snap coords if angle differences are close
				if ((Math.abs(this.tiltAngle - this._iCurrentTiltAngle) < 0.01) && (Math.abs(this._panAngle - this._iCurrentPanAngle) < 0.01))
                {
                    this._iCurrentTiltAngle = this._tiltAngle;
                    this._iCurrentPanAngle = this._panAngle;
				}
			}
			
			var pos:Vector3D = (this.lookAtObject)? this.lookAtObject.position : (this.lookAtPosition)? this.lookAtPosition : this._pOrigin;
			this.targetObject.x = pos.x + this.distance*Math.sin(this._iCurrentPanAngle*MathConsts.DEGREES_TO_RADIANS)*Math.cos(this._iCurrentTiltAngle*MathConsts.DEGREES_TO_RADIANS);
            this.targetObject.z = pos.z + this.distance*Math.cos(this._iCurrentPanAngle*MathConsts.DEGREES_TO_RADIANS)*Math.cos(this._iCurrentTiltAngle*MathConsts.DEGREES_TO_RADIANS);
            this.targetObject.y = pos.y + this.distance*Math.sin(this._iCurrentTiltAngle*MathConsts.DEGREES_TO_RADIANS)*this.yFactor;
			
			super.update();
		}
	}
}
