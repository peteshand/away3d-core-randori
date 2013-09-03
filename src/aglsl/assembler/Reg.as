/** * ... * @author Gary Paluk - http://www.plugin.io */

///<reference path="../../away/_definitions.ts" />

package aglsl.assembler
{
	
	public class Reg
	{
		
		public var code:Number;
		public var desc:String;
		
		public function Reg(code:Number, desc:String):void
		{
			this.code = code;
			this.desc = desc;
		}
	}
}