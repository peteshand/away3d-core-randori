///<reference path="../_definitions.ts"/>
package away.base
{
	import away.display3D.VertexBuffer3D;
	import away.display3D.Context3D;
	import away.managers.Stage3DProxy;
	import away.display3D.Context3DVertexBufferFormat;
	import away.geom.Matrix3D;

	public class CompactSubGeometry extends SubGeometryBase implements ISubGeometry
	{
		public var _pVertexDataInvalid:Vector.<Boolean> = Vector.<Boolean>( 8 );//new Vector.<Boolean>(8, true);		private var _vertexBuffer:Vector.<VertexBuffer3D> = new Vector.<VertexBuffer3D>( 8 );//Vector.<VertexBuffer3D> = new Vector.<VertexBuffer3D>(8);		private var _bufferContext:Vector.<Context3D> = new Vector.<Context3D>( 8 );//Vector.<Context3D> = new Vector.<Context3D>(8);		public var _pNumVertices:Number;
		private var _contextIndex:Number;
		public var _pActiveBuffer:VertexBuffer3D;
		private var _activeContext:Context3D;
		public var _pActiveDataInvalid:Boolean;
		private var _isolatedVertexPositionData:Vector.<Number>;
		private var _isolatedVertexPositionDataDirty:Boolean;
		
		public function CompactSubGeometry():void
		{
            super();

			this._autoDeriveVertexNormals = false;
            this._autoDeriveVertexTangents = false;
		}
		
		public function get numVertices():Number
		{
			return _pNumVertices;
		}
		
		/**		 * Updates the vertex data. All vertex properties are contained in a single Vector, and the order is as follows:		 * 0 - 2: vertex position X, Y, Z		 * 3 - 5: normal X, Y, Z		 * 6 - 8: tangent X, Y, Z		 * 9 - 10: U V		 * 11 - 12: Secondary U V		 */
		public function updateData(data:Vector.<Number>):void
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
            _faceTangentsDirty = true;
            _isolatedVertexPositionDataDirty = true;
            _vertexData = data;

			var numVertices:Number = _vertexData.length/13;

			if (numVertices != _pNumVertices)
            {
                pDisposeVertexBuffers(_vertexBuffer);
            }

			_pNumVertices = numVertices;
			
			if (_pNumVertices == 0)
            {
                throw new Error("Bad data: geometry can't have zero triangles");
            }

			pInvalidateBuffers( _pVertexDataInvalid );
            pInvalidateBounds();

		}
		
		public function activateVertexBuffer(index:Number, stage3DProxy:Stage3DProxy):void
		{
			var contextIndex:Number = stage3DProxy._iStage3DIndex;
			var context:Context3D = stage3DProxy._iContext3D;
			
			if (contextIndex != _contextIndex)
            {
                pUpdateActiveBuffer(contextIndex);
            }

			if (!_pActiveBuffer || _activeContext != context)
            {
                pCreateBuffer(contextIndex, context);
            }

			if ( _pActiveDataInvalid )
            {
                pUploadData(contextIndex);
            }

			context.setVertexBufferAt(index, _pActiveBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);

		}
		
		public function activateUVBuffer(index:Number, stage3DProxy:Stage3DProxy):void
		{
			var contextIndex:Number = stage3DProxy._iStage3DIndex;
            var context:Context3D = stage3DProxy._iContext3D;
			
			if (_uvsDirty && _autoGenerateUVs)
            {
				_vertexData = pUpdateDummyUVs( _vertexData);
                pInvalidateBuffers( _pVertexDataInvalid );
			}
			
			if (contextIndex != _contextIndex)
            {
                pUpdateActiveBuffer( contextIndex );

            }

			if (!_pActiveBuffer || _activeContext != context)
            {
                pCreateBuffer( contextIndex , context );
            }

			if (_pActiveDataInvalid)
            {
                pUploadData( contextIndex );
            }

			context.setVertexBufferAt(index, _pActiveBuffer, 9, Context3DVertexBufferFormat.FLOAT_2);

		}
		
		public function activateSecondaryUVBuffer(index:Number, stage3DProxy:Stage3DProxy):void
		{
			var contextIndex:Number = stage3DProxy._iStage3DIndex;
			var context:Context3D = stage3DProxy._iContext3D;
			
			if (contextIndex != _contextIndex)
            {
                pUpdateActiveBuffer( contextIndex );
            }

			if (!_pActiveBuffer || _activeContext != context)
            {
                pCreateBuffer( contextIndex , context );
            }

			if ( _pActiveDataInvalid )
            {
                pUploadData( contextIndex );
            }

			context.setVertexBufferAt(index, _pActiveBuffer, 11, Context3DVertexBufferFormat.FLOAT_2);

		}
		
		public function pUploadData(contextIndex:Number):void
		{
			_pActiveBuffer.uploadFromArray(_vertexData, 0, _pNumVertices);
			_pVertexDataInvalid[contextIndex] = _pActiveDataInvalid = false;
		}
		
		public function activateVertexNormalBuffer(index:Number, stage3DProxy:Stage3DProxy):void
		{
			var contextIndex:Number = stage3DProxy._iStage3DIndex;
			var context:Context3D = stage3DProxy._iContext3D;
			
			if (contextIndex != _contextIndex)
            {
                pUpdateActiveBuffer( contextIndex );
            }

			if (!_pActiveBuffer || _activeContext != context)
            {
                pCreateBuffer( contextIndex , context );
            }

			if (_pActiveDataInvalid)
            {
                pUploadData(contextIndex);
            }

			context.setVertexBufferAt(index, _pActiveBuffer, 3, Context3DVertexBufferFormat.FLOAT_3);

		}
		
		public function activateVertexTangentBuffer(index:Number, stage3DProxy:Stage3DProxy):void
		{
			var contextIndex:Number = stage3DProxy._iStage3DIndex;
			var context:Context3D = stage3DProxy._iContext3D;
			
			if (contextIndex != _contextIndex)
            {
                pUpdateActiveBuffer( contextIndex );
            }

			if (!_pActiveBuffer || _activeContext != context)
            {
                pCreateBuffer( contextIndex , context );
            }

			if ( _pActiveDataInvalid )
            {
                pUploadData(contextIndex);
            }

			
			context.setVertexBufferAt(index, _pActiveBuffer, 6, Context3DVertexBufferFormat.FLOAT_3);

		}
		
		public function pCreateBuffer(contextIndex:Number, context:Context3D):void
		{
			_vertexBuffer[contextIndex] = _pActiveBuffer = context.createVertexBuffer(_pNumVertices, 13);
			_bufferContext[contextIndex] = _activeContext = context;
			_pVertexDataInvalid[contextIndex] = _pActiveDataInvalid = true;
		}
		
		public function pUpdateActiveBuffer(contextIndex:Number):void
		{
			_contextIndex = contextIndex;
            _pActiveDataInvalid = _pVertexDataInvalid[contextIndex];
            _pActiveBuffer = _vertexBuffer[contextIndex];
            _activeContext = _bufferContext[contextIndex];
		}
		
		override public function get vertexData():Vector.<Number>
		{
			if ( _autoDeriveVertexNormals && _vertexNormalsDirty)
            {
                _vertexData = pUpdateVertexNormals(_vertexData);
            }

			if (_autoDeriveVertexTangents && _vertexTangentsDirty)
            {
                _vertexData = pUpdateVertexTangents(_vertexData);
            }

			if (_uvsDirty && _autoGenerateUVs)
            {
                _vertexData = pUpdateDummyUVs( _vertexData );
            }

			return _vertexData;
		}
		
		override public function pUpdateVertexNormals(target:Vector.<Number>):Vector.<Number>
		{
            pInvalidateBuffers( _pVertexDataInvalid);
			return super.pUpdateVertexNormals(target);
		}
		
		override public function pUpdateVertexTangents(target:Vector.<Number>):Vector.<Number>
		{
			if (_vertexNormalsDirty)
            {
                _vertexData = pUpdateVertexNormals( _vertexData );
            }

			pInvalidateBuffers( _pVertexDataInvalid);

			return super.pUpdateVertexTangents(target);

		}
		
		override public function get vertexNormalData():Vector.<Number>
		{
			if ( _autoDeriveVertexNormals && _vertexNormalsDirty)
            {
                _vertexData = pUpdateVertexNormals(_vertexData);
            }

			return _vertexData;

		}
		
		override public function get vertexTangentData():Vector.<Number>
		{
			if ( _autoDeriveVertexTangents && _vertexTangentsDirty)
            {
                _vertexData = pUpdateVertexTangents( _vertexData );
            }

			return _vertexData;
		}
		
		override public function get UVData():Vector.<Number>
		{
			if ( _uvsDirty && _autoGenerateUVs)
            {
				_vertexData = pUpdateDummyUVs(_vertexData);
				pInvalidateBuffers( _pVertexDataInvalid );
			}

			return _vertexData;
		}
		
		override public function applyTransformation(transform:Matrix3D):void
		{
			super.applyTransformation(transform);
			pInvalidateBuffers( _pVertexDataInvalid );
		}
		
		override public function scale(scale:Number):void
		{
			super.scale(scale);
			pInvalidateBuffers(_pVertexDataInvalid);
		}
		
		public function clone():ISubGeometry
		{
			var clone:CompactSubGeometry = new CompactSubGeometry();

			    clone._autoDeriveVertexNormals = _autoDeriveVertexNormals;
			    clone._autoDeriveVertexTangents = _autoDeriveVertexTangents;

                clone.updateData(_vertexData.concat());
			    clone.updateIndexData(_indices.concat());

			return clone;
		}
		
		override public function scaleUV(scaleU:Number = 1, scaleV:Number = 1):void
		{

			super.scaleUV(scaleU, scaleV);

			pInvalidateBuffers( _pVertexDataInvalid );

		}
		
		override public function get vertexStride():Number
		{
			return 13;
		}
		
		override public function get vertexNormalStride():Number
		{
			return 13;
		}
		
		override public function get vertexTangentStride():Number
		{
			return 13;
		}
		
		override public function get UVStride():Number
		{
			return 13;
		}
		
		public function get secondaryUVStride():Number
		{
			return 13;
		}
		
		override public function get vertexOffset():Number
		{
			return 0;
		}
		
		override public function get vertexNormalOffset():Number
		{
			return 3;
		}
		
		override public function get vertexTangentOffset():Number
		{
			return 6;
		}
		
		override public function get UVOffset():Number
		{
			return 9;
		}
		
		public function get secondaryUVOffset():Number
		{
			return 11;
		}
		
		override public function dispose():void
		{
			super.dispose();
			pDisposeVertexBuffers(_vertexBuffer);
			_vertexBuffer = null;
		}
		
		override public function pDisposeVertexBuffers(buffers:Vector.<VertexBuffer3D>):void
		{

			super.pDisposeVertexBuffers(buffers);
			_pActiveBuffer = null;

		}
		
		override public function pInvalidateBuffers(invalid:Vector.<Boolean>):void
		{
			super.pInvalidateBuffers(invalid);
			_pActiveDataInvalid = true;
		}

		public function cloneWithSeperateBuffers():SubGeometry
		{
			var clone:SubGeometry = new SubGeometry();

			clone.updateVertexData(_isolatedVertexPositionData? _isolatedVertexPositionData : _isolatedVertexPositionData = stripBuffer(0, 3));
			clone.autoDeriveVertexNormals = _autoDeriveVertexNormals;
			clone.autoDeriveVertexTangents = _autoDeriveVertexTangents;

			if (!_autoDeriveVertexNormals)
            {
                clone.updateVertexNormalData(stripBuffer(3, 3));
            }

			if (!_autoDeriveVertexTangents)
            {
                clone.updateVertexTangentData(stripBuffer(6, 3));
            }

			clone.updateUVData(stripBuffer(9, 2));
			clone.updateSecondaryUVData(stripBuffer(11, 2));
			clone.updateIndexData(indexData.concat());

			return clone;

		}

        override public function get vertexPositionData():Vector.<Number>
        {
            if (_isolatedVertexPositionDataDirty || !_isolatedVertexPositionData)
            {
                _isolatedVertexPositionData = stripBuffer(0, 3);
                _isolatedVertexPositionDataDirty = false;
            }

            return _isolatedVertexPositionData;

        }

        public function get strippedUVData():Vector.<Number>
        {
            return stripBuffer(9, 2);
        }
		
		/**		 * Isolate and returns a Vector.Number of a specific buffer type		 *		 * - stripBuffer(0, 3), return only the vertices		 * - stripBuffer(3, 3): return only the normals		 * - stripBuffer(6, 3): return only the tangents		 * - stripBuffer(9, 2): return only the uv's		 * - stripBuffer(11, 2): return only the secondary uv's		 */
		public function stripBuffer(offset:Number, numEntries:Number):Vector.<Number>
		{
			var data:Vector.<Number> = new Vector.<Number>( _pNumVertices*numEntries );// Vector.<Number>(_pNumVertices*numEntries);
			var i:Number = 0;
            var j:Number = offset;
			var skip:Number = 13 - numEntries;
			
			for (var v:Number = 0; v < _pNumVertices; ++v)
            {
				for (var k:Number = 0; k < numEntries; ++k)
                {
                    data[i++] = _vertexData[j++];
                }

				j += skip;

			}
			
			return data;

		}
		
		public function fromVectors(verts:Vector.<Number>, uvs:Vector.<Number>, normals:Vector.<Number>, tangents:Vector.<Number>):void
		{
			var vertLen:Number = verts.length/3*13;
			
			var index:Number = 0;
			var v:Number = 0;
			var n:Number = 0;
			var t:Number = 0;
			var u:Number = 0;
			
			var data:Vector.<Number> = new Vector.<Number>( vertLen );//Vector.<Number>(vertLen, true);
			
			while (index < vertLen)
            {

				data[index++] = verts[v++];
				data[index++] = verts[v++];
				data[index++] = verts[v++];
				
				if (normals && normals.length)
                {
                   	data[index++] = normals[n++];
					data[index++] = normals[n++];
					data[index++] = normals[n++];
				}
                else
                {
					data[index++] = 0;
					data[index++] = 0;
					data[index++] = 0;
				}
				
				if (tangents && tangents.length)
                {
					data[index++] = tangents[t++];
					data[index++] = tangents[t++];
					data[index++] = tangents[t++];
				}
                else
                {
					data[index++] = 0;
					data[index++] = 0;
					data[index++] = 0;
				}
				
				if (uvs && uvs.length)
                {
					data[index++] = uvs[u];
					data[index++] = uvs[u + 1];
					// use same secondary uvs as primary
					data[index++] = uvs[u++];
					data[index++] = uvs[u++];
				}
                else
                {
					data[index++] = 0;
					data[index++] = 0;
					data[index++] = 0;
					data[index++] = 0;
				}
			}
			
			autoDeriveVertexNormals = !(normals && normals.length);
            autoDeriveVertexTangents = !(tangents && tangents.length);
            autoGenerateDummyUVs = !(uvs && uvs.length);
            updateData(data);

		}
	}
}
