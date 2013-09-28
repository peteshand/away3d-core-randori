/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package away.primitives
{
	import away.base.CompactSubGeometry;
	import away.utils.VectorInit;

	/**	 * A Cylinder primitive mesh.	 */
	public class CylinderGeometry extends PrimitiveBase
	{
		public var _pBottomRadius:Number = 0;
        public var _pSegmentsW:Number = 0;
        public var _pSegmentsH:Number = 0;
        
		private var _topRadius:Number = 0;
		private var _height:Number = 0;

		private var _topClosed:Boolean = false;
		private var _bottomClosed:Boolean = false;
		private var _surfaceClosed:Boolean = false;
		private var _yUp:Boolean = false;
		private var _rawData:Vector.<Number>;
		private var _rawIndices:Vector.<Number>;/*uint*/
		private var _nextVertexIndex:Number = 0;
		private var _currentIndex:Number = 0;
		private var _currentTriangleIndex:Number = 0;
		private var _numVertices:Number = 0;
		private var _stride:Number = 0;
		private var _vertexOffset:Number = 0;
		
		private function addVertex(px:Number, py:Number, pz:Number, nx:Number, ny:Number, nz:Number, tx:Number, ty:Number, tz:Number):void
		{
			var compVertInd:Number = this._vertexOffset + this._nextVertexIndex*this._stride; // current component vertex index
            this._rawData[compVertInd++] = px;
            this._rawData[compVertInd++] = py;
            this._rawData[compVertInd++] = pz;
            this._rawData[compVertInd++] = nx;
            this._rawData[compVertInd++] = ny;
            this._rawData[compVertInd++] = nz;
            this._rawData[compVertInd++] = tx;
            this._rawData[compVertInd++] = ty;
            this._rawData[compVertInd++] = tz;
            this._nextVertexIndex++;
		}
		
		private function addTriangleClockWise(cwVertexIndex0:Number, cwVertexIndex1:Number, cwVertexIndex2:Number):void
		{
            this._rawIndices[this._currentIndex++] = cwVertexIndex0;
            this._rawIndices[this._currentIndex++] = cwVertexIndex1;
            this._rawIndices[this._currentIndex++] = cwVertexIndex2;
            this._currentTriangleIndex++;
		}
		
		/**		 * @inheritDoc		 */
		override public function pBuildGeometry(target:CompactSubGeometry):void
		{
			var i:Number;
            var j:Number;
			var x:Number;
            var y:Number;
            var z:Number;
            var radius:Number;
            var revolutionAngle:Number;

			var dr:Number;
            var latNormElev:Number;
            var latNormBase:Number;
			var numTriangles:Number = 0;
			
			var comp1:Number;
            var comp2:Number;
			var startIndex:Number = 0;

			var t1:Number;
            var t2:Number;
			
			this._stride = target.vertexStride;
            this._vertexOffset = target.vertexOffset;
			
			// reset utility variables
            this._numVertices = 0;
            this._nextVertexIndex = 0;
            this._currentIndex = 0;
            this._currentTriangleIndex = 0;
			
			// evaluate target number of vertices, triangles and indices
			if (this._surfaceClosed)
            {
                this._numVertices += (this._pSegmentsH + 1)*(this._pSegmentsW + 1); // segmentsH + 1 because of closure, segmentsW + 1 because of UV unwrapping
				numTriangles += this._pSegmentsH*this._pSegmentsW*2; // each level has segmentW quads, each of 2 triangles
			}
			if (this._topClosed)
            {
                this._numVertices += 2*(this._pSegmentsW + 1); // segmentsW + 1 because of unwrapping
				numTriangles += this._pSegmentsW; // one triangle for each segment
			}
			if (this._bottomClosed)
            {
                this._numVertices += 2*(this._pSegmentsW + 1);
				numTriangles += this._pSegmentsW;
			}
			
			// need to initialize raw arrays or can be reused?
			if (this._numVertices == target.numVertices)
            {
                this._rawData = target.vertexData;

                if ( target.indexData )
                {
                    this._rawIndices = target.indexData
                }
                else
                {
                    this._rawIndices =  VectorInit.Num(numTriangles*3);
                }

			}
            else
            {
				var numVertComponents:Number = this._numVertices*this._stride;
                this._rawData = VectorInit.Num(numVertComponents);
                this._rawIndices = VectorInit.Num(numTriangles*3);
			}
			
			// evaluate revolution steps
			var revolutionAngleDelta:Number = 2*Math.PI/this._pSegmentsW;
			
			// top
			if (this._topClosed && this._topRadius > 0) {
				
				z = -0.5*this._height;
				
				for (i = 0; i <= this._pSegmentsW; ++i) {
					// central vertex
					if (this._yUp) {
						t1 = 1;
						t2 = 0;
						comp1 = -z;
						comp2 = 0;
						
					} else {
						t1 = 0;
						t2 = -1;
						comp1 = 0;
						comp2 = z;
					}

                    this.addVertex(0, comp1, comp2, 0, t1, t2, 1, 0, 0);
					
					// revolution vertex
					revolutionAngle = i*revolutionAngleDelta;
					x = this._topRadius*Math.cos(revolutionAngle);
					y = this._topRadius*Math.sin(revolutionAngle);
					
					if (this._yUp)
                    {
						comp1 = -z;
						comp2 = y;
					}
                    else
                    {
						comp1 = y;
						comp2 = z;
					}
					
					if (i == this._pSegmentsW)
                        this.addVertex(this._rawData[startIndex + this._stride], this._rawData[startIndex + this._stride + 1], this._rawData[startIndex + this._stride + 2], 0, t1, t2, 1, 0, 0);
					else
                        this.addVertex(x, comp1, comp2, 0, t1, t2, 1, 0, 0);
					
					if (i > 0) // add triangle
						this.addTriangleClockWise(this._nextVertexIndex - 1, this._nextVertexIndex - 3, this._nextVertexIndex - 2);
				}
			}
			
			// bottom
			if (this._bottomClosed && this._pBottomRadius > 0)
            {
				
				z = 0.5*this._height;
				
				startIndex = this._vertexOffset + this._nextVertexIndex*this._stride;
				
				for (i = 0; i <= this._pSegmentsW; ++i)
                {
					if (this._yUp)
                    {
						t1 = -1;
						t2 = 0;
						comp1 = -z;
						comp2 = 0;
					}
                    else
                    {
						t1 = 0;
						t2 = 1;
						comp1 = 0;
						comp2 = z;
					}

                    this.addVertex(0, comp1, comp2, 0, t1, t2, 1, 0, 0);
					
					// revolution vertex
					revolutionAngle = i*revolutionAngleDelta;
					x = this._pBottomRadius*Math.cos(revolutionAngle);
					y = this._pBottomRadius*Math.sin(revolutionAngle);
					
					if (this._yUp) {
						comp1 = -z;
						comp2 = y;
					} else {
						comp1 = y;
						comp2 = z;
					}
					
					if (i == this._pSegmentsW)
                        this.addVertex(x, this._rawData[startIndex + 1], this._rawData[startIndex + 2], 0, t1, t2, 1, 0, 0);
					else
                        this.addVertex(x, comp1, comp2, 0, t1, t2, 1, 0, 0);
					
					if (i > 0) // add triangle
                        this.addTriangleClockWise(this._nextVertexIndex - 2, this._nextVertexIndex - 3, this._nextVertexIndex - 1);
				}
			}
			
			// The normals on the lateral surface all have the same incline, i.e.
			// the "elevation" component (Y or Z depending on yUp) is constant.
			// Same principle goes for the "base" of these vectors, which will be
			// calculated such that a vector [base,elev] will be a unit vector.
			dr = (this._pBottomRadius - this._topRadius);
			latNormElev = dr/this._height;
			latNormBase = (latNormElev == 0)? 1 : this._height/dr;
			
			// lateral surface
			if (this._surfaceClosed)
            {
				var a:Number;
                var b:Number;
                var c:Number;
                var d:Number;
				var na0:Number, na1:Number, naComp1:Number, naComp2:Number;
				
				for (j = 0; j <= this._pSegmentsH; ++j)
                {
					radius = this._topRadius - ((j/this._pSegmentsH)*(this._topRadius - this._pBottomRadius));
					z = -(this._height/2) + (j/this._pSegmentsH*this._height);
					
					startIndex = this._vertexOffset + this._nextVertexIndex*this._stride;
					
					for (i = 0; i <= this._pSegmentsW; ++i)
                    {
						// revolution vertex
						revolutionAngle = i*revolutionAngleDelta;
						x = radius*Math.cos(revolutionAngle);
						y = radius*Math.sin(revolutionAngle);
						na0 = latNormBase*Math.cos(revolutionAngle);
						na1 = latNormBase*Math.sin(revolutionAngle);
						
						if (this._yUp)
                        {
							t1 = 0;
							t2 = -na0;
							comp1 = -z;
							comp2 = y;
							naComp1 = latNormElev;
							naComp2 = na1;
							
						}
                        else
                        {
							t1 = -na0;
							t2 = 0;
							comp1 = y;
							comp2 = z;
							naComp1 = na1;
							naComp2 = latNormElev;
						}
						
						if (i == this._pSegmentsW)
                        {
                            this.addVertex( this._rawData[startIndex], this._rawData[startIndex + 1], this._rawData[startIndex + 2],
								            na0, latNormElev, na1,
								            na1, t1, t2);
						}
                        else
                        {
                            this.addVertex( x, comp1, comp2,
								            na0, naComp1, naComp2,
								            -na1, t1, t2);
						}
						
						// close triangle
						if (i > 0 && j > 0) {
							a = this._nextVertexIndex - 1; // current
							b = this._nextVertexIndex - 2; // previous
							c = b - this._pSegmentsW - 1; // previous of last level
							d = a - this._pSegmentsW - 1; // current of last level
                            this.addTriangleClockWise(a, b, c);
                            this.addTriangleClockWise(a, c, d);
						}
					}
				}
			}
			
			// build real data from raw data
			target.updateData(this._rawData);
			target.updateIndexData(this._rawIndices);
		}
		
		/**		 * @inheritDoc		 */
		override public function pBuildUVs(target:CompactSubGeometry):void
		{
			var i:Number;
            var j:Number;
			var x:Number;
            var y:Number;
            var revolutionAngle:Number;
			var stride:Number = target.UVStride;
			var skip:Number = stride - 2;
			var UVData:Vector.<Number>;
			
			// evaluate num uvs
			var numUvs:Number = this._numVertices*stride;
			
			// need to initialize raw array or can be reused?
			if (target.UVData && numUvs == target.UVData.length)
            {
				UVData = target.UVData;
            }
			else
            {
				UVData = VectorInit.Num(numUvs);
				this.pInvalidateGeometry();
			}
			
			// evaluate revolution steps
			var revolutionAngleDelta:Number = 2*Math.PI/this._pSegmentsW;
			
			// current uv component index
			var currentUvCompIndex:Number = target.UVOffset;
			
			// top
			if (this._topClosed)
            {
				for (i = 0; i <= this._pSegmentsW; ++i)
                {
					
					revolutionAngle = i*revolutionAngleDelta;
					x = 0.5 + 0.5* -Math.cos(revolutionAngle);
					y = 0.5 + 0.5*Math.sin(revolutionAngle);
					
					UVData[currentUvCompIndex++] = 0.5*target.scaleU; // central vertex
					UVData[currentUvCompIndex++] = 0.5*target.scaleV;
					currentUvCompIndex += skip;
					UVData[currentUvCompIndex++] = x*target.scaleU; // revolution vertex
					UVData[currentUvCompIndex++] = y*target.scaleV;
					currentUvCompIndex += skip;
				}
			}
			
			// bottom
			if (this._bottomClosed)
            {
				for (i = 0; i <= this._pSegmentsW; ++i)
                {
					
					revolutionAngle = i*revolutionAngleDelta;
					x = 0.5 + 0.5*Math.cos(revolutionAngle);
					y = 0.5 + 0.5*Math.sin(revolutionAngle);
					
					UVData[currentUvCompIndex++] = 0.5*target.scaleU ; // central vertex
					UVData[currentUvCompIndex++] = 0.5*target.scaleV;
					currentUvCompIndex += skip;
					UVData[currentUvCompIndex++] = x*target.scaleU; // revolution vertex
					UVData[currentUvCompIndex++] = y*target.scaleV;
					currentUvCompIndex += skip;
				}
			}
			
			// lateral surface
			if (this._surfaceClosed)
            {
				for (j = 0; j <= this._pSegmentsH; ++j)
                {
					for (i = 0; i <= this._pSegmentsW; ++i)
                    {
						// revolution vertex
						UVData[currentUvCompIndex++] = ( i/this._pSegmentsW )*target.scaleU ;
						UVData[currentUvCompIndex++] = ( j/this._pSegmentsH )*target.scaleV;
						currentUvCompIndex += skip;
					}
				}
			}
			
			// build real data from raw data
			target.updateData(UVData);
		}
		
		/**		 * The radius of the top end of the cylinder.		 */
		public function get topRadius():Number
		{
			return this._topRadius;
		}
		
		public function set topRadius(value:Number):void
		{
            this._topRadius = value;
            this.pInvalidateGeometry();
		}
		
		/**		 * The radius of the bottom end of the cylinder.		 */
		public function get bottomRadius():Number
		{
			return this._pBottomRadius;
		}
		
		public function set bottomRadius(value:Number):void
		{
            this._pBottomRadius = value;
            this.pInvalidateGeometry();
		}
		
		/**		 * The radius of the top end of the cylinder.		 */
		public function get height():Number
		{
			return this._height;
		}
		
		public function set height(value:Number):void
		{
            this._height = value;
            this.pInvalidateGeometry();
		}
		
		/**		 * Defines the number of horizontal segments that make up the cylinder. Defaults to 16.		 */
		public function get segmentsW():Number
		{
			return this._pSegmentsW;
		}

        public function set segmentsW(value:Number):void
        {
            this.setSegmentsW( value );
        }

        public function setSegmentsW(value:Number):void
        {
            this._pSegmentsW = value;
            this.pInvalidateGeometry();
            this.pInvalidateUVs();
        }
		
		/**		 * Defines the number of vertical segments that make up the cylinder. Defaults to 1.		 */
		public function get segmentsH():Number
		{
			return this._pSegmentsH;
		}

        public function set segmentsH(value:Number):void
        {

            this.setSegmentsH( value )

        }

        public function setSegmentsH(value:Number):void
        {
            this._pSegmentsH = value;
            this.pInvalidateGeometry();
            this.pInvalidateUVs();

        }
		
		/**		 * Defines whether the top end of the cylinder is closed (true) or open.		 */
		public function get topClosed():Boolean
		{
			return this._topClosed;
		}
		
		public function set topClosed(value:Boolean):void
		{
            this._topClosed = value;
            this.pInvalidateGeometry();
		}
		
		/**		 * Defines whether the bottom end of the cylinder is closed (true) or open.		 */
		public function get bottomClosed():Boolean
		{
			return this._bottomClosed;
		}
		
		public function set bottomClosed(value:Boolean):void
		{
            this._bottomClosed = value;
            this.pInvalidateGeometry();
		}
		
		/**		 * Defines whether the cylinder poles should lay on the Y-axis (true) or on the Z-axis (false).		 */
		public function get yUp():Boolean
		{
			return this._yUp;
		}
		
		public function set yUp(value:Boolean):void
		{
            this._yUp = value;
            this.pInvalidateGeometry();
		}
		
		/**		 * Creates a new Cylinder object.		 * @param topRadius The radius of the top end of the cylinder.		 * @param bottomRadius The radius of the bottom end of the cylinder		 * @param height The radius of the bottom end of the cylinder		 * @param segmentsW Defines the number of horizontal segments that make up the cylinder. Defaults to 16.		 * @param segmentsH Defines the number of vertical segments that make up the cylinder. Defaults to 1.		 * @param topClosed Defines whether the top end of the cylinder is closed (true) or open.		 * @param bottomClosed Defines whether the bottom end of the cylinder is closed (true) or open.		 * @param yUp Defines whether the cone poles should lay on the Y-axis (true) or on the Z-axis (false).		 */
		public function CylinderGeometry(topRadius:Number = 50, bottomRadius:Number = 50, height:Number = 100, segmentsW:Number = 16, segmentsH:Number = 1, topClosed:Boolean = true, bottomClosed:Boolean = true, surfaceClosed:Boolean = true, yUp:Boolean = true):void
		{
			topRadius = topRadius || 50;
			bottomRadius = bottomRadius || 50;
			height = height || 100;
			segmentsW = segmentsW || 16;
			segmentsH = segmentsH || 1;
			topClosed = topClosed || true;
			bottomClosed = bottomClosed || true;
			surfaceClosed = surfaceClosed || true;
			yUp = yUp || true;

			super();

            this._topRadius = topRadius;
            this._pBottomRadius = bottomRadius;
            this._height = height;
            this._pSegmentsW = segmentsW;
            this._pSegmentsH = segmentsH;
            this._topClosed = topClosed;
            this._bottomClosed = bottomClosed;
            this._surfaceClosed = surfaceClosed;
            this._yUp = yUp;
		}
	}
}
