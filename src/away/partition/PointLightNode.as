/** * ... * @author Gary Paluk - http://www.plugin.io */

///<reference path="../_definitions.ts"/>

package away.partition
{
	import away.lights.PointLight;
	import away.traverse.PartitionTraverser;
	public class PointLightNode extends EntityNode
	{
		
		private var _light:PointLight;
		
		public function PointLightNode(light:PointLight):void
		{
			super( light );
			this._light = light;
		}
		
		public function get light():PointLight
		{
			return this._light;
		}
		
		override public function acceptTraverser(traverser:PartitionTraverser):void
		{
			if( traverser.enterNode( (this as NodeBase) )  )
			{
				super.acceptTraverser( traverser );
				traverser.applyPointLight( this._light );
			}
		}
	}
}