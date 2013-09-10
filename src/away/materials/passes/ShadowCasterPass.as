///<reference path="../../_definitions.ts"/>

package away.materials.passes
{
	import away.materials.MaterialBase;
	import away.materials.compilation.ShaderCompiler;
	import away.materials.compilation.LightingShaderCompiler;
	import away.base.IRenderable;
	import away.managers.Stage3DProxy;
	import away.cameras.Camera3D;
	import away.geom.Matrix3D;
	import away.geom.Vector3D;
	import away.lights.DirectionalLight;
	import away.lights.PointLight;

	
	/**
	 * ShadowCasterPass is a shader pass that uses shader methods to compile a complete program. It only draws the lighting
	 * contribution for a single shadow-casting light.
	 *
	 * @see away3d.materials.methods.ShadingMethodBase
	 */
	
	public class ShadowCasterPass extends CompiledPass
	{
		private var _tangentSpace:Boolean;
		private var _lightVertexConstantIndex:Number;
		private var _inverseSceneMatrix:Vector.<Number> = new Vector.<Number>();
		
		/**
		 * Creates a new ShadowCasterPass objects.
		 *
		 * @param material The material to which this pass belongs.
		 */
		public function ShadowCasterPass(material:MaterialBase):void
		{
			super(material);
		}

		/**
		 * @inheritDoc
		 */
		override public function pCreateCompiler(profile:String):ShaderCompiler
		{
			return new LightingShaderCompiler(profile);
		}

		/**
		 * @inheritDoc
		 */
		override public function pUpdateLights():void
		{
			super.pUpdateLights();
			
			var numPointLights:Number = 0;
			var numDirectionalLights:Number = 0;
			
			if (_pLightPicker)
            {

				numPointLights = _pLightPicker.numCastingPointLights > 0? 1 : 0;
				numDirectionalLights = _pLightPicker.numCastingDirectionalLights > 0? 1 : 0;

			}
            else
            {
				numPointLights = 0;
				numDirectionalLights = 0;
			}
			
			_pNumLightProbes = 0;
			
			if (numPointLights + numDirectionalLights > 1)
            {
				throw new Error("Must have exactly one light!");
            }

			if (numPointLights != _pNumPointLights || numDirectionalLights != _pNumDirectionalLights)
            {
				_pNumPointLights = numPointLights;
				_pNumDirectionalLights = numDirectionalLights;
				iInvalidateShaderProgram();
			}
		}

		/**
		 * @inheritDoc
		 */
		override public function pUpdateShaderProperties():void
		{
			super.pUpdateShaderProperties();

            var c : LightingShaderCompiler = (_pCompiler as LightingShaderCompiler);
            _tangentSpace = c.tangentSpace;

		}

		/**
		 * @inheritDoc
		 */
		override public function pUpdateRegisterIndices():void
		{
			super.pUpdateRegisterIndices();

            var c : LightingShaderCompiler = (_pCompiler as LightingShaderCompiler);

			_lightVertexConstantIndex = c.lightVertexConstantIndex;

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
		 * @inheritDoc
		 */
		override public function pUpdateLightConstants():void
		{
			// first dirs, then points
			var dirLight:DirectionalLight;
			var pointLight:PointLight;
			var k:Number = 0;
            var l:Number = 0 ;
			var dirPos:Vector3D;
			
			l = _lightVertexConstantIndex;
			k = _pLightFragmentConstantIndex;
			
			if (_pNumDirectionalLights > 0)
            {

				dirLight = _pLightPicker.castingDirectionalLights[0];
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

				return;
			}
			
			if (_pNumPointLights > 0) {
				pointLight = _pLightPicker.castingPointLights[0];

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
				} else {
					_pVertexConstantData[l++] = dirPos.x;
                    _pVertexConstantData[l++] = dirPos.y;
                    _pVertexConstantData[l++] = dirPos.z;
				}
                _pVertexConstantData[l++] = 1;

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

		/**
		 * @inheritDoc
		 */
		override public function pUsesProbes():Boolean
		{
			return false;
		}

		/**
		 * @inheritDoc
		 */
		override public function pUsesLights():Boolean
		{
			return true;
		}

		/**
		 * @inheritDoc
		 */
		override public function pUpdateProbes(stage3DProxy:Stage3DProxy):void
		{
		}
	}
}
