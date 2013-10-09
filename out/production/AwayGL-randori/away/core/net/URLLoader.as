/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package away.core.net {
	import away.events.EventDispatcher;
	import away.errors.Error;
	import away.events.IOErrorEvent;
	import away.events.HTTPStatusEvent;
	import away.events.ProgressEvent;
	import away.events.Event;
	import randori.webkit.xml.XMLHttpRequest;

    // TODO: implement / test cross domain policy

    public class URLLoader extends EventDispatcher
    {

        private var _XHR:XMLHttpRequest;
        private var _bytesLoaded:Number = 0;
        private var _bytesTotal:Number = 0;
        private var _data:*;
        private var _dataFormat:String = URLLoaderDataFormat.TEXT;
        private var _request:URLRequest;
        private var _loadError:Boolean = false;

        public function URLLoader():void
        {

            super();

        }

        // Public

        /**         *         * @param request {away.net.URLRequest}         */
        public function load(request:URLRequest):void
        {

            this.initXHR();
            this._request = request;

            if ( request.method === URLRequestMethod.POST ){

                this.postRequest( request );


            } else {

                this.getRequest( request );

            }

        }

        /**         *         */
        public function close():void
        {

            this._XHR.abort();
            this.disposeXHR();

        }

        /**         *         */
        public function dispose():void
        {

            if ( this._XHR)
            {

                this._XHR.abort();

            }

            this.disposeXHR();

            this._data          = null;
            this._dataFormat    = null;
            this._bytesLoaded   = null;
            this._bytesTotal    = null;

            /*            if( this._request )            {                this._request.dispose();            }            */

            this._request   = null;

        }

        // Get / Set

        /**         *         * away.net.URLLoaderDataFormat.BINARY         * away.net.URLLoaderDataFormat.TEXT         * away.net.URLLoaderDataFormat.VARIABLES         *         * @param format         */
        public function set dataFormat(format:String):void
        {

            if( format === URLLoaderDataFormat.BLOB
                || format === URLLoaderDataFormat.ARRAY_BUFFER
                || format === URLLoaderDataFormat.BINARY
                || format === URLLoaderDataFormat.TEXT
                || format === URLLoaderDataFormat.VARIABLES) {

                this._dataFormat = format;

            } else {

                throw new away.errors.Error( 'URLLoader error: incompatible dataFormat' );

            }

        }

        /**         *         * @returns {string}         *      away.net.URLLoaderDataFormat         */
        public function get dataFormat():String
        {

            return this._dataFormat;

        }

        /**         *         * @returns {*}         */
        public function get data():*
        {

            return this._data;

        }

        /**         *         * @returns {number}         */
        public function get bytesLoaded():Number
        {

            return this._bytesLoaded;

        }

        /**         *         * @returns {number}         */
        public function get bytesTotal():Number
        {

            return this._bytesTotal;

        }

        /**         *         * @returns {away.net.URLRequest}         */
        public function get request():URLRequest
        {

            return this._request;

        }

        // Private

        /**         *         * @param xhr         * @param responseType         */
        private function setResponseType(xhr:XMLHttpRequest, responseType:String):void
        {

            switch( responseType )
            {

                case URLLoaderDataFormat.ARRAY_BUFFER:
                case URLLoaderDataFormat.BLOB:
                case URLLoaderDataFormat.TEXT:

                    xhr.responseType = responseType;

                    break;

                case URLLoaderDataFormat.VARIABLES:

                    xhr.responseType = URLLoaderDataFormat.TEXT;

                    break;


                case URLLoaderDataFormat.BINARY:

                    xhr.responseType = '';

                    break;


            }


        }

        /**         *         * @param request {away.net.URLRequest}         */
        private function getRequest(request:URLRequest):void
        {

            try {

                this._XHR.open( request.method , request.url , request.async );
                this.setResponseType( this._XHR , this._dataFormat );
                this._XHR.send(); // No data to send

            } catch ( e /* <XMLHttpRequestException> */ ) {

                this.handleXmlHttpRequestException( e);

            }

        }

        /**         *         * @param request {away.net.URLRequest}         */
        private function postRequest(request:URLRequest):void
        {

            this._loadError = false;

            this._XHR.open( request.method , request.url , request.async );

            if ( request.data != null )
            {

                if ( request.data instanceof URLVariables )
                {

                    var urlVars : URLVariables = (request.data as URLVariables);

                    try {

                        this._XHR.responseType = 'text';
                        this._XHR.send( urlVars.formData );


                    } catch ( e /* <XMLHttpRequestException> */ ) {

                        this.handleXmlHttpRequestException( e );

                    }

                }
                else
                {

                    this.setResponseType( this._XHR , this._dataFormat );

                    if ( request.data ) {

                        this._XHR.send( request.data ); // TODO: Test

                    } else {

                        this._XHR.send( ); // no data to send

                    }


                }

            }
            else
            {

                this._XHR.send(); // No data to send

            }

        }

        /**         *         * @param error {XMLHttpRequestException}         */
        private function handleXmlHttpRequestException(error /* <XMLHttpRequestException> */):void
        {
            //switch ( error.code )
            //{
                /******************************************************************************************************************************************************************************************************                 *                 *  XMLHttpRequestException { message: "NETWORK_ERR: XMLHttpRequest Exception 101", name: "NETWORK_ERR", code: 101, stack: "Error: A network error occurred in synchronous req…",NETWORK_ERR: 101… }                 *  code: 101 , message: "NETWORK_ERR: XMLHttpRequest Exception 101" ,  name: "NETWORK_ERR"                 *                 ******************************************************************************************************************************************************************************************************/
                //case 101:
                    // Note: onLoadError event throws IO_ERROR event - this case is already Covered
                    //break;
            //}
        }

        /**         *         */
        private function initXHR():void
        {

            if ( ! this._XHR )
            {

                this._XHR = new XMLHttpRequest();
				var that:URLLoader = this;

                this._XHR.onloadstart = function(event):void{ that.onLoadStart(event)};                 // loadstart	        - When the request starts.
                this._XHR.onprogress = function(event):void{ that.onProgress(event)};	                // progress	            - While loading and sending data.
                this._XHR.onabort = function(event):void{ that.onAbort(event)};	                        // abort	            - When the request has been aborted, either by invoking the abort() method or navigating away from the page.
                this._XHR.onerror = function(event):void{ that.onLoadError(event)};                     // error	            - When the request has failed.
                this._XHR.onload = function(event):void{ that.onLoadComplete(event)};                   // load	                - When the request has successfully completed.
                this._XHR.ontimeout	= function(event):void{ that.onTimeOut(event)};                     // timeout	            - When the author specified timeout has passed before the request could complete.
                this._XHR.onloadend	= function(event):void{ that.onLoadEnd(event)};                     // loadend	            - When the request has completed, regardless of whether or not it was successful.
                this._XHR.onreadystatechange = function(event):void{ that.onReadyStateChange(event)};   // onreadystatechange   - When XHR state changes

            }

        }

        /**         *         */
        private function disposeXHR():void
        {

            if ( this._XHR !== null )
            {

                this._XHR.onloadstart   = null;
                this._XHR.onprogress    = null;
                this._XHR.onabort       = null;
                this._XHR.onerror       = null;
                this._XHR.onload        = null;
                this._XHR.ontimeout	    = null;
                this._XHR.onloadend	    = null;
                this._XHR               = null;

            }

        }

        /**         *         * @param source         */
        public function decodeURLVariables(source:String):Object
        {

            var result : Object = new Object();

            source = source.split("+").join(" ");

            var re = /[?&]?([^=]+)=([^&]*)/g;
			var tokens = re; 
			
            while (tokens = re.exec(source))
            {

                result[decodeURIComponent(tokens[1])] = decodeURIComponent(tokens[2]);

            }

            return result;

        }

        // XMLHttpRequest - Event Handlers

        /**         * When XHR state changes         * @param event         */
        private function onReadyStateChange(event):void
        {
            if (this._XHR.readyState==4)
            {

                if (this._XHR.status==404)
                {

                    this._loadError = true;
                    this.dispatchEvent( new IOErrorEvent(IOErrorEvent.IO_ERROR ));

                }

                this.dispatchEvent( new HTTPStatusEvent( HTTPStatusEvent.HTTP_STATUS , this._XHR.status ));

            }

        }

        /**         * When the request has completed, regardless of whether or not it was successful.         * @param event         */
        private function onLoadEnd(event):void
        {

            if( this._loadError === true ) return;

        }

        /**         * When the author specified timeout has passed before the request could complete.         * @param event         */
        private function onTimeOut(event):void
        {

            //TODO: Timeout not currently implemented ( also not part of AS3 API )

        }

        /**         * When the request has been aborted, either by invoking the abort() method or navigating away from the page.         * @param event         */
        private function onAbort(event):void
        {

            // TODO: investigate whether this needs to be an IOError

        }

        /**         * While loading and sending data.         * @param event         */
        private function onProgress(event):void
        {

            this._bytesTotal    = event.total;
            this._bytesLoaded   = event.loaded;

            var progressEvent : ProgressEvent   = new ProgressEvent( ProgressEvent.PROGRESS );
                progressEvent.bytesLoaded                   = this._bytesLoaded;
                progressEvent.bytesTotal                    = this._bytesTotal;
            this.dispatchEvent( progressEvent );

        }

        /**         * When the request starts.         * @param event         */
        private function onLoadStart(event):void
        {

            this.dispatchEvent( new Event( Event.OPEN ));

        }

        /**         * When the request has successfully completed.         * @param event         */
        private function onLoadComplete(event):void
        {

            if( this._loadError === true ) return;

            // TODO: Assert received data format

            switch ( this._dataFormat ){

                case URLLoaderDataFormat.TEXT:

                    this._data = this._XHR.responseText;

                    break;

                case URLLoaderDataFormat.VARIABLES:

                    this._data = this.decodeURLVariables( this._XHR.responseText );

                    break;

                case URLLoaderDataFormat.BLOB:
                case URLLoaderDataFormat.ARRAY_BUFFER:
                case URLLoaderDataFormat.BINARY:

                    this._data = this._XHR.response;

                    break;

                default:

                    this._data = this._XHR.responseText;

                    break;

            }

            this.dispatchEvent( new Event( Event.COMPLETE ));

        }

        /**         * When the request has failed. ( due to network issues ).         * @param event         */
        private function onLoadError(event):void
        {

            this._loadError = true;
            this.dispatchEvent( new IOErrorEvent(IOErrorEvent.IO_ERROR ));

        }


    }

}