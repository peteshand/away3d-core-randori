/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

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