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
	import away.base.IRenderable;
	import away.managers.Stage3DProxy;
	import away.cameras.Camera3D;
	import away.geom.Matrix3D;
	import away.geom.Vector3D;
	import away.lights.DirectionalLight;
	import away.lights.PointLight;

	
	/**	 * ShadowCasterPass is a shader pass that uses shader methods to compile a complete program. It only draws the lighting	 * contribution for a single shadow-casting light.	 *	 * @see away3d.materials.methods.ShadingMethodBase	 */
	
	public class ShadowCasterPass extends CompiledPass
	{
		private var _tangentSpace:Boolean = false;
		private var _lightVertexConstantIndex:Number = 0;
		private var _inverseSceneMatrix:Vector.<Number> = VectorInit.Num();
		
		/**		 * Creates a new ShadowCasterPass objects.		 *		 * @param material The material to which this pass belongs.		 */
		public function ShadowCasterPass(material:MaterialBase):void
		{
			super(material);
		}

		/**		 * @inheritDoc		 */
		override public function pCreateCompiler(profile:String):ShaderCompiler
		{
			return new LightingShaderCompiler(profile);
		}

		/**		 * @inheritDoc		 */
		override public function pUpdateLights():void
		{
			super.pUpdateLights();
			
			var numPointLights:Number = 0;
			var numDirectionalLights:Number = 0;
			
			if (this._pLightPicker)
            {

				numPointLights = this._pLightPicker.numCastingPointLights > 0? 1 : 0;
				numDirectionalLights = this._pLightPicker.numCastingDirectionalLights > 0? 1 : 0;

			}
            else
            {
				numPointLights = 0;
				numDirectionalLights = 0;
			}
			
			this._pNumLightProbes = 0;
			
			if (numPointLights + numDirectionalLights > 1)
            {
				throw new Error("Must have exactly one light!");
            }

			if (numPointLights != this._pNumPointLights || numDirectionalLights != this._pNumDirectionalLights)
            {
				this._pNumPointLights = numPointLights;
				this._pNumDirectionalLights = numDirectionalLights;
				this.iInvalidateShaderProgram();
			}
		}

		/**		 * @inheritDoc		 */
		override public function pUpdateShaderProperties():void
		{
			super.pUpdateShaderProperties();

            var c : LightingShaderCompiler = (this._pCompiler as LightingShaderCompiler);
            this._tangentSpace = c.tangentSpace;

		}

		/**		 * @inheritDoc		 */
		override public function pUpdateRegisterIndices():void
		{
			super.pUpdateRegisterIndices();

            var c : LightingShaderCompiler = (this._pCompiler as LightingShaderCompiler);

			this._lightVertexConstantIndex = c.lightVertexConstantIndex;

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

		/**		 * @inheritDoc		 */
		override public function pUpdateLightConstants():void
		{
			// first dirs, then points
			var dirLight:DirectionalLight;
			var pointLight:PointLight;
			var k:Number = 0;
            var l:Number = 0 ;
			var dirPos:Vector3D;
			
			l = this._lightVertexConstantIndex;
			k = this._pLightFragmentConstantIndex;
			
			if (this._pNumDirectionalLights > 0)
            {

				dirLight = this._pLightPicker.castingDirectionalLights[0];
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

				return;
			}
			
			if (this._pNumPointLights > 0) {
				pointLight = this._pLightPicker.castingPointLights[0];

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
				} else {
					this._pVertexConstantData[l++] = dirPos.x;
                    this._pVertexConstantData[l++] = dirPos.y;
                    this._pVertexConstantData[l++] = dirPos.z;
				}
                this._pVertexConstantData[l++] = 1;

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

		/**		 * @inheritDoc		 */
		override public function pUsesProbes():Boolean
		{
			return false;
		}

		/**		 * @inheritDoc		 */
		override public function pUsesLights():Boolean
		{
			return true;
		}

		/**		 * @inheritDoc		 */
		override public function pUpdateProbes(stage3DProxy:Stage3DProxy):void
		{
		}
	}
}
