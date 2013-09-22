/** * ... * @author Gary Paluk - http://www.plugin.io */

///<reference path="../_definitions.ts" />

/** * @module away.events */
package away.events
{
	public class LightEvent extends Event
	{
		
		public static var CASTS_SHADOW_CHANGE:String = "castsShadowChange";		
		public function LightEvent(type:String):void
		{
			super( type );
		}
		
		//@override
		override public function clone():Event
		{
			return new LightEvent( this.type );
		}
	}
}