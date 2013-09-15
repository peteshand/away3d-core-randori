/** * ... * @author Gary Paluk - http://www.plugin.io */

///<reference path="../_definitions.ts"/>

package away.display3D
{
	public class Context3DClearMask
	{
		public static var COLOR:Number = 8 << 11;
		public static var DEPTH:Number = 8 << 5;
		public static var STENCIL:Number = 8 << 7;
		public static var ALL:Number = Context3DClearMask.COLOR | Context3DClearMask.DEPTH | Context3DClearMask.STENCIL;
	}
}