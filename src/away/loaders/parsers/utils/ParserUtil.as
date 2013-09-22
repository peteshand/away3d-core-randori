///<reference path="../../../_definitions.ts"/>

package away.loaders.parsers.utils
{
	import away.utils.ByteArray;
	import randori.webkit.html.HTMLImageElement;

	public class ParserUtil
	{

        /**         * Converts an ByteArray to an Image - returns an HTMLImageElement         *         * @param image data as a ByteArray         *         * @return HTMLImageElement         *         */
        public static function byteArrayToImage(data:ByteArray):HTMLImageElement
        {

            var byteStr : String    = '';
            var bytes   : Uint8Array  = new Uint8Array( data.arraybytes );
            var len     : Number      = bytes.byteLength;

            for (var i = 0; i < len; i++)
            {
                byteStr += String.fromCharCode( bytes[ i ] )
            }

            var base64Image     : String            = window.btoa ( byteStr );
            var str             : String            = 'data:image/png;base64,'+base64Image;
            var img             : HTMLImageElement  = (new HTMLImageElement( ) as HTMLImageElement);
                img.src                             = str;

            return img;

        }
        /**		 * Returns a object as ByteArray, if possible.		 * 		 * @param data The object to return as ByteArray		 * 		 * @return The ByteArray or null		 *		 */
		public static function toByteArray(data:*):ByteArray
		{
            var b : ByteArray = new ByteArray();
                b.setArrayBuffer( data );
            return b;
		}
		/**		 * Returns a object as String, if possible.		 * 		 * @param data The object to return as String		 * @param length The length of the returned String		 * 		 * @return The String or null		 *		 */
		public static function toString(data:*, length:Number = 0):String
		{
			length = length || 0;


            if ( typeof data === 'string' );
            {

                var s : String = (data as String);

                if (s['substr'] != null )
                {
                    return s.substr(0 , s.length );
                }

            }

            if ( data instanceof ByteArray )
            {

                var ba : ByteArray = (data as ByteArray);
                    ba.position = 0;
                return ba.readUTFBytes( Math.min(ba.getBytesAvailable() , length));

            }

            return null;

            /*			var ba:ByteArray;						length ||= uint.MAX_VALUE;						if (data is String)				return String(data).substr(0, length);						ba = toByteArray(data);			if (ba) {				ba.position = 0;				return ba.readUTFBytes(Math.min(ba.bytesAvailable, length));			}						return null;			*/

		}
	}
}
