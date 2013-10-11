/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package away.core.traverse
{
	import away.core.geom.Vector3D;
	import away.core.partition.NodeBase;
	import away.core.base.IRenderable;
	import away.lights.LightBase;

	/**
	public class RaycastCollector extends EntityCollector
	{
		private var _rayPosition:Vector3D = new Vector3D();
		private var _rayDirection:Vector3D = new Vector3D();
		
		/**
		public function RaycastCollector():void
		{

            super();

		}
		
		/**
		public function get rayPosition():Vector3D
		{
			return this._rayPosition;
		}
		
		public function set rayPosition(value:Vector3D):void
		{
            this._rayPosition = value;
		}
		
		/**
		public function get rayDirection():Vector3D
		{
			return this._rayDirection;
		}
		
		public function set rayDirection(value:Vector3D):void
		{
            this._rayDirection = value;
		}
		
		/**
		override public function enterNode(node:NodeBase):Boolean
		{
			return node.isIntersectingRay(this._rayPosition, this._rayDirection);
		}
		
		/**
		override public function applySkyBox(renderable:IRenderable):void
		{
		}
		
		/**
		override public function applyRenderable(renderable:IRenderable):void
		{
		}
		
		/**
		override public function applyUnknownLight(light:LightBase):void
		{
		}
	}
}