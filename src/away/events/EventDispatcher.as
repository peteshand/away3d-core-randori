/* * Author: mr.doob / https://github.com/mrdoob/eventdispatcher.js/ * TypeScript Conversion : Karim Beyrouti ( karim@kurst.co.uk ) */

///<reference path="../_definitions.ts"/>

/** * @module kurst.events */
package away.events {

    /**     * Base class for dispatching events     *     * @class kurst.events.EventDispatcher     *     */
    public class EventDispatcher{

        private var listeners:Vector.<Object> = new Vector.<Object>();
        private var lFncLength:Number;

        /**         * Add an event listener         * @method addEventListener         * @param {String} Name of event to add a listener for         * @param {Function} Callback function         * @param {Object} Target object listener is added to         */
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
        /**         * Remove an event listener         * @method removeEventListener         * @param {String} Name of event to remove a listener for         * @param {Function} Callback function         * @param {Object} Target object listener is added to         */
        public function removeEventListener(type:String, listener:Function, target:Object):void {
        
            var index : Number = getEventListenerIndex( type , listener , target );

            if ( index !== - 1 ) {

                listeners[ type ].splice( index, 1 );

            }

        }
        /**         * Dispatch an event         * @method dispatchEvent         * @param {Event} Event to dispatch         */
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
        /**         * get Event Listener Index in array. Returns -1 if no listener is added         * @method getEventListenerIndex         * @param {String} Name of event to remove a listener for         * @param {Function} Callback function         * @param {Object} Target object listener is added to         */
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
        /**         * check if an object has an event listener assigned to it         * @method hasListener         * @param {String} Name of event to remove a listener for         * @param {Function} Callback function         * @param {Object} Target object listener is added to         */

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