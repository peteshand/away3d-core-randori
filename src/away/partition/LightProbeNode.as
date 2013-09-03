/** * ... * @author Gary Paluk - http://www.plugin.io */

///<reference path="../_definitions.ts"/>

package away.partition
{
	import away.lights.LightProbe;
	import away.traverse.PartitionTraverser;
	public class LightProbeNode extends EntityNode
	{
		private var _light:LightProbe;
		
		public function LightProbeNode(light:LightProbe):void
		{
			super( light );
			this._light = light;
		}
		
		public function get light():LightProbe
		{
			return _light;
		}
		
		//@override
		override public function acceptTraverser(traverser:PartitionTraverser):void
		{
			if( traverser.enterNode(this))
			{
				super.acceptTraverser( traverser );
				traverser.applyLightProbe( _light );
			}
		}
	}
}