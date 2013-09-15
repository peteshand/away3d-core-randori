

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
            this._name = imageName;
            this.initImage();

        }

        // Public
        /**         * load an image         * @param request {away.net.URLRequest}         */
        public function load(request:URLRequest):void
        {

            this._loaded = false;
            this._request   = request;

            if ( this._crossOrigin )
            {

                if ( this._image['crossOrigin'] != null )
                {

                    this._image['crossOrigin'] = this._crossOrigin;

                }


            }

            this._image.src = this._request.url;

        }

        /**         *         */
        public function dispose():void
        {

            if ( this._image )
            {

                this._image.onabort = null;
                this._image.onerror = null;
                this._image.onload	= null;
                this._image         = null;

            }

            if ( this._request )
            {

                this._request = null;

            }

        }

        // Get / Set

        /**         * Get reference to image if it is loaded         * @returns {HTMLImageElement}         */
        public function get image():HTMLImageElement
        {

            return this._image;

        }

        /**         * Get image width. Returns null is image is not loaded         * @returns {number}         */
        public function get loaded():Boolean
        {

            return this._loaded

        }

        public function get crossOrigin():String
        {

            return this._crossOrigin;
        }

        public function set crossOrigin(value:String):void
        {

            this._crossOrigin = value;

        }

        /**         * Get image width. Returns null is image is not loaded         * @returns {number}         */
        public function get width():Number
        {

            if ( this._image ) {

                return this._image.width;

            }

            return null;

        }

        /**         * Get image height. Returns null is image is not loaded         * @returns {number}         */
        public function get height():Number
        {

            if ( this._image ) {

                return this._image.height;

            }

            return null;

        }

        /**         * return URL request used to load image         * @returns {away.net.URLRequest}         */
        public function get request():URLRequest
        {

            return this._request;

        }

        /**         * get name of HTMLImageElement         * @returns {string}         */
        public function get name():String
        {

            if ( this._image )
            {

                return this._image.name;

            }

            return this._name;

        }

        /**         * set name of HTMLImageElement         * @returns {string}         */
        public function set name(value:String):void
        {

            if ( this._image )
            {

                this._image.name = value;

            }

            this._name = value;

        }

        // Private

        /**         * intialise the image object         */
        private function initImage():void
        {

            var that:IMGLoader = this;
			if ( ! this._image )
            {

                this._image         = new HTMLImageElement();
                this._image.onabort = function(event) { that.onAbort(event); } //Loading of an image is interrupted
                this._image.onerror = function(event) { that.onError(event); } //An error occurs when loading an image
                this._image.onload	= function(event) { that.onLoadComplete(event); } //image is finished loading
                this._image.name    = this._name;

            }

        }

        // Image - event handlers

        /**         * Loading of an image is interrupted         * @param event         */
        private function onAbort(event):void
        {

            this.dispatchEvent( new Event( IOErrorEvent.IO_ERROR) );

        }

        /**         * An error occured when loading the image         * @param event         */
        private function onError(event):void
        {

            this.dispatchEvent( new Event( IOErrorEvent.IO_ERROR) );

        }

        /**         * image is finished loading         * @param event         */
        private function onLoadComplete(event):void
        {
            this._loaded = true;
            this.dispatchEvent( new Event( Event.COMPLETE ));

        }

    }

}
