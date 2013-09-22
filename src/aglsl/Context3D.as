/** * ... * @author Gary Paluk - http://www.plugin.io */

///<reference path="../away/_definitions.ts" />

package aglsl
{
	public class Context3D
	{
		
		public var enableErrorChecking:Boolean = false;
		public var resources:Vector.<*> = new Vector.<*>();
		public var driverInfo:String = "Call getter function instead";		
		public static var maxvertexconstants:Number = 128;
		public static var maxfragconstants:Number = 28;
		public static var maxtemp:Number = 8;
		public static var maxstreams:Number = 8;
		public static var maxtextures:Number = 8;
		public static var defaultsampler = new Sampler();
		
		public function Context3D():void
		{
		}
	}
}