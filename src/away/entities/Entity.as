/** * ... * @author Gary Paluk - http://www.plugin.io */

///<reference path="../_definitions.ts"/>


package away.entities
{
	import away.containers.ObjectContainer3D;
	import away.partition.EntityNode;
	import away.pick.PickingCollisionVO;
	import away.pick.IPickingCollider;
	import away.bounds.BoundingVolumeBase;
	import away.partition.Partition3D;
	import away.containers.Scene3D;
	import away.library.assets.AssetType;
	import away.geom.Vector3D;
	import away.errors.AbstractMethodError;
	import away.bounds.AxisAlignedBoundingBox;
	
	public class Entity extends ObjectContainer3D
	{
		
		private var _showBounds:Boolean;
		private var _partitionNode:EntityNode;
		private var _boundsIsShown:Boolean;
		private var _shaderPickingDetails:Boolean;
		
		public var _iPickingCollisionVO:PickingCollisionVO;
		public var _iPickingCollider:IPickingCollider;
		public var _iStaticNode:Boolean;
		
		public var _pBounds:BoundingVolumeBase;
		public var _pBoundsInvalid:Boolean = true;
		private var _worldBounds:BoundingVolumeBase;
		private var _worldBoundsInvalid:Boolean = true;
		
		public function Entity():void
		{
			super();
			this._pBounds = this.pGetDefaultBoundingVolume();

            //console.log( "Entity() - Bounds:" , this._pBounds );

			this._worldBounds = this.pGetDefaultBoundingVolume();
		}

		//@override
		override public function setIgnoreTransform(value:Boolean):void
		{
			if( _pScene )
			{
				_pScene.iInvalidateEntityBounds( this );
			}
			super.setIgnoreTransform( value );
		}
		
		public function get shaderPickingDetails():Boolean
		{
			return _shaderPickingDetails;
		}
		
		public function get staticNode():Boolean
		{
			return _iStaticNode;
		}
		
		public function set staticNode(value:Boolean):void
		{
			this._iStaticNode = value;
		}
		
		public function get pickingCollisionVO():PickingCollisionVO
		{
			if ( !_iPickingCollisionVO )
			{
				_iPickingCollisionVO = new PickingCollisionVO( this );
			}
			return _iPickingCollisionVO;
		}
		
		public function iCollidesBefore(shortestCollisionDistance:Number, findClosest:Boolean):Boolean
		{
			shortestCollisionDistance = shortestCollisionDistance;
			findClosest = findClosest;
			return true;
		}
		
		public function get showBounds():Boolean
		{
			return _showBounds;
		}
		
		public function set showBounds(value:Boolean):void
		{
			if (value == this._showBounds)
			{
				return;
			}
			this._showBounds = value;
			
			if (this._showBounds)
			{
				this.addBounds();
			}
			else
			{
				this.removeBounds();
			}
		}
		
		//@override
		override public function get minX():Number
		{
			if( _pBoundsInvalid )
			{
				pUpdateBounds();
			}
			return _pBounds.min.x;
		}
		
		//@override
		override public function get minY():Number
		{
			if( _pBoundsInvalid )
			{
				pUpdateBounds();
			}
			return _pBounds.min.y;
		}
		
		//@override
		override public function get minZ():Number
		{
			if(_pBoundsInvalid )
			{
				pUpdateBounds();
			}
			return _pBounds.min.z;
		}
		
		//@override
		override public function get maxX():Number
		{
			if( _pBoundsInvalid )
			{
				pUpdateBounds();
			}
			return _pBounds.max.x;
		}
		
		//@override
		override public function get maxY():Number
		{
			if( _pBoundsInvalid )
			{
				pUpdateBounds();
			}
			return _pBounds.max.y;
		}
		
		//@override
		override public function get maxZ():Number
		{
			if( _pBoundsInvalid )
			{
				pUpdateBounds();
			}
			return _pBounds.max.z;
		}

        public function getBounds():BoundingVolumeBase
        {
            if ( _pBoundsInvalid )
            {
                pUpdateBounds();
            }
            return _pBounds;
        }

        public function get bounds():BoundingVolumeBase
        {

            return getBounds();
        }
		
		public function set bounds(value:BoundingVolumeBase):void
		{
			this.removeBounds();
			this._pBounds = value;
			this._worldBounds = value.clone();
			this.pInvalidateBounds();
			if( this._showBounds )
			{
				this.addBounds();
			}
		}
		
		public function get worldBounds():BoundingVolumeBase
		{
			if( _worldBoundsInvalid )
			{
				updateWorldBounds();
			}
			return _worldBounds;
		}
		
		private function updateWorldBounds():void
		{
			_worldBounds.transformFrom( getBounds() , sceneTransform );
			_worldBoundsInvalid = false;
		}

        //@override
        /*        public set iImplicitPartition( value:away.partition.Partition3D )        {          */  /*            if( value == this._pImplicitPartition )            {                return;            }            if( this._pImplicitPartition )            {                this.notifyPartitionUnassigned();            }            super.iSetImplicitPartition( value );            this.notifyPartitionAssigned();            */
/*            this.iSetImplicitPartition( value );        }*/
        //@override
        override public function iSetImplicitPartition(value:Partition3D):void
        {

            //console.log( 'Entity' , 'iSetImplicitPartition' , value , 'this._pImplicitPartition' , this._pImplicitPartition , '==' , ( this._pImplicitPartition ==  value ));

            if( value == _pImplicitPartition )
            {
                return;
            }

            if( _pImplicitPartition )
            {
                notifyPartitionUnassigned();
            }

            super.iSetImplicitPartition( value );
            notifyPartitionAssigned();

        }

		//@override
		override public function set scene(value:Scene3D):void
		{
			if(value == this._pScene)
			{
				return;
			}
			if( this._pScene)
			{
				this._pScene.iUnregisterEntity( this );
			}
			// callback to notify object has been spawned. Casts to please FDT
			if ( value )
			{
				value.iRegisterEntity(this);
			}

			super.setScene ( value ) ;
		}

		 
		//@override 
		override public function get assetType():String
		{
			return AssetType.ENTITY;
		}
		
		public function get pickingCollider():IPickingCollider
		{
			return _iPickingCollider;
		}

        public function set pickingCollider(value:IPickingCollider):void
        {
            this.setPickingCollider( value );
        }

        public function setPickingCollider(value:IPickingCollider):void
        {
            _iPickingCollider = value;
        }


		
		public function getEntityPartitionNode():EntityNode
		{
			if( !_partitionNode )
			{
				_partitionNode = pCreateEntityPartitionNode()
			}
			return _partitionNode;
		}
		
		public function isIntersectingRay(rayPosition:Vector3D, rayDirection:Vector3D):Boolean
		{
			var localRayPosition:Vector3D = inverseSceneTransform.transformVector( rayPosition );
			var localRayDirection:Vector3D = inverseSceneTransform.deltaTransformVector( rayDirection );


			if( !_iPickingCollisionVO.localNormal )
			{
                _iPickingCollisionVO.localNormal = new Vector3D()
			}


			var rayEntryDistance:Number = _pBounds.rayIntersection(localRayPosition, localRayDirection, _iPickingCollisionVO.localNormal );
			
			if( rayEntryDistance < 0 )
			{
				return false;
			}

            _iPickingCollisionVO.rayEntryDistance = rayEntryDistance;
            _iPickingCollisionVO.localRayPosition = localRayPosition;
            _iPickingCollisionVO.localRayDirection = localRayDirection;
            _iPickingCollisionVO.rayPosition = rayPosition;
            _iPickingCollisionVO.rayDirection = rayDirection;
            _iPickingCollisionVO.rayOriginIsInsideBounds = rayEntryDistance == 0;
			
			return true;
		}

		public function pCreateEntityPartitionNode():EntityNode
		{
			throw new AbstractMethodError();
		}
		
		public function pGetDefaultBoundingVolume():BoundingVolumeBase
		{
			// point lights should be using sphere bounds
			// directional lights should be using null bounds
			return new AxisAlignedBoundingBox();

		}
		
		public function pUpdateBounds():void
		{
			throw new AbstractMethodError();
		}
		
		override public function pInvalidateSceneTransform():void
		{
			if( !_pIgnoreTransform )
			{
				super.pInvalidateSceneTransform();
				_worldBoundsInvalid = true;
				notifySceneBoundsInvalid();
			}
		}
		
		public function pInvalidateBounds():void
		{
			_pBoundsInvalid = true;
			_worldBoundsInvalid = true;
			notifySceneBoundsInvalid();
		}
		
		override public function pUpdateMouseChildren():void
		{
			// If there is a parent and this child does not have a triangle collider, use its parent's triangle collider.

			if( _pParent && !pickingCollider )
			{

				if ( _pParent instanceof Entity ) //if( this._pParent is Entity ) { // TODO: Test / validate
                {

                    var parentEntity : Entity =  Entity(_pParent);

					var collider:IPickingCollider = parentEntity.pickingCollider;
					if(collider)
                    {

                        pickingCollider = collider;

                    }

				}
			}
			
			super.pUpdateMouseChildren();
		}

		private function notifySceneBoundsInvalid():void
		{
			if( _pScene )
			{
				_pScene.iInvalidateEntityBounds( this );
			}
		}
		
		private function notifyPartitionAssigned():void
		{
			if( _pScene)
			{
				_pScene.iRegisterPartition( this ); //_onAssignPartitionCallback(this);
			}
		}
		
		private function notifyPartitionUnassigned():void
		{
			if( _pScene )
			{
				_pScene.iUnregisterPartition( this );
			}
		}
		
		private function addBounds():void
		{
			if ( !_boundsIsShown )
			{
				_boundsIsShown = true;
				addChild( _pBounds.boundingRenderable );
			}
		}
		
		private function removeBounds():void
		{
			if( !_boundsIsShown )
			{
				_boundsIsShown = false;
				removeChild( _pBounds.boundingRenderable );
				_pBounds.disposeRenderable();
			}
		}
		
		public function iInternalUpdate():void
		{

			if( _iController )
			{
				_iController.update();
			}

		}
	}
}