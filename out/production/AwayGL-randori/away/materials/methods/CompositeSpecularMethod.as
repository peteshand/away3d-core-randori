/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package away.materials.methods
{
	import away.events.ShadingMethodEvent;
	import away.materials.passes.MaterialPassBase;
	import away.textures.Texture2DBase;
	import away.managers.Stage3DProxy;
	import away.materials.compilation.ShaderRegisterData;
	import away.materials.compilation.ShaderRegisterCache;
	import away.materials.compilation.ShaderRegisterElement;
	
	/**	 * CompositeSpecularMethod provides a base class for specular methods that wrap a specular method to alter the	 * calculated specular reflection strength.	 */
	public class CompositeSpecularMethod extends BasicSpecularMethod
	{
		private var _baseMethod:BasicSpecularMethod;
		
		/**		 * Creates a new WrapSpecularMethod object.		 * @param modulateMethod The method which will add the code to alter the base method's strength. It needs to have the signature modSpecular(t : ShaderRegisterElement, regCache : ShaderRegisterCache) : string, in which t.w will contain the specular strength and t.xyz will contain the half-vector or the reflection vector.		 * @param baseSpecularMethod The base specular method on which this method's shading is based.		 */
		public function CompositeSpecularMethod():void
		{
			super();

            /*			this._baseMethod = baseSpecularMethod || new away.materials.BasicSpecularMethod();			this._baseMethod._iModulateMethod = modulateMethod;            this._baseMethod.addEventListener(away.events.ShadingMethodEvent.SHADER_INVALIDATED, this.onShaderInvalidated , this );            */

		}

        public function initCompositeSpecularMethod(scope:Object, modulateMethod:Function, baseSpecularMethod:BasicSpecularMethod = null):void
        {
			baseSpecularMethod = baseSpecularMethod || null;


            this._baseMethod = baseSpecularMethod || new BasicSpecularMethod();
            this._baseMethod._iModulateMethod = modulateMethod;
            this._baseMethod._iModulateMethodScope = scope;
            this._baseMethod.addEventListener(ShadingMethodEvent.SHADER_INVALIDATED, onShaderInvalidated , this );

        }

		/**		 * @inheritDoc		 */
		override public function iInitVO(vo:MethodVO):void
		{
			this._baseMethod.iInitVO(vo);
		}

		/**		 * @inheritDoc		 */
		override public function iInitConstants(vo:MethodVO):void
		{
			this._baseMethod.iInitConstants(vo);
		}
		
		/**		 * The base specular method on which this method's shading is based.		 */
		public function get baseMethod():BasicSpecularMethod
		{
			return this._baseMethod;
		}
		
		public function set baseMethod(value:BasicSpecularMethod):void
		{
			if (this._baseMethod == value)
				return;
            this._baseMethod.removeEventListener(ShadingMethodEvent.SHADER_INVALIDATED, onShaderInvalidated , this );
            this._baseMethod = value;
            this._baseMethod.addEventListener(ShadingMethodEvent.SHADER_INVALIDATED, onShaderInvalidated, this);
            this.iInvalidateShaderProgram();
		}
		
		/**		 * @inheritDoc		 */
		override public function get gloss():Number
		{
			return this._baseMethod.gloss;
		}
		
		override public function set gloss(value:Number):void
		{
			this._baseMethod.gloss = value;
		}
		
		/**		 * @inheritDoc		 */
		override public function get specular():Number
		{
			return this._baseMethod.specular;
		}
		
		override public function set specular(value:Number):void
		{
			this._baseMethod.specular = value;
		}
		
		/**		 * @inheritDoc		 */
		override public function get passes():Vector.<MaterialPassBase>
		{
			return this._baseMethod.passes;
		}
		
		/**		 * @inheritDoc		 */
		override public function dispose():void
		{
			this._baseMethod.removeEventListener(ShadingMethodEvent.SHADER_INVALIDATED, onShaderInvalidated , this );
			this._baseMethod.dispose();
		}
		
		/**		 * @inheritDoc		 */
		override public function get texture():Texture2DBase
		{
			return this._baseMethod.texture;
		}
		
		override public function set texture(value:Texture2DBase):void
		{
			this._baseMethod.texture = value;
		}
		
		/**		 * @inheritDoc		 */
		override public function iActivate(vo:MethodVO, stage3DProxy:Stage3DProxy):void
		{
			this._baseMethod.iActivate(vo, stage3DProxy);
		}

		/**		 * @inheritDoc		 */
		override public function iDeactivate(vo:MethodVO, stage3DProxy:Stage3DProxy):void
		{
			this._baseMethod.iDeactivate(vo, stage3DProxy);
		}
		
		/**		 * @inheritDoc		 */
        override public function set iSharedRegisters(value:ShaderRegisterData):void
        {
            super.setISharedRegisters( value );
            this._baseMethod.setISharedRegisters(value );
        }
        override public function setISharedRegisters(value:ShaderRegisterData):void
        {
            super.setISharedRegisters( value );
            this._baseMethod.setISharedRegisters(value );
        }
		
		/**		 * @inheritDoc		 */
		override public function iGetVertexCode(vo:MethodVO, regCache:ShaderRegisterCache):String
		{
			return this._baseMethod.iGetVertexCode(vo, regCache);
		}
		
		/**		 * @inheritDoc		 */
		override public function iGetFragmentPreLightingCode(vo:MethodVO, regCache:ShaderRegisterCache):String
		{
			return this._baseMethod.iGetFragmentPreLightingCode(vo, regCache);
		}
		
		/**		 * @inheritDoc		 */
		override public function iGetFragmentCodePerLight(vo:MethodVO, lightDirReg:ShaderRegisterElement, lightColReg:ShaderRegisterElement, regCache:ShaderRegisterCache):String
		{
			return this._baseMethod.iGetFragmentCodePerLight(vo, lightDirReg, lightColReg, regCache);
		}
		
		/**		 * @inheritDoc		 * @return		 */
		override public function iGetFragmentCodePerProbe(vo:MethodVO, cubeMapReg:ShaderRegisterElement, weightRegister:String, regCache:ShaderRegisterCache):String
		{
			return this._baseMethod.iGetFragmentCodePerProbe(vo, cubeMapReg, weightRegister, regCache);
		}
		
		/**		 * @inheritDoc		 */
		override public function iGetFragmentPostLightingCode(vo:MethodVO, regCache:ShaderRegisterCache, targetReg:ShaderRegisterElement):String
		{
			return this._baseMethod.iGetFragmentPostLightingCode(vo, regCache, targetReg);
		}
		
		/**		 * @inheritDoc		 */
		override public function iReset():void
		{
            this._baseMethod.iReset();
		}

		/**		 * @inheritDoc		 */
		override public function iCleanCompilationData():void
		{
			super.iCleanCompilationData();
			this._baseMethod.iCleanCompilationData();
		}

		/**		 * @inheritDoc		 */
		override public function set iShadowRegister(value:ShaderRegisterElement):void
		{

			this.setIShadowRegister( value );
			this._baseMethod.setIShadowRegister( value );
		}

		/**		 * Called when the base method's shader code is invalidated.		 */
		private function onShaderInvalidated(event:ShadingMethodEvent):void
		{
			this.iInvalidateShaderProgram();
		}
	}
}
