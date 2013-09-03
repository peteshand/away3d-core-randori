///<reference path="../_definitions.ts"/>

package away.primitives
{
	
	/**
	public class RegularPolygonGeometry extends CylinderGeometry
	{
		
		/**
		public function get radius():Number
		{
			return _pBottomRadius;
		}
		
		public function set radius(value:Number):void
		{
			this._pBottomRadius = value;
			this.pInvalidateGeometry();
		}
		
		/**
		public function get sides():Number
		{
			return _pSegmentsW;
		}
		
		public function set sides(value:Number):void
		{
			this.setSegmentsW ( value );
		}
		
		/**
		public function get subdivisions():Number
		{
			return _pSegmentsH;
		}
		
		public function set subdivisions(value:Number):void
		{
			this.setSegmentsH ( value );
		}
		
		/**
		public function RegularPolygonGeometry(radius:Number = 100, sides:Number = 16, yUp:Boolean = true):void
		{
			super(radius, 0, 0, sides, 1, true, false, false, yUp);
		}
	}
}