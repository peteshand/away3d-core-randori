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