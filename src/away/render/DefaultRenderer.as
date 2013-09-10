///<reference path="../_definitions.ts"/>
package away.render
{
	import away.materials.MaterialBase;
	import away.geom.Matrix3D;
	import away.managers.Stage3DProxy;
	import away.traverse.EntityCollector;
	import away.display3D.TextureBase;
	import away.geom.Rectangle;
	import away.lights.DirectionalLight;
	import away.lights.PointLight;
	import away.lights.LightBase;
	import away.lights.shadowmaps.ShadowMapperBase;
	import away.display3D.Context3DBlendFactor;
	import away.display3D.Context3DCompareMode;
	import away.base.IRenderable;
	import away.cameras.Camera3D;
	import away.geom.Vector3D;
	import away.data.RenderableListItem;

	/**
	 * The DefaultRenderer class provides the default rendering method. It renders the scene graph objects using the
	 * materials assigned to them.
	 */
	public class DefaultRenderer extends RendererBase
	{
		private static var RTT_PASSES:Number = 1;
		private static var SCREEN_PASSES:Number = 2;
		private static var ALL_PASSES:Number = 3;

		private var _activeMaterial:MaterialBase;
		private var _pDistanceRenderer:DepthRenderer;
		private var _pDepthRenderer:DepthRenderer;
		private var _skyboxProjection:Matrix3D = new Matrix3D();
		
		/**
		 * Creates a new DefaultRenderer object.
		 * @param antiAlias The amount of anti-aliasing to use.
		 * @param renderMode The render mode to use.
		 */
		public function DefaultRenderer():void
		{
			super(false);
			
			_pDepthRenderer = new DepthRenderer();
            _pDistanceRenderer = new DepthRenderer(false, true);

		}
		
		override public function set iStage3DProxy(value:Stage3DProxy):void
		{

			super.iSetStage3DProxy(value );
			_pDistanceRenderer.iStage3DProxy = _pDepthRenderer.iStage3DProxy = value;

		}

        override public function pExecuteRender(entityCollector:EntityCollector, target:TextureBase = null, scissorRect:Rectangle = null, surfaceSelector:Number = 0):void
		{

			updateLights(entityCollector);
			
			// otherwise RTT will interfere with other RTTs

			if (target)
            {

				drawRenderables(entityCollector.opaqueRenderableHead, entityCollector, DefaultRenderer.RTT_PASSES);
                drawRenderables(entityCollector.blendedRenderableHead, entityCollector, DefaultRenderer.RTT_PASSES);

			}
			
			super.pExecuteRender(entityCollector, target, scissorRect, surfaceSelector);
		}
		
		private function updateLights(entityCollector:EntityCollector):void
		{
			var dirLights:Vector.<DirectionalLight> = entityCollector.directionalLights;
			var pointLights:Vector.<PointLight> = entityCollector.pointLights;
			var len:Number, i:Number;
			var light:LightBase;
			var shadowMapper:ShadowMapperBase;
			
			len = dirLights.length;
            
			for (i = 0; i < len; ++i) 
            {
                
				light = dirLights[i];
                
				shadowMapper = light.shadowMapper;
                
				if (light.castsShadows && (shadowMapper.autoUpdateShadows || shadowMapper._iShadowsInvalid ))
                {

                    shadowMapper.iRenderDepthMap( _pStage3DProxy, entityCollector, _pDepthRenderer);
                    
                }
					
			}
			
			len = pointLights.length;
            
			for (i = 0; i < len; ++i) 
            {
                
				light = pointLights[i];
                
				shadowMapper = light.shadowMapper;
                
				if (light.castsShadows && (shadowMapper.autoUpdateShadows || shadowMapper._iShadowsInvalid))
                {

                    shadowMapper.iRenderDepthMap(_pStage3DProxy, entityCollector, _pDistanceRenderer);
                    
                }
					
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function pDraw(entityCollector:EntityCollector, target:TextureBase):void
		{

			_pContext.setBlendFactors(Context3DBlendFactor.ONE, Context3DBlendFactor.ZERO);

			if (entityCollector.skyBox)
            {
				if (_activeMaterial)
                {

                    _activeMaterial.iDeactivate(_pStage3DProxy);

                }

				_activeMaterial = null;
				
				_pContext.setDepthTest(false, Context3DCompareMode.ALWAYS);
				drawSkyBox(entityCollector);

			}
			
			_pContext.setDepthTest(true, Context3DCompareMode.LESS_EQUAL);
			
			var which:Number = target? DefaultRenderer.SCREEN_PASSES : DefaultRenderer.ALL_PASSES;

			drawRenderables(entityCollector.opaqueRenderableHead, entityCollector, which);
            drawRenderables(entityCollector.blendedRenderableHead, entityCollector, which);
			
			_pContext.setDepthTest(false, Context3DCompareMode.LESS_EQUAL);
			
			if (_activeMaterial)
            {

                _activeMaterial.iDeactivate(_pStage3DProxy);

            }

			
			_activeMaterial = null;

		}
		
		/**
		 * Draw the skybox if present.
		 * @param entityCollector The EntityCollector containing all potentially visible information.
		 */
		private function drawSkyBox(entityCollector:EntityCollector):void
		{
			var skyBox:IRenderable = entityCollector.skyBox;

			var material:MaterialBase = skyBox.material;

			var camera:Camera3D = entityCollector.camera;
			
			updateSkyBoxProjection(camera);
			
			material.iActivatePass(0, _pStage3DProxy, camera);
			material.iRenderPass(0, skyBox, _pStage3DProxy, entityCollector, _skyboxProjection);
			material.iDeactivatePass(0, _pStage3DProxy);

		}
		
		private function updateSkyBoxProjection(camera:Camera3D):void
		{

			var near:Vector3D = new Vector3D();

			_skyboxProjection.copyFrom(_pRttViewProjectionMatrix);
            _skyboxProjection.copyRowTo(2, near);

			var camPos:Vector3D = camera.scenePosition;
			
			var cx:Number = near.x;
			var cy:Number = near.y;
			var cz:Number = near.z;
			var cw:Number = -(near.x*camPos.x + near.y*camPos.y + near.z*camPos.z + Math.sqrt(cx*cx + cy*cy + cz*cz));

			var signX:Number = cx >= 0? 1 : -1;
			var signY:Number = cy >= 0? 1 : -1;

			var p:Vector3D = new Vector3D(signX, signY, 1, 1);

			var inverse:Matrix3D = _skyboxProjection.clone();
			    inverse.invert();

			var q:Vector3D = inverse.transformVector(p);

			_skyboxProjection.copyRowTo(3, p);

			var a:Number = (q.x*p.x + q.y*p.y + q.z*p.z + q.w*p.w)/(cx*q.x + cy*q.y + cz*q.z + cw*q.w);

			_skyboxProjection.copyRowFrom(2, new Vector3D(cx*a, cy*a, cz*a, cw*a));
		
		}
		
		/**
		 * Draw a list of renderables.
		 * @param renderables The renderables to draw.
		 * @param entityCollector The EntityCollector containing all potentially visible information.
		 */
		private function drawRenderables(item:RenderableListItem, entityCollector:EntityCollector, which:Number):void
		{
			var numPasses:Number;
			var j:Number;
			var camera:Camera3D = entityCollector.camera;
			var item2:RenderableListItem;
			
			while (item)
            {

                //console.log( 'DefaultRenderer' , 'drawRenderables' , item );
				_activeMaterial = item.renderable.material;

				_activeMaterial.iUpdateMaterial( _pContext);

				numPasses = _activeMaterial._iNumPasses;

				j = 0;
				
				do
                {

					item2 = item;

					var rttMask:Number = _activeMaterial.iPassRendersToTexture(j)? 1 : 2;
					
					if ((rttMask & which) != 0)
                    {
						_activeMaterial.iActivatePass(j, _pStage3DProxy, camera);

						do {
							_activeMaterial.iRenderPass(j, item2.renderable, _pStage3DProxy, entityCollector, _pRttViewProjectionMatrix);

							item2 = item2.next;

						} while (item2 && item2.renderable.material == _activeMaterial);

						_activeMaterial.iDeactivatePass(j, _pStage3DProxy);

					}
                    else
                    {

						do{

                            item2 = item2.next;

                        }
						while (item2 && item2.renderable.material == _activeMaterial);

					}
					
				} while (++j < numPasses);
				
				item = item2;
			}
		}
		
		override public function iDispose():void
		{
			super.iDispose();

			_pDepthRenderer.iDispose();
            _pDistanceRenderer.iDispose();
            _pDepthRenderer = null;
            _pDistanceRenderer = null;

		}
	}
}
