///<reference path="../../_definitions.ts"/>

package away.materials.methods
{
	import away.textures.Texture2DBase;
	import away.materials.compilation.ShaderRegisterElement;
	import away.utils.Debug;
	import away.materials.compilation.ShaderRegisterCache;
	import away.managers.Stage3DProxy;
	import away.display3D.Context3DWrapMode;
	import away.display3D.Context3DTextureFilter;
	import away.display3D.Context3DMipFilter;
	import away.base.IRenderable;
	import away.cameras.Camera3D;

	/**	 * BasicAmbientMethod provides the default shading method for uniform ambient lighting.	 */
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
		
		/**		 * Creates a new BasicAmbientMethod object.		 */
		public function BasicAmbientMethod():void
		{
			super();
		}

		/**		 * @inheritDoc		 */
		override public function iInitVO(vo:MethodVO):void
		{
			vo.needsUV = _useTexture;
		}

		/**		 * @inheritDoc		 */
		override public function iInitConstants(vo:MethodVO):void
		{
			vo.fragmentData[vo.fragmentConstantsIndex + 3] = 1;
		}
		
		/**		 * The strength of the ambient reflection of the surface.		 */
		public function get ambient():Number
		{
			return _ambient;
		}
		
		public function set ambient(value:Number):void
		{
            _ambient = value;
		}
		
		/**		 * The colour of the ambient reflection of the surface.		 */
		public function get ambientColor():Number
		{
			return _ambientColor;
		}
		
		public function set ambientColor(value:Number):void
		{
            _ambientColor = value;
		}
		
		/**		 * The bitmapData to use to define the diffuse reflection color per texel.		 */
		public function get texture():Texture2DBase
		{
			return _texture;
		}
		
		public function set texture(value:Texture2DBase):void
		{

            // TODO: Check - TRICKY
            Debug.throwPIR( 'BasicAmbientMethod' , 'set texture' , 'TRICKY - Odd boolean assignment - needs testing' );

            var b : Boolean =  ( value != null );

            /* // ORIGINAL conditional             if (Boolean(value) != _useTexture ||             (value && _texture && (value.hasMipMaps != _texture.hasMipMaps || value.format != _texture.format))) {             invalidateShaderProgram();             }             */
			if ( b != _useTexture ||
				(value && _texture && (value.hasMipMaps != _texture.hasMipMaps || value.format != _texture.format))) {
				iInvalidateShaderProgram();//invalidateShaderProgram();
			}
			_useTexture = b;//Boolean(value);
			_texture = value;
		}
		
		/**		 * @inheritDoc		 */
		override public function copyFrom(method:ShadingMethodBase):void
		{

            // TODO: Check - TRICKY
            Debug.throwPIR( 'BasicAmbientMethod' , 'copyFrom' , 'TRICKY - Odd case assignment - needs testing' );

            var m : * = method;
            var b : BasicAmbientMethod = (m as BasicAmbientMethod);

            var diff:BasicAmbientMethod = b;//BasicAmbientMethod(method);

			ambient = diff.ambient;
			ambientColor = diff.ambientColor;

		}

		/**		 * @inheritDoc		 */
		override public function iCleanCompilationData():void
		{
			super.iCleanCompilationData();
			_ambientInputRegister = null;
		}
		
		/**		 * @inheritDoc		 */
		public function iGetFragmentCode(vo:MethodVO, regCache:ShaderRegisterCache, targetReg:ShaderRegisterElement):String
		{

			var code:String = "";
			
			if (_useTexture)
            {

				_ambientInputRegister = regCache.getFreeTextureReg();

				vo.texturesIndex = _ambientInputRegister.index;

                // TODO: AGAL <> GLSL
				code += pGetTex2DSampleCode(vo, targetReg, _ambientInputRegister, _texture) + "div " + targetReg.toString() + ".xyz, " + targetReg.toString() + ".xyz, " + targetReg.toString() + ".w\n"; // apparently, still needs to un-premultiply :s

			}
            else
            {

				_ambientInputRegister = regCache.getFreeFragmentConstant();
				vo.fragmentConstantsIndex = _ambientInputRegister.index*4;

				code += "mov " + targetReg.toString() + ", " + _ambientInputRegister.toString() + "\n";

			}
			
			return code;
		}
		
		/**		 * @inheritDoc		 */
		override public function iActivate(vo:MethodVO, stage3DProxy:Stage3DProxy):void
		{
			if ( _useTexture)
            {

                stage3DProxy._iContext3D.setSamplerStateAt( vo.texturesIndex ,
                    vo.repeatTextures ?  Context3DWrapMode.REPEAT :  Context3DWrapMode.CLAMP,
                    vo.useSmoothTextures ? Context3DTextureFilter.LINEAR : Context3DTextureFilter.NEAREST ,
                    vo.useMipmapping ? Context3DMipFilter.MIPLINEAR : Context3DMipFilter.MIPNONE );

                stage3DProxy._iContext3D.setTextureAt(vo.texturesIndex, _texture.getTextureForStage3D(stage3DProxy));

            }

		}
		
		/**		 * Updates the ambient color data used by the render state.		 */
		private function updateAmbient():void
		{
			_ambientR = ((_ambientColor >> 16) & 0xff)/0xff*_ambient*_iLightAmbientR;
            _ambientG = ((_ambientColor >> 8) & 0xff)/0xff*_ambient*_iLightAmbientG;
            _ambientB = (ambientColor & 0xff)/0xff*_ambient*_iLightAmbientB;
		}

		/**		 * @inheritDoc		 */
		override public function iSetRenderState(vo:MethodVO, renderable:IRenderable, stage3DProxy:Stage3DProxy, camera:Camera3D):void
		{
			updateAmbient();
			
			if (!_useTexture)
            {

				var index:Number = vo.fragmentConstantsIndex;
				var data:Vector.<Number> = vo.fragmentData;
				data[index] = _ambientR;
				data[index + 1] = _ambientG;
				data[index + 2] = _ambientB;

			}
		}
	}
}
