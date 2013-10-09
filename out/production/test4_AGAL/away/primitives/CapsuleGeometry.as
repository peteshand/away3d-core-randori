/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package away.primitives
{
	import away.core.base.CompactSubGeometry;
	import away.utils.VectorInit;

	/**	 * A Capsule primitive mesh.	 */
	public class CapsuleGeometry extends PrimitiveBase
	{
		private var _radius:Number = 0;
		private var _height:Number = 0;
		private var _segmentsW:Number = 0;
		private var _segmentsH:Number = 0;
		private var _yUp:Boolean = false;
		
		/**		 * Creates a new Capsule object.		 * @param radius The radius of the capsule.		 * @param height The height of the capsule.		 * @param segmentsW Defines the number of horizontal segments that make up the capsule. Defaults to 16.		 * @param segmentsH Defines the number of vertical segments that make up the capsule. Defaults to 15. Must be uneven value.		 * @param yUp Defines whether the capsule poles should lay on the Y-axis (true) or on the Z-axis (false).		 */
		public function CapsuleGeometry(radius:Number = 50, height:Number = 100, segmentsW:Number = 16, segmentsH:Number = 15, yUp:Boolean = true):void
		{
			radius = radius || 50;
			height = height || 100;
			segmentsW = segmentsW || 16;
			segmentsH = segmentsH || 15;
			yUp = yUp || true;

			super();
			
			this._radius = radius;
            this._height = height;
            this._segmentsW = segmentsW;
            this._segmentsH = (segmentsH%2 == 0)? segmentsH + 1 : segmentsH;
            this._yUp = yUp;
		}
		
		/**		 * @inheritDoc		 */
		override public function pBuildGeometry(target:CompactSubGeometry):void
		{
			var data:Vector.<Number>;
			var indices:Vector.<Number> /*uint*/;
			var i:Number;
            var j:Number;
            var triIndex:Number = 0;
			var numVerts:Number = (this._segmentsH + 1)*(this._segmentsW + 1);
			var stride:Number = target.vertexStride;
			var skip:Number = stride - 9;
			var index:Number = 0;
			var startIndex:Number;
			var comp1:Number, comp2:Number, t1:Number, t2:Number;
			
			if (numVerts == target.numVertices)
            {
				data = target.vertexData;

                if ( target.indexData )
                {

                    indices = target.indexData


                }
                else
                {
                    indices = VectorInit.Num((this._segmentsH - 1)*this._segmentsW*6 );
                }

				
			}
            else
            {

				data = VectorInit.Num(numVerts*stride);
				indices = VectorInit.Num((this._segmentsH - 1)*this._segmentsW*6);
				this.pInvalidateUVs();

			}
			
			for (j = 0; j <= this._segmentsH; ++j)
            {
				
				var horangle:Number = Math.PI*j/this._segmentsH;
				var z:Number = -this._radius*Math.cos(horangle);
				var ringradius:Number = this._radius*Math.sin(horangle);

				startIndex = index;
				
				for (i = 0; i <= this._segmentsW; ++i)
                {
					var verangle:Number = 2*Math.PI*i/this._segmentsW;
					var x:Number = ringradius*Math.cos(verangle);
					var offset:Number = j > this._segmentsH/2? this._height/2 : -this._height/2;
					var y:Number = ringradius*Math.sin(verangle);
					var normLen:Number = 1/Math.sqrt(x*x + y*y + z*z);
					var tanLen:Number = Math.sqrt(y*y + x*x);
					
					if (this._yUp) {
						t1 = 0;
						t2 = tanLen > .007? x/tanLen : 0;
						comp1 = -z;
						comp2 = y;
						
					} else {
						t1 = tanLen > .007? x/tanLen : 0;
						t2 = 0;
						comp1 = y;
						comp2 = z;
					}
					
					if (i == this._segmentsW) {
						
						data[index++] = data[startIndex];
						data[index++] = data[startIndex + 1];
						data[index++] = data[startIndex + 2];
						data[index++] = (data[startIndex + 3] + (x*normLen))*.5;
						data[index++] = (data[startIndex + 4] + ( comp1*normLen))*.5;
						data[index++] = (data[startIndex + 5] + (comp2*normLen))*.5;
						data[index++] = (data[startIndex + 6] + (tanLen > .007? -y/tanLen : 1))*.5;
						data[index++] = (data[startIndex + 7] + t1)*.5;
						data[index++] = (data[startIndex + 8] + t2)*.5;
						
					} else {
						// vertex
						data[index++] = x;
						data[index++] = (this._yUp)? comp1 - offset : comp1;
						data[index++] = (this._yUp)? comp2 : comp2 + offset;
						// normal
						data[index++] = x*normLen;
						data[index++] = comp1*normLen;
						data[index++] = comp2*normLen;
						// tangent
						data[index++] = tanLen > .007? -y/tanLen : 1;
						data[index++] = t1;
						data[index++] = t2;
					}
					
					if (i > 0 && j > 0) {
						var a:Number = (this._segmentsW + 1)*j + i;
						var b:Number = (this._segmentsW + 1)*j + i - 1;
						var c:Number = (this._segmentsW + 1)*(j - 1) + i - 1;
						var d:Number = (this._segmentsW + 1)*(j - 1) + i;
						
						if (j == this._segmentsH) {
							data[index - 9] = data[startIndex];
							data[index - 8] = data[startIndex + 1];
							data[index - 7] = data[startIndex + 2];
							
							indices[triIndex++] = a;
							indices[triIndex++] = c;
							indices[triIndex++] = d;
							
						} else if (j == 1) {
							indices[triIndex++] = a;
							indices[triIndex++] = b;
							indices[triIndex++] = c;
							
						} else {
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
			
			target.updateData(data);
			target.updateIndexData(indices);
		}
		
		/**		 * @inheritDoc		 */
		override public function pBuildUVs(target:CompactSubGeometry):void
		{
			var i:Number;
            var j:Number;
			var index:Number;
			var data:Vector.<Number>;
			var stride:Number = target.UVStride;
			var UVlen:Number = (this._segmentsH + 1)*(this._segmentsW + 1)*stride;
			var skip:Number = stride - 2;
			
			if (target.UVData && UVlen == target.UVData.length)
            {
				data = target.UVData;
            }
			else
            {
				data = VectorInit.Num( UVlen );
				this.pInvalidateGeometry();
			}
			
			index = target.UVOffset;

			for (j = 0; j <= this._segmentsH; ++j)
            {
				for (i = 0; i <= this._segmentsW; ++i)
                {
					data[index++] = ( i/this._segmentsW )*target.scaleU;
					data[index++] = ( j/this._segmentsH )*target.scaleV;
					index += skip;
				}
			}
			
			target.updateData(data);
		}
		
		/**		 * The radius of the capsule.		 */
		public function get radius():Number
		{
			return this._radius;
		}
		
		public function set radius(value:Number):void
		{
            this._radius = value;
            this.pInvalidateGeometry();
		}
		
		/**		 * The height of the capsule.		 */
		public function get height():Number
		{
			return this._height;
		}
		
		public function set height(value:Number):void
		{
            this._height = value;
            this.pInvalidateGeometry();
		}
		
		/**		 * Defines the number of horizontal segments that make up the capsule. Defaults to 16.		 */
		public function get segmentsW():Number
		{
			return this._segmentsW;
		}
		
		public function set segmentsW(value:Number):void
		{
            this._segmentsW = value;
            this.pInvalidateGeometry();
            this.pInvalidateUVs();
		}
		
		/**		 * Defines the number of vertical segments that make up the capsule. Defaults to 15. Must be uneven.		 */
		public function get segmentsH():Number
		{
			return this._segmentsH;
		}
		
		public function set segmentsH(value:Number):void
		{
            this._segmentsH = (value%2 == 0)? value + 1 : value;
            this.pInvalidateGeometry();
            this.pInvalidateUVs();
		}
		
		/**		 * Defines whether the capsule poles should lay on the Y-axis (true) or on the Z-axis (false).		 */
		public function get yUp():Boolean
		{
			return this._yUp;
		}
		
		public function set yUp(value:Boolean):void
		{
            this._yUp = value;
            this.pInvalidateGeometry();
		}
	}
}
