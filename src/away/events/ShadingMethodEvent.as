
///<reference path="../_definitions.ts"/>

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
