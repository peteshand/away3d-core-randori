/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package away.lights
{
	import away.core.geom.Vector3D;
	import away.core.partition.EntityNode;
	import away.core.partition.DirectionalLightNode;
	import away.bounds.BoundingVolumeBase;
	import away.bounds.NullBounds;
	import away.lights.shadowmaps.ShadowMapperBase;
	import away.lights.shadowmaps.DirectionalShadowMapper;
	import away.core.base.IRenderable;
	import away.core.geom.Matrix3D;
	public class DirectionalLight extends LightBase
	{
		
		private var _direction:Vector3D;
		private var _tmpLookAt:Vector3D;
		private var _sceneDirection:Vector3D;
		private var _projAABBPoints:Vector.<Number>;
		
		public function DirectionalLight(xDir:Number = 0, yDir:Number = -1, zDir:Number = 1):void
		{
			xDir = xDir || 0;
			yDir = yDir || -1;
			zDir = zDir || 1;

			super();
			this.direction = new Vector3D( xDir, yDir, zDir );
			this._sceneDirection = new Vector3D();
		}
		
		//@override
		override public function pCreateEntityPartitionNode():EntityNode
		{
			return new DirectionalLightNode( this );
		}
		
		public function get sceneDirection():Vector3D
		{
			if( this._pSceneTransformDirty )
			{
				this.pUpdateSceneTransform();
			}
			return this._sceneDirection;
		}
		
		public function get direction():Vector3D
		{
			return this._direction;
		}
		
		public function set direction(value:Vector3D):void
		{
			this._direction = value;

			if (!this._tmpLookAt)
			{
				this._tmpLookAt = new Vector3D();
			}
			this._tmpLookAt.x = this.x + this._direction.x;
			this._tmpLookAt.y = this.y + this._direction.y;
			this._tmpLookAt.z = this.z + this._direction.z;
			
			this.lookAt( this._tmpLookAt );
		}
		
		//@override
		override public function pGetDefaultBoundingVolume():BoundingVolumeBase
		{
			return new NullBounds();
		}
		
		//@override
		override public function pUpdateBounds():void
		{
		}
		
		//@override
		override public function pUpdateSceneTransform():void
		{
			super.pUpdateSceneTransform();
			this.sceneTransform.copyColumnTo( 2, this._sceneDirection );
			this._sceneDirection.normalize();
		}
		
		//@override
		override public function pCreateShadowMapper():ShadowMapperBase
		{
			return new DirectionalShadowMapper();
		}
		
		//override
		override public function iGetObjectProjectionMatrix(renderable:IRenderable, target:Matrix3D = null):Matrix3D
		{
			target = target || null;

			var raw:Vector.<Number> = new Vector.<Number>();
			var bounds:BoundingVolumeBase = renderable.sourceEntity.bounds;
			var m:Matrix3D = new Matrix3D();
			
			m.copyFrom( renderable.sceneTransform );
			m.append( this.inverseSceneTransform );
			
			if( !this._projAABBPoints )
			{
				this._projAABBPoints = new <Number>[];
			}
			m.transformVectors( bounds.aabbPoints, this._projAABBPoints );
			
			var xMin:Number = Infinity, xMax:Number = -Infinity;
			var yMin:Number = Infinity, yMax:Number = -Infinity;
			var zMin:Number = Infinity, zMax:Number = -Infinity;
			var d:Number;
			for( var i:Number = 0; i < 24; ) {
				d = this._projAABBPoints[i++];
				if (d < xMin)
					xMin = d;
				if (d > xMax)
					xMax = d;
				d = this._projAABBPoints[i++];
				if (d < yMin)
					yMin = d;
				if (d > yMax)
					yMax = d;
				d = this._projAABBPoints[i++];
				if (d < zMin)
					zMin = d;
				if (d > zMax)
					zMax = d;
			}
			
			var invXRange:Number = 1/(xMax - xMin);
			var invYRange:Number = 1/(yMax - yMin);
			var invZRange:Number = 1/(zMax - zMin);
			raw[0] = 2*invXRange;
			raw[5] = 2*invYRange;
			raw[10] = invZRange;
			raw[12] = -(xMax + xMin)*invXRange;
			raw[13] = -(yMax + yMin)*invYRange;
			raw[14] = -zMin*invZRange;
			raw[11] =  0;
			raw[9] = raw[11]
			raw[8] = raw[9]
			raw[7] = raw[8]
			raw[6] = raw[7]
			raw[4] = raw[6]
			raw[3] = raw[4]
			raw[2] = raw[3]
			raw[1] = raw[2]
			raw[15] = 1;
			
			if( !target )
			{
				target = new Matrix3D();
			}
			target.copyRawDataFrom( raw );
			target.prepend( m );
			
			return target;
		}
	}
}