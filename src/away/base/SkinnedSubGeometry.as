///<reference path="../_definitions.ts" />

package away.base
{
	import away.display3D.VertexBuffer3D;
	import away.display3D.Context3D;
	import away.managers.Stage3DProxy;

	/**
	public class SkinnedSubGeometry extends CompactSubGeometry
	{
		private var _bufferFormat:String;
		private var _jointWeightsData:Vector.<Number>;
		private var _jointIndexData:Vector.<Number>;
		private var _animatedData:Vector.<Number>; // used for cpu fallback
		private var _jointIndexBuffer:Vector.<VertexBuffer3D> = new Vector.<VertexBuffer3D>(8);
		private var _jointWeightsInvalid:Vector.<Boolean> = new Vector.<Boolean>(8);
		private var _jointIndicesInvalid:Vector.<Boolean> = new Vector.<Boolean>(8);
		private var _jointWeightContext:Vector.<Context3D> = new Vector.<Context3D>(8);
		private var _jointIndexContext:Vector.<Context3D> = new Vector.<Context3D>(8);
		private var _jointsPerVertex:Number;
		
		private var _condensedJointIndexData:Vector.<Number>;
		private var _condensedIndexLookUp:Vector.<Number>/*uint*/; // used for linking condensed indices to the real ones
		
		/**
		public function SkinnedSubGeometry(jointsPerVertex:Number):void
		{
			super();

			this._jointsPerVertex = jointsPerVertex;
            this._bufferFormat = "float" + this._jointsPerVertex;
		}
		
		/**
		public function get condensedIndexLookUp():Vector.<Number> /*uint*/		{
			return _condensedIndexLookUp;
		}
		
		/**
		public function get numCondensedJoints():Number
		{
			return _numCondensedJoints;
		}
		
		/**
		public function get animatedData():Vector.<Number>
		{
			return _animatedData ||_vertexData.concat();
		}
		
		public function updateAnimatedData(value:Vector.<Number>):void
		{
            _animatedData = value;
            pInvalidateBuffers( _pVertexDataInvalid );
		}
		
		/**
		public function activateJointWeightsBuffer(index:Number, stage3DProxy:Stage3DProxy):void
		{
			var contextIndex:Number = stage3DProxy._iStage3DIndex;
			var context:Context3D = stage3DProxy._iContext3D;
			if (_jointWeightContext[contextIndex] != context || !_jointWeightsBuffer[contextIndex]) {
                _jointWeightsBuffer[contextIndex] = context.createVertexBuffer(_pNumVertices, _jointsPerVertex);
                _jointWeightContext[contextIndex] = context;
                _jointWeightsInvalid[contextIndex] = true;
			}
			if (_jointWeightsInvalid[contextIndex]) {
                _jointWeightsBuffer[contextIndex].uploadFromArray(_jointWeightsData, 0, _jointWeightsData.length/_jointsPerVertex);
                _jointWeightsInvalid[contextIndex] = false;
			}
			context.setVertexBufferAt(index, _jointWeightsBuffer[contextIndex], 0, _bufferFormat);
		}
		
		/**
		public function activateJointIndexBuffer(index:Number, stage3DProxy:Stage3DProxy):void
		{
			var contextIndex:Number = stage3DProxy._iStage3DIndex;
			var context:Context3D = stage3DProxy._iContext3D;
			
			if (_jointIndexContext[contextIndex] != context || !_jointIndexBuffer[contextIndex]) {
                _jointIndexBuffer[contextIndex] = context.createVertexBuffer(_pNumVertices, _jointsPerVertex);
                _jointIndexContext[contextIndex] = context;
                _jointIndicesInvalid[contextIndex] = true;
			}
			if (_jointIndicesInvalid[contextIndex]) {
                _jointIndexBuffer[contextIndex].uploadFromArray(_numCondensedJoints > 0? _condensedJointIndexData : _jointIndexData, 0, _jointIndexData.length/_jointsPerVertex);
                _jointIndicesInvalid[contextIndex] = false;
			}
			context.setVertexBufferAt(index, _jointIndexBuffer[contextIndex], 0, _bufferFormat);
		}
		
		override public function pUploadData(contextIndex:Number):void
		{
			if (_animatedData) {
                _pActiveBuffer.uploadFromArray(_animatedData, 0, _pNumVertices);
                _pVertexDataInvalid[contextIndex] = _pActiveDataInvalid = false;
			}
            else
            {
				super.pUploadData(contextIndex);
            }
		}
		
		/**
		override public function clone():ISubGeometry
		{
			var clone:SkinnedSubGeometry = new SkinnedSubGeometry(_jointsPerVertex);

			clone.updateData(_vertexData.concat());
			clone.updateIndexData(_indices.concat());
			clone.iUpdateJointIndexData(_jointIndexData.concat());
			clone.iUpdateJointWeightsData(_jointWeightsData.concat());
			clone._autoDeriveVertexNormals = _autoDeriveVertexNormals;
			clone._autoDeriveVertexTangents = _autoDeriveVertexTangents;
			clone._numCondensedJoints = _numCondensedJoints;
			clone._condensedIndexLookUp = _condensedIndexLookUp;
			clone._condensedJointIndexData = _condensedJointIndexData;

			return clone;
		}
		
		/**
		override public function dispose():void
		{
			super.dispose();
            pDisposeVertexBuffers(_jointWeightsBuffer);
            pDisposeVertexBuffers(_jointIndexBuffer);
		}
		
		/**
		public function iCondenseIndexData():void
		{
			var len:Number = _jointIndexData.length;
			var oldIndex:Number;
			var newIndex:Number = 0;
			var dic:Object = new Object();

            _condensedJointIndexData = new Vector.<Number>(len);
            _condensedIndexLookUp = new Vector.<Number>();
			
			for (var i:Number = 0; i < len; ++i) {
				oldIndex = _jointIndexData[i];
				
				// if we encounter a new index, assign it a new condensed index
				if (dic[oldIndex] == undefined) {
					dic[oldIndex] = newIndex;
                    _condensedIndexLookUp[newIndex++] = oldIndex;
                    _condensedIndexLookUp[newIndex++] = oldIndex + 1;
                    _condensedIndexLookUp[newIndex++] = oldIndex + 2;
				}
                _condensedJointIndexData[i] = dic[oldIndex];
			}
            _numCondensedJoints = newIndex/3;

            pInvalidateBuffers(_jointIndicesInvalid);
		}
		
		/**
		public function get iJointWeightsData():Vector.<Number>
		{
			return _jointWeightsData;
		}
		
		public function iUpdateJointWeightsData(value:Vector.<Number>):void
		{
			// invalidate condensed stuff
            _numCondensedJoints = 0;
            _condensedIndexLookUp = null;
            _condensedJointIndexData = null;

            _jointWeightsData = value;
            pInvalidateBuffers(_jointWeightsInvalid);
		}
		
		/**
		public function get iJointIndexData():Vector.<Number>
		{
			return _jointIndexData;
		}
		
		public function iUpdateJointIndexData(value:Vector.<Number>):void
		{
            _jointIndexData = value;
			pInvalidateBuffers(_jointIndicesInvalid);
		}
	}
}