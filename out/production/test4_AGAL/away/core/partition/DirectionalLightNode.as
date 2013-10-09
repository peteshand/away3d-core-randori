/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package away.core.partition
{
	import away.lights.DirectionalLight;
	import away.core.traverse.PartitionTraverser;
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