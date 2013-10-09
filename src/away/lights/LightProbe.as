/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package away.lights
{
	import away.textures.CubeTextureBase;
	import away.core.partition.EntityNode;
	import away.core.partition.LightProbeNode;
	import away.bounds.BoundingVolumeBase;
	import away.bounds.NullBounds;
	import away.core.base.IRenderable;
	import away.core.geom.Matrix3D;
	import away.errors.Error;
	public class LightProbe extends LightBase
	{
		private var _diffuseMap:CubeTextureBase;
		private var _specularMap:CubeTextureBase;
		
		public function LightProbe(diffuseMap:CubeTextureBase, specularMap:CubeTextureBase = null):void
		{
			specularMap = specularMap || null;

			super();
			this._diffuseMap = diffuseMap;
			this._specularMap = specularMap;
		}
		
		//@override
		override public function pCreateEntityPartitionNode():EntityNode
		{
			return new LightProbeNode( this );
		}
		
		public function get diffuseMap():CubeTextureBase
		{
			return this._diffuseMap;
		}
		
		public function set diffuseMap(value:CubeTextureBase):void
		{
			this._diffuseMap = value;
		}
		
		public function get specularMap():CubeTextureBase
		{
			return this._specularMap;
		}
		
		public function set specularMap(value:CubeTextureBase):void
		{
			this._specularMap = value;
		}
		
		//@override
		override public function pUpdateBounds():void
		{
			this._pBoundsInvalid = false;
		}
		
		//@override
		override public function pGetDefaultBoundingVolume():BoundingVolumeBase
		{
			return new NullBounds();
		}
		
		//@override
		override public function iGetObjectProjectionMatrix(renderable:IRenderable, target:Matrix3D = null):Matrix3D
		{
			target = target || null;

			// TODO: not used
			renderable = renderable;
			target = target;
			
			throw new away.errors.Error( "Object projection matrices are not supported for LightProbe objects!" );
			return null;
		}
	}
}