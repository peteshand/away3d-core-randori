/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package away.materials.utils
{
	import away.geom.Matrix;
	import away.geom.Rectangle;
	import away.display.BitmapData;
	import away.display3D.TextureBase;
	import away.display3D.Texture;
	import away.utils.Debug;
	import randori.webkit.html.HTMLImageElement;
	//import flash.display.*;
	//import flash.display3D.textures.CubeTexture;
	//import flash.display3D.textures.Texture;
	//import flash.display3D.textures.TextureBase;
	//import flash.geom.*;

	/**	 * MipmapGenerator is a helper class that uploads BitmapData to a Texture including mipmap levels.	 */
	public class MipmapGenerator
	{
		private static var _matrix:Matrix = new Matrix();
        private static var _rect:Rectangle = new Rectangle();
        private static var _source:BitmapData;//= new away.display.BitmapData()

        /**         * Uploads a BitmapData with mip maps to a target Texture object.         * @param source         * @param target The target Texture to upload to.         * @param mipmap An optional mip map holder to avoids creating new instances for fe animated materials.         * @param alpha Indicate whether or not the uploaded bitmapData is transparent.         */
        public static function generateHTMLImageElementMipMaps(source:HTMLImageElement, target:TextureBase, mipmap:BitmapData = null, alpha:Boolean = false, side:Number = -1):void
        {
			mipmap = mipmap || null;
			alpha = alpha || false;
			side = side || -1;


            MipmapGenerator._rect.width     = source.width;
            MipmapGenerator._rect.height    = source.height;

            MipmapGenerator._source = new BitmapData( source.width , source.height , alpha );
            MipmapGenerator._source.drawImage( source , MipmapGenerator._rect , MipmapGenerator._rect );

            MipmapGenerator.generateMipMaps( MipmapGenerator._source , target , mipmap );

            MipmapGenerator._source.dispose();
            MipmapGenerator._source = null;



        }
		/**		 * Uploads a BitmapData with mip maps to a target Texture object.		 * @param source The source BitmapData to upload.		 * @param target The target Texture to upload to.		 * @param mipmap An optional mip map holder to avoids creating new instances for fe animated materials.		 * @param alpha Indicate whether or not the uploaded bitmapData is transparent.		 */
		public static function generateMipMaps(source:BitmapData, target:TextureBase, mipmap:BitmapData = null, alpha:Boolean = false, side:Number = -1):void
		{
			mipmap = mipmap || null;
			alpha = alpha || false;
			side = side || -1;

			var w       : Number    = source.width;
		    var h       : Number    = source.height;
            var regen   : Boolean   = mipmap != null;
			var i       : Number;

            if ( ! mipmap )
            {

                mipmap = new BitmapData(w, h, alpha);


            }

            MipmapGenerator._rect.width = w;
            MipmapGenerator._rect.height = h;

            var tx : Texture;
			
			while (w >= 1 || h >= 1) {

				if (alpha){

					mipmap.fillRect(MipmapGenerator._rect, 0);

                }

                MipmapGenerator._matrix.a   = MipmapGenerator._rect.width / source.width;
                MipmapGenerator._matrix.d   = MipmapGenerator._rect.height / source.height;

                mipmap.width                = MipmapGenerator._rect.width;
                mipmap.height               = MipmapGenerator._rect.height;
                mipmap.copyPixels( source , source.rect , MipmapGenerator._rect );

                //console.log( target instanceof away.display3D.Texture , mipmap.width , mipmap.height );

                if ( target instanceof Texture)
                {
                    tx = (target as Texture);
                    tx.uploadFromBitmapData(mipmap, i++);
                }
                else
                {
                    Debug.throwPIR( 'MipMapGenerator' , 'generateMipMaps' , 'Dependency: CubeTexture');
                    // TODO: implement cube texture upload;
                    //CubeTexture(target).uploadFromBitmapData(mipmap, side, i++);
                }

				w >>= 1;
				h >>= 1;

                MipmapGenerator._rect.width = w > 1? w : 1;
                MipmapGenerator._rect.height = h > 1? h : 1;
			}
			
			if ( ! regen )
            {

                mipmap.dispose();

            }

		}
	}
}
