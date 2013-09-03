/** * ... * @author Gary Paluk - http://www.plugin.io */

///<reference path="../_definitions.ts" />

package away.lights
{
	import away.geom.Vector3D;
	import away.partition.EntityNode;
	import away.partition.DirectionalLightNode;
	import away.bounds.BoundingVolumeBase;
	import away.bounds.NullBounds;
	import away.lights.shadowmaps.ShadowMapperBase;
	import away.lights.shadowmaps.DirectionalShadowMapper;
	import away.base.IRenderable;
	import away.geom.Matrix3D;
	public class DirectionalLight extends LightBase
	{
		
		private var _direction:Vector3D;
		private var _tmpLookAt:Vector3D;
		private var _sceneDirection:Vector3D;
		private var _projAABBPoints:Vector.<Number>;
		
		public function DirectionalLight(xDir:Number = 0, yDir:Number = -1, zDir:Number = 1):void
		{
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
			if( _pSceneTransformDirty )
			{
				pUpdateSceneTransform();
			}
			return _sceneDirection;
		}
		
		public function get direction():Vector3D
		{
			return _direction;
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
			sceneTransform.copyColumnTo( 2, _sceneDirection );
			_sceneDirection.normalize();
		}
		
		//@override
		override public function pCreateShadowMapper():ShadowMapperBase
		{
			return new DirectionalShadowMapper();
		}
		
		//override
		override public function iGetObjectProjectionMatrix(renderable:IRenderable, target:Matrix3D = null):Matrix3D
		{
			var raw:Vector.<Number> = new Vector.<Number>();
			var bounds:BoundingVolumeBase = renderable.sourceEntity.bounds;
			var m:Matrix3D = new Matrix3D();
			
			m.copyFrom( renderable.sceneTransform );
			m.append( inverseSceneTransform );
			
			if( !_projAABBPoints )
			{
				_projAABBPoints = new <Number>[];
			}
			m.transformVectors( bounds.aabbPoints, _projAABBPoints );
			
			var xMin:Number = Infinity, xMax:Number = -Infinity;
			var yMin:Number = Infinity, yMax:Number = -Infinity;
			var zMin:Number = Infinity, zMax:Number = -Infinity;
			var d:Number;
			for( var i:Number = 0; i < 24; ) {
				d = _projAABBPoints[i++];
				if (d < xMin)
					xMin = d;
				if (d > xMax)
					xMax = d;
				d = _projAABBPoints[i++];
				if (d < yMin)
					yMin = d;
				if (d > yMax)
					yMax = d;
				d = _projAABBPoints[i++];
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
			raw[1] = raw[2] = raw[3] = raw[4] = raw[6] = raw[7] = raw[8] = raw[9] = raw[11] = 0;
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