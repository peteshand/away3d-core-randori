
///<reference path="../_definitions.ts"/>

package away.net
{
	import away.events.EventDispatcher;
	import away.events.Event;
	import away.events.IOErrorEvent;
	import randori.webkit.html.HTMLImageElement;

    // TODO: implement / test cross domain policy

    public class IMGLoader extends EventDispatcher
    {

        private var _image:HTMLImageElement;
        private var _request:URLRequest;
        private var _name:String = '';
        private var _loaded:Boolean = false;
        private var _crossOrigin:String;

        public function IMGLoader(imageName:String = ''):void
        {

            super();
            _name = imageName;
            initImage();

        }

        // Public
        /**
         * load an image
         * @param request {away.net.URLRequest}
         */
        public function load(request:URLRequest):void
        {

            _loaded = false;
            _request   = request;

            if ( _crossOrigin )
            {

                if ( _image['crossOrigin'] != null )
                {

                    _image['crossOrigin'] = _crossOrigin;

                }


            }

            _image.src = _request.url;

        }

        /**
         *
         */
        public function dispose():void
        {

            if ( _image )
            {

                _image.onabort = null;
                _image.onerror = null;
                _image.onload	= null;
                _image         = null;

            }

            if ( _request )
            {

                _request = null;

            }

        }

        // Get / Set

        /**
         * Get reference to image if it is loaded
         * @returns {HTMLImageElement}
         */
        public function get image():HTMLImageElement
        {

            return _image;

        }

        /**
         * Get image width. Returns null is image is not loaded
         * @returns {number}
         */
        public function get loaded():Boolean
        {

            return _loaded

        }

        public function get crossOrigin():String
        {

            return _crossOrigin;
        }

        public function set crossOrigin(value:String):void
        {

            _crossOrigin = value;

        }

        /**
         * Get image width. Returns null is image is not loaded
         * @returns {number}
         */
        public function get width():Number
        {

            if ( _image ) {

                return _image.width;

            }

            return null;

        }

        /**
         * Get image height. Returns null is image is not loaded
         * @returns {number}
         */
        public function get height():Number
        {

            if ( _image ) {

                return _image.height;

            }

            return null;

        }

        /**
         * return URL request used to load image
         * @returns {away.net.URLRequest}
         */
        public function get request():URLRequest
        {

            return _request;

        }

        /**
         * get name of HTMLImageElement
         * @returns {string}
         */
        public function get name():String
        {

            if ( _image )
            {

                return _image.name;

            }

            return _name;

        }

        /**
         * set name of HTMLImageElement
         * @returns {string}
         */
        public function set name(value:String):void
        {

            if ( _image )
            {

                _image.name = value;

            }

            _name = value;

        }

        // Private

        /**
         * intialise the image object
         */
        private function initImage():void
        {

            var that:IMGLoader = this;
			if ( ! _image )
            {

                _image         = new HTMLImageElement();
                _image.onabort = function(event) { that.onAbort(event); } //Loading of an image is interrupted
                _image.onerror = function(event) { that.onError(event); } //An error occurs when loading an image
                _image.onload	= function(event) { that.onLoadComplete(event); } //image is finished loading
                _image.name    = _name;

            }

        }

        // Image - event handlers

        /**
         * Loading of an image is interrupted
         * @param event
         */
        private function onAbort(event):void
        {

            dispatchEvent( new Event( IOErrorEvent.IO_ERROR) );

        }

        /**
         * An error occured when loading the image
         * @param event
         */
        private function onError(event):void
        {

            dispatchEvent( new Event( IOErrorEvent.IO_ERROR) );

        }

        /**
         * image is finished loading
         * @param event
         */
        private function onLoadComplete(event):void
        {
            _loaded = true;
            dispatchEvent( new Event( Event.COMPLETE ));

        }

    }

}
