/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package away.events
{
	import away.cameras.Camera3D;
    /**     * @class away.events.CameraEvent     */
	public class CameraEvent extends Event
	{
		public static var LENS_CHANGED:String = "lensChanged";
		
		private var _camera:Camera3D;
		
		public function CameraEvent(type:String, camera:Camera3D):void
		{
			super( type );
			this._camera = camera;
		}
		
		public function get camera():Camera3D
		{
			return this._camera;
		}
	}
}