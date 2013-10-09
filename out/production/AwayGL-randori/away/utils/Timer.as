/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package away.utils
{
	import away.events.EventDispatcher;
	import away.errors.Error;
	import away.events.TimerEvent;
	import randori.webkit.page.Window;


    //[native(cls="TimerClass", gc="exact", instance="TimerObject", methods="auto")]
    //[Event(name="timerComplete", type="flash.events.TimerEvent")]
    //[Event(name="timer", type="flash.events.TimerEvent")]

    public class Timer extends EventDispatcher
    {

        private var _delay:Number = 0;
        private var _repeatCount:Number = 0;
        private var _currentCount:Number = 0;
        private var _iid:Number = 0;
        private var _running:Boolean = false;

        public function Timer(delay:Number, repeatCount:Number = 0):void
        {
			repeatCount = repeatCount || 0;


            super();



            this._delay = delay;
            this._repeatCount = repeatCount;

            if (isNaN(delay) || delay < 0)
            {
                throw new away.errors.Error("Delay is negative or not a number");
            }

        }

        public function get currentCount():Number
        {

            return this._currentCount;

        }

        public function get delay():Number
        {

            return this._delay;

        }

        public function set delay(value:Number):void
        {

            this._delay = value;

            if (this._running)
            {
                this.stop();
                this.start();
            }

        }

        public function get repeatCount():Number
        {

            return this._repeatCount;
        }

        public function set repeatCount(value:Number):void
        {

            this._repeatCount = value;
        }

        public function reset():void
        {

            if (this._running)
            {
                this.stop();
            }

            this._currentCount = 0;

        }

        public function get running():Boolean
        {

            return this._running;

        }

        public function start():void
        {

            this._running = true;
            Window.clearInterval( this._iid );
            this._iid = Window.setInterval( tick , this._delay );

        }

        public function stop():void
        {

            this._running = false;
            Window.clearInterval( this._iid );

        }

        private function tick():void
        {

            this._currentCount ++;

            if ( ( this._repeatCount > 0 ) && this._currentCount >= this._repeatCount)
            {

                this.stop();
                this.dispatchEvent( new TimerEvent( TimerEvent.TIMER ) );
                this.dispatchEvent( new TimerEvent( TimerEvent.TIMER_COMPLETE ) );

            }
            else
            {

                this.dispatchEvent( new TimerEvent( TimerEvent.TIMER ) );

            }

        }
    }
}
