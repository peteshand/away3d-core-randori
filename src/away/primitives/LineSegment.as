/**
 * ...
 * @author Gary Paluk - http://www.plugin.io
 */

///<reference path="../_definitions.ts"/>

package away.primitives
{
	import away.primitives.data.Segment;
	import away.geom.Vector3D;
	public class LineSegment extends Segment
	{
		public var TYPE:String = "line";
		
		public function LineSegment(v0:Vector3D, v1:Vector3D, color0:Number = 0x333333, color1:Number = 0x333333, thickness:Number = 1):void
		{
			super( v0, v1, null, color0, color1, thickness );
		}
	}
}