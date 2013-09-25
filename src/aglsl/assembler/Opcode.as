/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package aglsl.assembler
{
	public class Opcode
	{
		
		public var dest:String = null;
		public var a:FS;
		public var b:FS;
		public var opcode:Number = 0;
		public var flags:Flags;
		
		public function Opcode(dest:String, aformat:String, asize:Number, bformat:String, bsize:Number, opcode:Number, simple:Boolean, horizontal:Boolean, fragonly:Boolean, matrix:Boolean):void
		{
			this.a = new FS();
			this.b = new FS();
			this.flags = new Flags();
			
			this.dest = dest;
			this.a.format = aformat;
			this.a.size = asize;
			this.b.format = bformat;
			this.b.size = bsize;
			this.opcode = opcode;
			this.flags.simple = simple;
			this.flags.horizontal = horizontal;
			this.flags.fragonly = fragonly;
			this.flags.matrix = matrix;
		}
	}
	
}