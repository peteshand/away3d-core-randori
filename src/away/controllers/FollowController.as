///<reference path="../_definitions.ts" />

package away.controllers
{
	import away.entities.Entity;
	import away.containers.ObjectContainer3D;

	/**	 * Controller used to follow behind an object on the XZ plane, with an optional	 * elevation (tiltAngle).	 *	 * @see    away3d.containers.View3D	 */
	public class FollowController extends HoverController
	{
		public function FollowController(targetObject:Entity = null, lookAtObject:ObjectContainer3D = null, tiltAngle:Number = 45, distance:Number = 700):void
		{
			super(targetObject, lookAtObject, 0, tiltAngle, distance);
		}
		
		override public function update(interpolate:Boolean = true):void
		{
			interpolate = interpolate; // unused: prevents warning
			
			if (!this.lookAtObject)
				return;

            this.panAngle = this._pLookAtObject.rotationY - 180;
			super.update();
		}
	}
}
