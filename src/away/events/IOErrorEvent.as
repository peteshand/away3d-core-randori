///<reference path="../_definitions.ts"/>

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