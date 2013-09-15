///<reference path="../_definitions.ts"/>

/** * @module away.events */
package away.events
{
	//import flash.events.Event;

	public class ParserEvent extends Event
	{
		private var _message:String;
		
		/** 		 * Dispatched when parsing of an asset completed.		*/
		public static var PARSE_COMPLETE:String = 'parseComplete';
		
		/**		 * Dispatched when an error occurs while parsing the data (e.g. because it's		 * incorrectly formatted.)		*/
		public static var PARSE_ERROR:String = 'parseError';
		
		
		/**		 * Dispatched when a parser is ready to have dependencies retrieved and resolved.		 * This is an internal event that should rarely (if ever) be listened for by		 * external classes.		*/
		public static var READY_FOR_DEPENDENCIES:String = 'readyForDependencies';
		
		
		public function ParserEvent(type:String, message:String = ''):void
		{
			super(type);
			
			this._message = message;
		}
		
		
		/**		 * Additional human-readable message. Usually supplied for ParserEvent.PARSE_ERROR events.		*/
		public function get message():String
		{
			return this._message;
		}
		
		
		override public function clone():Event
		{
			return new ParserEvent( this.type , this.message );
		}
	}
}