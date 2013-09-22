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

	/**	 * MultiPassMaterialBase forms an abstract base class for the default multi-pass materials provided by Away3D,	 * using material methods to define their appearance.	 */
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
		
		/**		 * Creates a new MultiPassMaterialBase object.		 */
		public function MultiPassMaterialBase():void
		{
			super();
		}
		
		/**		 * Whether or not to use fallOff and radius properties for lights. This can be used to improve performance and		 * compatibility for constrained mode.		 */
		public function get enableLightFallOff():Boolean
		{
			return this._enableLightFallOff;
		}
		
		public function set enableLightFallOff(value:Boolean):void
		{

			if (this._enableLightFallOff != value)
				this.pInvalidateScreenPasses();
            this._enableLightFallOff = value;

		}
		
		/**		 * The minimum alpha value for which pixels should be drawn. This is used for transparency that is either		 * invisible or entirely opaque, often used with textures for foliage, etc.		 * Recommended values are 0 to disable alpha, or 0.5 to create smooth edges. Default value is 0 (disabled).		 */
		public function get alphaThreshold():Number
		{
			return this._alphaThreshold;
		}
		
		public function set alphaThreshold(value:Number):void
		{
            this._alphaThreshold = value;
            this._diffuseMethod.alphaThreshold = value;
            this._pDepthPass.alphaThreshold = value;
            this._pDistancePass.alphaThreshold = value;
		}

		/**		 * @inheritDoc		 */
		override public function set depthCompareMode(value:String):void
		{
			super.setDepthCompareMode( value );
			this.pInvalidateScreenPasses();
		}

		/**		 * @inheritDoc		 */
		override public function set blendMode(value:String):void
		{
			super.setBlendMode( value );
			this.pInvalidateScreenPasses();
		}

		/**		 * @inheritDoc		 */
		override public function iActivateForDepth(stage3DProxy:Stage3DProxy, camera:Camera3D, distanceBased:Boolean = false):void
		{
			distanceBased = distanceBased || false;

			if (distanceBased)
            {
				this._pDistancePass.alphaMask = this._diffuseMethod.texture;

            }
			else
            {
				this._pDepthPass.alphaMask = this._diffuseMethod.texture;
            }

			super.iActivateForDepth(stage3DProxy, camera, distanceBased);
		}

		/**		 * Define which light source types to use for specular reflections. This allows choosing between regular lights		 * and/or light probes for specular reflections.		 *		 * @see away3d.materials.LightSources		 */
		public function get specularLightSources():Number
		{
			return this._specularLightSources;
		}
		
		public function set specularLightSources(value:Number):void
		{
            this._specularLightSources = value;
		}

		/**		 * Define which light source types to use for diffuse reflections. This allows choosing between regular lights		 * and/or light probes for diffuse reflections.		 *		 * @see away3d.materials.LightSources		 */
		public function get diffuseLightSources():Number
		{
			return this._diffuseLightSources;
		}
		
		public function set diffuseLightSources(value:Number):void
		{
            this._diffuseLightSources = value;
		}

		/**		 * @inheritDoc		 */
		override public function set lightPicker(value:LightPickerBase):void
		{
			if (this._pLightPicker)
				this._pLightPicker.removeEventListener(Event.CHANGE, onLightsChange , this );

            super.setLightPicker( value );

			if (this._pLightPicker)
				this._pLightPicker.addEventListener(Event.CHANGE, onLightsChange , this );
			this.pInvalidateScreenPasses();
		}
		
		/**		 * @inheritDoc		 */
		override public function get requiresBlending():Boolean
		{
			return false;
		}
		
		/**		 * The method that provides the ambient lighting contribution. Defaults to BasicAmbientMethod.		 */
		public function get ambientMethod():BasicAmbientMethod
		{
			return this._ambientMethod;
		}
		
		public function set ambientMethod(value:BasicAmbientMethod):void
		{
			value.copyFrom(this._ambientMethod);
			this._ambientMethod = value;
			this.pInvalidateScreenPasses();
		}
		
		/**		 * The method used to render shadows cast on this surface, or null if no shadows are to be rendered. Defaults to null.		 */
		public function get shadowMethod():ShadowMapMethodBase
		{
			return this._shadowMethod;
		}
		
		public function set shadowMethod(value:ShadowMapMethodBase):void
		{
			if (value && this._shadowMethod)
				value.copyFrom(this._shadowMethod);
            this._shadowMethod = value;
            this.pInvalidateScreenPasses();
		}
		
		/**		 * The method that provides the diffuse lighting contribution. Defaults to BasicDiffuseMethod.		 */
		public function get diffuseMethod():BasicDiffuseMethod
		{
			return this._diffuseMethod;
		}
		
		public function set diffuseMethod(value:BasicDiffuseMethod):void
		{
			value.copyFrom(this._diffuseMethod);
            this._diffuseMethod = value;
			this.pInvalidateScreenPasses();
		}

		/**		 * The method that provides the specular lighting contribution. Defaults to BasicSpecularMethod.		 */
		public function get specularMethod():BasicSpecularMethod
		{
			return this._specularMethod;
		}

		public function set specularMethod(value:BasicSpecularMethod):void
		{
			if (value && this._specularMethod)
				value.copyFrom(this._specularMethod);
			this._specularMethod = value;
			this.pInvalidateScreenPasses();
		}
		
		/**		 * The method used to generate the per-pixel normals. Defaults to BasicNormalMethod.		 */
		public function get normalMethod():BasicNormalMethod
		{
			return this._normalMethod;
		}
		
		public function set normalMethod(value:BasicNormalMethod):void
		{
			value.copyFrom(this._normalMethod);
			this._normalMethod = value;
			this.pInvalidateScreenPasses();
		}
		
		/**		 * Appends an "effect" shading method to the shader. Effect methods are those that do not influence the lighting		 * but modulate the shaded colour, used for fog, outlines, etc. The method will be applied to the result of the		 * methods added prior.		 */
		public function addMethod(method:EffectMethodBase):void
		{

            if ( this._pEffectsPass == null )
            {
                this._pEffectsPass = new SuperShaderPass( this );

            }

			this._pEffectsPass.addMethod(method);
			this.pInvalidateScreenPasses();
		}

		/**		 * The number of "effect" methods added to the material.		 */
		public function get numMethods():Number
		{
			return this._pEffectsPass? this._pEffectsPass.numMethods : 0;
		}

		/**		 * Queries whether a given effect method was added to the material.		 *		 * @param method The method to be queried.		 * @return true if the method was added to the material, false otherwise.		 */
		public function hasMethod(method:EffectMethodBase):Boolean
		{
			return this._pEffectsPass? this._pEffectsPass.hasMethod(method) : false;
		}

		/**		 * Returns the method added at the given index.		 * @param index The index of the method to retrieve.		 * @return The method at the given index.		 */
		public function getMethodAt(index:Number):EffectMethodBase
		{
			return this._pEffectsPass.getMethodAt(index);
		}
		
		/**		 * Adds an effect method at the specified index amongst the methods already added to the material. Effect		 * methods are those that do not influence the lighting but modulate the shaded colour, used for fog, outlines,		 * etc. The method will be applied to the result of the methods with a lower index.		 */
		public function addMethodAt(method:EffectMethodBase, index:Number):void
		{

            if ( this._pEffectsPass == null )
            {
                this._pEffectsPass = new SuperShaderPass( this );

            }

			this._pEffectsPass.addMethodAt(method, index);
			this.pInvalidateScreenPasses();

		}

		/**		 * Removes an effect method from the material.		 * @param method The method to be removed.		 */
		public function removeMethod(method:EffectMethodBase):void
		{
			if (this._pEffectsPass)
				return;
			this._pEffectsPass.removeMethod(method);
			
			// reconsider
			if (this._pEffectsPass.numMethods == 0)
				this.pInvalidateScreenPasses();
		}
		
		/**		 * @inheritDoc		 */
		override public function set mipmap(value:Boolean):void
		{
			if (this._pMipmap == value)
				return;

			super.setMipMap( value );

		}
		
		/**		 * The normal map to modulate the direction of the surface for each texel. The default normal method expects		 * tangent-space normal maps, but others could expect object-space maps.		 */
		public function get normalMap():Texture2DBase
		{
			return this._normalMethod.normalMap;
		}
		
		public function set normalMap(value:Texture2DBase):void
		{
			this._normalMethod.normalMap = value;
		}
		
		/**		 * A specular map that defines the strength of specular reflections for each texel in the red channel,		 * and the gloss factor in the green channel. You can use SpecularBitmapTexture if you want to easily set		 * specular and gloss maps from grayscale images, but correctly authored images are preferred.		 */
		public function get specularMap():Texture2DBase
		{
			return this._specularMethod.texture;
		}
		
		public function set specularMap(value:Texture2DBase):void
		{
			if (this._specularMethod)
				this._specularMethod.texture = value;
			else
				throw new Error("No specular method was set to assign the specularGlossMap to");
		}
		
		/**		 * The glossiness of the material (sharpness of the specular highlight).		 */
		public function get gloss():Number
		{
			return this._specularMethod? this._specularMethod.gloss : 0;
		}
		
		public function set gloss(value:Number):void
		{
			if (this._specularMethod)
				this._specularMethod.gloss = value;
		}
		
		/**		 * The strength of the ambient reflection.		 */
		public function get ambient():Number
		{
			return this._ambientMethod.ambient;
		}
		
		public function set ambient(value:Number):void
		{
            this._ambientMethod.ambient = value;
		}
		
		/**		 * The overall strength of the specular reflection.		 */
		public function get specular():Number
		{
			return this._specularMethod? this._specularMethod.specular : 0;
		}
		
		public function set specular(value:Number):void
		{
			if (this._specularMethod)
                this._specularMethod.specular = value;
		}
		
		/**		 * The colour of the ambient reflection.		 */
		public function get ambientColor():Number
		{
			return this._ambientMethod.ambientColor;
		}
		
		public function set ambientColor(value:Number):void
		{
            this._ambientMethod.ambientColor = value;
		}
		
		/**		 * The colour of the specular reflection.		 */
		public function get specularColor():Number
		{
			return this._specularMethod.specularColor;
		}
		
		public function set specularColor(value:Number):void
		{
            this._specularMethod.specularColor = value;
		}
		
		/**		 * @inheritDoc		 */
		override public function iUpdateMaterial(context:Context3D):void
		{
			var passesInvalid:Boolean;
			
			if (this._screenPassesInvalid) {
				this.pUpdateScreenPasses();
				passesInvalid = true;
			}
			
			if (passesInvalid || this.isAnyScreenPassInvalid()) {
				this.pClearPasses();
				
				this.addChildPassesFor(this._casterLightPass);

				if (this._nonCasterLightPasses) {
					for (var i:Number = 0; i < this._nonCasterLightPasses.length; ++i)
						this.addChildPassesFor(this._nonCasterLightPasses[i]);
				}

				this.addChildPassesFor(this._pEffectsPass);
				
				this.addScreenPass(this._casterLightPass);

				if (this._nonCasterLightPasses)
                {

					for (i = 0; i < this._nonCasterLightPasses.length; ++i)
                    {
						this.addScreenPass(this._nonCasterLightPasses[i]);
                    }

				}

				this.addScreenPass(this._pEffectsPass);
			}
		}

		/**		 * Adds a compiled pass that renders to the screen.		 * @param pass The pass to be added.		 */
		private function addScreenPass(pass:CompiledPass):void
		{
			if (pass)
            {

				this.pAddPass(pass);
				pass._iPassesDirty = false;

			}
		}

		/**		 * Tests if any pass that renders to the screen is invalid. This would trigger a new setup of the multiple passes.		 * @return		 */
		private function isAnyScreenPassInvalid():Boolean
		{
			if ((this._casterLightPass && this._casterLightPass._iPassesDirty) ||
				(this._pEffectsPass && this._pEffectsPass._iPassesDirty))
            {

				return true;

			}
			
			if (this._nonCasterLightPasses) {
				for (var i:Number = 0; i < this._nonCasterLightPasses.length; ++i)
                {
					if (this._nonCasterLightPasses[i]._iPassesDirty)
						return true;
				}
			}
			
			return false;
		}

		/**		 * Adds any additional passes on which the given pass is dependent.		 * @param pass The pass that my need additional passes.		 */
		private function addChildPassesFor(pass:CompiledPass):void
		{
			if (!pass)
				return;
			
			if (pass._iPasses)
            {
				var len:Number = pass._iPasses.length;

				for (var i:Number = 0; i < len; ++i)
                {
					this.pAddPass(pass._iPasses[i]);
                }
			}
		}

		/**		 * @inheritDoc		 */
		override public function iActivatePass(index:Number, stage3DProxy:Stage3DProxy, camera:Camera3D):void
		{
			if (index == 0)
            {
				stage3DProxy._iContext3D.setBlendFactors(Context3DBlendFactor.ONE, Context3DBlendFactor.ZERO);
            }
			super.iActivatePass(index, stage3DProxy, camera);
		}

		/**		 * @inheritDoc		 */
		override public function iDeactivate(stage3DProxy:Stage3DProxy):void
		{
			super.iDeactivate(stage3DProxy);
			stage3DProxy._iContext3D.setBlendFactors(Context3DBlendFactor.ONE, Context3DBlendFactor.ZERO);
		}

		/**		 * Updates screen passes when they were found to be invalid.		 */
		public function pUpdateScreenPasses():void
		{
			this.initPasses();
			this.setBlendAndCompareModes();
			
			this._screenPassesInvalid = false;
		}

		/**		 * Initializes all the passes and their dependent passes.		 */
		private function initPasses():void
		{
			// let the effects pass handle everything if there are no lights,
			// or when there are effect methods applied after shading.
			if (this.numLights == 0 || this.numMethods > 0)
            {
                this.initEffectsPass();
            }
			else if (this._pEffectsPass && this.numMethods == 0)
            {
				this.removeEffectsPass();
            }

			// only use a caster light pass if shadows need to be rendered
			if (this._shadowMethod)
            {
                this.initCasterLightPass();
            }
			else
            {
				this.removeCasterLightPass();
            }

			// only use non caster light passes if there are lights that don't cast
			if (this.numNonCasters > 0)
				this.initNonCasterLightPasses();
			else
                this.removeNonCasterLightPasses();
		}

		/**		 * Sets up the various blending modes for all screen passes, based on whether or not there are previous passes.		 */
		private function setBlendAndCompareModes():void
		{
			var forceSeparateMVP:Boolean = (( this._casterLightPass || this._pEffectsPass ) as Boolean);

			// caster light pass is always first if it exists, hence it uses normal blending
			if ( this._casterLightPass)
            {
				this._casterLightPass.setBlendMode(BlendMode.NORMAL);
                this._casterLightPass.depthCompareMode = this._pDepthCompareMode;
                this._casterLightPass.forceSeparateMVP = forceSeparateMVP;
			}

			if (this._nonCasterLightPasses)
            {
				var firstAdditiveIndex:Number = 0;

				// if there's no caster light pass, the first non caster light pass will be the first
				// and should use normal blending
				if (!this._casterLightPass) {
					this._nonCasterLightPasses[0].forceSeparateMVP = forceSeparateMVP;
					this._nonCasterLightPasses[0].setBlendMode(BlendMode.NORMAL);
					this._nonCasterLightPasses[0].depthCompareMode = this._pDepthCompareMode;
					firstAdditiveIndex = 1;
				}

				// all lighting passes following the first light pass should use additive blending
				for (var i:Number = firstAdditiveIndex; i < this._nonCasterLightPasses.length; ++i) {
					this._nonCasterLightPasses[i].forceSeparateMVP = forceSeparateMVP;
                    this._nonCasterLightPasses[i].setBlendMode(BlendMode.ADD);
                    this._nonCasterLightPasses[i].depthCompareMode = Context3DCompareMode.LESS_EQUAL;
				}
			}

			if (this._casterLightPass || this._nonCasterLightPasses)
            {

				// there are light passes, so this should be blended in
				if (this._pEffectsPass)
                {
                    this._pEffectsPass.iIgnoreLights= true;
                    this._pEffectsPass.depthCompareMode = Context3DCompareMode.LESS_EQUAL;
                    this._pEffectsPass.setBlendMode(BlendMode.LAYER);
                    this._pEffectsPass.forceSeparateMVP = forceSeparateMVP;
				}

			}
            else if (this._pEffectsPass)
            {
				// effects pass is the only pass, so it should just blend normally
				this._pEffectsPass.iIgnoreLights = false;
                this._pEffectsPass.depthCompareMode = this._pDepthCompareMode;

                this.depthCompareMode

                this._pEffectsPass.setBlendMode(BlendMode.NORMAL);
                this._pEffectsPass.forceSeparateMVP = false;
			}
		}

		private function initCasterLightPass():void
		{

            if ( this._casterLightPass == null )
            {

                this._casterLightPass = new ShadowCasterPass(this);

            }

			this._casterLightPass.diffuseMethod = null;
            this._casterLightPass.ambientMethod = null;
            this._casterLightPass.normalMethod = null;
            this._casterLightPass.specularMethod = null;
            this._casterLightPass.shadowMethod = null;
            this._casterLightPass.enableLightFallOff = this._enableLightFallOff;
            this._casterLightPass.lightPicker = new StaticLightPicker([this._shadowMethod.castingLight]);
            this._casterLightPass.shadowMethod = this._shadowMethod;
            this._casterLightPass.diffuseMethod = this._diffuseMethod;
            this._casterLightPass.ambientMethod = this._ambientMethod;
            this._casterLightPass.normalMethod = this._normalMethod;
            this._casterLightPass.specularMethod = this._specularMethod;
            this._casterLightPass.diffuseLightSources = this._diffuseLightSources;
            this._casterLightPass.specularLightSources = this._specularLightSources;
		}
		
		private function removeCasterLightPass():void
		{
			if (!this._casterLightPass)
				return;
            this._casterLightPass.dispose();
            this.pRemovePass(this._casterLightPass);
            this._casterLightPass = null;
		}
		
		private function initNonCasterLightPasses():void
		{
			this.removeNonCasterLightPasses();
			var pass:LightingPass;
			var numDirLights:Number = this._pLightPicker.numDirectionalLights;
			var numPointLights:Number = this._pLightPicker.numPointLights;
			var numLightProbes:Number = this._pLightPicker.numLightProbes;
			var dirLightOffset:Number = 0;
			var pointLightOffset:Number = 0;
			var probeOffset:Number = 0;
			
			if (! this._casterLightPass) {
				numDirLights += this._pLightPicker.numCastingDirectionalLights;
				numPointLights += this._pLightPicker.numCastingPointLights;
			}
			
			this._nonCasterLightPasses = new Vector.<LightingPass>();

			while (dirLightOffset < numDirLights || pointLightOffset < numPointLights || probeOffset < numLightProbes)
            {
				pass = new LightingPass(this);
				pass.enableLightFallOff = this._enableLightFallOff;
				pass.includeCasters = this._shadowMethod == null;
				pass.directionalLightsOffset = dirLightOffset;
				pass.pointLightsOffset = pointLightOffset;
				pass.lightProbesOffset = probeOffset;
				pass.diffuseMethod = null;
				pass.ambientMethod = null;
				pass.normalMethod = null;
				pass.specularMethod = null;
				pass.lightPicker = this._pLightPicker;
				pass.diffuseMethod = this._diffuseMethod;
				pass.ambientMethod = this._ambientMethod;
				pass.normalMethod = this._normalMethod;
				pass.specularMethod = this._specularMethod;
				pass.diffuseLightSources = this._diffuseLightSources;
				pass.specularLightSources = this._specularLightSources;
                this._nonCasterLightPasses.push(pass);
				
				dirLightOffset += pass.iNumDirectionalLights;
				pointLightOffset += pass.iNumPointLights;
				probeOffset += pass.iNumLightProbes;
			}
		}
		
		private function removeNonCasterLightPasses():void
		{
			if (! this._nonCasterLightPasses)
				return;

			for (var i:Number = 0; i < this._nonCasterLightPasses.length; ++i)
            {
                this.pRemovePass(this._nonCasterLightPasses[i]);
				this._nonCasterLightPasses[i].dispose();
			}
			this._nonCasterLightPasses = null;
		}
		
		private function removeEffectsPass():void
		{
			if (this._pEffectsPass.diffuseMethod != this._diffuseMethod)
                this._pEffectsPass.diffuseMethod.dispose();

            this.pRemovePass(this._pEffectsPass);
            this._pEffectsPass.dispose();
            this._pEffectsPass = null;
		}
		
		private function initEffectsPass():SuperShaderPass
		{

            if ( this._pEffectsPass == null )
            {

                this._pEffectsPass = new SuperShaderPass(this);

            }

			this._pEffectsPass.enableLightFallOff = this._enableLightFallOff;
			if (this.numLights == 0)
            {
				this._pEffectsPass.diffuseMethod = null;
                this._pEffectsPass.diffuseMethod = this._diffuseMethod;

			}
            else
            {
				this._pEffectsPass.diffuseMethod = null;
                this._pEffectsPass.diffuseMethod = new BasicDiffuseMethod();
                this._pEffectsPass.diffuseMethod.diffuseColor = 0x000000;
                this._pEffectsPass.diffuseMethod.diffuseAlpha = 0;
			}

            this._pEffectsPass.preserveAlpha = false;
            this._pEffectsPass.normalMethod = null;
            this._pEffectsPass.normalMethod = this._normalMethod;
			
			return this._pEffectsPass;
		}

		/**		 * The maximum total number of lights provided by the light picker.		 */
		private function get numLights():Number
		{
			return this._pLightPicker? this._pLightPicker.numLightProbes + this._pLightPicker.numDirectionalLights + this._pLightPicker.numPointLights +
				this._pLightPicker.numCastingDirectionalLights + this._pLightPicker.numCastingPointLights : 0;
		}

		/**		 * The amount of lights that don't cast shadows.		 */
		private function get numNonCasters():Number
		{
			return this._pLightPicker? this._pLightPicker.numLightProbes + this._pLightPicker.numDirectionalLights + this._pLightPicker.numPointLights : 0;
		}

		/**		 * Flags that the screen passes have become invalid.		 */
		public function pInvalidateScreenPasses():void
		{
			this._screenPassesInvalid = true;
		}

		/**		 * Called when the light picker's configuration changed.		 */
		private function onLightsChange(event:Event):void
		{
			this.pInvalidateScreenPasses();
		}

	}

}
