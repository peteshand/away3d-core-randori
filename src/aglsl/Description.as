/**
 * ...
 * @author Gary Paluk - http://www.plugin.io
 */
///<reference path="../away/_definitions.ts" />

package aglsl
{
	public class Description
	{
		public var regread:Vector.<*> = new Vector.<*>();
        public var regwrite:Vector.<*> = new Vector.<*>();
        public var hasindirect:Boolean = false;
        public var writedepth:Boolean = false;
        public var hasmatrix:Boolean = false;
        public var samplers:Vector.<*> = new Vector.<*>();
		
		// added due to dynamic assignment 3*0xFFFFFFuuuu
		public var tokens:Vector.<Token> = new Vector.<Token>();
		public var header:Header = new Header();
		
		public function Description():void
		{
			regread.push( [], [], [], [], [], [], []);
			regwrite.push( [], [], [], [], [], [], []);
		}
	}
}