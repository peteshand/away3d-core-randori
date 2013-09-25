/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package away.library.assets
{
	import away.events.IEventDispatcher;
	//import flash.events.IEventDispatcher;

	public interface IAsset extends IEventDispatcher
	{

		function get name():String; // GET SET		function set name(value:String):void; // GET SET		function get id():String; // GET SET		function set id(value:String):void; // GET SET		function get assetNamespace():String; // GET		function get assetType():String; // GET		function get assetFullPath():Vector.<String>; // GET		
		function assetPathEquals(name:String, ns:String):Boolean;
		function resetAssetPath(name:String, ns:String = null, overrideOriginal:Boolean = true):void;
		function dispose():void;

	}
}