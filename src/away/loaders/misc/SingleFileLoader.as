///<reference path="../../_definitions.ts"/>
package away.loaders.misc
{
	import away.events.EventDispatcher;
	import away.loaders.parsers.ParserBase;
	import away.net.URLRequest;
	import away.loaders.parsers.ImageParser;
	import away.loaders.parsers.ParserLoaderType;
	import away.net.URLLoaderDataFormat;
	import away.loaders.parsers.ParserDataFormat;
	import away.events.Event;
	import away.events.IOErrorEvent;
	import away.events.LoaderEvent;
	import away.events.ParserEvent;
	import away.events.AssetEvent;

	/**	 * The SingleFileLoader is used to load a single file, as part of a resource.	 *	 * While SingleFileLoader can be used directly, e.g. to create a third-party asset 	 * management system, it's recommended to use any of the classes Loader3D, AssetLoader	 * and AssetLibrary instead in most cases.	 *	 * @see away3d.loading.Loader3D	 * @see away3d.loading.AssetLoader	 * @see away3d.loading.AssetLibrary	 */
	public class SingleFileLoader extends EventDispatcher
	{
		private var _parser:ParserBase;
		private var _req:URLRequest;
		private var _fileExtension:String;
		private var _fileName:String;
		private var _loadAsRawData:Boolean;
		private var _materialMode:Number;
		private var _data:*;

        // Static

		// Image parser only parser that is added by default, to save file size.
        private static var _parsers:Vector.<*> = new Vector.<*>( ImageParser );

        public static function enableParser(parser:Object):void
        {
            if (SingleFileLoader._parsers.indexOf(parser) < 0)
            {

                SingleFileLoader._parsers.push(parser);

            }

        }

        public static function enableParsers(parsers:Vector.<Object>):void
        {
            var pc : Object;

            for( var c : Number = 0 ; c < parsers.length ; c ++ )
            {
                SingleFileLoader.enableParser( parsers[ c ] );

            }

        }

        // Constructor

		/**		 * Creates a new SingleFileLoader object.		 */
		public function SingleFileLoader(materialMode:Number = 0):void
		{

            super();
			this._materialMode=materialMode;
		}

        // Get / Set
		
		public function get url():String
		{

			return _req ? _req.url : '';
		}
		
		public function get data():*
		{
			return _data;
		}
		
		public function get loadAsRawData():Boolean
		{
			return _loadAsRawData;
		}

        // Public

		/**		 * Load a resource from a file.		 * 		 * @param urlRequest The URLRequest object containing the URL of the object to be loaded.		 * @param parser An optional parser object that will translate the loaded data into a usable resource. If not provided, AssetLoader will attempt to auto-detect the file type.		 */
		public function load(urlRequest:URLRequest, parser:ParserBase = null, loadAsRawData:Boolean = false):void
		{
			//var urlLoader   : away.net.URLLoader;
			var dataFormat  : String;
            var loaderType  : String    = ParserLoaderType.URL_LOADER;// Default to URLLoader;

			_loadAsRawData         = loadAsRawData;
			_req                   = urlRequest;

			decomposeFilename( _req.url );

			if ( _loadAsRawData ) {

				// Always use binary for raw data loading
				dataFormat = URLLoaderDataFormat.BINARY;

			}
			else
            {

				if (parser)
                {
                    _parser = parser;
                }
				
				if ( ! _parser )
                {
                    _parser = getParserFromSuffix();
                }

				if (_parser)
                {

                    //--------------------------------------------
                    // Data Format

                    switch ( _parser.dataFormat )
                    {

                        case ParserDataFormat.BINARY:
                            dataFormat = URLLoaderDataFormat.BINARY;
                            break;

                        case ParserDataFormat.PLAIN_TEXT:
                            dataFormat = URLLoaderDataFormat.TEXT;
                            break;

                    }

                    //--------------------------------------------
                    // Loader Type

                    switch ( _parser.loaderType )
                    {

                        case ParserLoaderType.IMG_LOADER:
                            loaderType = ParserLoaderType.IMG_LOADER;
                            break;

                        case ParserLoaderType.URL_LOADER:
                            loaderType = ParserLoaderType.URL_LOADER;
                            break;
                    }
					
				}
                else
                {

					// Always use BINARY for unknown file formats. The thorough
					// file type check will determine format after load, and if
					// binary, a text load will have broken the file data.
					dataFormat = URLLoaderDataFormat.BINARY;

				}
			}

            var loader : ISingleFileTSLoader = getLoader( loaderType );
                loader.dataFormat = dataFormat;
                loader.addEventListener(Event.COMPLETE, handleUrlLoaderComplete , this );
                loader.addEventListener(IOErrorEvent.IO_ERROR, handleUrlLoaderError , this );
                loader.load( urlRequest );

		}
		
		/**		 * Loads a resource from already loaded data.		 * @param data The data to be parsed. Depending on the parser type, this can be a ByteArray, String or XML.		 * @param uri The identifier (url or id) of the object to be loaded, mainly used for resource management.		 * @param parser An optional parser object that will translate the data into a usable resource. If not provided, AssetLoader will attempt to auto-detect the file type.		 */
		
		public function parseData(data:*, parser:ParserBase = null, req:URLRequest = null):void
		{
            if ( data.constructor === Function ) // TODO: Validate
            {
                data = new data();
            }

			if (parser)
            {
                _parser = parser;
            }

			_req = req;
			parse(data);

		}
		
		/**		 * A reference to the parser that will translate the loaded data into a usable resource.		 */
		public function get parser():ParserBase
		{
			return _parser;
		}
		
		/**		 * A list of dependencies that need to be loaded and resolved for the loaded object.		 */

		public function get dependencies():Vector.<ResourceDependency>
		{
			return _parser? _parser.dependencies : new Vector.<ResourceDependency>();
		}

        // Private

        /**         *         * @param loaderType         */
        private function getLoader(loaderType:String):ISingleFileTSLoader
        {

            var loader : ISingleFileTSLoader;

            switch ( loaderType )
            {

                case ParserLoaderType.IMG_LOADER :
                    loader = new SingleFileImageLoader();
                    break;

                case ParserLoaderType.URL_LOADER:
                    loader = new SingleFileURLLoader();
                    break;

            }

            return loader;

        }

		/**		 * Splits a url string into base and extension.		 * @param url The url to be decomposed.		 */
		private function decomposeFilename(url:String):void
		{
			
			// Get rid of query string if any and extract suffix
			var base    : String    = (url.indexOf('?')>0)? url.split('?')[0] : url;
			var i       : Number    = base.lastIndexOf('.');
			_fileExtension     = base.substr(i + 1).toLowerCase();
			_fileName          = base.substr(0, i);

		}
		
		/**		 * Guesses the parser to be used based on the file extension.		 * @return An instance of the guessed parser.		 */
		private function getParserFromSuffix():ParserBase
		{
			var len : Number = SingleFileLoader._parsers.length;

            //console.log( SingleFileLoader._parsers );

			// go in reverse order to allow application override of default parser added in Away3D proper
			for (var i : Number = len-1; i >= 0; i--)
            {

                var currentParser : ParserBase = SingleFileLoader._parsers[i];
                var supportstype : Boolean                  = SingleFileLoader._parsers[i].supportsType(_fileExtension);

                if (SingleFileLoader._parsers[i]['supportsType'](_fileExtension)){

                    return new SingleFileLoader._parsers[i]();


                }

            }

			return null;

		}
		/**		 * Guesses the parser to be used based on the file contents.		 * @param data The data to be parsed.		 * @param uri The url or id of the object to be parsed.		 * @return An instance of the guessed parser.		 */
		private function getParserFromData(data:*):ParserBase
		{
			var len : Number = SingleFileLoader._parsers.length;
			
			// go in reverse order to allow application override of default parser added in Away3D proper
			for (var i : Number = len-1; i >= 0; i--)
				if (SingleFileLoader._parsers[i].supportsData(data))
					return new SingleFileLoader._parsers[i]();
			
			return null;
		}
		
		/**		 * Cleanups		 */
		private function removeListeners(urlLoader:ISingleFileTSLoader):void
		{
			urlLoader.removeEventListener(Event.COMPLETE, handleUrlLoaderComplete , this );
			urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, handleUrlLoaderError , this );
		}

        // Events
		
		/**		 * Called when loading of a file has failed		 */
		private function handleUrlLoaderError(event:IOErrorEvent):void
		{
			var urlLoader : ISingleFileTSLoader = ISingleFileTSLoader(event.target);
			removeListeners(urlLoader);
			
			//if(this.hasEventListener(away.events.LoaderEvent.LOAD_ERROR , this.handleUrlLoaderError , this ))
				dispatchEvent(new LoaderEvent(LoaderEvent.LOAD_ERROR, _req.url, true ) ) ;//, event.text));
		}
		
		/**		 * Called when loading of a file is complete		 */
		private function handleUrlLoaderComplete(event:Event):void
		{

			var urlLoader : ISingleFileTSLoader = ISingleFileTSLoader(event.target);
			removeListeners( urlLoader );
			
			_data = urlLoader.data;

			if (_loadAsRawData)
            {
                // No need to parse this data, which should be returned as is
				dispatchEvent(new LoaderEvent(LoaderEvent.DEPENDENCY_COMPLETE));
            }
			else
            {
                parse(_data);
			}
		}
		
		/**		 * Initiates parsing of the loaded data.		 * @param data The data to be parsed.		 */
		private function parse(data:*):void
		{

			// If no parser has been defined, try to find one by letting
			// all plugged in parsers inspect the actual data.
			if ( ! _parser )
            {

				_parser = getParserFromData(data);

			}
			
			if( _parser )
            {

				_parser.addEventListener(ParserEvent.READY_FOR_DEPENDENCIES, onReadyForDependencies , this);
                _parser.addEventListener(ParserEvent.PARSE_ERROR, onParseError, this);
                _parser.addEventListener(ParserEvent.PARSE_COMPLETE, onParseComplete, this);
                _parser.addEventListener(AssetEvent.TEXTURE_SIZE_ERROR, onTextureSizeError, this);
                _parser.addEventListener(AssetEvent.ASSET_COMPLETE, onAssetComplete, this);
                _parser.addEventListener(AssetEvent.ANIMATION_SET_COMPLETE, onAssetComplete, this);
                _parser.addEventListener(AssetEvent.ANIMATION_STATE_COMPLETE, onAssetComplete, this);
                _parser.addEventListener(AssetEvent.ANIMATION_NODE_COMPLETE, onAssetComplete, this);
                _parser.addEventListener(AssetEvent.STATE_TRANSITION_COMPLETE, onAssetComplete, this);
                _parser.addEventListener(AssetEvent.TEXTURE_COMPLETE, onAssetComplete, this);
                _parser.addEventListener(AssetEvent.CONTAINER_COMPLETE, onAssetComplete, this);
                _parser.addEventListener(AssetEvent.GEOMETRY_COMPLETE, onAssetComplete, this);
                _parser.addEventListener(AssetEvent.MATERIAL_COMPLETE, onAssetComplete, this);
                _parser.addEventListener(AssetEvent.MESH_COMPLETE,onAssetComplete, this);
                _parser.addEventListener(AssetEvent.ENTITY_COMPLETE, onAssetComplete, this);
                _parser.addEventListener(AssetEvent.SKELETON_COMPLETE, onAssetComplete, this);
                _parser.addEventListener(AssetEvent.SKELETON_POSE_COMPLETE, onAssetComplete, this);
				
				if (_req && _req.url)
                {
                    _parser._iFileName = _req.url;
                }

				_parser.materialMode=_materialMode;
                _parser.parseAsync(data);

			}
            else
            {

				var msg:String = "No parser defined. To enable all parsers for auto-detection, use Parsers.enableAllBundled()";

				//if(hasEventListener(LoaderEvent.LOAD_ERROR)){
					dispatchEvent(new LoaderEvent(LoaderEvent.LOAD_ERROR, "", true, msg) );
				//} else{
				//	throw new Error(msg);
				//}
			}
		}
		
		private function onParseError(event:ParserEvent):void
		{
			dispatchEvent( event.clone() );
		}
		
		private function onReadyForDependencies(event:ParserEvent):void
		{
			dispatchEvent( event.clone() );
		}
		
		private function onAssetComplete(event:AssetEvent):void
		{
			dispatchEvent( event.clone() ) ;
		}

		private function onTextureSizeError(event:AssetEvent):void
		{
			dispatchEvent( event.clone() );
		}
		
		/**		 * Called when parsing is complete.		 */
		private function onParseComplete(event:ParserEvent):void
		{

			dispatchEvent( new LoaderEvent( LoaderEvent.DEPENDENCY_COMPLETE , url ) );//dispatch in front of removing listeners to allow any remaining asset events to propagate
			
			_parser.removeEventListener(ParserEvent.READY_FOR_DEPENDENCIES, onReadyForDependencies , this );
            _parser.removeEventListener(ParserEvent.PARSE_COMPLETE, onParseComplete, this );
            _parser.removeEventListener(ParserEvent.PARSE_ERROR, onParseError, this );
            _parser.removeEventListener(AssetEvent.TEXTURE_SIZE_ERROR, onTextureSizeError, this );
            _parser.removeEventListener(AssetEvent.ASSET_COMPLETE, onAssetComplete, this );
            _parser.removeEventListener(AssetEvent.ANIMATION_SET_COMPLETE, onAssetComplete, this );
            _parser.removeEventListener(AssetEvent.ANIMATION_STATE_COMPLETE, onAssetComplete, this );
            _parser.removeEventListener(AssetEvent.ANIMATION_NODE_COMPLETE, onAssetComplete, this );
            _parser.removeEventListener(AssetEvent.STATE_TRANSITION_COMPLETE, onAssetComplete, this );
            _parser.removeEventListener(AssetEvent.TEXTURE_COMPLETE, onAssetComplete, this );
            _parser.removeEventListener(AssetEvent.CONTAINER_COMPLETE, onAssetComplete, this );
            _parser.removeEventListener(AssetEvent.GEOMETRY_COMPLETE, onAssetComplete, this );
            _parser.removeEventListener(AssetEvent.MATERIAL_COMPLETE, onAssetComplete, this );
            _parser.removeEventListener(AssetEvent.MESH_COMPLETE, onAssetComplete, this );
            _parser.removeEventListener(AssetEvent.ENTITY_COMPLETE, onAssetComplete, this );
            _parser.removeEventListener(AssetEvent.SKELETON_COMPLETE, onAssetComplete, this );
            _parser.removeEventListener(AssetEvent.SKELETON_POSE_COMPLETE, onAssetComplete , this );

		}

	}

}
