///<reference path="../../_definitions.ts"/>

package away.materials.methods
{
	import away.textures.Texture2DBase;
	import away.materials.compilation.ShaderRegisterElement;
	import away.managers.Stage3DProxy;
	import away.display3D.Context3DWrapMode;
	import away.display3D.Context3DTextureFilter;
	import away.display3D.Context3DMipFilter;
	import away.materials.compilation.ShaderRegisterCache;

	/**	 * BasicNormalMethod is the default method for standard tangent-space normal mapping.	 */
	public class BasicNormalMethod extends ShadingMethodBase
	{
		private var _texture:Texture2DBase;
		private var _useTexture:Boolean;
		public var _pNormalTextureRegister:ShaderRegisterElement;

		/**		 * Creates a new BasicNormalMethod object.		 */
		public function BasicNormalMethod():void
		{
			super();
		}

		/**		 * @inheritDoc		 */
		override public function iInitVO(vo:MethodVO):void
		{
            if ( this._texture )
            {

                vo.needsUV = true;

            }
            else
            {

                vo.needsUV = false;

            }

			//vo.needsUV = Boolean(_texture);
		}

		/**		 * Indicates whether or not this method outputs normals in tangent space. Override for object-space normals.		 */
		public function get iTangentSpace():Boolean
		{
			return true;
		}
		
		/**		 * Indicates if the normal method output is not based on a texture (if not, it will usually always return true)		 * Override if subclasses are different.		 */
		public function get iHasOutput():Boolean
		{
			return this._useTexture;
		}

		/**		 * @inheritDoc		 */
		override public function copyFrom(method:ShadingMethodBase):void
		{

            var s : * = method;
            var bnm : BasicNormalMethod = (method as BasicNormalMethod);

            this.normalMap = bnm.normalMap;

		}

		/**		 * The texture containing the normals per pixel.		 */
		public function get normalMap():Texture2DBase
		{
			return this._texture;
		}
		
		public function set normalMap(value:Texture2DBase):void
		{

            this.setNormalMap( value );

		}

        public function setNormalMap(value:Texture2DBase):void
        {

            var b : Boolean =  ( value != null );

            if ( b != this._useTexture ||
                (value && this._texture && (value.hasMipMaps != this._texture.hasMipMaps || value.format != this._texture.format))) {
                this.iInvalidateShaderProgram();//invalidateShaderProgram();
            }
            this._useTexture = Boolean(value);
            this._texture = value;

        }

		/**		 * @inheritDoc		 */
		override public function iCleanCompilationData():void
		{
			super.iCleanCompilationData();
			this._pNormalTextureRegister = null;
		}

		/**		 * @inheritDoc		 */
		override public function dispose():void
		{
			if (this._texture)
            {

                this._texture = null;

            }

		}


		/**		 * @inheritDoc		 */
		override public function iActivate(vo:MethodVO, stage3DProxy:Stage3DProxy):void
		{
			if (vo.texturesIndex >= 0)
            {

                stage3DProxy._iContext3D.setSamplerStateAt( vo.texturesIndex ,
                        vo.repeatTextures ?  Context3DWrapMode.REPEAT :  Context3DWrapMode.CLAMP,
                        vo.useSmoothTextures ? Context3DTextureFilter.LINEAR : Context3DTextureFilter.NEAREST ,
                        vo.useMipmapping ? Context3DMipFilter.MIPLINEAR : Context3DMipFilter.MIPNONE );
                stage3DProxy._iContext3D.setTextureAt( vo.texturesIndex, this._texture.getTextureForStage3D(stage3DProxy));

            }

		}

		/**		 * @inheritDoc		 */
		public function iGetFragmentCode(vo:MethodVO, regCache:ShaderRegisterCache, targetReg:ShaderRegisterElement):String
		{
			this._pNormalTextureRegister = regCache.getFreeTextureReg();

			vo.texturesIndex = this._pNormalTextureRegister.index;

            // TODO: AGAL <> GLSL

			return this.pGetTex2DSampleCode(vo, targetReg, this._pNormalTextureRegister, this._texture) +
				"sub " + targetReg.toString() + ".xyz, " + targetReg.toString() + ".xyz, " + this._sharedRegisters.commons.toString() + ".xxx	\n" +
				"nrm " + targetReg.toString() + ".xyz, " + targetReg.toString() + ".xyz							\n";

		}
	}
}
