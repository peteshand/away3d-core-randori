///<reference path="../_definitions.ts"/>

package away.primitives
{
	import away.base.CompactSubGeometry;
	/**	 * A Plane primitive mesh.	 */
	public class PlaneGeometry extends PrimitiveBase
	{
		private var _segmentsW:Number;
		private var _segmentsH:Number;
		private var _yUp:Boolean;
		private var _width:Number;
		private var _height:Number;
		private var _doubleSided:Boolean;
		
		/**		 * Creates a new Plane object.		 * @param width The width of the plane.		 * @param height The height of the plane.		 * @param segmentsW The number of segments that make up the plane along the X-axis.		 * @param segmentsH The number of segments that make up the plane along the Y or Z-axis.		 * @param yUp Defines whether the normal vector of the plane should point along the Y-axis (true) or Z-axis (false).		 * @param doubleSided Defines whether the plane will be visible from both sides, with correct vertex normals.		 */
		public function PlaneGeometry(width:Number = 100, height:Number = 100, segmentsW:Number = 1, segmentsH:Number = 1, yUp:Boolean = true, doubleSided:Boolean = false):void
		{

			super();
			
			this._segmentsW = segmentsW;
            this._segmentsH = segmentsH;
            this._yUp = yUp;
            this._width = width;
            this._height = height;
            this._doubleSided = doubleSided;

		}
		
		/**		 * The number of segments that make up the plane along the X-axis. Defaults to 1.		 */
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
		
		/**		 * The number of segments that make up the plane along the Y or Z-axis, depending on whether yUp is true or		 * false, respectively. Defaults to 1.		 */
		public function get segmentsH():Number
		{
			return this._segmentsH;
		}
		
		public function set segmentsH(value:Number):void
		{

            this._segmentsH = value;

            this.pInvalidateGeometry();
            this.pInvalidateUVs();

		}
		
		/**		 *  Defines whether the normal vector of the plane should point along the Y-axis (true) or Z-axis (false). Defaults to true.		 */
		public function get yUp():Boolean
		{
			return this._yUp;
		}
		
		public function set yUp(value:Boolean):void
		{
            this._yUp = value;
            this.pInvalidateGeometry();
		}
		
		/**		 * Defines whether the plane will be visible from both sides, with correct vertex normals (as opposed to bothSides on Material). Defaults to false.		 */
		public function get doubleSided():Boolean
		{
			return this._doubleSided;
		}
		
		public function set doubleSided(value:Boolean):void
		{
            this._doubleSided = value;
            this.pInvalidateGeometry();
		}
		
		/**		 * The width of the plane.		 */
		public function get width():Number
		{
			return this._width;
		}
		
		public function set width(value:Number):void
		{
			this._width = value;
            this.pInvalidateGeometry();
		}
		
		/**		 * The height of the plane.		 */
		public function get height():Number
		{
			return this._height;
		}
		
		public function set height(value:Number):void
		{
			this._height = value;
            this.pInvalidateGeometry();//invalidateGeometry();
		}
		
		/**		 * @inheritDoc		 */
		override public function pBuildGeometry(target:CompactSubGeometry):void
		{
			var data:Vector.<Number>;
			var indices:Vector.<Number> /*uint*/;
			var x:Number, y:Number;
			var numIndices:Number;
			var base:Number;
			var tw:Number = this._segmentsW + 1;
			var numVertices:Number = (this._segmentsH + 1)*tw;
			var stride:Number = target.vertexStride;
			var skip:Number = stride - 9;

			if (this._doubleSided)
				numVertices *= 2;
			
			numIndices = this._segmentsH*this._segmentsW*6;

			if (this._doubleSided)
				numIndices <<= 1;
			
			if (numVertices == target.numVertices)
            {

                data = target.vertexData;

                if ( indices == null )
                {
                    indices = new Vector.<Number>( numIndices );
                }
                else
                {
                    indices = target.indexData;
                }
			}
            else
            {
				data = new Vector.<Number>( numVertices*stride );//new Vector.<Number>(numVertices*stride, true);
				indices = new Vector.<Number>( numIndices );//new Vector.<uint>(numIndices, true);

                this.pInvalidateUVs();//invalidateUVs();
			}
			
			numIndices = 0;

			var index:Number = target.vertexOffset;

			for (var yi:Number = 0; yi <= this._segmentsH; ++yi)
            {

				for (var xi:Number = 0; xi <= this._segmentsW; ++xi)
                {
					x = (xi/this._segmentsW - .5)*this._width;
					y = (yi/this._segmentsH - .5)*this._height;
					
					data[index++] = x;
					if (this._yUp)
                    {
						data[index++] = 0;
						data[index++] = y;
					}
                    else
                    {
						data[index++] = y;
						data[index++] = 0;
					}
					
					data[index++] = 0;

					if (this._yUp)
                    {
						data[index++] = 1;
						data[index++] = 0;
					}
                    else
                    {
						data[index++] = 0;
						data[index++] = -1;
					}
					
					data[index++] = 1;
					data[index++] = 0;
					data[index++] = 0;
					
					index += skip;
					
					// add vertex with same position, but with inverted normal & tangent
					if (this._doubleSided)
                    {

						for (var i:Number = 0; i < 3; ++i)
                        {
							data[index] = data[index - stride];
							++index;
						}

						for (i = 0; i < 3; ++i)
                        {
							data[index] = -data[index - stride];
							++index;
						}

						for (i = 0; i < 3; ++i)
                        {
							data[index] = -data[index - stride];
							++index;
						}

						index += skip;

					}
					
					if (xi != this._segmentsW && yi != this._segmentsH)
                    {

						base = xi + yi*tw;
						var mult:Number = this._doubleSided? 2 : 1;
						
						indices[numIndices++] = base*mult;
						indices[numIndices++] = (base + tw)*mult;
						indices[numIndices++] = (base + tw + 1)*mult;
						indices[numIndices++] = base*mult;
						indices[numIndices++] = (base + tw + 1)*mult;
						indices[numIndices++] = (base + 1)*mult;
						
						if (this._doubleSided)
                        {

							indices[numIndices++] = (base + tw + 1)*mult + 1;
							indices[numIndices++] = (base + tw)*mult + 1;
							indices[numIndices++] = base*mult + 1;
							indices[numIndices++] = (base + 1)*mult + 1;
							indices[numIndices++] = (base + tw + 1)*mult + 1;
							indices[numIndices++] = base*mult + 1;

						}
					}
				}
			}

			target.updateData(data);
			target.updateIndexData(indices);

		}
		
		/**		 * @inheritDoc		 */
		override public function pBuildUVs(target:CompactSubGeometry):void
		{
			var data:Vector.<Number>;
			var stride:Number = target.UVStride;
			var numUvs:Number = ( this._segmentsH + 1 )*( this._segmentsW + 1 ) * stride;
			var skip:Number = stride - 2;
			
			if (this._doubleSided)
            {
                numUvs *= 2;
            }

			
			if (target.UVData && numUvs == target.UVData.length)
            {
                data = target.UVData;
            }
			else
            {
				data = new Vector.<Number>( numUvs );//Vector.<Number>(numUvs, true);
                this.pInvalidateGeometry()
			}
			
			var index:Number = target.UVOffset;
			
			for (var yi:Number = 0; yi <= this._segmentsH; ++yi)
            {

				for (var xi:Number = 0; xi <= this._segmentsW; ++xi)
                {
					data[index++] = (xi/this._segmentsW)*target.scaleU;
					data[index++] = (1 - yi/this._segmentsH)*target.scaleV;
					index += skip;
					
					if (this._doubleSided)
                    {
						data[index++] = (xi/this._segmentsW)*target.scaleU ;
						data[index++] = (1 - yi/this._segmentsH)*target.scaleV;
						index += skip;
					}
				}
			}
			
			target.updateData(data);
		}
	}
}
