///<reference path="../_definitions.ts"/>
package away.primitives
{
	import away.entities.Entity;
	import away.base.IRenderable;
	import away.base.SubGeometry;
	import away.materials.SkyBoxMaterial;
	import away.geom.Matrix;
	import away.animators.IAnimator;
	import away.bounds.BoundingVolumeBase;
	import away.bounds.NullBounds;
	import away.textures.CubeTextureBase;
	import away.managers.Stage3DProxy;
	import away.display3D.IndexBuffer3D;
	import away.materials.MaterialBase;
	import away.errors.AbstractMethodError;
	import away.library.assets.AssetType;
	import away.partition.EntityNode;
	import away.partition.SkyBoxNode;
	import away.cameras.Camera3D;
	import away.geom.Matrix3D;

	/**	 * A SkyBox class is used to render a sky in the scene. It's always considered static and 'at infinity', and as	 * such it's always centered at the camera's position and sized to exactly fit within the camera's frustum, ensuring	 * the sky box is always as large as possible without being clipped.	 */
	public class SkyBox extends Entity implements IRenderable
	{
		// todo: remove SubGeometry, use a simple single buffer with offsets
		private var _geometry:SubGeometry;
		private var _material:SkyBoxMaterial;
		private var _uvTransform:Matrix = new Matrix();
		private var _animator:IAnimator;
		
		public function get animator():IAnimator
		{
			return this._animator;
		}
		
		override public function pGetDefaultBoundingVolume():BoundingVolumeBase
		{
			return new NullBounds();
		}
		
		/**		 * Create a new SkyBox object.		 * @param cubeMap The CubeMap to use for the sky box's texture.		 */
		public function SkyBox(cubeMap:CubeTextureBase):void
		{
			super();
			this._material = new SkyBoxMaterial(cubeMap);
			this._material.iAddOwner(this);
			this._geometry = new SubGeometry();
			this.buildGeometry(this._geometry);
		}
		
		/**		 * @inheritDoc		 */
		public function activateVertexBuffer(index:Number, stage3DProxy:Stage3DProxy):void
		{
			this._geometry.activateVertexBuffer(index, stage3DProxy);
		}
		
		/**		 * @inheritDoc		 */
		public function activateUVBuffer(index:Number, stage3DProxy:Stage3DProxy):void
		{
		}
		
		/**		 * @inheritDoc		 */
		public function activateVertexNormalBuffer(index:Number, stage3DProxy:Stage3DProxy):void
		{
		}
		
		/**		 * @inheritDoc		 */
		public function activateVertexTangentBuffer(index:Number, stage3DProxy:Stage3DProxy):void
		{
		}
		
		public function activateSecondaryUVBuffer(index:Number, stage3DProxy:Stage3DProxy):void
		{
		}
		
		/**		 * @inheritDoc		 */
		public function getIndexBuffer(stage3DProxy:Stage3DProxy):IndexBuffer3D
		{
			return this._geometry.getIndexBuffer(stage3DProxy);
		}
		
		/**		 * The amount of triangles that comprise the SkyBox geometry.		 */
		public function get numTriangles():Number
		{
			return this._geometry.numTriangles;
		}
		
		/**		 * The entity that that initially provided the IRenderable to the render pipeline.		 */
		public function get sourceEntity():Entity
		{
			return null;
		}
		
		/**		 * The material with which to render the object.		 */
		public function get material():MaterialBase
		{
			return this._material;
		}
		
		public function set material(value:MaterialBase):void
		{
			throw new AbstractMethodError("Unsupported method!");
		}
		
		override public function get assetType():String
		{
			return AssetType.SKYBOX;
		}
		
		/**		 * @inheritDoc		 */
		override public function pInvalidateBounds():void
		{
			// dead end
		}
		
		/**		 * @inheritDoc		 */
		override public function pCreateEntityPartitionNode():EntityNode
		{
            var node : SkyBoxNode = new SkyBoxNode(this)
			return (node as EntityNode);
		}
		
		/**		 * @inheritDoc		 */
		override public function pUpdateBounds():void
		{
            this._pBoundsInvalid = false;
		}
		
		/**		 * Builds the geometry that forms the SkyBox		 */
		private function buildGeometry(target:SubGeometry):void
		{
			var vertices:Vector.<Number> = new <Number>[-1, 1, -1, 1, 1, -1,1, 1, 1, -1, 1, 1,-1, -1, -1, 1, -1, -1,1, -1, 1, -1, -1, 1];
			var indices:Vector.<Number> = new <Number>[0, 1, 2, 2, 3, 0,6, 5, 4, 4, 7, 6,2, 6, 7, 7, 3, 2,4, 5, 1, 1, 0, 4,4, 0, 3, 3, 7, 4,2, 1, 5, 5, 6, 2];
			
			target.updateVertexData(vertices);
			target.updateIndexData(indices);
		}
		
		public function get castsShadows():Boolean
		{
			return false;
		}
		
		public function get uvTransform():Matrix
		{
			return this._uvTransform;
		}
		
		public function get vertexData():Vector.<Number>
		{
			return this._geometry.vertexData;
		}
		
		public function get indexData():Vector.<Number>
		{
			return this._geometry.indexData;
		}
		
		public function get UVData():Vector.<Number>
		{
			return this._geometry.UVData;
		}
		
		public function get numVertices():Number
		{
			return this._geometry.numVertices;
		}
		
		public function get vertexStride():Number
		{
			return this._geometry.vertexStride;
		}
		
		public function get vertexNormalData():Vector.<Number>
		{
			return this._geometry.vertexNormalData;
		}
		
		public function get vertexTangentData():Vector.<Number>
		{
			return this._geometry.vertexTangentData;
		}
		
		public function get vertexOffset():Number
		{
			return this._geometry.vertexOffset;
		}
		
		public function get vertexNormalOffset():Number
		{
			return this._geometry.vertexNormalOffset;
		}
		
		public function get vertexTangentOffset():Number
		{
			return this._geometry.vertexTangentOffset;
		}
		
		public function getRenderSceneTransform(camera:Camera3D):Matrix3D
		{

			return this._pSceneTransform
		}
	}
}
