/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package away.containers
{
	import away.events.EventDispatcher;
	import away.partition.Partition3D;
	import away.partition.NodeBase;
	import away.traverse.PartitionTraverser;
	import away.events.Scene3DEvent;
	import away.entities.Entity;
	public class Scene3D extends EventDispatcher
	{
		
		public var _iSceneGraphRoot:ObjectContainer3D;
		private var _partitions:Vector.<Partition3D>;
		
		public function Scene3D():void
		{
			super();
			this._partitions = new <Partition3D>[];
			this._iSceneGraphRoot = new ObjectContainer3D();
			
			this._iSceneGraphRoot.scene = this;
			this._iSceneGraphRoot._iIsRoot = true;
			this._iSceneGraphRoot.partition = new Partition3D( new NodeBase() );
		}
		
		public function traversePartitions(traverser:PartitionTraverser):void
		{
			var i:Number = 0;
			var len:Number = this._partitions.length;


            //console.log( 'Scene3D.traversePartitions' , len );

			traverser.scene = this;
			
			while (i < len)
			{
				this._partitions[i++].traverse( traverser );
			}
		}
		
		public function get partition():Partition3D
		{
			return this._iSceneGraphRoot.partition;
		}
		
		public function set partition(value:Partition3D):void
		{

            //console.log( 'scene3D.setPartition' , value );

			this._iSceneGraphRoot.partition = value;
			this.dispatchEvent( new Scene3DEvent( Scene3DEvent.PARTITION_CHANGED, this._iSceneGraphRoot ) );
		}
		
		public function contains(child:ObjectContainer3D):Boolean
		{
			return this._iSceneGraphRoot.contains( child );
		}
		
		public function addChild(child:ObjectContainer3D):ObjectContainer3D
		{
			return this._iSceneGraphRoot.addChild( child );
		}
		
		public function removeChild(child:ObjectContainer3D):void
		{
			this._iSceneGraphRoot.removeChild( child );
		}

		public function removeChildAt(index:Number):void
		{
			this._iSceneGraphRoot.removeChildAt( index );
		}

		
		public function getChildAt(index:Number):ObjectContainer3D
		{
			return this._iSceneGraphRoot.getChildAt( index );
		}
		
		public function get numChildren():Number
		{
			return this._iSceneGraphRoot.numChildren;
		}

		public function iRegisterEntity(entity:Entity):void
		{


            //console.log( 'Scene3D' , 'iRegisterEntity' , entity._pImplicitPartition );

			var partition:Partition3D = entity.iGetImplicitPartition();

            //console.log( 'scene3D.iRegisterEntity' , entity , entity.iImplicitPartition , partition );

			this.iAddPartitionUnique( partition );
			this.partition.iMarkForUpdate( entity );



		}

		public function iUnregisterEntity(entity:Entity):void
		{
			entity.iGetImplicitPartition().iRemoveEntity( entity );
		}

		public function iInvalidateEntityBounds(entity:Entity):void
		{
            entity.iGetImplicitPartition().iMarkForUpdate( entity );
		}

		public function iRegisterPartition(entity:Entity):void
		{
			this.iAddPartitionUnique( entity.iGetImplicitPartition() );
		}

		public function iUnregisterPartition(entity:Entity):void
		{
			entity.iGetImplicitPartition().iRemoveEntity( entity );
		}

		public function iAddPartitionUnique(partition:Partition3D):void
		{

            //console.log( 'scene3D.iAddPartitionUnique' , partition );

			if (this._partitions.indexOf(partition) == -1)
			{
				this._partitions.push( partition );
			}

		}

	}
}