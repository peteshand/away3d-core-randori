/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package away.data
{
	import away.base.IRenderable;
	import away.geom.Matrix3D;
	public class RenderableListItem
	{
		
		public var next:RenderableListItem;
		public var renderable:IRenderable;
		
		public var materialId:Number = 0;
		public var renderOrderId:Number = 0;
		public var zIndex:Number = 0;
		public var renderSceneTransform:Matrix3D;
		
		public var cascaded:Boolean = false;
		
		public function RenderableListItem():void
		{
		}
	}
}