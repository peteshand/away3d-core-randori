/**
 * ...
 * @author Gary Paluk - http://www.plugin.io
 */
///<reference path="../away/_definitions.ts" />

package aglsl
{
	public class OpLUT
	{
		
		public var s:String;
		public var flags:Number;
		public var dest:Boolean;
		public var a:Boolean;
		public var b:Boolean;
		public var matrixwidth:Number;
		public var matrixheight:Number;
		public var ndwm:Boolean;
		public var scalar:Boolean;
		public var dm:Boolean;
		public var lod:Boolean;
		
		public function OpLUT(s:String, flags:Number, dest:Boolean, a:Boolean, b:Boolean, matrixwidth:Number, matrixheight:Number, ndwm:Boolean, scaler:Boolean, dm:Boolean, lod:Boolean):void
		{
			s = s;
			flags = flags;
			dest = dest;
			a = a;
			b = b;
			matrixwidth = matrixwidth;
			matrixheight = matrixheight;
			ndwm = ndwm;
			scalar = scaler;
			dm = dm;
			lod = lod;
		}
	}
}