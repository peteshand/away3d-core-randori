///<reference path="../_definitions.ts"/>



package away.utils
{
import randori.webkit.page.Window;

public class RequestAnimationFrame
    {

        private var _callback:Function;
        private var _callbackContext:Object;
        private var _active:Boolean = false;
        private var _rafUpdateFunction:*;
        private var _prevTime:Number;
        private var _dt:Number;
        private var _currentTime:Number;
        private var _argsArray:Vector.<*> = new Vector.<*>();
        
        public function RequestAnimationFrame(callback:Function, callbackContext:Object):void
        {

			this.setCallback( callback , callbackContext );

            var that:RequestAnimationFrame = this;
			this._rafUpdateFunction = function() {

                if ( that._active )
                {

                    that._tick();

                }

            }

            this._argsArray.push( this._dt );

        }

        // Public

        /**
         *
         * @param callback
         * @param callbackContext
         */
        public function setCallback(callback:Function, callbackContext:Object):void
        {

            _callback = callback;
            _callbackContext = callbackContext;

        }

        /**
         *
         */
        public function start():void
        {

            _prevTime = new Date().getTime();
            _active = true;

            if ( window['mozRequestAnimationFrame'] )
            {

                window.requestAnimationFrame = window['mozRequestAnimationFrame'];

            }
            else if ( window['webkitRequestAnimationFrame'] )
            {

                window.requestAnimationFrame = window['webkitRequestAnimationFrame'];

            }
            else if ( window['oRequestAnimationFrame'] )
            {

                window.requestAnimationFrame = window['oRequestAnimationFrame'];

            }

            if ( window.requestAnimationFrame )
            {

                window.requestAnimationFrame( _rafUpdateFunction );

            }


        }

        /**
         *
         */
        public function stop():void
        {

            _active = false;

        }

        // Get / Set

        /**
         *
         * @returns {boolean}
         */
        public function get active():Boolean
        {

            return _active;

        }

        // Private

        /**
         *
         * @private
         */
        private function _tick():void
        {
            _currentTime   = new Date().getTime();
            _dt            = _currentTime - _prevTime;
            _argsArray[0]  = _dt;
            _callback.apply( _callbackContext , _argsArray );

            window.requestAnimationFrame( _rafUpdateFunction );

            _prevTime      = _currentTime;

        }


    }
}