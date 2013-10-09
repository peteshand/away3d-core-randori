/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package away.controllers
{
	import away.core.geom.Vector3D;
	import away.entities.Entity;
	import away.containers.ObjectContainer3D;

	/**	 * Uses spring physics to animate the target object towards a position that is	 * defined as the lookAtTarget object's position plus the vector defined by the	 * positionOffset property.	 */
	public class SpringController extends LookAtController
	{
		private var _velocity:Vector3D;
		private var _dv:Vector3D;
		private var _stretch:Vector3D;
		private var _force:Vector3D;
		private var _acceleration:Vector3D;
		private var _desiredPosition:Vector3D;
		
		/**		 * Stiffness of the spring, how hard is it to extend. The higher it is, the more "fixed" the cam will be.		 * A number between 1 and 20 is recommended.		 */
		public var stiffness:Number = 0;
		
		/**		 * Damping is the spring internal friction, or how much it resists the "boinggggg" effect. Too high and you'll lose it!		 * A number between 1 and 20 is recommended.		 */
		public var damping:Number = 0;
		
		/**		 * Mass of the camera, if over 120 and it'll be very heavy to move.		 */
		public var mass:Number = 0;
		
		/**		 * Offset of spring center from target in target object space, ie: Where the camera should ideally be in the target object space.		 */
		public var positionOffset:Vector3D = new Vector3D(0, 500, -1000);
		
		public function SpringController(targetObject:Entity = null, lookAtObject:ObjectContainer3D = null, stiffness:Number = 1, mass:Number = 40, damping:Number = 4):void
		{
			targetObject = targetObject || null;
			lookAtObject = lookAtObject || null;
			stiffness = stiffness || 1;
			mass = mass || 40;
			damping = damping || 4;

			super(targetObject, lookAtObject);
			
			this.stiffness = stiffness;
			this.damping = damping;
			this.mass = mass;
			
			this._velocity = new Vector3D();
            this._dv = new Vector3D();
            this._stretch = new Vector3D();
            this._force = new Vector3D();
            this._acceleration = new Vector3D();
            this._desiredPosition = new Vector3D();
		
		}
		
		override public function update(interpolate:Boolean = true):void
		{
			interpolate = interpolate || true;

			interpolate = interpolate; // prevents unused warning
			
			var offs:Vector3D;
			
			if (!this._pLookAtObject || !this._pTargetObject)
				return;
			
			offs = this._pLookAtObject.transform.deltaTransformVector(this.positionOffset);
            this._desiredPosition.x = this._pLookAtObject.x + offs.x;
            this._desiredPosition.y = this._pLookAtObject.y + offs.y;
            this._desiredPosition.z = this._pLookAtObject.z + offs.z;

            this._stretch.x = this._pTargetObject.x - this._desiredPosition.x;
            this._stretch.y = this._pTargetObject.y - this._desiredPosition.y;
            this._stretch.z = this._pTargetObject.z - this._desiredPosition.z;
            this._stretch.scaleBy(-this.stiffness);

            this._dv.copyFrom(this._velocity);
            this._dv.scaleBy(this.damping);

            this._force.x = this._stretch.x - this._dv.x;
            this._force.y = this._stretch.y - this._dv.y;
            this._force.z = this._stretch.z - this._dv.z;

            this._acceleration.copyFrom(this._force);
            this._acceleration.scaleBy(1/this.mass);

            this._velocity.x += this._acceleration.x;
            this._velocity.y += this._acceleration.y;
            this._velocity.z += this._acceleration.z;

            this._pTargetObject.x += this._velocity.x;
            this._pTargetObject.y += this._velocity.y;
            this._pTargetObject.z += this._velocity.z;
			
			super.update();
		}
	}
}
