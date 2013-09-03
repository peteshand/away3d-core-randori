/** * ... * @author Gary Paluk - http://www.plugin.io */

///<reference path="../_definitions.ts"/>


package away.events
{
	import away.cameras.Camera3D;
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
			return _camera;
		}
	}
}