///<reference path="../_definitions.ts"/>

/** * @module away.events */
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