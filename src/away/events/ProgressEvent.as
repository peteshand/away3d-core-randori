///<reference path="../_definitions.ts"/>

/** * @module away.events */
package away.events
{	
	public class ProgressEvent extends Event
	{

        public static var PROGRESS:String = "ProgressEvent_progress";

        public var bytesLoaded:Number;
        public var bytesTotal:Number;

		public function ProgressEvent(type:String):void
		{
			super(type);

		}
	}
}