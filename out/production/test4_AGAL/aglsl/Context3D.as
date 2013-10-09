/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package aglsl
{
	import away.utils.VectorInit;
	public class Context3D
	{
		
		public var enableErrorChecking:Boolean = false;
		public var resources:Vector.<*> = VectorInit.StarVec();
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