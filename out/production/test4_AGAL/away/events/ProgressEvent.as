/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package away.events
{	
	public class ProgressEvent extends Event
	{

        public static var PROGRESS:String = "ProgressEvent_progress";

        public var bytesLoaded:Number = 0;
        public var bytesTotal:Number = 0;

		public function ProgressEvent(type:String):void
		{
			super(type);

		}
	}
}