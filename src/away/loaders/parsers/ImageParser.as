

///<reference path="../../_definitions.ts"/>

package away.loaders.parsers
{
	import away.utils.ByteArray;
	import away.textures.Texture2DBase;
	import away.utils.TextureUtils;
	import away.textures.HTMLImageElementTexture;
	import away.library.assets.IAsset;
	import away.loaders.parsers.utils.ParserUtil;
	import away.textures.BitmapTexture;
	import away.materials.utils.DefaultMaterialManager;
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
                return true;

            if (!(data instanceof ByteArray))
                return false;

            var ba:ByteArray = (data as ByteArray);
            ba.position = 0;

            if (ba.readUnsignedShort() == 0xffd8)
                return true; // JPEG, maybe check for "JFIF" as well?

            ba.position = 0;
            if (ba.readShort() == 0x424D)
                return true; // BMP

            ba.position = 1;
            if (ba.readUTFBytes(3) == 'PNG')
                return true;

            ba.position = 0;
            if (ba.readUTFBytes(3) == 'GIF' && ba.readShort() == 0x3839 && ba.readByte() == 0x61)
                return true;

            ba.position = 0;
            if (ba.readUTFBytes(3) == 'ATF')
                return true;

            return false;

		}

		/**		 * @inheritDoc		 */
		override public function _pProceedParsing():Boolean
		{

            var asset       : Texture2DBase;
            var sizeError   : Boolean = false;

            if ( this.data instanceof HTMLImageElement )// Parse HTMLImageElement
            {

                if ( TextureUtils.isHTMLImageElementValid( HTMLImageElement(this.data) ) )
                {
                    asset = (new HTMLImageElementTexture( HTMLImageElement(this.data )  , false  ) as Texture2DBase);
                    this._pFinalizeAsset( (asset as IAsset) , this._iFileName  );
                }
                else
                {
                    sizeError = true;
                }

            }
            else if ( this.data instanceof ByteArray ) // Parse a ByteArray
            {

                var ba : ByteArray = this.data
                    ba.position = 0;
                var htmlImageElement : HTMLImageElement = ParserUtil.byteArrayToImage( this.data );

                if ( TextureUtils.isHTMLImageElementValid( htmlImageElement ) )
                {
                    asset = (new HTMLImageElementTexture( htmlImageElement  , false  ) as Texture2DBase);
                    this._pFinalizeAsset( (asset as IAsset) , this._iFileName  );
                }
                else
                {
                    sizeError = true;
                }

            }

            if ( sizeError == true ) // Generate new Checkerboard texture material
            {
                asset = (new BitmapTexture( DefaultMaterialManager.createCheckeredBitmapData( )  , false  ) as Texture2DBase);
                this._pFinalizeAsset( (asset as IAsset) , this._iFileName  );
                this.dispatchEvent( new AssetEvent( AssetEvent.TEXTURE_SIZE_ERROR , (asset as IAsset) )  );
            }

            return ParserBase.PARSING_DONE;

		}

	}
}