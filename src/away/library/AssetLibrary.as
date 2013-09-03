

///<reference path="../_definitions.ts"/>

package away.library
{
	import away.loaders.misc.SingleFileLoader;
	import away.library.naming.ConflictStrategyBase;
	import away.library.utils.AssetLibraryIterator;
	import away.net.URLRequest;
	import away.loaders.misc.AssetLoaderContext;
	import away.loaders.parsers.ParserBase;
	import away.loaders.misc.AssetLoaderToken;
	import away.library.assets.IAsset;

	/**
	public class AssetLibrary
	{
		public static var _iInstances:Object = {};
		
		/**
        //*
		public function AssetLibrary(se:AssetLibrarySingletonEnforcer):void
		{
			se = se;
		}
		//*/
		/**
		public static function getBundle(key:String = 'default'):AssetLibraryBundle
		{
			return AssetLibraryBundle.getInstance(key);
		}
		
		/**
		public static function enableParser(parserClass):void
		{
			SingleFileLoader.enableParser(parserClass);
		}
		
		/**
		public static function enableParsers(parserClasses:Vector.<Object>):void
		{
            SingleFileLoader.enableParsers(parserClasses);
		}
		
		/**
		public static function get conflictStrategy():ConflictStrategyBase
		{
			return AssetLibrary.getBundle().conflictStrategy;
		}
		
		public static function set conflictStrategy(val:ConflictStrategyBase):void
		{
            AssetLibrary.getBundle().conflictStrategy = val;
		}
		
		/**
		public static function get conflictPrecedence():String
		{
			return AssetLibrary.getBundle().conflictPrecedence;
		}
		
		public static function set conflictPrecedence(val:String):void
		{
            AssetLibrary.getBundle().conflictPrecedence = val;
		}
		
		/**
		public static function createIterator(assetTypeFilter:String = null, namespaceFilter:String = null, filterFunc = null):AssetLibraryIterator
		{
			return AssetLibrary.getBundle().createIterator(assetTypeFilter, namespaceFilter, filterFunc);
		}
		
		/**
		public static function load(req:URLRequest, context:AssetLoaderContext = null, ns:String = null, parser:ParserBase = null):AssetLoaderToken
		{
			return AssetLibrary.getBundle().load(req, context, ns, parser);
		}
		
		/**
		public static function loadData(data:*, context:AssetLoaderContext = null, ns:String = null, parser:ParserBase = null):AssetLoaderToken
		{
			return AssetLibrary.getBundle().loadData(data, context, ns, parser);
		}
		
		public static function stopLoad():void
		{
            AssetLibrary.getBundle().stopAllLoadingSessions();
		}
		
		/**
		public static function getAsset(name:String, ns:String = null):IAsset
		{
			return AssetLibrary.getBundle().getAsset(name, ns);
		}
		
		/**
		public static function addEventListener(type:String, listener:Function, target:Object):void
		{
            AssetLibrary.getBundle().addEventListener(type, listener, target );
		}
		
		/**
		public static function removeEventListener(type:String, listener:Function, target:Object):void
		{
            AssetLibrary.getBundle().removeEventListener(type , listener , target );
		}
		
		/**

		/**
		public static function addAsset(asset:IAsset):void
		{
			AssetLibrary.getBundle().addAsset(asset);
		}
		
		/**
		public static function removeAsset(asset:IAsset, dispose:Boolean = true):void
		{
            AssetLibrary.getBundle().removeAsset(asset, dispose);
		}
		
		/**
		public static function removeAssetByName(name:String, ns:String = null, dispose:Boolean = true):IAsset
		{
			return AssetLibrary.getBundle().removeAssetByName(name, ns, dispose);
		}
		
		/**
		public static function removeAllAssets(dispose:Boolean = true):void
		{
            AssetLibrary.getBundle().removeAllAssets(dispose);
		}
		
		/**
		public static function removeNamespaceAssets(ns:String = null, dispose:Boolean = true):void
		{
            AssetLibrary.getBundle().removeNamespaceAssets(ns, dispose);
		}
	}
}

import away.loaders.misc.SingleFileLoader;
import away.library.naming.ConflictStrategyBase;
import away.library.utils.AssetLibraryIterator;
import away.net.URLRequest;
import away.loaders.misc.AssetLoaderContext;
import away.loaders.parsers.ParserBase;
import away.loaders.misc.AssetLoaderToken;
import away.library.assets.IAsset;

class AssetLibrarySingletonEnforcer
{
}
// singleton enforcer