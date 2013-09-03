///<reference path="../_definitions.ts"/>

package away.partition
{
	import away.entities.SkyBox;
	import away.traverse.PartitionTraverser;
	import away.math.Plane3D;

	/**	 * SkyBoxNode is a space partitioning leaf node that contains a SkyBox object.	 */
	public class SkyBoxNode extends EntityNode
	{
		private var _skyBox:SkyBox;
		
		/**		 * Creates a new SkyBoxNode object.		 * @param skyBox The SkyBox to be contained in the node.		 */
		public function SkyBoxNode(skyBox:SkyBox):void
		{
			super(skyBox);
			this._skyBox = skyBox;
		}
		
		/**		 * @inheritDoc		 */
		override public function acceptTraverser(traverser:PartitionTraverser):void
		{


			if (traverser.enterNode(this)) {
				super.acceptTraverser(traverser);
				traverser.applySkyBox(_skyBox);
			}
		}
		
		override public function isInFrustum(planes:Vector.<Plane3D>, numPlanes:Number):Boolean
		{

			planes = planes;
			numPlanes = numPlanes;

			return true;
		}
	}
}
