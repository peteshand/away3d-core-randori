/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package away.events
{
	import away.base.ISubGeometry;

	/**	 * Dispatched to notify changes in a geometry object's state.	 *     * @class away.events.GeometryEvent	 * @see away3d.core.base.Geometry	 */
	public class GeometryEvent extends Event
	{
		/**		 * Dispatched when a SubGeometry was added from the dispatching Geometry.		 */
		public static var SUB_GEOMETRY_ADDED:String = "SubGeometryAdded";
		
		/**		 * Dispatched when a SubGeometry was removed from the dispatching Geometry.		 */
		public static var SUB_GEOMETRY_REMOVED:String = "SubGeometryRemoved";
		
		public static var BOUNDS_INVALID:String = "BoundsInvalid";
		
		private var _subGeometry:ISubGeometry;
		
		/**		 * Create a new GeometryEvent		 * @param type The event type.		 * @param subGeometry An optional SubGeometry object that is the subject of this event.		 */
		public function GeometryEvent(type:String, subGeometry:ISubGeometry = null):void
		{
			subGeometry = subGeometry || null;

			super( type ) //, false, false);
			this._subGeometry = subGeometry;
		}
		
		/**		 * The SubGeometry object that is the subject of this event, if appropriate.		 */
		public function get subGeometry():ISubGeometry
		{
			return this._subGeometry;
		}
		
		/**		 * Clones the event.		 * @return An exact duplicate of the current object.		 */
		override public function clone():Event
		{
			return new GeometryEvent( this.type , this._subGeometry );
		}
	}
}
