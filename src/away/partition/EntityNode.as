/** * ... * @author Gary Paluk - http://www.plugin.io */

///<reference path="../_definitions.ts" />

package away.partition
{
	import away.entities.Entity;
	import away.math.Plane3D;
	import away.traverse.PartitionTraverser;
	import away.geom.Vector3D;
	public class EntityNode extends NodeBase
	{
		
		private var _entity:Entity;
		public var _iUpdateQueueNext:EntityNode;
		
		public function EntityNode(entity:Entity):void
		{
			super();
			_entity = entity;
			_iNumEntities = 1;
		}
		
		public function get entity():Entity
		{
			return _entity;
		}
		
		public function removeFromParent():void
		{
			if( _iParent)
			{
				_iParent.iRemoveNode( this );
			}
			_iParent = null;
		}
		
		//@override
		override public function isInFrustum(planes:Vector.<Plane3D>, numPlanes:Number):Boolean
		{
			if( !_entity._iIsVisible )
			{
				return false;
			}
			return _entity.worldBounds.isInFrustum( planes, numPlanes );
		}

        /**         * @inheritDoc         */
        override public function acceptTraverser(traverser:PartitionTraverser):void
        {
            traverser.applyEntity(_entity);
        }

        /**         * @inheritDoc         */
        override public function isIntersectingRay(rayPosition:Vector3D, rayDirection:Vector3D):Boolean
        {
            if (!_entity._iIsVisible )
                return false;

            return _entity.isIntersectingRay(rayPosition, rayDirection);
        }


	}
}