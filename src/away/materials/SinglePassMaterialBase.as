///<reference path="../_definitions.ts"/>

package away.materials
{
	import away.materials.passes.SuperShaderPass;
	import away.display.BlendMode;
	import away.managers.Stage3DProxy;
	import away.cameras.Camera3D;
	import away.geom.ColorTransform;
	import away.materials.methods.BasicAmbientMethod;
	import away.materials.methods.ShadowMapMethodBase;
	import away.materials.methods.BasicDiffuseMethod;
	import away.materials.methods.BasicNormalMethod;
	import away.materials.methods.BasicSpecularMethod;
	import away.materials.methods.EffectMethodBase;
	import away.textures.Texture2DBase;
	import away.errors.Error;
	import away.display3D.Context3D;
	import away.materials.lightpickers.LightPickerBase;

	/**
	public class SinglePassMaterialBase extends MaterialBase
	{
		public var _pScreenPass:SuperShaderPass;
		private var _alphaBlending:Boolean = false;
		
		/**
		public function SinglePassMaterialBase():void
		{
			super();

            this.pAddPass( this._pScreenPass = new SuperShaderPass(this) );
		}
		
		/**
		public function get enableLightFallOff():Boolean
		{
			return _pScreenPass.enableLightFallOff;
		}
		
		public function set enableLightFallOff(value:Boolean):void
		{
            this._pScreenPass.enableLightFallOff = value;
		}
		
		/**
		public function get alphaThreshold():Number
		{

			return _pScreenPass.diffuseMethod.alphaThreshold;

		}
		
		public function set alphaThreshold(value:Number):void
		{



            this._pScreenPass.diffuseMethod.alphaThreshold = value;

            this._pDepthPass.alphaThreshold = value;
            this._pDistancePass.alphaThreshold = value;


		}

		/**
		override public function set blendMode(value:String):void
		{

            super.setBlendMode( value );
			this._pScreenPass.setBlendMode( ( this._pBlendMode == BlendMode.NORMAL ) && this.requiresBlending?  BlendMode.LAYER : this._pBlendMode);

		}

		/**
		override public function set depthCompareMode(value:String):void
		{

			this._pDepthCompareMode = value;
			this._pScreenPass.depthCompareMode = value;
		}

		/**
		override public function iActivateForDepth(stage3DProxy:Stage3DProxy, camera:Camera3D, distanceBased:Boolean = false):void
		{

			if (distanceBased){

                _pDistancePass.alphaMask = _pScreenPass.diffuseMethod.texture;

            }
			else
            {

                _pDepthPass.alphaMask = _pScreenPass.diffuseMethod.texture;

            }

			super.iActivateForDepth(stage3DProxy, camera, distanceBased);

		}

		/**
		public function get specularLightSources():Number
		{
			return _pScreenPass.specularLightSources;
		}
		
		public function set specularLightSources(value:Number):void
		{
			this._pScreenPass.specularLightSources = value;
		}

		/**
		public function get diffuseLightSources():Number
		{
			return _pScreenPass.diffuseLightSources;
		}
		
		public function set diffuseLightSources(value:Number):void
		{
            this._pScreenPass.diffuseLightSources = value;
		}

		/**
		override public function get requiresBlending():Boolean
		{
			return getRequiresBlending();
		}

        override public function getRequiresBlending():Boolean
        {

            var ct : ColorTransform = _pScreenPass.colorTransform;

            if ( ct )
            {
                return ( _pBlendMode != BlendMode.NORMAL ) || _alphaBlending || ( ct.alphaMultiplier < 1);
            }
            return ( _pBlendMode != BlendMode.NORMAL ) || _alphaBlending ;

            //return super.getRequiresBlending() || this._alphaBlending || ( this._pScreenPass.colorTransform && this._pScreenPass.colorTransform.alphaMultiplier < 1);

        }

		/**
		public function get colorTransform():ColorTransform
		{
			return _pScreenPass.colorTransform;
		}

        public function set colorTransform(value:ColorTransform):void
        {
            this.setColorTransform( value )
        }

        public function setColorTransform(value:ColorTransform):void
        {
            _pScreenPass.colorTransform = value;
        }

		/**

		public function get ambientMethod():BasicAmbientMethod
		{
			return _pScreenPass.ambientMethod;
		}
		
		public function set ambientMethod(value:BasicAmbientMethod):void
		{
			this._pScreenPass.ambientMethod = value;
		}

		/**
		public function get shadowMethod():ShadowMapMethodBase
		{
			return _pScreenPass.shadowMethod;
		}
		
		public function set shadowMethod(value:ShadowMapMethodBase):void
		{
			this._pScreenPass.shadowMethod = value;
		}

		/**

		public function get diffuseMethod():BasicDiffuseMethod
		{
			return _pScreenPass.diffuseMethod;
		}
		
		public function set diffuseMethod(value:BasicDiffuseMethod):void
		{
			this._pScreenPass.diffuseMethod = value;
		}

		/**

		public function get normalMethod():BasicNormalMethod
		{
			return _pScreenPass.normalMethod;
		}
		
		public function set normalMethod(value:BasicNormalMethod):void
		{
			this._pScreenPass.normalMethod = value;
		}

		/**

		public function get specularMethod():BasicSpecularMethod
		{
			return _pScreenPass.specularMethod;
		}
		
		public function set specularMethod(value:BasicSpecularMethod):void
		{
			this._pScreenPass.specularMethod = value;
		}

		/**
		public function addMethod(method:EffectMethodBase):void
		{
			_pScreenPass.addMethod(method);
		}

		/**

		public function get numMethods():Number
		{
			return _pScreenPass.numMethods;
		}

		/**
		public function hasMethod(method:EffectMethodBase):Boolean
		{
			return _pScreenPass.hasMethod(method);
		}

		/**
		public function getMethodAt(index:Number):EffectMethodBase
		{
			return _pScreenPass.getMethodAt(index);
		}

		/**
		public function addMethodAt(method:EffectMethodBase, index:Number):void
		{
			_pScreenPass.addMethodAt(method, index);
		}

		/**
		public function removeMethod(method:EffectMethodBase):void
		{
			_pScreenPass.removeMethod(method);
		}
		
		/**
		override public function set mipmap(value:Boolean):void
		{
			if (this._pMipmap == value)
				return;

			this.setMipMap( value );
		}

		/**
		public function get normalMap():Texture2DBase
		{
			return _pScreenPass.normalMap;
		}
		
		public function set normalMap(value:Texture2DBase):void
		{
			this._pScreenPass.normalMap = value;
		}
		
		/**

		public function get specularMap():Texture2DBase
		{
			return _pScreenPass.specularMethod.texture;
		}
		
		public function set specularMap(value:Texture2DBase):void
		{
			if (this._pScreenPass.specularMethod)
            {

                this._pScreenPass.specularMethod.texture = value;
            }
			else
            {

                throw new away.errors.Error("No specular method was set to assign the specularGlossMap to");

            }

		}

		/**

		public function get gloss():Number
		{
			return _pScreenPass.specularMethod? _pScreenPass.specularMethod.gloss : 0;
		}
		
		public function set gloss(value:Number):void
		{
			if (this._pScreenPass.specularMethod)
                this._pScreenPass.specularMethod.gloss = value;
		}

		/**

		public function get ambient():Number
		{
			return _pScreenPass.ambientMethod.ambient;
		}
		
		public function set ambient(value:Number):void
		{
            this._pScreenPass.ambientMethod.ambient = value;
		}

		/**

		public function get specular():Number
		{
			return _pScreenPass.specularMethod? _pScreenPass.specularMethod.specular : 0;
		}
		
		public function set specular(value:Number):void
		{
			if (this._pScreenPass.specularMethod)
                this._pScreenPass.specularMethod.specular = value;
		}

		/**

		public function get ambientColor():Number
		{
			return _pScreenPass.ambientMethod.ambientColor;
		}
		
		public function set ambientColor(value:Number):void
		{
            this._pScreenPass.ambientMethod.ambientColor = value;
		}

		/**

		public function get specularColor():Number
		{
			return _pScreenPass.specularMethod.specularColor;
		}
		
		public function set specularColor(value:Number):void
		{
			this._pScreenPass.specularMethod.specularColor = value;
		}

		/**

        public function get alphaBlending():Boolean
		{

			return _alphaBlending;

		}
		
		public function set alphaBlending(value:Boolean):void
		{

			this._alphaBlending = value;
			this._pScreenPass.setBlendMode(this.getBlendMode() == BlendMode.NORMAL && this.requiresBlending? BlendMode.LAYER : this.getBlendMode() );
			this._pScreenPass.preserveAlpha = this.requiresBlending;

		}
		
		/**
		override public function iUpdateMaterial(context:Context3D):void
		{
			if (_pScreenPass._iPassesDirty)
            {

                pClearPasses();

				if (_pScreenPass._iPasses)
                {

					var len:Number = _pScreenPass._iPasses.length;

					for (var i:Number = 0; i < len; ++i)
                    {

                        pAddPass(_pScreenPass._iPasses[i]);

                    }

				}
				
				pAddPass(_pScreenPass);
				_pScreenPass._iPassesDirty = false;
			}
		}

		/**
		override public function set lightPicker(value:LightPickerBase):void
		{

			super.setLightPicker( value );
			this._pScreenPass.lightPicker = value;
		}
	}
}