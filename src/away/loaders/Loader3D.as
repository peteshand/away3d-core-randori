/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package away.loaders
{
	import away.containers.ObjectContainer3D;
	import away.core.net.URLRequest;
	import away.loaders.misc.AssetLoaderContext;
	import away.loaders.parsers.ParserBase;
	import away.loaders.misc.AssetLoaderToken;
	import away.library.AssetLibraryBundle;
	import away.events.LoaderEvent;
	import away.events.AssetEvent;
	import away.loaders.misc.SingleFileLoader;
	import away.events.EventDispatcher;
	import away.library.assets.AssetType;
	import away.lights.LightBase;
	import away.entities.Mesh;
	import away.cameras.Camera3D;
	import away.entities.SegmentSet;
	import away.events.ParserEvent;

    /**     * Dispatched when any asset finishes parsing. Also see specific events for each     * individual asset type (meshes, materials et c.)     *     * @eventType away3d.events.AssetEvent     */
    //[Event(name="assetComplete", type="away3d.events.AssetEvent")]


    /**     * Dispatched when a full resource (including dependencies) finishes loading.     *     * @eventType away3d.events.LoaderEvent     */
    //[Event(name="resourceComplete", type="away3d.events.LoaderEvent")]


    /**     * Dispatched when a single dependency (which may be the main file of a resource)     * finishes loading.     *     * @eventType away3d.events.LoaderEvent     */
    //[Event(name="dependencyComplete", type="away3d.events.LoaderEvent")]


    /**     * Dispatched when an error occurs during loading. I     *     * @eventType away3d.events.LoaderEvent     */
    //[Event(name="loadError", type="away3d.events.LoaderEvent")]


    /**     * Dispatched when an error occurs during parsing.     *     * @eventType away3d.events.ParserEvent     */
    //[Event(name="parseError", type="away3d.events.ParserEvent")]


    /**     * Dispatched when a skybox asset has been costructed from a ressource.     *     * @eventType away3d.events.AssetEvent     */
    //[Event(name="skyboxComplete", type="away3d.events.AssetEvent")]

    /**     * Dispatched when a camera3d asset has been costructed from a ressource.     *     * @eventType away3d.events.AssetEvent     */
    //[Event(name="cameraComplete", type="away3d.events.AssetEvent")]

    /**     * Dispatched when a mesh asset has been costructed from a ressource.     *     * @eventType away3d.events.AssetEvent     */
    //[Event(name="meshComplete", type="away3d.events.AssetEvent")]

    /**     * Dispatched when a geometry asset has been constructed from a resource.     *     * @eventType away3d.events.AssetEvent     */
    //[Event(name="geometryComplete", type="away3d.events.AssetEvent")]

    /**     * Dispatched when a skeleton asset has been constructed from a resource.     *     * @eventType away3d.events.AssetEvent     */
    //[Event(name="skeletonComplete", type="away3d.events.AssetEvent")]

    /**     * Dispatched when a skeleton pose asset has been constructed from a resource.     *     * @eventType away3d.events.AssetEvent     */
    //[Event(name="skeletonPoseComplete", type="away3d.events.AssetEvent")]

    /**     * Dispatched when a container asset has been constructed from a resource.     *     * @eventType away3d.events.AssetEvent     */
    //[Event(name="containerComplete", type="away3d.events.AssetEvent")]

    /**     * Dispatched when a texture asset has been constructed from a resource.     *     * @eventType away3d.events.AssetEvent     */
    //[Event(name="textureComplete", type="away3d.events.AssetEvent")]

    /**     * Dispatched when a texture projector asset has been constructed from a resource.     *     * @eventType away3d.events.AssetEvent     */
    //[Event(name="textureProjectorComplete", type="away3d.events.AssetEvent")]


    /**     * Dispatched when a material asset has been constructed from a resource.     *     * @eventType away3d.events.AssetEvent     */
    //[Event(name="materialComplete", type="away3d.events.AssetEvent")]


    /**     * Dispatched when a animator asset has been constructed from a resource.     *     * @eventType away3d.events.AssetEvent     */
    //[Event(name="animatorComplete", type="away3d.events.AssetEvent")]


    /**     * Dispatched when an animation set has been constructed from a group of animation state resources.     *     * @eventType away3d.events.AssetEvent     */
    //[Event(name="animationSetComplete", type="away3d.events.AssetEvent")]


    /**     * Dispatched when an animation state has been constructed from a group of animation node resources.     *     * @eventType away3d.events.AssetEvent     */
    //[Event(name="animationStateComplete", type="away3d.events.AssetEvent")]


    /**     * Dispatched when an animation node has been constructed from a resource.     *     * @eventType away3d.events.AssetEvent     */
    //[Event(name="animationNodeComplete", type="away3d.events.AssetEvent")]


    /**     * Dispatched when an animation state transition has been constructed from a group of animation node resources.     *     * @eventType away3d.events.AssetEvent     */
    //[Event(name="stateTransitionComplete", type="away3d.events.AssetEvent")]


    /**     * Dispatched when an light asset has been constructed from a resources.     *     * @eventType away3d.events.AssetEvent     */
    //[Event(name="lightComplete", type="away3d.events.AssetEvent")]


    /**     * Dispatched when an light picker asset has been constructed from a resources.     *     * @eventType away3d.events.AssetEvent     */
    //[Event(name="lightPickerComplete", type="away3d.events.AssetEvent")]


    /**     * Dispatched when an effect method asset has been constructed from a resources.     *     * @eventType away3d.events.AssetEvent     */
    //[Event(name="effectMethodComplete", type="away3d.events.AssetEvent")]


    /**     * Dispatched when an shadow map method asset has been constructed from a resources.     *     * @eventType away3d.events.AssetEvent     */
    //[Event(name="shadowMapMethodComplete", type="away3d.events.AssetEvent")]

    /**     * Dispatched when an image asset dimensions are not a power of 2     *     * @eventType away3d.events.AssetEvent     */
    //[Event(name="textureSizeError", type="away3d.events.AssetEvent")]

    /**     * Loader3D can load any file format that Away3D supports (or for which a third-party parser     * has been plugged in) and be added directly to the scene. As assets are encountered     * they are added to the Loader3D container. Assets that can not be displayed in the scene     * graph (e.g. unused bitmaps/materials/skeletons etc) will be ignored.     *     * This provides a fast and easy way to load models (no need for event listeners) but is not     * very versatile since many types of assets are ignored.     *     * Loader3D by default uses the AssetLibrary to load all assets, which means that they also     * ends up in the library. To circumvent this, Loader3D can be configured to not use the     * AssetLibrary in which case it will use the AssetLoader directly.     *     * @see away3d.loaders.AssetLoader     * @see away3d.library.AssetLibrary     */
    public class Loader3D extends ObjectContainer3D
    {
        private var _loadingSessions:Vector.<AssetLoader>;
        private var _useAssetLib:Boolean = false;
        private var _assetLibId:String = null;

        public function Loader3D(useAssetLibrary:Boolean = true, assetLibraryId:String = null):void
        {
			assetLibraryId = assetLibraryId || null;

            super();

            this._loadingSessions = new Vector.<AssetLoader>();
            this._useAssetLib = useAssetLibrary;
            this._assetLibId = assetLibraryId;
        }

        /**         * Loads a file and (optionally) all of its dependencies.         *         * @param req The URLRequest object containing the URL of the file to be loaded.         * @param context An optional context object providing additional parameters for loading         * @param ns An optional namespace string under which the file is to be loaded, allowing the differentiation of two resources with identical assets         * @param parser An optional parser object for translating the loaded data into a usable resource. If not provided, AssetLoader will attempt to auto-detect the file type.         */
        public function load(req:URLRequest, context:AssetLoaderContext = null, ns:String = null, parser:ParserBase = null):AssetLoaderToken
        {
			context = context || null;
			ns = ns || null;
			parser = parser || null;

            var token:AssetLoaderToken;

            if (this._useAssetLib) {
                var lib:AssetLibraryBundle;
                lib = AssetLibraryBundle.getInstance(this._assetLibId);
                token = lib.load(req, context, ns, parser);
            } else {
                var loader:AssetLoader = new AssetLoader();
                this._loadingSessions.push(loader);
                token = loader.load(req, context, ns, parser);
            }

            token.addEventListener(LoaderEvent.RESOURCE_COMPLETE, onResourceRetrieved, this);
            token.addEventListener(AssetEvent.ASSET_COMPLETE, onAssetComplete, this);
            token.addEventListener(AssetEvent.ANIMATION_SET_COMPLETE, onAssetComplete, this);
            token.addEventListener(AssetEvent.ANIMATION_STATE_COMPLETE, onAssetComplete, this);
            token.addEventListener(AssetEvent.ANIMATION_NODE_COMPLETE, onAssetComplete, this);
            token.addEventListener(AssetEvent.STATE_TRANSITION_COMPLETE, onAssetComplete, this);
            token.addEventListener(AssetEvent.TEXTURE_COMPLETE, onAssetComplete, this);
            token.addEventListener(AssetEvent.CONTAINER_COMPLETE, onAssetComplete, this);
            token.addEventListener(AssetEvent.GEOMETRY_COMPLETE, onAssetComplete, this);
            token.addEventListener(AssetEvent.MATERIAL_COMPLETE, onAssetComplete, this);
            token.addEventListener(AssetEvent.MESH_COMPLETE, onAssetComplete, this);
            token.addEventListener(AssetEvent.ENTITY_COMPLETE, onAssetComplete, this);
            token.addEventListener(AssetEvent.SKELETON_COMPLETE, onAssetComplete, this);
            token.addEventListener(AssetEvent.SKELETON_POSE_COMPLETE, onAssetComplete, this);

            // Error are handled separately (see documentation for addErrorHandler)
            token._iLoader._iAddErrorHandler(onDependencyRetrievingError);
            token._iLoader._iAddParseErrorHandler(onDependencyRetrievingParseError);

            return token;
        }

        /**         * Loads a resource from already loaded data.         *         * @param data The data object containing all resource information.         * @param context An optional context object providing additional parameters for loading         * @param ns An optional namespace string under which the file is to be loaded, allowing the differentiation of two resources with identical assets         * @param parser An optional parser object for translating the loaded data into a usable resource. If not provided, AssetLoader will attempt to auto-detect the file type.         */
        public function loadData(data:*, context:AssetLoaderContext = null, ns:String = null, parser:ParserBase = null):AssetLoaderToken
        {
			context = context || null;
			ns = ns || null;
			parser = parser || null;

            var token:AssetLoaderToken;

            if (this._useAssetLib) {
                var lib:AssetLibraryBundle;
                lib = AssetLibraryBundle.getInstance(this._assetLibId);
                token = lib.loadData(data, context, ns, parser);
            } else {
                var loader:AssetLoader = new AssetLoader();
                this._loadingSessions.push(loader);
                token = loader.loadData(data, '', context, ns, parser);
            }

            token.addEventListener(LoaderEvent.RESOURCE_COMPLETE, onResourceRetrieved, this);
            token.addEventListener(AssetEvent.ASSET_COMPLETE, onAssetComplete, this);
            token.addEventListener(AssetEvent.ANIMATION_SET_COMPLETE, onAssetComplete, this);
            token.addEventListener(AssetEvent.ANIMATION_STATE_COMPLETE, onAssetComplete, this);
            token.addEventListener(AssetEvent.ANIMATION_NODE_COMPLETE, onAssetComplete, this);
            token.addEventListener(AssetEvent.STATE_TRANSITION_COMPLETE, onAssetComplete, this);
            token.addEventListener(AssetEvent.TEXTURE_COMPLETE, onAssetComplete, this);
            token.addEventListener(AssetEvent.CONTAINER_COMPLETE, onAssetComplete, this);
            token.addEventListener(AssetEvent.GEOMETRY_COMPLETE, onAssetComplete, this);
            token.addEventListener(AssetEvent.MATERIAL_COMPLETE, onAssetComplete, this);
            token.addEventListener(AssetEvent.MESH_COMPLETE, onAssetComplete, this);
            token.addEventListener(AssetEvent.ENTITY_COMPLETE, onAssetComplete, this);
            token.addEventListener(AssetEvent.SKELETON_COMPLETE, onAssetComplete, this);
            token.addEventListener(AssetEvent.SKELETON_POSE_COMPLETE, onAssetComplete, this);

            // Error are handled separately (see documentation for addErrorHandler)
            token._iLoader._iAddErrorHandler(onDependencyRetrievingError);
            token._iLoader._iAddParseErrorHandler(onDependencyRetrievingParseError);

            return token;
        }

        /**         * Stop the current loading/parsing process.         */
        public function stopLoad():void
        {
            if (this._useAssetLib) {
                var lib:AssetLibraryBundle;
                lib = AssetLibraryBundle.getInstance(this._assetLibId);
                lib.stopAllLoadingSessions();
                this._loadingSessions = null;
                return
            }
            var i:Number /*int*/;
            var length:Number /*int*/ = this._loadingSessions.length;
            for (i = 0; i < length; i++) {
                this.removeListeners(this._loadingSessions[i]);
                this._loadingSessions[i].stop();
                this._loadingSessions[i] = null;
            }
            this._loadingSessions = null;
        }

        /**         * Enables a specific parser.         * When no specific parser is set for a loading/parsing opperation,         * loader3d can autoselect the correct parser to use.         * A parser must have been enabled, to be considered when autoselecting the parser.         *         * @param parserClass The parser class to enable.         * @see away3d.loaders.parsers.Parsers         */
        public static function enableParser(parserClass:Object):void
        {
            SingleFileLoader.enableParser(parserClass);
        }

        /**         * Enables a list of parsers.         * When no specific parser is set for a loading/parsing opperation,         * loader3d can autoselect the correct parser to use.         * A parser must have been enabled, to be considered when autoselecting the parser.         *         * @param parserClasses A Vector of parser classes to enable.         * @see away3d.loaders.parsers.Parsers         */
        public static function enableParsers(parserClasses:Vector.<Object>):void
        {
                SingleFileLoader.enableParsers(parserClasses);
        }

        private function removeListeners(dispatcher:EventDispatcher):void
        {
            dispatcher.removeEventListener(LoaderEvent.RESOURCE_COMPLETE, onResourceRetrieved, this);
            dispatcher.removeEventListener(AssetEvent.ASSET_COMPLETE, onAssetComplete, this);
            dispatcher.removeEventListener(AssetEvent.ANIMATION_SET_COMPLETE, onAssetComplete, this);
            dispatcher.removeEventListener(AssetEvent.ANIMATION_STATE_COMPLETE, onAssetComplete, this);
            dispatcher.removeEventListener(AssetEvent.ANIMATION_NODE_COMPLETE, onAssetComplete, this);
            dispatcher.removeEventListener(AssetEvent.STATE_TRANSITION_COMPLETE, onAssetComplete, this);
            dispatcher.removeEventListener(AssetEvent.TEXTURE_COMPLETE, onAssetComplete, this);
            dispatcher.removeEventListener(AssetEvent.CONTAINER_COMPLETE, onAssetComplete, this);
            dispatcher.removeEventListener(AssetEvent.GEOMETRY_COMPLETE, onAssetComplete, this);
            dispatcher.removeEventListener(AssetEvent.MATERIAL_COMPLETE, onAssetComplete, this);
            dispatcher.removeEventListener(AssetEvent.MESH_COMPLETE, onAssetComplete, this);
            dispatcher.removeEventListener(AssetEvent.ENTITY_COMPLETE, onAssetComplete, this);
            dispatcher.removeEventListener(AssetEvent.SKELETON_COMPLETE, onAssetComplete, this);
            dispatcher.removeEventListener(AssetEvent.SKELETON_POSE_COMPLETE, onAssetComplete, this);
        }

        private function onAssetComplete(ev:AssetEvent):void
        {
            if (ev.type == AssetEvent.ASSET_COMPLETE) {
                // TODO: not used
                // var type : string = ev.asset.assetType;
                var obj:ObjectContainer3D;
                switch (ev.asset.assetType) {
                    case AssetType.LIGHT:
                        obj = (ev.asset as LightBase);
                        break;
                    case AssetType.CONTAINER:
                        obj = (ev.asset as ObjectContainer3D);
                        break;
                    case AssetType.MESH:
                        obj = (ev.asset as Mesh);
                        break;
                    //case away.library.AssetType.SKYBOX:
                    //    obj = <away.entities.SkyBox> ev.asset;
                        break;
                    //case away.library.AssetType.TEXTURE_PROJECTOR:
                    //    obj = <away.entities.TextureProjector> ev.asset;
                        break;
                    case AssetType.CAMERA:
                        obj = (ev.asset as Camera3D);
                        break;
                    case AssetType.SEGMENT_SET:
                        obj = (ev.asset as SegmentSet);
                        break;
                }

                // If asset was of fitting type, and doesn't
                // already have a parent, add to loader container
                if (obj && obj.parent == null)
                    this.addChild(obj);
            }

            this.dispatchEvent(ev.clone());
        }

        /**         * Called when a an error occurs during dependency retrieving.         */
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

        /**         * Called when a an error occurs during parsing.         */
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

        /**         * Called when the resource and all of its dependencies was retrieved.         */
        private function onResourceRetrieved(event:LoaderEvent):void
        {

            var loader:AssetLoader = (event.target as AssetLoader);

            this.dispatchEvent(event.clone());

        }
    }
}
