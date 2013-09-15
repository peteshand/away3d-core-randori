package away.events 
{
	public interface IEventDispatcher
	{
		function addEventListener(type:String, listener:Function, target:Object):void;
        function removeEventListener(type:String, listener:Function, target:Object):void;
        function dispatchEvent(event:Event):void;
        function hasEventListener(type:String, listener:Function = null, target:Object = null):Boolean;
    }
}