/** * ... * @author Gary Paluk - http://www.plugin.io */

package away.partition
{
	import away.lights.DirectionalLight;
	import away.traverse.PartitionTraverser;
	public class DirectionalLightNode extends EntityNode
	{
		
		private var _light:DirectionalLight;
		
		public function DirectionalLightNode(light:DirectionalLight):void
		{
			super( light );
			this._light = light;
		}
		
		public function get light():DirectionalLight
		{
			return this._light;
		}
		
		//@override
		override public function acceptTraverser(traverser:PartitionTraverser):void
		{
			if( traverser.enterNode(this))
			{
				super.acceptTraverser( traverser );
				traverser.applyDirectionalLight( this._light );
			}
		}
	}
}