///<reference path="../../_definitions.ts"/>

package away.library.assets
{
	import away.events.IEventDispatcher;
	//import flash.events.IEventDispatcher;

	public interface IAsset extends IEventDispatcher
	{

		function get name():String; // GET SET
		function assetPathEquals(name:String, ns:String):Boolean;
		function resetAssetPath(name:String, ns:String = null, overrideOriginal:Boolean = true):void;
		function dispose():void;

	}
}