/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package away.events
{	
	import away.library.assets.IAsset;
	public class LoaderEvent extends Event
	{
        /**         * Dispatched when loading of a asset failed.         * Such as wrong parser type, unsupported extensions, parsing errors, malformated or unsupported 3d file etc..         */
        public static var LOAD_ERROR:String = "loadError";

        /**         * Dispatched when a resource and all of its dependencies is retrieved.         */
        public static var RESOURCE_COMPLETE:String = "resourceComplete";

        /**         * Dispatched when a resource's dependency is retrieved and resolved.         */
        public static var DEPENDENCY_COMPLETE:String = "dependencyComplete";

        private var _url:String = null;
        private var _assets:Vector.<IAsset>;
        private var _message:String = null;
        private var _isDependency:Boolean = false;
        private var _isDefaultPrevented:Boolean = false;

        /**         * Create a new LoaderEvent object.         * @param type The event type.         * @param resource The loaded or parsed resource.         * @param url The url of the loaded resource.         */
        public function LoaderEvent(type:String, url:String = null, assets:Vector.<IAsset> = null, isDependency:Boolean = false, errmsg:String = null):void
		{
			url = url || null;
			errmsg = errmsg || null;

			super(type);

            this._url           = url;
            this._assets        = assets;
            this._message       = errmsg;
            this._isDependency  = isDependency;

		}
        /**         * The url of the loaded resource.         */
        public function get url():String
        {

            return this._url;

        }

        /**         * The error string on loadError.         */
        public function get assets():Vector.<IAsset>
        {
            return this._assets;
        }

        /**         * The error string on loadError.         */
        public function get message():String
        {
            return this._message;
        }

        /**         * Indicates whether the event occurred while loading a dependency, as opposed         * to the base file. Dependencies can be textures or other files that are         * referenced by the base file.         */
        public function get isDependency():Boolean
        {
            return this._isDependency;
        }

        /**         * Clones the current event.         * @return An exact duplicate of the current event.         */
        override public function clone():Event
        {
            return (new LoaderEvent(this.type , this._url , this._assets , this._isDependency , this._message ) as Event);

        }

    }

}