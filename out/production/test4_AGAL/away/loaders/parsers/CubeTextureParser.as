/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package away.loaders.parsers
{
	import away.textures.Texture2DBase;
	import away.loaders.misc.ResourceDependency;
	import away.core.net.URLRequest;
	import away.core.net.IMGLoader;
	import away.events.Event;
	import away.textures.HTMLImageElementCubeTexture;
	import away.library.assets.IAsset;
	import core.JSON;
	import randori.webkit.html.HTMLImageElement;

	/**	 * ImageParser provides a "parser" for natively supported image types (jpg, png). While it simply loads bytes into	 * a loader object, it wraps it in a BitmapDataResource so resource management can happen consistently without	 * exception cases.	 */
	public class CubeTextureParser extends ParserBase
	{

        private static var posX:String = 'posX';
        private static var negX:String = 'negX';
        private static var posY:String = 'posY';
        private static var negY:String = 'negY';
        private static var posZ:String = 'posZ';
        private static var negZ:String = 'negZ';

        private var STATE_PARSE_DATA:Number = 0;
        private var STATE_LOAD_IMAGES:Number = 1;
        private var STATE_COMPLETE:Number = 2;

        private var _state:Number = -1;
        private var _dependencyCount:Number = 0;
        private var _loadedTextures:Vector.<Texture2DBase>;

        private var _imgLoaderDictionary:Object;
        private var _totalImages:Number = 0;
        private var _loadedImageCounter:Number = 0;

		/**		 * Creates a new ImageParser object.		 * @param uri The url or id of the data or file to be parsed.		 * @param extra The holder for extra contextual data that the parser might need.		 */
		public function CubeTextureParser():void
		{

			super( ParserDataFormat.PLAIN_TEXT , ParserLoaderType.URL_LOADER );

            this._loadedTextures = new Vector.<Texture2DBase>();
            this._state = this.STATE_PARSE_DATA;

		}

		/**		 * Indicates whether or not a given file extension is supported by the parser.		 * @param extension The file extension of a potential file to be parsed.		 * @return Whether or not the given file type is supported.		 */

		public static function supportsType(extension:String):Boolean
		{

			extension = extension.toLowerCase();
			return extension == "cube";

		}

		/**		 * Tests whether a data block can be parsed by the parser.		 * @param data The data block to potentially be parsed.		 * @return Whether or not the given data is supported.		 */
		public static function supportsData(data:*):Boolean
		{
            try
            {
                var obj = JSON.parse( data  );

                if ( obj )
                {
                    return true;
                }
                return false;
            }
            catch ( e )
            {
                return false;
            }

            return false;
		}

        /**         * @inheritDoc         */
        override public function _iResolveDependency(resourceDependency:ResourceDependency):void
        {

        }

        /**         * @inheritDoc         */
        override public function _iResolveDependencyFailure(resourceDependency:ResourceDependency):void
        {

        }

        private function parseJson():void
        {

            if ( CubeTextureParser.supportsData( this.data ) )
            {

                try
                {

                    this._imgLoaderDictionary = new Object();

                    var json        : * = JSON.parse( this.data );
                    var data        : Array = (json.data as Array);
                    var rec         : *;
                    var rq          : URLRequest;

                    for ( var c : Number = 0 ; c < data.length ; c ++ )
                    {

                        rec                 = data[c];

                        var uri : String    = rec.image;
                        var id  : Number    = rec.id;

                        rq                  = new URLRequest( uri );

                        // Note: Not loading dependencies as we want these to be CubeTexture ( loader will automatically convert to Texture2d ) ;
                        var imgLoader : IMGLoader  = new IMGLoader();

                            imgLoader.name                  = rec.id;
                            imgLoader.load( rq );
                            imgLoader.addEventListener( Event.COMPLETE , onIMGLoadComplete , this );

                        this._imgLoaderDictionary[ imgLoader.name ] = imgLoader;

                    }

                    if ( data.length != 6 )
                    {
                        this._pDieWithError( 'CubeTextureParser: Error - cube texture should have exactly 6 images');
                        this._state = this.STATE_COMPLETE;

                        return;
                    }


                    if ( ! this.validateCubeData() )
                    {

                        this._pDieWithError(    "CubeTextureParser: JSON data error - cubes require id of:   \n" +
                                                CubeTextureParser.posX + ', ' + CubeTextureParser.negX + ',  \n' +
                                                CubeTextureParser.posY + ', ' + CubeTextureParser.negY + ',  \n' +
                                                CubeTextureParser.posZ + ', ' + CubeTextureParser.negZ ) ;

                        this._state = this.STATE_COMPLETE;

                        return;

                    }

                    this._state = this.STATE_LOAD_IMAGES;

                }
                catch ( e )
                {

                    this._pDieWithError( 'CubeTexturePaser Error parsing JSON');
                    this._state = this.STATE_COMPLETE;

                }


            }

        }

        private function createCubeTexture():void
        {

            var asset : HTMLImageElementCubeTexture = new HTMLImageElementCubeTexture (

                    this.getHTMLImageElement( CubeTextureParser.posX ) , this.getHTMLImageElement( CubeTextureParser.negX ),
                    this.getHTMLImageElement( CubeTextureParser.posY ) , this.getHTMLImageElement( CubeTextureParser.negY ),
                    this.getHTMLImageElement( CubeTextureParser.posZ ) , this.getHTMLImageElement( CubeTextureParser.negZ )
                );

                asset.name = this._iFileName;

            this._pFinalizeAsset( (asset as IAsset) , this._iFileName  );

            this._state = this.STATE_COMPLETE;

        }

        private function validateCubeData():Boolean
        {

            return  ( this.getHTMLImageElement( CubeTextureParser.posX ) != null && this.getHTMLImageElement( CubeTextureParser.negX ) != null &&
                      this.getHTMLImageElement( CubeTextureParser.posY ) != null && this.getHTMLImageElement( CubeTextureParser.negY ) != null &&
                      this.getHTMLImageElement( CubeTextureParser.posZ ) != null && this.getHTMLImageElement( CubeTextureParser.negZ ) != null );

        }

        private function getHTMLImageElement(name:String):HTMLImageElement
        {

            var imgLoader : IMGLoader = (this._imgLoaderDictionary[name] as IMGLoader);

            if ( imgLoader )
            {
                return imgLoader.image;
            }

            return null;

        }

        private function onIMGLoadComplete(e:Event):void
        {

            this._loadedImageCounter ++;

            if ( this._loadedImageCounter == 6 )
            {
                this.createCubeTexture();
            }

        }

		/**		 * @inheritDoc		 */
		override public function _pProceedParsing():Boolean
		{

            switch ( this._state )
            {

                case this.STATE_PARSE_DATA:

                    this.parseJson();
                    return ParserBase.MORE_TO_PARSE;

                    break;

                case this.STATE_LOAD_IMAGES:

                    // Async load image process
                    //return away.loaders.ParserBase.MORE_TO_PARSE;

                    break;

                case this.STATE_COMPLETE:

                    return ParserBase.PARSING_DONE;

                    break;

            }
			return false;
		}

	}
}