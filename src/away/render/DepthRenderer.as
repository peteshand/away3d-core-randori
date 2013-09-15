///<reference path="../_definitions.ts"/>

package away.render
{
	import away.materials.MaterialBase;
	import away.traverse.EntityCollector;
	import away.display3D.TextureBase;
	import away.geom.Rectangle;
	import away.cameras.Camera3D;
	import away.display3D.Context3DBlendFactor;
	import away.display3D.Context3DCompareMode;
	import away.data.RenderableListItem;
	import away.math.Plane3D;
	import away.base.IRenderable;
	import away.entities.Entity;

	/**	 * The DepthRenderer class renders 32-bit depth information encoded as RGBA	 */
	public class DepthRenderer extends RendererBase
	{
		private var _activeMaterial:MaterialBase;
		private var _renderBlended:Boolean;
		private var _distanceBased:Boolean;
		private var _disableColor:Boolean;
		
		/**		 * Creates a new DepthRenderer object.		 * @param renderBlended Indicates whether semi-transparent objects should be rendered.		 * @param distanceBased Indicates whether the written depth value is distance-based or projected depth-based		 */
		public function DepthRenderer(renderBlended:Boolean = false, distanceBased:Boolean = false):void
		{
			super(false);
			
			this._renderBlended = renderBlended;
            this._distanceBased = distanceBased;
            this.iBackgroundR = 1;
            this.iBackgroundG = 1;
            this.iBackgroundB = 1;

		}
		
		public function get disableColor():Boolean
		{
			return this._disableColor;
		}
		
		public function set disableColor(value:Boolean):void
		{
            this._disableColor = value;
		}
		
		override public function set iBackgroundR(value:Number):void
		{
		}

        override public function set iBackgroundG(value:Number):void
		{
		}

        override public function set iBackgroundB(value:Number):void
		{
		}
		
		public function iRenderCascades(entityCollector:EntityCollector, target:TextureBase, numCascades:Number, scissorRects:Vector.<Rectangle>, cameras:Vector.<Camera3D>):void
		{

			this._pRenderTarget = target;
			this._pRenderTargetSurface = 0;

			this._pRenderableSorter.sort(entityCollector);

			this._pStage3DProxy.setRenderTarget(target, true, 0);
			this._pContext.clear(1, 1, 1, 1, 1, 0);

			this._pContext.setBlendFactors(Context3DBlendFactor.ONE, Context3DBlendFactor.ZERO);
			this._pContext.setDepthTest(true, Context3DCompareMode.LESS);
			
			var head:RenderableListItem = entityCollector.opaqueRenderableHead;

			var first:Boolean = true;

			for (var i:Number = numCascades - 1; i >= 0; --i)
            {
				this._pStage3DProxy.scissorRect = scissorRects[i];
				this.drawCascadeRenderables(head, cameras[i], first? null : cameras[i].frustumPlanes);
				first = false;
			}
			
			if (this._activeMaterial)
            {

                this._activeMaterial.iDeactivateForDepth(this._pStage3DProxy);

            }

			
			this._activeMaterial = null;
			
			//line required for correct rendering when using away3d with starling. DO NOT REMOVE UNLESS STARLING INTEGRATION IS RETESTED!
			this._pContext.setDepthTest(false, Context3DCompareMode.LESS_EQUAL);
			
			this._pStage3DProxy.scissorRect = null;

		}
		
		private function drawCascadeRenderables(item:RenderableListItem, camera:Camera3D, cullPlanes:Vector.<Plane3D>):void
		{
			var material:MaterialBase;
			
			while (item)
            {

				if (item.cascaded)
                {

					item = item.next;
					continue;

				}
				
				var renderable:IRenderable = item.renderable;

				var entity:Entity = renderable.sourceEntity;

				
				// if completely in front, it will fall in a different cascade
				// do not use near and far planes

				if (!cullPlanes || entity.worldBounds.isInFrustum(cullPlanes, 4))
                {

					material = renderable.material;

					if (this._activeMaterial != material)
                    {
						if (this._activeMaterial)
                        {

                            this._activeMaterial.iDeactivateForDepth(this._pStage3DProxy);

                        }

                        this._activeMaterial = material;
                        this._activeMaterial.iActivateForDepth(this._pStage3DProxy, camera, false);
					}

                    this._activeMaterial.iRenderDepth(renderable, this._pStage3DProxy, camera, camera.viewProjection);

				}
                else
                {

                    item.cascaded = true;
                    
                }

				
				item = item.next;
			}
		}
		
		/**		 * @inheritDoc		 */
		override public function pDraw(entityCollector:EntityCollector, target:TextureBase):void
		{

			this._pContext.setBlendFactors(Context3DBlendFactor.ONE, Context3DBlendFactor.ZERO);

            this._pContext.setDepthTest(true, Context3DCompareMode.LESS);

            this.drawRenderables(entityCollector.opaqueRenderableHead, entityCollector);
			
			if (this._disableColor)
                this._pContext.setColorMask(false, false, false, false);
			
			if (this._renderBlended)
                this.drawRenderables(entityCollector.blendedRenderableHead, entityCollector);
			
			if (this._activeMaterial)
                this._activeMaterial.iDeactivateForDepth(this._pStage3DProxy);
			
			if (this._disableColor)
                this._pContext.setColorMask(true, true, true, true);

            this._activeMaterial = null;

		}
		
		/**		 * Draw a list of renderables.		 * @param renderables The renderables to draw.		 * @param entityCollector The EntityCollector containing all potentially visible information.		 */
		private function drawRenderables(item:RenderableListItem, entityCollector:EntityCollector):void
		{
			var camera:Camera3D = entityCollector.camera;
			var item2:RenderableListItem;
			
			while (item)
            {

				this._activeMaterial = item.renderable.material;
				
				// otherwise this would result in depth rendered anyway because fragment shader kil is ignored
				if (this._disableColor && this._activeMaterial.iHasDepthAlphaThreshold())
                {

					item2 = item;
					// fast forward
					do{

                        item2 = item2.next;

                    } while (item2 && item2.renderable.material == this._activeMaterial);

				}
                else
                {
					this._activeMaterial.iActivateForDepth(this._pStage3DProxy, camera, this._distanceBased);
					item2 = item;
					do {

                        this._activeMaterial.iRenderDepth(item2.renderable, this._pStage3DProxy, camera, this._pRttViewProjectionMatrix);
						item2 = item2.next;

					} while (item2 && item2.renderable.material == this._activeMaterial);

					this._activeMaterial.iDeactivateForDepth(this._pStage3DProxy);

				}

				item = item2;

			}
		}
	}
}
