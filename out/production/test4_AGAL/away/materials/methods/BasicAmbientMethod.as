/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package away.materials.methods
{
	import away.textures.Texture2DBase;
	import away.materials.compilation.ShaderRegisterElement;
	import away.materials.compilation.ShaderRegisterCache;
	import away.managers.Stage3DProxy;
	import away.core.display3D.Context3DWrapMode;
	import away.core.display3D.Context3DTextureFilter;
	import away.core.display3D.Context3DMipFilter;
	import away.core.base.IRenderable;
	import away.cameras.Camera3D;

import randori.webkit.page.Window;

/**
	 * BasicAmbientMethod provides the default shading method for uniform ambient lighting.
	 */
	public class BasicAmbientMethod extends ShadingMethodBase
	{
		private var _useTexture:Boolean = false;
		private var _texture:Texture2DBase;
		
		private var _ambientInputRegister:ShaderRegisterElement;
		
		private var _ambientColor:Number = 0xffffff;

		private var _ambientR:Number = 0;
        private var _ambientG:Number = 0;
        private var _ambientB:Number = 0;

		private var _ambient:Number = 1;

		public var _iLightAmbientR:Number = 0;
		public var _iLightAmbientG:Number = 0;
		public var _iLightAmbientB:Number = 0;
		
		/**
		 * Creates a new BasicAmbientMethod object.
		 */
		public function BasicAmbientMethod():void
		{
			super();
		}

		/**
		 * @inheritDoc
		 */
		override public function iInitVO(vo:MethodVO):void
		{
			vo.needsUV = this._useTexture;
		}

		/**
		 * @inheritDoc
		 */
		override public function iInitConstants(vo:MethodVO):void
		{
			vo.fragmentData[vo.fragmentConstantsIndex + 3] = 1;
		}
		
		/**
		 * The strength of the ambient reflection of the surface.
		 */
		public function get ambient():Number
		{
			return this._ambient;
		}
		
		public function set ambient(value:Number):void
		{
            this._ambient = value;
		}
		
		/**
		 * The colour of the ambient reflection of the surface.
		 */
		public function get ambientColor():Number
		{
			return this._ambientColor;
		}
		
		public function set ambientColor(value:Number):void
		{
            this._ambientColor = value;
		}
		
		/**
		 * The bitmapData to use to define the diffuse reflection color per texel.
		 */
		public function get texture():Texture2DBase
		{
			return this._texture;
		}
		
		public function set texture(value:Texture2DBase):void
		{

            var b : Boolean =  ( value != null );

            /* // ORIGINAL conditional
             if (Boolean(value) != _useTexture ||
             (value && _texture && (value.hasMipMaps != _texture.hasMipMaps || value.format != _texture.format))) {
             invalidateShaderProgram();
             }
             */
			if ( b != this._useTexture ||
				(value && this._texture && (value.hasMipMaps != this._texture.hasMipMaps || value.format != this._texture.format))) {
				this.iInvalidateShaderProgram();//invalidateShaderProgram();
			}
			this._useTexture = b;//Boolean(value);
			this._texture = value;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function copyFrom(method:ShadingMethodBase):void
		{
            var m : * = method;
            var b : BasicAmbientMethod = (m as BasicAmbientMethod);

            var diff:BasicAmbientMethod = b;//BasicAmbientMethod(method);

			this.ambient = diff.ambient;
			this.ambientColor = diff.ambientColor;
		}

		/**
		 * @inheritDoc
		 */
		override public function iCleanCompilationData():void
		{
			super.iCleanCompilationData();
			this._ambientInputRegister = null;
		}
		
		/**
		 * @inheritDoc
		 */
		public function iGetFragmentCode(vo:MethodVO, regCache:ShaderRegisterCache, targetReg:ShaderRegisterElement):String
		{

			var code:String = "";
			
			if (this._useTexture)
            {

				this._ambientInputRegister = regCache.getFreeTextureReg();

				vo.texturesIndex = this._ambientInputRegister.index;

                // TODO: AGAL <> GLSL
				code += this.pGetTex2DSampleCode(vo, targetReg, this._ambientInputRegister, this._texture) + "div " + targetReg.toString() + ".xyz, " + targetReg.toString() + ".xyz, " + targetReg.toString() + ".w\n"; // apparently, still needs to un-premultiply :s

			}
            else
            {

				this._ambientInputRegister = regCache.getFreeFragmentConstant();
				vo.fragmentConstantsIndex = this._ambientInputRegister.index*4;

				code += "mov " + targetReg.toString() + ", " + this._ambientInputRegister.toString() + "\n";

			}
			
			return code;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function iActivate(vo:MethodVO, stage3DProxy:Stage3DProxy):void
		{
            if ( this._useTexture)
            {

                stage3DProxy._iContext3D.setSamplerStateAt( vo.texturesIndex ,
                    vo.repeatTextures ?  Context3DWrapMode.REPEAT :  Context3DWrapMode.CLAMP,
                    vo.useSmoothTextures ? Context3DTextureFilter.LINEAR : Context3DTextureFilter.NEAREST ,
                    vo.useMipmapping ? Context3DMipFilter.MIPLINEAR : Context3DMipFilter.MIPNONE );

                stage3DProxy._iContext3D.setTextureAt(vo.texturesIndex, this._texture.getTextureForStage3D(stage3DProxy));

            }

		}
		
		/**
		 * Updates the ambient color data used by the render state.
		 */
		private function updateAmbient():void
		{
			this._ambientR = ((this._ambientColor >> 16) & 0xff)/0xff*this._ambient*this._iLightAmbientR;
            this._ambientG = ((this._ambientColor >> 8) & 0xff)/0xff*this._ambient*this._iLightAmbientG;
            this._ambientB = (this.ambientColor & 0xff)/0xff*this._ambient*this._iLightAmbientB;
		}

		/**
		 * @inheritDoc
		 */
		override public function iSetRenderState(vo:MethodVO, renderable:IRenderable, stage3DProxy:Stage3DProxy, camera:Camera3D):void
		{
			this.updateAmbient();
			
			if (!this._useTexture)
            {

				var index:Number = vo.fragmentConstantsIndex;
				var data:Vector.<Number> = vo.fragmentData;
				data[index] = this._ambientR;
				data[index + 1] = this._ambientG;
				data[index + 2] = this._ambientB;

			}
		}
	}
}
