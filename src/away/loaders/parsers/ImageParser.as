

///<reference path="../../_definitions.ts"/>

package away.loaders.parsers
{
	import away.textures.Texture2DBase;
	import away.textures.HTMLImageElementTexture;
	import away.utils.TextureUtils;
	import away.library.assets.IAsset;
	import away.events.AssetEvent;
	import randori.webkit.html.HTMLImageElement;

	/**	 * ImageParser provides a "parser" for natively supported image types (jpg, png). While it simply loads bytes into	 * a loader object, it wraps it in a BitmapDataResource so resource management can happen consistently without	 * exception cases.	 */
	public class ImageParser extends ParserBase
	{
		//private var _byteData         : ByteArray;
		private var _startedParsing:Boolean;
		private var _doneParsing:Boolean;
		//private var _loader           : Loader;

		/**		 * Creates a new ImageParser object.		 * @param uri The url or id of the data or file to be parsed.		 * @param extra The holder for extra contextual data that the parser might need.		 */
		public function ImageParser():void
		{

			super( ParserDataFormat.IMAGE , ParserLoaderType.IMG_LOADER );

		}

		/**		 * Indicates whether or not a given file extension is supported by the parser.		 * @param extension The file extension of a potential file to be parsed.		 * @return Whether or not the given file type is supported.		 */

		public static function supportsType(extension:String):Boolean
		{

			extension = extension.toLowerCase();
			return extension == "jpg" || extension == "jpeg" || extension == "png" || extension == "gif" ;//|| extension == "bmp";//|| extension == "atf";

		}

		/**		 * Tests whether a data block can be parsed by the parser.		 * @param data The data block to potentially be parsed.		 * @return Whether or not the given data is supported.		 */
		public static function supportsData(data:*):Boolean
		{

            if ( data  instanceof HTMLImageElement )
            {

                return true;
            }

            return false;

		}

		/**		 * @inheritDoc		 */
		override public function _pProceedParsing():Boolean
		{

            var asset : Texture2DBase;

            if ( data  instanceof HTMLImageElement )
            {

                asset = Texture2DBase(new HTMLImageElementTexture( HTMLImageElement(data) , false ));

                if ( TextureUtils.isHTMLImageElementValid( HTMLImageElement(data) ) )
                {

                    _pFinalizeAsset( IAsset(asset), _iFileName );


                }
                else
                {

                    dispatchEvent( new AssetEvent( AssetEvent.TEXTURE_SIZE_ERROR , IAsset(asset)) );

                }

                return ParserBase.PARSING_DONE;

            }

            return ParserBase.PARSING_DONE;

		}

	}
}