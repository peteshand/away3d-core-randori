///<reference path="../_definitions.ts"/>

package away.materials
{
	import away.materials.passes.ShadowCasterPass;
	import away.materials.passes.LightingPass;
	import away.materials.passes.SuperShaderPass;
	import away.materials.methods.BasicAmbientMethod;
	import away.materials.methods.ShadowMapMethodBase;
	import away.materials.methods.BasicDiffuseMethod;
	import away.materials.methods.BasicNormalMethod;
	import away.materials.methods.BasicSpecularMethod;
	import away.managers.Stage3DProxy;
	import away.cameras.Camera3D;
	import away.materials.lightpickers.LightPickerBase;
	import away.events.Event;
	import away.materials.methods.EffectMethodBase;
	import away.textures.Texture2DBase;
	import away.display3D.Context3D;
	import away.materials.passes.CompiledPass;
	import away.display3D.Context3DBlendFactor;
	import away.display.BlendMode;
	import away.display3D.Context3DCompareMode;
	import away.materials.lightpickers.StaticLightPicker;

	/**
	public class MultiPassMaterialBase extends MaterialBase
	{
		private var _casterLightPass:ShadowCasterPass;
		private var _nonCasterLightPasses:Vector.<LightingPass>;
		public var _pEffectsPass:SuperShaderPass;
		
		private var _alphaThreshold:Number = 0;
		private var _specularLightSources:Number = 0x01;
		private var _diffuseLightSources:Number = 0x03;
		
		private var _ambientMethod:BasicAmbientMethod = new BasicAmbientMethod();
		private var _shadowMethod:ShadowMapMethodBase;
		private var _diffuseMethod:BasicDiffuseMethod = new BasicDiffuseMethod();
		private var _normalMethod:BasicNormalMethod = new BasicNormalMethod();
		private var _specularMethod:BasicSpecularMethod = new BasicSpecularMethod();
		
		private var _screenPassesInvalid:Boolean = true;
		private var _enableLightFallOff:Boolean = true;
		
		/**
		public function MultiPassMaterialBase():void
		{
			super();
		}
		
		/**
		public function get enableLightFallOff():Boolean
		{
			return _enableLightFallOff;
		}
		
		public function set enableLightFallOff(value:Boolean):void
		{

			if (this._enableLightFallOff != value)
				this.pInvalidateScreenPasses();
            this._enableLightFallOff = value;

		}
		
		/**
		public function get alphaThreshold():Number
		{
			return _alphaThreshold;
		}
		
		public function set alphaThreshold(value:Number):void
		{
            this._alphaThreshold = value;
            this._diffuseMethod.alphaThreshold = value;
            this._pDepthPass.alphaThreshold = value;
            this._pDistancePass.alphaThreshold = value;
		}

		/**
		override public function set depthCompareMode(value:String):void
		{
			super.setDepthCompareMode( value );
			this.pInvalidateScreenPasses();
		}

		/**
		override public function set blendMode(value:String):void
		{
			super.setBlendMode( value );
			this.pInvalidateScreenPasses();
		}

		/**
		override public function iActivateForDepth(stage3DProxy:Stage3DProxy, camera:Camera3D, distanceBased:Boolean = false):void
		{
			if (distanceBased)
            {
				_pDistancePass.alphaMask = _diffuseMethod.texture;

            }
			else
            {
				_pDepthPass.alphaMask = _diffuseMethod.texture;
            }

			super.iActivateForDepth(stage3DProxy, camera, distanceBased);
		}

		/**
		public function get specularLightSources():Number
		{
			return _specularLightSources;
		}
		
		public function set specularLightSources(value:Number):void
		{
            this._specularLightSources = value;
		}

		/**
		public function get diffuseLightSources():Number
		{
			return _diffuseLightSources;
		}
		
		public function set diffuseLightSources(value:Number):void
		{
            this._diffuseLightSources = value;
		}

		/**
		override public function set lightPicker(value:LightPickerBase):void
		{
			if (this._pLightPicker)
				this._pLightPicker.removeEventListener(Event.CHANGE, this.onLightsChange , this );

            super.setLightPicker( value );

			if (this._pLightPicker)
				this._pLightPicker.addEventListener(Event.CHANGE, this.onLightsChange , this );
			this.pInvalidateScreenPasses();
		}
		
		/**
		override public function get requiresBlending():Boolean
		{
			return false;
		}
		
		/**
		public function get ambientMethod():BasicAmbientMethod
		{
			return _ambientMethod;
		}
		
		public function set ambientMethod(value:BasicAmbientMethod):void
		{
			value.copyFrom(this._ambientMethod);
			this._ambientMethod = value;
			this.pInvalidateScreenPasses();
		}
		
		/**
		public function get shadowMethod():ShadowMapMethodBase
		{
			return _shadowMethod;
		}
		
		public function set shadowMethod(value:ShadowMapMethodBase):void
		{
			if (value && this._shadowMethod)
				value.copyFrom(this._shadowMethod);
            this._shadowMethod = value;
            this.pInvalidateScreenPasses();
		}
		
		/**
		public function get diffuseMethod():BasicDiffuseMethod
		{
			return _diffuseMethod;
		}
		
		public function set diffuseMethod(value:BasicDiffuseMethod):void
		{
			value.copyFrom(this._diffuseMethod);
            this._diffuseMethod = value;
			this.pInvalidateScreenPasses();
		}

		/**
		public function get specularMethod():BasicSpecularMethod
		{
			return _specularMethod;
		}

		public function set specularMethod(value:BasicSpecularMethod):void
		{
			if (value && this._specularMethod)
				value.copyFrom(this._specularMethod);
			this._specularMethod = value;
			this.pInvalidateScreenPasses();
		}
		
		/**
		public function get normalMethod():BasicNormalMethod
		{
			return _normalMethod;
		}
		
		public function set normalMethod(value:BasicNormalMethod):void
		{
			value.copyFrom(this._normalMethod);
			this._normalMethod = value;
			this.pInvalidateScreenPasses();
		}
		
		/**
		public function addMethod(method:EffectMethodBase):void
		{

            if ( _pEffectsPass == null )
            {
                _pEffectsPass = new SuperShaderPass( this );

            }

			_pEffectsPass.addMethod(method);
			pInvalidateScreenPasses();
		}

		/**
		public function get numMethods():Number
		{
			return _pEffectsPass? _pEffectsPass.numMethods : 0;
		}

		/**
		public function hasMethod(method:EffectMethodBase):Boolean
		{
			return _pEffectsPass? _pEffectsPass.hasMethod(method) : false;
		}

		/**
		public function getMethodAt(index:Number):EffectMethodBase
		{
			return _pEffectsPass.getMethodAt(index);
		}
		
		/**
		public function addMethodAt(method:EffectMethodBase, index:Number):void
		{

            if ( _pEffectsPass == null )
            {
                _pEffectsPass = new SuperShaderPass( this );

            }

			_pEffectsPass.addMethodAt(method, index);
			pInvalidateScreenPasses();

		}

		/**
		public function removeMethod(method:EffectMethodBase):void
		{
			if (_pEffectsPass)
				return;
			_pEffectsPass.removeMethod(method);
			
			// reconsider
			if (_pEffectsPass.numMethods == 0)
				pInvalidateScreenPasses();
		}
		
		/**
		override public function set mipmap(value:Boolean):void
		{
			if (this._pMipmap == value)
				return;

			super.setMipMap( value );

		}
		
		/**
		public function get normalMap():Texture2DBase
		{
			return _normalMethod.normalMap;
		}
		
		public function set normalMap(value:Texture2DBase):void
		{
			this._normalMethod.normalMap = value;
		}
		
		/**
		public function get specularMap():Texture2DBase
		{
			return _specularMethod.texture;
		}
		
		public function set specularMap(value:Texture2DBase):void
		{
			if (this._specularMethod)
				this._specularMethod.texture = value;
			else
				throw new Error("No specular method was set to assign the specularGlossMap to");
		}
		
		/**
		public function get gloss():Number
		{
			return _specularMethod? _specularMethod.gloss : 0;
		}
		
		public function set gloss(value:Number):void
		{
			if (this._specularMethod)
				this._specularMethod.gloss = value;
		}
		
		/**
		public function get ambient():Number
		{
			return _ambientMethod.ambient;
		}
		
		public function set ambient(value:Number):void
		{
            this._ambientMethod.ambient = value;
		}
		
		/**
		public function get specular():Number
		{
			return _specularMethod? _specularMethod.specular : 0;
		}
		
		public function set specular(value:Number):void
		{
			if (this._specularMethod)
                this._specularMethod.specular = value;
		}
		
		/**
		public function get ambientColor():Number
		{
			return _ambientMethod.ambientColor;
		}
		
		public function set ambientColor(value:Number):void
		{
            this._ambientMethod.ambientColor = value;
		}
		
		/**
		public function get specularColor():Number
		{
			return _specularMethod.specularColor;
		}
		
		public function set specularColor(value:Number):void
		{
            this._specularMethod.specularColor = value;
		}
		
		/**
		override public function iUpdateMaterial(context:Context3D):void
		{
			var passesInvalid:Boolean;
			
			if (_screenPassesInvalid) {
				pUpdateScreenPasses();
				passesInvalid = true;
			}
			
			if (passesInvalid || isAnyScreenPassInvalid()) {
				pClearPasses();
				
				addChildPassesFor(_casterLightPass);

				if (_nonCasterLightPasses) {
					for (var i:Number = 0; i < _nonCasterLightPasses.length; ++i)
						addChildPassesFor(_nonCasterLightPasses[i]);
				}

				addChildPassesFor(_pEffectsPass);
				
				addScreenPass(_casterLightPass);

				if (_nonCasterLightPasses)
                {

					for (i = 0; i < _nonCasterLightPasses.length; ++i)
                    {
						addScreenPass(_nonCasterLightPasses[i]);
                    }

				}

				addScreenPass(_pEffectsPass);
			}
		}

		/**
		private function addScreenPass(pass:CompiledPass):void
		{
			if (pass)
            {

				pAddPass(pass);
				pass._iPassesDirty = false;

			}
		}

		/**
		private function isAnyScreenPassInvalid():Boolean
		{
			if ((_casterLightPass && _casterLightPass._iPassesDirty) ||
				(_pEffectsPass && _pEffectsPass._iPassesDirty))
            {

				return true;

			}
			
			if (_nonCasterLightPasses) {
				for (var i:Number = 0; i < _nonCasterLightPasses.length; ++i)
                {
					if (_nonCasterLightPasses[i]._iPassesDirty)
						return true;
				}
			}
			
			return false;
		}

		/**
		private function addChildPassesFor(pass:CompiledPass):void
		{
			if (!pass)
				return;
			
			if (pass._iPasses)
            {
				var len:Number = pass._iPasses.length;

				for (var i:Number = 0; i < len; ++i)
                {
					pAddPass(pass._iPasses[i]);
                }
			}
		}

		/**
		override public function iActivatePass(index:Number, stage3DProxy:Stage3DProxy, camera:Camera3D):void
		{
			if (index == 0)
            {
				stage3DProxy._iContext3D.setBlendFactors(Context3DBlendFactor.ONE, Context3DBlendFactor.ZERO);
            }
			super.iActivatePass(index, stage3DProxy, camera);
		}

		/**
		override public function iDeactivate(stage3DProxy:Stage3DProxy):void
		{
			super.iDeactivate(stage3DProxy);
			stage3DProxy._iContext3D.setBlendFactors(Context3DBlendFactor.ONE, Context3DBlendFactor.ZERO);
		}

		/**
		public function pUpdateScreenPasses():void
		{
			initPasses();
			setBlendAndCompareModes();
			
			_screenPassesInvalid = false;
		}

		/**
		private function initPasses():void
		{
			// let the effects pass handle everything if there are no lights,
			// or when there are effect methods applied after shading.
			if (numLights == 0 || numMethods > 0)
            {
                initEffectsPass();
            }
			else if (_pEffectsPass && numMethods == 0)
            {
				removeEffectsPass();
            }

			// only use a caster light pass if shadows need to be rendered
			if (_shadowMethod)
            {
                initCasterLightPass();
            }
			else
            {
				removeCasterLightPass();
            }

			// only use non caster light passes if there are lights that don't cast
			if (numNonCasters > 0)
				initNonCasterLightPasses();
			else
                removeNonCasterLightPasses();
		}

		/**
		private function setBlendAndCompareModes():void
		{
			var forceSeparateMVP:Boolean = Boolean(( _casterLightPass || _pEffectsPass));

			// caster light pass is always first if it exists, hence it uses normal blending
			if ( _casterLightPass)
            {
				_casterLightPass.setBlendMode(BlendMode.NORMAL);
                _casterLightPass.depthCompareMode = _pDepthCompareMode;
                _casterLightPass.forceSeparateMVP = forceSeparateMVP;
			}

			if (_nonCasterLightPasses)
            {
				var firstAdditiveIndex:Number = 0;

				// if there's no caster light pass, the first non caster light pass will be the first
				// and should use normal blending
				if (!_casterLightPass) {
					_nonCasterLightPasses[0].forceSeparateMVP = forceSeparateMVP;
					_nonCasterLightPasses[0].setBlendMode(BlendMode.NORMAL);
					_nonCasterLightPasses[0].depthCompareMode = _pDepthCompareMode;
					firstAdditiveIndex = 1;
				}

				// all lighting passes following the first light pass should use additive blending
				for (var i:Number = firstAdditiveIndex; i < _nonCasterLightPasses.length; ++i) {
					_nonCasterLightPasses[i].forceSeparateMVP = forceSeparateMVP;
                    _nonCasterLightPasses[i].setBlendMode(BlendMode.ADD);
                    _nonCasterLightPasses[i].depthCompareMode = Context3DCompareMode.LESS_EQUAL;
				}
			}

			if (_casterLightPass || _nonCasterLightPasses)
            {

				// there are light passes, so this should be blended in
				if (_pEffectsPass)
                {
                    _pEffectsPass.iIgnoreLights= true;
                    _pEffectsPass.depthCompareMode = Context3DCompareMode.LESS_EQUAL;
                    _pEffectsPass.setBlendMode(BlendMode.LAYER);
                    _pEffectsPass.forceSeparateMVP = forceSeparateMVP;
				}

			}
            else if (_pEffectsPass)
            {
				// effects pass is the only pass, so it should just blend normally
				_pEffectsPass.iIgnoreLights = false;
                _pEffectsPass.depthCompareMode = _pDepthCompareMode;

                depthCompareMode

                _pEffectsPass.setBlendMode(BlendMode.NORMAL);
                _pEffectsPass.forceSeparateMVP = false;
			}
		}

		private function initCasterLightPass():void
		{

            if ( _casterLightPass == null )
            {

                _casterLightPass = new ShadowCasterPass(this);

            }

			_casterLightPass.diffuseMethod = null;
            _casterLightPass.ambientMethod = null;
            _casterLightPass.normalMethod = null;
            _casterLightPass.specularMethod = null;
            _casterLightPass.shadowMethod = null;
            _casterLightPass.enableLightFallOff = _enableLightFallOff;
            _casterLightPass.lightPicker = new StaticLightPicker([_shadowMethod.castingLight]);
            _casterLightPass.shadowMethod = _shadowMethod;
            _casterLightPass.diffuseMethod = _diffuseMethod;
            _casterLightPass.ambientMethod = _ambientMethod;
            _casterLightPass.normalMethod = _normalMethod;
            _casterLightPass.specularMethod = _specularMethod;
            _casterLightPass.diffuseLightSources = _diffuseLightSources;
            _casterLightPass.specularLightSources = _specularLightSources;
		}
		
		private function removeCasterLightPass():void
		{
			if (!_casterLightPass)
				return;
            _casterLightPass.dispose();
            pRemovePass(_casterLightPass);
            _casterLightPass = null;
		}
		
		private function initNonCasterLightPasses():void
		{
			removeNonCasterLightPasses();
			var pass:LightingPass;
			var numDirLights:Number = _pLightPicker.numDirectionalLights;
			var numPointLights:Number = _pLightPicker.numPointLights;
			var numLightProbes:Number = _pLightPicker.numLightProbes;
			var dirLightOffset:Number = 0;
			var pointLightOffset:Number = 0;
			var probeOffset:Number = 0;
			
			if (! _casterLightPass) {
				numDirLights += _pLightPicker.numCastingDirectionalLights;
				numPointLights += _pLightPicker.numCastingPointLights;
			}
			
			_nonCasterLightPasses = new Vector.<LightingPass>();

			while (dirLightOffset < numDirLights || pointLightOffset < numPointLights || probeOffset < numLightProbes)
            {
				pass = new LightingPass(this);
				pass.enableLightFallOff = _enableLightFallOff;
				pass.includeCasters = _shadowMethod == null;
				pass.directionalLightsOffset = dirLightOffset;
				pass.pointLightsOffset = pointLightOffset;
				pass.lightProbesOffset = probeOffset;
				pass.diffuseMethod = null;
				pass.ambientMethod = null;
				pass.normalMethod = null;
				pass.specularMethod = null;
				pass.lightPicker = _pLightPicker;
				pass.diffuseMethod = _diffuseMethod;
				pass.ambientMethod = _ambientMethod;
				pass.normalMethod = _normalMethod;
				pass.specularMethod = _specularMethod;
				pass.diffuseLightSources = _diffuseLightSources;
				pass.specularLightSources = _specularLightSources;
                _nonCasterLightPasses.push(pass);
				
				dirLightOffset += pass.iNumDirectionalLights;
				pointLightOffset += pass.iNumPointLights;
				probeOffset += pass.iNumLightProbes;
			}
		}
		
		private function removeNonCasterLightPasses():void
		{
			if (! _nonCasterLightPasses)
				return;

			for (var i:Number = 0; i < _nonCasterLightPasses.length; ++i)
            {
                pRemovePass(_nonCasterLightPasses[i]);
				_nonCasterLightPasses[i].dispose();
			}
			_nonCasterLightPasses = null;
		}
		
		private function removeEffectsPass():void
		{
			if (_pEffectsPass.diffuseMethod != _diffuseMethod)
                _pEffectsPass.diffuseMethod.dispose();

            pRemovePass(_pEffectsPass);
            _pEffectsPass.dispose();
            _pEffectsPass = null;
		}
		
		private function initEffectsPass():SuperShaderPass
		{

            if ( _pEffectsPass == null )
            {

                _pEffectsPass = new SuperShaderPass(this);

            }

			_pEffectsPass.enableLightFallOff = _enableLightFallOff;
			if (numLights == 0)
            {
				_pEffectsPass.diffuseMethod = null;
                _pEffectsPass.diffuseMethod = _diffuseMethod;

			}
            else
            {
				_pEffectsPass.diffuseMethod = null;
                _pEffectsPass.diffuseMethod = new BasicDiffuseMethod();
                _pEffectsPass.diffuseMethod.diffuseColor = 0x000000;
                _pEffectsPass.diffuseMethod.diffuseAlpha = 0;
			}

            _pEffectsPass.preserveAlpha = false;
            _pEffectsPass.normalMethod = null;
            _pEffectsPass.normalMethod = _normalMethod;
			
			return _pEffectsPass;
		}

		/**
		private function get numLights():Number
		{
			return _pLightPicker? _pLightPicker.numLightProbes + _pLightPicker.numDirectionalLights + _pLightPicker.numPointLights +
				_pLightPicker.numCastingDirectionalLights + _pLightPicker.numCastingPointLights : 0;
		}

		/**
		private function get numNonCasters():Number
		{
			return _pLightPicker? _pLightPicker.numLightProbes + _pLightPicker.numDirectionalLights + _pLightPicker.numPointLights : 0;
		}

		/**
		public function pInvalidateScreenPasses():void
		{
			_screenPassesInvalid = true;
		}

		/**
		private function onLightsChange(event:Event):void
		{
			pInvalidateScreenPasses();
		}

	}

}