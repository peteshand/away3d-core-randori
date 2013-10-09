/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package away.core.render
{
	import away.materials.MaterialBase;
	import away.core.geom.Matrix3D;
	import away.managers.Stage3DProxy;
	import away.core.traverse.EntityCollector;
	import away.core.display3D.TextureBase;
	import away.core.geom.Rectangle;
	import away.lights.DirectionalLight;
	import away.lights.PointLight;
	import away.lights.LightBase;
	import away.lights.shadowmaps.ShadowMapperBase;
	import away.core.display3D.Context3DBlendFactor;
	import away.core.display3D.Context3DCompareMode;
	import away.core.base.IRenderable;
	import away.cameras.Camera3D;
	import away.core.geom.Vector3D;
	import away.core.data.RenderableListItem;

	/**	 * The DefaultRenderer class provides the default rendering method. It renders the scene graph objects using the	 * materials assigned to them.	 */
	public class DefaultRenderer extends RendererBase
	{
		private static var RTT_PASSES:Number = 1;
		private static var SCREEN_PASSES:Number = 2;
		private static var ALL_PASSES:Number = 3;

		private var _activeMaterial:MaterialBase;
		private var _pDistanceRenderer:DepthRenderer;
		private var _pDepthRenderer:DepthRenderer;
		private var _skyboxProjection:Matrix3D = new Matrix3D();
		
		/**		 * Creates a new DefaultRenderer object.		 * @param antiAlias The amount of anti-aliasing to use.		 * @param renderMode The render mode to use.		 */
		public function DefaultRenderer():void
		{
			super(false);
			
			this._pDepthRenderer = new DepthRenderer();
            this._pDistanceRenderer = new DepthRenderer(false, true);

		}
		
		override public function set iStage3DProxy(value:Stage3DProxy):void
		{

			super.iSetStage3DProxy(value );
			this._pDistanceRenderer.iStage3DProxy = value;
			this._pDepthRenderer.iStage3DProxy = value;


		}

        override public function pExecuteRender(entityCollector:EntityCollector, target:TextureBase = null, scissorRect:Rectangle = null, surfaceSelector:Number = 0):void
		{
			target = target || null;
			scissorRect = scissorRect || null;
			surfaceSelector = surfaceSelector || 0;


			this.updateLights(entityCollector);
			
			// otherwise RTT will interfere with other RTTs

			if (target)
            {

				this.drawRenderables(entityCollector.opaqueRenderableHead, entityCollector, DefaultRenderer.RTT_PASSES);
                this.drawRenderables(entityCollector.blendedRenderableHead, entityCollector, DefaultRenderer.RTT_PASSES);

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

                    shadowMapper.iRenderDepthMap( this._pStage3DProxy, entityCollector, this._pDepthRenderer);
                    
                }
					
			}
			
			len = pointLights.length;
            
			for (i = 0; i < len; ++i) 
            {
                
				light = pointLights[i];
                
				shadowMapper = light.shadowMapper;
                
				if (light.castsShadows && (shadowMapper.autoUpdateShadows || shadowMapper._iShadowsInvalid))
                {

                    shadowMapper.iRenderDepthMap(this._pStage3DProxy, entityCollector, this._pDistanceRenderer);
                    
                }
					
			}
		}
		
		/**		 * @inheritDoc		 */
		override public function pDraw(entityCollector:EntityCollector, target:TextureBase):void
		{

			this._pContext.setBlendFactors(Context3DBlendFactor.ONE, Context3DBlendFactor.ZERO);

			if (entityCollector.skyBox)
            {
				if (this._activeMaterial)
                {

                    this._activeMaterial.iDeactivate(this._pStage3DProxy);

                }

				this._activeMaterial = null;
				
				this._pContext.setDepthTest(false, Context3DCompareMode.ALWAYS);
				this.drawSkyBox(entityCollector);

			}
			
			this._pContext.setDepthTest(true, Context3DCompareMode.LESS_EQUAL);
			
			var which:Number = target? DefaultRenderer.SCREEN_PASSES : DefaultRenderer.ALL_PASSES;

			this.drawRenderables(entityCollector.opaqueRenderableHead, entityCollector, which);
            this.drawRenderables(entityCollector.blendedRenderableHead, entityCollector, which);
			
			this._pContext.setDepthTest(false, Context3DCompareMode.LESS_EQUAL);
			
			if (this._activeMaterial)
            {

                this._activeMaterial.iDeactivate(this._pStage3DProxy);

            }

			
			this._activeMaterial = null;

		}
		
		/**		 * Draw the skybox if present.		 * @param entityCollector The EntityCollector containing all potentially visible information.		 */
		private function drawSkyBox(entityCollector:EntityCollector):void
		{
			var skyBox:IRenderable = entityCollector.skyBox;

			var material:MaterialBase = skyBox.material;

			var camera:Camera3D = entityCollector.camera;
			
			this.updateSkyBoxProjection(camera);
			
			material.iActivatePass(0, this._pStage3DProxy, camera);
			material.iRenderPass(0, skyBox, this._pStage3DProxy, entityCollector, this._skyboxProjection);
			material.iDeactivatePass(0, this._pStage3DProxy);

		}
		
		private function updateSkyBoxProjection(camera:Camera3D):void
		{

			var near:Vector3D = new Vector3D();

			this._skyboxProjection.copyFrom(this._pRttViewProjectionMatrix);
            this._skyboxProjection.copyRowTo(2, near);

			var camPos:Vector3D = camera.scenePosition;
			
			var cx:Number = near.x;
			var cy:Number = near.y;
			var cz:Number = near.z;
			var cw:Number = -(near.x*camPos.x + near.y*camPos.y + near.z*camPos.z + Math.sqrt(cx*cx + cy*cy + cz*cz));

			var signX:Number = cx >= 0? 1 : -1;
			var signY:Number = cy >= 0? 1 : -1;

			var p:Vector3D = new Vector3D(signX, signY, 1, 1);

			var inverse:Matrix3D = this._skyboxProjection.clone();
			    inverse.invert();

			var q:Vector3D = inverse.transformVector(p);

			this._skyboxProjection.copyRowTo(3, p);

			var a:Number = (q.x*p.x + q.y*p.y + q.z*p.z + q.w*p.w)/(cx*q.x + cy*q.y + cz*q.z + cw*q.w);

			this._skyboxProjection.copyRowFrom(2, new Vector3D(cx*a, cy*a, cz*a, cw*a));
		
		}
		
		/**		 * Draw a list of renderables.		 * @param renderables The renderables to draw.		 * @param entityCollector The EntityCollector containing all potentially visible information.		 */
		private function drawRenderables(item:RenderableListItem, entityCollector:EntityCollector, which:Number):void
		{
			var numPasses:Number;
			var j:Number;
			var camera:Camera3D = entityCollector.camera;
			var item2:RenderableListItem;
			
			while (item)
            {

                //console.log( 'DefaultRenderer' , 'drawRenderables' , item );
				this._activeMaterial = item.renderable.material;

				this._activeMaterial.iUpdateMaterial( this._pContext);

				numPasses = this._activeMaterial._iNumPasses;

				j = 0;
				
				do
                {

					item2 = item;

					var rttMask:Number = this._activeMaterial.iPassRendersToTexture(j)? 1 : 2;
					
					if ((rttMask & which) != 0)
                    {
						this._activeMaterial.iActivatePass(j, this._pStage3DProxy, camera);

						do {
							this._activeMaterial.iRenderPass(j, item2.renderable, this._pStage3DProxy, entityCollector, this._pRttViewProjectionMatrix);

							item2 = item2.next;

						} while (item2 && item2.renderable.material == this._activeMaterial);

						this._activeMaterial.iDeactivatePass(j, this._pStage3DProxy);

					}
                    else
                    {

						do{

                            item2 = item2.next;

                        }
						while (item2 && item2.renderable.material == this._activeMaterial);

					}
					
				} while (++j < numPasses);
				
				item = item2;
			}
		}
		
		override public function iDispose():void
		{
			super.iDispose();

			this._pDepthRenderer.iDispose();
            this._pDistanceRenderer.iDispose();
            this._pDepthRenderer = null;
            this._pDistanceRenderer = null;

		}
	}
}
