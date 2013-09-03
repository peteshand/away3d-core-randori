///<reference path="../_definitions.ts" />
package away.primitives
{
	import away.geom.Vector3D;
	//import flash.geom.Vector3D;
	
	//import away3d.primitives.WireframePrimitiveBase;
	
	/**	 * A WireframeTetrahedron primitive mesh	 */
	public class WireframeTetrahedron extends WireframePrimitiveBase
	{
		
		public static var ORIENTATION_YZ:String = "yz";
		public static var ORIENTATION_XY:String = "xy";
		public static var ORIENTATION_XZ:String = "xz";
		
		private var _width:Number;
		private var _height:Number;
		private var _orientation:String;
		
		/**		 * Creates a new WireframeTetrahedron object.		 * @param width The size of the tetrahedron buttom size.		 * @param height The size of the tetranhedron height.		 * @param color The color of the wireframe lines.		 * @param thickness The thickness of the wireframe lines.		 */
		public function WireframeTetrahedron(width:Number, height:Number, color:Number = 0xffffff, thickness:Number = 1, orientation:String = "yz"):void
		{
			super(color, thickness);
			
			this._width = width;
            this._height = height;

            this._orientation = orientation;
		}
		
		/**		 * The orientation in which the plane lies		 */
		public function get orientation():String
		{
			return _orientation;
		}
		
		public function set orientation(value:String):void
		{
            this._orientation = value;
            this.pInvalidateGeometry();
		}
		
		/**		 * The size of the tetrahedron bottom.		 */
		public function get width():Number
		{
			return _width;
		}
		
		public function set width(value:Number):void
		{
			if (value <= 0)
				throw new Error("Value needs to be greater than 0");
            this._width = value;
			this.pInvalidateGeometry();
		}
		
		/**		 * The size of the tetrahedron height.		 */
		public function get height():Number
		{
			return _height;
		}
		
		public function set height(value:Number):void
		{
			if (value <= 0)
				throw new Error("Value needs to be greater than 0");
            this._height = value;
            this.pInvalidateGeometry();
		}
		
		/**		 * @inheritDoc		 */
		override public function pBuildGeometry():void
		{
			
			var bv0:Vector3D;
			var bv1:Vector3D;
			var bv2:Vector3D;
			var bv3:Vector3D;
			var top:Vector3D;

			var hw:Number = _width*0.5;
			
			switch (_orientation)
            {
				case WireframeTetrahedron.ORIENTATION_XY:

					bv0 = new Vector3D(-hw, hw, 0);
					bv1 = new Vector3D(hw, hw, 0);
					bv2 = new Vector3D(hw, -hw, 0);
					bv3 = new Vector3D(-hw, -hw, 0);
					top = new Vector3D(0, 0, _height);
					break;
				case WireframeTetrahedron.ORIENTATION_XZ:
					bv0 = new Vector3D(-hw, 0, hw);
					bv1 = new Vector3D(hw, 0, hw);
					bv2 = new Vector3D(hw, 0, -hw);
					bv3 = new Vector3D(-hw, 0, -hw);
					top = new Vector3D(0, _height, 0);
					break;
				case WireframeTetrahedron.ORIENTATION_YZ:
					bv0 = new Vector3D(0, -hw, hw);
					bv1 = new Vector3D(0, hw, hw);
					bv2 = new Vector3D(0, hw, -hw);
					bv3 = new Vector3D(0, -hw, -hw);
					top = new Vector3D(_height, 0, 0);
					break;
			}
			//bottom
			pUpdateOrAddSegment(0, bv0, bv1);
            pUpdateOrAddSegment(1, bv1, bv2);
            pUpdateOrAddSegment(2, bv2, bv3);
            pUpdateOrAddSegment(3, bv3, bv0);
			//bottom to top
            pUpdateOrAddSegment(4, bv0, top);
            pUpdateOrAddSegment(5, bv1, top);
            pUpdateOrAddSegment(6, bv2, top);
            pUpdateOrAddSegment(7, bv3, top);
		}
	}
}
