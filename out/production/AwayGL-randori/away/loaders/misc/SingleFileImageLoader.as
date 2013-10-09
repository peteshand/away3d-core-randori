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
	import away.core.net.IMGLoader;
	import away.core.net.URLRequest;
	import away.events.Event;
	import away.events.IOErrorEvent;

    public class SingleFileImageLoader extends EventDispatcher implements ISingleFileTSLoader
    {

        private var _loader:IMGLoader;
        private var _data:*;
        private var _dataFormat:String = null;// Not used in this implementation

        public function SingleFileImageLoader():void
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
            return this._loader.image;
        }
        /**         *         * @returns {*}         */
        public function get dataFormat():String
        {
            return this._dataFormat;
        }
        public function set dataFormat(value:String):void
        {
            this._dataFormat = value;
        }

        // Private

        /**         *         */
        private function initLoader():void
        {
            if ( ! this._loader )
            {
                this._loader = new IMGLoader();
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