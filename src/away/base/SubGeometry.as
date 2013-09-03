///<reference path="../_definitions.ts"/>
package away.base
{
	import away.display3D.VertexBuffer3D;
	import away.display3D.Context3D;
	import away.managers.Stage3DProxy;
	import away.display3D.Context3DVertexBufferFormat;
	import away.geom.Matrix3D;
	//import away3d.arcane;
	//import away3d.managers.Stage3DProxy;
	
	//import flash.display3D.Context3D;
	//import flash.display3D.Context3DVertexBufferFormat;
	//import flash.display3D.VertexBuffer3D;
	//import flash.geom.Matrix3D;
	
	//use namespace arcane;
	
	/**
	public class SubGeometry extends SubGeometryBase implements ISubGeometry
	{
		// raw data:
		private var _uvs:Vector.<Number>;
		private var _secondaryUvs:Vector.<Number>;
		private var _vertexNormals:Vector.<Number>;
		private var _vertexTangents:Vector.<Number>;
		
		private var _verticesInvalid:Vector.<Boolean> = new Vector.<Boolean>( 8 );//= new Vector.<Boolean>(8, true);
		// buffers:
		private var _vertexBuffer:Vector.<VertexBuffer3D> = new Vector.<VertexBuffer3D>( 8 );//Vector.<VertexBuffer3D> = new Vector.<VertexBuffer3D>(8);
		// buffer dirty flags, per context:
		private var _vertexBufferContext:Vector.<Context3D> = new Vector.<Context3D>( 8 );//:Vector.<Context3D> = new Vector.<Context3D>(8);
		private var _numVertices:Number;
		
		/**
		public function SubGeometry():void
		{
            super();
		}
		
		/**
		public function get numVertices():Number
		{
			return _numVertices;
		}
		
		/**
		public function activateVertexBuffer(index:Number, stage3DProxy:Stage3DProxy):void
		{
			var contextIndex:Number = stage3DProxy._iStage3DIndex;
			var context:Context3D = stage3DProxy._iContext3D;

			if (!_vertexBuffer[contextIndex] || _vertexBufferContext[contextIndex] != context)
            {
                _vertexBuffer[contextIndex] = context.createVertexBuffer(_numVertices, 3);
                _vertexBufferContext[contextIndex] = context;
                _verticesInvalid[contextIndex] = true;

			}

			if (_verticesInvalid[contextIndex])
            {
                _vertexBuffer[contextIndex].uploadFromArray(_vertexData, 0, _numVertices);
                _verticesInvalid[contextIndex] = false;
			}
			
			context.setVertexBufferAt(index, _vertexBuffer[contextIndex], 0, Context3DVertexBufferFormat.FLOAT_3);
		}
		
		/**
		public function activateUVBuffer(index:Number, stage3DProxy:Stage3DProxy):void
        {
            var contextIndex:Number = stage3DProxy._iStage3DIndex;
            var context:Context3D = stage3DProxy._iContext3D;
			
			if (_autoGenerateUVs && _uvsDirty)
            {
                _uvs = pUpdateDummyUVs(_uvs);
            }

			
			if (!_uvBuffer[contextIndex] || _uvBufferContext[contextIndex] != context)
            {
                _uvBuffer[contextIndex] = context.createVertexBuffer(_numVertices, 2);
                _uvBufferContext[contextIndex] = context;
                _uvsInvalid[contextIndex] = true;
			}

			if (_uvsInvalid[contextIndex])
            {
                _uvBuffer[contextIndex].uploadFromArray(_uvs, 0, _numVertices);
                _uvsInvalid[contextIndex] = false;
			}
			
			context.setVertexBufferAt(index, _uvBuffer[contextIndex], 0, Context3DVertexBufferFormat.FLOAT_2);
		}
		
		/**
		public function activateSecondaryUVBuffer(index:Number, stage3DProxy:Stage3DProxy):void
        {
            var contextIndex:Number = stage3DProxy._iStage3DIndex;
            var context:Context3D = stage3DProxy._iContext3D;
			
			if (!_secondaryUvBuffer[contextIndex] || _secondaryUvBufferContext[contextIndex] != context)
            {
                _secondaryUvBuffer[contextIndex] = context.createVertexBuffer(_numVertices, 2);
                _secondaryUvBufferContext[contextIndex] = context;
                _secondaryUvsInvalid[contextIndex] = true;
			}

			if (_secondaryUvsInvalid[contextIndex])
            {
                _secondaryUvBuffer[contextIndex].uploadFromArray(_secondaryUvs, 0, _numVertices);
                _secondaryUvsInvalid[contextIndex] = false;
			}
			
			context.setVertexBufferAt(index, _secondaryUvBuffer[contextIndex], 0, Context3DVertexBufferFormat.FLOAT_2);
		}
		
		/**
		public function activateVertexNormalBuffer(index:Number, stage3DProxy:Stage3DProxy):void
        {
            var contextIndex:Number = stage3DProxy._iStage3DIndex;
            var context:Context3D = stage3DProxy._iContext3D;
			
			if (_autoDeriveVertexNormals && _vertexNormalsDirty)
            {
                _vertexNormals = pUpdateVertexNormals(_vertexNormals);
            }

			if (!_vertexNormalBuffer[contextIndex] || _vertexNormalBufferContext[contextIndex] != context)
            {
                _vertexNormalBuffer[contextIndex] = context.createVertexBuffer(_numVertices, 3);
                _vertexNormalBufferContext[contextIndex] = context;
                _normalsInvalid[contextIndex] = true;
			}

			if (_normalsInvalid[contextIndex])
            {
                _vertexNormalBuffer[contextIndex].uploadFromArray(_vertexNormals, 0, _numVertices);
                _normalsInvalid[contextIndex] = false;
			}
			
			context.setVertexBufferAt(index, _vertexNormalBuffer[contextIndex], 0, Context3DVertexBufferFormat.FLOAT_3);
		}
		
		/**
		public function activateVertexTangentBuffer(index:Number, stage3DProxy:Stage3DProxy):void
        {
            var contextIndex:Number = stage3DProxy._iStage3DIndex;
            var context:Context3D = stage3DProxy._iContext3D;
			
			if (_vertexTangentsDirty)
            {
                _vertexTangents = pUpdateVertexTangents(_vertexTangents);
            }

			if (!_vertexTangentBuffer[contextIndex] || _vertexTangentBufferContext[contextIndex] != context)
            {
                _vertexTangentBuffer[contextIndex] = context.createVertexBuffer(_numVertices, 3);
                _vertexTangentBufferContext[contextIndex] = context;
                _tangentsInvalid[contextIndex] = true;
			}

			if (_tangentsInvalid[contextIndex])
            {
                _vertexTangentBuffer[contextIndex].uploadFromArray( _vertexTangents, 0, _numVertices);
                _tangentsInvalid[contextIndex] = false;
			}

			context.setVertexBufferAt(index, _vertexTangentBuffer[contextIndex], 0, Context3DVertexBufferFormat.FLOAT_3);
		}
		
		override public function applyTransformation(transform:Matrix3D):void
		{
			super.applyTransformation(transform);
            pInvalidateBuffers(_verticesInvalid);
            pInvalidateBuffers(_normalsInvalid);
            pInvalidateBuffers(_tangentsInvalid);
		}
		
		/**
		public function clone():ISubGeometry
		{
			var clone:SubGeometry = new SubGeometry();
			    clone.updateVertexData(_vertexData.concat());
			    clone.updateUVData(_uvs.concat());
			    clone.updateIndexData(_indices.concat());

			if (_secondaryUvs)
            {
                clone.updateSecondaryUVData(_secondaryUvs.concat());
            }

			if (!_autoDeriveVertexNormals)
            {
                clone.updateVertexNormalData(_vertexNormals.concat());
            }

			if (!_autoDeriveVertexTangents)
            {
                clone.updateVertexTangentData(_vertexTangents.concat());
            }

			return clone;
		}
		
		/**
		override public function scale(scale:Number):void
		{
			super.scale(scale);
            pInvalidateBuffers( _verticesInvalid );
		}
		
		/**
		override public function scaleUV(scaleU:Number = 1, scaleV:Number = 1):void
		{
			super.scaleUV(scaleU, scaleV);
			pInvalidateBuffers(_uvsInvalid);
		}
		
		/**
		override public function dispose():void
		{
			super.dispose();
			pDisposeAllVertexBuffers();
            _vertexBuffer = null;
            _vertexNormalBuffer = null;
            _uvBuffer = null;
            _secondaryUvBuffer = null;
            _vertexTangentBuffer = null;
            _indexBuffer = null;
            _uvs = null;
            _secondaryUvs = null;
            _vertexNormals = null;
            _vertexTangents = null;
            _vertexBufferContext = null;
            _uvBufferContext = null;
            _secondaryUvBufferContext = null;
            _vertexNormalBufferContext = null;
            _vertexTangentBufferContext = null;
		}
		
		public function pDisposeAllVertexBuffers():void
		{
            pDisposeVertexBuffers(_vertexBuffer);
            pDisposeVertexBuffers(_vertexNormalBuffer);
            pDisposeVertexBuffers(_uvBuffer);
            pDisposeVertexBuffers(_secondaryUvBuffer);
            pDisposeVertexBuffers(_vertexTangentBuffer);
		}
		
		/**
		override public function get vertexData():Vector.<Number>
		{
			return _vertexData;
		}
		
		override public function get vertexPositionData():Vector.<Number>
		{
			return _vertexData;
		}
		
		/**
		public function updateVertexData(vertices:Vector.<Number>):void
		{
			if (_autoDeriveVertexNormals)
            {
                _vertexNormalsDirty = true;
            }

			if (_autoDeriveVertexTangents)
            {
                _vertexTangentsDirty = true;
            }

			_faceNormalsDirty = true;
			_vertexData = vertices;
			var numVertices:Number = vertices.length/3;

			if (numVertices != _numVertices)
            {
                pDisposeAllVertexBuffers();
            }

			_numVertices = numVertices;
			pInvalidateBuffers( _verticesInvalid );
			pInvalidateBounds();//invalidateBounds();
		}
		
		/**
		override public function get UVData():Vector.<Number>
		{
			if (_uvsDirty && _autoGenerateUVs)
            {
                _uvs = pUpdateDummyUVs( _uvs );
            }

			return _uvs;
		}
		
		public function get secondaryUVData():Vector.<Number>
		{
			return _secondaryUvs;
		}
		
		/**
		public function updateUVData(uvs:Vector.<Number>):void
		{
			// normals don't get dirty from this
			if (_autoDeriveVertexTangents)
            {
                _vertexTangentsDirty = true;
            }

			_faceTangentsDirty = true;
			_uvs = uvs;
			pInvalidateBuffers( _uvsInvalid );
		}
		
		public function updateSecondaryUVData(uvs:Vector.<Number>):void
		{
			_secondaryUvs = uvs;
            pInvalidateBuffers( _secondaryUvsInvalid );
		}
		
		/**
		override public function get vertexNormalData():Vector.<Number>
		{
			if ( _autoDeriveVertexNormals && _vertexNormalsDirty)
            {
                _vertexNormals = pUpdateVertexNormals(_vertexNormals);
            }

			return _vertexNormals;
		}
		
		/**
		public function updateVertexNormalData(vertexNormals:Vector.<Number>):void
		{
			_vertexNormalsDirty = false;
			_autoDeriveVertexNormals = (vertexNormals == null);
			_vertexNormals = vertexNormals;
			pInvalidateBuffers( _normalsInvalid );
		}
		
		/**
		override public function get vertexTangentData():Vector.<Number>
		{
			if (_autoDeriveVertexTangents && _vertexTangentsDirty)
            {
                _vertexTangents = pUpdateVertexTangents( _vertexTangents );
            }

			return _vertexTangents;
		}
		
		/**
		public function updateVertexTangentData(vertexTangents:Vector.<Number>):void
		{
			_vertexTangentsDirty = false;
			_autoDeriveVertexTangents = (vertexTangents == null);
			_vertexTangents = vertexTangents;
            pInvalidateBuffers( _tangentsInvalid );
		}
		
		public function fromVectors(vertices:Vector.<Number>, uvs:Vector.<Number>, normals:Vector.<Number>, tangents:Vector.<Number>):void
		{
			updateVertexData(vertices);
			updateUVData(uvs);
			updateVertexNormalData(normals);
			updateVertexTangentData(tangents);
		}
		
		override public function pUpdateVertexNormals(target:Vector.<Number>):Vector.<Number>
		{
			pInvalidateBuffers( _normalsInvalid );
			return super.pUpdateVertexNormals(target);

		}
		
		override public function pUpdateVertexTangents(target:Vector.<Number>):Vector.<Number>
		{
			if (_vertexNormalsDirty)
            {
                _vertexNormals = pUpdateVertexNormals( _vertexNormals);
            }

			pInvalidateBuffers(_tangentsInvalid);
			return super.pUpdateVertexTangents(target);
		}
		
		override public function pUpdateDummyUVs(target:Vector.<Number>):Vector.<Number>
		{
			pInvalidateBuffers(_uvsInvalid);
			return super.pUpdateDummyUVs( target );
		}
		
		public function pDisposeForStage3D(stage3DProxy:Stage3DProxy):void
		{
			var index:Number = stage3DProxy._iStage3DIndex;
			if (_vertexBuffer[index])
            {
                _vertexBuffer[index].dispose();
                _vertexBuffer[index] = null;
			}
			if (_uvBuffer[index])
            {
                _uvBuffer[index].dispose();
                _uvBuffer[index] = null;
			}
			if (_secondaryUvBuffer[index])
            {
                _secondaryUvBuffer[index].dispose();
                _secondaryUvBuffer[index] = null;
			}
			if (_vertexNormalBuffer[index])
            {
                _vertexNormalBuffer[index].dispose();
                _vertexNormalBuffer[index] = null;
			}
			if (_vertexTangentBuffer[index])
            {
                _vertexTangentBuffer[index].dispose();
                _vertexTangentBuffer[index] = null;
			}
			if (_indexBuffer[index])
            {
                _indexBuffer[index].dispose();
                _indexBuffer[index] = null;
			}
		}
		
		override public function get vertexStride():Number
		{
			return 3;
		}
		
		override public function get vertexTangentStride():Number
		{
			return 3;
		}
		
		override public function get vertexNormalStride():Number
		{
			return 3;
		}
		
		override public function get UVStride():Number
		{
			return 2;
		}
		
		public function get secondaryUVStride():Number
		{
			return 2;
		}
		
		override public function get vertexOffset():Number
		{
			return 0;
		}
		
		override public function get vertexNormalOffset():Number
		{
			return 0;
		}
		
		override public function get vertexTangentOffset():Number
		{
			return 0;
		}
		
		override public function get UVOffset():Number
		{
			return 0;
		}
		
		public function get secondaryUVOffset():Number
		{
			return 0;
		}
		
		public function cloneWithSeperateBuffers():SubGeometry
		{
            var obj : * = clone();
			return SubGeometry(obj);
		}
	}
}