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
			shift = shift;
			mask = mask;
			value = value;
		}
	}
}
