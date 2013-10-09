/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package away.library
{
	import away.loaders.misc.SingleFileLoader;
	import away.library.naming.ConflictStrategyBase;
	import away.library.utils.AssetLibraryIterator;
	import away.core.net.URLRequest;
	import away.loaders.misc.AssetLoaderContext;
	import away.loaders.parsers.ParserBase;
	import away.loaders.misc.AssetLoaderToken;
	import away.library.assets.IAsset;

	/**	 * AssetLibrary enforces a singleton pattern and is not intended to be instanced.	 * It's purpose is to allow access to the default library bundle through a set of static shortcut methods.	 * If you are interested in creating multiple library bundles, please use the <code>getBundle()</code> method.	 */
	public class AssetLibrarySingletonEnforcer
	{
	}
	
}// singleton enforcer
