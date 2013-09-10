/*
 * Author: mr.doob / https://github.com/mrdoob/eventdispatcher.js/
 * TypeScript Conversion : Karim Beyrouti ( karim@kurst.co.uk )
 */
///<reference path="../_definitions.ts"/>

/**
 * @module kurst.events
 */
package away.events {

    
    /**
     * Event listener data container
     */
    public class EventData{

        public var listener:Function;
        public var target:Object;
        public var type:String;

    }

}