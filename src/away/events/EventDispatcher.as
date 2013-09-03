/*

///<reference path="../_definitions.ts"/>

/**
package away.events {

    /**
    public class EventDispatcher{

        private var listeners:Vector.<Object> = new Vector.<Object>();
        private var lFncLength:Number;

        /**
        public function addEventListener(type:String, listener:Function, target:Object):void {
        
            if ( listeners[ type ] === undefined ) {

                listeners[ type ] = new Vector.<EventData>();

            }

            if ( getEventListenerIndex( type , listener , target ) === -1 ) {

                var d : EventData   = new EventData();
                    d.listener      = listener;
                    d.type          = type;
                    d.target        = target;

                listeners[ type ].push( d );

            }

        }
        /**
        public function removeEventListener(type:String, listener:Function, target:Object):void {
        
            var index : Number = getEventListenerIndex( type , listener , target );

            if ( index !== - 1 ) {

                listeners[ type ].splice( index, 1 );

            }

        }
        /**
        public function dispatchEvent(event:Event):void {
        
            var listenerArray : Vector.<EventData> = Vector.<EventData>(listeners[ event.type ]);

            if (listenerArray != null) {

                lFncLength     = listenerArray.length;
                event.target        = this;

                var eventData : EventData;

                for ( var i:int = 0; i < lFncLength; ++i ) {

                    eventData = listenerArray[i];
                    eventData.listener.call( eventData.target , event );

                }
            }

        }
        /**
        private function getEventListenerIndex(type:String, listener:Function, target:Object):Number {
        
            if ( listeners[ type ] !== undefined ) {

                var a : Vector.<EventData> = Vector.<EventData>(listeners[ type ]);
                var l : Number = a.length;
                var d : EventData;

                for ( var c : Number = 0 ; c < l ; c ++ ){

                    d = a[c];

                    if ( target == d.target && listener == d.listener ){

                        return c;

                    }

                }


            }

            return -1;

        }
        /**

        //todo: hasEventListener - relax check by not requiring target in param

        public function hasEventListener(type:String, listener:Function = null, target:Object = null):Boolean {
        
            if ( listeners != null && target != null )
            {

                return ( getEventListenerIndex( type, listener , target ) !== -1 ) ;

            }
            else
            {

                if ( listeners[ type ] !== undefined )
                {

                    var a : Vector.<EventData> = Vector.<EventData>(listeners[ type ]);
                    return ( a.length > 0 );

                }

                return false;


            }

           return false;

        }



    }
   

}