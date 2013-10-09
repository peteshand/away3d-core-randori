/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package aglsl
{
	public class Token
	{
		
		public var dest:Destination = new Destination();
		public var opcode:Number = 0;
		public var a:Destination = new Destination();
		public var b:Destination = new Destination();
		
		public function Token():void
		{
		}
	}
}