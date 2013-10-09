/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package away.core.display3D
{
	public class Context3DClearMask
	{
		public static var COLOR:Number = 8 << 11;
		public static var DEPTH:Number = 8 << 5;
		public static var STENCIL:Number = 8 << 7;
		public static var ALL:Number = Context3DClearMask.COLOR | Context3DClearMask.DEPTH | Context3DClearMask.STENCIL;
	}
}