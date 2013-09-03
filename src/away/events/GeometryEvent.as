///<reference path="../_definitions.ts"/>
package away.events
{
	import away.base.ISubGeometry;

	/**
	public class GeometryEvent extends Event
	{
		/**
		public static var SUB_GEOMETRY_ADDED:String = "SubGeometryAdded";
		
		/**
		public static var SUB_GEOMETRY_REMOVED:String = "SubGeometryRemoved";
		
		public static var BOUNDS_INVALID:String = "BoundsInvalid";
		
		private var _subGeometry:ISubGeometry;
		
		/**
		public function GeometryEvent(type:String, subGeometry:ISubGeometry = null):void
		{
			super( type ) //, false, false);
			this._subGeometry = subGeometry;
		}
		
		/**
		public function get subGeometry():ISubGeometry
		{
			return _subGeometry;
		}
		
		/**
		override public function clone():Event
		{
			return new GeometryEvent( type , _subGeometry );
		}
	}
}