/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package away.events
{
    /**     * @class away.events.HTTPStatusEvent     */
	public class HTTPStatusEvent extends Event
	{

        public static var HTTP_STATUS:String = "HTTPStatusEvent_HTTP_STATUS";

        public var status:Number = 0;
		
		public function HTTPStatusEvent(type:String, status:Number = null):void
		{
			status = status || null;

			super(type);

            this.status = status;

		}
	}
}