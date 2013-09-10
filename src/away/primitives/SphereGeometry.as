///<reference path="../_definitions.ts"/>
package away.primitives
{
	import away.base.CompactSubGeometry;
	//import away3d.arcane;
	//import away3d.core.base.CompactSubGeometry;

	/**	 * A UV Sphere primitive mesh.	 */
	public class SphereGeometry extends PrimitiveBase
	{
		private var _radius:Number;
		private var _segmentsW:Number;
		private var _segmentsH:Number;
		private var _yUp:Boolean;
		
		/**		 * Creates a new Sphere object.		 * @param radius The radius of the sphere.		 * @param segmentsW Defines the number of horizontal segments that make up the sphere.		 * @param segmentsH Defines the number of vertical segments that make up the sphere.		 * @param yUp Defines whether the sphere poles should lay on the Y-axis (true) or on the Z-axis (false).		 */
		public function SphereGeometry(radius:Number = 50, segmentsW:Number = 16, segmentsH:Number = 12, yUp:Boolean = true):void
		{
			super();
			
			_radius = radius;
            _segmentsW = segmentsW;
            _segmentsH = segmentsH;
            _yUp = yUp;
		}
		
		/**		 * @inheritDoc		 */
		override public function pBuildGeometry(target:CompactSubGeometry):void
		{
			var vertices:Vector.<Number>;
			var indices:Vector.<Number> /*uint*/;
			var i:Number;
            var j:Number;
            var triIndex:Number = 0;
			var numVerts:Number = (_segmentsH + 1)*(_segmentsW + 1);
			var stride:Number = target.vertexStride;
			var skip:Number = stride - 9;
			
			if (numVerts == target.numVertices)
            {
				vertices = target.vertexData;


                if ( target.indexData )
                {

                    indices = target.indexData;

                }
                else
                {
                    indices = new Vector.<Number>((_segmentsH - 1)*_segmentsW*6 );
                }


			}
            else
            {
				vertices = new Vector.<Number>(numVerts*stride);
				indices = new Vector.<Number>((_segmentsH - 1)*_segmentsW*6);
				pInvalidateGeometry();
			}
			
			var startIndex:Number;
			var index:Number = target.vertexOffset;
			var comp1:Number;
            var comp2:Number;
            var t1:Number;
            var t2:Number;
			
			for (j = 0; j <= _segmentsH; ++j)
            {
				
				startIndex = index;
				
				var horangle:Number = Math.PI*j/_segmentsH;
				var z:Number = -_radius*Math.cos(horangle);
				var ringradius:Number = _radius*Math.sin(horangle);
				
				for (i = 0; i <= _segmentsW; ++i)
                {
					var verangle:Number = 2*Math.PI*i/_segmentsW;
					var x:Number = ringradius*Math.cos(verangle);
					var y:Number = ringradius*Math.sin(verangle);
					var normLen:Number = 1/Math.sqrt(x*x + y*y + z*z);
					var tanLen:Number = Math.sqrt(y*y + x*x);
					
					if (_yUp)
                    {

						t1 = 0;
						t2 = tanLen > .007? x/tanLen : 0;
						comp1 = -z;
						comp2 = y;
						
					}
                    else
                    {
						t1 = tanLen > .007? x/tanLen : 0;
						t2 = 0;
						comp1 = y;
						comp2 = z;
					}
					
					if (i == _segmentsW) {
						vertices[index++] = vertices[startIndex];
						vertices[index++] = vertices[startIndex + 1];
						vertices[index++] = vertices[startIndex + 2];
						vertices[index++] = vertices[startIndex + 3] + (x*normLen)*.5;
						vertices[index++] = vertices[startIndex + 4] + ( comp1*normLen)*.5;
						vertices[index++] = vertices[startIndex + 5] + (comp2*normLen)*.5;
						vertices[index++] = tanLen > .007? -y/tanLen : 1;
						vertices[index++] = t1;
						vertices[index++] = t2;
						
					}
                    else
                    {

						vertices[index++] = x;
						vertices[index++] = comp1;
						vertices[index++] = comp2;
						vertices[index++] = x*normLen;
						vertices[index++] = comp1*normLen;
						vertices[index++] = comp2*normLen;
						vertices[index++] = tanLen > .007? -y/tanLen : 1;
						vertices[index++] = t1;
						vertices[index++] = t2;
					}
					
					if (i > 0 && j > 0)
                    {

						var a:Number = (_segmentsW + 1)*j + i;
						var b:Number = (_segmentsW + 1)*j + i - 1;
						var c:Number = (_segmentsW + 1)*(j - 1) + i - 1;
						var d:Number = (_segmentsW + 1)*(j - 1) + i;
						
						if (j == _segmentsH)
                        {

							vertices[index - 9] = vertices[startIndex];
							vertices[index - 8] = vertices[startIndex + 1];
							vertices[index - 7] = vertices[startIndex + 2];
							
							indices[triIndex++] = a;
							indices[triIndex++] = c;
							indices[triIndex++] = d;
							
						}
                        else if (j == 1)
                        {

							indices[triIndex++] = a;
							indices[triIndex++] = b;
							indices[triIndex++] = c;
							
						}
                        else
                        {
							indices[triIndex++] = a;
							indices[triIndex++] = b;
							indices[triIndex++] = c;
							indices[triIndex++] = a;
							indices[triIndex++] = c;
							indices[triIndex++] = d;
						}
					}
					
					index += skip;
				}
			}
			
			target.updateData(vertices);
			target.updateIndexData(indices);
		}
		
		/**		 * @inheritDoc		 */
		override public function pBuildUVs(target:CompactSubGeometry):void
		{
			var i:Number, j:Number;
			var stride:Number = target.UVStride;
			var numUvs:Number = (_segmentsH + 1)*(_segmentsW + 1)*stride;
			var data:Vector.<Number>;
			var skip:Number = stride - 2;
			
			if (target.UVData && numUvs == target.UVData.length)
				data = target.UVData;
			else {
				data = new Vector.<Number>(numUvs);
                pInvalidateGeometry();
			}
			
			var index:Number = target.UVOffset;
			for (j = 0; j <= _segmentsH; ++j)
            {
				for (i = 0; i <= _segmentsW; ++i)
                {
					data[index++] = 1 - ( i/_segmentsW )*target.scaleU ;
					data[index++] = ( j/_segmentsH )*target.scaleV;
					index += skip;
				}
			}
			
			target.updateData(data);
		}
		
		/**		 * The radius of the sphere.		 */
		public function get radius():Number
		{
			return _radius;
		}
		
		public function set radius(value:Number):void
		{
            _radius = value;
            pInvalidateGeometry();
		}
		
		/**		 * Defines the number of horizontal segments that make up the sphere. Defaults to 16.		 */
		public function get segmentsW():Number
		{
			return _segmentsW;
		}
		
		public function set segmentsW(value:Number):void
		{
            _segmentsW = value;
            pInvalidateGeometry();
            pInvalidateUVs();
		}
		
		/**		 * Defines the number of vertical segments that make up the sphere. Defaults to 12.		 */
		public function get segmentsH():Number
		{
			return _segmentsH;
		}
		
		public function set segmentsH(value:Number):void
		{
            _segmentsH = value;
            pInvalidateGeometry();
            pInvalidateUVs();
		}
		
		/**		 * Defines whether the sphere poles should lay on the Y-axis (true) or on the Z-axis (false).		 */
		public function get yUp():Boolean
		{
			return _yUp;
		}
		
		public function set yUp(value:Boolean):void
		{
            _yUp = value;
            pInvalidateGeometry();
		}
	}
}
