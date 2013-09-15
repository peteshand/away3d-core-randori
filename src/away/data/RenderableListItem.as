/** * ... * @author Gary Paluk - http://www.plugin.io */

///<reference path="../_definitions.ts"/>

package away.data
{
	import away.base.IRenderable;
	import away.geom.Matrix3D;
	public class RenderableListItem
	{
		
		public var next:RenderableListItem;
		public var renderable:IRenderable;
		
		public var materialId:Number;
		public var renderOrderId:Number;
		public var zIndex:Number;
		public var renderSceneTransform:Matrix3D;
		
		public var cascaded:Boolean;
		
		public function RenderableListItem():void
		{
		}
	}
}