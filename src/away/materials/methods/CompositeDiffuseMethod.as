///<reference path="../../_definitions.ts"/>
package away.materials.methods
{
	import away.events.ShadingMethodEvent;
	import away.textures.Texture2DBase;
	import away.materials.compilation.ShaderRegisterCache;
	import away.materials.compilation.ShaderRegisterElement;
	import away.managers.Stage3DProxy;
	import away.materials.compilation.ShaderRegisterData;

	/**	 * CompositeDiffuseMethod provides a base class for diffuse methods that wrap a diffuse method to alter the	 * calculated diffuse reflection strength.	 */
	public class CompositeDiffuseMethod extends BasicDiffuseMethod
	{
		public var pBaseMethod:BasicDiffuseMethod;

		/**		 * Creates a new WrapDiffuseMethod object.		 * @param modulateMethod The method which will add the code to alter the base method's strength. It needs to have the signature clampDiffuse(t : ShaderRegisterElement, regCache : ShaderRegisterCache) : string, in which t.w will contain the diffuse strength.		 * @param baseDiffuseMethod The base diffuse method on which this method's shading is based.		 */
		public function CompositeDiffuseMethod(modulateMethod:Function = null, baseDiffuseMethod:BasicDiffuseMethod = null):void
		{

            super();

			this.pBaseMethod = baseDiffuseMethod || new BasicDiffuseMethod();
            this.pBaseMethod._iModulateMethod = modulateMethod;
            this.pBaseMethod.addEventListener(ShadingMethodEvent.SHADER_INVALIDATED, onShaderInvalidated , this );
		}

		/**		 * The base diffuse method on which this method's shading is based.		 */
		public function get baseMethod():BasicDiffuseMethod
		{
			return this.pBaseMethod;
		}

		public function set baseMethod(value:BasicDiffuseMethod):void
		{
			if (this.pBaseMethod == value)
				return;
            this.pBaseMethod.removeEventListener(ShadingMethodEvent.SHADER_INVALIDATED, onShaderInvalidated , this );
            this.pBaseMethod = value;
            this.pBaseMethod.addEventListener(ShadingMethodEvent.SHADER_INVALIDATED, onShaderInvalidated, this );
			this.iInvalidateShaderProgram();//invalidateShaderProgram();
		}

		/**		 * @inheritDoc		 */
		override public function iInitVO(vo:MethodVO):void
		{
            this.pBaseMethod.iInitVO(vo);
		}

		/**		 * @inheritDoc		 */
		override public function iInitConstants(vo:MethodVO):void
		{
            this.pBaseMethod.iInitConstants(vo);
		}
		
		/**		 * @inheritDoc		 */
		override public function dispose():void
		{
            this.pBaseMethod.removeEventListener(ShadingMethodEvent.SHADER_INVALIDATED, onShaderInvalidated , this );
            this.pBaseMethod.dispose();
		}

		/**		 * @inheritDoc		 */
		override public function get alphaThreshold():Number
		{
			return this.pBaseMethod.alphaThreshold;
		}
		
		override public function set alphaThreshold(value:Number):void
		{
            this.pBaseMethod.alphaThreshold = value;
		}
		
		/**		 * @inheritDoc		 */
		override public function get texture():Texture2DBase
		{
			return this.pBaseMethod.texture;
		}
		
		/**		 * @inheritDoc		 */
		override public function set texture(value:Texture2DBase):void
		{
            this.pBaseMethod.texture = value;
		}
		
		/**		 * @inheritDoc		 */
		override public function get diffuseAlpha():Number
		{
			return this.pBaseMethod.diffuseAlpha;
		}
		
		/**		 * @inheritDoc		 */
		override public function get diffuseColor():Number
		{
			return this.pBaseMethod.diffuseColor;
		}
		
		/**		 * @inheritDoc		 */
		override public function set diffuseColor(diffuseColor:Number):void
		{
            this.pBaseMethod.diffuseColor = diffuseColor;
		}
		
		/**		 * @inheritDoc		 */
		override public function set diffuseAlpha(value:Number):void
		{
            this.pBaseMethod.diffuseAlpha = value;
		}
		
		/**		 * @inheritDoc		 */
		override public function iGetFragmentPreLightingCode(vo:MethodVO, regCache:ShaderRegisterCache):String
		{
			return this.pBaseMethod.iGetFragmentPreLightingCode(vo, regCache);
		}
		
		/**		 * @inheritDoc		 */
		override public function iGetFragmentCodePerLight(vo:MethodVO, lightDirReg:ShaderRegisterElement, lightColReg:ShaderRegisterElement, regCache:ShaderRegisterCache):String
		{
			var code:String = this.pBaseMethod.iGetFragmentCodePerLight(vo, lightDirReg, lightColReg, regCache);
			this.pTotalLightColorReg = this.pBaseMethod.pTotalLightColorReg;
			return code;
		}
		
		/**		 * @inheritDoc		 */
		override public function iGetFragmentCodePerProbe(vo:MethodVO, cubeMapReg:ShaderRegisterElement, weightRegister:String, regCache:ShaderRegisterCache):String
		{
			var code:String = this.pBaseMethod.iGetFragmentCodePerProbe(vo, cubeMapReg, weightRegister, regCache);
			this.pTotalLightColorReg = this.pBaseMethod.pTotalLightColorReg;
			return code;
		}
		
		/**		 * @inheritDoc		 */
		override public function iActivate(vo:MethodVO, stage3DProxy:Stage3DProxy):void
		{
            this.pBaseMethod.iActivate(vo, stage3DProxy);
		}

		/**		 * @inheritDoc		 */
		override public function iDeactivate(vo:MethodVO, stage3DProxy:Stage3DProxy):void
		{
            this.pBaseMethod.iDeactivate(vo, stage3DProxy);
		}
		
		/**		 * @inheritDoc		 */
		override public function iGetVertexCode(vo:MethodVO, regCache:ShaderRegisterCache):String
		{
			return this.pBaseMethod.iGetVertexCode(vo, regCache);
		}
		
		/**		 * @inheritDoc		 */
		override public function iGetFragmentPostLightingCode(vo:MethodVO, regCache:ShaderRegisterCache, targetReg:ShaderRegisterElement):String
		{
			return this.pBaseMethod.iGetFragmentPostLightingCode(vo, regCache, targetReg);
		}
		
		/**		 * @inheritDoc		 */
		override public function iReset():void
		{
            this.pBaseMethod.iReset();
		}

		/**		 * @inheritDoc		 */
		override public function iCleanCompilationData():void
		{
			super.iCleanCompilationData();
            this.pBaseMethod.iCleanCompilationData();
		}
		
		/**		 * @inheritDoc		 */

        override public function set iSharedRegisters(value:ShaderRegisterData):void
        {
            this.pBaseMethod.setISharedRegisters( value );
            super.setISharedRegisters( value ) ;

        }

        override public function setISharedRegisters(value:ShaderRegisterData):void
        {
            this.pBaseMethod.setISharedRegisters( value );
            super.setISharedRegisters( value ) ;

        }

		/**		 * @inheritDoc		 */
		override public function set iShadowRegister(value:ShaderRegisterElement):void
		{
			super.setIShadowRegister( value );
            this.pBaseMethod.setIShadowRegister( value );
		}

		/**		 * Called when the base method's shader code is invalidated.		 */
		private function onShaderInvalidated(event:ShadingMethodEvent):void
		{
			this.iInvalidateShaderProgram();
		}
	}
}
