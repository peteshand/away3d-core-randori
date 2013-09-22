///<reference path="../_definitions.ts"/>
package away.base
{
	import away.display3D.VertexBuffer3D;
	import away.display3D.Context3D;
	import away.managers.Stage3DProxy;
	import away.display3D.Context3DVertexBufferFormat;
	import away.geom.Matrix3D;
	import away.utils.VectorNumber;
    /**     * @class away.base.Geometry     */
	public class CompactSubGeometry extends SubGeometryBase implements ISubGeometry
	{
		public var _pVertexDataInvalid:Vector.<Boolean>//new Vector.<Boolean>(8, true); = new Vector.<Boolean>( 8 )
		private var _vertexBuffer:Vector.<VertexBuffer3D>//Vector.<VertexBuffer3D> = new Vector.<VertexBuffer3D>(8); = new Vector.<VertexBuffer3D>( 8 )
		private var _bufferContext:Vector.<Context3D>//Vector.<Context3D> = new Vector.<Context3D>(8); = new Vector.<Context3D>( 8 )
		public var _pNumVertices:Number;
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
			return this._pNumVertices;
		}
		
		/**		 * Updates the vertex data. All vertex properties are contained in a single Vector, and the order is as follows:		 * 0 - 2: vertex position X, Y, Z		 * 3 - 5: normal X, Y, Z		 * 6 - 8: tangent X, Y, Z		 * 9 - 10: U V		 * 11 - 12: Secondary U V		 */
		public function updateData(data:Vector.<Number>):void
		{
			if (this._autoDeriveVertexNormals)
            {
                this._vertexNormalsDirty = true;
            }

			if (this._autoDeriveVertexTangents)
            {
                this._vertexTangentsDirty = true;
            }

			this._faceNormalsDirty = true;
            this._faceTangentsDirty = true;
            this._isolatedVertexPositionDataDirty = true;
            this._vertexData = data;

			var numVertices:Number = this._vertexData.length/13;

			if (numVertices != this._pNumVertices)
            {
                this.pDisposeVertexBuffers(this._vertexBuffer);
            }

			this._pNumVertices = numVertices;
			
			if (this._pNumVertices == 0)
            {
                throw new Error("Bad data: geometry can't have zero triangles");
            }

			this.pInvalidateBuffers( this._pVertexDataInvalid );
            this.pInvalidateBounds();

		}
		
		public function activateVertexBuffer(index:Number, stage3DProxy:Stage3DProxy):void
		{
			var contextIndex:Number = stage3DProxy._iStage3DIndex;
			var context:Context3D = stage3DProxy._iContext3D;
			
			if (contextIndex != this._contextIndex)
            {
                this.pUpdateActiveBuffer(contextIndex);
            }

			if (!this._pActiveBuffer || this._activeContext != context)
            {
                this.pCreateBuffer(contextIndex, context);
            }

			if ( this._pActiveDataInvalid )
            {
                this.pUploadData(contextIndex);
            }

			context.setVertexBufferAt(index, this._pActiveBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);

		}
		
		public function activateUVBuffer(index:Number, stage3DProxy:Stage3DProxy):void
		{
			var contextIndex:Number = stage3DProxy._iStage3DIndex;
            var context:Context3D = stage3DProxy._iContext3D;
			
			if (this._uvsDirty && this._autoGenerateUVs)
            {
				this._vertexData = this.pUpdateDummyUVs( this._vertexData);
                this.pInvalidateBuffers( this._pVertexDataInvalid );
			}
			
			if (contextIndex != this._contextIndex)
            {
                this.pUpdateActiveBuffer( contextIndex );

            }

			if (!this._pActiveBuffer || this._activeContext != context)
            {
                this.pCreateBuffer( contextIndex , context );
            }

			if (this._pActiveDataInvalid)
            {
                this.pUploadData( contextIndex );
            }

			context.setVertexBufferAt(index, this._pActiveBuffer, 9, Context3DVertexBufferFormat.FLOAT_2);

		}
		
		public function activateSecondaryUVBuffer(index:Number, stage3DProxy:Stage3DProxy):void
		{
			var contextIndex:Number = stage3DProxy._iStage3DIndex;
			var context:Context3D = stage3DProxy._iContext3D;
			
			if (contextIndex != this._contextIndex)
            {
                this.pUpdateActiveBuffer( contextIndex );
            }

			if (!this._pActiveBuffer || this._activeContext != context)
            {
                this.pCreateBuffer( contextIndex , context );
            }

			if ( this._pActiveDataInvalid )
            {
                this.pUploadData( contextIndex );
            }

			context.setVertexBufferAt(index, this._pActiveBuffer, 11, Context3DVertexBufferFormat.FLOAT_2);

		}
		
		public function pUploadData(contextIndex:Number):void
		{
			this._pActiveBuffer.uploadFromArray(this._vertexData, 0, this._pNumVertices);
			this._pVertexDataInvalid[contextIndex] = false;
			this._pActiveDataInvalid = false;

		}
		
		public function activateVertexNormalBuffer(index:Number, stage3DProxy:Stage3DProxy):void
		{
			var contextIndex:Number = stage3DProxy._iStage3DIndex;
			var context:Context3D = stage3DProxy._iContext3D;
			
			if (contextIndex != this._contextIndex)
            {
                this.pUpdateActiveBuffer( contextIndex );
            }

			if (!this._pActiveBuffer || this._activeContext != context)
            {
                this.pCreateBuffer( contextIndex , context );
            }

			if (this._pActiveDataInvalid)
            {
                this.pUploadData(contextIndex);
            }

			context.setVertexBufferAt(index, this._pActiveBuffer, 3, Context3DVertexBufferFormat.FLOAT_3);

		}
		
		public function activateVertexTangentBuffer(index:Number, stage3DProxy:Stage3DProxy):void
		{
			var contextIndex:Number = stage3DProxy._iStage3DIndex;
			var context:Context3D = stage3DProxy._iContext3D;
			
			if (contextIndex != this._contextIndex)
            {
                this.pUpdateActiveBuffer( contextIndex );
            }

			if (!this._pActiveBuffer || this._activeContext != context)
            {
                this.pCreateBuffer( contextIndex , context );
            }

			if ( this._pActiveDataInvalid )
            {
                this.pUploadData(contextIndex);
            }

			
			context.setVertexBufferAt(index, this._pActiveBuffer, 6, Context3DVertexBufferFormat.FLOAT_3);

		}
		
		public function pCreateBuffer(contextIndex:Number, context:Context3D):void
		{
			this._vertexBuffer[contextIndex] = context.createVertexBuffer(this._pNumVertices, 13);
			this._pActiveBuffer = context.createVertexBuffer(this._pNumVertices, 13);

			this._bufferContext[contextIndex] = context;
			this._activeContext = context;

			this._pVertexDataInvalid[contextIndex] = true;
			this._pActiveDataInvalid = true;

		}
		
		public function pUpdateActiveBuffer(contextIndex:Number):void
		{
			this._contextIndex = contextIndex;
            this._pActiveDataInvalid = this._pVertexDataInvalid[contextIndex];
            this._pActiveBuffer = this._vertexBuffer[contextIndex];
            this._activeContext = this._bufferContext[contextIndex];
		}
		
		override public function get vertexData():Vector.<Number>
		{
			if ( this._autoDeriveVertexNormals && this._vertexNormalsDirty)
            {
                this._vertexData = this.pUpdateVertexNormals(this._vertexData);
            }

			if (this._autoDeriveVertexTangents && this._vertexTangentsDirty)
            {
                this._vertexData = this.pUpdateVertexTangents(this._vertexData);
            }

			if (this._uvsDirty && this._autoGenerateUVs)
            {
                this._vertexData = this.pUpdateDummyUVs( this._vertexData );
            }

			return this._vertexData;
		}
		
		override public function pUpdateVertexNormals(target:Vector.<Number>):Vector.<Number>
		{
            this.pInvalidateBuffers( this._pVertexDataInvalid);
			return super.pUpdateVertexNormals(target);
		}
		
		override public function pUpdateVertexTangents(target:Vector.<Number>):Vector.<Number>
		{
			if (this._vertexNormalsDirty)
            {
                this._vertexData = this.pUpdateVertexNormals( this._vertexData );
            }

			this.pInvalidateBuffers( this._pVertexDataInvalid);

			return super.pUpdateVertexTangents(target);

		}
		
		override public function get vertexNormalData():Vector.<Number>
		{
			if ( this._autoDeriveVertexNormals && this._vertexNormalsDirty)
            {
                this._vertexData = this.pUpdateVertexNormals(this._vertexData);
            }

			return this._vertexData;

		}
		
		override public function get vertexTangentData():Vector.<Number>
		{
			if ( this._autoDeriveVertexTangents && this._vertexTangentsDirty)
            {
                this._vertexData = this.pUpdateVertexTangents( this._vertexData );
            }

			return this._vertexData;
		}
		
		override public function get UVData():Vector.<Number>
		{
			if ( this._uvsDirty && this._autoGenerateUVs)
            {
				this._vertexData = this.pUpdateDummyUVs(this._vertexData);
				this.pInvalidateBuffers( this._pVertexDataInvalid );
			}

			return this._vertexData;
		}
		
		override public function applyTransformation(transform:Matrix3D):void
		{
			super.applyTransformation(transform);
			this.pInvalidateBuffers( this._pVertexDataInvalid );
		}
		
		override public function scale(scale:Number):void
		{
			super.scale(scale);
			this.pInvalidateBuffers(this._pVertexDataInvalid);
		}
		
		public function clone():ISubGeometry
		{
			var clone:CompactSubGeometry = new CompactSubGeometry();

			    clone._autoDeriveVertexNormals = this._autoDeriveVertexNormals;
			    clone._autoDeriveVertexTangents = this._autoDeriveVertexTangents;

                clone.updateData(this._vertexData.concat());
			    clone.updateIndexData(this._indices.concat());

			return clone;
		}
		
		override public function scaleUV(scaleU:Number = 1, scaleV:Number = 1):void
		{
			scaleU = scaleU || 1;
			scaleV = scaleV || 1;


			super.scaleUV(scaleU, scaleV);

			this.pInvalidateBuffers( this._pVertexDataInvalid );

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
			this.pDisposeVertexBuffers(this._vertexBuffer);
			this._vertexBuffer = null;
		}
		
		override public function pDisposeVertexBuffers(buffers:Vector.<VertexBuffer3D>):void
		{

			super.pDisposeVertexBuffers(buffers);
			this._pActiveBuffer = null;

		}
		
		override public function pInvalidateBuffers(invalid:Vector.<Boolean>):void
		{
			super.pInvalidateBuffers(invalid);
			this._pActiveDataInvalid = true;
		}

		public function cloneWithSeperateBuffers():SubGeometry
		{
			var clone:SubGeometry = new SubGeometry();

			clone.updateVertexData(this._isolatedVertexPositionData? this._isolatedVertexPositionData : this._isolatedVertexPositionData = this.stripBuffer(0, 3));
			clone.autoDeriveVertexNormals = this._autoDeriveVertexNormals;
			clone.autoDeriveVertexTangents = this._autoDeriveVertexTangents;

			if (!this._autoDeriveVertexNormals)
            {
                clone.updateVertexNormalData(this.stripBuffer(3, 3));
            }

			if (!this._autoDeriveVertexTangents)
            {
                clone.updateVertexTangentData(this.stripBuffer(6, 3));
            }

			clone.updateUVData(this.stripBuffer(9, 2));
			clone.updateSecondaryUVData(this.stripBuffer(11, 2));
			clone.updateIndexData(this.indexData.concat());

			return clone;

		}

        override public function get vertexPositionData():Vector.<Number>
        {
            if (this._isolatedVertexPositionDataDirty || !this._isolatedVertexPositionData)
            {
                this._isolatedVertexPositionData = this.stripBuffer(0, 3);
                this._isolatedVertexPositionDataDirty = false;
            }

            return this._isolatedVertexPositionData;

        }

        public function get strippedUVData():Vector.<Number>
        {
            return this.stripBuffer(9, 2);
        }
		
		/**		 * Isolate and returns a Vector.Number of a specific buffer type		 *		 * - stripBuffer(0, 3), return only the vertices		 * - stripBuffer(3, 3): return only the normals		 * - stripBuffer(6, 3): return only the tangents		 * - stripBuffer(9, 2): return only the uv's		 * - stripBuffer(11, 2): return only the secondary uv's		 */
		public function stripBuffer(offset:Number, numEntries:Number):Vector.<Number>
		{
			var data:Vector.<Number> = VectorNumber.init( this._pNumVertices*numEntries );// Vector.<Number>(_pNumVertices*numEntries);
			var i:Number = 0;
            var j:Number = offset;
			var skip:Number = 13 - numEntries;
			
			for (var v:Number = 0; v < this._pNumVertices; ++v)
            {
				for (var k:Number = 0; k < numEntries; ++k)
                {
                    data[i++] = this._vertexData[j++];
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
			
			var data:Vector.<Number> = VectorNumber.init( vertLen );//Vector.<Number>(vertLen, true);
			
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
			
			this.autoDeriveVertexNormals = !(normals && normals.length);
            this.autoDeriveVertexTangents = !(tangents && tangents.length);
            this.autoGenerateDummyUVs = !(uvs && uvs.length);
            this.updateData(data);

		}
	}
}
