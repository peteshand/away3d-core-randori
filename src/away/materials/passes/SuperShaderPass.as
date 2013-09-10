///<reference path="../../_definitions.ts"/>

package away.materials.passes
{
	import away.materials.MaterialBase;
	import away.materials.compilation.ShaderCompiler;
	import away.materials.compilation.SuperShaderCompiler;
	import away.geom.ColorTransform;
	import away.materials.methods.ColorTransformMethod;
	import away.materials.methods.EffectMethodBase;
	import away.managers.Stage3DProxy;
	import away.cameras.Camera3D;
	import away.materials.methods.MethodVOSet;
	import away.geom.Vector3D;
	import away.materials.LightSources;
	import away.lights.DirectionalLight;
	import away.lights.PointLight;
	import away.lights.LightProbe;
	import away.display3D.Context3D;

	/**	 * SuperShaderPass is a shader pass that uses shader methods to compile a complete program. It includes all methods	 * associated with a material.	 *	 * @see away3d.materials.methods.ShadingMethodBase	 */
	public class SuperShaderPass extends CompiledPass
	{
		private var _includeCasters:Boolean = true;
		private var _ignoreLights:Boolean;
		
		/**		 * Creates a new SuperShaderPass objects.		 *		 * @param material The material to which this material belongs.		 */
		public function SuperShaderPass(material:MaterialBase):void
		{
			super(material);
			_pNeedFragmentAnimation = true;
		}

		/**		 * @inheritDoc		 */
		override public function pCreateCompiler(profile:String):ShaderCompiler
		{
			return new SuperShaderCompiler(profile);
		}

		/**		 * Indicates whether lights that cast shadows should be included in the pass.		 */
		public function get includeCasters():Boolean
		{
			return _includeCasters;
		}
		
		public function set includeCasters(value:Boolean):void
		{
			if (_includeCasters == value)
				return;
            _includeCasters = value;
            iInvalidateShaderProgram();//invalidateShaderProgram();
		}

		/**		 * The ColorTransform object to transform the colour of the material with. Defaults to null.		 */
		public function get colorTransform():ColorTransform
		{


            return _pMethodSetup._iColorTransformMethod ? _pMethodSetup._iColorTransformMethod.colorTransform : null;
		}

		public function set colorTransform(value:ColorTransform):void
		{
			if (value)
            {

                //colorTransformMethod ||= new away.geom.ColorTransform();
                if ( colorTransformMethod == null )
                {


                    colorTransformMethod = new ColorTransformMethod();

                }

				_pMethodSetup._iColorTransformMethod.colorTransform = value;

			}
            else if (!value)
            {

				if (_pMethodSetup._iColorTransformMethod)
                {

                    colorTransformMethod = null;

                }

				colorTransformMethod = _pMethodSetup._iColorTransformMethod = null;
			}
		}

		/**		 * The ColorTransformMethod object to transform the colour of the material with. Defaults to null.		 */
		public function get colorTransformMethod():ColorTransformMethod
		{

			return _pMethodSetup._iColorTransformMethod;
		}
		
		public function set colorTransformMethod(value:ColorTransformMethod):void
		{
			_pMethodSetup.iColorTransformMethod = value;
		}

		/**		 * Appends an "effect" shading method to the shader. Effect methods are those that do not influence the lighting		 * but modulate the shaded colour, used for fog, outlines, etc. The method will be applied to the result of the		 * methods added prior.		 */
		public function addMethod(method:EffectMethodBase):void
		{
			_pMethodSetup.addMethod(method);
		}

		/**		 * The number of "effect" methods added to the material.		 */
		public function get numMethods():Number
		{
			return _pMethodSetup.numMethods;
		}

		/**		 * Queries whether a given effect method was added to the material.		 *		 * @param method The method to be queried.		 * @return true if the method was added to the material, false otherwise.		 */
		public function hasMethod(method:EffectMethodBase):Boolean
		{
			return _pMethodSetup.hasMethod(method);
		}

		/**		 * Returns the method added at the given index.		 * @param index The index of the method to retrieve.		 * @return The method at the given index.		 */
		public function getMethodAt(index:Number):EffectMethodBase
		{
			return _pMethodSetup.getMethodAt(index);
		}

		/**		 * Adds an effect method at the specified index amongst the methods already added to the material. Effect		 * methods are those that do not influence the lighting but modulate the shaded colour, used for fog, outlines,		 * etc. The method will be applied to the result of the methods with a lower index.		 */
		public function addMethodAt(method:EffectMethodBase, index:Number):void
		{
			_pMethodSetup.addMethodAt(method, index);
		}

		/**		 * Removes an effect method from the material.		 * @param method The method to be removed.		 */
		public function removeMethod(method:EffectMethodBase):void
		{
            _pMethodSetup.removeMethod(method);
		}

		/**		 * @inheritDoc		 */
		override public function pUpdateLights():void
		{

			if (_pLightPicker && !_ignoreLights)
            {

				_pNumPointLights = _pLightPicker.numPointLights;
                _pNumDirectionalLights = _pLightPicker.numDirectionalLights;
                _pNumLightProbes = _pLightPicker.numLightProbes;

				if (_includeCasters)
                {
					_pNumPointLights += _pLightPicker.numCastingPointLights;
					_pNumDirectionalLights += _pLightPicker.numCastingDirectionalLights;
				}

			}
            else
            {
				_pNumPointLights = 0;
                _pNumDirectionalLights = 0;
                _pNumLightProbes = 0;
			}

            iInvalidateShaderProgram();//invalidateShaderProgram();
		}
		
		/**		 * @inheritDoc		 */
		override public function iActivate(stage3DProxy:Stage3DProxy, camera:Camera3D):void
		{
			super.iActivate(stage3DProxy, camera);

			if (_pMethodSetup._iColorTransformMethod)
                _pMethodSetup._iColorTransformMethod.iActivate(_pMethodSetup._iColorTransformMethodVO, stage3DProxy);

			var methods:Vector.<MethodVOSet> = _pMethodSetup._iMethods;
			var len:Number = methods.length;

			for (var i:Number = 0; i < len; ++i)
            {

				var aset:MethodVOSet = methods[i];
                aset.method.iActivate( aset.data, stage3DProxy );

			}


			if (_pCameraPositionIndex >= 0)
            {

				var pos : Vector3D = camera.scenePosition;

				_pVertexConstantData[_pCameraPositionIndex] = pos.x;
                _pVertexConstantData[_pCameraPositionIndex + 1] = pos.y;
                _pVertexConstantData[_pCameraPositionIndex + 2] = pos.z;

			}
		}
		
		/**		 * @inheritDoc		 */
		override public function iDeactivate(stage3DProxy:Stage3DProxy):void
		{
			super.iDeactivate(stage3DProxy);

			if (_pMethodSetup._iColorTransformMethod)
            {

                _pMethodSetup._iColorTransformMethod.iDeactivate(_pMethodSetup._iColorTransformMethodVO, stage3DProxy);

            }

			var aset:MethodVOSet;
			var methods:Vector.<MethodVOSet> =  _pMethodSetup._iMethods;
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
			
			if (_pMethodSetup._iColorTransformMethod)
            {

                pAddPasses( _pMethodSetup._iColorTransformMethod.passes );

            }
			var methods:Vector.<MethodVOSet> = _pMethodSetup._iMethods;

			for (var i:Number = 0; i < methods.length; ++i)
            {

                pAddPasses(methods[i].method.passes);

            }


		}

		/**		 * Indicates whether any light probes are used to contribute to the specular shading.		 */
		private function usesProbesForSpecular():Boolean
		{

			return _pNumLightProbes > 0 && (_pSpecularLightSources & LightSources.PROBES) != 0;
		}

		/**		 * Indicates whether any light probes are used to contribute to the diffuse shading.		 */
		private function usesProbesForDiffuse():Boolean
		{

			return _pNumLightProbes > 0 && (_pDiffuseLightSources & LightSources.PROBES) != 0;

		}

		/**		 * @inheritDoc		 */
		override public function pUpdateMethodConstants():void
		{

			super.pUpdateMethodConstants();

			if (_pMethodSetup._iColorTransformMethod)
            {

                _pMethodSetup._iColorTransformMethod.iInitConstants(_pMethodSetup._iColorTransformMethodVO);

            }

			var methods:Vector.<MethodVOSet> = _pMethodSetup._iMethods;
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

			var numLightTypes:Number = _includeCasters? 2 : 1;
			
			k = _pLightFragmentConstantIndex;
			
			for (var cast:Number = 0; cast < numLightTypes; ++cast)
            {

				var dirLights:Vector.<DirectionalLight> = cast? _pLightPicker.castingDirectionalLights : _pLightPicker.directionalLights;
				len = dirLights.length;
				total += len;
				
				for (i = 0; i < len; ++i)
                {

					dirLight = dirLights[i];
					dirPos = dirLight.sceneDirection;
					
					_pAmbientLightR += dirLight._iAmbientR;
                    _pAmbientLightG += dirLight._iAmbientG;
                    _pAmbientLightB += dirLight._iAmbientB;

                    _pFragmentConstantData[k++] = -dirPos.x;
                    _pFragmentConstantData[k++] = -dirPos.y;
                    _pFragmentConstantData[k++] = -dirPos.z;
                    _pFragmentConstantData[k++] = 1;

                    _pFragmentConstantData[k++] = dirLight._iDiffuseR;
                    _pFragmentConstantData[k++] = dirLight._iDiffuseG;
                    _pFragmentConstantData[k++] = dirLight._iDiffuseB;
                    _pFragmentConstantData[k++] = 1;

                    _pFragmentConstantData[k++] = dirLight._iSpecularR;
                    _pFragmentConstantData[k++] = dirLight._iSpecularG;
                    _pFragmentConstantData[k++] = dirLight._iSpecularB;
                    _pFragmentConstantData[k++] = 1;
				}
			}
			
			// more directional supported than currently picked, need to clamp all to 0
			if (_pNumDirectionalLights > total)
            {
				i = k + (_pNumDirectionalLights - total)*12;

				while (k < i)
                {

                    _pFragmentConstantData[k++] = 0;

                }

			}
			
			total = 0;
			for (cast = 0; cast < numLightTypes; ++cast)
            {

				var pointLights:Vector.<PointLight>= cast? _pLightPicker.castingPointLights : _pLightPicker.pointLights;

				len = pointLights.length;

				for (i = 0; i < len; ++i)
                {
					pointLight = pointLights[i];
					dirPos = pointLight.scenePosition;
					
					_pAmbientLightR += pointLight._iAmbientR;
                    _pAmbientLightG += pointLight._iAmbientG;
                    _pAmbientLightB += pointLight._iAmbientB;

                    _pFragmentConstantData[k++] = dirPos.x;
                    _pFragmentConstantData[k++] = dirPos.y;
                    _pFragmentConstantData[k++] = dirPos.z;
                    _pFragmentConstantData[k++] = 1;

                    _pFragmentConstantData[k++] = pointLight._iDiffuseR;
                    _pFragmentConstantData[k++] = pointLight._iDiffuseG;
                    _pFragmentConstantData[k++] = pointLight._iDiffuseB;
                    _pFragmentConstantData[k++] = pointLight._pRadius*pointLight._pRadius;

                    _pFragmentConstantData[k++] = pointLight._iSpecularR;
                    _pFragmentConstantData[k++] = pointLight._iSpecularG;
                    _pFragmentConstantData[k++] = pointLight._iSpecularB;
                    _pFragmentConstantData[k++] = pointLight._pFallOffFactor;
				}
			}
			
			// more directional supported than currently picked, need to clamp all to 0
			if (_pNumPointLights > total)
            {

				i = k + (total - _pNumPointLights )*12;

				for (; k < i; ++k)
                {

                    _pFragmentConstantData[k] = 0;

                }

			}

		}

		/**		 * @inheritDoc		 */
		override public function pUpdateProbes(stage3DProxy:Stage3DProxy):void
		{

			var probe:LightProbe;
			var lightProbes:Vector.<LightProbe> = _pLightPicker.lightProbes;
			var weights:Vector.<Number> = _pLightPicker.lightProbeWeights;
			var len:Number = lightProbes.length;
			var addDiff:Boolean = usesProbesForDiffuse();
			var addSpec:Boolean = ((_pMethodSetup._iSpecularMethod && usesProbesForSpecular()) as Boolean);
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

                    context.setTextureAt(_pLightProbeSpecularIndices[i], probe.diffuseMap.getTextureForStage3D(stage3DProxy));//<------ TODO: implement

                }

				if (addSpec)
                {

                    context.setTextureAt(_pLightProbeSpecularIndices[i], probe.specularMap.getTextureForStage3D(stage3DProxy));//<------ TODO: implement

                }

			}
			
			_pFragmentConstantData[_pProbeWeightsIndex] = weights[0];
            _pFragmentConstantData[_pProbeWeightsIndex + 1] = weights[1];
            _pFragmentConstantData[_pProbeWeightsIndex + 2] = weights[2];
            _pFragmentConstantData[_pProbeWeightsIndex + 3] = weights[3];

		}

		/**		 * Indicates whether lights should be ignored in this pass. This is used when only effect methods are rendered in		 * a multipass material.		 */
		public function set iIgnoreLights(ignoreLights:Boolean):void
		{
			_ignoreLights = ignoreLights;
		}
		
		public function get iIgnoreLights():Boolean
		{
			return _ignoreLights;
		}
	}
}
