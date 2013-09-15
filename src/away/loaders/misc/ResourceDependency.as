


///<reference path="../../_definitions.ts"/>

package away.loaders.misc
{
	import away.net.URLRequest;
	import away.library.assets.IAsset;
	import away.loaders.parsers.ParserBase;
	//import away3d.arcane;
	//import away3d.library.assets.IAsset;
	//import away3d.loaders.parsers.ParserBase;
	
	//import flash.net.URLRequest;

	//use namespace arcane;
	
	/**	 * ResourceDependency represents the data required to load, parse and resolve additional files ("dependencies")	 * required by a parser, used by ResourceLoadSession.	 *	 */
	public class ResourceDependency
	{
		private var _id:String;
		private var _req:URLRequest;
		private var _assets:Vector.<IAsset>;//Vector.<IAsset>;		private var _parentParser:ParserBase;
		private var _data:*;
		private var _retrieveAsRawData:Boolean;
		private var _suppressAssetEvents:Boolean;
		private var _dependencies:Vector.<ResourceDependency>;

		public var _iLoader:SingleFileLoader;
		public var _iSuccess:Boolean;

		
		public function ResourceDependency(id:String, req:URLRequest, data:*, parentParser:ParserBase, retrieveAsRawData:Boolean = false, suppressAssetEvents:Boolean = false):void
		{

			this._id = id;
            this._req = req;
            this._parentParser = parentParser;
            this._data = data;
            this._retrieveAsRawData = retrieveAsRawData;
            this._suppressAssetEvents = suppressAssetEvents;

            this._assets = new Vector.<IAsset>();//new Vector.<IAsset>();
            this._dependencies = new Vector.<ResourceDependency>();
		}
		
		
		public function get id():String
		{
			return this._id;
		}
		
		
		public function get assets():Vector.<IAsset>//Vector.<IAsset>		{
			return this._assets;
		}
		
		
		public function get dependencies():Vector.<ResourceDependency>//Vector.<ResourceDependency>		{
			return this._dependencies;
		}
		
		
		public function get request():URLRequest
		{
			return this._req;
		}
		
		
		public function get retrieveAsRawData():Boolean
		{
			return this._retrieveAsRawData;
		}
		
		
		public function get suppresAssetEvents():Boolean
		{
			return this._suppressAssetEvents;
		}
		
		
		/**		 * The data containing the dependency to be parsed, if the resource was already loaded.		 */
		public function get data():*
		{
			return this._data;
		}
		
		
		/**		 * @private		 * Method to set data after having already created the dependency object, e.g. after load.		*/
		public function _iSetData(data:*):void
		{
			this._data = data;
		}
		
		/**		 * The parser which is dependent on this ResourceDependency object.		 */
		public function get parentParser():ParserBase
		{
			return this._parentParser;
		}
		
		/**		 * Resolve the dependency when it's loaded with the parent parser. For example, a dependency containing an		 * ImageResource would be assigned to a Mesh instance as a BitmapMaterial, a scene graph object would be added		 * to its intended parent. The dependency should be a member of the dependencies property.		 */
		public function resolve():void
		{

			if (this._parentParser) this._parentParser._iResolveDependency(this);
		}
		
		/**		 * Resolve a dependency failure. For example, map loading failure from a 3d file		 */
		public function resolveFailure():void
		{
			if (this._parentParser) this._parentParser._iResolveDependencyFailure(this);
		}
		
		/**		 * Resolve the dependencies name		 */
		public function resolveName(asset:IAsset):String
		{
			if (this._parentParser) return this._parentParser._iResolveDependencyName(this, asset);
			return asset.name;
		}
		
	}
}
