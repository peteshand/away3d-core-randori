
///<reference path="../../_definitions.ts"/>
package away.loaders.misc
{
	import away.events.EventDispatcher;
	import away.net.URLLoader;
	import away.net.URLRequest;
	import away.events.Event;
	import away.events.IOErrorEvent;

    public class SingleFileURLLoader extends EventDispatcher implements ISingleFileTSLoader
    {

        private var _loader:URLLoader;
        private var _data:*;

        public function SingleFileURLLoader():void
        {
            super();
            initLoader();
        }

        // Public

        /**         *         * @param req         */
        public function load(req:URLRequest):void
        {
            _loader.load( req );
        }

        /**         *         */
        public function dispose():void
        {
            disposeLoader();
            _data = null;
        }

        // Get / Set

        /**         *         * @returns {*}         */
        public function get data():*
        {
            return _loader.data;
        }
        /**         *         * @returns {*}         */
        public function get dataFormat():String
        {
            return _loader.dataFormat;
        }
        public function set dataFormat(value:String):void
        {
            _loader.dataFormat = value;

        }

        // Private

        /**         *         */
        private function initLoader():void
        {
            if ( ! _loader )
            {
                _loader = new URLLoader();
                _loader.addEventListener( Event.COMPLETE , onLoadComplete , this );
                _loader.addEventListener( IOErrorEvent.IO_ERROR, onLoadError , this );
            }

        }

        /**         *         */
        private function disposeLoader():void
        {
            if ( _loader )
            {
                _loader.dispose();
                _loader.removeEventListener( Event.COMPLETE , onLoadComplete , this );
                _loader.removeEventListener( IOErrorEvent.IO_ERROR, onLoadError , this );
                _loader = null
            }
        }

        // Events

        /**         *         * @param event         */
        private function onLoadComplete(event:Event):void
        {
            dispatchEvent( event );
        }

        /**         *         * @param event         */
        private function onLoadError(event:IOErrorEvent):void
        {
            dispatchEvent( event );
        }

    }

}