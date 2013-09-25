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

        public static function get map():Vector.<Object>
        {

            if ( ! SamplerMap._map )
            {

                SamplerMap._map = new Vector.<Object>();
                SamplerMap._map['rgba'] = new Sampler( 8, 0xf, 0 );
                SamplerMap._map['rg'] = new Sampler( 8, 0xf, 5 );
                SamplerMap._map['r'] = new Sampler( 8, 0xf, 4 );
                SamplerMap._map['compressed'] = new Sampler( 8, 0xf, 1 );
                SamplerMap._map['compressed_alpha'] = new Sampler( 8, 0xf, 2 );
                SamplerMap._map['dxt1'] = new Sampler( 8, 0xf, 1 );
                SamplerMap._map['dxt5'] = new Sampler( 8, 0xf, 2 );

                // dimension
                SamplerMap._map['2d'] = new Sampler( 12, 0xf, 0 );
                SamplerMap._map['cube'] = new Sampler( 12, 0xf, 1 );
                SamplerMap._map['3d'] = new Sampler( 12, 0xf, 2 );

                // special
                SamplerMap._map['centroid'] = new Sampler( 16, 1, 1 );
                SamplerMap._map['ignoresampler'] = new Sampler( 16, 4, 4 );

                // repeat
                SamplerMap._map['clamp'] = new Sampler( 20, 0xf, 0 );
                SamplerMap._map['repeat'] = new Sampler( 20, 0xf, 1 );
                SamplerMap._map['wrap'] = new Sampler( 20, 0xf, 1 );

                // mip
                SamplerMap._map['nomip'] = new Sampler( 24, 0xf, 0 );
                SamplerMap._map['mipnone'] = new Sampler( 24, 0xf, 0 );
                SamplerMap._map['mipnearest'] = new Sampler( 24, 0xf, 1 );
                SamplerMap._map['miplinear'] = new Sampler( 24, 0xf, 2 );

                // filter
                SamplerMap._map['nearest'] = new Sampler( 28, 0xf, 0 );
                SamplerMap._map['linear'] = new Sampler( 28, 0xf, 1 );

            }

            return SamplerMap._map;

        }

        /*        public static map =     [ new aglsl.assembler.Sampler( 8, 0xf, 0 ),								  new aglsl.assembler.Sampler( 8, 0xf, 5 ),								  new aglsl.assembler.Sampler( 8, 0xf, 4 ),        						  new aglsl.assembler.Sampler( 8, 0xf, 1 ),        						  new aglsl.assembler.Sampler( 8, 0xf, 2 ),        						  new aglsl.assembler.Sampler( 8, 0xf, 1 ),        						  new aglsl.assembler.Sampler( 8, 0xf, 2 ),                // dimension        						  new aglsl.assembler.Sampler( 12, 0xf, 0 ),        						  new aglsl.assembler.Sampler( 12, 0xf, 1 ),        						  new aglsl.assembler.Sampler( 12, 0xf, 2 ),                // special        						  new aglsl.assembler.Sampler( 16, 1, 1 ),        						  new aglsl.assembler.Sampler( 16, 4, 4 ),		        // repeat        						  new aglsl.assembler.Sampler( 20, 0xf, 0 ),        						  new aglsl.assembler.Sampler( 20, 0xf, 1 ),        						  new aglsl.assembler.Sampler( 20, 0xf, 1 ),                // mip        						  new aglsl.assembler.Sampler( 24, 0xf, 0 ),        						  new aglsl.assembler.Sampler( 24, 0xf, 0 ),        						  new aglsl.assembler.Sampler( 24, 0xf, 1 ),        						  new aglsl.assembler.Sampler( 24, 0xf, 2 ),                // filter        						  new aglsl.assembler.Sampler( 28, 0xf, 0 ),        						  new aglsl.assembler.Sampler( 28, 0xf, 1 ) ]		*/
		/*		public static rgba: aglsl.assembler.Sampler = new aglsl.assembler.Sampler( 8, 0xf, 0 );        public static rg: aglsl.assembler.Sampler = new aglsl.assembler.Sampler( 8, 0xf, 5 );        public static r: aglsl.assembler.Sampler = new aglsl.assembler.Sampler( 8, 0xf, 4 );        public static compressed: aglsl.assembler.Sampler = new aglsl.assembler.Sampler( 8, 0xf, 1 );        public static compressed_alpha: aglsl.assembler.Sampler = new aglsl.assembler.Sampler( 8, 0xf, 2 );        public static dxt1: aglsl.assembler.Sampler = new aglsl.assembler.Sampler( 8, 0xf, 1 );        public static dxt5: aglsl.assembler.Sampler = new aglsl.assembler.Sampler( 8, 0xf, 2 );                // dimension        public static sampler2d: aglsl.assembler.Sampler = new aglsl.assembler.Sampler( 12, 0xf, 0 );        public static cube: aglsl.assembler.Sampler = new aglsl.assembler.Sampler( 12, 0xf, 1 );        public static sampler3d: aglsl.assembler.Sampler = new aglsl.assembler.Sampler( 12, 0xf, 2 );                // special        public static centroid: aglsl.assembler.Sampler = new aglsl.assembler.Sampler( 16, 1, 1 );        public static ignoresampler: aglsl.assembler.Sampler = new aglsl.assembler.Sampler( 16, 4, 4 );        // repeat        public static clamp: aglsl.assembler.Sampler = new aglsl.assembler.Sampler( 20, 0xf, 0 );        public static repeat: aglsl.assembler.Sampler = new aglsl.assembler.Sampler( 20, 0xf, 1 );        public static wrap: aglsl.assembler.Sampler = new aglsl.assembler.Sampler( 20, 0xf, 1 );                // mip        public static nomip: aglsl.assembler.Sampler = new aglsl.assembler.Sampler( 24, 0xf, 0 );        public static mipnone: aglsl.assembler.Sampler = new aglsl.assembler.Sampler( 24, 0xf, 0 );        public static mipnearest: aglsl.assembler.Sampler = new aglsl.assembler.Sampler( 24, 0xf, 1 );        public static miplinear: aglsl.assembler.Sampler = new aglsl.assembler.Sampler( 24, 0xf, 2 );                // filter        public static nearest: aglsl.assembler.Sampler = new aglsl.assembler.Sampler( 28, 0xf, 0 );        public static linear: aglsl.assembler.Sampler = new aglsl.assembler.Sampler( 28, 0xf, 1 );		*/
		public function SamplerMap():void
		{
		}
	}
}
