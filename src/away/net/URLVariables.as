///<reference path="../_definitions.ts"/>

package away.net {
	import randori.webkit.html.FormData;


    public class URLVariables
    {

        private var _variables:Object = new Object();

        /**
         *
         * @param source
         */
        public function URLVariables(source:String = null):void
        {

            if ( source !== null )
            {

                decode( source );

            }


        }
        /**
         *
         * @param source
         */
        public function decode(source:String):void
        {

            source = source.split("+").join(" ");

            var tokens, re = /[?&]?([^=]+)=([^&]*)/g;

            while (tokens = re.exec(source)) {

                _variables[decodeURIComponent(tokens[1])] = decodeURIComponent(tokens[2]);

            }

        }
        /**
         *
         * @returns {string}
         */
        public function toString():String
        {

            return '';
        }
        /**
         *
         * @returns {Object}
         */
        public function get variables():Object
        {

            return _variables;

        }
        /**
         *
         * @returns {Object}
         */
        public function get formData():FormData
        {

            var fd : FormData = new FormData();

            for ( var s in _variables )
            {

                fd.append( s , _variables[s] );

            }

            return fd;


        }
        /**
         *
         * @returns {Object}
         */
        public function set variables(obj:Object):void
        {

            _variables = obj;

        }


    }


}