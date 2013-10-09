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
	
	public class ShadingMethodEvent extends Event
	{
		public static var SHADER_INVALIDATED:String = "ShaderInvalidated";
		
		public function ShadingMethodEvent(type:String):void
		{

			super(type );

		}
	}
}
