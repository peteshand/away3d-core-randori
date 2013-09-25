/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package away.primitives
{
	
	/**	 * A UV Cone primitive mesh.	 */
	public class ConeGeometry extends CylinderGeometry
	{
		
		/**		 * The radius of the bottom end of the cone.		 */
		public function get radius():Number
		{
			return this._pBottomRadius;
		}
		
		public function set radius(value:Number):void
		{
			this._pBottomRadius = value;
            this.pInvalidateGeometry();
		}
		
		/**		 * Creates a new Cone object.		 * @param radius The radius of the bottom end of the cone		 * @param height The height of the cone		 * @param segmentsW Defines the number of horizontal segments that make up the cone. Defaults to 16.		 * @param segmentsH Defines the number of vertical segments that make up the cone. Defaults to 1.		 * @param yUp Defines whether the cone poles should lay on the Y-axis (true) or on the Z-axis (false).		 */
		public function ConeGeometry(radius:Number = 50, height:Number = 100, segmentsW:Number = 16, segmentsH:Number = 1, closed:Boolean = true, yUp:Boolean = true):void
		{
			radius = radius || 50;
			height = height || 100;
			segmentsW = segmentsW || 16;
			segmentsH = segmentsH || 1;
			closed = closed || true;
			yUp = yUp || true;

			super(0, radius, height, segmentsW, segmentsH, false, closed, true, yUp);
		}
	}
}
