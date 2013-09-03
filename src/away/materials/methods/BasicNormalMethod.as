///<reference path="../../_definitions.ts"/>

package away.materials.methods
{
	import away.textures.Texture2DBase;
	import away.materials.compilation.ShaderRegisterElement;
	import away.managers.Stage3DProxy;
	import away.materials.compilation.ShaderRegisterCache;

	/**
	public class BasicNormalMethod extends ShadingMethodBase
	{
		private var _texture:Texture2DBase;
		private var _useTexture:Boolean;
		private var _normalTextureRegister:ShaderRegisterElement;

		/**
		public function BasicNormalMethod():void
		{
			super();
		}

		/**
		override public function iInitVO(vo:MethodVO):void
		{
            if ( _texture )
            {

                vo.needsUV = true;

            }
            else
            {

                vo.needsUV = false;

            }

			//vo.needsUV = Boolean(_texture);
		}

		/**
		public function get iTangentSpace():Boolean
		{
			return true;
		}
		
		/**
		public function get iHasOutput():Boolean
		{
			return _useTexture;
		}

		/**
		override public function copyFrom(method:ShadingMethodBase):void
		{

            var s : * = method;
            var bnm : BasicNormalMethod = BasicNormalMethod(method);

            normalMap = bnm.normalMap;

		}

		/**
		public function get normalMap():Texture2DBase
		{
			return _texture;
		}
		
		public function set normalMap(value:Texture2DBase):void
		{

            var b : Boolean =  ( value != null );

			if ( b != this._useTexture ||
				(value && this._texture && (value.hasMipMaps != this._texture.hasMipMaps || value.format != this._texture.format))) {
				this.iInvalidateShaderProgram();//invalidateShaderProgram();
			}
			this._useTexture = Boolean(value);
            this._texture = value;

		}

		/**
		override public function iCleanCompilationData():void
		{
			super.iCleanCompilationData();
			_normalTextureRegister = null;
		}

		/**
		override public function dispose():void
		{
			if (_texture)
            {

                _texture = null;

            }

		}


		/**
		override public function iActivate(vo:MethodVO, stage3DProxy:Stage3DProxy):void
		{
			if (vo.texturesIndex >= 0)
            {

                //away.Debug.throwPIR( 'BasicNormalMethod' , 'iActivate' , 'Context3D.setGLSLTextureAt - params not matching');
                stage3DProxy._iContext3D.setTextureAt( vo.texturesIndex, _texture.getTextureForStage3D(stage3DProxy));

            }


		}

		/**
		public function iGetFragmentCode(vo:MethodVO, regCache:ShaderRegisterCache, targetReg:ShaderRegisterElement):String
		{
			_normalTextureRegister = regCache.getFreeTextureReg();

			vo.texturesIndex = _normalTextureRegister.index;

            // TODO: AGAL <> GLSL

			return pGetTex2DSampleCode(vo, targetReg, _normalTextureRegister, _texture) +
				"sub " + targetReg.toString() + ".xyz, " + targetReg.toString() + ".xyz, " + _sharedRegisters.commons.toString() + ".xxx	\n" +
				"nrm " + targetReg.toString() + ".xyz, " + targetReg.toString() + ".xyz							\n";

		}
	}
}