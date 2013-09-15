/** * ... * @author Gary Paluk - http://www.plugin.io */

///<reference path="../away/_definitions.ts" />

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