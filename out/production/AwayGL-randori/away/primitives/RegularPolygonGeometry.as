/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package away.primitives
{
	
	/**	 * A UV RegularPolygon primitive mesh.	 */
	public class RegularPolygonGeometry extends CylinderGeometry
	{
		
		/**		 * The radius of the regular polygon.		 */
		public function get radius():Number
		{
			return this._pBottomRadius;
		}
		
		public function set radius(value:Number):void
		{
			this._pBottomRadius = value;
			this.pInvalidateGeometry();
		}
		
		/**		 * The number of sides of the regular polygon.		 */
		public function get sides():Number
		{
			return this._pSegmentsW;
		}
		
		public function set sides(value:Number):void
		{
			this.setSegmentsW ( value );
		}
		
		/**		 * The number of subdivisions from the edge to the center of the regular polygon.		 */
		public function get subdivisions():Number
		{
			return this._pSegmentsH;
		}
		
		public function set subdivisions(value:Number):void
		{
			this.setSegmentsH ( value );
		}
		
		/**		 * Creates a new RegularPolygon disc object.		 * @param radius The radius of the regular polygon		 * @param sides Defines the number of sides of the regular polygon.		 * @param yUp Defines whether the regular polygon should lay on the Y-axis (true) or on the Z-axis (false).		 */
		public function RegularPolygonGeometry(radius:Number = 100, sides:Number = 16, yUp:Boolean = true):void
		{
			radius = radius || 100;
			sides = sides || 16;

			super(radius, 0, 0, sides, 1, true, false, false, yUp);
		}
	}
}
