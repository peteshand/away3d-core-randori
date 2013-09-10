/**
 * ...
 * @author Gary Paluk - http://www.plugin.io
 */
///<reference path="../../away/_definitions.ts" />

package aglsl.assembler
{
	public class RegMap
	{
        private static var _map:Vector.<*>;
        public static function get map():Vector.<*>
        {
            if ( ! RegMap._map )
            {
                RegMap._map = new Vector.<*>();
                RegMap._map['va'] =  new Reg( 0x00, "vertex attribute" );
                RegMap._map['fc'] =  new Reg( 0x01, "fragment constant" );
                RegMap._map['vc'] =  new Reg( 0x01, "vertex constant" )
                RegMap._map['ft'] =  new Reg( 0x02, "fragment temporary" );
                RegMap._map['vt'] =  new Reg( 0x02, "vertex temporary" );
                RegMap._map['vo'] =  new Reg( 0x03, "vertex output" );
                RegMap._map['op'] =  new Reg( 0x03, "vertex output" );
                RegMap._map['fd'] =  new Reg( 0x03, "fragment depth output" );
                RegMap._map['fo'] =  new Reg( 0x03, "fragment output" );
                RegMap._map['oc'] =  new Reg( 0x03, "fragment output" );
                RegMap._map['v']  =  new Reg( 0x04, "varying" )
                RegMap._map['vi'] =  new Reg( 0x04, "varying output" );
                RegMap._map['fi'] =  new Reg( 0x04, "varying input" );
                RegMap._map['fs'] =  new Reg( 0x05, "sampler" );
            }
            return RegMap._map;
        }
		
		public function RegMap():void
		{
		}
	}
}