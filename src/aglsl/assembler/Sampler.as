/** * ... * @author Gary Paluk - http://www.plugin.io */

///<reference path="../../away/_definitions.ts" />

package aglsl.assembler
{
	public class Sampler
	{
		public var shift:Number;
		public var mask:Number;
		public var value:Number;
		
		public function Sampler(shift:Number, mask:Number, value:Number):void
		{
			this.shift = shift;
			this.mask = mask;
			this.value = value;
		}
	}
}
