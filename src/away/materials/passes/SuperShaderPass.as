/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package away.materials.passes
{
	import away.materials.MaterialBase;
	import away.materials.compilation.ShaderCompiler;
	import away.materials.compilation.SuperShaderCompiler;
	import away.core.geom.ColorTransform;
	import away.materials.methods.ColorTransformMethod;
	import away.materials.methods.EffectMethodBase;
	import away.managers.Stage3DProxy;
	import away.cameras.Camera3D;
	import away.materials.methods.MethodVOSet;
	import away.core.geom.Vector3D;
	import away.materials.LightSources;
	import away.lights.DirectionalLight;
	import away.lights.PointLight;
	import away.lights.LightProbe;
	import away.core.display3D.Context3D;

	/**	 * SuperShaderPass is a shader pass that uses shader methods to compile a complete program. It includes all methods	 * associated with a material.	 *	 * @see away3d.materials.methods.ShadingMethodBase	 */
	public class SuperShaderPass extends CompiledPass
	{
		private var _includeCasters:Boolean = true;
		private var _ignoreLights:Boolean = false;
		
		/**		 * Creates a new SuperShaderPass objects.		 *		 * @param material The material to which this material belongs.		 */
		public function SuperShaderPass(material:MaterialBase):void
		{
			super(material);
			this._pNeedFragmentAnimation = true;
		}

		/**		 * @inheritDoc		 */
		override public function pCreateCompiler(profile:String):ShaderCompiler
		{
			return new SuperShaderCompiler(profile);
		}

		/**		 * Indicates whether lights that cast shadows should be included in the pass.		 */
		public function get includeCasters():Boolean
		{
			return this._includeCasters;
		}
		
		public function set includeCasters(value:Boolean):void
		{
			if (this._includeCasters == value)
				return;
            this._includeCasters = value;
            this.iInvalidateShaderProgram();//invalidateShaderProgram();
		}

		/**		 * The ColorTransform object to transform the colour of the material with. Defaults to null.		 */
		public function get colorTransform():ColorTransform
		{


            return this._pMethodSetup._iColorTransformMethod ? this._pMethodSetup._iColorTransformMethod.colorTransform : null;
		}

		public function set colorTransform(value:ColorTransform):void
		{
			if (value)
            {

                //colorTransformMethod ||= new away.geom.ColorTransform();
                if ( this.colorTransformMethod == null )
                {


                    this.colorTransformMethod = new ColorTransformMethod();

                }

				this._pMethodSetup._iColorTransformMethod.colorTransform = value;

			}
            else if (!value)
            {

				if (this._pMethodSetup._iColorTransformMethod)
                {

                    this.colorTransformMethod = null;

                }

				this._pMethodSetup._iColorTransformMethod =  null;
				this.colorTransformMethod = this._pMethodSetup._iColorTransformMethod
			}
		}

		/**		 * The ColorTransformMethod object to transform the colour of the material with. Defaults to null.		 */
		public function get colorTransformMethod():ColorTransformMethod
		{

			return this._pMethodSetup._iColorTransformMethod;
		}
		
		public function set colorTransformMethod(value:ColorTransformMethod):void
		{
			this._pMethodSetup.iColorTransformMethod = value;
		}

		/**		 * Appends an "effect" shading method to the shader. Effect methods are those that do not influence the lighting		 * but modulate the shaded colour, used for fog, outlines, etc. The method will be applied to the result of the		 * methods added prior.		 */
		public function addMethod(method:EffectMethodBase):void
		{
			this._pMethodSetup.addMethod(method);
		}

		/**		 * The number of "effect" methods added to the material.		 */
		public function get numMethods():Number
		{
			return this._pMethodSetup.numMethods;
		}

		/**		 * Queries whether a given effect method was added to the material.		 *		 * @param method The method to be queried.		 * @return true if the method was added to the material, false otherwise.		 */
		public function hasMethod(method:EffectMethodBase):Boolean
		{
			return this._pMethodSetup.hasMethod(method);
		}

		/**		 * Returns the method added at the given index.		 * @param index The index of the method to retrieve.		 * @return The method at the given index.		 */
		public function getMethodAt(index:Number):EffectMethodBase
		{
			return this._pMethodSetup.getMethodAt(index);
		}

		/**		 * Adds an effect method at the specified index amongst the methods already added to the material. Effect		 * methods are those that do not influence the lighting but modulate the shaded colour, used for fog, outlines,		 * etc. The method will be applied to the result of the methods with a lower index.		 */
		public function addMethodAt(method:EffectMethodBase, index:Number):void
		{
			this._pMethodSetup.addMethodAt(method, index);
		}

		/**		 * Removes an effect method from the material.		 * @param method The method to be removed.		 */
		public function removeMethod(method:EffectMethodBase):void
		{
            this._pMethodSetup.removeMethod(method);
		}

		/**		 * @inheritDoc		 */
		override public function pUpdateLights():void
		{

			if (this._pLightPicker && !this._ignoreLights)
            {

				this._pNumPointLights = this._pLightPicker.numPointLights;
                this._pNumDirectionalLights = this._pLightPicker.numDirectionalLights;
                this._pNumLightProbes = this._pLightPicker.numLightProbes;

				if (this._includeCasters)
                {
					this._pNumPointLights += this._pLightPicker.numCastingPointLights;
					this._pNumDirectionalLights += this._pLightPicker.numCastingDirectionalLights;
				}

			}
            else
            {
				this._pNumPointLights = 0;
                this._pNumDirectionalLights = 0;
                this._pNumLightProbes = 0;
			}

            this.iInvalidateShaderProgram();//invalidateShaderProgram();
		}
		
		/**		 * @inheritDoc		 */
		override public function iActivate(stage3DProxy:Stage3DProxy, camera:Camera3D):void
		{
			super.iActivate(stage3DProxy, camera);

			if (this._pMethodSetup._iColorTransformMethod)
                this._pMethodSetup._iColorTransformMethod.iActivate(this._pMethodSetup._iColorTransformMethodVO, stage3DProxy);

			var methods:Vector.<MethodVOSet> = this._pMethodSetup._iMethods;
			var len:Number = methods.length;

			for (var i:Number = 0; i < len; ++i)
            {

				var aset:MethodVOSet = methods[i];
                aset.method.iActivate( aset.data, stage3DProxy );

			}


			if (this._pCameraPositionIndex >= 0)
            {

				var pos : Vector3D = camera.scenePosition;

				this._pVertexConstantData[this._pCameraPositionIndex] = pos.x;
                this._pVertexConstantData[this._pCameraPositionIndex + 1] = pos.y;
                this._pVertexConstantData[this._pCameraPositionIndex + 2] = pos.z;

			}
		}
		
		/**		 * @inheritDoc		 */
		override public function iDeactivate(stage3DProxy:Stage3DProxy):void
		{
			super.iDeactivate(stage3DProxy);

			if (this._pMethodSetup._iColorTransformMethod)
            {

                this._pMethodSetup._iColorTransformMethod.iDeactivate(this._pMethodSetup._iColorTransformMethodVO, stage3DProxy);

            }

			var aset:MethodVOSet;
			var methods:Vector.<MethodVOSet> =  this._pMethodSetup._iMethods;
			var len:Number = methods.length;

			for (var i:Number = 0; i < len; ++i)
            {
                aset = methods[i];
                aset.method.iDeactivate(aset.data, stage3DProxy);
			}

		}

		/**		 * @inheritDoc		 */
		override public function pAddPassesFromMethods():void
		{
			super.pAddPassesFromMethods();
			
			if (this._pMethodSetup._iColorTransformMethod)
            {

                this.pAddPasses( this._pMethodSetup._iColorTransformMethod.passes );

            }
			var methods:Vector.<MethodVOSet> = this._pMethodSetup._iMethods;

			for (var i:Number = 0; i < methods.length; ++i)
            {

                this.pAddPasses(methods[i].method.passes);

            }


		}

		/**		 * Indicates whether any light probes are used to contribute to the specular shading.		 */
		private function usesProbesForSpecular():Boolean
		{

			return this._pNumLightProbes > 0 && (this._pSpecularLightSources & LightSources.PROBES) != 0;
		}

		/**		 * Indicates whether any light probes are used to contribute to the diffuse shading.		 */
		private function usesProbesForDiffuse():Boolean
		{

			return this._pNumLightProbes > 0 && (this._pDiffuseLightSources & LightSources.PROBES) != 0;

		}

		/**		 * @inheritDoc		 */
		override public function pUpdateMethodConstants():void
		{

			super.pUpdateMethodConstants();

			if (this._pMethodSetup._iColorTransformMethod)
            {

                this._pMethodSetup._iColorTransformMethod.iInitConstants(this._pMethodSetup._iColorTransformMethodVO);

            }

			var methods:Vector.<MethodVOSet> = this._pMethodSetup._iMethods;
			var len:Number = methods.length;

			for (var i:Number = 0; i < len; ++i)
            {

                methods[i].method.iInitConstants(methods[i].data);

            }



		}

		/**		 * @inheritDoc		 */
		override public function pUpdateLightConstants():void
		{

			// first dirs, then points
			var dirLight:DirectionalLight;

			var pointLight:PointLight;

			var i:Number, k:Number;

			var len:Number;

			var dirPos:Vector3D;

			var total:Number = 0;

			var numLightTypes:Number = this._includeCasters? 2 : 1;
			
			k = this._pLightFragmentConstantIndex;
			
			for (var cast:Number = 0; cast < numLightTypes; ++cast)
            {

				var dirLights:Vector.<DirectionalLight> = cast? this._pLightPicker.castingDirectionalLights : this._pLightPicker.directionalLights;
				len = dirLights.length;
				total += len;
				
				for (i = 0; i < len; ++i)
                {

					dirLight = dirLights[i];
					dirPos = dirLight.sceneDirection;
					
					this._pAmbientLightR += dirLight._iAmbientR;
                    this._pAmbientLightG += dirLight._iAmbientG;
                    this._pAmbientLightB += dirLight._iAmbientB;

                    this._pFragmentConstantData[k++] = -dirPos.x;
                    this._pFragmentConstantData[k++] = -dirPos.y;
                    this._pFragmentConstantData[k++] = -dirPos.z;
                    this._pFragmentConstantData[k++] = 1;

                    this._pFragmentConstantData[k++] = dirLight._iDiffuseR;
                    this._pFragmentConstantData[k++] = dirLight._iDiffuseG;
                    this._pFragmentConstantData[k++] = dirLight._iDiffuseB;
                    this._pFragmentConstantData[k++] = 1;

                    this._pFragmentConstantData[k++] = dirLight._iSpecularR;
                    this._pFragmentConstantData[k++] = dirLight._iSpecularG;
                    this._pFragmentConstantData[k++] = dirLight._iSpecularB;
                    this._pFragmentConstantData[k++] = 1;
				}
			}
			
			// more directional supported than currently picked, need to clamp all to 0
			if (this._pNumDirectionalLights > total)
            {
				i = k + (this._pNumDirectionalLights - total)*12;

				while (k < i)
                {

                    this._pFragmentConstantData[k++] = 0;

                }

			}
			
			total = 0;
			for (cast = 0; cast < numLightTypes; ++cast)
            {

				var pointLights:Vector.<PointLight>= cast? this._pLightPicker.castingPointLights : this._pLightPicker.pointLights;

				len = pointLights.length;

				for (i = 0; i < len; ++i)
                {
					pointLight = pointLights[i];
					dirPos = pointLight.scenePosition;
					
					this._pAmbientLightR += pointLight._iAmbientR;
                    this._pAmbientLightG += pointLight._iAmbientG;
                    this._pAmbientLightB += pointLight._iAmbientB;

                    this._pFragmentConstantData[k++] = dirPos.x;
                    this._pFragmentConstantData[k++] = dirPos.y;
                    this._pFragmentConstantData[k++] = dirPos.z;
                    this._pFragmentConstantData[k++] = 1;

                    this._pFragmentConstantData[k++] = pointLight._iDiffuseR;
                    this._pFragmentConstantData[k++] = pointLight._iDiffuseG;
                    this._pFragmentConstantData[k++] = pointLight._iDiffuseB;
                    this._pFragmentConstantData[k++] = pointLight._pRadius*pointLight._pRadius;

                    this._pFragmentConstantData[k++] = pointLight._iSpecularR;
                    this._pFragmentConstantData[k++] = pointLight._iSpecularG;
                    this._pFragmentConstantData[k++] = pointLight._iSpecularB;
                    this._pFragmentConstantData[k++] = pointLight._pFallOffFactor;
				}
			}
			
			// more directional supported than currently picked, need to clamp all to 0
			if (this._pNumPointLights > total)
            {

				i = k + (total - this._pNumPointLights )*12;

				for (; k < i; ++k)
                {

                    this._pFragmentConstantData[k] = 0;

                }

			}

		}

		/**		 * @inheritDoc		 */
		override public function pUpdateProbes(stage3DProxy:Stage3DProxy):void
		{

			var probe:LightProbe;
			var lightProbes:Vector.<LightProbe> = this._pLightPicker.lightProbes;
			var weights:Vector.<Number> = this._pLightPicker.lightProbeWeights;
			var len:Number = lightProbes.length;
			var addDiff:Boolean = this.usesProbesForDiffuse();
			var addSpec:Boolean = ((this._pMethodSetup._iSpecularMethod && this.usesProbesForSpecular( ) ) as Boolean);
			var context:Context3D = stage3DProxy._iContext3D;
			
			if (!(addDiff || addSpec))
            {

                return;

            }

			for (var i:Number = 0; i < len; ++i)
            {

				probe = lightProbes[i];

                //away.Debug.throwPIR( 'SuperShaderPass' , 'pUpdateProbes' , 'context.setGLSLTextureAt - Parameters not matching');

				if (addDiff)
                {

                    context.setTextureAt(this._pLightProbeSpecularIndices[i], probe.diffuseMap.getTextureForStage3D(stage3DProxy));//<------ TODO: implement

                }

				if (addSpec)
                {

                    context.setTextureAt(this._pLightProbeSpecularIndices[i], probe.specularMap.getTextureForStage3D(stage3DProxy));//<------ TODO: implement

                }

			}
			
			this._pFragmentConstantData[this._pProbeWeightsIndex] = weights[0];
            this._pFragmentConstantData[this._pProbeWeightsIndex + 1] = weights[1];
            this._pFragmentConstantData[this._pProbeWeightsIndex + 2] = weights[2];
            this._pFragmentConstantData[this._pProbeWeightsIndex + 3] = weights[3];

		}

		/**		 * Indicates whether lights should be ignored in this pass. This is used when only effect methods are rendered in		 * a multipass material.		 */
		public function set iIgnoreLights(ignoreLights:Boolean):void
		{
			this._ignoreLights = ignoreLights;
		}
		
		public function get iIgnoreLights():Boolean
		{
			return this._ignoreLights;
		}
	}
}
