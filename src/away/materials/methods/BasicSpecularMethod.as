/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package away.materials.methods
{
	import away.materials.compilation.ShaderRegisterElement;
	import away.textures.Texture2DBase;
	import away.materials.compilation.ShaderRegisterCache;
	import away.managers.Stage3DProxy;
	import away.display3D.Context3DWrapMode;
	import away.display3D.Context3DTextureFilter;
	import away.display3D.Context3DMipFilter;
	//import away3d.*;
	//import away3d.managers.*;
	//import away3d.materials.compilation.*;
	//import away3d.textures.*;
	
	//use namespace arcane;
	
	/**	 * BasicSpecularMethod provides the default shading method for Blinn-Phong specular highlights (an optimized but approximated	 * version of Phong specularity).	 */
	public class BasicSpecularMethod extends LightingMethodBase
	{
		private var _useTexture:Boolean = false;
		private var _totalLightColorReg:ShaderRegisterElement;
		private var _specularTextureRegister:ShaderRegisterElement;
		private var _specularTexData:ShaderRegisterElement;
		private var _specularDataRegister:ShaderRegisterElement;
		
		private var _texture:Texture2DBase;
		
		private var _gloss:Number = 50;
		private var _specular:Number = 1;
		private var _specularColor:Number = 0xffffff;
		public var _iSpecularR:Number = 1;
        public var _iSpecularG:Number = 1;
        public var _iSpecularB:Number = 1;
		private var _shadowRegister:ShaderRegisterElement;
		private var _isFirstLight:Boolean = false;
		
		/**		 * Creates a new BasicSpecularMethod object.		 */
		public function BasicSpecularMethod():void
		{
			super();
		}

		/**		 * @inheritDoc		 */
		override public function iInitVO(vo:MethodVO):void
		{
			vo.needsUV = this._useTexture;
			vo.needsNormals = vo.numLights > 0;
			vo.needsView = vo.numLights > 0;
		}
		
		/**		 * The sharpness of the specular highlight.		 */
		public function get gloss():Number
		{
			return this._gloss;
		}
		
		public function set gloss(value:Number):void
		{
            this._gloss = value;
		}
		
		/**		 * The overall strength of the specular highlights.		 */
		public function get specular():Number
		{
			return this._specular;
		}
		
		public function set specular(value:Number):void
		{
			if (value == this._specular)
				return;

            this._specular = value;
            this.updateSpecular();
		}
		
		/**		 * The colour of the specular reflection of the surface.		 */
		public function get specularColor():Number
		{
			return this._specularColor;
		}
		
		public function set specularColor(value:Number):void
		{
			if (this._specularColor == value)
				return;
			
			// specular is now either enabled or disabled
			if (this._specularColor == 0 || value == 0)
                this.iInvalidateShaderProgram();

			this._specularColor = value;
			this.updateSpecular();
		}
		
		/**		 * The bitmapData that encodes the specular highlight strength per texel in the red channel, and the sharpness		 * in the green channel. You can use SpecularBitmapTexture if you want to easily set specular and gloss maps		 * from grayscale images, but prepared images are preferred.		 */
		public function get texture():Texture2DBase
		{
			return this._texture;
		}
		
		public function set texture(value:Texture2DBase):void
		{

            var b : Boolean =  ( value != null );

			if ( b != this._useTexture ||
				(value && this._texture && (value.hasMipMaps != this._texture.hasMipMaps || value.format != this._texture.format))) {
				this.iInvalidateShaderProgram();
			}
			this._useTexture = b;//Boolean(value);
			this._texture = value;

		}
		
		/**		 * @inheritDoc		 */
		override public function copyFrom(method:ShadingMethodBase):void
		{

            var m : * = method;
            var bsm : BasicSpecularMethod = (method as BasicSpecularMethod);

			var spec:BasicSpecularMethod = bsm;//BasicSpecularMethod(method);
			this.texture = spec.texture;
            this.specular = spec.specular;
            this.specularColor = spec.specularColor;
            this.gloss = spec.gloss;
		}
		
		/**		 * @inheritDoc		 */
		override public function iCleanCompilationData():void
		{
			super.iCleanCompilationData();
			this._shadowRegister = null;
            this._totalLightColorReg = null;
            this._specularTextureRegister = null;
            this._specularTexData = null;
            this._specularDataRegister = null;
		}
		
		/**		 * @inheritDoc		 */
		override public function iGetFragmentPreLightingCode(vo:MethodVO, regCache:ShaderRegisterCache):String
		{
			var code:String = "";
			
			this._isFirstLight = true;
			
			if (vo.numLights > 0)
            {

				this._specularDataRegister = regCache.getFreeFragmentConstant();
				vo.fragmentConstantsIndex = this._specularDataRegister.index*4;
				
				if (this._useTexture)
                {

					this._specularTexData = regCache.getFreeFragmentVectorTemp();
					regCache.addFragmentTempUsages(this._specularTexData, 1);
					this._specularTextureRegister = regCache.getFreeTextureReg();
					vo.texturesIndex = this._specularTextureRegister.index;
					code = this.pGetTex2DSampleCode( vo, this._specularTexData, this._specularTextureRegister, this._texture );

				}
                else
                {

                    this._specularTextureRegister = null;
                }

				
				this._totalLightColorReg = regCache.getFreeFragmentVectorTemp();
				regCache.addFragmentTempUsages(this._totalLightColorReg, 1);
			}
			
			return code;
		}
		
		/**		 * @inheritDoc		 */
		override public function iGetFragmentCodePerLight(vo:MethodVO, lightDirReg:ShaderRegisterElement, lightColReg:ShaderRegisterElement, regCache:ShaderRegisterCache):String
		{
			var code:String = "";
			var t:ShaderRegisterElement;
			
			if (this._isFirstLight)
            {

                t = this._totalLightColorReg;

            }
			else
            {

				t = regCache.getFreeFragmentVectorTemp();
				regCache.addFragmentTempUsages(t, 1);

			}
			
			var viewDirReg:ShaderRegisterElement = this._sharedRegisters.viewDirFragment;
			var normalReg:ShaderRegisterElement = this._sharedRegisters.normalFragment;
			
			// blinn-phong half vector model

            //TODO: AGAL <> GLSL

			code += "add " + t.toString() + ", " + lightDirReg.toString() + ", " + viewDirReg.toString() + "\n" +
				"nrm " + t.toString() + ".xyz, " + t.toString() + "\n" +
				"dp3 " + t.toString() + ".w, " + normalReg.toString() + ", " + t.toString() + "\n" +
				"sat " + t.toString() + ".w, " + t.toString() + ".w\n";


			if (this._useTexture)
            {

                //TODO: AGAL <> GLSL

				// apply gloss modulation from texture
				code += "mul " + this._specularTexData.toString() + ".w, " + this._specularTexData.toString() + ".y, " + this._specularDataRegister.toString() + ".w\n" +
					"pow " + t + ".w, " + t + ".w, " + this._specularTexData.toString() + ".w\n";


			}
            else
            {

                //TODO: AGAL <> GLSL

                code += "pow " + t.toString() + ".w, " + t.toString() + ".w, " + this._specularDataRegister.toString() + ".w\n";


            }

			
			// attenuate
			if (vo.useLightFallOff)
            {

                //TODO: AGAL <> GLSL
                code += "mul " + t.toString() + ".w, " + t.toString() + ".w, " + lightDirReg.toString() + ".w\n";


            }

			
			if (this._iModulateMethod != null)
            {

                //TODO: AGAL <> GLSL

                if (  this._iModulateMethodScope != null )
                {
                    code += this._iModulateMethod.apply( this._iModulateMethodScope, [vo, t, regCache, this._sharedRegisters] );
                }
                else
                {
                    throw "Modulated methods needs a scope";
                }

                //code += this._iModulateMethod (vo, t, regCache, this._sharedRegisters);

            }


            //TODO: AGAL <> GLSL
			code += "mul " + t.toString() + ".xyz, " + lightColReg.toString() + ", " + t.toString() + ".w\n";
			
			if (! this._isFirstLight)
            {
                //TODO: AGAL <> GLSL
				code += "add " + this._totalLightColorReg.toString() + ".xyz, " + this._totalLightColorReg.toString() + ", " + t.toString() + "\n";

				regCache.removeFragmentTempUsage(t);

			}
			
			this._isFirstLight = false;
			
			return code;
		}
		
		/**		 * @inheritDoc		 */
		override public function iGetFragmentCodePerProbe(vo:MethodVO, cubeMapReg:ShaderRegisterElement, weightRegister:String, regCache:ShaderRegisterCache):String
		{
			var code:String = "";
			var t:ShaderRegisterElement;
			
			// write in temporary if not first light, so we can add to total diffuse colour
			if (this._isFirstLight)
            {

                t = this._totalLightColorReg;

            }
			else
            {

				t = regCache.getFreeFragmentVectorTemp();
				regCache.addFragmentTempUsages(t, 1);

			}
			
			var normalReg:ShaderRegisterElement = this._sharedRegisters.normalFragment;
			var viewDirReg:ShaderRegisterElement = this._sharedRegisters.viewDirFragment;

            //TODO: AGAL <> GLSL

			code += "dp3 " + t.toString() + ".w, " + normalReg.toString() + ", " + viewDirReg.toString() + "\n" +
				"add " + t.toString() + ".w, " + t.toString() + ".w, " + t.toString() + ".w\n" +
				"mul " + t.toString() + ", " + t.toString() + ".w, " + normalReg.toString() + "\n" +
				"sub " + t.toString() + ", " + t.toString() + ", " + viewDirReg.toString() + "\n" +
				"tex " + t.toString() + ", " + t.toString() + ", " + cubeMapReg.toString() + " <cube," + (vo.useSmoothTextures? "linear" : "nearest") + ",miplinear>\n" +
				"mul " + t.toString() + ".xyz, " + t.toString() + ", " + weightRegister.toString() + "\n";


            if (this._iModulateMethod != null)
            {

                //TODO: AGAL <> GLSL

                if (  this._iModulateMethodScope != null )
                {
                    code += this._iModulateMethod.apply( this._iModulateMethodScope, [vo, t, regCache, this._sharedRegisters] );
                }
                else
                {
                    throw "Modulated methods needs a scope";
                }

                //code += this._iModulateMethod (vo, t, regCache, this._sharedRegisters);

            }

            /*			if (this._iModulateMethod!= null)            {                //TODO: AGAL <> GLSL                code += this._iModulateMethod(vo, t, regCache, this._sharedRegisters);            }            */

			if (!this._isFirstLight)
            {

                //TODO: AGAL <> GLSL
				code += "add " + this._totalLightColorReg.toString() + ".xyz, " + this._totalLightColorReg.toString() + ", " + t.toString() + "\n";

				regCache.removeFragmentTempUsage(t);

			}
			
			this._isFirstLight = false;
			
			return code;
		}
		
		/**		 * @inheritDoc		 */
		override public function iGetFragmentPostLightingCode(vo:MethodVO, regCache:ShaderRegisterCache, targetReg:ShaderRegisterElement):String
		{
			var code:String = "";
			
			if (vo.numLights == 0)
				return code;
			
			if (this._shadowRegister)
            {

                //TODO: AGAL <> GLSL
                code += "mul " + this._totalLightColorReg.toString() + ".xyz, " + this._totalLightColorReg.toString() + ", " + this._shadowRegister.toString() + ".w\n";

            }

			
			if (this._useTexture)
            {

				// apply strength modulation from texture

                //TODO: AGAL <> GLSL
				code += "mul " + this._totalLightColorReg.toString() + ".xyz, " + this._totalLightColorReg.toString() + ", " + this._specularTexData.toString() + ".x\n";

				regCache.removeFragmentTempUsage(this._specularTexData);


			}
			
			// apply material's specular reflection

            //TODO: AGAL <> GLSL

			code += "mul " + this._totalLightColorReg.toString() + ".xyz, " + this._totalLightColorReg.toString() + ", " + this._specularDataRegister.toString() + "\n" +
				"add " + targetReg.toString() + ".xyz, " + targetReg.toString() + ", " + this._totalLightColorReg.toString() + "\n";

			regCache.removeFragmentTempUsage( this._totalLightColorReg );
			
			return code;
		}
		
		/**		 * @inheritDoc		 */
		override public function iActivate(vo:MethodVO, stage3DProxy:Stage3DProxy):void
		{
			//var context : Context3D = stage3DProxy._context3D;
			
			if (vo.numLights == 0)
				return;
			
			if (this._useTexture)
            {

               stage3DProxy._iContext3D.setSamplerStateAt( vo.texturesIndex ,
                    vo.repeatTextures ?  Context3DWrapMode.REPEAT :  Context3DWrapMode.CLAMP,
                    vo.useSmoothTextures ? Context3DTextureFilter.LINEAR : Context3DTextureFilter.NEAREST ,
                    vo.useMipmapping ? Context3DMipFilter.MIPLINEAR : Context3DMipFilter.MIPNONE );
               stage3DProxy._iContext3D.setTextureAt(vo.texturesIndex, this._texture.getTextureForStage3D(stage3DProxy));

            }

			var index:Number = vo.fragmentConstantsIndex;
			var data:Vector.<Number> = vo.fragmentData;
			data[index] = this._iSpecularR;
			data[index + 1] = this._iSpecularG;
			data[index + 2] = this._iSpecularB;
			data[index + 3] = this._gloss;
		}
		
		/**		 * Updates the specular color data used by the render state.		 */
		private function updateSpecular():void
		{
			this._iSpecularR = (( this._specularColor >> 16) & 0xff)/0xff*this._specular;
			this._iSpecularG = (( this._specularColor >> 8) & 0xff)/0xff*this._specular;
			this._iSpecularB = ( this._specularColor & 0xff)/0xff*this._specular;
		}

		/**		 * Set internally by the compiler, so the method knows the register containing the shadow calculation.		 */
        public function set iShadowRegister(shadowReg:ShaderRegisterElement):void
        {

            this._shadowRegister = shadowReg;

        }

        public function setIShadowRegister(shadowReg:ShaderRegisterElement):void
        {

            this._shadowRegister = shadowReg;

        }

        
	}
}
