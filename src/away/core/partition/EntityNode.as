/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package away.core.partition
{
	import away.entities.Entity;
	import away.core.math.Plane3D;
	import away.core.traverse.PartitionTraverser;
	import away.core.geom.Vector3D;
	public class EntityNode extends NodeBase
	{
		
		private var _entity:Entity;
		public var _iUpdateQueueNext:EntityNode;
		
		public function EntityNode(entity:Entity):void
		{
			super();
			this._entity = entity;
			this._iNumEntities = 1;
		}
		
		public function get entity():Entity
		{
			return this._entity;
		}
		
		public function removeFromParent():void
		{
			if( this._iParent)
			{
				this._iParent.iRemoveNode( this );
			}
			this._iParent = null;
		}
		
		//@override
		override public function isInFrustum(planes:Vector.<Plane3D>, numPlanes:Number):Boolean
		{
			if( !this._entity._iIsVisible )
			{
				return false;
			}
			return this._entity.worldBounds.isInFrustum( planes, numPlanes );
		}

        /**         * @inheritDoc         */
        override public function acceptTraverser(traverser:PartitionTraverser):void
        {
            traverser.applyEntity(this._entity);
        }

        /**         * @inheritDoc         */
        override public function isIntersectingRay(rayPosition:Vector3D, rayDirection:Vector3D):Boolean
        {
            if (!this._entity._iIsVisible )
                return false;

            return this._entity.isIntersectingRay(rayPosition, rayDirection);
        }


	}
}