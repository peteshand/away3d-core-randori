///<reference path="../_definitions.ts"/>

package away.primitives
{
	
	/**
	public class ConeGeometry extends CylinderGeometry
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
		public function ConeGeometry(radius:Number = 50, height:Number = 100, segmentsW:Number = 16, segmentsH:Number = 1, closed:Boolean = true, yUp:Boolean = true):void
		{
			super(0, radius, height, segmentsW, segmentsH, false, closed, true, yUp);
		}
	}
}