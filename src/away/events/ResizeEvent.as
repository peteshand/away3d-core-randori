/** * ... * @author Gary Paluk - http://www.plugin.io */

///<reference path="../_definitions.ts"/>
/** * @module away.events */
package away.events
{
	public class ResizeEvent extends Event
	{
		
		public static var RESIZE:String = "resize";		
		private var _oldHeight:Number;
		private var _oldWidth:Number;
		
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