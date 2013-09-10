///<reference path="../_definitions.ts"/>

package away.pick
{
	import away.traverse.RaycastCollector;
	import away.entities.Entity;
	import away.containers.View3D;
	import away.traverse.EntityCollector;
	import away.geom.Vector3D;
	import away.data.EntityListItem;
	import away.containers.Scene3D;

	/**	 * Picks a 3d object from a view or scene by 3D raycast calculations.	 * Performs an initial coarse boundary calculation to return a subset of entities whose bounding volumes intersect with the specified ray,	 * then triggers an optional picking collider on individual entity objects to further determine the precise values of the picking ray collision.	 */

	public class RaycastPicker implements IPicker
	{
		private var _findClosestCollision:Boolean;
		private var _raycastCollector:RaycastCollector = new RaycastCollector ();
		private var _ignoredEntities:Array = new Array();
		private var _onlyMouseEnabled:Boolean = true;
		
		private var _entities:Vector.<Entity>;//Vector.<Entity>;		private var _numEntities:Number = 0;
		private var _hasCollisions:Boolean;
		
		/**		 * @inheritDoc		 */
		public function get onlyMouseEnabled():Boolean
		{
			return _onlyMouseEnabled;
		}
		
		public function set onlyMouseEnabled(value:Boolean):void
		{
			_onlyMouseEnabled = value;
		}
		
		/**		 * Creates a new <code>RaycastPicker</code> object.		 *		 * @param findClosestCollision Determines whether the picker searches for the closest bounds collision along the ray,		 * or simply returns the first collision encountered Defaults to false.		 */
		public function RaycastPicker(findClosestCollision:Boolean):void
		{
			
			_findClosestCollision = findClosestCollision;
            _entities = new Vector.<Entity>();//Vector.<Entity>();
		}
		
		/**		 * @inheritDoc		 */

		public function getViewCollision(x:Number, y:Number, view:View3D):PickingCollisionVO
		{

			//cast ray through the collection of entities on the view
			var collector:EntityCollector = view.iEntityCollector;
			//var i:number;
			
			if (collector.numMouseEnableds == 0)
				return null;
			
			//update ray
			var rayPosition:Vector3D = view.unproject(x, y, 0);
			var rayDirection:Vector3D = view.unproject(x, y, 1);
			rayDirection = rayDirection.subtract(rayPosition);
			
			// Perform ray-bounds collision checks.
			_numEntities = 0;
			var node:EntityListItem = collector.entityHead;
			var entity:Entity;
			while (node)
            {
				entity = node.entity;
				
				if (isIgnored(entity)) {
					node = node.next;
					continue;
				}
				
				// If collision detected, store in new data set.
				if (entity._iIsVisible && entity.isIntersectingRay(rayPosition, rayDirection))
					_entities[_numEntities++] = entity;
				
				node = node.next;
			}
			
			//early out if no collisions detected
			if (!_numEntities)
				return null;
			
			return getPickingCollisionVO();

		}
		//*/
		/**		 * @inheritDoc		 */

        //* TODO Implement Dependency: EntityListItem, EntityCollector, RaycastCollector
		public function getSceneCollision(position:Vector3D, direction:Vector3D, scene:Scene3D):PickingCollisionVO
		{

			//clear collector
			_raycastCollector.clear();
			
			//setup ray vectors
            _raycastCollector.rayPosition = position;
            _raycastCollector.rayDirection = direction;
			
			// collect entities to test
			scene.traversePartitions(_raycastCollector);

            _numEntities = 0;
			var node:EntityListItem = _raycastCollector.entityHead;
			var entity:Entity;

			while (node)
            {
				entity = node.entity;
				
				if (isIgnored(entity))
                {
					node = node.next;
					continue;
				}
				
				_entities[_numEntities++] = entity;
				
				node = node.next;
			}
			
			//early out if no collisions detected
			if (!_numEntities)
				return null;
			
			return getPickingCollisionVO();

		}
		//*/
		public function getEntityCollision(position:Vector3D, direction:Vector3D, entities:Vector.<Entity>):PickingCollisionVO
		{


			position = position; // TODO: remove ?
			direction = direction;

			_numEntities = 0;
			
			var entity:Entity;
            var l : Number = entities.length;


            for ( var c : Number = 0 ; c < l ; c ++ )
            {

                entity = entities[c];

                if (entity.isIntersectingRay(position, direction))
                {

                    _entities[_numEntities++] = entity;

                }


            }

			return getPickingCollisionVO();

		}
		//*/
		public function setIgnoreList(entities):void
		{
			_ignoredEntities = entities;
		}
		
		private function isIgnored(entity:Entity):Boolean
		{
			if (_onlyMouseEnabled && (!entity._iAncestorsAllowMouseEnabled || !entity.mouseEnabled))
            {

                return true;

            }

			
			var ignoredEntity:Entity;

            var l : Number = _ignoredEntities.length;

            for ( var c : Number = 0 ; c < l ; c ++ )
            {

                ignoredEntity = _ignoredEntities[ c ];

                if (ignoredEntity == entity)
                {

                    return true;

                }

            }

			return false;

		}
		
		private function sortOnNearT(entity1:Entity, entity2:Entity):Number
		{
			return entity1.pickingCollisionVO.rayEntryDistance > entity2.pickingCollisionVO.rayEntryDistance? 1 : -1;
		}
		
		private function getPickingCollisionVO():PickingCollisionVO
		{
			// trim before sorting
			_entities.length = _numEntities;
			
			// Sort entities from closest to furthest.
			_entities = _entities.sort(sortOnNearT); // TODO - test sort filter in JS
			
			// ---------------------------------------------------------------------
			// Evaluate triangle collisions when needed.
			// Replaces collision data provided by bounds collider with more precise data.
			// ---------------------------------------------------------------------
			
			var shortestCollisionDistance:Number = Number.MAX_VALUE;
			var bestCollisionVO:PickingCollisionVO;
			var pickingCollisionVO:PickingCollisionVO;
			var entity:Entity;
			var i:Number;
			
			for (i = 0; i < _numEntities; ++i) {
				entity = _entities[i];
				pickingCollisionVO = entity._iPickingCollisionVO;
				if (entity.pickingCollider) {
					// If a collision exists, update the collision data and stop all checks.
					if ((bestCollisionVO == null || pickingCollisionVO.rayEntryDistance < bestCollisionVO.rayEntryDistance) && entity.iCollidesBefore(shortestCollisionDistance, _findClosestCollision)) {
						shortestCollisionDistance = pickingCollisionVO.rayEntryDistance;
						bestCollisionVO = pickingCollisionVO;
						if (!_findClosestCollision) {
							updateLocalPosition(pickingCollisionVO);
							return pickingCollisionVO;
						}
					}
				} else if (bestCollisionVO == null || pickingCollisionVO.rayEntryDistance < bestCollisionVO.rayEntryDistance) { // A bounds collision with no triangle collider stops all checks.
					// Note: a bounds collision with a ray origin inside its bounds is ONLY ever used
					// to enable the detection of a corresponsding triangle collision.
					// Therefore, bounds collisions with a ray origin inside its bounds can be ignored
					// if it has been established that there is NO triangle collider to test
					if (!pickingCollisionVO.rayOriginIsInsideBounds) {
						updateLocalPosition(pickingCollisionVO);
						return pickingCollisionVO;
					}
				}
			}
			
			return bestCollisionVO;
		}
		
		private function updateLocalPosition(pickingCollisionVO:PickingCollisionVO):void
		{

            var collisionPos:Vector3D = ( pickingCollisionVO.localPosition == null ) ? new Vector3D() : pickingCollisionVO.localPosition;
            //var collisionPos:away.geom.Vector3D = pickingCollisionVO.localPosition ||= new away.geom.Vector3D();

			var rayDir:Vector3D = pickingCollisionVO.localRayDirection;
			var rayPos:Vector3D = pickingCollisionVO.localRayPosition;
			var t:Number = pickingCollisionVO.rayEntryDistance;
			collisionPos.x = rayPos.x + t*rayDir.x;
			collisionPos.y = rayPos.y + t*rayDir.y;
			collisionPos.z = rayPos.z + t*rayDir.z;
		}
		
		public function dispose():void
		{
		}
	}
}
