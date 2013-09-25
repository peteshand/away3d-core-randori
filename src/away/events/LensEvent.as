/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

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
			return this._lens;
		}
	}
}