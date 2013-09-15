///<reference path="../../_definitions.ts"/>
package away.materials.methods
{
	import away.events.EventDispatcher;
	import away.events.ShadingMethodEvent;

	/**	 * ShaderMethodSetup contains the method configuration for an entire material.	 */
	public class ShaderMethodSetup extends EventDispatcher
	{
		public var _iColorTransformMethod:ColorTransformMethod;
        public var _iColorTransformMethodVO:MethodVO;
        public var _iNormalMethod:BasicNormalMethod;
        public var _iNormalMethodVO:MethodVO;
        public var _iAmbientMethod:BasicAmbientMethod;
        public var _iAmbientMethodVO:MethodVO;
        public var _iShadowMethod:ShadowMapMethodBase;
        public var _iShadowMethodVO:MethodVO;
        public var _iDiffuseMethod:BasicDiffuseMethod;
        public var _iDiffuseMethodVO:MethodVO;
        public var _iSpecularMethod:BasicSpecularMethod;
        public var _iSpecularMethodVO:MethodVO;
        public var _iMethods:Vector.<MethodVOSet>;//Vector.<MethodVOSet>;
		/**		 * Creates a new ShaderMethodSetup object.		 */
		public function ShaderMethodSetup():void
		{

            super();

			this._iMethods = new Vector.<MethodVOSet>();//Vector.<MethodVOSet>();
            this._iNormalMethod = new BasicNormalMethod();
            this._iAmbientMethod = new BasicAmbientMethod();
            this._iDiffuseMethod = new BasicDiffuseMethod();
            this._iSpecularMethod = new BasicSpecularMethod();
            this._iNormalMethod.addEventListener(ShadingMethodEvent.SHADER_INVALIDATED, this.onShaderInvalidated, this);
            this._iDiffuseMethod.addEventListener(ShadingMethodEvent.SHADER_INVALIDATED, this.onShaderInvalidated, this);
            this._iSpecularMethod.addEventListener(ShadingMethodEvent.SHADER_INVALIDATED, this.onShaderInvalidated, this);
            this._iAmbientMethod.addEventListener(ShadingMethodEvent.SHADER_INVALIDATED, this.onShaderInvalidated , this);
            this._iNormalMethodVO = this._iNormalMethod.iCreateMethodVO();
            this._iAmbientMethodVO = this._iAmbientMethod.iCreateMethodVO();
            this._iDiffuseMethodVO = this._iDiffuseMethod.iCreateMethodVO();
            this._iSpecularMethodVO = this._iSpecularMethod.iCreateMethodVO();
		}

		/**		 * Called when any method's code is invalidated.		 */
		private function onShaderInvalidated(event:ShadingMethodEvent):void
		{
			this.invalidateShaderProgram();
		}

		/**		 * Invalidates the material's shader code.		 */
		private function invalidateShaderProgram():void
		{

			this.dispatchEvent( new ShadingMethodEvent(ShadingMethodEvent.SHADER_INVALIDATED) );

		}

		/**		 *  The method used to generate the per-pixel normals.		 */
		public function get normalMethod():BasicNormalMethod
		{
			return this._iNormalMethod;
		}
		
		public function set normalMethod(value:BasicNormalMethod):void
		{
			if (this._iNormalMethod)
            {

                this._iNormalMethod.removeEventListener(ShadingMethodEvent.SHADER_INVALIDATED, this.onShaderInvalidated , this );

            }

			
			if (value)
            {

				if (this._iNormalMethod)
                {

                    value.copyFrom(this._iNormalMethod);

                }


				this._iNormalMethodVO = value.iCreateMethodVO();
				value.addEventListener(ShadingMethodEvent.SHADER_INVALIDATED, this.onShaderInvalidated , this );
			}
			
			this._iNormalMethod = value;
			
			if (value)
				this.invalidateShaderProgram();
		}

		/**		 * The method that provides the ambient lighting contribution.		 */
		public function get ambientMethod():BasicAmbientMethod
		{
			return this._iAmbientMethod;
		}
		
		public function set ambientMethod(value:BasicAmbientMethod):void
		{
			if (this._iAmbientMethod)
				this._iAmbientMethod.removeEventListener(ShadingMethodEvent.SHADER_INVALIDATED, this.onShaderInvalidated , this );

			if (value)
            {

				if (this._iAmbientMethod)
					value.copyFrom(this._iAmbientMethod);

				value.addEventListener(ShadingMethodEvent.SHADER_INVALIDATED, this.onShaderInvalidated , this );
				this._iAmbientMethodVO = value.iCreateMethodVO();

			}
			this._iAmbientMethod = value;
			
			if (value)
				this.invalidateShaderProgram();
		}

		/**		 * The method used to render shadows cast on this surface, or null if no shadows are to be rendered.		 */
		public function get shadowMethod():ShadowMapMethodBase
		{
			return this._iShadowMethod;
		}
		
		public function set shadowMethod(value:ShadowMapMethodBase):void
		{
			if (this._iShadowMethod)
            {

                this._iShadowMethod.removeEventListener(ShadingMethodEvent.SHADER_INVALIDATED, this.onShaderInvalidated , this );

            }

			this._iShadowMethod = value;

			if ( this._iShadowMethod)
            {

				this._iShadowMethod.addEventListener(ShadingMethodEvent.SHADER_INVALIDATED, this.onShaderInvalidated , this );
				this._iShadowMethodVO = this._iShadowMethod.iCreateMethodVO();

			}
            else
            {

                this._iShadowMethodVO = null;

            }

			this.invalidateShaderProgram();

		}

		/**		 * The method that provides the diffuse lighting contribution.		 */
		 public function get diffuseMethod():BasicDiffuseMethod
		{
			return this._iDiffuseMethod;
		}
		
		public function set diffuseMethod(value:BasicDiffuseMethod):void
		{
			if (this._iDiffuseMethod)
				this._iDiffuseMethod.removeEventListener(ShadingMethodEvent.SHADER_INVALIDATED, this.onShaderInvalidated , this );
			
			if (value)
            {

				if (this._iDiffuseMethod)
					value.copyFrom( this._iDiffuseMethod);

				value.addEventListener(ShadingMethodEvent.SHADER_INVALIDATED, this.onShaderInvalidated , this );

				this._iDiffuseMethodVO = value.iCreateMethodVO();
			}
			
			this._iDiffuseMethod = value;
			
			if (value)
				this.invalidateShaderProgram();

		}
		
		/**		 * The method to perform specular shading.		 */
		public function get specularMethod():BasicSpecularMethod
		{
			return this._iSpecularMethod;
		}
		
		public function set specularMethod(value:BasicSpecularMethod):void
		{
			if (this._iSpecularMethod)
            {
				this._iSpecularMethod.removeEventListener(ShadingMethodEvent.SHADER_INVALIDATED, this.onShaderInvalidated , this );

				if (value)
					value.copyFrom(this._iSpecularMethod);

			}
			
			this._iSpecularMethod = value;
			if (this._iSpecularMethod)
            {

				this._iSpecularMethod.addEventListener(ShadingMethodEvent.SHADER_INVALIDATED, this.onShaderInvalidated , this );
				this._iSpecularMethodVO = this._iSpecularMethod.iCreateMethodVO();

			}
            else
            {

                this._iSpecularMethodVO = null;

            }

			this.invalidateShaderProgram();

		}
		
		/**		 * @private		 */
		public function get iColorTransformMethod():ColorTransformMethod
		{
			return this._iColorTransformMethod;
		}
		
		public function set iColorTransformMethod(value:ColorTransformMethod):void
		{
			if (this._iColorTransformMethod == value)
				return;

			if (this._iColorTransformMethod)
				this._iColorTransformMethod.removeEventListener(ShadingMethodEvent.SHADER_INVALIDATED, this.onShaderInvalidated , this );

			if (!this._iColorTransformMethod || !value)
            {

                this.invalidateShaderProgram();

            }

			
			this._iColorTransformMethod = value;

			if (this._iColorTransformMethod)
            {
				this._iColorTransformMethod.addEventListener(ShadingMethodEvent.SHADER_INVALIDATED, this.onShaderInvalidated , this );
				this._iColorTransformMethodVO = this._iColorTransformMethod.iCreateMethodVO();

			}
            else
            {

                this._iColorTransformMethodVO = null;

            }

		}

		/**		 * Disposes the object.		 */
		public function dispose():void
		{
			this.clearListeners(this._iNormalMethod);
            this.clearListeners(this._iDiffuseMethod);
            this.clearListeners(this._iShadowMethod);
            this.clearListeners(this._iAmbientMethod);
            this.clearListeners(this._iSpecularMethod);
			
			for (var i:Number = 0; i < this._iMethods.length; ++i)
            {

                this.clearListeners(this._iMethods[i].method);

            }

			
			this._iMethods = null;

		}

		/**		 * Removes all listeners from a method.		 */
		private function clearListeners(method:ShadingMethodBase):void
		{
			if (method)
				method.removeEventListener(ShadingMethodEvent.SHADER_INVALIDATED, this.onShaderInvalidated , this );
		}
		
		/**		 * Adds a method to change the material after all lighting is performed.		 * @param method The method to be added.		 */
		public function addMethod(method:EffectMethodBase):void
		{
			this._iMethods.push(new MethodVOSet(method));

			method.addEventListener(ShadingMethodEvent.SHADER_INVALIDATED, this.onShaderInvalidated , this );

			this.invalidateShaderProgram();

		}

		/**		 * Queries whether a given effect method was added to the material.		 *		 * @param method The method to be queried.		 * @return true if the method was added to the material, false otherwise.		 */
		public function hasMethod(method:EffectMethodBase):Boolean
		{

			return this.getMethodSetForMethod(method) != null;

		}
		
		/**		 * Inserts a method to change the material after all lighting is performed at the given index.		 * @param method The method to be added.		 * @param index The index of the method's occurrence		 */
		public function addMethodAt(method:EffectMethodBase, index:Number):void
		{
			this._iMethods.splice(index, 0, new MethodVOSet(method));

			method.addEventListener(ShadingMethodEvent.SHADER_INVALIDATED, this.onShaderInvalidated , this );

			this.invalidateShaderProgram();

		}

		/**		 * Returns the method added at the given index.		 * @param index The index of the method to retrieve.		 * @return The method at the given index.		 */
		public function getMethodAt(index:Number):EffectMethodBase
		{
			if (index > this._iMethods.length - 1)
				return null;
			
			return this._iMethods[index].method;

		}

		/**		 * The number of "effect" methods added to the material.		 */
		public function get numMethods():Number
		{

			return this._iMethods.length;

		}
		
		/**		 * Removes a method from the pass.		 * @param method The method to be removed.		 */
		public function removeMethod(method:EffectMethodBase):void
		{
			var methodSet:MethodVOSet = this.getMethodSetForMethod(method);

			if (methodSet != null)
            {
				var index:Number = this._iMethods.indexOf(methodSet);

				this._iMethods.splice(index, 1);

				method.removeEventListener(ShadingMethodEvent.SHADER_INVALIDATED, this.onShaderInvalidated , this );

				this.invalidateShaderProgram();

			}
		}
		
		private function getMethodSetForMethod(method:EffectMethodBase):MethodVOSet
		{
			var len:Number = this._iMethods.length;

			for (var i:Number = 0; i < len; ++i)
            {
				if (this._iMethods[i].method == method)
					return this._iMethods[i];
			}
			
			return null;
		}
	}
}
