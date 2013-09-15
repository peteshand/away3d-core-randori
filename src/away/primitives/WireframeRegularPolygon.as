///<reference path="../_definitions.ts"/>

package away.primitives
{
	import away.geom.Vector3D;
	//import flash.geom.Vector3D;
	
	/**	 * A WireframeRegularPolygon primitive mesh.	 */
	public class WireframeRegularPolygon extends WireframePrimitiveBase
	{
		public static var ORIENTATION_YZ:String = "yz";
		public static var ORIENTATION_XY:String = "xy";
		public static var ORIENTATION_XZ:String = "xz";
		
		private var _radius:Number;
		private var _sides:Number;
		private var _orientation:String;
		
		/**		 * Creates a new WireframeRegularPolygon object.		 * @param radius The radius of the polygon.		 * @param sides The number of sides on the polygon.		 * @param color The colour of the wireframe lines		 * @param thickness The thickness of the wireframe lines		 * @param orientation The orientaion in which the plane lies.		 */
		public function WireframeRegularPolygon(radius:Number, sides:Number, color:Number = 0xFFFFFF, thickness:Number = 1, orientation:String = "yz"):void
		{
			super(color, thickness);
			
			this._radius = radius;
            this._sides = sides;
            this._orientation = orientation;
		}
		
		/**		 * The orientaion in which the polygon lies.		 */
		public function get orientation():String
		{
			return this._orientation;
		}
		
		public function set orientation(value:String):void
		{
            this._orientation = value;
            this.pInvalidateGeometry();
		}
		
		/**		 * The radius of the regular polygon.		 */
		public function get radius():Number
		{
			return this._radius;
		}
		
		public function set radius(value:Number):void
		{
            this._radius = value;
            this.pInvalidateGeometry();
		}
		
		/**		 * The number of sides to the regular polygon.		 */
		public function get sides():Number
		{
			return this._sides;
		}
		
		public function set sides(value:Number):void
		{
            this._sides = value;
            this.removeAllSegments();
            this.pInvalidateGeometry();
		}
		
		/**		 * @inheritDoc		 */
		override public function pBuildGeometry():void
		{
			var v0:Vector3D = new Vector3D();
			var v1:Vector3D = new Vector3D();
			var index:Number = 0;
			var s:Number;
			
			if (this._orientation == WireframeRegularPolygon.ORIENTATION_XY)
            {
				v0.z = 0;
				v1.z = 0;
				
				for (s = 0; s < this._sides; ++s)
                {
					v0.x = this._radius*Math.cos(2*Math.PI*s/this._sides);
					v0.y = this._radius*Math.sin(2*Math.PI*s/this._sides);
					v1.x = this._radius*Math.cos(2*Math.PI*(s + 1)/this._sides);
					v1.y = this._radius*Math.sin(2*Math.PI*(s + 1)/this._sides);
					this.pUpdateOrAddSegment(index++, v0, v1);
				}
			}
			else if (this._orientation == WireframeRegularPolygon.ORIENTATION_XZ)
            {

				v0.y = 0;
				v1.y = 0;
				
				for (s = 0; s < this._sides; ++s)
                {
					v0.x = this._radius*Math.cos(2*Math.PI*s/this._sides);
					v0.z = this._radius*Math.sin(2*Math.PI*s/this._sides);
					v1.x = this._radius*Math.cos(2*Math.PI*(s + 1)/this._sides);
					v1.z = this._radius*Math.sin(2*Math.PI*(s + 1)/this._sides);
                    this.pUpdateOrAddSegment(index++, v0, v1);
				}
			}
			else if (this._orientation == WireframeRegularPolygon.ORIENTATION_YZ)
            {
				v0.x = 0;
				v1.x = 0;
				
				for (s = 0; s < this._sides; ++s)
                {
					v0.z = this._radius*Math.cos(2*Math.PI*s/this._sides);
					v0.y = this._radius*Math.sin(2*Math.PI*s/this._sides);
					v1.z = this._radius*Math.cos(2*Math.PI*(s + 1)/this._sides);
					v1.y = this._radius*Math.sin(2*Math.PI*(s + 1)/this._sides);
                    this.pUpdateOrAddSegment(index++, v0, v1);
				}
			}
		}
	
	}
}
