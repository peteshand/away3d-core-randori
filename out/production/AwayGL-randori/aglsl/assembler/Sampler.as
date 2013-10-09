/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package aglsl.assembler
{
	
	public class Sampler
	{
		public var shift:Number = 0;
		public var mask:Number = 0;
		public var value:Number = 0;
		
		public function Sampler(shift:Number, mask:Number, value:Number):void
		{
			this.shift = shift;
			this.mask = mask;
			this.value = value;
		}
	}
	
}

