///<reference path="../../_definitions.ts"/>
package away.materials.passes
{
	import away.materials.MaterialBase;
	import away.materials.compilation.ShaderCompiler;
	import away.materials.compilation.LightingShaderCompiler;
	import away.materials.LightSources;
	import away.base.IRenderable;
	import away.managers.Stage3DProxy;
	import away.cameras.Camera3D;
	import away.geom.Matrix3D;
	import away.geom.Vector3D;
	import away.lights.DirectionalLight;
	import away.lights.PointLight;
	import away.display3D.Context3D;
	import away.lights.LightProbe;
	//import away3d.arcane;
	//import away3d.cameras.Camera3D;
	//import away3d.core.base.IRenderable;
	//import away3d.managers.Stage3DProxy;
	//import away3d.lights.DirectionalLight;
	//import away3d.lights.LightProbe;
	//import away3d.lights.PointLight;
	//import away3d.materials.LightSources;
	//import away3d.materials.MaterialBase;
	//import away3d.materials.compilation.LightingShaderCompiler;
	//import away3d.materials.compilation.ShaderCompiler;
	
	//import flash.display3D.Context3D;
	//import flash.geom.Matrix3D;
	//import flash.geom.Vector3D;
	
	//use namespace arcane;
	
	/**
	 * LightingPass is a shader pass that uses shader methods to compile a complete program. It only includes the lighting
	 * methods. It's used by multipass materials to accumulate lighting passes.
	 *
	 * @see away3d.materials.MultiPassMaterialBase
	 */
	
	public class LightingPass extends CompiledPass
	{
		private var _includeCasters:Boolean = true;
		private var _tangentSpace:Boolean;
		private var _lightVertexConstantIndex:Number;
		private var _inverseSceneMatrix:Vector.<Number> = new Vector.<Number>();
		
		private var _directionalLightsOffset:Number;
		private var _pointLightsOffset:Number;
		private var _lightProbesOffset:Number;
		private var _maxLights:Number = 3;
		
		/**
		 * Creates a new LightingPass objects.
		 *
		 * @param material The material to which this pass belongs.
		 */
		public function LightingPass(material:MaterialBase):void
		{
			super(material);
		}

		/**
		 * Indicates the offset in the light picker's directional light vector for which to start including lights.
		 * This needs to be set before the light picker is assigned.
		 */
		public function get directionalLightsOffset():Number
		{
			return _directionalLightsOffset;
		}
		
		public function set directionalLightsOffset(value:Number):void
		{
			_directionalLightsOffset = value;
		}

		/**
		 * Indicates the offset in the light picker's point light vector for which to start including lights.
		 * This needs to be set before the light picker is assigned.
		 */
		public function get pointLightsOffset():Number
		{
			return _pointLightsOffset;
		}
		
		public function set pointLightsOffset(value:Number):void
		{
            _pointLightsOffset = value;
		}

		/**
		 * Indicates the offset in the light picker's light probes vector for which to start including lights.
		 * This needs to be set before the light picker is assigned.
		 */
		public function get lightProbesOffset():Number
		{
			return _lightProbesOffset;
		}
		
		public function set lightProbesOffset(value:Number):void
		{
            _lightProbesOffset = value;
		}

		/**
		 * @inheritDoc
		 */
		override public function pCreateCompiler(profile:String):ShaderCompiler
		{
			_maxLights = profile == "baselineConstrained"? 1 : 3;
			return new LightingShaderCompiler(profile);
		}

		/**
		 * Indicates whether or not shadow casting lights need to be included.
		 */
		public function get includeCasters():Boolean
		{
			return _includeCasters;
		}
		
		public function set includeCasters(value:Boolean):void
		{
			if (_includeCasters == value)
				return;
            _includeCasters = value;
            iInvalidateShaderProgram();
		}

		/**
		 * @inheritDoc
		 */
		override public function pUpdateLights():void
		{
			super.pUpdateLights();
			var numDirectionalLights:Number;
			var numPointLights:Number = 0;
			var numLightProbes:Number = 0;
			
			if (_pLightPicker)
            {
				numDirectionalLights = calculateNumDirectionalLights(_pLightPicker.numDirectionalLights);
				numPointLights = calculateNumPointLights(_pLightPicker.numPointLights);
				numLightProbes = calculateNumProbes(_pLightPicker.numLightProbes);
				
				if (_includeCasters)
                {
					numPointLights += _pLightPicker.numCastingPointLights;
					numDirectionalLights += _pLightPicker.numCastingDirectionalLights;
				}

			}
            else
            {
				numDirectionalLights = 0;
				numPointLights = 0;
				numLightProbes = 0;
			}
			
			
			if (numPointLights != _pNumPointLights ||
				numDirectionalLights != _pNumDirectionalLights ||
				numLightProbes != _pNumLightProbes) {
                _pNumPointLights = numPointLights;
                _pNumDirectionalLights = numDirectionalLights;
                _pNumLightProbes = numLightProbes;
                iInvalidateShaderProgram();
			}
		
		}

		/**
		 * Calculates the amount of directional lights this material will support.
		 * @param numDirectionalLights The maximum amount of directional lights to support.
		 * @return The amount of directional lights this material will support, bounded by the amount necessary.
		 */
		private function calculateNumDirectionalLights(numDirectionalLights:Number):Number
		{
			return Math.min(numDirectionalLights - _directionalLightsOffset, _maxLights);
		}

		/**
		 * Calculates the amount of point lights this material will support.
		 * @param numDirectionalLights The maximum amount of point lights to support.
		 * @return The amount of point lights this material will support, bounded by the amount necessary.
		 */
		private function calculateNumPointLights(numPointLights:Number):Number
		{
			var numFree:Number = _maxLights - _pNumDirectionalLights;
			return Math.min(numPointLights - _pointLightsOffset, numFree);
		}

		/**
		 * Calculates the amount of light probes this material will support.
		 * @param numDirectionalLights The maximum amount of light probes to support.
		 * @return The amount of light probes this material will support, bounded by the amount necessary.
		 */
		private function calculateNumProbes(numLightProbes:Number):Number
		{
			var numChannels:Number = 0;
			if ((_pSpecularLightSources & LightSources.PROBES) != 0)
            {
				++numChannels;
            }
			if ((_pDiffuseLightSources & LightSources.PROBES) != 0)
				++numChannels;


			// 4 channels available
			return Math.min(numLightProbes - _lightProbesOffset, (4/numChannels) | 0);
		}

		/**
		 * @inheritDoc
		 */
		override public function pUpdateShaderProperties():void
		{
			super.pUpdateShaderProperties();

            var compilerV : LightingShaderCompiler = (_pCompiler as LightingShaderCompiler);
            _tangentSpace = compilerV.tangentSpace;

		}

		/**
		 * @inheritDoc
		 */
		override public function pUpdateRegisterIndices():void
		{
			super.pUpdateRegisterIndices();

            var compilerV : LightingShaderCompiler = (_pCompiler as LightingShaderCompiler);
			_lightVertexConstantIndex = compilerV.lightVertexConstantIndex;

		}

		/**
		 * @inheritDoc
		 */
		override public function iRender(renderable:IRenderable, stage3DProxy:Stage3DProxy, camera:Camera3D, viewProjection:Matrix3D):void
		{
			renderable.inverseSceneTransform.copyRawDataTo(_inverseSceneMatrix);
			
			if (_tangentSpace && _pCameraPositionIndex >= 0)
            {
				var pos:Vector3D = camera.scenePosition;
				var x:Number = pos.x;
				var y:Number = pos.y;
				var z:Number = pos.z;

				_pVertexConstantData[_pCameraPositionIndex] = _inverseSceneMatrix[0]*x + _inverseSceneMatrix[4]*y + _inverseSceneMatrix[8]*z + _inverseSceneMatrix[12];
                _pVertexConstantData[_pCameraPositionIndex + 1] = _inverseSceneMatrix[1]*x + _inverseSceneMatrix[5]*y + _inverseSceneMatrix[9]*z + _inverseSceneMatrix[13];
                _pVertexConstantData[_pCameraPositionIndex + 2] = _inverseSceneMatrix[2]*x + _inverseSceneMatrix[6]*y + _inverseSceneMatrix[10]*z + _inverseSceneMatrix[14];
			}
			
			super.iRender(renderable, stage3DProxy, camera, viewProjection);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function iActivate(stage3DProxy:Stage3DProxy, camera:Camera3D):void
		{
			super.iActivate(stage3DProxy, camera);
			
			if (!_tangentSpace && _pCameraPositionIndex >= 0)
            {
				var pos:Vector3D = camera.scenePosition;

				_pVertexConstantData[_pCameraPositionIndex] = pos.x;
                _pVertexConstantData[_pCameraPositionIndex + 1] = pos.y;
                _pVertexConstantData[_pCameraPositionIndex + 2] = pos.z;
			}
		}

		/**
		 * Indicates whether any light probes are used to contribute to the specular shading.
		 */
		private function usesProbesForSpecular():Boolean
		{
			return _pNumLightProbes > 0 && (_pSpecularLightSources & LightSources.PROBES) != 0;
		}

		/**
		 * Indicates whether any light probes are used to contribute to the diffuse shading.
		 */
		private function usesProbesForDiffuse():Boolean
		{
			return _pNumLightProbes > 0 && (_pDiffuseLightSources & LightSources.PROBES) != 0;
		}

		/**
		 * @inheritDoc
		 */
		override public function pUpdateLightConstants():void
		{
			var dirLight:DirectionalLight;
			var pointLight:PointLight;
			var i:Number = 0;
            var k:Number = 0;
			var len:Number;
			var dirPos:Vector3D;
			var total:Number = 0;
			var numLightTypes:Number = _includeCasters? 2 : 1;
			var l:Number;
			var offset:Number;
			
			l = _lightVertexConstantIndex;
			k = _pLightFragmentConstantIndex;
			
			var cast:Number = 0;
			var dirLights:Vector.<DirectionalLight> = _pLightPicker.directionalLights;
			offset = _directionalLightsOffset;
			len = _pLightPicker.directionalLights.length;

			if (offset > len)
            {
				cast = 1;
				offset -= len;
			}
			
			for (; cast < numLightTypes; ++cast)
            {
				if (cast)
					dirLights = _pLightPicker.castingDirectionalLights;
				len = dirLights.length;
				if (len > _pNumDirectionalLights)
					len = _pNumDirectionalLights;

				for (i = 0; i < len; ++i)
                {
					dirLight = dirLights[offset + i];
					dirPos = dirLight.sceneDirection;
					
					_pAmbientLightR += dirLight._iAmbientR;
                    _pAmbientLightG += dirLight._iAmbientG;
                    _pAmbientLightB += dirLight._iAmbientB;
					
					if (_tangentSpace)
                    {
						var x:Number = -dirPos.x;
						var y:Number = -dirPos.y;
						var z:Number = -dirPos.z;

						_pVertexConstantData[l++] = _inverseSceneMatrix[0]*x + _inverseSceneMatrix[4]*y + _inverseSceneMatrix[8]*z;
                        _pVertexConstantData[l++] = _inverseSceneMatrix[1]*x + _inverseSceneMatrix[5]*y + _inverseSceneMatrix[9]*z;
                        _pVertexConstantData[l++] = _inverseSceneMatrix[2]*x + _inverseSceneMatrix[6]*y + _inverseSceneMatrix[10]*z;
                        _pVertexConstantData[l++] = 1;
					}
                    else
                    {
						_pFragmentConstantData[k++] = -dirPos.x;
                        _pFragmentConstantData[k++] = -dirPos.y;
                        _pFragmentConstantData[k++] = -dirPos.z;
                        _pFragmentConstantData[k++] = 1;
					}
					
					_pFragmentConstantData[k++] = dirLight._iDiffuseR;
                    _pFragmentConstantData[k++] = dirLight._iDiffuseG;
                    _pFragmentConstantData[k++] = dirLight._iDiffuseB;
                    _pFragmentConstantData[k++] = 1;

                    _pFragmentConstantData[k++] = dirLight._iSpecularR;
                    _pFragmentConstantData[k++] = dirLight._iSpecularG;
                    _pFragmentConstantData[k++] = dirLight._iSpecularB;
                    _pFragmentConstantData[k++] = 1;
					
					if (++total == _pNumDirectionalLights) {
						// break loop
						i = len;
						cast = numLightTypes;
					}
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
			
			var pointLights:Vector.<PointLight> = _pLightPicker.pointLights;
			offset = _pointLightsOffset;
			len = _pLightPicker.pointLights.length;

			if (offset > len)
            {
				cast = 1;
				offset -= len;
			}
            else
            {
				cast = 0;
            }

			for (; cast < numLightTypes; ++cast)
            {
				if (cast)
                {
					pointLights = _pLightPicker.castingPointLights;
                }

				len = pointLights.length;

				for (i = 0; i < len; ++i)
                {
					pointLight = pointLights[offset + i];
					dirPos = pointLight.scenePosition;
					
					_pAmbientLightR += pointLight._iAmbientR;
                    _pAmbientLightG += pointLight._iAmbientG;
                    _pAmbientLightB += pointLight._iAmbientB;
					
					if (_tangentSpace)
                    {
						x = dirPos.x;
						y = dirPos.y;
						z = dirPos.z;

						_pVertexConstantData[l++] = _inverseSceneMatrix[0]*x + _inverseSceneMatrix[4]*y + _inverseSceneMatrix[8]*z + _inverseSceneMatrix[12];
                        _pVertexConstantData[l++] = _inverseSceneMatrix[1]*x + _inverseSceneMatrix[5]*y + _inverseSceneMatrix[9]*z + _inverseSceneMatrix[13];
                        _pVertexConstantData[l++] = _inverseSceneMatrix[2]*x + _inverseSceneMatrix[6]*y + _inverseSceneMatrix[10]*z + _inverseSceneMatrix[14];
					}
                    else
                    {

						_pVertexConstantData[l++] = dirPos.x;
						_pVertexConstantData[l++] = dirPos.y;
						_pVertexConstantData[l++] = dirPos.z;

					}
					_pVertexConstantData[l++] = 1;
					
					_pFragmentConstantData[k++] = pointLight._iDiffuseR;
                    _pFragmentConstantData[k++] = pointLight._iDiffuseG;
                    _pFragmentConstantData[k++] = pointLight._iDiffuseB;

					var radius:Number = pointLight._pRadius;
					_pFragmentConstantData[k++] = radius*radius;

                    _pFragmentConstantData[k++] = pointLight._iSpecularR;
                    _pFragmentConstantData[k++] = pointLight._iSpecularG;
                    _pFragmentConstantData[k++] = pointLight._iSpecularB;
                    _pFragmentConstantData[k++] = pointLight._pFallOffFactor;
					
					if (++total == _pNumPointLights)
                    {
						// break loop
						i = len;
						cast = numLightTypes;
					}
				}
			}
			
			// more directional supported than currently picked, need to clamp all to 0
			if (_pNumPointLights > total)
            {
				i = k + (total - _pNumPointLights)*12;
				for (; k < i; ++k)
                {
					_pFragmentConstantData[k] = 0;

                }
			}
		}

		/**
		 * @inheritDoc
		 */
		override public function pUpdateProbes(stage3DProxy:Stage3DProxy):void
		{
			var context:Context3D = stage3DProxy._iContext3D;
			var probe:LightProbe;
			var lightProbes:Vector.<LightProbe> = _pLightPicker.lightProbes;
			var weights:Vector.<Number> = _pLightPicker.lightProbeWeights;
			var len:Number = lightProbes.length - _lightProbesOffset;
			var addDiff:Boolean = usesProbesForDiffuse();
			var addSpec:Boolean = ((_pMethodSetup._iSpecularMethod && usesProbesForSpecular()) as Boolean);
			
			if (!(addDiff || addSpec))
				return;
			
			if (len > _pNumLightProbes)
            {
				len = _pNumLightProbes;
            }

			for (var i:Number = 0; i < len; ++i)
            {
				probe = lightProbes[ _lightProbesOffset + i];
				
				if (addDiff)
                {
					context.setTextureAt(_pLightProbeDiffuseIndices[i], probe.diffuseMap.getTextureForStage3D(stage3DProxy));
                }
				if (addSpec)
                {
					context.setTextureAt(_pLightProbeSpecularIndices[i], probe.specularMap.getTextureForStage3D(stage3DProxy));
                }
			}
			
			for (i = 0; i < len; ++i)
				_pFragmentConstantData[_pProbeWeightsIndex + i] = weights[_lightProbesOffset + i];
		}
	}
}
