/** * ... * @author Gary Paluk - http://www.plugin.io */

///<reference path="../_definitions.ts" />


package away.partition
{
	import away.cameras.Camera3D;
	import away.traverse.PartitionTraverser;
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