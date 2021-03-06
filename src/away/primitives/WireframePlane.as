/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package away.primitives
{
	import away.core.geom.Vector3D;
	//import flash.geom.Vector3D;
	
	/**	 * A WireframePlane primitive mesh.	 */
	public class WireframePlane extends WireframePrimitiveBase
	{
		public static var ORIENTATION_YZ:String = "yz";
		public static var ORIENTATION_XY:String = "xy";
		public static var ORIENTATION_XZ:String = "xz";
		
		private var _width:Number = 0;
		private var _height:Number = 0;
		private var _segmentsW:Number = 0;
		private var _segmentsH:Number = 0;
		private var _orientation:String = null;
		
		/**		 * Creates a new WireframePlane object.		 * @param width The size of the cube along its X-axis.		 * @param height The size of the cube along its Y-axis.		 * @param segmentsW The number of segments that make up the cube along the X-axis.		 * @param segmentsH The number of segments that make up the cube along the Y-axis.		 * @param color The colour of the wireframe lines		 * @param thickness The thickness of the wireframe lines		 * @param orientation The orientaion in which the plane lies.		 */
		public function WireframePlane(width:Number, height:Number, segmentsW:Number = 10, segmentsH:Number = 10, color:Number = 0xFFFFFF, thickness:Number = 1, orientation:String = "yz"):void
		{
			segmentsW = segmentsW || 10;
			segmentsH = segmentsH || 10;
			color = color || 0xFFFFFF;
			thickness = thickness || 1;
			orientation = orientation || "yz";

			super(color, thickness);
			
			this._width = width;
            this._height = height;
            this._segmentsW = segmentsW;
            this._segmentsH = segmentsH;
            this._orientation = orientation;
		}
		
		/**		 * The orientaion in which the plane lies.		 */
		public function get orientation():String
		{
			return this._orientation;
		}
		
		public function set orientation(value:String):void
		{
            this._orientation = value;
            this.pInvalidateGeometry();
		}
		
		/**		 * The size of the cube along its X-axis.		 */
		public function get width():Number
		{
			return this._width;
		}
		
		public function set width(value:Number):void
		{
            this._width = value;
            this.pInvalidateGeometry();
		}
		
		/**		 * The size of the cube along its Y-axis.		 */
		public function get height():Number
		{
			return this._height;
		}
		
		public function set height(value:Number):void
		{
			if (value <= 0)
				throw new Error("Value needs to be greater than 0");
            this._height = value;
            this.pInvalidateGeometry();
		}
		
		/**		 * The number of segments that make up the plane along the X-axis.		 */
		public function get segmentsW():Number
		{
			return this._segmentsW;
		}
		
		public function set segmentsW(value:Number):void
		{
            this._segmentsW = value;
            this.removeAllSegments();
            this.pInvalidateGeometry();
		}
		
		/**		 * The number of segments that make up the plane along the Y-axis.		 */
		public function get segmentsH():Number
		{
			return this._segmentsH;
		}
		
		public function set segmentsH(value:Number):void
		{
            this._segmentsH = value;
            this.removeAllSegments();
            this.pInvalidateGeometry();
		}
		
		/**		 * @inheritDoc		 */
		override public function pBuildGeometry():void
		{
			var v0:Vector3D = new Vector3D();
			var v1:Vector3D = new Vector3D();
			var hw:Number = this._width*.5;
			var hh:Number = this._height*.5;
			var index:Number = 0;
			var ws:Number, hs:Number;
			
			if ( this._orientation == WireframePlane.ORIENTATION_XY)
            {

				v0.y = hh;
				v0.z = 0;
				v1.y = -hh;
				v1.z = 0;
				
				for (ws = 0; ws <= this._segmentsW; ++ws)
                {
					v1.x =  (ws/this._segmentsW - .5)*this._width;
					v0.x = v1.x
                    this.pUpdateOrAddSegment(index++, v0, v1);
				}
				
				v0.x = -hw;
				v1.x = hw;
				
				for (hs = 0; hs <= this._segmentsH; ++hs)
                {
					v1.y =  (hs/this._segmentsH - .5)*this._height;
					v0.y = v1.y
					this.pUpdateOrAddSegment(index++, v0, v1);
				}
			}
			else if (this._orientation == WireframePlane.ORIENTATION_XZ)
            {
				v0.z = hh;
				v0.y = 0;
				v1.z = -hh;
				v1.y = 0;
				
				for (ws = 0; ws <= this._segmentsW; ++ws)
                {
					v1.x =  (ws/this._segmentsW - .5)*this._width;
					v0.x = v1.x
                    this.pUpdateOrAddSegment(index++, v0, v1);
				}
				
				v0.x = -hw;
				v1.x = hw;
				
				for (hs = 0; hs <= this._segmentsH; ++hs)
                {
					v1.z =  (hs/this._segmentsH - .5)*this._height;
					v0.z = v1.z
                    this.pUpdateOrAddSegment(index++, v0, v1);
				}
			}
			else if (this._orientation == WireframePlane.ORIENTATION_YZ)
            {
				v0.y = hh;
				v0.x = 0;
				v1.y = -hh;
				v1.x = 0;
				
				for (ws = 0; ws <= this._segmentsW; ++ws)
                {
					v1.z =  (ws/this._segmentsW - .5)*this._width;
					v0.z = v1.z
                    this.pUpdateOrAddSegment(index++, v0, v1);
				}
				
				v0.z = hw;
				v1.z = -hw;
				
				for (hs = 0; hs <= this._segmentsH; ++hs)
                {
					v1.y =  (hs/this._segmentsH - .5)*this._height;
					v0.y = v1.y
                    this.pUpdateOrAddSegment(index++, v0, v1);
				}
			}
		}
	
	}
}
