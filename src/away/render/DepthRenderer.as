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

	/**
	public class DepthRenderer extends RendererBase
	{
		private var _activeMaterial:MaterialBase;
		private var _renderBlended:Boolean;
		private var _distanceBased:Boolean;
		private var _disableColor:Boolean;
		
		/**
		public function DepthRenderer(renderBlended:Boolean = false, distanceBased:Boolean = false):void
		{
			super();

			this._renderBlended = renderBlended;
            this._distanceBased = distanceBased;
            this.iBackgroundR = 1;
            this.iBackgroundG = 1;
            this.iBackgroundB = 1;

		}
		
		public function get disableColor():Boolean
		{
			return _disableColor;
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

			_pRenderTarget = target;
			_pRenderTargetSurface = 0;

			_pRenderableSorter.sort(entityCollector);

			_pStage3DProxy.setRenderTarget(target, true, 0);
			_pContext.clear(1, 1, 1, 1, 1, 0);

			_pContext.setBlendFactors(Context3DBlendFactor.ONE, Context3DBlendFactor.ZERO);
			_pContext.setDepthTest(true, Context3DCompareMode.LESS);
			
			var head:RenderableListItem = entityCollector.opaqueRenderableHead;

			var first:Boolean = true;

			for (var i:Number = numCascades - 1; i >= 0; --i)
            {
				_pStage3DProxy.scissorRect = scissorRects[i];
				drawCascadeRenderables(head, cameras[i], first? null : cameras[i].frustumPlanes);
				first = false;
			}
			
			if (_activeMaterial)
            {

                _activeMaterial.iDeactivateForDepth(_pStage3DProxy);

            }

			
			_activeMaterial = null;
			
			//line required for correct rendering when using away3d with starling. DO NOT REMOVE UNLESS STARLING INTEGRATION IS RETESTED!
			_pContext.setDepthTest(false, Context3DCompareMode.LESS_EQUAL);
			
			_pStage3DProxy.scissorRect = null;

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

					if (_activeMaterial != material)
                    {
						if (_activeMaterial)
                        {

                            _activeMaterial.iDeactivateForDepth(_pStage3DProxy);

                        }

                        _activeMaterial = material;
                        _activeMaterial.iActivateForDepth(_pStage3DProxy, camera, false);
					}

                    _activeMaterial.iRenderDepth(renderable, _pStage3DProxy, camera, camera.viewProjection);

				}
                else
                {

                    item.cascaded = true;
                    
                }

				
				item = item.next;
			}
		}
		
		/**
		override public function pDraw(entityCollector:EntityCollector, target:TextureBase):void
		{

			_pContext.setBlendFactors(Context3DBlendFactor.ONE, Context3DBlendFactor.ZERO);

            _pContext.setDepthTest(true, Context3DCompareMode.LESS);

            drawRenderables(entityCollector.opaqueRenderableHead, entityCollector);
			
			if (_disableColor)
                _pContext.setColorMask(false, false, false, false);
			
			if (_renderBlended)
                drawRenderables(entityCollector.blendedRenderableHead, entityCollector);
			
			if (_activeMaterial)
                _activeMaterial.iDeactivateForDepth(_pStage3DProxy);
			
			if (_disableColor)
                _pContext.setColorMask(true, true, true, true);

            _activeMaterial = null;

		}
		
		/**
		private function drawRenderables(item:RenderableListItem, entityCollector:EntityCollector):void
		{
			var camera:Camera3D = entityCollector.camera;
			var item2:RenderableListItem;
			
			while (item)
            {

				_activeMaterial = item.renderable.material;
				
				// otherwise this would result in depth rendered anyway because fragment shader kil is ignored
				if (_disableColor && _activeMaterial.iHasDepthAlphaThreshold())
                {

					item2 = item;
					// fast forward
					do{

                        item2 = item2.next;

                    } while (item2 && item2.renderable.material == _activeMaterial);

				}
                else
                {
					_activeMaterial.iActivateForDepth(_pStage3DProxy, camera, _distanceBased);
					item2 = item;
					do {

                        _activeMaterial.iRenderDepth(item2.renderable, _pStage3DProxy, camera, _pRttViewProjectionMatrix);
						item2 = item2.next;

					} while (item2 && item2.renderable.material == _activeMaterial);

					_activeMaterial.iDeactivateForDepth(_pStage3DProxy);

				}

				item = item2;

			}
		}
	}
}