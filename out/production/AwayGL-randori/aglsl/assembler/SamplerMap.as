/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package aglsl.assembler
{
	
	public class SamplerMap
	{

        private static var _map:Vector.<Object>;
		
		public function SamplerMap():void
		{
			
		}
		
        public static function map():Vector.<Object>
        {
            if ( ! SamplerMap._map )
            {
                SamplerMap._map = new Vector.<Object>();
                SamplerMap._map['rgba'] = new aglsl.assembler.Sampler( 8, 0xf, 0 );
                SamplerMap._map['rg'] = new aglsl.assembler.Sampler( 8, 0xf, 5 );
                SamplerMap._map['r'] = new aglsl.assembler.Sampler( 8, 0xf, 4 );
                SamplerMap._map['compressed'] = new aglsl.assembler.Sampler( 8, 0xf, 1 );
                SamplerMap._map['compressed_alpha'] = new aglsl.assembler.Sampler( 8, 0xf, 2 );
                SamplerMap._map['dxt1'] = new aglsl.assembler.Sampler( 8, 0xf, 1 );
                SamplerMap._map['dxt5'] = new aglsl.assembler.Sampler( 8, 0xf, 2 );

                // dimension
                SamplerMap._map['2d'] = new aglsl.assembler.Sampler( 12, 0xf, 0 );
                SamplerMap._map['cube'] = new aglsl.assembler.Sampler( 12, 0xf, 1 );
                SamplerMap._map['3d'] = new aglsl.assembler.Sampler( 12, 0xf, 2 );

                // special
                SamplerMap._map['centroid'] = new aglsl.assembler.Sampler( 16, 1, 1 );
                SamplerMap._map['ignoresampler'] = new aglsl.assembler.Sampler( 16, 4, 4 );

                // repeat
                SamplerMap._map['clamp'] = new aglsl.assembler.Sampler( 20, 0xf, 0 );
                SamplerMap._map['repeat'] = new aglsl.assembler.Sampler( 20, 0xf, 1 );
                SamplerMap._map['wrap'] = new aglsl.assembler.Sampler( 20, 0xf, 1 );

                // mip
                SamplerMap._map['nomip'] = new aglsl.assembler.Sampler( 24, 0xf, 0 );
                SamplerMap._map['mipnone'] = new aglsl.assembler.Sampler( 24, 0xf, 0 );
                SamplerMap._map['mipnearest'] = new aglsl.assembler.Sampler( 24, 0xf, 1 );
                SamplerMap._map['miplinear'] = new aglsl.assembler.Sampler( 24, 0xf, 2 );

                // filter
                SamplerMap._map['nearest'] = new aglsl.assembler.Sampler( 28, 0xf, 0 );
                SamplerMap._map['linear'] = new aglsl.assembler.Sampler( 28, 0xf, 1 );
            }
            return SamplerMap._map;
        }
	}
}


