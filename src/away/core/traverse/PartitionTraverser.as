/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package away.core.traverse
{
	import away.containers.Scene3D;
	import away.core.geom.Vector3D;
	import away.core.partition.NodeBase;
	import away.core.base.IRenderable;
	import away.errors.AbstractMethodError;
	import away.lights.LightBase;
	import away.lights.DirectionalLight;
	import away.lights.PointLight;
	import away.lights.LightProbe;
	import away.entities.Entity;
	public class PartitionTraverser
	{
		public var scene:Scene3D;
		
		public var _iEntryPoint:Vector3D;
		public static var _iCollectionMark:Number = 0;
		
		public function PartitionTraverser():void
		{
		}
		
		public function enterNode(node:NodeBase):Boolean
		{
			node = node;
			return true;
		}
		
		public function applySkyBox(renderable:IRenderable):void
		{
			throw new AbstractMethodError();
		}
		
		public function applyRenderable(renderable:IRenderable):void
		{
			throw new AbstractMethodError();
		}
		
		public function applyUnknownLight(light:LightBase):void
		{
			throw new AbstractMethodError();
		}
		
		public function applyDirectionalLight(light:DirectionalLight):void
		{
			throw new AbstractMethodError();
		}
		
		public function applyPointLight(light:PointLight):void
		{
			throw new AbstractMethodError();
		}
		
		public function applyLightProbe(light:LightProbe):void
		{
			throw new AbstractMethodError();
		}
		
		public function applyEntity(entity:Entity):void
		{
			throw new AbstractMethodError();
		}
		
		public function get entryPoint():Vector3D
		{
			return this._iEntryPoint;
		}
	}
}