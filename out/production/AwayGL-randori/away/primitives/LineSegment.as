/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package away.primitives
{
	import away.primitives.data.Segment;
	import away.core.geom.Vector3D;
	public class LineSegment extends Segment
	{
		public var TYPE:String = "line";
		
		public function LineSegment(v0:Vector3D, v1:Vector3D, color0:Number = 0x333333, color1:Number = 0x333333, thickness:Number = 1):void
		{
			color0 = color0 || 0x333333;
			color1 = color1 || 0x333333;
			thickness = thickness || 1;

			super( v0, v1, null, color0, color1, thickness );
		}
	}
}