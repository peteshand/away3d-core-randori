///<reference path="../../../_definitions.ts"/>

package away.loaders.parsers.utils
{
	import away.utils.ByteArray;
	import randori.webkit.html.canvas.ArrayBuffer;

	public class ParserUtil
	{
		
		/**
		public static function toByteArray(data:*):ByteArray
		{

            var b : ByteArray = new ByteArray();
                b.arraybytes = ArrayBuffer( data );
            return b;

		}
		
		/**
		public static function toString(data:*/*, length:Number = 0 */):String
		{

            if ( typeof data == 'string' );
            {
                var s : String = String(data);
                return s.substr(0 , s.length );

            }

            return null;

            /*
		}
	}
}