/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package aglsl.assembler
{
	
	public class Reg
	{
		
		public var code:Number = 0;
		public var desc:String = null;
		
		public function Reg(code:Number, desc:String):void
		{
			this.code = code;
			this.desc = desc;
		}
	}
}