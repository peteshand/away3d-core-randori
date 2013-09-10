///<reference path="../../_definitions.ts"/>
package away.materials.compilation
{
	
	/**
	 * ShaderRegister Cache provides the usage management system for all registers during shading compilation.
	 */
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
		private var _vertexAttributesOffset:Number;//TODO: check if this should be initialised to 0
		private var _varyingsOffset:Number;//TODO: check if this should be initialised to 0
		private var _fragmentConstantOffset:Number;//TODO: check if this should be initialised to 0
		
		private var _fragmentOutputRegister:ShaderRegisterElement;
		private var _vertexOutputRegister:ShaderRegisterElement;
		private var _numUsedVertexConstants:Number = 0;
		private var _numUsedFragmentConstants:Number = 0;
		private var _numUsedStreams:Number = 0;
		private var _numUsedTextures:Number = 0;
		private var _numUsedVaryings:Number = 0;
		private var _profile:String;
		
		/**
		 * Create a new ShaderRegisterCache object.
		 *
		 * @param profile The compatibility profile used by the renderer.
		 */
		public function ShaderRegisterCache(profile:String):void
		{

			_profile = profile;

		}
		
		/**
		 * Resets all registers.
		 */
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
		 * Disposes all resources used.
		 */
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
		 * Marks a fragment temporary register as used, so it cannot be retrieved. The register won't be able to be used until removeUsage
		 * has been called usageCount times again.
		 * @param register The register to mark as used.
		 * @param usageCount The amount of usages to add.
		 */
		public function addFragmentTempUsages(register:ShaderRegisterElement, usageCount:Number):void
		{
			_fragmentTempCache.addUsage(register, usageCount);
		}
		
		/**
		 * Removes a usage from a fragment temporary register. When usages reach 0, the register is freed again.
		 * @param register The register for which to remove a usage.
		 */
		public function removeFragmentTempUsage(register:ShaderRegisterElement):void
		{
            _fragmentTempCache.removeUsage(register);
		}
		
		/**
		 * Marks a vertex temporary register as used, so it cannot be retrieved. The register won't be able to be used
		 * until removeUsage has been called usageCount times again.
		 * @param register The register to mark as used.
		 * @param usageCount The amount of usages to add.
		 */
		public function addVertexTempUsages(register:ShaderRegisterElement, usageCount:Number):void
		{
			_vertexTempCache.addUsage(register, usageCount);
		}
		
		/**
		 * Removes a usage from a vertex temporary register. When usages reach 0, the register is freed again.
		 * @param register The register for which to remove a usage.
		 */
		public function removeVertexTempUsage(register:ShaderRegisterElement):void
		{
			_vertexTempCache.removeUsage(register);
		}
		
		/**
		 * Retrieve an entire fragment temporary register that's still available. The register won't be able to be used until removeUsage
		 * has been called usageCount times again.
		 */
		public function getFreeFragmentVectorTemp():ShaderRegisterElement
		{
			return _fragmentTempCache.requestFreeVectorReg();
		}
		
		/**
		 * Retrieve a single component from a fragment temporary register that's still available.
		 */
		public function getFreeFragmentSingleTemp():ShaderRegisterElement
		{
			return _fragmentTempCache.requestFreeRegComponent();
		}
		
		/**
		 * Retrieve an available varying register
		 */
		public function getFreeVarying():ShaderRegisterElement
		{
			++_numUsedVaryings;
			return _varyingCache.requestFreeVectorReg();
		}
		
		/**
		 * Retrieve an available fragment constant register
		 */
		public function getFreeFragmentConstant():ShaderRegisterElement
		{
			++_numUsedFragmentConstants;
			return _fragmentConstantsCache.requestFreeVectorReg();

		}
		
		/**
		 * Retrieve an available vertex constant register
		 */
		public function getFreeVertexConstant():ShaderRegisterElement
		{
			++_numUsedVertexConstants;
			return _vertexConstantsCache.requestFreeVectorReg();
		}
		
		/**
		 * Retrieve an entire vertex temporary register that's still available.
		 */
		public function getFreeVertexVectorTemp():ShaderRegisterElement
		{
			return _vertexTempCache.requestFreeVectorReg();
		}
		
		/**
		 * Retrieve a single component from a vertex temporary register that's still available.
		 */
		public function getFreeVertexSingleTemp():ShaderRegisterElement
		{
			return _vertexTempCache.requestFreeRegComponent();
		}
		
		/**
		 * Retrieve an available vertex attribute register
		 */
		public function getFreeVertexAttribute():ShaderRegisterElement
		{
			++_numUsedStreams;
			return _vertexAttributesCache.requestFreeVectorReg();
		}
		
		/**
		 * Retrieve an available texture register
		 */
		public function getFreeTextureReg():ShaderRegisterElement
		{
			++_numUsedTextures;
			return _textureCache.requestFreeVectorReg();
		}
		
		/**
		 * Indicates the start index from which to retrieve vertex constants.
		 */
		public function get vertexConstantOffset():Number
		{
			return _vertexConstantOffset;
		}
		
		public function set vertexConstantOffset(vertexConstantOffset:Number):void
		{
			_vertexConstantOffset = vertexConstantOffset;
		}
		
		/**
		 * Indicates the start index from which to retrieve vertex attributes.
		 */
		public function get vertexAttributesOffset():Number
		{
			return _vertexAttributesOffset;
		}
		
		public function set vertexAttributesOffset(value:Number):void
		{
			_vertexAttributesOffset = value;
		}

		/**
		 * Indicates the start index from which to retrieve varying registers.
		 */
		public function get varyingsOffset():Number
		{
			return _varyingsOffset;
		}
		
		public function set varyingsOffset(value:Number):void
		{
            _varyingsOffset = value;
		}

		/**
		 * Indicates the start index from which to retrieve fragment constants.
		 */
		public function get fragmentConstantOffset():Number
		{
			return _fragmentConstantOffset;
		}
		
		public function set fragmentConstantOffset(value:Number):void
		{
            _fragmentConstantOffset = value;
		}
		
		/**
		 * The fragment output register.
		 */
		public function get fragmentOutputRegister():ShaderRegisterElement
		{
			return _fragmentOutputRegister;
		}
		
		/**
		 * The amount of used vertex constant registers.
		 */
		public function get numUsedVertexConstants():Number
		{
			return _numUsedVertexConstants;
		}
		
		/**
		 * The amount of used fragment constant registers.
		 */
		public function get numUsedFragmentConstants():Number
		{
			return _numUsedFragmentConstants;
		}
		
		/**
		 * The amount of used vertex streams.
		 */
		public function get numUsedStreams():Number
		{
			return _numUsedStreams;
		}

		/**
		 * The amount of used texture slots.
		 */
		public function get numUsedTextures():Number
		{
			return _numUsedTextures;
		}

		/**
		 * The amount of used varying registers.
		 */
		public function get numUsedVaryings():Number
		{
			return _numUsedVaryings;
		}
	}
}
