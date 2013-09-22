
///<reference path="../_definitions.ts"/>

package away.net {

    /**     *     */
    public class URLRequest
    {

        //public authenticate     : boolean = false;
        //public cacheResponse    : boolean = true;
        //public idleTimeout      : number;
        //public requestHeader    : Array;
        //public userAgent        : string;

        /*         * The MIME content type of the content in the the data property.         * @type {string}         */
        //public contentType      : string = 'application/x-www-form-urlencoded'; //Note: Not used for now.

        /**         * Object containing data to be transmited with URL Request ( URL Variables / binary / string )         *         */
        public var data:*;

        /**         *         * away.net.URLRequestMethod.GET         * away.net.URLRequestMethod.POST         *         * @type {string}         */
        public var method:String = URLRequestMethod.GET;

        /**         * Use asynchronous XMLHttpRequest         * @type {boolean}         */
        public var async:Boolean = true;

        /**         *         */
        private var _url:String;

        /**         * @param url         */
        public function URLRequest(url:String = null):void
        {
			url = url || null;


            this._url = url;

        }

        /**         *         * @returns {string}         */
        public function get url():String
        {

            return this._url;

        }

        /**         *         * @param value         */
        public function set url(value:String):void
        {

            this._url = value;

        }

        /**         * dispose         */
        public function dispose():void
        {

            this.data   = null;
            this._url   = null;
            this.method = null;
            this.async  = null;

        }
    }
}