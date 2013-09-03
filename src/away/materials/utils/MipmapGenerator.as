

///<reference path="../../_definitions.ts"/>

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

	/**
	public class MipmapGenerator
	{
		private static var _matrix:Matrix = new Matrix();
        private static var _rect:Rectangle = new Rectangle();
        private static var _source:BitmapData;//= new away.display.BitmapData();
        /**
        public static function generateHTMLImageElementMipMaps(source:HTMLImageElement, target:TextureBase, mipmap:BitmapData = null, alpha:Boolean = false, side:Number = -1):void
        {

            MipmapGenerator._rect.width     = source.width;
            MipmapGenerator._rect.height    = source.height;

            MipmapGenerator._source = new BitmapData( source.width , source.height , alpha );
            MipmapGenerator._source.drawImage( source , MipmapGenerator._rect , MipmapGenerator._rect );

            MipmapGenerator.generateMipMaps( MipmapGenerator._source , target , mipmap );

            MipmapGenerator._source.dispose();
            MipmapGenerator._source = null;



        }
		/**
		public static function generateMipMaps(source:BitmapData, target:TextureBase, mipmap:BitmapData = null, alpha:Boolean = false, side:Number = -1):void
		{
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
                    tx = Texture(target);
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