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

	/**	 * SinglePassMaterialBase forms an abstract base class for the default single-pass materials provided by Away3D,	 * using material methods to define their appearance.	 */
	public class SinglePassMaterialBase extends MaterialBase
	{
		public var _pScreenPass:SuperShaderPass;
		private var _alphaBlending:Boolean = false;
		
		/**		 * Creates a new SinglePassMaterialBase object.		 */
		public function SinglePassMaterialBase():void
		{
			super();

            this.pAddPass( this._pScreenPass = new SuperShaderPass(this) );
		}
		
		/**		 * Whether or not to use fallOff and radius properties for lights. This can be used to improve performance and		 * compatibility for constrained mode.		 */
		public function get enableLightFallOff():Boolean
		{
			return _pScreenPass.enableLightFallOff;
		}
		
		public function set enableLightFallOff(value:Boolean):void
		{
            this._pScreenPass.enableLightFallOff = value;
		}
		
		/**		 * The minimum alpha value for which pixels should be drawn. This is used for transparency that is either		 * invisible or entirely opaque, often used with textures for foliage, etc.		 * Recommended values are 0 to disable alpha, or 0.5 to create smooth edges. Default value is 0 (disabled).		 */
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

		/**		 * @inheritDoc		 */
		override public function set blendMode(value:String):void
		{

            super.setBlendMode( value );
			this._pScreenPass.setBlendMode( ( this._pBlendMode == BlendMode.NORMAL ) && this.requiresBlending?  BlendMode.LAYER : this._pBlendMode);

		}

		/**		 * @inheritDoc		 */
		override public function set depthCompareMode(value:String):void
		{

			this._pDepthCompareMode = value;
			this._pScreenPass.depthCompareMode = value;
		}

		/**		 * @inheritDoc		 */
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

		/**		 * Define which light source types to use for specular reflections. This allows choosing between regular lights		 * and/or light probes for specular reflections.		 *		 * @see away3d.materials.LightSources		 */
		public function get specularLightSources():Number
		{
			return _pScreenPass.specularLightSources;
		}
		
		public function set specularLightSources(value:Number):void
		{
			this._pScreenPass.specularLightSources = value;
		}

		/**		 * Define which light source types to use for diffuse reflections. This allows choosing between regular lights		 * and/or light probes for diffuse reflections.		 *		 * @see away3d.materials.LightSources		 */
		public function get diffuseLightSources():Number
		{
			return _pScreenPass.diffuseLightSources;
		}
		
		public function set diffuseLightSources(value:Number):void
		{
            this._pScreenPass.diffuseLightSources = value;
		}

		/**		 * @inheritDoc		 */
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

		/**		 * The ColorTransform object to transform the colour of the material with. Defaults to null.		 */
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

		/**		 * The method that provides the ambient lighting contribution. Defaults to BasicAmbientMethod.		 */

		public function get ambientMethod():BasicAmbientMethod
		{
			return _pScreenPass.ambientMethod;
		}
		
		public function set ambientMethod(value:BasicAmbientMethod):void
		{
			this._pScreenPass.ambientMethod = value;
		}

		/**		 * The method used to render shadows cast on this surface, or null if no shadows are to be rendered. Defaults to null.		 */
		public function get shadowMethod():ShadowMapMethodBase
		{
			return _pScreenPass.shadowMethod;
		}
		
		public function set shadowMethod(value:ShadowMapMethodBase):void
		{
			this._pScreenPass.shadowMethod = value;
		}

		/**		 * The method that provides the diffuse lighting contribution. Defaults to BasicDiffuseMethod.		 */

		public function get diffuseMethod():BasicDiffuseMethod
		{
			return _pScreenPass.diffuseMethod;
		}
		
		public function set diffuseMethod(value:BasicDiffuseMethod):void
		{
			this._pScreenPass.diffuseMethod = value;
		}

		/**		 * The method used to generate the per-pixel normals. Defaults to BasicNormalMethod.		 */

		public function get normalMethod():BasicNormalMethod
		{
			return _pScreenPass.normalMethod;
		}
		
		public function set normalMethod(value:BasicNormalMethod):void
		{
			this._pScreenPass.normalMethod = value;
		}

		/**		 * The method that provides the specular lighting contribution. Defaults to BasicSpecularMethod.		 */

		public function get specularMethod():BasicSpecularMethod
		{
			return _pScreenPass.specularMethod;
		}
		
		public function set specularMethod(value:BasicSpecularMethod):void
		{
			this._pScreenPass.specularMethod = value;
		}

		/**		 * Appends an "effect" shading method to the shader. Effect methods are those that do not influence the lighting		 * but modulate the shaded colour, used for fog, outlines, etc. The method will be applied to the result of the		 * methods added prior.		 */
		public function addMethod(method:EffectMethodBase):void
		{
			_pScreenPass.addMethod(method);
		}

		/**		 * The number of "effect" methods added to the material.		 */

		public function get numMethods():Number
		{
			return _pScreenPass.numMethods;
		}

		/**		 * Queries whether a given effect method was added to the material.		 *		 * @param method The method to be queried.		 * @return true if the method was added to the material, false otherwise.		 */
		public function hasMethod(method:EffectMethodBase):Boolean
		{
			return _pScreenPass.hasMethod(method);
		}

		/**		 * Returns the method added at the given index.		 * @param index The index of the method to retrieve.		 * @return The method at the given index.		 */
		public function getMethodAt(index:Number):EffectMethodBase
		{
			return _pScreenPass.getMethodAt(index);
		}

		/**		 * Adds an effect method at the specified index amongst the methods already added to the material. Effect		 * methods are those that do not influence the lighting but modulate the shaded colour, used for fog, outlines,		 * etc. The method will be applied to the result of the methods with a lower index.		 */
		public function addMethodAt(method:EffectMethodBase, index:Number):void
		{
			_pScreenPass.addMethodAt(method, index);
		}

		/**		 * Removes an effect method from the material.		 * @param method The method to be removed.		 */
		public function removeMethod(method:EffectMethodBase):void
		{
			_pScreenPass.removeMethod(method);
		}
		
		/**		 * @inheritDoc		 */
		override public function set mipmap(value:Boolean):void
		{
			if (this._pMipmap == value)
				return;

			this.setMipMap( value );
		}

		/**		 * The normal map to modulate the direction of the surface for each texel. The default normal method expects		 * tangent-space normal maps, but others could expect object-space maps.		 */
		public function get normalMap():Texture2DBase
		{
			return _pScreenPass.normalMap;
		}
		
		public function set normalMap(value:Texture2DBase):void
		{
			this._pScreenPass.normalMap = value;
		}
		
		/**		 * A specular map that defines the strength of specular reflections for each texel in the red channel,		 * and the gloss factor in the green channel. You can use SpecularBitmapTexture if you want to easily set		 * specular and gloss maps from grayscale images, but correctly authored images are preferred.		 */

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

		/**		 * The glossiness of the material (sharpness of the specular highlight).		 */

		public function get gloss():Number
		{
			return _pScreenPass.specularMethod? _pScreenPass.specularMethod.gloss : 0;
		}
		
		public function set gloss(value:Number):void
		{
			if (this._pScreenPass.specularMethod)
                this._pScreenPass.specularMethod.gloss = value;
		}

		/**		 * The strength of the ambient reflection.		 */

		public function get ambient():Number
		{
			return _pScreenPass.ambientMethod.ambient;
		}
		
		public function set ambient(value:Number):void
		{
            this._pScreenPass.ambientMethod.ambient = value;
		}

		/**		 * The overall strength of the specular reflection.		 */

		public function get specular():Number
		{
			return _pScreenPass.specularMethod? _pScreenPass.specularMethod.specular : 0;
		}
		
		public function set specular(value:Number):void
		{
			if (this._pScreenPass.specularMethod)
                this._pScreenPass.specularMethod.specular = value;
		}

		/**		 * The colour of the ambient reflection.		 */

		public function get ambientColor():Number
		{
			return _pScreenPass.ambientMethod.ambientColor;
		}
		
		public function set ambientColor(value:Number):void
		{
            this._pScreenPass.ambientMethod.ambientColor = value;
		}

		/**		 * The colour of the specular reflection.		 */

		public function get specularColor():Number
		{
			return _pScreenPass.specularMethod.specularColor;
		}
		
		public function set specularColor(value:Number):void
		{
			this._pScreenPass.specularMethod.specularColor = value;
		}

		/**		 * Indicates whether or not the material has transparency. If binary transparency is sufficient, for		 * example when using textures of foliage, consider using alphaThreshold instead.		 */

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
		
		/**		 * @inheritDoc		 */
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

		/**		 * @inheritDoc		 */
		override public function set lightPicker(value:LightPickerBase):void
		{

			super.setLightPicker( value );
			this._pScreenPass.lightPicker = value;
		}
	}
}
