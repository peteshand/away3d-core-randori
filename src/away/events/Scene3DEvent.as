/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package away.events 
{
	import away.containers.ObjectContainer3D;
	
	public class Scene3DEvent extends Event
	{
		public static var ADDED_TO_SCENE:String = "addedToScene";
		public static var REMOVED_FROM_SCENE:String = "removedFromScene";
		public static var PARTITION_CHANGED:String = "partitionChanged";
		
		public var objectContainer3D:ObjectContainer3D;
		
		public function Scene3DEvent(type:String, objectContainer:ObjectContainer3D):void
		{
			this.target = objectContainer;
			super( type );
		}
		
	}
}