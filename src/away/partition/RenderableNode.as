/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package away.partition
{
	import away.base.IRenderable;
	import away.entities.Entity;
	import away.traverse.PartitionTraverser;

	/**	 * RenderableNode is a space partitioning leaf node that contains any Entity that is itself a IRenderable	 * object. This excludes Mesh (since the renderable objects are its SubMesh children).	 */
	public class RenderableNode extends EntityNode
	{
		private var _renderable:IRenderable;
		
		/**		 * Creates a new RenderableNode object.		 * @param mesh The mesh to be contained in the node.		 */
		public function RenderableNode(renderable:IRenderable):void
		{

            var e : * = renderable;

			super( (e as Entity) );

			this._renderable = renderable; // also keep a stronger typed reference
		}
		
		/**		 * @inheritDoc		 */
		override public function acceptTraverser(traverser:PartitionTraverser):void
		{
			if (traverser.enterNode(this))
            {

				super.acceptTraverser(traverser);

				traverser.applyRenderable(this._renderable);

			}
		}
	
	}
}
