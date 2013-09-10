/** * ... * @author Gary Paluk - http://www.plugin.io */

///<reference path="../_definitions.ts"/>

package away.lights
{
	import away.lights.shadowmaps.ShadowMapperBase;
	import away.lights.shadowmaps.CubeMapShadowMapper;
	import away.partition.EntityNode;
	import away.partition.PointLightNode;
	import away.geom.Vector3D;
	import away.bounds.BoundingVolumeBase;
	import away.bounds.BoundingSphere;
	import away.base.IRenderable;
	import away.geom.Matrix3D;
	public class PointLight extends LightBase
	{
		
		public var _pRadius:Number = 90000;
		public var _pFallOff:Number = 100000;
		public var _pFallOffFactor:Number;
		
		public function PointLight():void
		{
			super();
			_pFallOffFactor = 1/(_pFallOff*_pFallOff - _pRadius*_pRadius);
		}
		
		override public function pCreateShadowMapper():ShadowMapperBase
		{
			return new CubeMapShadowMapper();
		}
		
		override public function pCreateEntityPartitionNode():EntityNode
		{
			return new PointLightNode( this );
		}
		
		public function get radius():Number
		{
			return _pRadius;
		}
		
		public function set radius(value:Number):void
		{
			_pRadius = value;
			if (_pRadius < 0)
			{
				_pRadius = 0;
			}
			else if( _pRadius > _pFallOff )
			{
				_pFallOff = _pRadius;
				pInvalidateBounds();
			}
			_pFallOffFactor = 1/( _pFallOff*_pFallOff - _pRadius*_pRadius );
		}
		
		public function iFallOffFactor():Number
		{
			return _pFallOffFactor;
		}
		
		public function get fallOff():Number
		{
			return _pFallOff;
		}
		
		public function set fallOff(value:Number):void
		{
			_pFallOff = value;
			if( _pFallOff < 0)
			{
				_pFallOff = 0;
			}
			if( _pFallOff < _pRadius )
			{
				_pRadius = _pFallOff;
			}
			_pFallOffFactor = 1/( _pFallOff*_pFallOff - _pRadius*_pRadius);
			pInvalidateBounds();
		}
		
		override public function pUpdateBounds():void
		{
			_pBounds.fromSphere( new Vector3D(), _pFallOff );
			_pBoundsInvalid = false;
		}
		
		override public function pGetDefaultBoundingVolume():BoundingVolumeBase
		{
			return new BoundingSphere();
		}
		
		override public function iGetObjectProjectionMatrix(renderable:IRenderable, target:Matrix3D = null):Matrix3D
		{
			var raw:Vector.<Number> = new Vector.<Number>();
			var bounds:BoundingVolumeBase = renderable.sourceEntity.bounds;
			var m:Matrix3D = new Matrix3D();
			
			// todo: do not use lookAt on Light
			m.copyFrom( renderable.sceneTransform );
			m.append( _pParent.inverseSceneTransform );
			lookAt( m.position );
			
			m.copyFrom( renderable.sceneTransform );
			m.append( inverseSceneTransform );
			m.copyColumnTo( 3, _pPos );
			
			var v1:Vector3D = m.deltaTransformVector( bounds.min );
			var v2:Vector3D = m.deltaTransformVector( bounds.max );
			var z:Number = _pPos.z;
			var d1:Number = v1.x*v1.x + v1.y*v1.y + v1.z*v1.z;
			var d2:Number = v2.x*v2.x + v2.y*v2.y + v2.z*v2.z;
			var d:Number = Math.sqrt(d1 > d2? d1 : d2);
			var zMin:Number;
			var zMax:Number;
			
			zMin = z - d;
			zMax = z + d;
			
			raw[5] = raw[0] = zMin/d;
			raw[10] = zMax/(zMax - zMin);
			raw[11] = 1;
			raw[1] = raw[2] = raw[3] = raw[4] =
				raw[6] = raw[7] = raw[8] = raw[9] =
				raw[12] = raw[13] = raw[15] = 0;
			raw[14] = -zMin*raw[10];
			
			if(!target)
			{
				target = new Matrix3D();
			}
			target.copyRawDataFrom(raw);
			target.prepend(m);
			
			return target;
		}
	}
}