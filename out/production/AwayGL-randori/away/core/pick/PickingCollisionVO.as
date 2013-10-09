/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package away.core.pick
{
	import away.entities.Entity;
	import away.core.geom.Vector3D;
	import away.core.geom.Point;
	import away.core.base.IRenderable;

	/**	 * Value object for a picking collision returned by a picking collider. Created as unique objects on entities	 *	 * @see away3d.entities.Entity#pickingCollisionVO	 * @see away3d.core.pick.IPickingCollider	 */
	public class PickingCollisionVO
	{
		/**		 * The entity to which this collision object belongs.		 */
		public var entity:Entity;
		
		/**		 * The local position of the collision on the entity's surface.		 */
		public var localPosition:Vector3D;
		
		/**		 * The local normal vector at the position of the collision.		 */
		public var localNormal:Vector3D;
		
		/**		 * The uv coordinate at the position of the collision.		 */
		public var uv:Point;
		
		/**		 * The index of the face where the event took pl ace.		 */
		public var index:Number = 0;
		
		/**		 * The index of the subGeometry where the event took place.		 */
		public var subGeometryIndex:Number = 0;
		
		/**		 * The starting position of the colliding ray in local coordinates.		 */
		public var localRayPosition:Vector3D;
		
		/**		 * The direction of the colliding ray in local coordinates.		 */
		public var localRayDirection:Vector3D;
		
		/**		 * The starting position of the colliding ray in scene coordinates.		 */
		public var rayPosition:Vector3D;
		
		/**		 * The direction of the colliding ray in scene coordinates.		 */
		public var rayDirection:Vector3D;
		
		/**		 * Determines if the ray position is contained within the entity bounds.		 *		 * @see away3d.entities.Entity#bounds		 */
		public var rayOriginIsInsideBounds:Boolean = false;
		
		/**		 * The distance along the ray from the starting position to the calculated intersection entry point with the entity.		 */
		public var rayEntryDistance:Number = 0;
		
		/**		 * The IRenderable associated with a collision.		 */
		public var renderable:IRenderable;
		
		/**		 * Creates a new <code>PickingCollisionVO</code> object.		 *		 * @param entity The entity to which this collision object belongs.		 */
		public function PickingCollisionVO(entity:Entity):void
		{
			this.entity = entity;
		}
	
	}
}
