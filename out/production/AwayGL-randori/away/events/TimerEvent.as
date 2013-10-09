/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package away.events
{	
	public class TimerEvent extends Event
	{

        public static var TIMER:String = "timer";
        public static var TIMER_COMPLETE:String = "timerComplete";

		public function TimerEvent(type:String):void
		{
			super(type);

		}
	}
}