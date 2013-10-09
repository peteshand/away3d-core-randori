/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package away.core.math
{
	
	public class PlaneClassification
	{
		// "back" is synonymous with "in", but used for planes (back of plane is "inside" a solid volume walled by a plane)
		public static var BACK:Number = 0;
		public static var FRONT:Number = 1;
		
		public static var IN:Number = 0;
		public static var OUT:Number = 1;
		public static var INTERSECT:Number = 2;

	}
}
