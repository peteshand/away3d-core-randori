/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package away.core.net {

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
        private var _url:String = null;

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