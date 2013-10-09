/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

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
