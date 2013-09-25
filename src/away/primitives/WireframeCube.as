/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package away.primitives
{
	import away.geom.Vector3D;
	//import flash.geom.Vector3D;
	
	/**	 * A WirefameCube primitive mesh.	 */
	public class WireframeCube extends WireframePrimitiveBase
	{
		private var _width:Number = 0;
		private var _height:Number = 0;
		private var _depth:Number = 0;
		
		/**		 * Creates a new WireframeCube object.		 * @param width The size of the cube along its X-axis.		 * @param height The size of the cube along its Y-axis.		 * @param depth The size of the cube along its Z-axis.		 * @param color The colour of the wireframe lines		 * @param thickness The thickness of the wireframe lines		 */
		public function WireframeCube(width:Number = 100, height:Number = 100, depth:Number = 100, color:Number = 0xFFFFFF, thickness:Number = 1):void
		{
			width = width || 100;
			height = height || 100;
			depth = depth || 100;
			color = color || 0xFFFFFF;
			thickness = thickness || 1;

			super(color, thickness);
			
			this._width = width;
            this._height = height;
            this._depth = depth;
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
		
		/**		 * The size of the cube along its Z-axis.		 */
		public function get depth():Number
		{
			return this._depth;
		}
		
		public function set depth(value:Number):void
		{
            this._depth = value;
            this.pInvalidateGeometry();
		}
		
		/**		 * @inheritDoc		 */
		override public function pBuildGeometry():void
		{
			var v0:Vector3D = new Vector3D();
			var v1:Vector3D = new Vector3D();
			var hw:Number = this._width*.5;
			var hh:Number = this._height*.5;
			var hd:Number = this._depth*.5;
			
			v0.x = -hw;
			v0.y = hh;
			v0.z = -hd;
			v1.x = -hw;
			v1.y = -hh;
			v1.z = -hd;
			
			this.pUpdateOrAddSegment(0, v0, v1);
			v0.z = hd;
			v1.z = hd;
            this.pUpdateOrAddSegment(1, v0, v1);
			v0.x = hw;
			v1.x = hw;
            this.pUpdateOrAddSegment(2, v0, v1);
			v0.z = -hd;
			v1.z = -hd;
            this.pUpdateOrAddSegment(3, v0, v1);
			
			v0.x = -hw;
			v0.y = -hh;
			v0.z = -hd;
			v1.x = hw;
			v1.y = -hh;
			v1.z = -hd;
            this.pUpdateOrAddSegment(4, v0, v1);
			v0.y = hh;
			v1.y = hh;
            this.pUpdateOrAddSegment(5, v0, v1);
			v0.z = hd;
			v1.z = hd;
            this.pUpdateOrAddSegment(6, v0, v1);
			v0.y = -hh;
			v1.y = -hh;
            this.pUpdateOrAddSegment(7, v0, v1);
			
			v0.x = -hw;
			v0.y = -hh;
			v0.z = -hd;
			v1.x = -hw;
			v1.y = -hh;
			v1.z = hd;
            this.pUpdateOrAddSegment(8, v0, v1);
			v0.y = hh;
			v1.y = hh;
            this.pUpdateOrAddSegment(9, v0, v1);
			v0.x = hw;
			v1.x = hw;
            this.pUpdateOrAddSegment(10, v0, v1);
			v0.y = -hh;
			v1.y = -hh;
            this.pUpdateOrAddSegment(11, v0, v1);
		}
	}
}
