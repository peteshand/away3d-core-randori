/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package away.library
{
	import away.events.EventDispatcher;
	import away.loaders.AssetLoader;
	import away.library.naming.ConflictStrategyBase;
	import away.library.assets.IAsset;
	import away.library.naming.ConflictStrategy;
	import away.library.naming.ConflictPrecedence;
	import away.loaders.misc.SingleFileLoader;
	import away.errors.Error;
	import away.library.utils.AssetLibraryIterator;
	import away.net.URLRequest;
	import away.loaders.misc.AssetLoaderContext;
	import away.loaders.parsers.ParserBase;
	import away.loaders.misc.AssetLoaderToken;
	import away.library.assets.NamedAssetBase;
	import away.library.utils.IDUtil;
	import away.events.AssetEvent;
	import away.events.LoaderEvent;
	import away.events.ParserEvent;
	import randori.webkit.page.Window;

	
	/**	 * AssetLibraryBundle enforces a multiton pattern and is not intended to be instanced directly.	 * Its purpose is to create a container for 3D data management, both before and after parsing.	 * If you are interested in creating multiple library bundles, please use the <code>getInstance()</code> method.	 */
	public class AssetLibraryBundleSingletonEnforcer
	{
	}
	
}// singleton enforcer
