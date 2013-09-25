/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package away.utils
{
	import away.display.BitmapData;
	import randori.webkit.html.HTMLImageElement;
	//import flash.display.BitmapData;
	
	public class TextureUtils
	{
		private static var MAX_SIZE:Number = 2048;

        public static function isBitmapDataValid(bitmapData:BitmapData):Boolean
        {
            if (bitmapData == null)
            {

                return true;

            }

            return TextureUtils.isDimensionValid( bitmapData.width ) && TextureUtils.isDimensionValid( bitmapData.height );

        }

        public static function isHTMLImageElementValid(image:HTMLImageElement):Boolean
        {
            if (image == null)
            {

                return true;

            }

            return TextureUtils.isDimensionValid( image.width ) && TextureUtils.isDimensionValid( image.height );

        }
		
		public static function isDimensionValid(d:Number):Boolean
		{

			return d >= 1 && d <= TextureUtils.MAX_SIZE && TextureUtils.isPowerOfTwo(d);

		}
		
		public static function isPowerOfTwo(value:Number):Boolean
		{

			return value ? ( ( value & -value ) == value ) : false;

		}
		
		public static function getBestPowerOf2(value:Number):Number
		{

			var p:Number = 1;
			
			while (p < value)
				p <<= 1;
			
			if (p > TextureUtils.MAX_SIZE)
				p = TextureUtils.MAX_SIZE;
			
			return p;

		}
	}
}
