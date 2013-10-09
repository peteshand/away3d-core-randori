/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package away.library.assets
{
	import away.events.EventDispatcher;
	import away.events.AssetEvent;
	import away.errors.AbstractMethodError;

	public class NamedAssetBase extends EventDispatcher
	{
		private var _originalName:String = null;
		private var _namespace:String = null;
		private var _name:String = null;
		private var _id:String = null;
		private var _full_path:Vector.<String>;
        private var _assetType:String = null;

		public static var DEFAULT_NAMESPACE:String = 'default';
		
		public function NamedAssetBase(name:String):void
		{
            super();

			if (name == null)
				name = 'null';
			
			this._name = name;
            this._originalName = name;

            this.updateFullPath();

		}
		
		/**		 * The original name used for this asset in the resource (e.g. file) in which		 * it was found. This may not be the same as <code>name</code>, which may		 * have changed due to of a name conflict.		 */
		public function get originalName():String
		{
			return this._originalName;
		}

        public function get id():String
        {
            return this._id;
        }

        public function set id(newID:String):void
        {
            this._id=newID;
        }

        public function get assetType():String
        {
            return this._assetType;
        }

        public function set assetType(type:String):void
        {
            this._assetType=type;
        }
		
		public function get name():String
		{
			return this._name;
		}

		public function set name(val:String):void
		{
			var prev : String;
			
			prev = this._name;
            this._name = val;

			if ( this._name == null )
            {

                this._name = 'null';

            }

			this.updateFullPath();
			
			//if (hasEventListener(AssetEvent.ASSET_RENAME))
			this.dispatchEvent( new AssetEvent(AssetEvent.ASSET_RENAME , (this as IAsset) , prev ) );

		}

        public function dispose():void
        {
            throw new AbstractMethodError();
        }

		public function get assetNamespace():String
		{
			return this._namespace;
		}
		
		public function get assetFullPath():Vector.<String>
		{
			return this._full_path;
		}
		
		public function assetPathEquals(name:String, ns:String):Boolean
		{
			return (this._name == name && (!ns || this._namespace==ns));
		}
		
		public function resetAssetPath(name:String, ns:String = null, overrideOriginal:Boolean = true):void
		{
			ns = ns || null;


            this._name = name? name : 'null';
            this._namespace = ns? ns: NamedAssetBase.DEFAULT_NAMESPACE;

			if (overrideOriginal)
            {

                this._originalName = this._name;

            }

			this.updateFullPath();

		}
		
		private function updateFullPath():void
		{

            this._full_path = new <String>[this._namespace, this._name];

		}
		

	}

}