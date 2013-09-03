///<reference path="../../_definitions.ts"/>

package away.materials.methods
{
	import away.materials.compilation.ShaderRegisterElement;
	import away.textures.Texture2DBase;
	import away.managers.Stage3DProxy;
	import away.utils.Debug;
	import away.materials.compilation.ShaderRegisterCache;
	//import away3d.arcane;
	//import away3d.managers.Stage3DProxy;
	//import away3d.materials.compilation.ShaderRegisterCache;
	//import away3d.materials.compilation.ShaderRegisterElement;
	//import away3d.textures.Texture2DBase;
	
	//use namespace arcane;
	
	/**
	public class BasicDiffuseMethod extends LightingMethodBase
	{
		private var _useAmbientTexture:Boolean;
		
		private var _useTexture:Boolean;
		private var _totalLightColorReg:ShaderRegisterElement;
		
		// TODO: are these registers at all necessary to be members?
		private var _diffuseInputRegister:ShaderRegisterElement;
		
		private var _texture:Texture2DBase;
		private var _diffuseColor:Number = 0xffffff;
		private var _diffuseR:Number = 1;
        private var _diffuseG:Number = 1;
        private var _diffuseB:Number = 1;
        private var _diffuseA:Number = 1;

		private var _shadowRegister:ShaderRegisterElement;
		
		private var _alphaThreshold:Number = 0;
		private var _isFirstLight:Boolean;
		
		/**
		public function BasicDiffuseMethod():void
		{
			super();
		}

		/**
		public function get iUseAmbientTexture():Boolean
		{
			return _useAmbientTexture;
		}

		public function set iUseAmbientTexture(value:Boolean):void
		{
			if (this._useAmbientTexture == value)
				return;

			this._useAmbientTexture = value;

			this.iInvalidateShaderProgram();

		}
		
		override public function iInitVO(vo:MethodVO):void
		{

			vo.needsUV = _useTexture;
			vo.needsNormals = vo.numLights > 0;

		}

		/**
		public function generateMip(stage3DProxy:Stage3DProxy):void
		{
			if (_useTexture)
				_texture.getTextureForStage3D(stage3DProxy);
		}

		/**
		public function get diffuseAlpha():Number
		{
			return _diffuseA;
		}
		
		public function set diffuseAlpha(value:Number):void
		{
			this._diffuseA = value;
		}
		
		/**
		public function get diffuseColor():Number
		{
			return _diffuseColor;
		}
		
		public function set diffuseColor(diffuseColor:Number):void
		{
			this._diffuseColor = diffuseColor;
			this.updateDiffuse();

		}
		
		/**
		public function get texture():Texture2DBase
		{
			return _texture;
		}
		
		public function set texture(value:Texture2DBase):void
		{

            // TODO: Check - TRICKY
            Debug.throwPIR( 'BasicDiffuseMethod' , 'set texture' , 'TRICKY - Odd boolean assignment - needs testing' );

            //var v : any = value;
            var b : Boolean =  ( value != null );
            //var b : boolean = <boolean> value;

			if ( b != this._useTexture ||
				(value && this._texture && (value.hasMipMaps != this._texture.hasMipMaps || value.format != this._texture.format))) {

				this.iInvalidateShaderProgram();

			}
			
			this._useTexture = b;
            this._texture = value;

		}
		
		/**
		public function get alphaThreshold():Number
		{
			return _alphaThreshold;
		}
		
		public function set alphaThreshold(value:Number):void
		{
			if (value < 0)
				value = 0;
			else if (value > 1)
				value = 1;
			if (value == this._alphaThreshold)
				return;
			
			if (value == 0 || this._alphaThreshold == 0)
				this.iInvalidateShaderProgram();//invalidateShaderProgram();
			
			this._alphaThreshold = value;
		}
		
		/**
		override public function dispose():void
		{
			_texture = null;
		}
		
		/**
		override public function copyFrom(method:ShadingMethodBase):void
		{

            var m : * = method;

			var diff:BasicDiffuseMethod = BasicDiffuseMethod(m);

			alphaThreshold = diff.alphaThreshold;
            texture = diff.texture;
            iUseAmbientTexture = diff.iUseAmbientTexture;
            diffuseAlpha = diff.diffuseAlpha;
            diffuseColor = diff.diffuseColor;
		}

		/**
		override public function iCleanCompilationData():void
		{
			super.iCleanCompilationData();

			_shadowRegister = null;
            _totalLightColorReg = null;
            _diffuseInputRegister = null;
		}
		
		/**
		override public function iGetFragmentPreLightingCode(vo:MethodVO, regCache:ShaderRegisterCache):String
		{
			var code:String = "";
			
			_isFirstLight = true;
			
			if (vo.numLights > 0)
            {
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

            //TODO: AGAL <> GLSL

            //*
			code += "dp3 " + t + ".x, " + lightDirReg.toString() + ", " + _sharedRegisters.normalFragment.toString() + "\n" +
				"max " + t.toString() + ".w, " + t.toString() + ".x, " + _sharedRegisters.commons.toString() + ".y\n";
			
			if (vo.useLightFallOff)
            {

                code += "mul " + t.toString() + ".w, " + t.toString() + ".w, " + lightDirReg.toString() + ".w\n";

            }

			
			if (_iModulateMethod != null)
            {

                code += _iModulateMethod(vo, t, regCache, _sharedRegisters);

            }

			
			code += "mul " + t.toString() + ", " + t.toString() + ".w, " + lightColReg.toString() + "\n";
			
			if (!_isFirstLight) {
				code += "add " + _totalLightColorReg.toString() + ".xyz, " + _totalLightColorReg.toString() + ", " + t.toString() + "\n";
				regCache.removeFragmentTempUsage(t);
			}
			//*/
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

            // TODO: AGAL <> GLSL


			code += "tex " + t.toString() + ", " + _sharedRegisters.normalFragment.toString() + ", " + cubeMapReg.toString() + " <cube,linear,miplinear>\n" +
				"mul " + t.toString() + ".xyz, " + t.toString() + ".xyz, " + weightRegister + "\n";
			
			if (_iModulateMethod!= null)
            {

                code += _iModulateMethod(vo, t, regCache, _sharedRegisters);

            }

			
			if (!_isFirstLight)
            {

				code += "add " + _totalLightColorReg + ".xyz, " + _totalLightColorReg + ", " + t.toString() + "\n";
				regCache.removeFragmentTempUsage(t);

			}

			_isFirstLight = false;
			
			return code;
		}
		
		/**
		override public function iGetFragmentPostLightingCode(vo:MethodVO, regCache:ShaderRegisterCache, targetReg:ShaderRegisterElement):String
		{
			var code:String = "";
			var albedo:ShaderRegisterElement;
			var cutOffReg:ShaderRegisterElement;
			
			// incorporate input from ambient
			if (vo.numLights > 0)
            {

				if (_shadowRegister)
					code += pApplyShadow(vo, regCache);

				albedo = regCache.getFreeFragmentVectorTemp();
				regCache.addFragmentTempUsages(albedo, 1);

			}
            else
            {

                albedo = targetReg;

            }

			
			if (_useTexture)
            {

				_diffuseInputRegister = regCache.getFreeTextureReg();

				vo.texturesIndex = _diffuseInputRegister.index;


				code += pGetTex2DSampleCode(vo, albedo, _diffuseInputRegister, _texture);

				if (_alphaThreshold > 0)
                {

                    //TODO: AGAL <> GLSL

					cutOffReg = regCache.getFreeFragmentConstant();
					vo.fragmentConstantsIndex = cutOffReg.index*4;

					code += "sub " + albedo.toString() + ".w, " + albedo.toString() + ".w, " + cutOffReg.toString() + ".x\n" +
						"kil " + albedo.toString() + ".w\n" +
						"add " + albedo.toString() + ".w, " + albedo.toString() + ".w, " + cutOffReg.toString() + ".x\n";

				}

			}
            else
            {

                //TODO: AGAL <> GLSL

				_diffuseInputRegister = regCache.getFreeFragmentConstant();

				vo.fragmentConstantsIndex = _diffuseInputRegister.index*4;

				code += "mov " + albedo.toString() + ", " + _diffuseInputRegister.toString() + "\n";


			}
			
			if (vo.numLights == 0)
				return code;

            //TODO: AGAL <> GLSL
			code += "sat " + _totalLightColorReg.toString() + ", " + _totalLightColorReg.toString() + "\n";
			
			if (_useAmbientTexture)
            {

                //TODO: AGAL <> GLSL

				code += "mul " + albedo.toString() + ".xyz, " + albedo.toString() + ", " + _totalLightColorReg.toString() + "\n" +
					"mul " + _totalLightColorReg.toString() + ".xyz, " + targetReg.toString() + ", " + _totalLightColorReg.toString() + "\n" +
					"sub " + targetReg.toString() + ".xyz, " + targetReg.toString() + ", " + _totalLightColorReg.toString() + "\n" +
					"add " + targetReg.toString() + ".xyz, " + albedo.toString() + ", " + targetReg.toString() + "\n";


			}
            else
            {

                //TODO: AGAL <> GLSL

				code += "add " + targetReg.toString() + ".xyz, " + _totalLightColorReg.toString() + ", " + targetReg.toString() + "\n";

				if (_useTexture)
                {

					code += "mul " + targetReg.toString() + ".xyz, " + albedo.toString() + ", " + targetReg.toString() + "\n" +
						"mov " + targetReg + ".w, " + albedo + ".w\n";

				}
                else
                {

					code += "mul " + targetReg.toString() + ".xyz, " + _diffuseInputRegister.toString() + ", " + targetReg.toString() + "\n" +
						"mov " + targetReg.toString() + ".w, " + _diffuseInputRegister.toString() + ".w\n";

				}

			}
			
			regCache.removeFragmentTempUsage(_totalLightColorReg);
			regCache.removeFragmentTempUsage(albedo);
			
			return code;
		}

		/**
		public function pApplyShadow(vo:MethodVO, regCache:ShaderRegisterCache):String
		{

            //TODO: AGAL <> GLSL
			return "mul " + _totalLightColorReg.toString() + ".xyz, " + _totalLightColorReg.toString() + ", " + _shadowRegister.toString() + ".w\n";

		}
		
		/**
		override public function iActivate(vo:MethodVO, stage3DProxy:Stage3DProxy):void
		{
			if (_useTexture)
            {

                //away.Debug.throwPIR( 'BasicDiffuseMethod' , 'iActivate' , 'Context3D.setGLSLTextureAt - params not matching');
				stage3DProxy._iContext3D.setTextureAt(vo.texturesIndex, _texture.getTextureForStage3D(stage3DProxy));

				if (_alphaThreshold > 0)
					vo.fragmentData[vo.fragmentConstantsIndex] = _alphaThreshold;


			}
            else
            {

				var index:Number = vo.fragmentConstantsIndex;
				var data:Vector.<Number> = vo.fragmentData;
				data[index] = _diffuseR;
				data[index + 1] = _diffuseG;
				data[index + 2] = _diffuseB;
				data[index + 3] = _diffuseA;

			}
		}
		
		/**
		private function updateDiffuse():void
		{
			_diffuseR = ((_diffuseColor >> 16) & 0xff)/0xff;
            _diffuseG = ((_diffuseColor >> 8) & 0xff)/0xff;
            _diffuseB = (_diffuseColor & 0xff)/0xff;
		}

		/**
		public function set iShadowRegister(value:ShaderRegisterElement):void
		{
			this._shadowRegister = value;
		}
	}
}