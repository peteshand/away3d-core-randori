/** * ... * @author Gary Paluk - http://www.plugin.io */

///<reference path="../_definitions.ts"/>

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
				var item:RenderableListItem = _pRenderableListItemPool.getItem();
				item.renderable = renderable;
				item.next = _pOpaqueRenderableHead;
				item.cascaded = false;
				var dx:Number = _iEntryPoint.x - entity.x;
				var dy:Number = _iEntryPoint.y - entity.y;
				var dz:Number = _iEntryPoint.z - entity.z;
				item.zIndex = dx * _pCameraForward.x + dy * _pCameraForward.y + dz * _pCameraForward.z;
				item.renderSceneTransform = renderable.getRenderSceneTransform( _pCamera );
				item.renderOrderId = material._iDepthPassId;
				_pOpaqueRenderableHead = item;
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