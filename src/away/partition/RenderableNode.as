///<reference path="../_definitions.ts"/>

package away.partition
{
	import away.base.IRenderable;
	import away.entities.Entity;
	import away.traverse.PartitionTraverser;

	/**
	public class RenderableNode extends EntityNode
	{
		private var _renderable:IRenderable;
		
		/**
		public function RenderableNode(renderable:IRenderable):void
		{

            var e : * = renderable;

			super( Entity(e));

			this._renderable = renderable; // also keep a stronger typed reference
		}
		
		/**
		override public function acceptTraverser(traverser:PartitionTraverser):void
		{
			if (traverser.enterNode(this))
            {

				super.acceptTraverser(traverser);

				traverser.applyRenderable(_renderable);

			}
		}
	
	}
}