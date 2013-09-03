
///<reference path="../_definitions.ts"/>

package away.net {
	import randori.webkit.html.FormData;


    public class URLVariables
    {

        private var _variables:Object = new Object();

        /**
        public function URLVariables(source:String = null):void
        {

            if ( source !== null )
            {

                this.decode( source );

            }


        }
        /**
        public function decode(source:String):void
        {

            source = source.split("+").join(" ");

            var tokens, re = /[?&]?([^=]+)=([^&]*)/g;

            while (tokens = re.exec(source)) {

                _variables[decodeURIComponent(tokens[1])] = decodeURIComponent(tokens[2]);

            }

        }
        /**
        public function toString():String
        {

            return '';
        }
        /**
        public function get variables():Object
        {

            return _variables;

        }
        /**
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
        public function set variables(obj:Object):void
        {

            this._variables = obj;

        }


    }


}