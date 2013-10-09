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
	//import away3d.arcane;
	//import away3d.core.base.CompactSubGeometry;
	
	//use namespace arcane;
	
	/**	 * A UV Cylinder primitive mesh.	 */
	public class TorusGeometry extends PrimitiveBase
	{
		private var _radius:Number = 0;
		private var _tubeRadius:Number = 0;
		private var _segmentsR:Number = 0;
		private var _segmentsT:Number = 0;
		private var _yUp:Boolean = false;
		private var _rawVertexData:Vector.<Number>;
		private var _rawIndices:Vector.<Number>;/*uint*/
		private var _nextVertexIndex:Number = 0;
		private var _currentIndex:Number = 0;
		private var _currentTriangleIndex:Number = 0;
		private var _numVertices:Number = 0;
		private var _vertexStride:Number = 0;
		private var _vertexOffset:Number = 0;
		
		private function addVertex(px:Number, py:Number, pz:Number, nx:Number, ny:Number, nz:Number, tx:Number, ty:Number, tz:Number):void
		{
			var compVertInd:Number = this._vertexOffset + this._nextVertexIndex*this._vertexStride; // current component vertex index
            this._rawVertexData[compVertInd++] = px;
            this._rawVertexData[compVertInd++] = py;
            this._rawVertexData[compVertInd++] = pz;
            this._rawVertexData[compVertInd++] = nx;
            this._rawVertexData[compVertInd++] = ny;
            this._rawVertexData[compVertInd++] = nz;
            this._rawVertexData[compVertInd++] = tx;
            this._rawVertexData[compVertInd++] = ty;
            this._rawVertexData[compVertInd] = tz;
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
			var i:Number, j:Number;
			var x:Number, y:Number, z:Number, nx:Number, ny:Number, nz:Number, revolutionAngleR:Number, revolutionAngleT:Number;
			var numTriangles:Number;
			// reset utility variables
			this._numVertices = 0;
            this._nextVertexIndex = 0;
            this._currentIndex = 0;
            this._currentTriangleIndex = 0;
            this._vertexStride = target.vertexStride;
            this._vertexOffset = target.vertexOffset;
			
			// evaluate target number of vertices, triangles and indices
            this._numVertices = (this._segmentsT + 1)*(this._segmentsR + 1); // segmentsT + 1 because of closure, segmentsR + 1 because of closure
			numTriangles = this._segmentsT*this._segmentsR*2; // each level has segmentR quads, each of 2 triangles
			
			// need to initialize raw arrays or can be reused?
			if (this._numVertices == target.numVertices)
            {
                this._rawVertexData = target.vertexData;

                if ( target.indexData == null )
                {
                    this._rawIndices = VectorInit.Num( numTriangles * 3 );
                }
                else
                {
                    this._rawIndices = target.indexData;
                }

                     			}
            else
            {
				var numVertComponents:Number = this._numVertices*this._vertexStride;
                this._rawVertexData = VectorInit.Num(numVertComponents);
                this._rawIndices = VectorInit.Num(numTriangles*3);
                this.pInvalidateUVs();

			}
			
			// evaluate revolution steps
			var revolutionAngleDeltaR:Number = 2*Math.PI/this._segmentsR;
			var revolutionAngleDeltaT:Number = 2*Math.PI/this._segmentsT;
			
			var comp1:Number, comp2:Number;
			var t1:Number, t2:Number, n1:Number, n2:Number;
			var startIndex:Number;
			
			// surface
			var a:Number, b:Number, c:Number, d:Number, length:Number;
			
			for (j = 0; j <= this._segmentsT; ++j)
            {
				
				startIndex = this._vertexOffset + this._nextVertexIndex * this._vertexStride;
				
				for (i = 0; i <= this._segmentsR; ++i)
                {

					// revolution vertex
					revolutionAngleR = i*revolutionAngleDeltaR;
					revolutionAngleT = j*revolutionAngleDeltaT;
					
					length = Math.cos(revolutionAngleT);
					nx = length*Math.cos(revolutionAngleR);
					ny = length*Math.sin(revolutionAngleR);
					nz = Math.sin(revolutionAngleT);
					
					x = this._radius*Math.cos(revolutionAngleR) + this._tubeRadius*nx;
					y = this._radius*Math.sin(revolutionAngleR) + this._tubeRadius*ny;
					z = (j == this._segmentsT)? 0 : this._tubeRadius*nz;
					
					if (this._yUp)
                    {

						n1 = -nz;
						n2 = ny;
						t1 = 0;
						t2 = (length? nx/length : x/this._radius);
						comp1 = -z;
						comp2 = y;
						
					}
                    else
                    {
						n1 = ny;
						n2 = nz;
						t1 = (length? nx/length : x/this._radius);
						t2 = 0;
						comp1 = y;
						comp2 = z;
					}
					
					if (i == this._segmentsR)
                    {
						this.addVertex(x, this._rawVertexData[startIndex + 1], this._rawVertexData[startIndex + 2],
							nx, n1, n2,
							-(length? ny/length : y/this._radius), t1, t2);
					}
                    else
                    {
						this.addVertex(x, comp1, comp2,
							nx, n1, n2,
							-(length? ny/length : y/this._radius), t1, t2);
					}
					
					// close triangle
					if (i > 0 && j > 0)
                    {
						a = this._nextVertexIndex - 1; // current
						b = this._nextVertexIndex - 2; // previous
						c = b - this._segmentsR - 1; // previous of last level
						d = a - this._segmentsR - 1; // current of last level
                        this.addTriangleClockWise(a, b, c);
                        this.addTriangleClockWise(a, c, d);
					}
				}
			}
			
			// build real data from raw data
			target.updateData(this._rawVertexData);
			target.updateIndexData(this._rawIndices);
		}
		
		/**		 * @inheritDoc		 */
		override public function pBuildUVs(target:CompactSubGeometry):void
		{

			var i:Number, j:Number;
			var data:Vector.<Number>;
			var stride:Number = target.UVStride;
			var offset:Number = target.UVOffset;
			var skip:Number = target.UVStride - 2;
			
			// evaluate num uvs
			var numUvs:Number = this._numVertices*stride;
			
			// need to initialize raw array or can be reused?
			if (target.UVData && numUvs == target.UVData.length)
            {
                data = target.UVData;
            }
			else
            {
				data = VectorInit.Num( numUvs );
				this.pInvalidateGeometry();//invalidateGeometry();
			}
			
			// current uv component index
			var currentUvCompIndex:Number = offset;
			
			// surface
			for (j = 0; j <= this._segmentsT; ++j)
            {

				for (i = 0; i <= this._segmentsR; ++i)
                {
					// revolution vertex
					data[currentUvCompIndex++] = ( i/this._segmentsR )*target.scaleU;
					data[currentUvCompIndex++] = ( j/this._segmentsT )*target.scaleV;
					currentUvCompIndex += skip;
				}

			}
			
			// build real data from raw data
			target.updateData(data);
		}
		
		/**		 * The radius of the torus.		 */
		public function get radius():Number
		{
			return this._radius;
		}
		
		public function set radius(value:Number):void
		{
            this._radius = value;
            this.pInvalidateGeometry();
		}
		
		/**		 * The radius of the inner tube of the torus.		 */
		public function get tubeRadius():Number
		{
			return this._tubeRadius;
		}
		
		public function set tubeRadius(value:Number):void
		{
            this._tubeRadius = value;
            this.pInvalidateGeometry();
		}
		
		/**		 * Defines the number of horizontal segments that make up the torus. Defaults to 16.		 */
		public function get segmentsR():Number
		{
			return this._segmentsR;
		}
		
		public function set segmentsR(value:Number):void
		{
            this._segmentsR = value;
            this.pInvalidateGeometry();
            this.pInvalidateUVs();
		}
		
		/**		 * Defines the number of vertical segments that make up the torus. Defaults to 8.		 */
		public function get segmentsT():Number
		{
			return this._segmentsT;
		}
		
		public function set segmentsT(value:Number):void
		{
            this._segmentsT = value;
            this.pInvalidateGeometry();
			this.pInvalidateUVs();
		}
		
		/**		 * Defines whether the torus poles should lay on the Y-axis (true) or on the Z-axis (false).		 */
		public function get yUp():Boolean
		{
			return this._yUp;
		}
		
		public function set yUp(value:Boolean):void
		{
            this._yUp = value;
            this.pInvalidateGeometry();
		}
		
		/**		 * Creates a new <code>Torus</code> object.		 * @param radius The radius of the torus.		 * @param tuebRadius The radius of the inner tube of the torus.		 * @param segmentsR Defines the number of horizontal segments that make up the torus.		 * @param segmentsT Defines the number of vertical segments that make up the torus.		 * @param yUp Defines whether the torus poles should lay on the Y-axis (true) or on the Z-axis (false).		 */
		public function TorusGeometry(radius:Number = 50, tubeRadius:Number = 50, segmentsR:Number = 16, segmentsT:Number = 8, yUp:Boolean = true):void
		{
			radius = radius || 50;
			tubeRadius = tubeRadius || 50;
			segmentsR = segmentsR || 16;
			segmentsT = segmentsT || 8;

			super();

            this._radius = radius;
            this._tubeRadius = tubeRadius;
            this._segmentsR = segmentsR;
            this._segmentsT = segmentsT;
			this._yUp = yUp;
		}
	}
}
