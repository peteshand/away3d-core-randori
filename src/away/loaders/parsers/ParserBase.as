

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
	import randori.webkit.page.Window;

	/**
	public class ParserBase extends EventDispatcher
	{
		public var _iFileName:String; // ARCANE
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

        /* TODO: Implement ParserUtil;
		private var _dependencies:Vector.<ResourceDependency>;//Vector.<ResourceDependency>;
		private var _parsingComplete:Boolean;
		private var _parsingFailure:Boolean;
		private var _timer:Timer;
		private var _materialMode:Number;
		
		/**
		public static var PARSING_DONE:Boolean = true; /* Protected */		
		/**
        public static var MORE_TO_PARSE:Boolean = false; /* Protected */		
		
		/**
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
		
		/**

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
			return _parsingFailure;
		}

		public function get parsingPaused():Boolean
		{
			return _parsingPaused;
		}

		public function get parsingComplete():Boolean
		{
			return _parsingComplete;
		}
		
		public function set materialMode(newMaterialMode:Number):void
		{
            this._materialMode=newMaterialMode;
		}
		
		public function get materialMode():Number
		{
			return _materialMode;
		}

        public function get loaderType():String
        {

            return _loaderType;

        }

        public function set loaderType(value:String):void
        {

            this._loaderType = value;

        }

        public function get data():*
        {

            return _data;

        }

		/**
		public function get dataFormat():String
		{
			return _dataFormat;
		}
		
		/**
		public function parseAsync(data:*, frameLimit:Number = 30):void
		{
            _data = data;
            startParsing(frameLimit);
		}
		
		/**
		public function get dependencies():Vector.<ResourceDependency>
		{
			return _dependencies;
		}
		
		/**
		public function _iResolveDependency(resourceDependency:ResourceDependency):void
		{

            throw new AbstractMethodError();

		}
		
		/**
		public function _iResolveDependencyFailure(resourceDependency:ResourceDependency):void
		{
            throw new AbstractMethodError();
		}

		/**
		public function _iResolveDependencyName(resourceDependency:ResourceDependency, asset:IAsset):String
		{
			return asset.name;
		}
		
		public function _iResumeParsingAfterDependencies():void
		{
			_parsingPaused = false;

			if (_timer){

                _timer.start();

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
			
			dispatchEvent(new AssetEvent(AssetEvent.ASSET_COMPLETE, asset));
            dispatchEvent(new AssetEvent(type_event, asset));
		}
		
		/**
		public function _pProceedParsing():Boolean
		{

            throw new AbstractMethodError();
			return true;
		}

		public function _pDieWithError(message:String = 'Unknown parsing error'):void
		{
            if(_timer)
            {
			    _timer.removeEventListener(TimerEvent.TIMER, _pOnInterval , this );
                _timer.stop();
                _timer = null;
            }

			dispatchEvent(new ParserEvent(ParserEvent.PARSE_ERROR, message));
		}

		public function _pAddDependency(id:String, req:URLRequest, retrieveAsRawData:Boolean = false, data:* = null, suppressErrorEvents:Boolean = false):void
		{

			_dependencies.push(new ResourceDependency(id, req, data, this, retrieveAsRawData, suppressErrorEvents));
		}

		public function _pPauseAndRetrieveDependencies():void
		{
            if(_timer)
            {
                _timer.stop();
            }

			_parsingPaused = true;
			dispatchEvent(new ParserEvent(ParserEvent.READY_FOR_DEPENDENCIES));
		}
		
		/**
		public function _pHasTime():Boolean
		{

			return ((new Date.getTime() - _lastFrameTime) < _frameLimit);

		}
		
		/**
		public function _pOnInterval(event:TimerEvent = null):void
		{
			_lastFrameTime = new Date.getTime();

			if (_pProceedParsing() && !_parsingFailure){

				_pFinishParsing();

            }
		}
		
		/**
		private function startParsing(frameLimit:Number):void
		{

			_frameLimit = frameLimit;
			_timer = new Timer(_frameLimit, 0);
			_timer.addEventListener(TimerEvent.TIMER, _pOnInterval , this );
			_timer.start();

		}

		/**
		public function _pFinishParsing():void
		{

            //console.log( 'ParserBase._pFinishParsing');

            if(_timer)
            {
			    _timer.removeEventListener(TimerEvent.TIMER, _pOnInterval , this );
			    _timer.stop();
            }

			_timer = null;
			_parsingComplete = true;

			dispatchEvent(new ParserEvent(ParserEvent.PARSE_COMPLETE));

		}

        /**
        public function _pGetTextData():String
        {
            return ParserUtil.toString( _data);
        }

	}

}