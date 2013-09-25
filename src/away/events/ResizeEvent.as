/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package away.events
{
	public class ResizeEvent extends Event
	{
		
		public static var RESIZE:String = "resize";
		
		private var _oldHeight:Number = 0;
		private var _oldWidth:Number = 0;
		
		public function ResizeEvent(type:String, oldHeight:Number = NaN, oldWidth:Number = NaN):void
		{
			oldHeight = oldHeight || NaN;
			oldWidth = oldWidth || NaN;

			super( type );
			this._oldHeight = oldHeight;
			this._oldWidth = oldWidth;
		}
		
		public function get oldHeight():Number
		{
			return this._oldHeight;
		}
		
		public function get oldWidth():Number
		{
			return this._oldWidth;
		}
	}
}