///<reference path="../_definitions.ts"/>
package away.entities
{
	import away.base.IMaterialOwner;
	import away.base.SubMesh;
	import away.base.Geometry;
	import away.materials.MaterialBase;
	import away.animators.IAnimator;
	import away.materials.utils.DefaultMaterialManager;
	import away.library.assets.AssetType;
	import away.events.GeometryEvent;
	import away.utils.Debug;
	import away.base.ISubGeometry;
	import away.base.Object3D;
	import away.containers.ObjectContainer3D;
	import away.partition.EntityNode;
	import away.partition.MeshNode;
	import away.base.SubGeometry;
	//import away3d.materials.utils.DefaultMaterialManager;
	//import away3d.animators.IAnimator;
	//import away3d.arcane;
	//import away3d.containers.*;
	//import away3d.core.base.*;
	//import away3d.core.partition.*;
	//import away3d.events.*;
	//import away3d.library.assets.*;
	//import away3d.materials.*;
	
	//use namespace arcane;
	
	/**
	public class Mesh extends Entity implements IMaterialOwner
	{
		private var _subMeshes:Vector.<SubMesh>;//:Vector.<SubMesh>;
		private var _animator:IAnimator;
		private var _castsShadows:Boolean = true;
		private var _shareAnimationGeometry:Boolean = true;
		
		/**
		public function Mesh(geometry:Geometry, material:MaterialBase = null):void
		{
			super();

			this._subMeshes = new Vector.<SubMesh>();//Vector.<SubMesh>();

            //this.geometry = geometry || new Geometry(); //this should never happen, but if people insist on trying to create their meshes before they have geometry to fill it, it becomes necessary
            if ( geometry == null )
            {
                this.geometry = new Geometry();
            }
            else
            {
                this.geometry = geometry;
            }

			if ( material == null)
            {
                this.material = DefaultMaterialManager.getDefaultMaterial(this);
            }
            else
            {
                this.material = material;
            }

		}
		
		public function bakeTransformations():void
		{
			geometry.applyTransformation(transform);
            transform.identity();
		}
		
		override public function get assetType():String
		{
			return AssetType.MESH;
		}
		
		private function onGeometryBoundsInvalid(event:GeometryEvent):void
		{
            pInvalidateBounds();//this.invalidateBounds();

		}
		
		/**
		public function get castsShadows():Boolean
		{
			return _castsShadows;
		}
		
		public function set castsShadows(value:Boolean):void
		{
            this._castsShadows = value;
		}
		
		/**


		public function get animator():IAnimator
		{
			return _animator;
		}


		public function set animator(value:IAnimator):void
		{

            Debug.throwPIR('Mesh' , 'set animator' , 'Partial Implementation')
            /*
		}

		/**
		public function get geometry():Geometry
		{
			return _geometry;
		}
		
		public function set geometry(value:Geometry):void
		{
			var i:Number;

			if (this._geometry)
            {

                this._geometry.removeEventListener(GeometryEvent.BOUNDS_INVALID, this.onGeometryBoundsInvalid , this);
                this._geometry.removeEventListener(GeometryEvent.SUB_GEOMETRY_ADDED, this.onSubGeometryAdded, this);
                this._geometry.removeEventListener(GeometryEvent.SUB_GEOMETRY_REMOVED, this.onSubGeometryRemoved, this);
				
				for (i = 0; i < this._subMeshes.length; ++i)
                {

                    this._subMeshes[i].dispose();
                }

				this._subMeshes.length = 0;

			}
			
			this._geometry = value;

			if (this._geometry)
            {

				this._geometry.addEventListener(GeometryEvent.BOUNDS_INVALID, this.onGeometryBoundsInvalid , this );
                this._geometry.addEventListener(GeometryEvent.SUB_GEOMETRY_ADDED, this.onSubGeometryAdded , this );
                this._geometry.addEventListener(GeometryEvent.SUB_GEOMETRY_REMOVED, this.onSubGeometryRemoved , this );

                //var subGeoms:Vector.<ISubGeometry> = _geometry.subGeometries;
                var subGeoms:Vector.<ISubGeometry> = this._geometry.subGeometries;//
				
				for (i = 0; i < subGeoms.length; ++i)
                {

                    this.addSubMesh(subGeoms[i]);

                }

			}
			
			if (this._material)
            {

                this._material.iRemoveOwner(this);
                this._material.iAddOwner(this);

			}
		}
		
		/**
		public function get material():MaterialBase
		{
			return _material;
		}
		
		public function set material(value:MaterialBase):void
		{

			if (value == this._material)
            {

                return;

            }

			if (this._material)
            {

                this._material.iRemoveOwner(this);

            }

            this._material = value;

			if (this._material)
            {

                this._material.iAddOwner(this);

            }

		}
		
		/**
		public function get subMeshes():Vector.<SubMesh>//Vector.<SubMesh>
			// Since this getter is invoked every iteration of the render loop, and
			// the geometry construct could affect the sub-meshes, the geometry is
			// validated here to give it a chance to rebuild.

            _geometry.iValidate();

			return _subMeshes;
		}
		
		/**
		public function get shareAnimationGeometry():Boolean
		{
			return _shareAnimationGeometry;
		}
		
		public function set shareAnimationGeometry(value:Boolean):void
		{
            this._shareAnimationGeometry = value;
		}
		
		/**
		public function clearAnimationGeometry():void
		{

            Debug.throwPIR( "away.entities.Mesh" , "away.entities.Mesh" , "Missing Dependency: IAnimator" );

            /* TODO: Missing Dependency: IAnimator
		}
		
		/**
		override public function dispose():void
		{
			super.dispose();
			
			material = null;
            geometry = null;
		}
		
		/**
		public function disposeWithAnimatorAndChildren():void
		{
			disposeWithChildren();

            Debug.throwPIR( "away.entities.Mesh" , "away.entities.Mesh" , "Missing Dependency: IAnimator" );

            /* TODO: Missing Dependency: IAnimator
		}
		
		/**
		override public function clone():Object3D
		{
			var clone:Mesh = new Mesh(_geometry, _material);
			clone.transform = transform;
			clone.pivotPoint = pivotPoint;
			clone.partition = partition;
			clone.bounds = _pBounds.clone(); // TODO: check _pBounds is the correct prop ( in case of problem / debug note )


			clone.name = name;
			clone.castsShadows = castsShadows;
			clone.shareAnimationGeometry = shareAnimationGeometry;
			clone.mouseEnabled = mouseEnabled;
			clone.mouseChildren = mouseChildren;
			//this is of course no proper cloning
			//maybe use this instead?: http://blog.another-d-mention.ro/programming/how-to-clone-duplicate-an-object-in-actionscript-3/
			clone.extra = extra;
			
			var len:Number = _subMeshes.length;
			for (var i:Number = 0; i < len; ++i)
            {
                clone._subMeshes[i].material = _subMeshes[i].material;
            }

			
			len = numChildren;
            var obj : *;

			for (i = 0; i < len; ++i)
            {

                obj = getChildAt(i).clone();
                clone.addChild( ObjectContainer3D(obj)) ;

            }

            Debug.throwPIR( "away.entities.Mesh" , "away.entities.Mesh" , "Missing Dependency: IAnimator" );

            /* TODO: implement dependency IAnimator
			
			return clone;
		}
		
		/**
		override public function pUpdateBounds():void
		{
			_pBounds.fromGeometry(_geometry);
            _pBoundsInvalid = false;//this._boundsInvalid = false;
		}
		
		/**
		override public function pCreateEntityPartitionNode():EntityNode
		{
			return new MeshNode(this);
		}
		
		/**
		private function onSubGeometryAdded(event:GeometryEvent):void
		{
			addSubMesh( event.subGeometry );
		}
		
		/**
		private function onSubGeometryRemoved(event:GeometryEvent):void
		{
			var subMesh:SubMesh;
			var subGeom:ISubGeometry = event.subGeometry;
			var len:Number = _subMeshes.length;
			var i:Number;
			
			// Important! This has to be done here, and not delayed until the
			// next render loop, since this may be caused by the geometry being
			// rebuilt IN THE RENDER LOOP. Invalidating and waiting will delay
			// it until the NEXT RENDER FRAME which is probably not desirable.
			
			for (i = 0; i < len; ++i)
            {

				subMesh = _subMeshes[i];

				if (subMesh.subGeometry == subGeom)
                {
					subMesh.dispose();

					_subMeshes.splice(i, 1);

					break;
				}
			}
			
			--len;
			for (; i < len; ++i){

                _subMeshes[i]._iIndex = i;

            }

		}
		
		/**
		private function addSubMesh(subGeometry:ISubGeometry):void
		{

			var subMesh:SubMesh = new SubMesh(subGeometry, this, null);
			var len:Number = _subMeshes.length;

			subMesh._iIndex = len;

			_subMeshes[len] = subMesh;

            pInvalidateBounds();
		}
		
		public function getSubMeshForSubGeometry(subGeometry:SubGeometry):SubMesh
		{
			return _subMeshes[_geometry.subGeometries.indexOf(subGeometry)];
		}
		
		override public function iCollidesBefore(shortestCollisionDistance:Number, findClosest:Boolean):Boolean
		{

            _iPickingCollider.setLocalRay(_iPickingCollisionVO.localRayPosition, _iPickingCollisionVO.localRayDirection);
            _iPickingCollisionVO.renderable = null;
			var len:Number = _subMeshes.length;
			for (var i:Number = 0; i < len; ++i) {
				var subMesh:SubMesh = _subMeshes[i];
				
				//var ignoreFacesLookingAway:boolean = _material ? !_material.bothSides : true;

				if (_iPickingCollider.testSubMeshCollision(subMesh, _iPickingCollisionVO, shortestCollisionDistance))
                {

					shortestCollisionDistance = _iPickingCollisionVO.rayEntryDistance;

                    _iPickingCollisionVO.renderable = subMesh;

					if (!findClosest)
                    {

                        return true;

                    }

				}
			}
			
			return _iPickingCollisionVO.renderable != null;
		}
	}
}