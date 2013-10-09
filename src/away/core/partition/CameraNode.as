/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package away.core.partition
{
	import away.cameras.Camera3D;
	import away.core.traverse.PartitionTraverser;
	public class CameraNode extends EntityNode
	{
		public function CameraNode(camera:Camera3D):void
		{
			super( camera );
		}
		
		//@override
		override public function acceptTraverser(traverser:PartitionTraverser):void
		{
			// todo: dead end for now, if it has a debug mesh, then sure accept that
		}
	}
}