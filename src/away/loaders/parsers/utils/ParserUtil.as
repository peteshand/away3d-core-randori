///<reference path="../../../_definitions.ts"/>
package away.loaders.parsers.utils
{
	import away.utils.ByteArray;
	import randori.webkit.html.canvas.ArrayBuffer;

	public class ParserUtil
	{
		
		/**
		 * Returns a object as ByteArray, if possible.
		 * 
		 * @param data The object to return as ByteArray
		 * 
		 * @return The ByteArray or null
		 *
		 */
		public static function toByteArray(data:*):ByteArray
		{

            var b : ByteArray = new ByteArray();
                b.arraybytes = ArrayBuffer( data );
            return b;

		}
		
		/**
		 * Returns a object as String, if possible.
		 * 
		 * @param data The object to return as String
		 * @param length The length of the returned String
		 * 
		 * @return The String or null
		 *
		 */
		public static function toString(data:*/*, length:Number = 0 */):String
		{

            if ( typeof data == 'string' );
            {
                var s : String = (data as String);
                return s.substr(0 , s.length );

            }

            return null;

            /*
			var ba:ByteArray;
			
			length ||= uint.MAX_VALUE;
			
			if (data is String)
				return String(data).substr(0, length);
			
			ba = toByteArray(data);
			if (ba) {
				ba.position = 0;
				return ba.readUTFBytes(Math.min(ba.bytesAvailable, length));
			}
			
			return null;

			*/
		}
	}
}
