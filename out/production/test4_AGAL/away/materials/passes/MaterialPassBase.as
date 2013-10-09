/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package away.materials.passes
{
	import away.events.EventDispatcher;
	import away.materials.MaterialBase;
	import away.animators.IAnimationSet;
	import away.core.display3D.Program3D;
	import away.core.display3D.Context3D;
	import away.core.display3D.Context3DCompareMode;
	import away.core.display3D.Context3DBlendFactor;
	import away.materials.lightpickers.LightPickerBase;
	import away.utils.VectorInit;
	import away.core.display3D.Context3DTriangleFace;
	import away.core.display3D.TextureBase;
	import away.core.geom.Rectangle;
	import away.events.Event;
	import away.managers.AGALProgram3DCache;
	import away.core.base.IRenderable;
	import away.managers.Stage3DProxy;
	import away.cameras.Camera3D;
	import away.core.geom.Matrix3D;
	import away.errors.AbstractMethodError;
	import away.core.display.BlendMode;
	import away.errors.ArgumentError;
	import away.utils.VectorInit;
	//import away3d.animators.data.AnimationRegisterCache;
	//import away3d.animators.IAnimationSet;
	//import away3d.arcane;
	//import away3d.cameras.Camera3D;
	//import away3d.core.base.IRenderable;
	//import away3d.managers.AGALProgram3DCache;
	//import away3d.managers.Stage3DProxy;
	//import away3d.debug.Debug;
	//import away3d.errors.AbstractMethodError;
	//import away3d.materials.MaterialBase;
	//import away3d.materials.lightpickers.LightPickerBase;
	
	//import flash.display.BlendMode;
	//import flash.display3D.Context3D;
	//import flash.display3D.Context3DBlendFactor;
	//import flash.display3D.Context3DCompareMode;
	//import flash.display3D.Context3DTriangleFace;
	//import flash.display3D.Program3D;
	//import flash.display3D.textures.TextureBase;
	//import flash.events.Event;
	//import flash.events.EventDispatcher;
	//import flash.geom.Matrix3D;
	//import flash.geom.Rectangle;
	
	//use namespace arcane;
	
	/**	 * MaterialPassBase provides an abstract base class for material shader passes. A material pass constitutes at least	 * a render call per required renderable.	 */
	public class MaterialPassBase extends EventDispatcher
	{
        public var _pMaterial:MaterialBase;
		private var _animationSet:IAnimationSet;

        public var _iProgram3Ds:Vector.<Program3D> = VectorInit.AnyClass(Program3D,  8 );
        public var _iProgram3Dids:Vector.<Number> = new <Number>[-1, -1, -1, -1, -1, -1, -1, -1];//Vector.<int> = Vector.<int>([-1, -1, -1, -1, -1, -1, -1, -1])
		private var _context3Ds:Vector.<Context3D> = VectorInit.AnyClass(Context3D,  8 );//Vector.<Context3D> = VectorInit.AnyClass(Context3D, 8)
		
		// agal props. these NEED to be set by subclasses!
		// todo: can we perhaps figure these out manually by checking read operations in the bytecode, so other sources can be safely updated?
        public var _pNumUsedStreams:Number = 0;
        public var _pNumUsedTextures:Number = 0;
        public var _pNumUsedVertexConstants:Number = 0;
        public var _pNumUsedFragmentConstants:Number = 0;
        public var _pNumUsedVaryings:Number = 0;

        public var _pSmooth:Boolean = true;
        public var _pRepeat:Boolean = false;
        public var _pMipmap:Boolean = true;
		private var _depthCompareMode:String = Context3DCompareMode.LESS_EQUAL;
		
		private var _blendFactorSource:String = Context3DBlendFactor.ONE;
		private var _blendFactorDest:String = Context3DBlendFactor.ZERO;

        public var _pEnableBlending:Boolean = false;
		
		public var _pBothSides:Boolean = false;
		
		public var _pLightPicker:LightPickerBase;

        // TODO: AGAL conversion
        public var _pAnimatableAttributes:Vector.<String> = VectorInit.Str();

        // TODO: AGAL conversion
        public var _pAnimationTargetRegisters:Vector.<String> = VectorInit.Str();

        // TODO: AGAL conversion
        public var _pShadedTarget:String = "ft0";
		
		// keep track of previously rendered usage for faster cleanup of old vertex buffer streams and textures
		private static var _previousUsedStreams:Vector.<Number> = new <Number>[0, 0, 0, 0, 0, 0, 0, 0];//Vector.<int> = Vector.<int>([0, 0, 0, 0, 0, 0, 0, 0])
		private static var _previousUsedTexs:Vector.<Number> = new <Number>[0, 0, 0, 0, 0, 0, 0, 0];//Vector.<int> = Vector.<int>([0, 0, 0, 0, 0, 0, 0, 0])
		private var _defaultCulling:String = Context3DTriangleFace.BACK;
		
		private var _renderToTexture:Boolean = false;
		
		// render state mementos for render-to-texture passes
		private var _oldTarget:TextureBase;
		private var _oldSurface:Number = 0;
		private var _oldDepthStencil:Boolean = false;
		private var _oldRect:Rectangle;

        public var _pAlphaPremultiplied:Boolean = false;
        public var _pNeedFragmentAnimation:Boolean = false;
        public var _pNeedUVAnimation:Boolean = false;
        public var _pUVTarget:String = null;
        public var _pUVSource:String = null;
		
		private var _writeDepth:Boolean = true;
		
		//public animationRegisterCache:AnimationRegisterCache; TODO: implement dependency AnimationRegisterCache
		
		/**		 * Creates a new MaterialPassBase object.		 *		 * @param renderToTexture Indicates whether this pass is a render-to-texture pass.		 */
		public function MaterialPassBase(renderToTexture:Boolean):void
		{

            super();
			
			_pAnimatableAttributes.push( "va0");
			_pAnimationTargetRegisters.push( "vt0" );
		
			this._renderToTexture = renderToTexture;
            this._pNumUsedStreams = 1;
            this._pNumUsedVertexConstants = 5;

		}
		
		/**		 * The material to which this pass belongs.		 */
		public function get material():MaterialBase
		{
			return this._pMaterial;
		}
		
		public function set material(value:MaterialBase):void
		{
			this._pMaterial = value;
		}
		
		/**		 * Indicate whether this pass should write to the depth buffer or not. Ignored when blending is enabled.		 */
		public function get writeDepth():Boolean
		{
			return this._writeDepth;
		}
		
		public function set writeDepth(value:Boolean):void
		{
			this._writeDepth = value;
		}
		
		/**		 * Defines whether any used textures should use mipmapping.		 */
		public function get mipmap():Boolean
		{
			return this._pMipmap;
		}
		
		public function set mipmap(value:Boolean):void
		{

            this.setMipMap( value );

		}

        public function setMipMap(value:Boolean):void
        {

            if (this._pMipmap == value)
            {

                return;

            }

            this._pMipmap = value;
            this.iInvalidateShaderProgram( );

        }
		/**		 * Defines whether smoothing should be applied to any used textures.		 */
		public function get smooth():Boolean
		{
			return this._pSmooth;
		}
		
		public function set smooth(value:Boolean):void
		{
			if (this._pSmooth == value)
            {

                return;

            }

			this._pSmooth = value;
            this.iInvalidateShaderProgram( );
		}
		
		/**		 * Defines whether textures should be tiled.		 */
		public function get repeat():Boolean
		{
			return this._pRepeat;
		}
		
		public function set repeat(value:Boolean):void
		{
			if (this._pRepeat == value)
            {

                return;

            }

			this._pRepeat = value;
            this.iInvalidateShaderProgram( );
		}
		
		/**		 * Defines whether or not the material should perform backface culling.		 */
		public function get bothSides():Boolean
		{
			return this._pBothSides;
		}
		
		public function set bothSides(value:Boolean):void
		{
            this._pBothSides = value;
		}

		/**		 * The depth compare mode used to render the renderables using this material.		 *		 * @see flash.display3D.Context3DCompareMode		 */
		public function get depthCompareMode():String
		{
			return this._depthCompareMode;
		}
		
		public function set depthCompareMode(value:String):void
		{
            this._depthCompareMode = value;
		}

		/**		 * Returns the animation data set adding animations to the material.		 */
		public function get animationSet():IAnimationSet
		{
			return this._animationSet;
		}
		
		public function set animationSet(value:IAnimationSet):void
		{
			if (this._animationSet == value)
            {

                return;

            }

			
			this._animationSet = value;

            this.iInvalidateShaderProgram( );
		}
		
		/**		 * Specifies whether this pass renders to texture		 */
		public function get renderToTexture():Boolean
		{
			return this._renderToTexture;
		}
		
		/**		 * Cleans up any resources used by the current object.		 * @param deep Indicates whether other resources should be cleaned up, that could potentially be shared across different instances.		 */
		public function dispose():void
		{
			if (this._pLightPicker)
            {

                this._pLightPicker.removeEventListener(Event.CHANGE, onLightsChange , this );

            }

			
			for (var i:Number = 0; i < 8; ++i)
            {

				if (this._iProgram3Ds[i])
                {

                    //away.Debug.throwPIR( 'away.materials.MaterialPassBase' , 'dispose' , 'required dependency: AGALProgram3DCache');
					AGALProgram3DCache.getInstanceFromIndex(i).freeProgram3D(this._iProgram3Dids[i]);
					this._iProgram3Ds[i] = null;

				}
			}
		}
		
		/**		 * The amount of used vertex streams in the vertex code. Used by the animation code generation to know from which index on streams are available.		 */
		public function get numUsedStreams():Number
		{
			return this._pNumUsedStreams;
		}
		
		/**		 * The amount of used vertex constants in the vertex code. Used by the animation code generation to know from which index on registers are available.		 */
		public function get numUsedVertexConstants():Number
		{
			return this._pNumUsedVertexConstants;
		}
		
		public function get numUsedVaryings():Number
		{
			return this._pNumUsedVaryings;
		}

		/**		 * The amount of used fragment constants in the fragment code. Used by the animation code generation to know from which index on registers are available.		 */
		public function get numUsedFragmentConstants():Number
		{
			return this._pNumUsedFragmentConstants;
		}
		
		public function get needFragmentAnimation():Boolean
		{
			return this._pNeedFragmentAnimation;
		}

		/**		 * Indicates whether the pass requires any UV animatin code.		 */
		public function get needUVAnimation():Boolean
		{
			return this._pNeedUVAnimation;
		}
		
		/**		 * Sets up the animation state. This needs to be called before render()		 *		 * @private		 */
		public function iUpdateAnimationState(renderable:IRenderable, stage3DProxy:Stage3DProxy, camera:Camera3D):void
		{
			renderable.animator.setRenderState(stage3DProxy, renderable, this._pNumUsedVertexConstants, this._pNumUsedStreams, camera);
		}
		
		/**		 * Renders an object to the current render target.		 *		 * @private		 */
		public function iRender(renderable:IRenderable, stage3DProxy:Stage3DProxy, camera:Camera3D, viewProjection:Matrix3D):void
		{
			throw new AbstractMethodError();
		}

		/**		 * Returns the vertex AGAL code for the material.		 */
		public function iGetVertexCode():String
		{
            throw new AbstractMethodError();
		}

		/**		 * Returns the fragment AGAL code for the material.		 */
		public function iGetFragmentCode(fragmentAnimatorCode:String):String
		{
            throw new AbstractMethodError();
		}

		/**		 * The blend mode to use when drawing this renderable. The following blend modes are supported:		 * <ul>		 * <li>BlendMode.NORMAL: No blending, unless the material inherently needs it</li>		 * <li>BlendMode.LAYER: Force blending. This will draw the object the same as NORMAL, but without writing depth writes.</li>		 * <li>BlendMode.MULTIPLY</li>		 * <li>BlendMode.ADD</li>		 * <li>BlendMode.ALPHA</li>		 * </ul>		 */
		public function setBlendMode(value:String):void
		{
			switch (value)
            {

				case BlendMode.NORMAL:

					this._blendFactorSource = Context3DBlendFactor.ONE;
					this._blendFactorDest = Context3DBlendFactor.ZERO;
					this._pEnableBlending = false;

					break;

				case BlendMode.LAYER:

					this._blendFactorSource = Context3DBlendFactor.SOURCE_ALPHA;
                    this._blendFactorDest = Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA;
                    this._pEnableBlending = true;

					break;

				case BlendMode.MULTIPLY:

					this._blendFactorSource = Context3DBlendFactor.ZERO;
                    this._blendFactorDest = Context3DBlendFactor.SOURCE_COLOR;
                    this._pEnableBlending = true;

					break;

				case BlendMode.ADD:

					this._blendFactorSource = Context3DBlendFactor.SOURCE_ALPHA;
                    this._blendFactorDest =  Context3DBlendFactor.ONE;
                    this._pEnableBlending = true;

					break;

				case BlendMode.ALPHA:

					this._blendFactorSource = Context3DBlendFactor.ZERO;
					this._blendFactorDest = Context3DBlendFactor.SOURCE_ALPHA;
					this._pEnableBlending = true;

					break;

				default:

					throw new away.errors.ArgumentError("Unsupported blend mode!");

			}
		}

		/**		 * Sets the render state for the pass that is independent of the rendered object. This needs to be called before		 * calling renderPass. Before activating a pass, the previously used pass needs to be deactivated.		 * @param stage3DProxy The Stage3DProxy object which is currently used for rendering.		 * @param camera The camera from which the scene is viewed.		 * @private		 */
		public function iActivate(stage3DProxy:Stage3DProxy, camera:Camera3D):void
		{
			var contextIndex:Number = stage3DProxy._iStage3DIndex;//_stage3DIndex;
			var context:Context3D = stage3DProxy._iContext3D;

			context.setDepthTest( ( this._writeDepth && ! this._pEnableBlending ) , this._depthCompareMode);

			if (this._pEnableBlending)
            {

                context.setBlendFactors( this._blendFactorSource, this._blendFactorDest);

            }

			if ( this._context3Ds[contextIndex] != context || ! this._iProgram3Ds[contextIndex])
            {

				this._context3Ds[contextIndex] = context;

                this.iUpdateProgram( stage3DProxy );
				this.dispatchEvent(new Event(Event.CHANGE));

			}

			var prevUsed:Number = MaterialPassBase._previousUsedStreams[contextIndex];
			var i:Number;

			for (i = this._pNumUsedStreams; i < prevUsed; ++i)
            {

                context.setVertexBufferAt(i, null);

            }

			
			prevUsed = MaterialPassBase._previousUsedTexs[contextIndex];
			
			for (i = this._pNumUsedTextures; i < prevUsed; ++i)
            {

                context.setTextureAt(i, null);

            }

			
			if ( this._animationSet && ! this._animationSet.usesCPU)
            {

                this._animationSet.activate(stage3DProxy, this);

            }


			context.setProgram(this._iProgram3Ds[contextIndex]);
			
			context.setCulling(this._pBothSides? Context3DTriangleFace.NONE : this._defaultCulling);
			
			if (this._renderToTexture)
            {
				this._oldTarget = stage3DProxy.renderTarget;
                this._oldSurface = stage3DProxy.renderSurfaceSelector;
                this._oldDepthStencil = stage3DProxy.enableDepthAndStencil;
                this._oldRect = stage3DProxy.scissorRect;
			}
		}

		/**		 * Clears the render state for the pass. This needs to be called before activating another pass.		 * @param stage3DProxy The Stage3DProxy used for rendering		 *		 * @private		 */
		public function iDeactivate(stage3DProxy:Stage3DProxy):void
		{

			var index:Number = stage3DProxy._iStage3DIndex;//_stage3DIndex;
			MaterialPassBase._previousUsedStreams[index] = this._pNumUsedStreams;
            MaterialPassBase._previousUsedTexs[index] = this._pNumUsedTextures;
			
			if (this._animationSet && !this._animationSet.usesCPU)
            {

                this._animationSet.deactivate(stage3DProxy, this);

            }

			
			if ( this._renderToTexture)
            {

				// kindly restore state
				stage3DProxy.setRenderTarget(this._oldTarget, this._oldDepthStencil, this._oldSurface);
				stage3DProxy.scissorRect = this._oldRect;

			}

			stage3DProxy._iContext3D.setDepthTest(true, Context3DCompareMode.LESS_EQUAL); // TODO : imeplement
		}
		
		/**		 * Marks the shader program as invalid, so it will be recompiled before the next render.		 *		 * @param updateMaterial Indicates whether the invalidation should be performed on the entire material. Should always pass "true" unless it's called from the material itself.		 */
		public function iInvalidateShaderProgram(updateMaterial:Boolean = true):void
		{
			updateMaterial = updateMaterial || true;

			for (var i:Number = 0; i < 8; ++i)
            {

                this._iProgram3Ds[i] = null;

            }

			
			if (this._pMaterial && updateMaterial)
            {

                this._pMaterial.iInvalidatePasses(this);

            }

		}
		
		/**		 * Compiles the shader program.		 * @param polyOffsetReg An optional register that contains an amount by which to inflate the model (used in single object depth map rendering).		 */
		public function iUpdateProgram(stage3DProxy:Stage3DProxy):void
		{
			var animatorCode:String = "";
			var UVAnimatorCode:String = "";
			var fragmentAnimatorCode:String = "";
			var vertexCode:String = this.iGetVertexCode();//getVertexCode();
			
			if ( this._animationSet && ! this._animationSet.usesCPU)
            {

				animatorCode = this._animationSet.getAGALVertexCode(this, this._pAnimatableAttributes, this._pAnimationTargetRegisters, stage3DProxy.profile);

				if (this._pNeedFragmentAnimation)
                {

                    fragmentAnimatorCode = this._animationSet.getAGALFragmentCode(this, this._pShadedTarget, stage3DProxy.profile);

                }

				if ( this._pNeedUVAnimation)
                {

                    UVAnimatorCode = this._animationSet.getAGALUVCode(this, this._pUVSource, this._pUVTarget);

                }

				this._animationSet.doneAGALCode(this);

			}
            else
            {
				var len:Number = this._pAnimatableAttributes.length;
				
				// simply write attributes to targets, do not animate them
				// projection will pick up on targets[0] to do the projection
				for (var i:Number = 0; i < len; ++i)
                {
                    // TODO: AGAL <> GLSL conversion:
                    //away.Debug.throwPIR( 'away.materials.MaterialPassBase' , 'iUpdateProgram' , 'AGAL <> GLSL Conversion');
                    animatorCode += "mov " + this._pAnimationTargetRegisters[i] + ", " + this._pAnimatableAttributes[i] + "\n";

                }

				if (this._pNeedUVAnimation)
                {

                    //away.Debug.throwPIR( 'away.materials.MaterialPassBase' , 'iUpdateProgram' , 'AGAL <> GLSL Conversion');
                    // TODO: AGAL <> GLSL conversion
                    UVAnimatorCode = "mov " + this._pUVTarget+ "," + this._pUVSource + "\n";

                }

			}
			
			vertexCode = animatorCode + UVAnimatorCode + vertexCode;
			
			var fragmentCode:String = this.iGetFragmentCode( fragmentAnimatorCode );

            /*			if (this.Debug.active) {				trace("Compiling AGAL Code:");				trace("--------------------");				trace(vertexCode);				trace("--------------------");				trace(fragmentCode);			}			*/

			AGALProgram3DCache.getInstance(stage3DProxy).setProgram3D(this, vertexCode, fragmentCode);

		}

		/**		 * The light picker used by the material to provide lights to the material if it supports lighting.		 *		 * @see away3d.materials.lightpickers.LightPickerBase		 * @see away3d.materials.lightpickers.StaticLightPicker		 */
		public function get lightPicker():LightPickerBase
		{
			return this._pLightPicker;
		}
		
		public function set lightPicker(value:LightPickerBase):void
		{
			if ( this._pLightPicker)
            {

                this._pLightPicker.removeEventListener(Event.CHANGE, onLightsChange , this );

            }

			this._pLightPicker = value;

			if (this._pLightPicker)
            {

                this._pLightPicker.addEventListener(Event.CHANGE, onLightsChange , this );

            }

            this.pUpdateLights();

		}

		/**		 * Called when the light picker's configuration changes.		 */
		private function onLightsChange(event:Event):void
		{
            this.pUpdateLights();

		}

		/**		 * Implemented by subclasses if the pass uses lights to update the shader.		 */
		public function pUpdateLights():void
		{
		
		}

		/**		 * Indicates whether visible textures (or other pixels) used by this material have		 * already been premultiplied. Toggle this if you are seeing black halos around your		 * blended alpha edges.		 */
		public function get alphaPremultiplied():Boolean
		{
			return this._pAlphaPremultiplied;
		}
		
		public function set alphaPremultiplied(value:Boolean):void
		{
            this._pAlphaPremultiplied = value;
            this.iInvalidateShaderProgram( false );
		}
	}
}
