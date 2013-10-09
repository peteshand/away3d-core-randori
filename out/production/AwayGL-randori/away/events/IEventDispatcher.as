/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

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