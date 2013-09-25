/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package away.partition
{
	import away.lights.LightBase;
	import away.traverse.PartitionTraverser;
	public class LightNode extends EntityNode
	{
		
		private var _light:LightBase;
		
		public function LightNode(light:LightBase):void
		{
			super( light );
			this._light = light;
		}
		
		public function get light():LightBase
		{
			return this._light;
		}
		
		//@override
		override public function acceptTraverser(traverser:PartitionTraverser):void
		{
			if( traverser.enterNode(this))
			{
				super.acceptTraverser( traverser );
				traverser.applyUnknownLight( this._light);
			}
		}
	}
}