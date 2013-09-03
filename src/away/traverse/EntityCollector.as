/** * ... * @author Gary Paluk - http://www.plugin.io */

///<reference path="../_definitions.ts"/>

package away.traverse
{
	import away.base.IRenderable;
	import away.data.RenderableListItem;
	import away.data.EntityListItem;
	import away.data.RenderableListItemPool;
	import away.data.EntityListItemPool;
	import away.lights.LightBase;
	import away.lights.DirectionalLight;
	import away.lights.PointLight;
	import away.lights.LightProbe;
	import away.cameras.Camera3D;
	import away.geom.Vector3D;
	import away.math.Plane3D;
	import away.partition.NodeBase;
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
			_pLights = new <LightBase>[];
			_directionalLights = new <DirectionalLight>[];
			_pointLights = new <PointLight>[];
			_lightProbes = new <LightProbe>[];
			_pRenderableListItemPool = new RenderableListItemPool();
			_pEntityListItemPool = new EntityListItemPool();
		}
		
		public function get camera():Camera3D
		{
			return _pCamera;
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
			return _customCullPlanes;
		}
		
		public function set cullPlanes(value:Vector.<Plane3D>):void
		{
			this._customCullPlanes = value;
		}
		
		public function get numMouseEnableds():Number
		{
			return _pNumMouseEnableds;
		}
		
		public function get skyBox():IRenderable
		{
			return _pSkyBox;
		}
		
		public function get opaqueRenderableHead():RenderableListItem
		{
			return _pOpaqueRenderableHead;
		}
		
		public function set opaqueRenderableHead(value:RenderableListItem):void
		{
			this._pOpaqueRenderableHead = value;
		}
		
		public function get blendedRenderableHead():RenderableListItem
		{
			return _pBlendedRenderableHead;
		}
		
		public function set blendedRenderableHead(value:RenderableListItem):void
		{
			this._pBlendedRenderableHead = value;
		}
		
		public function get entityHead():EntityListItem
		{
			return _entityHead;
		}
		
		public function get lights():Vector.<LightBase>
		{
			return _pLights;
		}
		
		public function get directionalLights():Vector.<DirectionalLight>
		{
			return _directionalLights;
		}
		
		public function get pointLights():Vector.<PointLight>
		{
			return _pointLights;
		}
		
		public function get lightProbes():Vector.<LightProbe>
		{
			return _lightProbes;
		}
		
		public function clear():void
		{
			_cullPlanes = _customCullPlanes ? _customCullPlanes : ( _pCamera ? _pCamera.frustumPlanes : null );
			_numCullPlanes = _cullPlanes ? _cullPlanes.length : 0;
			_pNumTriangles = _pNumMouseEnableds = 0;
			_pBlendedRenderableHead = null;
			_pOpaqueRenderableHead = null;
			_entityHead = null;
			_pRenderableListItemPool.freeAll();
			_pEntityListItemPool.freeAll();
			_pSkyBox = null;
			if( _pNumLights > 0 )
			{
				_pLights.length = _pNumLights = 0;
			}
			if( _numDirectionalLights > 0 )
			{
				_directionalLights.length = _numDirectionalLights = 0;
			}
			if( _numPointLights > 0 )
			{
				_pointLights.length = _numPointLights = 0;
			}
			if( _numLightProbes > 0 )
			{
				_lightProbes.length = _numLightProbes = 0;
			}
		}
		
		//@override
		override public function enterNode(node:NodeBase):Boolean
		{

            var enter : Boolean = PartitionTraverser._iCollectionMark != node._iCollectionMark && node.isInFrustum( _cullPlanes, _numCullPlanes );

            node._iCollectionMark = PartitionTraverser._iCollectionMark;

			return enter;
		}
		
		//@override
		override public function applySkyBox(renderable:IRenderable):void
		{
			_pSkyBox = renderable;
		}
		
		//@override
		override public function applyRenderable(renderable:IRenderable):void
		{
			var material:MaterialBase;
			var entity:Entity = renderable.sourceEntity;
			if( renderable.mouseEnabled )
			{
				++_pNumMouseEnableds;
			}
			_pNumTriangles += renderable.numTriangles;
			
			material = renderable.material;
			if( material )
			{
				var item:RenderableListItem = _pRenderableListItemPool.getItem();
				item.renderable = renderable;
				item.materialId = material._iUniqueId;
				item.renderOrderId = material._iRenderOrderId;
				item.cascaded = false;
				var dx:Number = _iEntryPoint.x - entity.x;
				var dy:Number = _iEntryPoint.y - entity.y;
				var dz:Number = _iEntryPoint.z - entity.z;
				// project onto camera's z-axis
				item.zIndex = dx*_pCameraForward.x + dy*_pCameraForward.y + dz*_pCameraForward.z + entity.zOffset;
				item.renderSceneTransform = renderable.getRenderSceneTransform( _pCamera );
				if( material.requiresBlending )
				{
					item.next = _pBlendedRenderableHead;
					_pBlendedRenderableHead = item;
				}
				else
				{
					item.next = _pOpaqueRenderableHead;
					_pOpaqueRenderableHead = item;
				}
			}
		}
		
		//@override
		override public function applyEntity(entity:Entity):void
		{



			++_pNumEntities;
			
			var item:EntityListItem = _pEntityListItemPool.getItem();
			item.entity = entity;
			
			item.next = _entityHead;
			_entityHead = item;


            //console.log ( 'EntityCollector' , 'applyEntity: ' , entity , ' item: ' , item , 'item.next' , item.next , ' head: ' , this._entityHead );

		}
		
		//@override
		override public function applyUnknownLight(light:LightBase):void
		{
			_pLights[ _pNumLights++ ] = light;
		}
		
		//@override
		override public function applyDirectionalLight(light:DirectionalLight):void
		{
			_pLights[ _pNumLights++ ] = light;
			_directionalLights[ _numDirectionalLights++ ] = light;
		}
		
		//@override
		override public function applyPointLight(light:PointLight):void
		{
			_pLights[ _pNumLights++ ] = light;
			_pointLights[ _numPointLights++ ] = light;
		}
		
		//@override
		override public function applyLightProbe(light:LightProbe):void
		{
			_pLights[ _pNumLights++ ] = light;
			_lightProbes[ _numLightProbes++ ] = light;
		}

        /**         * Cleans up any data at the end of a frame.         */
        public function cleanUp():void
        {
        }

	}
}