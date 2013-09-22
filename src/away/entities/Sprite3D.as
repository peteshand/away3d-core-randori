///<reference path="../_definitions.ts"/>

package away.entities
{
	import away.base.IRenderable;
	import away.base.SubGeometry;
	import away.materials.MaterialBase;
	import away.geom.Matrix3D;
	import away.animators.IAnimator;
	import away.base.SubMesh;
	import away.cameras.Camera3D;
	import away.pick.IPickingCollider;
	import away.managers.Stage3DProxy;
	import away.display3D.IndexBuffer3D;
	import away.bounds.BoundingVolumeBase;
	import away.bounds.AxisAlignedBoundingBox;
	import away.partition.EntityNode;
	import away.partition.RenderableNode;
	import away.geom.Matrix;
	import away.math.Matrix3DUtils;
	import away.geom.Vector3D;

	/**	 * Sprite3D is a 3D billboard, a renderable rectangular area that is always aligned with the projection plane.	 * As a result, no perspective transformation occurs on a Sprite3D object.	 *	 * todo: mvp generation or vertex shader code can be optimized	 */
	public class Sprite3D extends Entity implements IRenderable
	{
		// TODO: Replace with CompactSubGeometry
		private static var _geometry:SubGeometry;
		//private static var _pickingSubMesh:SubGeometry;
		
		private var _material:MaterialBase;
		private var _spriteMatrix:Matrix3D;
		private var _animator:IAnimator;
		
		private var _pickingSubMesh:SubMesh;
		private var _pickingTransform:Matrix3D;
		private var _camera:Camera3D;
		
		private var _width:Number;
		private var _height:Number;
		private var _shadowCaster:Boolean = false;
		
		public function Sprite3D(material:MaterialBase, width:Number, height:Number):void
		{
			super();
			this.material = material;
			this._width = width;
            this._height = height;
            this._spriteMatrix = new Matrix3D();
			if (!Sprite3D._geometry) {
                Sprite3D._geometry = new SubGeometry();
                Sprite3D._geometry.updateVertexData(new <Number>[-.5, .5, .0, .5, .5, .0, .5, -.5, .0, -.5, -.5, .0]);
                Sprite3D._geometry.updateUVData(new <Number>[.0, .0, 1.0, .0, 1.0, 1.0, .0, 1.0]);
                Sprite3D._geometry.updateIndexData(new <Number>[0, 1, 2, 0, 2, 3]);
                Sprite3D._geometry.updateVertexTangentData(new <Number>[1.0, 0.0, 0.0, 1.0, 0.0, 0.0, 1.0, 0.0, 0.0, 1.0, 0.0, 0.0]);
                Sprite3D._geometry.updateVertexNormalData(new <Number>[.0, .0, -1.0, .0, .0, -1.0, .0, .0, -1.0, .0, .0, -1.0]);
			}
		}
		
		override public function set pickingCollider(value:IPickingCollider):void
		{
			super.setPickingCollider ( value );

			if (value)
            { // bounds collider is the only null value
				this._pickingSubMesh = new SubMesh(Sprite3D._geometry, null);
                this._pickingTransform = new Matrix3D();
			}
		}
		
		public function get width():Number
		{
			return this._width;
		}
		
		public function set width(value:Number):void
		{
			if (this._width == value)
				return;
            this._width = value;
            this.iInvalidateTransform();
		}
		
		public function get height():Number
		{
			return this._height;
		}
		
		public function set height(value:Number):void
		{
			if (this._height == value)
				return;
            this._height = value;
            this.iInvalidateTransform();
		}
		
		public function activateVertexBuffer(index:Number, stage3DProxy:Stage3DProxy):void
		{
            Sprite3D._geometry.activateVertexBuffer(index, stage3DProxy);
		}
		
		public function activateUVBuffer(index:Number, stage3DProxy:Stage3DProxy):void
		{
            Sprite3D._geometry.activateUVBuffer(index, stage3DProxy);
		}
		
		public function activateSecondaryUVBuffer(index:Number, stage3DProxy:Stage3DProxy):void
		{
            Sprite3D._geometry.activateSecondaryUVBuffer(index, stage3DProxy);
		}
		
		public function activateVertexNormalBuffer(index:Number, stage3DProxy:Stage3DProxy):void
		{
            Sprite3D._geometry.activateVertexNormalBuffer(index, stage3DProxy);
		}
		
		public function activateVertexTangentBuffer(index:Number, stage3DProxy:Stage3DProxy):void
		{
            Sprite3D._geometry.activateVertexTangentBuffer(index, stage3DProxy);
		}
		
		public function getIndexBuffer(stage3DProxy:Stage3DProxy):IndexBuffer3D
		{
			return Sprite3D._geometry.getIndexBuffer(stage3DProxy);
		}
		
		public function get numTriangles():Number
		{
			return 2;
		}
		
		public function get sourceEntity():Entity
		{
			return this;
		}
		
		public function get material():MaterialBase
		{
			return this._material;
		}
		
		public function set material(value:MaterialBase):void
		{
			if (value == this._material)
				return;
			if (this._material)
                this._material.iRemoveOwner(this);
            this._material = value;
			if (this._material)
                this._material.iAddOwner(this);
		}
		
		/**		 * Defines the animator of the mesh. Act on the mesh's geometry. Defaults to null		 */
		public function get animator():IAnimator
		{
			return this._animator;
		}
		
		public function get castsShadows():Boolean
		{
			return this._shadowCaster;
		}
		
		override public function pGetDefaultBoundingVolume():BoundingVolumeBase
		{
			return new AxisAlignedBoundingBox();
		}
		
		override public function pUpdateBounds():void
		{
			this._pBounds.fromExtremes(-.5*this._pScaleX, -.5*this._pScaleY, -.5*this._pScaleZ, .5*this._pScaleX, .5*this._pScaleY, .5*this._pScaleZ);
			this._pBoundsInvalid = false;
		}
		
		override public function pCreateEntityPartitionNode():EntityNode
		{
			return new RenderableNode(this);
		}
		
		override public function pUpdateTransform():void
		{
			super.pUpdateTransform();
			this._pTransform.prependScale(this._width, this._height, Math.max(this._width, this._height));
		}
		
		public function get uvTransform():Matrix
		{
			return null;
		}
		
		public function get vertexData():Vector.<Number>
		{
			return Sprite3D._geometry.vertexData;
		}
		
		public function get indexData():Vector.<Number> /*uint*/		{
			return Sprite3D._geometry.indexData;
		}
		
		public function get UVData():Vector.<Number>
		{
			return Sprite3D._geometry.UVData;
		}
		
		public function get numVertices():Number
		{
			return Sprite3D._geometry.numVertices;
		}
		
		public function get vertexStride():Number
		{
			return Sprite3D._geometry.vertexStride;
		}
		
		public function get vertexNormalData():Vector.<Number>
		{
			return Sprite3D._geometry.vertexNormalData;
		}
		
		public function get vertexTangentData():Vector.<Number>
		{
			return Sprite3D._geometry.vertexTangentData;
		}
		
		public function get vertexOffset():Number
		{
			return Sprite3D._geometry.vertexOffset;
		}
		
		public function get vertexNormalOffset():Number
		{
			return Sprite3D._geometry.vertexNormalOffset;
		}
		
		public function get vertexTangentOffset():Number
		{
			return Sprite3D._geometry.vertexTangentOffset;
		}
		
		override public function iCollidesBefore(shortestCollisionDistance:Number, findClosest:Boolean):Boolean
		{
			findClosest = findClosest;

			var viewTransform:Matrix3D = this._camera.inverseSceneTransform.clone();
			viewTransform.transpose();
			var rawViewTransform:Vector.<Number> = Matrix3DUtils.RAW_DATA_CONTAINER;
			viewTransform.copyRawDataTo(rawViewTransform);
			rawViewTransform[ 3  ] = 0;
			rawViewTransform[ 7  ] = 0;
			rawViewTransform[ 11 ] = 0;
			rawViewTransform[ 12 ] = 0;
			rawViewTransform[ 13 ] = 0;
			rawViewTransform[ 14 ] = 0;
			
			this._pickingTransform.copyRawDataFrom(rawViewTransform);
            this._pickingTransform.prependScale(this._width, this._height, Math.max(this._width, this._height));
            this._pickingTransform.appendTranslation(this.scenePosition.x, this.scenePosition.y, this.scenePosition.z);
            this._pickingTransform.invert();
			
			var localRayPosition:Vector3D = this._pickingTransform.transformVector(this._iPickingCollisionVO.rayPosition);
			var localRayDirection:Vector3D = this._pickingTransform.deltaTransformVector(this._iPickingCollisionVO.rayDirection);
			
			this._iPickingCollider.setLocalRay(localRayPosition, localRayDirection);
			
			this._iPickingCollisionVO.renderable = null;

			if (this._iPickingCollider.testSubMeshCollision(this._pickingSubMesh, this._iPickingCollisionVO, shortestCollisionDistance))
				this._iPickingCollisionVO.renderable = this._pickingSubMesh;
			
			return this._iPickingCollisionVO.renderable != null;
		}
		
		public function getRenderSceneTransform(camera:Camera3D):Matrix3D
		{
			var comps:Vector.<Vector3D> = camera.sceneTransform.decompose();
			var scale:Vector3D = comps[2];
			comps[0] = this.scenePosition;
			scale.x = this._width*this._pScaleX;
			scale.y = this._height*this._pScaleY;
			this._spriteMatrix.recompose(comps);
			return this._spriteMatrix;
		}
	}
}
