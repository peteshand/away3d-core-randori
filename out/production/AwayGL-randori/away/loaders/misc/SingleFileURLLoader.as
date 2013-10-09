/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package away.loaders.misc
{
	import away.events.EventDispatcher;
	import away.core.net.URLLoader;
	import away.core.net.URLRequest;
	import away.events.Event;
	import away.events.IOErrorEvent;

    public class SingleFileURLLoader extends EventDispatcher implements ISingleFileTSLoader
    {

        private var _loader:URLLoader;
        private var _data:*;

        public function SingleFileURLLoader():void
        {
            super();
            this.initLoader();
        }

        // Public

        /**         *         * @param req         */
        public function load(req:URLRequest):void
        {
            this._loader.load( req );
        }

        /**         *         */
        public function dispose():void
        {
            this.disposeLoader();
            this._data = null;
        }

        // Get / Set

        /**         *         * @returns {*}         */
        public function get data():*
        {
            return this._loader.data;
        }
        /**         *         * @returns {*}         */
        public function get dataFormat():String
        {
            return this._loader.dataFormat;
        }
        public function set dataFormat(value:String):void
        {
            this._loader.dataFormat = value;

        }

        // Private

        /**         *         */
        private function initLoader():void
        {
            if ( ! this._loader )
            {
                this._loader = new URLLoader();
                this._loader.addEventListener( Event.COMPLETE , onLoadComplete , this );
                this._loader.addEventListener( IOErrorEvent.IO_ERROR, onLoadError , this );
            }

        }

        /**         *         */
        private function disposeLoader():void
        {
            if ( this._loader )
            {
                this._loader.dispose();
                this._loader.removeEventListener( Event.COMPLETE , onLoadComplete , this );
                this._loader.removeEventListener( IOErrorEvent.IO_ERROR, onLoadError , this );
                this._loader = null
            }
        }

        // Events

        /**         *         * @param event         */
        private function onLoadComplete(event:Event):void
        {
            this.dispatchEvent( event );
        }

        /**         *         * @param event         */
        private function onLoadError(event:IOErrorEvent):void
        {
            this.dispatchEvent( event );
        }

    }

}