/**
 * ...
 * @author Gary Paluk - http://www.plugin.io
 */
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
			_rootNode = rootNode || (new NullNode() as NodeBase);
		}
		
		public function get showDebugBounds():Boolean
		{
			return _rootNode.showDebugBounds;
		}
		
		public function set showDebugBounds(value:Boolean):void
		{
			_rootNode.showDebugBounds = value;
		}
		
		public function traverse(traverser:PartitionTraverser):void
		{

			if( _updatesMade )
			{
				updateEntities();
			}
			++PartitionTraverser._iCollectionMark;
			_rootNode.acceptTraverser( traverser );
		}
		
		public function iMarkForUpdate(entity:Entity):void
		{
			var node:EntityNode = entity.getEntityPartitionNode();
			var t:EntityNode = _updateQueue;
			
			while( t )
			{
				if ( node == t )
				{
					return;
				}
				t = t._iUpdateQueueNext;
			}
			
			node._iUpdateQueueNext = _updateQueue;
			
			_updateQueue = node;
			_updatesMade = true;
		}
		
		public function iRemoveEntity(entity:Entity):void
		{
			var node:EntityNode = entity.getEntityPartitionNode();
			var t:EntityNode;
			
			node.removeFromParent();
			
			if( node == _updateQueue )
			{
				_updateQueue = node._iUpdateQueueNext;
			}
			else
			{
				t = _updateQueue;
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
			
			if ( !_updateQueue )
			{
				_updatesMade = false;
			}
		}
		
		private function updateEntities():void
		{



			var node:EntityNode = _updateQueue;
			var targetNode:NodeBase;
			var t:EntityNode;
			_updateQueue = null;
			_updatesMade = false;

            //console.log( 'Partition3D' , 'updateEntities')

			do {

				targetNode = _rootNode.findPartitionForEntity(node.entity);

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