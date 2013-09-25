/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package away.library
{
	import away.events.EventDispatcher;
	import away.loaders.AssetLoader;
	import away.library.naming.ConflictStrategyBase;
	import away.library.assets.IAsset;
	import away.library.naming.ConflictStrategy;
	import away.library.naming.ConflictPrecedence;
	import away.loaders.misc.SingleFileLoader;
	import away.errors.Error;
	import away.library.utils.AssetLibraryIterator;
	import away.net.URLRequest;
	import away.loaders.misc.AssetLoaderContext;
	import away.loaders.parsers.ParserBase;
	import away.loaders.misc.AssetLoaderToken;
	import away.library.assets.NamedAssetBase;
	import away.library.utils.IDUtil;
	import away.events.AssetEvent;
	import away.events.LoaderEvent;
	import away.events.ParserEvent;
	import randori.webkit.page.Window;

	
	/**	 * AssetLibraryBundle enforces a multiton pattern and is not intended to be instanced directly.	 * Its purpose is to create a container for 3D data management, both before and after parsing.	 * If you are interested in creating multiple library bundles, please use the <code>getInstance()</code> method.	 */
	public class AssetLibraryBundle extends EventDispatcher
	{
		private var _loadingSessions:Vector.<AssetLoader>;//Vector.<AssetLoader>
		private var _strategy:ConflictStrategyBase;
		private var _strategyPreference:String = null;
		private var _assets:Vector.<IAsset>;//Vector.<IAsset>
		private var _assetDictionary:Object;
		private var _assetDictDirty:Boolean = false;
        private var _loadingSessionsGarbage:Vector.<AssetLoader> = new Vector.<AssetLoader>();
        private var _gcTimeoutIID:Number = 0;
		
		/**		 * Creates a new <code>AssetLibraryBundle</code> object.		 *		 * @param me A multiton enforcer for the AssetLibraryBundle ensuring it cannnot be instanced.		 */
		public function AssetLibraryBundle(me:AssetLibraryBundleSingletonEnforcer):void
		{
            super();

			//me = me;
			
			this._assets = new Vector.<IAsset>();//new Vector.<IAsset>;
			this._assetDictionary = new Object();
			this._loadingSessions = new Vector.<AssetLoader>();

			this.conflictStrategy = ConflictStrategy.IGNORE.create();
			this.conflictPrecedence = ConflictPrecedence.FAVOR_NEW;
		}
		
		/**		 * Returns an AssetLibraryBundle instance. If no key is given, returns the default bundle instance (which is		 * similar to using the AssetLibraryBundle as a singleton.) To keep several separated library bundles,		 * pass a string key to this method to define which bundle should be returned. This is		 * referred to as using the AssetLibrary as a multiton.		 *		 * @param key Defines which multiton instance should be returned.		 * @return An instance of the asset library		 */
		public static function getInstance(key:String = 'default'):AssetLibraryBundle
		{
			key = key || 'default';

			if (!key)
            {

                key = 'default';

            }

			
			if (!AssetLibrary._iInstances.hasOwnProperty(key))
            {

                AssetLibrary._iInstances[key] = new AssetLibraryBundle(new AssetLibraryBundleSingletonEnforcer());

            }

			
			return AssetLibrary._iInstances[key];

		}
		
		/**		 *		 */
		public function enableParser(parserClass:Object):void
		{
			SingleFileLoader.enableParser(parserClass);
		}
		
		/**		 *		 */
		public function enableParsers(parserClasses:Vector.<Object>):void
		{
			SingleFileLoader.enableParsers(parserClasses);
		}
		
		/**		 * Defines which strategy should be used for resolving naming conflicts, when two library		 * assets are given the same name. By default, <code>ConflictStrategy.APPEND_NUM_SUFFIX</code>		 * is used which means that a numeric suffix is appended to one of the assets. The		 * <code>conflictPrecedence</code> property defines which of the two conflicting assets will		 * be renamed.		 *		 * @see away3d.library.naming.ConflictStrategy		 * @see away3d.library.AssetLibrary.conflictPrecedence		 */
		public function get conflictStrategy():ConflictStrategyBase
		{
			return this._strategy;
		}
		
		public function set conflictStrategy(val:ConflictStrategyBase):void
		{

			if (!val)
            {

                throw new away.errors.Error('namingStrategy must not be null. To ignore naming, use AssetLibrary.IGNORE');

            }

			this._strategy = val.create();

		}
		
		/**		 * Defines which asset should have precedence when resolving a naming conflict between		 * two assets of which one has just been renamed by the user or by a parser. By default		 * <code>ConflictPrecedence.FAVOR_NEW</code> is used, meaning that the newly renamed		 * asset will keep it's new name while the older asset gets renamed to not conflict.		 *		 * This property is ignored for conflict strategies that do not actually rename an		 * asset automatically, such as ConflictStrategy.IGNORE and ConflictStrategy.THROW_ERROR.		 *		 * @see away3d.library.naming.ConflictPrecedence		 * @see away3d.library.naming.ConflictStrategy		 */
		public function get conflictPrecedence():String
		{
			return this._strategyPreference;
		}
		
		public function set conflictPrecedence(val:String):void
		{
			this._strategyPreference = val;
		}
		
		/**		 * Create an AssetLibraryIterator instance that can be used to iterate over the assets		 * in this asset library instance. The iterator can filter assets on asset type and/or		 * namespace. A "null" filter value means no filter of that type is used.		 *		 * @param assetTypeFilter Asset type to filter on (from the AssetType enum class.) Use		 * null to not filter on asset type.		 * @param namespaceFilter Namespace to filter on. Use null to not filter on namespace.		 * @param filterFunc Callback function to use when deciding whether an asset should be		 * included in the iteration or not. This needs to be a function that takes a single		 * parameter of type IAsset and returns a boolean where true means it should be included.		 *		 * @see away3d.library.assets.AssetType		 */
		public function createIterator(assetTypeFilter:String = null, namespaceFilter:String = null, filterFunc = null):AssetLibraryIterator
		{
			assetTypeFilter = assetTypeFilter || null;
			namespaceFilter = namespaceFilter || null;
			filterFunc = filterFunc || null;

			return new AssetLibraryIterator(this._assets, assetTypeFilter, namespaceFilter, filterFunc);
		}
		
		/**		 * Loads a file and (optionally) all of its dependencies.		 *		 * @param req The URLRequest object containing the URL of the file to be loaded.		 * @param context An optional context object providing additional parameters for loading		 * @param ns An optional namespace string under which the file is to be loaded, allowing the differentiation of two resources with identical assets		 * @param parser An optional parser object for translating the loaded data into a usable resource. If not provided, AssetLoader will attempt to auto-detect the file type.		 */
		public function load(req:URLRequest, context:AssetLoaderContext = null, ns:String = null, parser:ParserBase = null):AssetLoaderToken
		{
			context = context || null;
			ns = ns || null;
			parser = parser || null;

			return this.loadResource(req, context, ns, parser);
		}
		
		/**		 * Loads a resource from existing data in memory.		 *		 * @param data The data object containing all resource information.		 * @param context An optional context object providing additional parameters for loading		 * @param ns An optional namespace string under which the file is to be loaded, allowing the differentiation of two resources with identical assets		 * @param parser An optional parser object for translating the loaded data into a usable resource. If not provided, AssetLoader will attempt to auto-detect the file type.		 */
		public function loadData(data:*, context:AssetLoaderContext = null, ns:String = null, parser:ParserBase = null):AssetLoaderToken
		{
			context = context || null;
			ns = ns || null;
			parser = parser || null;

			return this.parseResource(data, context, ns, parser);
		}
		
		/**		 *		 */
		public function getAsset(name:String, ns:String = null):IAsset
		{
			ns = ns || null;

			//var asset : IAsset;
			
			if (this._assetDictDirty)
            {

                this.rehashAssetDict();

            }

            //ns ||= NamedAssetBase.DEFAULT_NAMESPACE;
            if ( ns == null )
            {

                ns = NamedAssetBase.DEFAULT_NAMESPACE;

            }
			

			if (!this._assetDictionary.hasOwnProperty(ns))
            {

                return null;

            }

			return this._assetDictionary[ns][name];

		}
		
		/**		 * Adds an asset to the asset library, first making sure that it's name is unique		 * using the method defined by the <code>conflictStrategy</code> and		 * <code>conflictPrecedence</code> properties.		 */
		public function addAsset(asset:IAsset):void
		{
			var ns:String;
			var old:IAsset;
			
			// Bail if asset has already been added.
			if (this._assets.indexOf(asset) >= 0)
            {

                return;

            }

			old = this.getAsset(asset.name, asset.assetNamespace);
			ns = asset.assetNamespace || NamedAssetBase.DEFAULT_NAMESPACE;
			
			if (old != null)
            {

                this._strategy.resolveConflict(asset, old, this._assetDictionary[ns], this._strategyPreference);

            }

			//create unique-id (for now this is used in AwayBuilder only
			asset.id = IDUtil.createUID();
			
			// Add it
			this._assets.push(asset);

			if (!this._assetDictionary.hasOwnProperty(ns))
            {

                this._assetDictionary[ns] = new Object();

            }

			this._assetDictionary[ns][asset.name] = asset;
			
			asset.addEventListener(AssetEvent.ASSET_RENAME, onAssetRename , this );
			asset.addEventListener(AssetEvent.ASSET_CONFLICT_RESOLVED, onAssetConflictResolved , this );
		}
		
		/**		 * Removes an asset from the library, and optionally disposes that asset by calling		 * it's disposeAsset() method (which for most assets is implemented as a default		 * version of that type's dispose() method.		 *		 * @param asset The asset which should be removed from this library.		 * @param dispose Defines whether the assets should also be disposed.		 */
		public function removeAsset(asset:IAsset, dispose:Boolean = true):void
		{
			dispose = dispose || true;

			var idx:Number;
			
			this.removeAssetFromDict(asset);
			
			asset.removeEventListener(AssetEvent.ASSET_RENAME, onAssetRename , this );
			asset.removeEventListener(AssetEvent.ASSET_CONFLICT_RESOLVED, onAssetConflictResolved , this );
			
			idx = this._assets.indexOf(asset);
			if (idx >= 0)
            {

                this._assets.splice(idx, 1);

            }

			if (dispose)
            {

                asset.dispose();

            }

		}
		
		/**		 * Removes an asset which is specified using name and namespace.		 *		 * @param name The name of the asset to be removed.		 * @param ns The namespace to which the desired asset belongs.		 * @param dispose Defines whether the assets should also be disposed.		 *		 * @see away3d.library.AssetLibrary.removeAsset()		 */
		public function removeAssetByName(name:String, ns:String = null, dispose:Boolean = true):IAsset
		{
			ns = ns || null;
			dispose = dispose || true;


			var asset:IAsset = this.getAsset(name, ns);

			if (asset)
            {

                this.removeAsset(asset, dispose);

            }

			return asset;
		}
		
		/**		 * Removes all assets from the asset library, optionally disposing them as they		 * are removed.		 *		 * @param dispose Defines whether the assets should also be disposed.		 */
		public function removeAllAssets(dispose:Boolean = true):void
		{
			dispose = dispose || true;

			if (dispose)
            {
				var asset:IAsset;

                for ( var c : Number = 0 ; c < this._assets.length ; c ++ )
                {
                    asset = this._assets[ c ];
                    asset.dispose();

                }
                /*				for each (asset in _assets)					asset.dispose();		        */
			}
			
			this._assets.length = 0;
            this.rehashAssetDict();
		}
		
		/**		 * Removes all assets belonging to a particular namespace (null for default)		 * from the asset library, and optionall disposes them by calling their		 * disposeAsset() method.		 *		 * @param ns The namespace from which all assets should be removed.		 * @param dispose Defines whether the assets should also be disposed.		 *		 * @see away3d.library.AssetLibrary.removeAsset()		 */
		public function removeNamespaceAssets(ns:String = null, dispose:Boolean = true):void
		{
			ns = ns || null;
			dispose = dispose || true;

			var idx:Number = 0;
			var asset:IAsset;
			var old_assets:Vector.<IAsset>;
			
			// Empty the assets vector after having stored a copy of it.
			// The copy will be filled with all assets which weren't removed.
			old_assets = this._assets.concat();
			this._assets.length = 0;

            if ( ns == null )
            {

                ns = NamedAssetBase.DEFAULT_NAMESPACE;//ns ||= NamedAssetBase.DEFAULT_NAMESPACE;

            }

            for ( var d : Number = 0 ; d < old_assets.length ; d ++ )
            {
                asset = old_assets[d];

                // Remove from dict if in the supplied namespace. If not,
                // transfer over to the new vector.
                if (asset.assetNamespace == ns)
                {
                    if (dispose)
                    {

                        asset.dispose();

                    }

                    // Remove asset from dictionary, but don't try to auto-remove
                    // the namespace, which will trigger an unnecessarily expensive
                    // test that is not needed since we know that the namespace
                    // will be empty when loop finishes.
                    this.removeAssetFromDict(asset, false);
                }
                else
                {

                    this._assets[idx++] = asset;

                }


            }

            /*			for each (asset in old_assets) {				// Remove from dict if in the supplied namespace. If not,				// transfer over to the new vector.				if (asset.assetNamespace == ns) {					if (dispose)						asset.dispose();										// Remove asset from dictionary, but don't try to auto-remove					// the namespace, which will trigger an unnecessarily expensive					// test that is not needed since we know that the namespace					// will be empty when loop finishes.					removeAssetFromDict(asset, false);				} else					_assets[idx++] = asset;			}             */
			
			// Remove empty namespace
			if (this._assetDictionary.hasOwnProperty(ns))
            {

                delete this._assetDictionary[ns];

            }

		}
		
		private function removeAssetFromDict(asset:IAsset, autoRemoveEmptyNamespace:Boolean = true):void
		{
			autoRemoveEmptyNamespace = autoRemoveEmptyNamespace || true;

			if (this._assetDictDirty)
            {
                this.rehashAssetDict();
            }

			
			if (this._assetDictionary.hasOwnProperty(asset.assetNamespace))
            {
				if (this._assetDictionary[asset.assetNamespace].hasOwnProperty(asset.name))
                {
                    delete this._assetDictionary[asset.assetNamespace][asset.name];
                }

				
				if (autoRemoveEmptyNamespace) {

					var key:String;
					var empty:Boolean = true;
					
					for (key in this._assetDictionary[asset.assetNamespace]) {
						empty = false;
						break;
					}
					
					if (empty)
                    {

                        delete this._assetDictionary[asset.assetNamespace];

                    }

				}
			}
		}
		
		/**		 * Loads a yet unloaded resource file from the given url.		 */
		private function loadResource(req:URLRequest, context:AssetLoaderContext = null, ns:String = null, parser:ParserBase = null):AssetLoaderToken
		{
			context = context || null;
			ns = ns || null;
			parser = parser || null;

			var loader:AssetLoader = new AssetLoader();

			if (!this._loadingSessions)
            {

                this._loadingSessions = new Vector.<AssetLoader>();

            }

			this._loadingSessions.push(loader);

			loader.addEventListener(LoaderEvent.RESOURCE_COMPLETE, onResourceRetrieved , this);
			loader.addEventListener(LoaderEvent.DEPENDENCY_COMPLETE, onDependencyRetrieved, this);
			loader.addEventListener(AssetEvent.TEXTURE_SIZE_ERROR, onTextureSizeError, this);
			loader.addEventListener(AssetEvent.ASSET_COMPLETE, onAssetComplete, this);
			loader.addEventListener(AssetEvent.ANIMATION_SET_COMPLETE, onAssetComplete, this);
			loader.addEventListener(AssetEvent.ANIMATION_STATE_COMPLETE, onAssetComplete, this);
			loader.addEventListener(AssetEvent.ANIMATION_NODE_COMPLETE, onAssetComplete, this);
			loader.addEventListener(AssetEvent.STATE_TRANSITION_COMPLETE, onAssetComplete, this);
			loader.addEventListener(AssetEvent.TEXTURE_COMPLETE, onAssetComplete, this);
			loader.addEventListener(AssetEvent.CONTAINER_COMPLETE, onAssetComplete, this);
			loader.addEventListener(AssetEvent.GEOMETRY_COMPLETE, onAssetComplete, this);
			loader.addEventListener(AssetEvent.MATERIAL_COMPLETE, onAssetComplete, this);
			loader.addEventListener(AssetEvent.MESH_COMPLETE, onAssetComplete, this);
			loader.addEventListener(AssetEvent.ENTITY_COMPLETE, onAssetComplete, this);
			loader.addEventListener(AssetEvent.SKELETON_COMPLETE, onAssetComplete, this);
			loader.addEventListener(AssetEvent.SKELETON_POSE_COMPLETE, onAssetComplete, this);

			// Error are handled separately (see documentation for addErrorHandler)
			loader._iAddErrorHandler(onDependencyRetrievingError);
			loader._iAddParseErrorHandler(onDependencyRetrievingParseError);
			
			return loader.load(req, context, ns, parser);
		}
		
		public function stopAllLoadingSessions():void
		{
			var i:Number;

			if (! this._loadingSessions )
            {

                this._loadingSessions = new Vector.<AssetLoader>();

            }

			var length:Number = this._loadingSessions.length;

			for (i = 0; i < length; i++)
            {

                this.killLoadingSession(this._loadingSessions[i]);

            }

			this._loadingSessions = null;
		}
		
		/**		 * Retrieves an unloaded resource parsed from the given data.		 * @param data The data to be parsed.		 * @param id The id that will be assigned to the resource. This can later also be used by the getResource method.		 * @param ignoreDependencies Indicates whether or not dependencies should be ignored or loaded.		 * @param parser An optional parser object that will translate the data into a usable resource.		 * @return A handle to the retrieved resource.		 */
		private function parseResource(data:*, context:AssetLoaderContext = null, ns:String = null, parser:ParserBase = null):AssetLoaderToken
		{
			context = context || null;
			ns = ns || null;
			parser = parser || null;

			var loader:AssetLoader = new AssetLoader();

			if (!this._loadingSessions)
            {

                this._loadingSessions = new Vector.<AssetLoader>();

            }

			this._loadingSessions.push(loader);

			loader.addEventListener(LoaderEvent.RESOURCE_COMPLETE, onResourceRetrieved , this);
			loader.addEventListener(LoaderEvent.DEPENDENCY_COMPLETE, onDependencyRetrieved, this);
			loader.addEventListener(AssetEvent.TEXTURE_SIZE_ERROR, onTextureSizeError, this);
			loader.addEventListener(AssetEvent.ASSET_COMPLETE, onAssetComplete, this);
			loader.addEventListener(AssetEvent.ANIMATION_SET_COMPLETE, onAssetComplete, this);
			loader.addEventListener(AssetEvent.ANIMATION_STATE_COMPLETE, onAssetComplete, this);
			loader.addEventListener(AssetEvent.ANIMATION_NODE_COMPLETE, onAssetComplete, this);
			loader.addEventListener(AssetEvent.STATE_TRANSITION_COMPLETE, onAssetComplete, this);
			loader.addEventListener(AssetEvent.TEXTURE_COMPLETE, onAssetComplete, this);
			loader.addEventListener(AssetEvent.CONTAINER_COMPLETE, onAssetComplete, this);
			loader.addEventListener(AssetEvent.GEOMETRY_COMPLETE, onAssetComplete, this);
			loader.addEventListener(AssetEvent.MATERIAL_COMPLETE, onAssetComplete, this);
			loader.addEventListener(AssetEvent.MESH_COMPLETE, onAssetComplete, this);
			loader.addEventListener(AssetEvent.ENTITY_COMPLETE, onAssetComplete, this);
			loader.addEventListener(AssetEvent.SKELETON_COMPLETE, onAssetComplete, this);
			loader.addEventListener(AssetEvent.SKELETON_POSE_COMPLETE, onAssetComplete, this);
			
			// Error are handled separately (see documentation for addErrorHandler)
			loader._iAddErrorHandler(onDependencyRetrievingError);
			loader._iAddParseErrorHandler(onDependencyRetrievingParseError);
			
			return loader.loadData(data, '', context, ns, parser);
		}
		
		private function rehashAssetDict():void
		{
			var asset:IAsset;
			
			this._assetDictionary = {};

            var l : Number = this._assets.length;

            for ( var c : Number = 0 ; c < l ; c ++)
            {

                asset = this._assets[c];

				if (!this._assetDictionary.hasOwnProperty(asset.assetNamespace))
                {

                    this._assetDictionary[asset.assetNamespace] = {};

                }

				this._assetDictionary[asset.assetNamespace][asset.name] = asset;

			}

			this._assetDictDirty = false;

		}
		
		/**		 * Called when a dependency was retrieved.		 */
		private function onDependencyRetrieved(event:LoaderEvent):void
		{
			//if (hasEventListener(LoaderEvent.DEPENDENCY_COMPLETE))
			this.dispatchEvent(event);

		}
		
		/**		 * Called when a an error occurs during dependency retrieving.		 */
		private function onDependencyRetrievingError(event:LoaderEvent):Boolean
		{
			if (this.hasEventListener(LoaderEvent.LOAD_ERROR , onDependencyRetrievingError , this ) )
            {

				this.dispatchEvent(event);
				return true;

			}
            else
            {

                return false;

            }

		}
		
		/**		 * Called when a an error occurs during parsing.		 */
		private function onDependencyRetrievingParseError(event:ParserEvent):Boolean
		{
			if (this.hasEventListener(ParserEvent.PARSE_ERROR, onDependencyRetrievingParseError, this ))
            {

				this.dispatchEvent(event);
				return true;

			}
            else
            {

                return false;

            }

		}
		
		private function onAssetComplete(event:AssetEvent):void
		{

            //console.log( 'AssetLibraryBundle.onAssetComplete ' , event );

			// Only add asset to library the first time.
			if (event.type == AssetEvent.ASSET_COMPLETE)
            {

                this.addAsset(event.asset);

            }

			this.dispatchEvent(event.clone());

		}
		
		private function onTextureSizeError(event:AssetEvent):void
		{
			this.dispatchEvent(event.clone());
		}
		
		/**		 * Called when the resource and all of its dependencies was retrieved.		 */
		private function onResourceRetrieved(event:LoaderEvent):void
		{

			var loader:AssetLoader = (event.target as AssetLoader);

			this.dispatchEvent(event.clone());

            var index:Number = this._loadingSessions.indexOf(loader);
            this._loadingSessions.splice(index, 1);

            // Add loader to a garbage array - for a collection sweep and kill
            this._loadingSessionsGarbage.push( loader );
            this._gcTimeoutIID = Window.setTimeout( loadingSessionGC  , 100 );

		}

        private function loadingSessionGC():void
        {

            var loader  : AssetLoader;

            while( this._loadingSessionsGarbage.length > 0 )
            {

                loader = this._loadingSessionsGarbage.pop();
                this.killLoadingSession( loader );

            }

            Window.clearTimeout(this._gcTimeoutIID);
            this._gcTimeoutIID = null;

        }

		private function killLoadingSession(loader:AssetLoader):void
		{
			
			loader.removeEventListener(LoaderEvent.LOAD_ERROR, onDependencyRetrievingError , this);
			loader.removeEventListener(LoaderEvent.RESOURCE_COMPLETE, onResourceRetrieved, this);
			loader.removeEventListener(LoaderEvent.DEPENDENCY_COMPLETE, onDependencyRetrieved, this);
			loader.removeEventListener(AssetEvent.TEXTURE_SIZE_ERROR, onTextureSizeError, this);
			loader.removeEventListener(AssetEvent.ASSET_COMPLETE, onAssetComplete, this);
			loader.removeEventListener(AssetEvent.ANIMATION_SET_COMPLETE, onAssetComplete, this);
			loader.removeEventListener(AssetEvent.ANIMATION_STATE_COMPLETE, onAssetComplete, this);
			loader.removeEventListener(AssetEvent.ANIMATION_NODE_COMPLETE, onAssetComplete, this);
			loader.removeEventListener(AssetEvent.STATE_TRANSITION_COMPLETE, onAssetComplete, this);
			loader.removeEventListener(AssetEvent.TEXTURE_COMPLETE, onAssetComplete, this);
			loader.removeEventListener(AssetEvent.CONTAINER_COMPLETE, onAssetComplete, this);
			loader.removeEventListener(AssetEvent.GEOMETRY_COMPLETE, onAssetComplete, this);
			loader.removeEventListener(AssetEvent.MATERIAL_COMPLETE, onAssetComplete, this);
			loader.removeEventListener(AssetEvent.MESH_COMPLETE, onAssetComplete, this);
			loader.removeEventListener(AssetEvent.ENTITY_COMPLETE, onAssetComplete, this);
			loader.removeEventListener(AssetEvent.SKELETON_COMPLETE, onAssetComplete, this);
			loader.removeEventListener(AssetEvent.SKELETON_POSE_COMPLETE, onAssetComplete, this);
			loader.stop();
		
		}
		
		/**		 * Called when unespected error occurs		 */
		/*		 private onResourceError() : void		 {		 var msg:string = "Unexpected parser error";		 if(hasEventListener(LoaderEvent.DEPENDENCY_ERROR)){		 var re:LoaderEvent = new LoaderEvent(LoaderEvent.DEPENDENCY_ERROR, "");		 dispatchEvent(re);		 } else{		 throw new Error(msg);		 }		 }		 */
		
		private function onAssetRename(ev:AssetEvent):void
		{
			var asset:IAsset = (ev.target as IAsset);// TODO: was ev.currentTarget - watch this var
			var old:IAsset  = this.getAsset(asset.assetNamespace, asset.name);
			
			if (old != null)
            {

                this._strategy.resolveConflict(asset, old, this._assetDictionary[asset.assetNamespace], this._strategyPreference);

            }
			else
            {
				var dict:Object = this._assetDictionary[ev.asset.assetNamespace];

				if (dict == null)
                {

                    return;

                }

				
				dict[ev.assetPrevName] = null;
				dict[ev.asset.name] = ev.asset;

			}
		}
		
		private function onAssetConflictResolved(ev:AssetEvent):void
		{
			this.dispatchEvent(ev.clone());
		}

	}
}
// singleton enforcer
