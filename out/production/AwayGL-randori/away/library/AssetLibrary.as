/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package away.library
{
	import away.loaders.misc.SingleFileLoader;
	import away.library.naming.ConflictStrategyBase;
	import away.library.utils.AssetLibraryIterator;
	import away.core.net.URLRequest;
	import away.loaders.misc.AssetLoaderContext;
	import away.loaders.parsers.ParserBase;
	import away.loaders.misc.AssetLoaderToken;
	import away.library.assets.IAsset;

	/**	 * AssetLibrary enforces a singleton pattern and is not intended to be instanced.	 * It's purpose is to allow access to the default library bundle through a set of static shortcut methods.	 * If you are interested in creating multiple library bundles, please use the <code>getBundle()</code> method.	 */
	public class AssetLibrary
	{
		public static var _iInstances:Object = {};
		
		/**		 * Creates a new <code>AssetLibrary</code> object.		 *		 * @param se A singleton enforcer for the AssetLibrary ensuring it cannnot be instanced.		 */
        //*
		public function AssetLibrary(se:AssetLibrarySingletonEnforcer):void
		{
			se = se;
		}
		//*/
		/**		 * Returns an AssetLibrary bundle instance. If no key is given, returns the default bundle (which is		 * similar to using the AssetLibraryBundle as a singleton). To keep several separated library bundles,		 * pass a string key to this method to define which bundle should be returned. This is		 * referred to as using the AssetLibraryBundle as a multiton.		 *		 * @param key Defines which multiton instance should be returned.		 * @return An instance of the asset library		 */
		public static function getBundle(key:String = 'default'):AssetLibraryBundle
		{
			key = key || 'default';

			return AssetLibraryBundle.getInstance(key);
		}
		
		/**		 *		 */
		public static function enableParser(parserClass):void
		{
			SingleFileLoader.enableParser(parserClass);
		}
		
		/**		 *		 */
		public static function enableParsers(parserClasses:Vector.<Object>):void
		{
            SingleFileLoader.enableParsers(parserClasses);
		}
		
		/**		 * Short-hand for conflictStrategy property on default asset library bundle.		 *		 * @see away3d.library.AssetLibraryBundle.conflictStrategy		 */
		public static function get conflictStrategy():ConflictStrategyBase
		{
			return AssetLibrary.getBundle().conflictStrategy;
		}
		
		public static function set conflictStrategy(val:ConflictStrategyBase):void
		{
            AssetLibrary.getBundle().conflictStrategy = val;
		}
		
		/**		 * Short-hand for conflictPrecedence property on default asset library bundle.		 *		 * @see away3d.library.AssetLibraryBundle.conflictPrecedence		 */
		public static function get conflictPrecedence():String
		{
			return AssetLibrary.getBundle().conflictPrecedence;
		}
		
		public static function set conflictPrecedence(val:String):void
		{
            AssetLibrary.getBundle().conflictPrecedence = val;
		}
		
		/**		 * Short-hand for createIterator() method on default asset library bundle.		 *		 * @see away3d.library.AssetLibraryBundle.createIterator()		 */
		public static function createIterator(assetTypeFilter:String = null, namespaceFilter:String = null, filterFunc = null):AssetLibraryIterator
		{
			assetTypeFilter = assetTypeFilter || null;
			namespaceFilter = namespaceFilter || null;
			filterFunc = filterFunc || null;

			return AssetLibrary.getBundle().createIterator(assetTypeFilter, namespaceFilter, filterFunc);
		}
		
		/**		 * Short-hand for load() method on default asset library bundle.		 *		 * @see away3d.library.AssetLibraryBundle.load()		 */
		public static function load(req:URLRequest, context:AssetLoaderContext = null, ns:String = null, parser:ParserBase = null):AssetLoaderToken
		{
			context = context || null;
			ns = ns || null;
			parser = parser || null;

			return AssetLibrary.getBundle().load(req, context, ns, parser);
		}
		
		/**		 * Short-hand for loadData() method on default asset library bundle.		 *		 * @see away3d.library.AssetLibraryBundle.loadData()		 */
		public static function loadData(data:*, context:AssetLoaderContext = null, ns:String = null, parser:ParserBase = null):AssetLoaderToken
		{
			context = context || null;
			ns = ns || null;
			parser = parser || null;

			return AssetLibrary.getBundle().loadData(data, context, ns, parser);
		}
		
		public static function stopLoad():void
		{
            AssetLibrary.getBundle().stopAllLoadingSessions();
		}
		
		/**		 * Short-hand for getAsset() method on default asset library bundle.		 *		 * @see away3d.library.AssetLibraryBundle.getAsset()		 */
		public static function getAsset(name:String, ns:String = null):IAsset
		{
			ns = ns || null;

			return AssetLibrary.getBundle().getAsset(name, ns);
		}
		
		/**		 * Short-hand for addEventListener() method on default asset library bundle.		 */
		public static function addEventListener(type:String, listener:Function, target:Object):void
		{
            AssetLibrary.getBundle().addEventListener(type, listener, target );
		}
		
		/**		 * Short-hand for removeEventListener() method on default asset library bundle.		 */
		public static function removeEventListener(type:String, listener:Function, target:Object):void
		{
            AssetLibrary.getBundle().removeEventListener(type , listener , target );
		}
		
		/**		 * Short-hand for hasEventListener() method on default asset library bundle.		public static hasEventListener(type:string):boolean		{			return away.library.AssetLibrary.getBundle().hasEventListener(type);		}		public static willTrigger(type:string):boolean		{			return getBundle().willTrigger(type);		}        */

		/**		 * Short-hand for addAsset() method on default asset library bundle.		 *		 * @see away3d.library.AssetLibraryBundle.addAsset()		 */
		public static function addAsset(asset:IAsset):void
		{
			AssetLibrary.getBundle().addAsset(asset);
		}
		
		/**		 * Short-hand for removeAsset() method on default asset library bundle.		 *		 * @param asset The asset which should be removed from the library.		 * @param dispose Defines whether the assets should also be disposed.		 *		 * @see away3d.library.AssetLibraryBundle.removeAsset()		 */
		public static function removeAsset(asset:IAsset, dispose:Boolean = true):void
		{
            AssetLibrary.getBundle().removeAsset(asset, dispose);
		}
		
		/**		 * Short-hand for removeAssetByName() method on default asset library bundle.		 *		 * @param name The name of the asset to be removed.		 * @param ns The namespace to which the desired asset belongs.		 * @param dispose Defines whether the assets should also be disposed.		 *		 * @see away3d.library.AssetLibraryBundle.removeAssetByName()		 */
		public static function removeAssetByName(name:String, ns:String = null, dispose:Boolean = true):IAsset
		{
			ns = ns || null;

			return AssetLibrary.getBundle().removeAssetByName(name, ns, dispose);
		}
		
		/**		 * Short-hand for removeAllAssets() method on default asset library bundle.		 *		 * @param dispose Defines whether the assets should also be disposed.		 *		 * @see away3d.library.AssetLibraryBundle.removeAllAssets()		 */
		public static function removeAllAssets(dispose:Boolean = true):void
		{
            AssetLibrary.getBundle().removeAllAssets(dispose);
		}
		
		/**		 * Short-hand for removeNamespaceAssets() method on default asset library bundle.		 *		 * @see away3d.library.AssetLibraryBundle.removeNamespaceAssets()		 */
		public static function removeNamespaceAssets(ns:String = null, dispose:Boolean = true):void
		{
			ns = ns || null;

            AssetLibrary.getBundle().removeNamespaceAssets(ns, dispose);
		}
	}
}
// singleton enforcer
