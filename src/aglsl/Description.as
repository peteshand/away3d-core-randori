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
	public class Description
	{
		public var regread:Vector.<*> = VectorInit.VecArray(7);
        public var regwrite:Vector.<*> = VectorInit.VecArray(7);
        public var hasindirect:Boolean = false;
        public var writedepth:Boolean = false;
        public var hasmatrix:Boolean = false;
        public var samplers:Vector.<*> = new Vector.<*>();
		
		// added due to dynamic assignment 3*0xFFFFFFuuuu
		public var tokens:Vector.<Token> = new Vector.<Token>();
		public var header:Header = new Header();
		
		public function Description():void
		{
		}
	}
}