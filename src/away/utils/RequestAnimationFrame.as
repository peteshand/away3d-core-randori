///<reference path="../_definitions.ts"/>



package away.utils
{

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

        /**         *         * @param callback         * @param callbackContext         */
        public function setCallback(callback:Function, callbackContext:Object):void
        {

            this._callback = callback;
            this._callbackContext = callbackContext;

        }

        /**         *         */
        public function start():void
        {

            this._prevTime = new Date().getTime();
            this._active = true;

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

                window.requestAnimationFrame( this._rafUpdateFunction );

            }


        }

        /**         *         */
        public function stop():void
        {

            this._active = false;

        }

        // Get / Set

        /**         *         * @returns {boolean}         */
        public function get active():Boolean
        {

            return this._active;

        }

        // Private

        /**         *         * @private         */
        private function _tick():void
        {

            this._currentTime   = new Date().getTime();
            this._dt            = this._currentTime - this._prevTime;
            this._argsArray[0]  = this._dt;
            this._callback.apply( this._callbackContext , this._argsArray );

            window.requestAnimationFrame( this._rafUpdateFunction );

            this._prevTime      = this._currentTime;

        }


    }
}
