/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package away.core.traverse
{
	import away.core.base.IRenderable;
	import away.core.data.RenderableListItem;
	import away.core.data.EntityListItem;
	import away.core.data.RenderableListItemPool;
	import away.core.data.EntityListItemPool;
	import away.lights.LightBase;
	import away.lights.DirectionalLight;
	import away.lights.PointLight;
	import away.lights.LightProbe;
	import away.cameras.Camera3D;
	import away.core.geom.Vector3D;
	import away.core.math.Plane3D;
	import away.core.partition.NodeBase;
	import away.materials.MaterialBase;
	import away.entities.Entity;
	public class EntityCollector extends PartitionTraverser
	{
		
		public var _pSkyBox:IRenderable;
		public var _pOpaqueRenderableHead:RenderableListItem;
		public var _pBlendedRenderableHead:RenderableListItem;
		private var _entityHead:EntityListItem;
		public var _pRenderableListItemPool:RenderableListItemPool;
		public var _pEntityListItemPool:EntityListItemPool;
		public var _pLights:Vector.<LightBase>;
		private var _directionalLights:Vector.<DirectionalLight>;
		private var _pointLights:Vector.<PointLight>;
		private var _lightProbes:Vector.<LightProbe>;
		public var _pNumEntities:Number = 0;
		public var _pNumLights:Number = 0;
		public var _pNumTriangles:Number = 0;
		public var _pNumMouseEnableds:Number = 0;
		public var _pCamera:Camera3D;
		private var _numDirectionalLights:Number = 0;
		private var _numPointLights:Number = 0;
		private var _numLightProbes:Number = 0;
		public var _pCameraForward:Vector3D;
		private var _customCullPlanes:Vector.<Plane3D>;
		private var _cullPlanes:Vector.<Plane3D>;
		private var _numCullPlanes:Number = 0;
		
		public function EntityCollector():void
		{
			super();
			this.init();
		}
		
		private function init():void
		{
			this._pLights = new <LightBase>[];
			this._directionalLights = new <DirectionalLight>[];
			this._pointLights = new <PointLight>[];
			this._lightProbes = new <LightProbe>[];
			this._pRenderableListItemPool = new RenderableListItemPool();
			this._pEntityListItemPool = new EntityListItemPool();
		}
		
		public function get camera():Camera3D
		{
			return this._pCamera;
		}
		
		public function set camera(value:Camera3D):void
		{
			this._pCamera = value;
			this._iEntryPoint = this._pCamera.scenePosition;
			this._pCameraForward = this._pCamera.forwardVector;
			this._cullPlanes = this._pCamera.frustumPlanes;
		}
		
		public function get cullPlanes():Vector.<Plane3D>
		{
			return this._customCullPlanes;
		}
		
		public function set cullPlanes(value:Vector.<Plane3D>):void
		{
			this._customCullPlanes = value;
		}
		
		public function get numMouseEnableds():Number
		{
			return this._pNumMouseEnableds;
		}
		
		public function get skyBox():IRenderable
		{
			return this._pSkyBox;
		}
		
		public function get opaqueRenderableHead():RenderableListItem
		{
			return this._pOpaqueRenderableHead;
		}
		
		public function set opaqueRenderableHead(value:RenderableListItem):void
		{
			this._pOpaqueRenderableHead = value;
		}
		
		public function get blendedRenderableHead():RenderableListItem
		{
			return this._pBlendedRenderableHead;
		}
		
		public function set blendedRenderableHead(value:RenderableListItem):void
		{
			this._pBlendedRenderableHead = value;
		}
		
		public function get entityHead():EntityListItem
		{
			return this._entityHead;
		}
		
		public function get lights():Vector.<LightBase>
		{
			return this._pLights;
		}
		
		public function get directionalLights():Vector.<DirectionalLight>
		{
			return this._directionalLights;
		}
		
		public function get pointLights():Vector.<PointLight>
		{
			return this._pointLights;
		}
		
		public function get lightProbes():Vector.<LightProbe>
		{
			return this._lightProbes;
		}
		
		public function clear():void
		{
			this._cullPlanes = this._customCullPlanes ? this._customCullPlanes : ( this._pCamera ? this._pCamera.frustumPlanes : null );
			this._numCullPlanes = this._cullPlanes ? this._cullPlanes.length : 0;
			this._pNumTriangles = 0;
			this._pNumMouseEnableds = 0;

			this._pBlendedRenderableHead = null;
			this._pOpaqueRenderableHead = null;
			this._entityHead = null;
			this._pRenderableListItemPool.freeAll();
			this._pEntityListItemPool.freeAll();
			this._pSkyBox = null;
			if( this._pNumLights > 0 )
			{
				this._pLights.length = 0;
				this._pNumLights = 0;

			}
			if( this._numDirectionalLights > 0 )
			{
				this._directionalLights.length = 0;
				this._numDirectionalLights = 0;

			}
			if( this._numPointLights > 0 )
			{
				this._pointLights.length = 0;
				this._numPointLights = 0;

			}
			if( this._numLightProbes > 0 )
			{
				this._lightProbes.length = 0;
				this._numLightProbes = 0;

			}
		}
		
		//@override
		override public function enterNode(node:NodeBase):Boolean
		{

            var enter : Boolean = PartitionTraverser._iCollectionMark != node._iCollectionMark && node.isInFrustum( this._cullPlanes, this._numCullPlanes );

            node._iCollectionMark = PartitionTraverser._iCollectionMark;

			return enter;
		}
		
		//@override
		override public function applySkyBox(renderable:IRenderable):void
		{
			this._pSkyBox = renderable;
		}
		
		//@override
		override public function applyRenderable(renderable:IRenderable):void
		{
			var material:MaterialBase;
			var entity:Entity = renderable.sourceEntity;
			if( renderable.mouseEnabled )
			{
				++this._pNumMouseEnableds;
			}
			this._pNumTriangles += renderable.numTriangles;
			
			material = renderable.material;
			if( material )
			{
				var item:RenderableListItem = this._pRenderableListItemPool.getItem();
				item.renderable = renderable;
				item.materialId = material._iUniqueId;
				item.renderOrderId = material._iRenderOrderId;
				item.cascaded = false;
				var dx:Number = this._iEntryPoint.x - entity.x;
				var dy:Number = this._iEntryPoint.y - entity.y;
				var dz:Number = this._iEntryPoint.z - entity.z;
				// project onto camera's z-axis
				item.zIndex = dx*this._pCameraForward.x + dy*this._pCameraForward.y + dz*this._pCameraForward.z + entity.zOffset;
				item.renderSceneTransform = renderable.getRenderSceneTransform( this._pCamera );
				if( material.requiresBlending )
				{
					item.next = this._pBlendedRenderableHead;
					this._pBlendedRenderableHead = item;
				}
				else
				{
					item.next = this._pOpaqueRenderableHead;
					this._pOpaqueRenderableHead = item;
				}
			}
		}
		
		//@override
		override public function applyEntity(entity:Entity):void
		{



			++this._pNumEntities;
			
			var item:EntityListItem = this._pEntityListItemPool.getItem();
			item.entity = entity;
			
			item.next = this._entityHead;
			this._entityHead = item;


            //console.log ( 'EntityCollector' , 'applyEntity: ' , entity , ' item: ' , item , 'item.next' , item.next , ' head: ' , this._entityHead );

		}
		
		//@override
		override public function applyUnknownLight(light:LightBase):void
		{
			this._pLights[ this._pNumLights++ ] = light;
		}
		
		//@override
		override public function applyDirectionalLight(light:DirectionalLight):void
		{
			this._pLights[ this._pNumLights++ ] = light;
			this._directionalLights[ this._numDirectionalLights++ ] = light;
		}
		
		//@override
		override public function applyPointLight(light:PointLight):void
		{
			this._pLights[ this._pNumLights++ ] = light;
			this._pointLights[ this._numPointLights++ ] = light;
		}
		
		//@override
		override public function applyLightProbe(light:LightProbe):void
		{
			this._pLights[ this._pNumLights++ ] = light;
			this._lightProbes[ this._numLightProbes++ ] = light;
		}

        /**         * Cleans up any data at the end of a frame.         */
        public function cleanUp():void
        {
        }

	}
}