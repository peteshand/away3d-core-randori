///<reference path="../_definitions.ts"/>

package away.primitives
{
	import away.geom.Vector3D;
	//import flash.geom.Vector3D;
	
	/**
	public class WireframeRegularPolygon extends WireframePrimitiveBase
	{
		public static var ORIENTATION_YZ:String = "yz";
		public static var ORIENTATION_XY:String = "xy";
		public static var ORIENTATION_XZ:String = "xz";
		
		private var _radius:Number;
		private var _sides:Number;
		private var _orientation:String;
		
		/**
		public function WireframeRegularPolygon(radius:Number, sides:Number, color:Number = 0xFFFFFF, thickness:Number = 1, orientation:String = "yz"):void
		{
			super(color, thickness);
			
			this._radius = radius;
            this._sides = sides;
            this._orientation = orientation;
		}
		
		/**
		public function get orientation():String
		{
			return _orientation;
		}
		
		public function set orientation(value:String):void
		{
            this._orientation = value;
            this.pInvalidateGeometry();
		}
		
		/**
		public function get radius():Number
		{
			return _radius;
		}
		
		public function set radius(value:Number):void
		{
            this._radius = value;
            this.pInvalidateGeometry();
		}
		
		/**
		public function get sides():Number
		{
			return _sides;
		}
		
		public function set sides(value:Number):void
		{
            this._sides = value;
            this.removeAllSegments();
            this.pInvalidateGeometry();
		}
		
		/**
		override public function pBuildGeometry():void
		{
			var v0:Vector3D = new Vector3D();
			var v1:Vector3D = new Vector3D();
			var index:Number = 0;
			var s:Number;
			
			if (_orientation == WireframeRegularPolygon.ORIENTATION_XY)
            {
				v0.z = 0;
				v1.z = 0;
				
				for (s = 0; s < _sides; ++s)
                {
					v0.x = _radius*Math.cos(2*Math.PI*s/_sides);
					v0.y = _radius*Math.sin(2*Math.PI*s/_sides);
					v1.x = _radius*Math.cos(2*Math.PI*(s + 1)/_sides);
					v1.y = _radius*Math.sin(2*Math.PI*(s + 1)/_sides);
					pUpdateOrAddSegment(index++, v0, v1);
				}
			}
			else if (_orientation == WireframeRegularPolygon.ORIENTATION_XZ)
            {

				v0.y = 0;
				v1.y = 0;
				
				for (s = 0; s < _sides; ++s)
                {
					v0.x = _radius*Math.cos(2*Math.PI*s/_sides);
					v0.z = _radius*Math.sin(2*Math.PI*s/_sides);
					v1.x = _radius*Math.cos(2*Math.PI*(s + 1)/_sides);
					v1.z = _radius*Math.sin(2*Math.PI*(s + 1)/_sides);
                    pUpdateOrAddSegment(index++, v0, v1);
				}
			}
			else if (_orientation == WireframeRegularPolygon.ORIENTATION_YZ)
            {
				v0.x = 0;
				v1.x = 0;
				
				for (s = 0; s < _sides; ++s)
                {
					v0.z = _radius*Math.cos(2*Math.PI*s/_sides);
					v0.y = _radius*Math.sin(2*Math.PI*s/_sides);
					v1.z = _radius*Math.cos(2*Math.PI*(s + 1)/_sides);
					v1.y = _radius*Math.sin(2*Math.PI*(s + 1)/_sides);
                    pUpdateOrAddSegment(index++, v0, v1);
				}
			}
		}
	
	}
}