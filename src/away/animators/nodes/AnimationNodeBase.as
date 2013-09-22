///<reference path="../../_definitions.ts"/>
package away.animators.nodes
{
	import away.library.assets.NamedAssetBase;
	import away.library.assets.IAsset;
	import away.library.assets.AssetType;

	/**	 * Provides an abstract base class for nodes in an animation blend tree.	 */
	public class AnimationNodeBase extends NamedAssetBase implements IAsset
	{
		private var _stateClass:*;
		
		public function get stateClass():*
		{
			return this._stateClass;
		}
		
		/**		 * Creates a new <code>AnimationNodeBase</code> object.		 */
		public function AnimationNodeBase():void
		{

            super(null);

		}
		
		/**		 * @inheritDoc		 */
		override public function dispose():void
		{
		}
		
		/**		 * @inheritDoc		 */
		override public function get assetType():String
		{
			return AssetType.ANIMATION_NODE;
		}
	}
}
