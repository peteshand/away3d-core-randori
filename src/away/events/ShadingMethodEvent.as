
///<reference path="../_definitions.ts"/>
/** * @module away.events */
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
