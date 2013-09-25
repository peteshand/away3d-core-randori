/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package aglsl
{
	public class OpLUT
	{
		
		public var s:String = null;
		public var flags:Number = 0;
		public var dest:Boolean = false;
		public var a:Boolean = false;
		public var b:Boolean = false;
		public var matrixwidth:Number = 0;
		public var matrixheight:Number = 0;
		public var ndwm:Boolean = false;
		public var scalar:Boolean = false;
		public var dm:Boolean = false;
		public var lod:Boolean = false;
		
		public function OpLUT(s:String, flags:Number, dest:Boolean, a:Boolean, b:Boolean, matrixwidth:Number, matrixheight:Number, ndwm:Boolean, scaler:Boolean, dm:Boolean, lod:Boolean):void
		{
			this.s = s;
			this.flags = flags;
			this.dest = dest;
			this.a = a;
			this.b = b;
			this.matrixwidth = matrixwidth;
			this.matrixheight = matrixheight;
			this.ndwm = ndwm;
			this.scalar = scaler;
			this.dm = dm;
			this.lod = lod;
		}
	}
}