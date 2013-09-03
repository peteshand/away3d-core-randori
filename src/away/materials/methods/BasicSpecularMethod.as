///<reference path="../../_definitions.ts"/>

package away.materials.methods
{
	import away.materials.compilation.ShaderRegisterElement;
	import away.textures.Texture2DBase;
	import away.materials.compilation.ShaderRegisterCache;
	import away.managers.Stage3DProxy;
	//import away3d.*;
	//import away3d.managers.*;
	//import away3d.materials.compilation.*;
	//import away3d.textures.*;
	
	//use namespace arcane;
	
	/**
	public class BasicSpecularMethod extends LightingMethodBase
	{
		private var _useTexture:Boolean;
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
		private var _isFirstLight:Boolean;
		
		/**
		public function BasicSpecularMethod():void
		{
			super();
		}

		/**
		override public function iInitVO(vo:MethodVO):void
		{
			vo.needsUV = _useTexture;
			vo.needsNormals = vo.numLights > 0;
			vo.needsView = vo.numLights > 0;
		}
		
		/**
		public function get gloss():Number
		{
			return _gloss;
		}
		
		public function set gloss(value:Number):void
		{
            this._gloss = value;
		}
		
		/**
		public function get specular():Number
		{
			return _specular;
		}
		
		public function set specular(value:Number):void
		{
			if (value == this._specular)
				return;

            this._specular = value;
            this.updateSpecular();
		}
		
		/**
		public function get specularColor():Number
		{
			return _specularColor;
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
		
		/**
		public function get texture():Texture2DBase
		{
			return _texture;
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
		
		/**
		override public function copyFrom(method:ShadingMethodBase):void
		{

            var m : * = method;
            var bsm : BasicSpecularMethod = BasicSpecularMethod(method);

			var spec:BasicSpecularMethod = bsm;//BasicSpecularMethod(method);
			texture = spec.texture;
            specular = spec.specular;
            specularColor = spec.specularColor;
            gloss = spec.gloss;
		}
		
		/**
		override public function iCleanCompilationData():void
		{
			super.iCleanCompilationData();
			_shadowRegister = null;
            _totalLightColorReg = null;
            _specularTextureRegister = null;
            _specularTexData = null;
            _specularDataRegister = null;
		}
		
		/**
		override public function iGetFragmentPreLightingCode(vo:MethodVO, regCache:ShaderRegisterCache):String
		{
			var code:String = "";
			
			_isFirstLight = true;
			
			if (vo.numLights > 0)
            {

				_specularDataRegister = regCache.getFreeFragmentConstant();
				vo.fragmentConstantsIndex = _specularDataRegister.index*4;
				
				if (_useTexture)
                {

					_specularTexData = regCache.getFreeFragmentVectorTemp();
					regCache.addFragmentTempUsages(_specularTexData, 1);
					_specularTextureRegister = regCache.getFreeTextureReg();
					vo.texturesIndex = _specularTextureRegister.index;
					code = pGetTex2DSampleCode( vo, _specularTexData, _specularTextureRegister, _texture );

				}
                else
                {

                    _specularTextureRegister = null;
                }

				
				_totalLightColorReg = regCache.getFreeFragmentVectorTemp();
				regCache.addFragmentTempUsages(_totalLightColorReg, 1);
			}
			
			return code;
		}
		
		/**
		override public function iGetFragmentCodePerLight(vo:MethodVO, lightDirReg:ShaderRegisterElement, lightColReg:ShaderRegisterElement, regCache:ShaderRegisterCache):String
		{
			var code:String = "";
			var t:ShaderRegisterElement;
			
			if (_isFirstLight)
            {

                t = _totalLightColorReg;

            }
			else
            {

				t = regCache.getFreeFragmentVectorTemp();
				regCache.addFragmentTempUsages(t, 1);

			}
			
			var viewDirReg:ShaderRegisterElement = _sharedRegisters.viewDirFragment;
			var normalReg:ShaderRegisterElement = _sharedRegisters.normalFragment;
			
			// blinn-phong half vector model

            //TODO: AGAL <> GLSL

			code += "add " + t.toString() + ", " + lightDirReg.toString() + ", " + viewDirReg.toString() + "\n" +
				"nrm " + t.toString() + ".xyz, " + t.toString() + "\n" +
				"dp3 " + t.toString() + ".w, " + normalReg.toString() + ", " + t.toString() + "\n" +
				"sat " + t.toString() + ".w, " + t.toString() + ".w\n";


			if (_useTexture)
            {

                //TODO: AGAL <> GLSL

				// apply gloss modulation from texture
				code += "mul " + _specularTexData.toString() + ".w, " + _specularTexData.toString() + ".y, " + _specularDataRegister.toString() + ".w\n" +
					"pow " + t + ".w, " + t + ".w, " + _specularTexData.toString() + ".w\n";


			}
            else
            {

                //TODO: AGAL <> GLSL

                code += "pow " + t.toString() + ".w, " + t.toString() + ".w, " + _specularDataRegister.toString() + ".w\n";


            }

			
			// attenuate
			if (vo.useLightFallOff)
            {

                //TODO: AGAL <> GLSL
                code += "mul " + t.toString() + ".w, " + t.toString() + ".w, " + lightDirReg.toString() + ".w\n";


            }

			
			if (_iModulateMethod != null)
            {

                //TODO: AGAL <> GLSL
                code += _iModulateMethod (vo, t, regCache, _sharedRegisters);

            }


            //TODO: AGAL <> GLSL
			code += "mul " + t.toString() + ".xyz, " + lightColReg.toString() + ", " + t.toString() + ".w\n";
			
			if (! _isFirstLight)
            {
                //TODO: AGAL <> GLSL
				code += "add " + _totalLightColorReg.toString() + ".xyz, " + _totalLightColorReg.toString() + ", " + t.toString() + "\n";

				regCache.removeFragmentTempUsage(t);

			}
			
			_isFirstLight = false;
			
			return code;
		}
		
		/**
		override public function iGetFragmentCodePerProbe(vo:MethodVO, cubeMapReg:ShaderRegisterElement, weightRegister:String, regCache:ShaderRegisterCache):String
		{
			var code:String = "";
			var t:ShaderRegisterElement;
			
			// write in temporary if not first light, so we can add to total diffuse colour
			if (_isFirstLight)
            {

                t = _totalLightColorReg;

            }
			else
            {

				t = regCache.getFreeFragmentVectorTemp();
				regCache.addFragmentTempUsages(t, 1);

			}
			
			var normalReg:ShaderRegisterElement = _sharedRegisters.normalFragment;
			var viewDirReg:ShaderRegisterElement = _sharedRegisters.viewDirFragment;

            //TODO: AGAL <> GLSL

			code += "dp3 " + t.toString() + ".w, " + normalReg.toString() + ", " + viewDirReg.toString() + "\n" +
				"add " + t.toString() + ".w, " + t.toString() + ".w, " + t.toString() + ".w\n" +
				"mul " + t.toString() + ", " + t.toString() + ".w, " + normalReg.toString() + "\n" +
				"sub " + t.toString() + ", " + t.toString() + ", " + viewDirReg.toString() + "\n" +
				"tex " + t.toString() + ", " + t.toString() + ", " + cubeMapReg.toString() + " <cube," + (vo.useSmoothTextures? "linear" : "nearest") + ",miplinear>\n" +
				"mul " + t.toString() + ".xyz, " + t.toString() + ", " + weightRegister.toString() + "\n";


			if (_iModulateMethod!= null)
            {

                //TODO: AGAL <> GLSL
                code += _iModulateMethod(vo, t, regCache, _sharedRegisters);

            }

			
			if (!_isFirstLight)
            {

                //TODO: AGAL <> GLSL
				code += "add " + _totalLightColorReg.toString() + ".xyz, " + _totalLightColorReg.toString() + ", " + t.toString() + "\n";

				regCache.removeFragmentTempUsage(t);

			}
			
			_isFirstLight = false;
			
			return code;
		}
		
		/**
		override public function iGetFragmentPostLightingCode(vo:MethodVO, regCache:ShaderRegisterCache, targetReg:ShaderRegisterElement):String
		{
			var code:String = "";
			
			if (vo.numLights == 0)
				return code;
			
			if (_shadowRegister)
            {

                //TODO: AGAL <> GLSL
                code += "mul " + _totalLightColorReg.toString() + ".xyz, " + _totalLightColorReg.toString() + ", " + _shadowRegister.toString() + ".w\n";

            }

			
			if (_useTexture)
            {

				// apply strength modulation from texture

                //TODO: AGAL <> GLSL
				code += "mul " + _totalLightColorReg.toString() + ".xyz, " + _totalLightColorReg.toString() + ", " + _specularTexData.toString() + ".x\n";

				regCache.removeFragmentTempUsage(_specularTexData);


			}
			
			// apply material's specular reflection

            //TODO: AGAL <> GLSL

			code += "mul " + _totalLightColorReg.toString() + ".xyz, " + _totalLightColorReg.toString() + ", " + _specularDataRegister.toString() + "\n" +
				"add " + targetReg.toString() + ".xyz, " + targetReg.toString() + ", " + _totalLightColorReg.toString() + "\n";

			regCache.removeFragmentTempUsage( _totalLightColorReg );
			
			return code;
		}
		
		/**
		override public function iActivate(vo:MethodVO, stage3DProxy:Stage3DProxy):void
		{
			//var context : Context3D = stage3DProxy._context3D;
			
			if (vo.numLights == 0)
				return;
			
			if (_useTexture)
            {

               stage3DProxy._iContext3D.setTextureAt(vo.texturesIndex, _texture.getTextureForStage3D(stage3DProxy));

            }

			var index:Number = vo.fragmentConstantsIndex;
			var data:Vector.<Number> = vo.fragmentData;
			data[index] = _iSpecularR;
			data[index + 1] = _iSpecularG;
			data[index + 2] = _iSpecularB;
			data[index + 3] = _gloss;
		}
		
		/**
		private function updateSpecular():void
		{
			_iSpecularR = (( _specularColor >> 16) & 0xff)/0xff*_specular;
			_iSpecularG = (( _specularColor >> 8) & 0xff)/0xff*_specular;
			_iSpecularB = ( _specularColor & 0xff)/0xff*_specular;
		}

		/**
		public function set iShadowRegister(shadowReg:ShaderRegisterElement):void
		{

			this._shadowRegister = shadowReg;

		}
        
	}
}