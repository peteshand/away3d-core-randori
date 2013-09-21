/** * ... * @author Gary Paluk - http://www.plugin.io */

///<reference path="../_definitions.ts" />

package away.cameras
{
	import away.entities.Entity;
	import away.geom.Matrix3D;
	import away.cameras.lenses.LensBase;
	import away.math.Plane3D;
	import away.cameras.lenses.PerspectiveLens;
	import away.events.LensEvent;
	import away.bounds.BoundingVolumeBase;
	import away.bounds.NullBounds;
	import away.library.assets.AssetType;
	import away.partition.EntityNode;
	import away.partition.CameraNode;
	import away.events.CameraEvent;
	import away.geom.Vector3D;
	public class Camera3D extends Entity
	{
		
		private var _viewProjection:Matrix3D = new Matrix3D();
		private var _viewProjectionDirty:Boolean = true;
		private var _lens:LensBase;
		private var _frustumPlanes:Vector.<Plane3D>;
		private var _frustumPlanesDirty:Boolean = true;
		
		public function Camera3D(lens:LensBase = null):void
		{
			super();
			
			this._lens = lens || new PerspectiveLens();
			this._lens.addEventListener( LensEvent.MATRIX_CHANGED, onLensMatrixChanged, this );
			
			this._frustumPlanes = new <Plane3D>[];
			
			for( var i:Number = 0; i < 6; ++i )
			{
				this._frustumPlanes[i] = new Plane3D();
			}

            this.z = -1000;

		}
		
		override public function pGetDefaultBoundingVolume():BoundingVolumeBase
		{
			return new NullBounds();
		}
		
		//@override
		override public function get assetType():String
		{
			return AssetType.CAMERA;
		}
		
		private function onLensMatrixChanged(event:LensEvent):void
		{
			this._viewProjectionDirty = true;
			this._frustumPlanesDirty = true;
			this.dispatchEvent(event);
		}
		
		public function get frustumPlanes():Vector.<Plane3D>
		{
			if( this._frustumPlanesDirty )
			{
				this.updateFrustum();
			}
			return this._frustumPlanes;
		}
		
		private function updateFrustum():void
		{
			var a:Number, b:Number, c:Number;
			//var d : Number;
			var c11:Number, c12:Number, c13:Number, c14:Number;
			var c21:Number, c22:Number, c23:Number, c24:Number;
			var c31:Number, c32:Number, c33:Number, c34:Number;
			var c41:Number, c42:Number, c43:Number, c44:Number;
			var p:Plane3D;
			var raw:Vector.<Number> = new Vector.<Number>(16);;//new Array(16 );away.utils.Matrix3DUtils.RAW_DATA_CONTAINER;//[];
			var invLen:Number;
            this.viewProjection.copyRawDataTo( raw );

			c11 = raw[0];
			c12 = raw[4];
			c13 = raw[8];
			c14 = raw[12];
			c21 = raw[1];
			c22 = raw[5];
			c23 = raw[9];
			c24 = raw[13];
			c31 = raw[2];
			c32 = raw[6];
			c33 = raw[10];
			c34 = raw[14];
			c41 = raw[3];
			c42 = raw[7];
			c43 = raw[11];
			c44 = raw[15];
			
			// left plane
			p = this._frustumPlanes[0];
			a = c41 + c11;
			b = c42 + c12;
			c = c43 + c13;
			invLen = 1/Math.sqrt(a*a + b*b + c*c);
			p.a = a*invLen;
			p.b = b*invLen;
			p.c = c*invLen;
			p.d = -(c44 + c14)*invLen;
			
			// right plane
			p = this._frustumPlanes[1];
			a = c41 - c11;
			b = c42 - c12;
			c = c43 - c13;
			invLen = 1/Math.sqrt(a*a + b*b + c*c);
			p.a = a*invLen;
			p.b = b*invLen;
			p.c = c*invLen;
			p.d = (c14 - c44)*invLen;
			
			// bottom
			p = this._frustumPlanes[2];
			a = c41 + c21;
			b = c42 + c22;
			c = c43 + c23;
			invLen = 1/Math.sqrt(a*a + b*b + c*c);
			p.a = a*invLen;
			p.b = b*invLen;
			p.c = c*invLen;
			p.d = -(c44 + c24)*invLen;
			
			// top
			p = this._frustumPlanes[3];
			a = c41 - c21;
			b = c42 - c22;
			c = c43 - c23;
			invLen = 1/Math.sqrt(a*a + b*b + c*c);
			p.a = a*invLen;
			p.b = b*invLen;
			p.c = c*invLen;
			p.d = (c24 - c44)*invLen;
			
			// near
			p = this._frustumPlanes[4];
			a = c31;
			b = c32;
			c = c33;
			invLen = 1/Math.sqrt(a*a + b*b + c*c);
			p.a = a*invLen;
			p.b = b*invLen;
			p.c = c*invLen;
			p.d = -c34*invLen;
			
			// far
			p = this._frustumPlanes[5];
			a = c41 - c31;
			b = c42 - c32;
			c = c43 - c33;
			invLen = 1/Math.sqrt(a*a + b*b + c*c);
			p.a = a*invLen;
			p.b = b*invLen;
			p.c = c*invLen;
			p.d = (c34 - c44)*invLen;
			
			this._frustumPlanesDirty = false;

		}
		
		//@override
		override public function pInvalidateSceneTransform():void
		{
			super.pInvalidateSceneTransform();
			
			this._viewProjectionDirty = true;
			this._frustumPlanesDirty = true;
		}
		
		//@override
		override public function pUpdateBounds():void
		{
			this._pBounds.nullify();
			this._pBoundsInvalid = false;
		}
		
		//@override
		override public function pCreateEntityPartitionNode():EntityNode
		{
			return new CameraNode( this );
		}
		
		public function get lens():LensBase
		{
			return this._lens;
		}
		
		public function set lens(value:LensBase):void
		{
			if( this._lens == value )
			{
				return;
			}
			if(!value)
			{
				throw new Error("Lens cannot be null!");
			}
			this._lens.removeEventListener(LensEvent.MATRIX_CHANGED, onLensMatrixChanged, this );
			this._lens = value;
			this._lens.addEventListener( LensEvent.MATRIX_CHANGED, onLensMatrixChanged, this );
			this.dispatchEvent( new CameraEvent( CameraEvent.LENS_CHANGED, this ));
		}
		
		public function get viewProjection():Matrix3D
		{
			if( this._viewProjectionDirty)
			{

				this._viewProjection.copyFrom( this.inverseSceneTransform );
				this._viewProjection.append( this._lens.matrix );
				this._viewProjectionDirty = false;

			}
			return this._viewProjection;
		}

        /**         * Calculates the ray in scene space from the camera to the given normalized coordinates in screen space.         *         * @param nX The normalised x coordinate in screen space, -1 corresponds to the left edge of the viewport, 1 to the right.         * @param nY The normalised y coordinate in screen space, -1 corresponds to the top edge of the viewport, 1 to the bottom.         * @param sZ The z coordinate in screen space, representing the distance into the screen.         * @return The ray from the camera to the scene space position of the given screen coordinates.         */
        public function getRay(nX:Number, nY:Number, sZ:Number):Vector3D
        {
            return this.sceneTransform.deltaTransformVector(this._lens.unproject(nX, nY, sZ));
        }

        /**         * Calculates the normalised position in screen space of the given scene position.         *         * @param point3d the position vector of the scene coordinates to be projected.         * @return The normalised screen position of the given scene coordinates.         */
        public function project(point3d:Vector3D):Vector3D
        {
            return this._lens.project( this.inverseSceneTransform.transformVector(point3d));
        }

        /**         * Calculates the scene position of the given normalized coordinates in screen space.         *         * @param nX The normalised x coordinate in screen space, -1 corresponds to the left edge of the viewport, 1 to the right.         * @param nY The normalised y coordinate in screen space, -1 corresponds to the top edge of the viewport, 1 to the bottom.         * @param sZ The z coordinate in screen space, representing the distance into the screen.         * @return The scene position of the given screen coordinates.         */
        public function unproject(nX:Number, nY:Number, sZ:Number):Vector3D
        {
            return this.sceneTransform.transformVector(this._lens.unproject(nX, nY, sZ));
        }

	}
}