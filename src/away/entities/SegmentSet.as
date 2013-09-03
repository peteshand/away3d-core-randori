/** * ... * @author Gary Paluk - http://www.plugin.io */

///<reference path="../_definitions.ts"/>


package away.entities
{
	import away.base.IRenderable;
	import away.materials.MaterialBase;
	import away.animators.IAnimator;
	import away.materials.SegmentMaterial;
	import away.primitives.data.Segment;
	import away.geom.Vector3D;
	import away.managers.Stage3DProxy;
	import away.display3D.IndexBuffer3D;
	import away.display3D.VertexBuffer3D;
	import away.display3D.Context3D;
	import away.display3D.Context3DVertexBufferFormat;
	import away.bounds.BoundingVolumeBase;
	import away.bounds.BoundingSphere;
	import away.partition.EntityNode;
	import away.partition.RenderableNode;
	import away.geom.Matrix;
	import away.library.assets.AssetType;
	import away.cameras.Camera3D;
	import away.geom.Matrix3D;
	
	public class SegmentSet extends Entity implements IRenderable
	{
		private var LIMIT:Number = 3*0xFFFF;
		private var _activeSubSet:SubSet;
		private var _subSets:Vector.<SubSet>;
		private var _subSetCount:Number;
		private var _numIndices:Number;
		private var _material:MaterialBase;
		private var _animator:IAnimator;
		private var _hasData:Boolean;
		
		public var _pSegments:Object; //Dictionary		private var _indexSegments:Number;
		
		public function SegmentSet():void
		{
			super();
			
			this._subSetCount = 0;
			this._subSets = new <SubSet>[];
			this.addSubSet();
			
			this._pSegments = new Object();

        this.material = new SegmentMaterial();
		}
		
		public function addSegment(segment:Segment):void
		{
			segment.iSegmentsBase = this;
			
			_hasData = true;
			
			var subSetIndex:Number = _subSets.length - 1;
			var subSet:SubSet = _subSets[subSetIndex];
			
			if( subSet.vertices.length + 44 > LIMIT )
			{
				subSet = addSubSet();
				subSetIndex++;
			}
			
			segment.iIndex = subSet.vertices.length;
			segment.iSubSetIndex = subSetIndex;
			
			iUpdateSegment( segment );
			
			var index:Number = subSet.lineCount << 2;
			
			subSet.indices.push(index, index + 1, index + 2, index + 3, index + 2, index + 1);
			subSet.numVertices = subSet.vertices.length/11;
			subSet.numIndices = subSet.indices.length;
			subSet.lineCount++;
			
			var segRef:SegRef = new SegRef();
			segRef.index = index;
			segRef.subSetIndex = subSetIndex;
			segRef.segment = segment;
			
			_pSegments[_indexSegments] = segRef;
			
			_indexSegments++;
		}
		
		public function removeSegmentByIndex(index:Number, dispose:Boolean = false):void
		{
			var segRef:SegRef;
			if (index >= _indexSegments)
			{
				return;
			}
			if( _pSegments[index] )
			{
				segRef = _pSegments[index];
			}
			else
			{
				return;
			}
			
			var subSet:SubSet;
			if ( !_subSets[segRef.subSetIndex] )
			{
				return;
			}
			
			var subSetIndex:Number = segRef.subSetIndex;
			subSet = _subSets[segRef.subSetIndex];
			
			var segment:Segment = segRef.segment;
			var indices:Vector.<Number> = subSet.indices;
			
			var ind:Number = index * 6;
			for (var i:Number = ind; i < indices.length; ++i)
			{
				indices[i] -= 4;
			}
			subSet.indices.splice(index*6, 6);
			subSet.vertices.splice(index*44, 44);
			subSet.numVertices = subSet.vertices.length/11;
			subSet.numIndices = indices.length;
			subSet.vertexBufferDirty = true;
			subSet.indexBufferDirty = true;
			subSet.lineCount--;
			
			if( dispose )
			{
				segment.dispose();
				segment = null;
				
			}
			else
			{
				segment.iIndex = -1;
				segment.iSegmentsBase = null;
			}
			
			if( subSet.lineCount == 0 ) {
				
				if( subSetIndex == 0 )
				{
					_hasData = false;
				}
				else
				{
					subSet.dispose();
					_subSets[subSetIndex] = null;
					_subSets.splice(subSetIndex, 1);
				}
			}
			
			reOrderIndices( subSetIndex, index );
			
			segRef = null;
			_pSegments[_indexSegments] = null;
			_indexSegments--;
		}
		
		public function removeSegment(segment:Segment, dispose:Boolean = false):void
		{
			if( segment.iIndex == -1 )
			{
				return;
			}
			removeSegmentByIndex(segment.iIndex/44);
		}
		
		public function removeAllSegments():void
		{
			var subSet:SubSet;
			for ( var i:Number = 0; i < _subSetCount; ++i )
			{
				subSet = _subSets[i];
				subSet.vertices = null;
				subSet.indices = null;
				if (subSet.vertexBuffer)
				{
					subSet.vertexBuffer.dispose();
				}
				if (subSet.indexBuffer)
				{
					subSet.indexBuffer.dispose();
				}
				subSet = null;
			}
			
			for( var segRef in _pSegments )
			{
				segRef = null;
			}
			_pSegments = null; //WHY?
			_subSetCount = 0;
			_activeSubSet = null;
			_indexSegments = 0;
			_subSets = new <SubSet>[];
			_pSegments = new Object();
			
			addSubSet();
			
			_hasData = false;
		}
		
		public function getSegment(index:Number):Segment
		{
			if (index > _indexSegments - 1)
			{
				return null;
			}
			return _pSegments[index].segment;
		}
		
		public function get segmentCount():Number
		{
			return _indexSegments;
		}
		
		public function get iSubSetCount():Number
		{
			return _subSetCount;
		}
		
		public function iUpdateSegment(segment:Segment):void
		{
			var start:Vector3D = segment._pStart;
			var end:Vector3D = segment._pEnd;
			var startX:Number = start.x, startY:Number = start.y, startZ:Number = start.z;
			var endX:Number = end.x, endY:Number = end.y, endZ:Number = end.z;
			var startR:Number = segment._pStartR, startG:Number = segment._pStartG, startB:Number = segment._pStartB;
			var endR:Number = segment._pEndR, endG:Number = segment._pEndG, endB:Number = segment._pEndB;
			var index:Number = segment.iIndex;
			var t:Number = segment.thickness;
			
			var subSet:SubSet = _subSets[segment.iSubSetIndex];
			var vertices:Vector.<Number> = subSet.vertices;
			
			vertices[index++] = startX;
			vertices[index++] = startY;
			vertices[index++] = startZ;
			vertices[index++] = endX;
			vertices[index++] = endY;
			vertices[index++] = endZ;
			vertices[index++] = t;
			vertices[index++] = startR;
			vertices[index++] = startG;
			vertices[index++] = startB;
			vertices[index++] = 1;
			
			vertices[index++] = endX;
			vertices[index++] = endY;
			vertices[index++] = endZ;
			vertices[index++] = startX;
			vertices[index++] = startY;
			vertices[index++] = startZ;
			vertices[index++] = -t;
			vertices[index++] = endR;
			vertices[index++] = endG;
			vertices[index++] = endB;
			vertices[index++] = 1;
			
			vertices[index++] = startX;
			vertices[index++] = startY;
			vertices[index++] = startZ;
			vertices[index++] = endX;
			vertices[index++] = endY;
			vertices[index++] = endZ;
			vertices[index++] = -t;
			vertices[index++] = startR;
			vertices[index++] = startG;
			vertices[index++] = startB;
			vertices[index++] = 1;
			
			vertices[index++] = endX;
			vertices[index++] = endY;
			vertices[index++] = endZ;
			vertices[index++] = startX;
			vertices[index++] = startY;
			vertices[index++] = startZ;
			vertices[index++] = t;
			vertices[index++] = endR;
			vertices[index++] = endG;
			vertices[index++] = endB;
			vertices[index++] = 1;
			
			subSet.vertexBufferDirty = true;
			
			_pBoundsInvalid = true;
		}
		
		public function get hasData():Boolean
		{
			return _hasData;
		}
		

		public function getIndexBuffer(stage3DProxy:Stage3DProxy):IndexBuffer3D
		{

			if( _activeSubSet.indexContext3D != stage3DProxy.context3D || _activeSubSet.indexBufferDirty )
			{
				_activeSubSet.indexBuffer = stage3DProxy._iContext3D.createIndexBuffer( _activeSubSet.numIndices );
				_activeSubSet.indexBuffer.uploadFromArray( _activeSubSet.indices, 0, _activeSubSet.numIndices );
				_activeSubSet.indexBufferDirty = false;
				_activeSubSet.indexContext3D = stage3DProxy.context3D;
			}
			
			return _activeSubSet.indexBuffer;

		}


		public function activateVertexBuffer(index:Number, stage3DProxy:Stage3DProxy):void
		{

			var subSet:SubSet = _subSets[index];
			
			_activeSubSet = subSet;
			_numIndices = subSet.numIndices;
			
			var vertexBuffer:VertexBuffer3D = subSet.vertexBuffer;
			
			if (subSet.vertexContext3D != stage3DProxy.context3D || subSet.vertexBufferDirty) {
				subSet.vertexBuffer = stage3DProxy._iContext3D.createVertexBuffer(subSet.numVertices, 11);
				subSet.vertexBuffer.uploadFromArray(subSet.vertices, 0, subSet.numVertices);
				subSet.vertexBufferDirty = false;
				subSet.vertexContext3D = stage3DProxy.context3D;
			}
			
			var context3d:Context3D = stage3DProxy._iContext3D;
			context3d.setVertexBufferAt(0, vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			context3d.setVertexBufferAt(1, vertexBuffer, 3, Context3DVertexBufferFormat.FLOAT_3);
			context3d.setVertexBufferAt(2, vertexBuffer, 6, Context3DVertexBufferFormat.FLOAT_1);
			context3d.setVertexBufferAt(3, vertexBuffer, 7, Context3DVertexBufferFormat.FLOAT_4);

		}
		
		public function activateUVBuffer(index:Number, stage3DProxy:Stage3DProxy):void
		{
		}
		
		public function activateVertexNormalBuffer(index:Number, stage3DProxy:Stage3DProxy):void
		{
		}
		
		public function activateVertexTangentBuffer(index:Number, stage3DProxy:Stage3DProxy):void
		{
		}
		
		public function activateSecondaryUVBuffer(index:Number, stage3DProxy:Stage3DProxy):void
		{
		}

		private function reOrderIndices(subSetIndex:Number, index:Number):void
		{
			var segRef:SegRef;
			
			for( var i:Number = index; i < _indexSegments - 1; ++i )
			{
				segRef = _pSegments[i + 1];
				segRef.index = i;
				if( segRef.subSetIndex == subSetIndex )
				{
					segRef.segment.iIndex -= 44;
				}
				_pSegments[i] = segRef;
			}
		}
		
		private function addSubSet():SubSet
		{
			var subSet:SubSet = new SubSet();
			_subSets.push(subSet);
			
			subSet.vertices = new <Number>[];
			subSet.numVertices = 0;
			subSet.indices = new <Number>[];
			subSet.numIndices = 0;
			subSet.vertexBufferDirty = true;
			subSet.indexBufferDirty = true;
			subSet.lineCount = 0;
			
			_subSetCount++;
			
			return subSet;
		}
		
		//@override
		override public function dispose():void
		{
			super.dispose();
			removeAllSegments();
			_pSegments = null
			_material = null;
			var subSet:SubSet = _subSets[0];
			subSet.vertices = null;
			subSet.indices = null;
			_subSets = null;
		}
		
		//@override
		override public function get mouseEnabled():Boolean
		{
			return false;
		}
		
		//@override
		override public function pGetDefaultBoundingVolume():BoundingVolumeBase
		{
			return new BoundingSphere();
		}
		
		//@override
		override public function pUpdateBounds():void
		{
			var subSet:SubSet;
			var len:Number;
			var v:Number;
			var index:Number;
			
			var minX:Number = Infinity;
			var minY:Number = Infinity;
			var minZ:Number = Infinity;
			var maxX:Number = -Infinity;
			var maxY:Number = -Infinity;
			var maxZ:Number = -Infinity;
			var vertices:Vector.<Number>;
			
			for( var i:Number = 0; i < _subSetCount; ++i )
			{
				subSet = _subSets[i];
				index = 0;
				vertices = subSet.vertices;
				len = vertices.length;
				
				if (len == 0)
				{
					continue;
				}
				
				while(index < len)
				{
					v = vertices[index++];
					if (v < minX)
						minX = v;
					else if (v > maxX)
						maxX = v;
					
					v = vertices[index++];
					if (v < minY)
						minY = v;
					else if (v > maxY)
						maxY = v;
					
					v = vertices[index++];
					if (v < minZ)
						minZ = v;
					else if (v > maxZ)
						maxZ = v;
					
					index += 8;
				}
			}

			if (minX != Infinity)
            {
				_pBounds.fromExtremes(minX, minY, minZ, maxX, maxY, maxZ);

            }
			else
            {
				var min:Number = .5;
				_pBounds.fromExtremes(-min, -min, -min, min, min, min);
			}

			_pBoundsInvalid = false;
		}
		
		
		//@override

		override public function pCreateEntityPartitionNode():EntityNode
		{
			return new RenderableNode(this);
		}

		public function get numTriangles():Number
		{
			return _numIndices/3;
		}
		
		public function get sourceEntity():Entity
		{
			return this;
		}
		
		public function get castsShadows():Boolean
		{
			return false;
		}
		
		public function get material():MaterialBase
		{
			return _material;
		}

		public function get animator():IAnimator
		{
			return _animator;
		}
		
		public function set animator(value:IAnimator):void
		{
			this._animator = value;
		}
		
		public function set material(value:MaterialBase):void
		{
			if( value == this._material)
			{
				return;
			}
			if( this._material )
			{
				this._material.iRemoveOwner( this );
			}
			this._material = value;
			if( this._material )
			{
				this._material.iAddOwner( this );
			}
		}
		
		public function get uvTransform():Matrix
		{
			return null;
		}
		
		public function get vertexData():Vector.<Number>
		{
			return null;
		}
		
		public function get indexData():Vector.<Number>
		{
			return null;
		}
		
		public function get UVData():Vector.<Number>
		{
			return null;
		}
		
		public function get numVertices():Number
		{
			return null;
		}
		
		public function get vertexStride():Number
		{
			return 11;
		}
		
		public function get vertexNormalData():Vector.<Number>
		{
			return null;
		}
		
		public function get vertexTangentData():Vector.<Number>
		{
			return null;
		}
		
		public function get vertexOffset():Number
		{
			return 0;
		}
		
		public function get vertexNormalOffset():Number
		{
			return 0;
		}
		
		public function get vertexTangentOffset():Number
		{
			return 0;
		}
		
		//@override
		override public function get assetType():String
		{
			return AssetType.SEGMENT_SET;
		}
		
		public function getRenderSceneTransform(camera:Camera3D):Matrix3D
		{
			return _pSceneTransform;
		}
	}
}
