///<reference path="../_definitions.ts"/>

package away.primitives
{
	import away.geom.Vector3D;
	//import flash.geom.Vector3D;
	
	/**	 * Generates a wireframd cylinder primitive.	 */
	public class WireframeCylinder extends WireframePrimitiveBase
	{
		private static var TWO_PI:Number = 2*Math.PI;
		
		private var _topRadius:Number;
		private var _bottomRadius:Number;
		private var _height:Number;
		private var _segmentsW:Number;
		private var _segmentsH:Number;
		
		/**		 * Creates a new WireframeCylinder instance		 * @param topRadius Top radius of the cylinder		 * @param bottomRadius Bottom radius of the cylinder		 * @param height The height of the cylinder		 * @param segmentsW Number of radial segments		 * @param segmentsH Number of vertical segments		 * @param color The color of the wireframe lines		 * @param thickness The thickness of the wireframe lines		 */
		public function WireframeCylinder(topRadius:Number = 50, bottomRadius:Number = 50, height:Number = 100, segmentsW:Number = 16, segmentsH:Number = 1, color:Number = 0xFFFFFF, thickness:Number = 1):void
		{
			super(color, thickness);
			this._topRadius = topRadius;
            this._bottomRadius = bottomRadius;
            this._height = height;
            this._segmentsW = segmentsW;
            this._segmentsH = segmentsH;
		}
		
		override public function pBuildGeometry():void
		{
			
			var i:Number, j:Number;
			var radius:Number = this._topRadius;
			var revolutionAngle:Number;
			var revolutionAngleDelta:Number = WireframeCylinder.TWO_PI/this._segmentsW;
			var nextVertexIndex:Number = 0;
			var x:Number, y:Number, z:Number;

            var lastLayer : Vector.<Vector.<Vector3D>> = new Vector.<Vector.<Vector3D>>( this._segmentsH + 1 );

			for (j = 0; j <= this._segmentsH; ++j)
            {
                lastLayer[j] = new Vector.<Vector3D>( this._segmentsW + 1 );
				
				radius = this._topRadius - ((j/this._segmentsH)*(this._topRadius - this._bottomRadius));
				z = -(this._height/2) + (j/this._segmentsH*this._height);
				
				var previousV:Vector3D = null;
				
				for (i = 0; i <= this._segmentsW; ++i)
                {
					// revolution vertex
					revolutionAngle = i*revolutionAngleDelta;
					x = radius*Math.cos(revolutionAngle);
					y = radius*Math.sin(revolutionAngle);
					var vertex:Vector3D;
					if (previousV) {
						vertex = new Vector3D(x, -z, y);
						this.pUpdateOrAddSegment(nextVertexIndex++, vertex, previousV);
						previousV = vertex;
					} else
						previousV = new Vector3D(x, -z, y);
					
					if (j > 0)
                    {
						this.pUpdateOrAddSegment(nextVertexIndex++, vertex, lastLayer[j - 1][i]);
                    }
					lastLayer[j][i] = previousV;
				}
			}
		}
		
		/**		 * Top radius of the cylinder		 */
		public function get topRadius():Number
		{
			return this._topRadius;
		}
		
		public function set topRadius(value:Number):void
		{
			this._topRadius = value;
			this.pInvalidateGeometry();
		}
		
		/**		 * Bottom radius of the cylinder		 */
		public function get bottomRadius():Number
		{
			return this._bottomRadius;
		}
		
		public function set bottomRadius(value:Number):void
		{
			this._bottomRadius = value;
			this.pInvalidateGeometry();
		}
		
		/**		 * The height of the cylinder		 */
		public function get height():Number
		{
			return this._height;
		}
		
		public function set height(value:Number):void
		{
			if (this.height <= 0)
				throw new Error('Height must be a value greater than zero.');

			this._height = value;
			this.pInvalidateGeometry();
		}
	}
}
