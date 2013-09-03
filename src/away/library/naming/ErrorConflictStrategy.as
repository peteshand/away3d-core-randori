///<reference path="../../_definitions.ts"/>

package away.library.naming
{
	import away.library.assets.IAsset;
	import away.errors.Error;
	//import away3d.library.assets.IAsset;
	
	public class ErrorConflictStrategy extends ConflictStrategyBase
	{
		public function ErrorConflictStrategy():void
		{
			super();
		}
		
		override public function resolveConflict(changedAsset:IAsset, oldAsset:IAsset, assetsDictionary:Object, precedence:String):void
		{
			throw new away.errors.Error('Asset name collision while AssetLibrary.namingStrategy set to AssetLibrary.THROW_ERROR. Asset path: ' + changedAsset.assetFullPath );
		}
		
		override public function create():ConflictStrategyBase
		{
			return new ErrorConflictStrategy();
		}
	}
}
