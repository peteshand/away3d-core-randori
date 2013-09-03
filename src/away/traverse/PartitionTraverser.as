/** * ... * @author Gary Paluk - http://www.plugin.io */

///<reference path="../_definitions.ts"/>

package away.traverse
{
	import away.containers.Scene3D;
	import away.geom.Vector3D;
	import away.partition.NodeBase;
	import away.base.IRenderable;
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
			return _iEntryPoint;
		}
	}
}