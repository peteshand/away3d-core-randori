/** * ... * @author Gary Paluk - http://www.plugin.io */

///<reference path="../_definitions.ts" />


package away.partition
{
	import away.primitives.WireframePrimitiveBase;
	import away.errors.PartialImplementationError;
	import away.math.Plane3D;
	import away.geom.Vector3D;
	import away.entities.Entity;
	import away.traverse.PartitionTraverser;
	public class NodeBase
	{

		public var _iParent:NodeBase;
		public var _pChildNodes:Vector.<NodeBase>;
		public var _pNumChildNodes:Number = 0;
		public var _pDebugPrimitive:WireframePrimitiveBase;
		
		public var _iNumEntities:Number = 0;
		public var _iCollectionMark:Number// = 0;		
		public function NodeBase():void
		{
			this._pChildNodes = new <NodeBase>[];
		}
		
		public function get showDebugBounds():Boolean
		{
			return this._pDebugPrimitive != null;
		}
		
		public function set showDebugBounds(value:Boolean):void
		{
			if( this._pDebugPrimitive && value == true )
			{
				return;
			}
			
			if( !this._pDebugPrimitive && value == false )
			{
				return;
			}
			
			if (value)
			{
				throw new PartialImplementationError();
				this._pDebugPrimitive = this.pCreateDebugBounds();
			}
			else
			{
				this._pDebugPrimitive.dispose();
				this._pDebugPrimitive = null;
			}
			
			for (var i:Number = 0; i < this._pNumChildNodes; ++i)
			{
				this._pChildNodes[i].showDebugBounds = value;
			}
		}
		
		public function get parent():NodeBase
		{
			return this._iParent;
		}
		
		public function iAddNode(node:NodeBase):void
		{
			node._iParent = this;
			this._iNumEntities += node._pNumEntities;
			this._pChildNodes[ this._pNumChildNodes++ ] = node;
			node.showDebugBounds = this._pDebugPrimitive != null;
			
			var numEntities:Number = node._pNumEntities;
			node = this;
			
			do
			{
				node._iNumEntities += numEntities;
			}
			while ((node = node._iParent) != null);
		}
		
		public function iRemoveNode(node:NodeBase):void
		{
			var index:Number = this._pChildNodes.indexOf(node);
			this._pChildNodes[index] = this._pChildNodes[--this._pNumChildNodes];
			this._pChildNodes.pop();
			
			var numEntities:Number = node._pNumEntities;
			node = this;
			
			do
			{
				node._pNumEntities -= numEntities;
			}
			while ((node = node._iParent) != null);
		}
		
		public function isInFrustum(planes:Vector.<Plane3D>, numPlanes:Number):Boolean
		{
            //console.log( 'NodeBase' , 'isInFrustum - should be true');

			planes = planes;
			numPlanes = numPlanes;
			return true;
		}
		
		public function isIntersectingRay(rayPosition:Vector3D, rayDirection:Vector3D):Boolean
		{
			rayPosition = rayPosition;
			rayDirection = rayDirection;
			return true;
		}
		
		public function findPartitionForEntity(entity:Entity):NodeBase
		{
			entity = entity;
			return this;
		}
		
		public function acceptTraverser(traverser:PartitionTraverser):void
		{

            //console.log( 'NodeBase' , '1 - acceptTraverser' , ( this._pNumEntities == 0 && !this._pDebugPrimitive ));

			if( this._pNumEntities == 0 && !this._pDebugPrimitive )
			{
				return;
			}

            //console.log( 'NodeBase' , '2 - acceptTraverser' , traverser , '_pNumEntities: ' + this._pNumEntities , '_pNumChildNodes: ' + this._pNumChildNodes);
            //console.log( 'NodeBase' , '2b- acceptTraverser' , ' traverser.enterNode( this ): ' ,  traverser.enterNode( this ) );

            //console.log( 'NodeBase' , this , ' traverser.enterNode( this )  : ', traverser.enterNode( this )  )

			if( traverser.enterNode( this ) )
			{

               // console.log ( 'NodeBase' , 'acceptTraverser (node entered) : ' , this )

				var i:Number = 0;

				while( i < this._pNumChildNodes )
				{

                    //console.log ( 'NodeBase' , 'loop through childNodes : ' , i );

					this._pChildNodes[i++].acceptTraverser( traverser );
				}
				
				if ( this._pDebugPrimitive )
				{
					traverser.applyRenderable( this._pDebugPrimitive );
				}
			}
		}
		
		public function pCreateDebugBounds():WireframePrimitiveBase
		{
			return null;
		}
		
		public function get _pNumEntities():Number
		{
			return this._iNumEntities;
		}
		
		public function set _pNumEntities(value:Number):void
		{
			this._iNumEntities = value;
		}
		
		public function _pUpdateNumEntities(value:Number):void
		{

			var diff:Number = value - this._pNumEntities;
			var node:NodeBase = this;
			
			do
			{
				node._pNumEntities += diff;
			}
			while ( (node = node._iParent) != null );

            //console.log( 'NodeBase' , '_pUpdateNumEntities' , this._pUpdateNumEntities)

		}
	}
}