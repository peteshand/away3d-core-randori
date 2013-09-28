/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package away.materials.passes
{
	import away.utils.VectorInit;
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
	
	/**	 * LightingPass is a shader pass that uses shader methods to compile a complete program. It only includes the lighting	 * methods. It's used by multipass materials to accumulate lighting passes.	 *	 * @see away3d.materials.MultiPassMaterialBase	 */
	
	public class LightingPass extends CompiledPass
	{
		private var _includeCasters:Boolean = true;
		private var _tangentSpace:Boolean = false;
		private var _lightVertexConstantIndex:Number = 0;
		private var _inverseSceneMatrix:Vector.<Number> = VectorInit.Num();
		
		private var _directionalLightsOffset:Number = 0;
		private var _pointLightsOffset:Number = 0;
		private var _lightProbesOffset:Number = 0;
		private var _maxLights:Number = 3;
		
		/**		 * Creates a new LightingPass objects.		 *		 * @param material The material to which this pass belongs.		 */
		public function LightingPass(material:MaterialBase):void
		{
			super(material);
		}

		/**		 * Indicates the offset in the light picker's directional light vector for which to start including lights.		 * This needs to be set before the light picker is assigned.		 */
		public function get directionalLightsOffset():Number
		{
			return this._directionalLightsOffset;
		}
		
		public function set directionalLightsOffset(value:Number):void
		{
			this._directionalLightsOffset = value;
		}

		/**		 * Indicates the offset in the light picker's point light vector for which to start including lights.		 * This needs to be set before the light picker is assigned.		 */
		public function get pointLightsOffset():Number
		{
			return this._pointLightsOffset;
		}
		
		public function set pointLightsOffset(value:Number):void
		{
            this._pointLightsOffset = value;
		}

		/**		 * Indicates the offset in the light picker's light probes vector for which to start including lights.		 * This needs to be set before the light picker is assigned.		 */
		public function get lightProbesOffset():Number
		{
			return this._lightProbesOffset;
		}
		
		public function set lightProbesOffset(value:Number):void
		{
            this._lightProbesOffset = value;
		}

		/**		 * @inheritDoc		 */
		override public function pCreateCompiler(profile:String):ShaderCompiler
		{
			this._maxLights = profile == "baselineConstrained"? 1 : 3;
			return new LightingShaderCompiler(profile);
		}

		/**		 * Indicates whether or not shadow casting lights need to be included.		 */
		public function get includeCasters():Boolean
		{
			return this._includeCasters;
		}
		
		public function set includeCasters(value:Boolean):void
		{
			if (this._includeCasters == value)
				return;
            this._includeCasters = value;
            this.iInvalidateShaderProgram();
		}

		/**		 * @inheritDoc		 */
		override public function pUpdateLights():void
		{
			super.pUpdateLights();
			var numDirectionalLights:Number;
			var numPointLights:Number = 0;
			var numLightProbes:Number = 0;
			
			if (this._pLightPicker)
            {
				numDirectionalLights = this.calculateNumDirectionalLights(this._pLightPicker.numDirectionalLights);
				numPointLights = this.calculateNumPointLights(this._pLightPicker.numPointLights);
				numLightProbes = this.calculateNumProbes(this._pLightPicker.numLightProbes);
				
				if (this._includeCasters)
                {
					numPointLights += this._pLightPicker.numCastingPointLights;
					numDirectionalLights += this._pLightPicker.numCastingDirectionalLights;
				}

			}
            else
            {
				numDirectionalLights = 0;
				numPointLights = 0;
				numLightProbes = 0;
			}
			
			
			if (numPointLights != this._pNumPointLights ||
				numDirectionalLights != this._pNumDirectionalLights ||
				numLightProbes != this._pNumLightProbes) {
                this._pNumPointLights = numPointLights;
                this._pNumDirectionalLights = numDirectionalLights;
                this._pNumLightProbes = numLightProbes;
                this.iInvalidateShaderProgram();
			}
		
		}

		/**		 * Calculates the amount of directional lights this material will support.		 * @param numDirectionalLights The maximum amount of directional lights to support.		 * @return The amount of directional lights this material will support, bounded by the amount necessary.		 */
		private function calculateNumDirectionalLights(numDirectionalLights:Number):Number
		{
			return Math.min(numDirectionalLights - this._directionalLightsOffset, this._maxLights);
		}

		/**		 * Calculates the amount of point lights this material will support.		 * @param numDirectionalLights The maximum amount of point lights to support.		 * @return The amount of point lights this material will support, bounded by the amount necessary.		 */
		private function calculateNumPointLights(numPointLights:Number):Number
		{
			var numFree:Number = this._maxLights - this._pNumDirectionalLights;
			return Math.min(numPointLights - this._pointLightsOffset, numFree);
		}

		/**		 * Calculates the amount of light probes this material will support.		 * @param numDirectionalLights The maximum amount of light probes to support.		 * @return The amount of light probes this material will support, bounded by the amount necessary.		 */
		private function calculateNumProbes(numLightProbes:Number):Number
		{
			var numChannels:Number = 0;
			if ((this._pSpecularLightSources & LightSources.PROBES) != 0)
            {
				++numChannels;
            }
			if ((this._pDiffuseLightSources & LightSources.PROBES) != 0)
				++numChannels;


			// 4 channels available
			return Math.min(numLightProbes - this._lightProbesOffset, (4/numChannels) | 0);
		}

		/**		 * @inheritDoc		 */
		override public function pUpdateShaderProperties():void
		{
			super.pUpdateShaderProperties();

            var compilerV : LightingShaderCompiler = (this._pCompiler as LightingShaderCompiler);
            this._tangentSpace = compilerV.tangentSpace;

		}

		/**		 * @inheritDoc		 */
		override public function pUpdateRegisterIndices():void
		{
			super.pUpdateRegisterIndices();

            var compilerV : LightingShaderCompiler = (this._pCompiler as LightingShaderCompiler);
			this._lightVertexConstantIndex = compilerV.lightVertexConstantIndex;

		}

		/**		 * @inheritDoc		 */
		override public function iRender(renderable:IRenderable, stage3DProxy:Stage3DProxy, camera:Camera3D, viewProjection:Matrix3D):void
		{
			renderable.inverseSceneTransform.copyRawDataTo(this._inverseSceneMatrix);
			
			if (this._tangentSpace && this._pCameraPositionIndex >= 0)
            {
				var pos:Vector3D = camera.scenePosition;
				var x:Number = pos.x;
				var y:Number = pos.y;
				var z:Number = pos.z;

				this._pVertexConstantData[this._pCameraPositionIndex] = this._inverseSceneMatrix[0]*x + this._inverseSceneMatrix[4]*y + this._inverseSceneMatrix[8]*z + this._inverseSceneMatrix[12];
                this._pVertexConstantData[this._pCameraPositionIndex + 1] = this._inverseSceneMatrix[1]*x + this._inverseSceneMatrix[5]*y + this._inverseSceneMatrix[9]*z + this._inverseSceneMatrix[13];
                this._pVertexConstantData[this._pCameraPositionIndex + 2] = this._inverseSceneMatrix[2]*x + this._inverseSceneMatrix[6]*y + this._inverseSceneMatrix[10]*z + this._inverseSceneMatrix[14];
			}
			
			super.iRender(renderable, stage3DProxy, camera, viewProjection);
		}
		
		/**		 * @inheritDoc		 */
		override public function iActivate(stage3DProxy:Stage3DProxy, camera:Camera3D):void
		{
			super.iActivate(stage3DProxy, camera);
			
			if (!this._tangentSpace && this._pCameraPositionIndex >= 0)
            {
				var pos:Vector3D = camera.scenePosition;

				this._pVertexConstantData[this._pCameraPositionIndex] = pos.x;
                this._pVertexConstantData[this._pCameraPositionIndex + 1] = pos.y;
                this._pVertexConstantData[this._pCameraPositionIndex + 2] = pos.z;
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
		override public function pUpdateLightConstants():void
		{
			var dirLight:DirectionalLight;
			var pointLight:PointLight;
			var i:Number = 0;
            var k:Number = 0;
			var len:Number;
			var dirPos:Vector3D;
			var total:Number = 0;
			var numLightTypes:Number = this._includeCasters? 2 : 1;
			var l:Number;
			var offset:Number;
			
			l = this._lightVertexConstantIndex;
			k = this._pLightFragmentConstantIndex;
			
			var cast:Number = 0;
			var dirLights:Vector.<DirectionalLight> = this._pLightPicker.directionalLights;
			offset = this._directionalLightsOffset;
			len = this._pLightPicker.directionalLights.length;

			if (offset > len)
            {
				cast = 1;
				offset -= len;
			}
			
			for (; cast < numLightTypes; ++cast)
            {
				if (cast)
					dirLights = this._pLightPicker.castingDirectionalLights;
				len = dirLights.length;
				if (len > this._pNumDirectionalLights)
					len = this._pNumDirectionalLights;

				for (i = 0; i < len; ++i)
                {
					dirLight = dirLights[offset + i];
					dirPos = dirLight.sceneDirection;
					
					this._pAmbientLightR += dirLight._iAmbientR;
                    this._pAmbientLightG += dirLight._iAmbientG;
                    this._pAmbientLightB += dirLight._iAmbientB;
					
					if (this._tangentSpace)
                    {
						var x:Number = -dirPos.x;
						var y:Number = -dirPos.y;
						var z:Number = -dirPos.z;

						this._pVertexConstantData[l++] = this._inverseSceneMatrix[0]*x + this._inverseSceneMatrix[4]*y + this._inverseSceneMatrix[8]*z;
                        this._pVertexConstantData[l++] = this._inverseSceneMatrix[1]*x + this._inverseSceneMatrix[5]*y + this._inverseSceneMatrix[9]*z;
                        this._pVertexConstantData[l++] = this._inverseSceneMatrix[2]*x + this._inverseSceneMatrix[6]*y + this._inverseSceneMatrix[10]*z;
                        this._pVertexConstantData[l++] = 1;
					}
                    else
                    {
						this._pFragmentConstantData[k++] = -dirPos.x;
                        this._pFragmentConstantData[k++] = -dirPos.y;
                        this._pFragmentConstantData[k++] = -dirPos.z;
                        this._pFragmentConstantData[k++] = 1;
					}
					
					this._pFragmentConstantData[k++] = dirLight._iDiffuseR;
                    this._pFragmentConstantData[k++] = dirLight._iDiffuseG;
                    this._pFragmentConstantData[k++] = dirLight._iDiffuseB;
                    this._pFragmentConstantData[k++] = 1;

                    this._pFragmentConstantData[k++] = dirLight._iSpecularR;
                    this._pFragmentConstantData[k++] = dirLight._iSpecularG;
                    this._pFragmentConstantData[k++] = dirLight._iSpecularB;
                    this._pFragmentConstantData[k++] = 1;
					
					if (++total == this._pNumDirectionalLights) {
						// break loop
						i = len;
						cast = numLightTypes;
					}
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
			
			var pointLights:Vector.<PointLight> = this._pLightPicker.pointLights;
			offset = this._pointLightsOffset;
			len = this._pLightPicker.pointLights.length;

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
					pointLights = this._pLightPicker.castingPointLights;
                }

				len = pointLights.length;

				for (i = 0; i < len; ++i)
                {
					pointLight = pointLights[offset + i];
					dirPos = pointLight.scenePosition;
					
					this._pAmbientLightR += pointLight._iAmbientR;
                    this._pAmbientLightG += pointLight._iAmbientG;
                    this._pAmbientLightB += pointLight._iAmbientB;
					
					if (this._tangentSpace)
                    {
						x = dirPos.x;
						y = dirPos.y;
						z = dirPos.z;

						this._pVertexConstantData[l++] = this._inverseSceneMatrix[0]*x + this._inverseSceneMatrix[4]*y + this._inverseSceneMatrix[8]*z + this._inverseSceneMatrix[12];
                        this._pVertexConstantData[l++] = this._inverseSceneMatrix[1]*x + this._inverseSceneMatrix[5]*y + this._inverseSceneMatrix[9]*z + this._inverseSceneMatrix[13];
                        this._pVertexConstantData[l++] = this._inverseSceneMatrix[2]*x + this._inverseSceneMatrix[6]*y + this._inverseSceneMatrix[10]*z + this._inverseSceneMatrix[14];
					}
                    else
                    {

						this._pVertexConstantData[l++] = dirPos.x;
						this._pVertexConstantData[l++] = dirPos.y;
						this._pVertexConstantData[l++] = dirPos.z;

					}
					this._pVertexConstantData[l++] = 1;
					
					this._pFragmentConstantData[k++] = pointLight._iDiffuseR;
                    this._pFragmentConstantData[k++] = pointLight._iDiffuseG;
                    this._pFragmentConstantData[k++] = pointLight._iDiffuseB;

					var radius:Number = pointLight._pRadius;
					this._pFragmentConstantData[k++] = radius*radius;

                    this._pFragmentConstantData[k++] = pointLight._iSpecularR;
                    this._pFragmentConstantData[k++] = pointLight._iSpecularG;
                    this._pFragmentConstantData[k++] = pointLight._iSpecularB;
                    this._pFragmentConstantData[k++] = pointLight._pFallOffFactor;
					
					if (++total == this._pNumPointLights)
                    {
						// break loop
						i = len;
						cast = numLightTypes;
					}
				}
			}
			
			// more directional supported than currently picked, need to clamp all to 0
			if (this._pNumPointLights > total)
            {
				i = k + (total - this._pNumPointLights)*12;
				for (; k < i; ++k)
                {
					this._pFragmentConstantData[k] = 0;

                }
			}
		}

		/**		 * @inheritDoc		 */
		override public function pUpdateProbes(stage3DProxy:Stage3DProxy):void
		{
			var context:Context3D = stage3DProxy._iContext3D;
			var probe:LightProbe;
			var lightProbes:Vector.<LightProbe> = this._pLightPicker.lightProbes;
			var weights:Vector.<Number> = this._pLightPicker.lightProbeWeights;
			var len:Number = lightProbes.length - this._lightProbesOffset;
			var addDiff:Boolean = this.usesProbesForDiffuse();
			var addSpec:Boolean = ((this._pMethodSetup._iSpecularMethod && this.usesProbesForSpecular( ) ) as Boolean);
			
			if (!(addDiff || addSpec))
				return;
			
			if (len > this._pNumLightProbes)
            {
				len = this._pNumLightProbes;
            }

			for (var i:Number = 0; i < len; ++i)
            {
				probe = lightProbes[ this._lightProbesOffset + i];
				
				if (addDiff)
                {
					context.setTextureAt(this._pLightProbeDiffuseIndices[i], probe.diffuseMap.getTextureForStage3D(stage3DProxy));
                }
				if (addSpec)
                {
					context.setTextureAt(this._pLightProbeSpecularIndices[i], probe.specularMap.getTextureForStage3D(stage3DProxy));
                }
			}
			
			for (i = 0; i < len; ++i)
				this._pFragmentConstantData[this._pProbeWeightsIndex + i] = weights[this._lightProbesOffset + i];
		}
	}
}
