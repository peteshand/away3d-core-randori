/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package away.traverse
{
	import away.base.IRenderable;
	import away.materials.MaterialBase;
	import away.entities.Entity;
	import away.data.RenderableListItem;
	import away.lights.LightBase;
	import away.lights.DirectionalLight;
	import away.lights.PointLight;
	import away.lights.LightProbe;
	public class ShadowCasterCollector extends EntityCollector
	{
		public function ShadowCasterCollector():void
		{
			super();
		}
		
		//@override
		override public function applyRenderable(renderable:IRenderable):void
		{
			// the test for material is temporary, you SHOULD be hammered with errors if you try to render anything without a material
			var material:MaterialBase = renderable.material;
			var entity:Entity = renderable.sourceEntity;
			if( renderable.castsShadows && material )
			{
				var item:RenderableListItem = this._pRenderableListItemPool.getItem();
				item.renderable = renderable;
				item.next = this._pOpaqueRenderableHead;
				item.cascaded = false;
				var dx:Number = this._iEntryPoint.x - entity.x;
				var dy:Number = this._iEntryPoint.y - entity.y;
				var dz:Number = this._iEntryPoint.z - entity.z;
				item.zIndex = dx * this._pCameraForward.x + dy * this._pCameraForward.y + dz * this._pCameraForward.z;
				item.renderSceneTransform = renderable.getRenderSceneTransform( this._pCamera );
				item.renderOrderId = material._iDepthPassId;
				this._pOpaqueRenderableHead = item;
			}
		}
		
		//@override
		override public function applyUnknownLight(light:LightBase):void
		{
		}
		
		//@override

		override public function applyDirectionalLight(light:DirectionalLight):void
		{
		}
		
		//@override
		override public function applyPointLight(light:PointLight):void
		{
		}
		
		//@override

		override public function applyLightProbe(light:LightProbe):void
		{
		}
		
		//@override
		override public function applySkyBox(renderable:IRenderable):void
		{
		}
	}
}