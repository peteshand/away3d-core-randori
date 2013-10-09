/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package away.core.pick
{
	
	/**	 * Options for setting a picking collider for entity objects. Used with the <code>RaycastPicker</code> picking object.	 *	 * @see away3d.entities.Entity#pickingCollider	 * @see away3d.core.pick.RaycastPicker	 */
	public class PickingColliderType
	{
		/**		 * Default null collider that forces picker to only use entity bounds for hit calculations on an Entity		 */
		public static var BOUNDS_ONLY:IPickingCollider = null;
		
		/**		 * Pure AS3 picking collider that returns the first encountered hit on an Entity. Useful for low poly meshes and applying to many mesh instances.		 *		 * @see away3d.core.pick.AS3PickingCollider		 */
		public static var AS3_FIRST_ENCOUNTERED:IPickingCollider = new AS3PickingCollider(false);
		
		/**		 * Pure AS3 picking collider that returns the best (closest) hit on an Entity. Useful for low poly meshes and applying to many mesh instances.		 *		 * @see away3d.core.pick.AS3PickingCollider		 */
		public static var AS3_BEST_HIT:IPickingCollider = new AS3PickingCollider(true);
	}
}
