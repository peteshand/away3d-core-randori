///<reference path="../_definitions.ts"/>
package away.primitives
{
	
	/**
	 * A UV RegularPolygon primitive mesh.
	 */
	public class RegularPolygonGeometry extends CylinderGeometry
	{
		
		/**
		 * The radius of the regular polygon.
		 */
		public function get radius():Number
		{
			return _pBottomRadius;
		}
		
		public function set radius(value:Number):void
		{
			_pBottomRadius = value;
			pInvalidateGeometry();
		}
		
		/**
		 * The number of sides of the regular polygon.
		 */
		public function get sides():Number
		{
			return _pSegmentsW;
		}
		
		public function set sides(value:Number):void
		{
			setSegmentsW ( value );
		}
		
		/**
		 * The number of subdivisions from the edge to the center of the regular polygon.
		 */
		public function get subdivisions():Number
		{
			return _pSegmentsH;
		}
		
		public function set subdivisions(value:Number):void
		{
			setSegmentsH ( value );
		}
		
		/**
		 * Creates a new RegularPolygon disc object.
		 * @param radius The radius of the regular polygon
		 * @param sides Defines the number of sides of the regular polygon.
		 * @param yUp Defines whether the regular polygon should lay on the Y-axis (true) or on the Z-axis (false).
		 */
		public function RegularPolygonGeometry(radius:Number = 100, sides:Number = 16, yUp:Boolean = true):void
		{
			super(radius, 0, 0, sides, 1, true, false, false, yUp);
		}
	}
}
