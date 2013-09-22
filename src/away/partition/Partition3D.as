/** * ... * @author Gary Paluk - http://www.plugin.io */

///<reference path="../_definitions.ts" />

package away.partition
{
	import away.traverse.PartitionTraverser;
	import away.entities.Entity;
	
	public class Partition3D
	{
		
		public var _rootNode:NodeBase;
		private var _updatesMade:Boolean = false;
		private var _updateQueue:EntityNode;
		
		public function Partition3D(rootNode:NodeBase):void
		{
			this._rootNode = rootNode || (new NullNode( ) as NodeBase);
		}
		
		public function get showDebugBounds():Boolean
		{
			return this._rootNode.showDebugBounds;
		}
		
		public function set showDebugBounds(value:Boolean):void
		{
			this._rootNode.showDebugBounds = value;
		}
		
		public function traverse(traverser:PartitionTraverser):void
		{

			if( this._updatesMade )
			{
				this.updateEntities();
			}
			++PartitionTraverser._iCollectionMark;
			this._rootNode.acceptTraverser( traverser );
		}
		
		public function iMarkForUpdate(entity:Entity):void
		{
			var node:EntityNode = entity.getEntityPartitionNode();
			var t:EntityNode = this._updateQueue;
			
			while( t )
			{
				if ( node == t )
				{
					return;
				}
				t = t._iUpdateQueueNext;
			}
			
			node._iUpdateQueueNext = this._updateQueue;
			
			this._updateQueue = node;
			this._updatesMade = true;
		}
		
		public function iRemoveEntity(entity:Entity):void
		{
			var node:EntityNode = entity.getEntityPartitionNode();
			var t:EntityNode;
			
			node.removeFromParent();
			
			if( node == this._updateQueue )
			{
				this._updateQueue = node._iUpdateQueueNext;
			}
			else
			{
				t = this._updateQueue;
				while( t && t._iUpdateQueueNext != node )
				{
					t = t._iUpdateQueueNext;
				}
				if( t )
				{
					t._iUpdateQueueNext = node._iUpdateQueueNext;
				}
			}
			
			node._iUpdateQueueNext = null;
			
			if ( !this._updateQueue )
			{
				this._updatesMade = false;
			}
		}
		
		private function updateEntities():void
		{



			var node:EntityNode = this._updateQueue;
			var targetNode:NodeBase;
			var t:EntityNode;
			this._updateQueue = null;
			this._updatesMade = false;

            //console.log( 'Partition3D' , 'updateEntities')

			do {

				targetNode = this._rootNode.findPartitionForEntity(node.entity);

                //console.log( 'Partition3D' , 'updateEntities' , 'targetNode: ' , targetNode );

				if (node.parent != targetNode)
				{
					if (node)
					{
						node.removeFromParent();
					}
					targetNode.iAddNode(node);
				}
				
				t = node._iUpdateQueueNext;
				node._iUpdateQueueNext = null;
				node.entity.iInternalUpdate();
				
			} while ((node = t) != null);
		}
		
	}
}