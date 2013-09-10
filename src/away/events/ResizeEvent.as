/**
 * ...
 * @author Gary Paluk - http://www.plugin.io
 */
///<reference path="../_definitions.ts"/>

package away.events
{
	public class ResizeEvent extends Event
	{
		
		public static var RESIZE:String = "resize";
		
		private var _oldHeight:Number;
		private var _oldWidth:Number;
		
		public function ResizeEvent(type:String, oldHeight:Number = NaN, oldWidth:Number = NaN):void
		{
			super( type );
			_oldHeight = oldHeight;
			_oldWidth = oldWidth;
		}
		
		public function get oldHeight():Number
		{
			return _oldHeight;
		}
		
		public function get oldWidth():Number
		{
			return _oldWidth;
		}
	}
}