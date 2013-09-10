///<reference path="../_definitions.ts"/>
package away.primitives
{
	import away.geom.Vector3D;
	//import flash.geom.Vector3D;
	
	/**
	 * Generates a wireframd cylinder primitive.
	 */
	public class WireframeCylinder extends WireframePrimitiveBase
	{
		private static var TWO_PI:Number = 2*Math.PI;
		
		private var _topRadius:Number;
		private var _bottomRadius:Number;
		private var _height:Number;
		private var _segmentsW:Number;
		private var _segmentsH:Number;
		
		/**
		 * Creates a new WireframeCylinder instance
		 * @param topRadius Top radius of the cylinder
		 * @param bottomRadius Bottom radius of the cylinder
		 * @param height The height of the cylinder
		 * @param segmentsW Number of radial segments
		 * @param segmentsH Number of vertical segments
		 * @param color The color of the wireframe lines
		 * @param thickness The thickness of the wireframe lines
		 */
		public function WireframeCylinder(topRadius:Number = 50, bottomRadius:Number = 50, height:Number = 100, segmentsW:Number = 16, segmentsH:Number = 1, color:Number = 0xFFFFFF, thickness:Number = 1):void
		{
			super(color, thickness);
			_topRadius = topRadius;
            _bottomRadius = bottomRadius;
            _height = height;
            _segmentsW = segmentsW;
            _segmentsH = segmentsH;
		}
		
		override public function pBuildGeometry():void
		{
			
			var i:Number, j:Number;
			var radius:Number = _topRadius;
			var revolutionAngle:Number;
			var revolutionAngleDelta:Number = WireframeCylinder.TWO_PI/_segmentsW;
			var nextVertexIndex:Number = 0;
			var x:Number, y:Number, z:Number;

            var lastLayer : Vector.<Vector.<Vector3D>> = new Vector.<Vector.<Vector3D>>( _segmentsH + 1 );

			for (j = 0; j <= _segmentsH; ++j)
            {
                lastLayer[j] = new Vector.<Vector3D>( _segmentsW + 1 );
				
				radius = _topRadius - ((j/_segmentsH)*(_topRadius - _bottomRadius));
				z = -(_height/2) + (j/_segmentsH*_height);
				
				var previousV:Vector3D = null;
				
				for (i = 0; i <= _segmentsW; ++i)
                {
					// revolution vertex
					revolutionAngle = i*revolutionAngleDelta;
					x = radius*Math.cos(revolutionAngle);
					y = radius*Math.sin(revolutionAngle);
					var vertex:Vector3D;
					if (previousV) {
						vertex = new Vector3D(x, -z, y);
						pUpdateOrAddSegment(nextVertexIndex++, vertex, previousV);
						previousV = vertex;
					} else
						previousV = new Vector3D(x, -z, y);
					
					if (j > 0)
                    {
						pUpdateOrAddSegment(nextVertexIndex++, vertex, lastLayer[j - 1][i]);
                    }
					lastLayer[j][i] = previousV;
				}
			}
		}
		
		/**
		 * Top radius of the cylinder
		 */
		public function get topRadius():Number
		{
			return _topRadius;
		}
		
		public function set topRadius(value:Number):void
		{
			_topRadius = value;
			pInvalidateGeometry();
		}
		
		/**
		 * Bottom radius of the cylinder
		 */
		public function get bottomRadius():Number
		{
			return _bottomRadius;
		}
		
		public function set bottomRadius(value:Number):void
		{
			_bottomRadius = value;
			pInvalidateGeometry();
		}
		
		/**
		 * The height of the cylinder
		 */
		public function get height():Number
		{
			return _height;
		}
		
		public function set height(value:Number):void
		{
			if (height <= 0)
				throw new Error('Height must be a value greater than zero.');

			_height = value;
			pInvalidateGeometry();
		}
	}
}
