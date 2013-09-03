///<reference path="../../_definitions.ts"/>

package away.materials.compilation
{
	
	/**
	public class ShaderRegisterCache
	{
		private var _fragmentTempCache:RegisterPool;
		private var _vertexTempCache:RegisterPool;
		private var _varyingCache:RegisterPool;
		private var _fragmentConstantsCache:RegisterPool;
		private var _vertexConstantsCache:RegisterPool;
		private var _textureCache:RegisterPool;
		private var _vertexAttributesCache:RegisterPool;
		private var _vertexConstantOffset:Number; //TODO: check if this should be initialised to 0
		private var _fragmentOutputRegister:ShaderRegisterElement;
		private var _vertexOutputRegister:ShaderRegisterElement;
		private var _numUsedVertexConstants:Number = 0;
		private var _numUsedFragmentConstants:Number = 0;
		private var _numUsedStreams:Number = 0;
		private var _numUsedTextures:Number = 0;
		private var _numUsedVaryings:Number = 0;
		private var _profile:String;
		
		/**
		public function ShaderRegisterCache(profile:String):void
		{

			this._profile = profile;

		}
		
		/**
		public function reset():void
		{

            //TODO: AGAL <> GLSL Conversion

			_fragmentTempCache = new RegisterPool("ft", 8, false);
            _vertexTempCache = new RegisterPool("vt", 8, false);
            _varyingCache = new RegisterPool("v", 8);
            _textureCache = new RegisterPool("fs", 8);
            _vertexAttributesCache = new RegisterPool("va", 8);
            _fragmentConstantsCache = new RegisterPool("fc", 28);
            _vertexConstantsCache = new RegisterPool("vc", 128);
            _fragmentOutputRegister = new ShaderRegisterElement("oc", -1);
            _vertexOutputRegister = new ShaderRegisterElement("op", -1);
            _numUsedVertexConstants = 0;
            _numUsedStreams = 0;
            _numUsedTextures = 0;
            _numUsedVaryings = 0;
            _numUsedFragmentConstants = 0;

			var i:Number;

			for (i = 0; i < _vertexAttributesOffset; ++i)
                getFreeVertexAttribute();

			for (i = 0; i < _vertexConstantOffset; ++i)
                getFreeVertexConstant();

			for (i = 0; i < _varyingsOffset; ++i)
                getFreeVarying();

			for (i = 0; i < _fragmentConstantOffset; ++i)
                getFreeFragmentConstant();
		
		}

		/**
		public function dispose():void
		{

			_fragmentTempCache.dispose();
            _vertexTempCache.dispose();
            _varyingCache.dispose();
            _fragmentConstantsCache.dispose();
            _vertexAttributesCache.dispose();

            _fragmentTempCache = null;
            _vertexTempCache = null;
            _varyingCache = null;
            _fragmentConstantsCache = null;
            _vertexAttributesCache = null;
            _fragmentOutputRegister = null;
            _vertexOutputRegister = null;

		}
		
		/**
		public function addFragmentTempUsages(register:ShaderRegisterElement, usageCount:Number):void
		{
			_fragmentTempCache.addUsage(register, usageCount);
		}
		
		/**
		public function removeFragmentTempUsage(register:ShaderRegisterElement):void
		{
            _fragmentTempCache.removeUsage(register);
		}
		
		/**
		public function addVertexTempUsages(register:ShaderRegisterElement, usageCount:Number):void
		{
			_vertexTempCache.addUsage(register, usageCount);
		}
		
		/**
		public function removeVertexTempUsage(register:ShaderRegisterElement):void
		{
			_vertexTempCache.removeUsage(register);
		}
		
		/**
		public function getFreeFragmentVectorTemp():ShaderRegisterElement
		{
			return _fragmentTempCache.requestFreeVectorReg();
		}
		
		/**
		public function getFreeFragmentSingleTemp():ShaderRegisterElement
		{
			return _fragmentTempCache.requestFreeRegComponent();
		}
		
		/**
		public function getFreeVarying():ShaderRegisterElement
		{
			++_numUsedVaryings;
			return _varyingCache.requestFreeVectorReg();
		}
		
		/**
		public function getFreeFragmentConstant():ShaderRegisterElement
		{
			++_numUsedFragmentConstants;
			return _fragmentConstantsCache.requestFreeVectorReg();

		}
		
		/**
		public function getFreeVertexConstant():ShaderRegisterElement
		{
			++_numUsedVertexConstants;
			return _vertexConstantsCache.requestFreeVectorReg();
		}
		
		/**
		public function getFreeVertexVectorTemp():ShaderRegisterElement
		{
			return _vertexTempCache.requestFreeVectorReg();
		}
		
		/**
		public function getFreeVertexSingleTemp():ShaderRegisterElement
		{
			return _vertexTempCache.requestFreeRegComponent();
		}
		
		/**
		public function getFreeVertexAttribute():ShaderRegisterElement
		{
			++_numUsedStreams;
			return _vertexAttributesCache.requestFreeVectorReg();
		}
		
		/**
		public function getFreeTextureReg():ShaderRegisterElement
		{
			++_numUsedTextures;
			return _textureCache.requestFreeVectorReg();
		}
		
		/**
		public function get vertexConstantOffset():Number
		{
			return _vertexConstantOffset;
		}
		
		public function set vertexConstantOffset(vertexConstantOffset:Number):void
		{
			this._vertexConstantOffset = vertexConstantOffset;
		}
		
		/**
		public function get vertexAttributesOffset():Number
		{
			return _vertexAttributesOffset;
		}
		
		public function set vertexAttributesOffset(value:Number):void
		{
			this._vertexAttributesOffset = value;
		}

		/**
		public function get varyingsOffset():Number
		{
			return _varyingsOffset;
		}
		
		public function set varyingsOffset(value:Number):void
		{
            this._varyingsOffset = value;
		}

		/**
		public function get fragmentConstantOffset():Number
		{
			return _fragmentConstantOffset;
		}
		
		public function set fragmentConstantOffset(value:Number):void
		{
            this._fragmentConstantOffset = value;
		}
		
		/**
		public function get fragmentOutputRegister():ShaderRegisterElement
		{
			return _fragmentOutputRegister;
		}
		
		/**
		public function get numUsedVertexConstants():Number
		{
			return _numUsedVertexConstants;
		}
		
		/**
		public function get numUsedFragmentConstants():Number
		{
			return _numUsedFragmentConstants;
		}
		
		/**
		public function get numUsedStreams():Number
		{
			return _numUsedStreams;
		}

		/**
		public function get numUsedTextures():Number
		{
			return _numUsedTextures;
		}

		/**
		public function get numUsedVaryings():Number
		{
			return _numUsedVaryings;
		}
	}
}