/** * ... * @author Gary Paluk - http://www.plugin.io */

///<reference path="../_definitions.ts"/>

package away.events
{
	import away.cameras.lenses.LensBase;
	public class LensEvent extends Event
	{
		public static var MATRIX_CHANGED:String = "matrixChanged";
		
		private var _lens:LensBase;
		
		public function LensEvent(type:String, lens:LensBase):void
		{
			super( type );
			this._lens = lens;
		}
		
		public function get lens():LensBase
		{
			return _lens;
		}
	}
}