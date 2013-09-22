///<reference path="../_definitions.ts"/>

package away.events
{
    /**     * @class away.events.HTTPStatusEvent     */
	public class HTTPStatusEvent extends Event
	{

        public static var HTTP_STATUS:String = "HTTPStatusEvent_HTTP_STATUS";
        public var status:Number;
		
		public function HTTPStatusEvent(type:String, status:Number = null):void
		{
			status = status || null;

			super(type);

            this.status = status;

		}
	}
}