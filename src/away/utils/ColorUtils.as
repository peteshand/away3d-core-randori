/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package away.utils
{
    public class ColorUtils
    {

        public static function float32ColorToARGB(float32Color:Number):Vector.<Number>
        {

            var a       : Number = ( float32Color & 0xff000000 ) >>> 24
            var r       : Number = ( float32Color & 0xff0000 ) >>> 16;
            var g       : Number = ( float32Color & 0xff00 ) >>> 8;
            var b       : Number = float32Color & 0xff;
            var result  : Vector.<Number>  = new <Number>[ a, r , g , b ];

            return result;

        }

        private static function componentToHex(c:Number):String
        {

            var hex = c.toString(16);
            return hex.length == 1 ? "0" + hex : hex;

        }

        public static function RGBToHexString(argb:Vector.<Number>):String
        {

            return "#" + ColorUtils.componentToHex( argb[1] ) + ColorUtils.componentToHex( argb[2] ) + ColorUtils.componentToHex( argb[3] );

        }

        public static function ARGBToHexString(argb:Vector.<Number>):String
        {

            return "#" + ColorUtils.componentToHex( argb[0] ) + ColorUtils.componentToHex( argb[1] ) + ColorUtils.componentToHex( argb[2] ) + ColorUtils.componentToHex( argb[3] );

        }


    }
}