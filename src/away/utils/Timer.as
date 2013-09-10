

///<reference path="../_definitions.ts"/>

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

        private var _delay:Number;
        private var _repeatCount:Number = 0;
        private var _currentCount:Number = 0;
        private var _iid:Number;
        private var _running:Boolean = false;

        public function Timer(delay:Number, repeatCount:Number = 0):void
        {

            super();



            _delay = delay;
            _repeatCount = repeatCount;

            if (isNaN(delay) || delay < 0)
            {
                throw new away.errors.Error("Delay is negative or not a number");
            }

        }

        public function get currentCount():Number
        {

            return _currentCount;

        }

        public function get delay():Number
        {

            return _delay;

        }

        public function set delay(value:Number):void
        {

            _delay = value;

            if (_running)
            {
                stop();
                start();
            }

        }

        public function get repeatCount():Number
        {

            return _repeatCount;
        }

        public function set repeatCount(value:Number):void
        {

            _repeatCount = value;
        }

        public function reset():void
        {

            if (_running)
            {
                stop();
            }

            _currentCount = 0;

        }

        public function get running():Boolean
        {

            return _running;

        }

        public function start():void
        {

            _running = true;
            Window.clearInterval( _iid );
            _iid = Window.setInterval( tick , _delay );

        }

        public function stop():void
        {

            _running = false;
            Window.clearInterval( _iid );

        }

        private function tick():void
        {

            _currentCount ++;

            if ( ( _repeatCount > 0 ) && _currentCount >= _repeatCount)
            {

                stop();
                dispatchEvent( new TimerEvent( TimerEvent.TIMER ) );
                dispatchEvent( new TimerEvent( TimerEvent.TIMER_COMPLETE ) );

            }
            else
            {

                dispatchEvent( new TimerEvent( TimerEvent.TIMER ) );

            }

        }
    }
}
