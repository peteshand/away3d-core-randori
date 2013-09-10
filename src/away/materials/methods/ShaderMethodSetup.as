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

			_iMethods = new Vector.<MethodVOSet>();//Vector.<MethodVOSet>();
            _iNormalMethod = new BasicNormalMethod();
            _iAmbientMethod = new BasicAmbientMethod();
            _iDiffuseMethod = new BasicDiffuseMethod();
            _iSpecularMethod = new BasicSpecularMethod();
            _iNormalMethod.addEventListener(ShadingMethodEvent.SHADER_INVALIDATED, onShaderInvalidated, this);
            _iDiffuseMethod.addEventListener(ShadingMethodEvent.SHADER_INVALIDATED, onShaderInvalidated, this);
            _iSpecularMethod.addEventListener(ShadingMethodEvent.SHADER_INVALIDATED, onShaderInvalidated, this);
            _iAmbientMethod.addEventListener(ShadingMethodEvent.SHADER_INVALIDATED, onShaderInvalidated , this);
            _iNormalMethodVO = _iNormalMethod.iCreateMethodVO();
            _iAmbientMethodVO = _iAmbientMethod.iCreateMethodVO();
            _iDiffuseMethodVO = _iDiffuseMethod.iCreateMethodVO();
            _iSpecularMethodVO = _iSpecularMethod.iCreateMethodVO();
		}

		/**		 * Called when any method's code is invalidated.		 */
		private function onShaderInvalidated(event:ShadingMethodEvent):void
		{
			invalidateShaderProgram();
		}

		/**		 * Invalidates the material's shader code.		 */
		private function invalidateShaderProgram():void
		{

			dispatchEvent( new ShadingMethodEvent(ShadingMethodEvent.SHADER_INVALIDATED) );

		}

		/**		 *  The method used to generate the per-pixel normals.		 */
		public function get normalMethod():BasicNormalMethod
		{
			return _iNormalMethod;
		}
		
		public function set normalMethod(value:BasicNormalMethod):void
		{
			if (_iNormalMethod)
            {

                _iNormalMethod.removeEventListener(ShadingMethodEvent.SHADER_INVALIDATED, onShaderInvalidated , this );

            }

			
			if (value)
            {

				if (_iNormalMethod)
                {

                    value.copyFrom(_iNormalMethod);

                }


				_iNormalMethodVO = value.iCreateMethodVO();
				value.addEventListener(ShadingMethodEvent.SHADER_INVALIDATED, onShaderInvalidated , this );
			}
			
			_iNormalMethod = value;
			
			if (value)
				invalidateShaderProgram();
		}

		/**		 * The method that provides the ambient lighting contribution.		 */
		public function get ambientMethod():BasicAmbientMethod
		{
			return _iAmbientMethod;
		}
		
		public function set ambientMethod(value:BasicAmbientMethod):void
		{
			if (_iAmbientMethod)
				_iAmbientMethod.removeEventListener(ShadingMethodEvent.SHADER_INVALIDATED, onShaderInvalidated , this );

			if (value)
            {

				if (_iAmbientMethod)
					value.copyFrom(_iAmbientMethod);

				value.addEventListener(ShadingMethodEvent.SHADER_INVALIDATED, onShaderInvalidated , this );
				_iAmbientMethodVO = value.iCreateMethodVO();

			}
			_iAmbientMethod = value;
			
			if (value)
				invalidateShaderProgram();
		}

		/**		 * The method used to render shadows cast on this surface, or null if no shadows are to be rendered.		 */
		public function get shadowMethod():ShadowMapMethodBase
		{
			return _iShadowMethod;
		}
		
		public function set shadowMethod(value:ShadowMapMethodBase):void
		{
			if (_iShadowMethod)
            {

                _iShadowMethod.removeEventListener(ShadingMethodEvent.SHADER_INVALIDATED, onShaderInvalidated , this );

            }

			_iShadowMethod = value;

			if ( _iShadowMethod)
            {

				_iShadowMethod.addEventListener(ShadingMethodEvent.SHADER_INVALIDATED, onShaderInvalidated , this );
				_iShadowMethodVO = _iShadowMethod.iCreateMethodVO();

			}
            else
            {

                _iShadowMethodVO = null;

            }

			invalidateShaderProgram();

		}

		/**		 * The method that provides the diffuse lighting contribution.		 */
		 public function get diffuseMethod():BasicDiffuseMethod
		{
			return _iDiffuseMethod;
		}
		
		public function set diffuseMethod(value:BasicDiffuseMethod):void
		{
			if (_iDiffuseMethod)
				_iDiffuseMethod.removeEventListener(ShadingMethodEvent.SHADER_INVALIDATED, onShaderInvalidated , this );
			
			if (value)
            {

				if (_iDiffuseMethod)
					value.copyFrom( _iDiffuseMethod);

				value.addEventListener(ShadingMethodEvent.SHADER_INVALIDATED, onShaderInvalidated , this );

				_iDiffuseMethodVO = value.iCreateMethodVO();
			}
			
			_iDiffuseMethod = value;
			
			if (value)
				invalidateShaderProgram();

		}
		
		/**		 * The method to perform specular shading.		 */
		public function get specularMethod():BasicSpecularMethod
		{
			return _iSpecularMethod;
		}
		
		public function set specularMethod(value:BasicSpecularMethod):void
		{
			if (_iSpecularMethod)
            {
				_iSpecularMethod.removeEventListener(ShadingMethodEvent.SHADER_INVALIDATED, onShaderInvalidated , this );

				if (value)
					value.copyFrom(_iSpecularMethod);

			}
			
			_iSpecularMethod = value;
			if (_iSpecularMethod)
            {

				_iSpecularMethod.addEventListener(ShadingMethodEvent.SHADER_INVALIDATED, onShaderInvalidated , this );
				_iSpecularMethodVO = _iSpecularMethod.iCreateMethodVO();

			}
            else
            {

                _iSpecularMethodVO = null;

            }

			invalidateShaderProgram();

		}
		
		/**		 * @private		 */
		public function get iColorTransformMethod():ColorTransformMethod
		{
			return _iColorTransformMethod;
		}
		
		public function set iColorTransformMethod(value:ColorTransformMethod):void
		{
			if (_iColorTransformMethod == value)
				return;

			if (_iColorTransformMethod)
				_iColorTransformMethod.removeEventListener(ShadingMethodEvent.SHADER_INVALIDATED, onShaderInvalidated , this );

			if (!_iColorTransformMethod || !value)
            {

                invalidateShaderProgram();

            }

			
			_iColorTransformMethod = value;

			if (_iColorTransformMethod)
            {
				_iColorTransformMethod.addEventListener(ShadingMethodEvent.SHADER_INVALIDATED, onShaderInvalidated , this );
				_iColorTransformMethodVO = _iColorTransformMethod.iCreateMethodVO();

			}
            else
            {

                _iColorTransformMethodVO = null;

            }

		}

		/**		 * Disposes the object.		 */
		public function dispose():void
		{
			clearListeners(_iNormalMethod);
            clearListeners(_iDiffuseMethod);
            clearListeners(_iShadowMethod);
            clearListeners(_iAmbientMethod);
            clearListeners(_iSpecularMethod);
			
			for (var i:Number = 0; i < _iMethods.length; ++i)
            {

                clearListeners(_iMethods[i].method);

            }

			
			_iMethods = null;

		}

		/**		 * Removes all listeners from a method.		 */
		private function clearListeners(method:ShadingMethodBase):void
		{
			if (method)
				method.removeEventListener(ShadingMethodEvent.SHADER_INVALIDATED, onShaderInvalidated , this );
		}
		
		/**		 * Adds a method to change the material after all lighting is performed.		 * @param method The method to be added.		 */
		public function addMethod(method:EffectMethodBase):void
		{
			_iMethods.push(new MethodVOSet(method));

			method.addEventListener(ShadingMethodEvent.SHADER_INVALIDATED, onShaderInvalidated , this );

			invalidateShaderProgram();

		}

		/**		 * Queries whether a given effect method was added to the material.		 *		 * @param method The method to be queried.		 * @return true if the method was added to the material, false otherwise.		 */
		public function hasMethod(method:EffectMethodBase):Boolean
		{

			return getMethodSetForMethod(method) != null;

		}
		
		/**		 * Inserts a method to change the material after all lighting is performed at the given index.		 * @param method The method to be added.		 * @param index The index of the method's occurrence		 */
		public function addMethodAt(method:EffectMethodBase, index:Number):void
		{
			_iMethods.splice(index, 0, new MethodVOSet(method));

			method.addEventListener(ShadingMethodEvent.SHADER_INVALIDATED, onShaderInvalidated , this );

			invalidateShaderProgram();

		}

		/**		 * Returns the method added at the given index.		 * @param index The index of the method to retrieve.		 * @return The method at the given index.		 */
		public function getMethodAt(index:Number):EffectMethodBase
		{
			if (index > _iMethods.length - 1)
				return null;
			
			return _iMethods[index].method;

		}

		/**		 * The number of "effect" methods added to the material.		 */
		public function get numMethods():Number
		{

			return _iMethods.length;

		}
		
		/**		 * Removes a method from the pass.		 * @param method The method to be removed.		 */
		public function removeMethod(method:EffectMethodBase):void
		{
			var methodSet:MethodVOSet = getMethodSetForMethod(method);

			if (methodSet != null)
            {
				var index:Number = _iMethods.indexOf(methodSet);

				_iMethods.splice(index, 1);

				method.removeEventListener(ShadingMethodEvent.SHADER_INVALIDATED, onShaderInvalidated , this );

				invalidateShaderProgram();

			}
		}
		
		private function getMethodSetForMethod(method:EffectMethodBase):MethodVOSet
		{
			var len:Number = _iMethods.length;

			for (var i:Number = 0; i < len; ++i)
            {
				if (_iMethods[i].method == method)
					return _iMethods[i];
			}
			
			return null;
		}
	}
}
