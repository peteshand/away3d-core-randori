

///<reference path="../../_definitions.ts"/>

package away.loaders.parsers {
	import away.events.EventDispatcher;
	import away.loaders.misc.ResourceDependency;
	import away.utils.Timer;
	import away.errors.AbstractMethodError;
	import away.display.BitmapData;
	import away.utils.TextureUtils;
	import away.library.assets.IAsset;
	import away.library.assets.AssetType;
	import away.events.AssetEvent;
	import away.errors.Error;
	import away.events.TimerEvent;
	import away.events.ParserEvent;
	import away.net.URLRequest;
	import away.loaders.parsers.utils.ParserUtil;
	import away.utils.ByteArray;
	import randori.webkit.page.Window;

	/**	 * <code>ParserBase</code> provides an abstract base class for objects that convert blocks of data to data structures	 * supported by Away3D.	 *	 * If used by <code>AssetLoader</code> to automatically determine the parser type, two public static methods should	 * be implemented, with the following signatures:	 *	 * <code>public static supportsType(extension : string) : boolean</code>	 * Indicates whether or not a given file extension is supported by the parser.	 *	 * <code>public static supportsData(data : *) : boolean</code>	 * Tests whether a data block can be parsed by the parser.	 *	 * Furthermore, for any concrete subtype, the method <code>initHandle</code> should be overridden to immediately	 * create the object that will contain the parsed data. This allows <code>ResourceManager</code> to return an object	 * handle regardless of whether the object was loaded or not.	 *	 * @see away3d.loading.parsers.AssetLoader	 * @see away3d.loading.ResourceManager	 */
	public class ParserBase extends EventDispatcher
	{
		public var _iFileName:String; // ARCANE		private var _dataFormat:String;
		private var _data:*;
		private var _frameLimit:Number;
		private var _lastFrameTime:Number;

        //----------------------------------------------------------------------------------------------------------------------------------------------------------------
        // TODO: add error checking for the following ( could cause a problem if this function is not implemented )
        //----------------------------------------------------------------------------------------------------------------------------------------------------------------
        // Needs to be implemented in all Parsers (
        //<code>public static supportsType(extension : string) : boolean</code>
        //* Indicates whether or not a given file extension is supported by the parser.
        //----------------------------------------------------------------------------------------------------------------------------------------------------------------

        public static function supportsType(extension:String):Boolean
        {

            throw new AbstractMethodError();
            return false;

        }

        /* TODO: Implement ParserUtil;		public _pGetTextData():string		{			return ParserUtil.toString(_data);		}				public _pGetByteData():ByteArray		{			return ParserUtil.toByteArray(_data);		}		*/
		private var _dependencies:Vector.<ResourceDependency>;//Vector.<ResourceDependency>;        private var _loaderType:String = ParserLoaderType.URL_LOADER; // Default loader is URLLoader		private var _parsingPaused:Boolean;
		private var _parsingComplete:Boolean;
		private var _parsingFailure:Boolean;
		private var _timer:Timer;
		private var _materialMode:Number;
		
		/**		 * Returned by <code>proceedParsing</code> to indicate no more parsing is needed.		 */
		public static var PARSING_DONE:Boolean = true; /* Protected */		
		/**		 * Returned by <code>proceedParsing</code> to indicate more parsing is needed, allowing asynchronous parsing.		 */
        public static var MORE_TO_PARSE:Boolean = false; /* Protected */		
		
		/**		 * Creates a new ParserBase object		 * @param format The data format of the file data to be parsed. Can be either <code>ParserDataFormat.BINARY</code> or <code>ParserDataFormat.PLAIN_TEXT</code>, and should be provided by the concrete subtype.         * @param loaderType The type of loader required by the parser		 *		 * @see away3d.loading.parsers.ParserDataFormat		 */
		public function ParserBase(format:String, loaderType:String = null):void
		{

            super();

            if ( loaderType )
            {

                this._loaderType = loaderType;

            }

			this._materialMode=0;
			this._dataFormat    = format;
			this._dependencies  = new Vector.<ResourceDependency>();
		}
		
		/**		 * Validates a bitmapData loaded before assigning to a default BitmapMaterial 		 */

		public function isBitmapDataValid(bitmapData:BitmapData):Boolean
		{
			var isValid : Boolean = TextureUtils.isBitmapDataValid( bitmapData );

			if( ! isValid )
            {

                Window.console.log (">> Bitmap loaded is not having power of 2 dimensions or is higher than 2048");
            }
			
			return isValid;
		}

		public function set parsingFailure(b:Boolean):void
		{
			this._parsingFailure = b;
		}

		public function get parsingFailure():Boolean
		{
			return this._parsingFailure;
		}

		public function get parsingPaused():Boolean
		{
			return this._parsingPaused;
		}

		public function get parsingComplete():Boolean
		{
			return this._parsingComplete;
		}
		
		public function set materialMode(newMaterialMode:Number):void
		{
            this._materialMode=newMaterialMode;
		}
		
		public function get materialMode():Number
		{
			return this._materialMode;
		}

        public function get loaderType():String
        {

            return this._loaderType;

        }

        public function set loaderType(value:String):void
        {

            this._loaderType = value;

        }

        public function get data():*
        {

            return this._data;

        }

		/**		 * The data format of the file data to be parsed. Can be either <code>ParserDataFormat.BINARY</code> or <code>ParserDataFormat.PLAIN_TEXT</code>.		 */
		public function get dataFormat():String
		{
			return this._dataFormat;
		}
		
		/**		 * Parse data (possibly containing bytearry, plain text or BitmapAsset) asynchronously, meaning that		 * the parser will periodically stop parsing so that the AVM may proceed to the		 * next frame.		 *		 * @param data The untyped data object in which the loaded data resides.		 * @param frameLimit number of milliseconds of parsing allowed per frame. The		 * actual time spent on a frame can exceed this number since time-checks can		 * only be performed between logical sections of the parsing procedure.		 */
		public function parseAsync(data:*, frameLimit:Number = 30):void
		{
            this._data = data;
            this.startParsing(frameLimit);
		}
		
		/**		 * A list of dependencies that need to be loaded and resolved for the object being parsed.		 */
		public function get dependencies():Vector.<ResourceDependency>
		{
			return this._dependencies;
		}
		
		/**		 * Resolve a dependency when it's loaded. For example, a dependency containing an ImageResource would be assigned		 * to a Mesh instance as a BitmapMaterial, a scene graph object would be added to its intended parent. The		 * dependency should be a member of the dependencies property.		 *		 * @param resourceDependency The dependency to be resolved.		 */
		public function _iResolveDependency(resourceDependency:ResourceDependency):void
		{

            throw new AbstractMethodError();

		}
		
		/**		 * Resolve a dependency loading failure. Used by parser to eventually provide a default map		 *		 * @param resourceDependency The dependency to be resolved.		 */
		public function _iResolveDependencyFailure(resourceDependency:ResourceDependency):void
		{
            throw new AbstractMethodError();
		}

		/**		 * Resolve a dependency name		 *		 * @param resourceDependency The dependency to be resolved.		 */
		public function _iResolveDependencyName(resourceDependency:ResourceDependency, asset:IAsset):String
		{
			return asset.name;
		}
		
		public function _iResumeParsingAfterDependencies():void
		{
			this._parsingPaused = false;

			if (this._timer){

                this._timer.start();

            }
		}
		
		public function _pFinalizeAsset(asset:IAsset, name:String = null):void
		{
			var type_event : String;
			var type_name : String;
			
			if (name != null){

                asset.name = name;

            }

			switch (asset.assetType) {
				case AssetType.LIGHT_PICKER:
					type_name = 'lightPicker';
					type_event = AssetEvent.LIGHTPICKER_COMPLETE;
					break;
				case AssetType.LIGHT:
					type_name = 'light';
					type_event = AssetEvent.LIGHT_COMPLETE;
					break;
				case AssetType.ANIMATOR:
					type_name = 'animator';
					type_event = AssetEvent.ANIMATOR_COMPLETE;
					break;
				case AssetType.ANIMATION_SET:
					type_name = 'animationSet';
					type_event = AssetEvent.ANIMATION_SET_COMPLETE;
					break;
				case AssetType.ANIMATION_STATE:
					type_name = 'animationState';
					type_event = AssetEvent.ANIMATION_STATE_COMPLETE;
					break;
				case AssetType.ANIMATION_NODE:
					type_name = 'animationNode';
					type_event = AssetEvent.ANIMATION_NODE_COMPLETE;
					break;
				case AssetType.STATE_TRANSITION:
					type_name = 'stateTransition';
					type_event = AssetEvent.STATE_TRANSITION_COMPLETE;
					break;
				case AssetType.TEXTURE:
					type_name = 'texture';
					type_event = AssetEvent.TEXTURE_COMPLETE;
					break;
				case AssetType.TEXTURE_PROJECTOR:
					type_name = 'textureProjector';
					type_event = AssetEvent.TEXTURE_PROJECTOR_COMPLETE;
					break;
				case AssetType.CONTAINER:
					type_name = 'container';
					type_event = AssetEvent.CONTAINER_COMPLETE;
					break;
				case AssetType.GEOMETRY:
					type_name = 'geometry';
					type_event = AssetEvent.GEOMETRY_COMPLETE;
					break;
				case AssetType.MATERIAL:
					type_name = 'material';
					type_event = AssetEvent.MATERIAL_COMPLETE;
					break;
				case AssetType.MESH:
					type_name = 'mesh';
					type_event = AssetEvent.MESH_COMPLETE;
					break;
				case AssetType.SKELETON:
					type_name = 'skeleton';
					type_event = AssetEvent.SKELETON_COMPLETE;
					break;
				case AssetType.SKELETON_POSE:
					type_name = 'skelpose';
					type_event = AssetEvent.SKELETON_POSE_COMPLETE;
					break;
				case AssetType.ENTITY:
					type_name = 'entity';
					type_event = AssetEvent.ENTITY_COMPLETE;
					break;
				case AssetType.SKYBOX:
					type_name = 'skybox';
					type_event = AssetEvent.SKYBOX_COMPLETE;
					break;
				case AssetType.CAMERA:
					type_name = 'camera';
					type_event = AssetEvent.CAMERA_COMPLETE;
					break;
				case AssetType.SEGMENT_SET:
					type_name = 'segmentSet';
					type_event = AssetEvent.SEGMENT_SET_COMPLETE;
					break;
				case AssetType.EFFECTS_METHOD:
					type_name = 'effectsMethod';
					type_event = AssetEvent.EFFECTMETHOD_COMPLETE;
					break;
				case AssetType.SHADOW_MAP_METHOD:
					type_name = 'effectsMethod';
					type_event = AssetEvent.SHADOWMAPMETHOD_COMPLETE;
					break;
                default:
                    throw new away.errors.Error('Unhandled asset type '+asset.assetType+'. Report as bug!');
					break;
			};

            //console.log( 'ParserBase' , '_pFinalizeAsset.type_event: ' ,  type_event );

			// If the asset has no name, give it
			// a per-type default name.
			if (!asset.name)
				asset.name = type_name;
			
			this.dispatchEvent(new AssetEvent(AssetEvent.ASSET_COMPLETE, asset));
            this.dispatchEvent(new AssetEvent(type_event, asset));
		}
		
		/**		 * Parse the next block of data.		 * @return Whether or not more data needs to be parsed. Can be <code>ParserBase.ParserBase.PARSING_DONE</code> or		 * <code>ParserBase.ParserBase.MORE_TO_PARSE</code>.		 */
		public function _pProceedParsing():Boolean
		{

            throw new AbstractMethodError();
			return true;
		}

		public function _pDieWithError(message:String = 'Unknown parsing error'):void
		{
            if(this._timer)
            {
			    this._timer.removeEventListener(TimerEvent.TIMER, this._pOnInterval , this );
                this._timer.stop();
                this._timer = null;
            }

			this.dispatchEvent(new ParserEvent(ParserEvent.PARSE_ERROR, message));
		}

		public function _pAddDependency(id:String, req:URLRequest, retrieveAsRawData:Boolean = false, data:* = null, suppressErrorEvents:Boolean = false):void
		{

			this._dependencies.push(new ResourceDependency(id, req, data, this, retrieveAsRawData, suppressErrorEvents));
		}

		public function _pPauseAndRetrieveDependencies():void
		{
            if(this._timer)
            {
                this._timer.stop();
            }

			this._parsingPaused = true;
			this.dispatchEvent(new ParserEvent(ParserEvent.READY_FOR_DEPENDENCIES));
		}
		
		/**		 * Tests whether or not there is still time left for parsing within the maximum allowed time frame per session.		 * @return True if there is still time left, false if the maximum allotted time was exceeded and parsing should be interrupted.		 */
		public function _pHasTime():Boolean
		{

			return ((new Date().getTime() - this._lastFrameTime) < this._frameLimit);

		}
		
		/**		 * Called when the parsing pause interval has passed and parsing can proceed.		 */
		public function _pOnInterval(event:TimerEvent = null):void
		{
			this._lastFrameTime = new Date().getTime();

			if (this._pProceedParsing() && !this._parsingFailure){

				this._pFinishParsing();

            }
		}
		
		/**		 * Initializes the parsing of data.		 * @param frameLimit The maximum duration of a parsing session.		 */
		private function startParsing(frameLimit:Number):void
		{

			this._frameLimit = frameLimit;
			this._timer = new Timer(this._frameLimit, 0);
			this._timer.addEventListener(TimerEvent.TIMER, this._pOnInterval , this );
			this._timer.start();

		}

		/**		 * Finish parsing the data.		 */
		public function _pFinishParsing():void
		{

            //console.log( 'ParserBase._pFinishParsing');

            if(this._timer)
            {
			    this._timer.removeEventListener(TimerEvent.TIMER, this._pOnInterval , this );
			    this._timer.stop();
            }

			this._timer = null;
			this._parsingComplete = true;

			this.dispatchEvent(new ParserEvent(ParserEvent.PARSE_COMPLETE));

		}

        /**         *         * @returns {string}         * @private         */
        public function _pGetTextData():String
        {
            return ParserUtil.toString( this._data);
        }

        /**         *         * @returns {string}         * @private         */
        public function _pGetByteData():ByteArray
        {

            return ParserUtil.toByteArray( this._data );

        }

	}

}
