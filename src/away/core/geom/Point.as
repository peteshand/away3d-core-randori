/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package away.core.geom
{
	public class Point
	{
		public var x:Number = 0;
		public var y:Number = 0;
		
		public function Point(x:Number = 0, y:Number = 0):void
		{
			x = x || 0;
			y = y || 0;

			this.x = x;
			this.y = y;
		}
		
	}
}