/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package aglsl.assembler
{	
	public class RegMap
	{
        private static var _map:Vector.<*>;
		
		public function RegMap():void
		{
			
		}
		
        public static function map():Vector.<*>
        {
            if ( ! RegMap._map )
            {
                RegMap._map = new Vector.<*>();
                RegMap._map['va'] =  new aglsl.assembler.Reg( 0x00, "vertex attribute" );
                RegMap._map['fc'] =  new aglsl.assembler.Reg( 0x01, "fragment constant" );
                RegMap._map['vc'] =  new aglsl.assembler.Reg( 0x01, "vertex constant" )
                RegMap._map['ft'] =  new aglsl.assembler.Reg( 0x02, "fragment temporary" );
                RegMap._map['vt'] =  new aglsl.assembler.Reg( 0x02, "vertex temporary" );
                RegMap._map['vo'] =  new aglsl.assembler.Reg( 0x03, "vertex output" );
                RegMap._map['op'] =  new aglsl.assembler.Reg( 0x03, "vertex output" );
                RegMap._map['fd'] =  new aglsl.assembler.Reg( 0x03, "fragment depth output" );
                RegMap._map['fo'] =  new aglsl.assembler.Reg( 0x03, "fragment output" );
                RegMap._map['oc'] =  new aglsl.assembler.Reg( 0x03, "fragment output" );
                RegMap._map['v']  =  new aglsl.assembler.Reg( 0x04, "varying" )
                RegMap._map['vi'] =  new aglsl.assembler.Reg( 0x04, "varying output" );
                RegMap._map['fi'] =  new aglsl.assembler.Reg( 0x04, "varying input" );
                RegMap._map['fs'] =  new aglsl.assembler.Reg( 0x05, "sampler" );
            }
            return RegMap._map;
        }
		
		
	}
}
