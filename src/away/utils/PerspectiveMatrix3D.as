/** * ... * @author Gary Paluk - http://www.plugin.io */

    ///<reference path="../_definitions.ts"/>

package away.utils
{
	import away.geom.Matrix3D;
	public class PerspectiveMatrix3D extends Matrix3D
	{
		public function PerspectiveMatrix3D(v:Vector.<Number> = null):void
		{
			super( v );
		}
		
		public function perspectiveFieldOfViewLH(fieldOfViewY:Number, aspectRatio:Number, zNear:Number, zFar:Number):void
		{
			var yScale:Number = 1/Math.tan( fieldOfViewY/2 );
			var xScale:Number = yScale / aspectRatio;
			this.copyRawDataFrom( new <Number>[xScale, 0.0, 0.0, 0.0,
				0.0, yScale, 0.0, 0.0,
				0.0, 0.0, zFar/(zFar-zNear), 1.0,
				0.0, 0.0, (zNear*zFar)/(zNear-zFar), 0.0]
				);
		}
	}
}