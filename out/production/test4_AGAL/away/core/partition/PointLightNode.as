/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package away.core.partition
{
	import away.lights.PointLight;
	import away.core.traverse.PartitionTraverser;
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