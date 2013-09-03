
///<reference path="../../_definitions.ts"/>

package away.library.naming
{
	import away.library.assets.IAsset;
	//import away3d.library.assets.IAsset;
	
	public class IgnoreConflictStrategy extends ConflictStrategyBase
	{
		public function IgnoreConflictStrategy():void
		{
			super();
		}
		
		override public function resolveConflict(changedAsset:IAsset, oldAsset:IAsset, assetsDictionary:Object, precedence:String):void
		{
			// Do nothing, ignore the fact that there is a conflict.
			return;
		}
		
		override public function create():ConflictStrategyBase
		{
			return new IgnoreConflictStrategy();
		}
	}
}
