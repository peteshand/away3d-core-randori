    /** * ... * @author Gary Paluk - http://www.plugin.io */

///<reference path="../../away/_definitions.ts" />

package aglsl.assembler
{
	public class Opcode
	{
		
		public var dest:String;
		public var a:FS;
		public var b:FS;
		public var opcode:Number;
		public var flags:Flags;
		
		public function Opcode(dest:String, aformat:String, asize:Number, bformat:String, bsize:Number, opcode:Number, simple:Boolean, horizontal:Boolean, fragonly:Boolean, matrix:Boolean):void
		{
			a = new FS();
			b = new FS();
			flags = new Flags();
			
			dest = dest;
			a.format = aformat;
			a.size = asize;
			b.format = bformat;
			b.size = bsize;
			opcode = opcode;
			flags.simple = simple;
			flags.horizontal = horizontal;
			flags.fragonly = fragonly;
			flags.matrix = matrix;
		}
	}
	
}