/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package away.loaders.misc
{

	public class AssetLoaderContext
	{
		public static var UNDEFINED:Number = 0;
		public static var SINGLEPASS_MATERIALS:Number = 1;
		public static var MULTIPASS_MATERIALS:Number = 2;

		private var _includeDependencies:Boolean = false;
		private var _dependencyBaseUrl:String = null;
		private var _embeddedDataByUrl:Object;
		private var _remappedUrls:Object;
		private var _materialMode:Number = 0;
		
		private var _overrideAbsPath:Boolean = false;
		private var _overrideFullUrls:Boolean = false;
		
		/**		 * AssetLoaderContext provides configuration for the AssetLoader load() and parse() operations.		 * Use it to configure how (and if) dependencies are loaded, or to map dependency URLs to		 * embedded data.		 *		 * @see away3d.loading.AssetLoader		 */
		public function AssetLoaderContext(includeDependencies:Boolean = true, dependencyBaseUrl:String = null):void
		{
			dependencyBaseUrl = dependencyBaseUrl || null;

			this._includeDependencies   = includeDependencies;
            this._dependencyBaseUrl     = dependencyBaseUrl || '';
            this._embeddedDataByUrl     = {};
            this._remappedUrls          = {};
            this._materialMode          = AssetLoaderContext.UNDEFINED;
		}
		
		/**		 * Defines whether dependencies (all files except the one at the URL given to the load() or		 * parseData() operations) should be automatically loaded. Defaults to true.		 */
		public function get includeDependencies():Boolean
		{
			return this._includeDependencies;
		}
		
		public function set includeDependencies(val:Boolean):void
		{
            this._includeDependencies = val;
		}
		
		/**		 * MaterialMode defines, if the Parser should create SinglePass or MultiPass Materials		 * Options:		 * 0 (Default / undefined) - All Parsers will create SinglePassMaterials, but the AWD2.1parser will create Materials as they are defined in the file		 * 1 (Force SinglePass) - All Parsers create SinglePassMaterials		 * 2 (Force MultiPass) - All Parsers will create MultiPassMaterials		 * 		 */
		public function get materialMode():Number
		{
			return this._materialMode;
		}
		
		public function set materialMode(materialMode:Number):void
		{
            this._materialMode = materialMode;
		}
		
		/**		 * A base URL that will be prepended to all relative dependency URLs found in a loaded resource.		 * Absolute paths will not be affected by the value of this property.		 */
		public function get dependencyBaseUrl():String
		{
			return this._dependencyBaseUrl;
		}
		
		public function set dependencyBaseUrl(val:String):void
		{
            this._dependencyBaseUrl = val;
		}
		
		/**		 * Defines whether absolute paths (defined as paths that begin with a "/") should be overridden		 * with the dependencyBaseUrl defined in this context. If this is true, and the base path is		 * "base", /path/to/asset.jpg will be resolved as base/path/to/asset.jpg.		 */
		public function get overrideAbsolutePaths():Boolean
		{
			return this._overrideAbsPath;
		}
		
		public function set overrideAbsolutePaths(val:Boolean):void
		{
            this._overrideAbsPath = val;
		}
		
		/**		 * Defines whether "full" URLs (defined as a URL that includes a scheme, e.g. http://) should be		 * overridden with the dependencyBaseUrl defined in this context. If this is true, and the base		 * path is "base", http://example.com/path/to/asset.jpg will be resolved as base/path/to/asset.jpg.		 */
		public function get overrideFullURLs():Boolean
		{
			return this._overrideFullUrls;
		}
		
		public function set overrideFullURLs(val:Boolean):void
		{
            this._overrideFullUrls = val;
		}
		
		/**		 * Map a URL to another URL, so that files that are referred to by the original URL will instead		 * be loaded from the new URL. Use this when your file structure does not match the one that is		 * expected by the loaded file.		 *		 * @param originalUrl The original URL which is referenced in the loaded resource.		 * @param newUrl The URL from which Away3D should load the resource instead.		 *		 * @see mapUrlToData()		 */
		public function mapUrl(originalUrl:String, newUrl:String):void
		{
            this._remappedUrls[originalUrl] = newUrl;
		}
		
		/**		 * Map a URL to embedded data, so that instead of trying to load a dependency from the URL at		 * which it's referenced, the dependency data will be retrieved straight from the memory instead.		 *		 * @param originalUrl The original URL which is referenced in the loaded resource.		 * @param data The embedded data. Can be ByteArray or a class which can be used to create a bytearray.		 */
		public function mapUrlToData(originalUrl:String, data:*):void
		{
			this._embeddedDataByUrl[originalUrl] = data;
		}
		
		/**		 * @private		 * Defines whether embedded data has been mapped to a particular URL.		 */
		public function _iHasDataForUrl(url:String):Boolean
		{
			return this._embeddedDataByUrl.hasOwnProperty(url);
		}
		
		/**		 * @private		 * Returns embedded data for a particular URL.		 */
		public function _iGetDataForUrl(url:String):*
		{
			return this._embeddedDataByUrl[url];
		}
		
		/**		 * @private		 * Defines whether a replacement URL has been mapped to a particular URL.		 */
		public function _iHasMappingForUrl(url:String):Boolean
		{
			return this._remappedUrls.hasOwnProperty(url);
		}
		
		/**		 * @private		 * Returns new (replacement) URL for a particular original URL.		 */
		public function _iGetRemappedUrl(originalUrl:String):String
		{
			return this._remappedUrls[originalUrl];
		}
	}
}
