/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package away.events
{
	//import flash.events.Event;
	
	public class Stage3DEvent extends Event
	{
		public static var CONTEXT3D_CREATED:String = "Context3DCreated";
		public static var CONTEXT3D_DISPOSED:String = "Context3DDisposed";
		public static var CONTEXT3D_RECREATED:String = "Context3DRecreated";
		public static var VIEWPORT_UPDATED:String = "ViewportUpdated";
		
		public function Stage3DEvent(type:String):void//, bubbles:boolean = false, cancelable:boolean = false)		{
			super( type );//, bubbles, cancelable);
		}
	}
}
