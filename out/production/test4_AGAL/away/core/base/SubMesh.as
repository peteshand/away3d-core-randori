/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package away.core.base
{
	import away.materials.MaterialBase;
	import away.entities.Mesh;
	import away.core.geom.Matrix;
	import away.entities.Entity;
	import away.core.geom.Matrix3D;
	import away.managers.Stage3DProxy;
	import away.core.display3D.IndexBuffer3D;
	import away.animators.IAnimator;
	import away.bounds.BoundingVolumeBase;
	import away.cameras.Camera3D;

    /**	 * SubMesh wraps a SubGeometry as a scene graph instantiation. A SubMesh is owned by a Mesh object.	 *     *	 * @see away3d.core.base.SubGeometry	 * @see away3d.scenegraph.Mesh     *     * @class away.base.SubGeometryBase	 */
	public class SubMesh implements IRenderable
	{
		public var _iMaterial:MaterialBase;
		private var _parentMesh:Mesh;
		private var _subGeometry:ISubGeometry;
		public var _iIndex:Number = 0;
		private var _uvTransform:Matrix;
		private var _uvTransformDirty:Boolean = false;
		private var _uvRotation:Number = 0;
		private var _scaleU:Number = 1;
		private var _scaleV:Number = 1;
		private var _offsetU:Number = 0;
		private var _offsetV:Number = 0;
		
		//public animationSubGeometry:AnimationSubGeometry;// TODO: implement dependencies AnimationSubGeometry
		//public animatorSubGeometry:AnimationSubGeometry;// TODO: implement dependencies AnimationSubGeometry
		
		/**		 * Creates a new SubMesh object		 * @param subGeometry The SubGeometry object which provides the geometry data for this SubMesh.		 * @param parentMesh The Mesh object to which this SubMesh belongs.		 * @param material An optional material used to render this SubMesh.		 */
		public function SubMesh(subGeometry:ISubGeometry, parentMesh:Mesh, material:MaterialBase = null):void
		{
			material = material || null;

			this._parentMesh = parentMesh;
            this._subGeometry = subGeometry;
			this.material = material;
		}
		
		public function get shaderPickingDetails():Boolean
		{

			return this.sourceEntity.shaderPickingDetails;
		}
		
		public function get offsetU():Number
		{
			return this._offsetU;
		}
		
		public function set offsetU(value:Number):void
		{
			if (value == this._offsetU)
            {

                return;

            }

			this._offsetU = value;
            this._uvTransformDirty = true;
		}
		
		public function get offsetV():Number
		{
			return this._offsetV;
		}
		
		public function set offsetV(value:Number):void
		{
			if (value == this._offsetV)
            {

                return;

            }

			this._offsetV = value;
            this._uvTransformDirty = true;

		}
		
		public function get scaleU():Number
		{
			return this._scaleU;
		}
		
		public function set scaleU(value:Number):void
		{
			if (value == this._scaleU)
            {

                return;

            }

            this._scaleU = value;
            this._uvTransformDirty = true;
		}
		
		public function get scaleV():Number
		{
			return this._scaleV;
		}
		
		public function set scaleV(value:Number):void
		{
			if (value ==this._scaleV)
            {

                return;

            }

			this._scaleV = value;
            this._uvTransformDirty = true;
		}
		
		public function get uvRotation():Number
		{
			return this._uvRotation;
		}
		
		public function set uvRotation(value:Number):void
		{
			if (value == this._uvRotation)
            {

                return;

            }

			this._uvRotation = value;
            this._uvTransformDirty = true;
		}
		
		/**		 * The entity that that initially provided the IRenderable to the render pipeline (ie: the owning Mesh object).		 */
		public function get sourceEntity():Entity
		{
			return this._parentMesh;
		}
		
		/**		 * The SubGeometry object which provides the geometry data for this SubMesh.		 */
		public function get subGeometry():ISubGeometry
		{
			return this._subGeometry;
		}
		
		public function set subGeometry(value:ISubGeometry):void
		{
            this._subGeometry = value;
		}
		
		/**		 * The material used to render the current SubMesh. If set to null, its parent Mesh's material will be used instead.		 */
		public function get material():MaterialBase
		{
			return this._iMaterial || this._parentMesh.material;
		}
		
		public function set material(value:MaterialBase):void
		{

            //away.Debug.throwPIR( 'away.base.Submesh' , 'set material' , 'away.base.MaterialBase _iRemoveOwner , _iAddOwner');
            //*
			if (this._iMaterial)
            {

                this._iMaterial.iRemoveOwner(this);

            }

			this._iMaterial = value;
			
			if (this._iMaterial)
            {

                this._iMaterial.iAddOwner(this);

            }
            //*/
		}
		
		/**		 * The scene transform object that transforms from model to world space.		 */
		public function get sceneTransform():Matrix3D
		{
			return this._parentMesh.sceneTransform;
		}
		
		/**		 * The inverse scene transform object that transforms from world to model space.		 */
		public function get inverseSceneTransform():Matrix3D
		{
			return this._parentMesh.inverseSceneTransform;
		}
		
		/**		 * @inheritDoc		 */
		public function activateVertexBuffer(index:Number, stage3DProxy:Stage3DProxy):void
		{
			this._subGeometry.activateVertexBuffer(index, stage3DProxy);
		}
		
		/**		 * @inheritDoc		 */
		public function activateVertexNormalBuffer(index:Number, stage3DProxy:Stage3DProxy):void
		{
			this._subGeometry.activateVertexNormalBuffer(index, stage3DProxy);
		}
		
		/**		 * @inheritDoc		 */
		public function activateVertexTangentBuffer(index:Number, stage3DProxy:Stage3DProxy):void
		{
			this._subGeometry.activateVertexTangentBuffer(index, stage3DProxy);
		}
		
		/**		 * @inheritDoc		 */
		public function activateUVBuffer(index:Number, stage3DProxy:Stage3DProxy):void
		{
			this._subGeometry.activateUVBuffer(index, stage3DProxy);
		}
		
		/**		 * @inheritDoc		 */
		public function activateSecondaryUVBuffer(index:Number, stage3DProxy:Stage3DProxy):void
		{
            this._subGeometry.activateSecondaryUVBuffer(index, stage3DProxy);
		}
		
		/**		 * @inheritDoc		 */
		public function getIndexBuffer(stage3DProxy:Stage3DProxy):IndexBuffer3D
		{
			return this._subGeometry.getIndexBuffer(stage3DProxy);
		}
		
		/**		 * The amount of triangles that make up this SubMesh.		 */
		public function get numTriangles():Number
		{
			return this._subGeometry.numTriangles;
		}
		
		/**		 * The animator object that provides the state for the SubMesh's animation.		 */
		public function get animator():IAnimator
		{

			return this._parentMesh.animator;

		}
		/**		 * Indicates whether the SubMesh should trigger mouse events, and hence should be rendered for hit testing.		 */
		public function get mouseEnabled():Boolean
		{


			return this._parentMesh.mouseEnabled || this._parentMesh._iAncestorsAllowMouseEnabled;//this._parentMesh._ancestorsAllowMouseEnabled;
		}
		
		public function get castsShadows():Boolean
		{
			return this._parentMesh.castsShadows;
		}
		
		/**		 * A reference to the owning Mesh object		 *		 * @private		 */
		public function get iParentMesh():Mesh
		{
			return this._parentMesh;
		}
		
		public function set iParentMesh(value:Mesh):void
		{
            this._parentMesh = value;
		}
		
		public function get uvTransform():Matrix
		{
			if (this._uvTransformDirty)
            {

                this.updateUVTransform();

            }

			return this._uvTransform;
		}
		
		private function updateUVTransform():void
		{
            if ( this._uvTransform  == null )
            {

                this._uvTransform = new Matrix();
                //_uvTransform ||= new Matrix();

            }

			this._uvTransform.identity();

			if (this._uvRotation != 0)
            {

                this._uvTransform.rotate(this._uvRotation);

            }

			if (this._scaleU != 1 || this._scaleV != 1)
            {

                this._uvTransform.scale(this._scaleU, this._scaleV);

            }

            this._uvTransform.translate(this._offsetU, this._offsetV);
            this._uvTransformDirty = false;
		}
		
		public function dispose():void
		{
            this.material = null;
		}
		
		public function get vertexData():Vector.<Number>
		{
			return this._subGeometry.vertexData;
		}
		
		public function get indexData():Vector.<Number> /*uint*/		{
			return this._subGeometry.indexData;
		}
		
		public function get UVData():Vector.<Number>
		{
			return this._subGeometry.UVData;
		}
		
		public function get bounds():BoundingVolumeBase
		{
			return this._parentMesh.getBounds(); // TODO: return smaller, sub mesh bounds instead
		}
		
		public function get visible():Boolean
		{
			return this._parentMesh.visible;
		}
		
		public function get numVertices():Number
		{
			return this._subGeometry.numVertices;
		}
		
		public function get vertexStride():Number
		{
			return this._subGeometry.vertexStride;
		}
		
		public function get UVStride():Number
		{
			return this._subGeometry.UVStride;
		}
		
		public function get vertexNormalData():Vector.<Number>
		{
			return this._subGeometry.vertexNormalData;
		}
		
		public function get vertexTangentData():Vector.<Number>
		{
			return this._subGeometry.vertexTangentData;
		}
		
		public function get UVOffset():Number
		{
			return this._subGeometry.UVOffset;
		}
		
		public function get vertexOffset():Number
		{
			return this._subGeometry.vertexOffset;
		}
		
		public function get vertexNormalOffset():Number
		{
			return this._subGeometry.vertexNormalOffset;
		}
		
		public function get vertexTangentOffset():Number
		{
			return this._subGeometry.vertexTangentOffset;
		}
		
		public function getRenderSceneTransform(camera:Camera3D):Matrix3D
		{
			return this._parentMesh.sceneTransform;
		}
	}
}
