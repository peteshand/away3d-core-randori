/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package away.events
{	
	public class IOErrorEvent extends Event
	{

        public static var IO_ERROR:String = "IOErrorEvent_IO_ERROR";

		public function IOErrorEvent(type:String):void
		{
			super(type);

		}
	}
}