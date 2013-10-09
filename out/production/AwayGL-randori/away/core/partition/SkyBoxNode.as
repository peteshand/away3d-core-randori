/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package away.core.partition
{
	import away.primitives.SkyBox;
	import away.entities.Entity;
	import away.core.traverse.PartitionTraverser;
	import away.core.base.IRenderable;
	import away.core.math.Plane3D;

	/**	 * SkyBoxNode is a space partitioning leaf node that contains a SkyBox object.	 */
	public class SkyBoxNode extends EntityNode
	{
		private var _skyBox:SkyBox;
		
		/**		 * Creates a new SkyBoxNode object.		 * @param skyBox The SkyBox to be contained in the node.		 */
		public function SkyBoxNode(skyBox:SkyBox):void
		{
			super( (skyBox as Entity) );
			this._skyBox = skyBox;
		}
		
		/**		 * @inheritDoc		 */
		override public function acceptTraverser(traverser:PartitionTraverser):void
		{
			if (traverser.enterNode(this))
            {
				super.acceptTraverser(traverser);
				traverser.applySkyBox( (this._skyBox as IRenderable));
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
