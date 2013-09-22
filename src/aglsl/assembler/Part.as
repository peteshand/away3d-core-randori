/** * ... * @author Gary Paluk - http://www.plugin.io */

///<reference path="../../away/_definitions.ts" />

package aglsl.assembler
{
	import away.utils.ByteArray;
	public class Part
	{
		public var name:String = "";		public var version:Number = 0;
		public var data:ByteArray;
		
		public function Part(name:String = null, version:Number = null):void
		{
			name = name || null;
			version = version || null;

			this.name = name;
			this.version = version;
			this.data = new ByteArray();
		}
	}
}