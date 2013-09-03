///<reference path="../_definitions.ts"/>

package away.primitives
{
	import away.base.CompactSubGeometry;
	//import away3d.arcane;
	//import away3d.core.base.CompactSubGeometry;
	
	//use namespace arcane;
	
	/**	 * A UV Cylinder primitive mesh.	 */
	public class TorusGeometry extends PrimitiveBase
	{
		private var _radius:Number;
		private var _tubeRadius:Number;
		private var _segmentsR:Number;
		private var _segmentsT:Number;
		private var _yUp:Boolean;
		private var _rawVertexData:Vector.<Number>;
		private var _rawIndices:Vector.<Number>/*uint*/;
		private var _nextVertexIndex:Number = 0;
		private var _currentIndex:Number = 0;
		private var _currentTriangleIndex:Number = 0;
		private var _numVertices:Number = 0;
		private var _vertexStride:Number;
		private var _vertexOffset:Number;
		
		private function addVertex(px:Number, py:Number, pz:Number, nx:Number, ny:Number, nz:Number, tx:Number, ty:Number, tz:Number):void
		{
			var compVertInd:Number = _vertexOffset + _nextVertexIndex*_vertexStride; // current component vertex index
            _rawVertexData[compVertInd++] = px;
            _rawVertexData[compVertInd++] = py;
            _rawVertexData[compVertInd++] = pz;
            _rawVertexData[compVertInd++] = nx;
            _rawVertexData[compVertInd++] = ny;
            _rawVertexData[compVertInd++] = nz;
            _rawVertexData[compVertInd++] = tx;
            _rawVertexData[compVertInd++] = ty;
            _rawVertexData[compVertInd] = tz;
            _nextVertexIndex++;

		}
		
		private function addTriangleClockWise(cwVertexIndex0:Number, cwVertexIndex1:Number, cwVertexIndex2:Number):void
		{
            _rawIndices[_currentIndex++] = cwVertexIndex0;
            _rawIndices[_currentIndex++] = cwVertexIndex1;
            _rawIndices[_currentIndex++] = cwVertexIndex2;
            _currentTriangleIndex++;
		}
		
		/**		 * @inheritDoc		 */
		override public function pBuildGeometry(target:CompactSubGeometry):void
		{
			var i:Number, j:Number;
			var x:Number, y:Number, z:Number, nx:Number, ny:Number, nz:Number, revolutionAngleR:Number, revolutionAngleT:Number;
			var numTriangles:Number;
			// reset utility variables
			_numVertices = 0;
            _nextVertexIndex = 0;
            _currentIndex = 0;
            _currentTriangleIndex = 0;
            _vertexStride = target.vertexStride;
            _vertexOffset = target.vertexOffset;
			
			// evaluate target number of vertices, triangles and indices
            _numVertices = (_segmentsT + 1)*(_segmentsR + 1); // segmentsT + 1 because of closure, segmentsR + 1 because of closure
			numTriangles = _segmentsT*_segmentsR*2; // each level has segmentR quads, each of 2 triangles
			
			// need to initialize raw arrays or can be reused?
			if (_numVertices == target.numVertices)
            {
                _rawVertexData = target.vertexData;

                if ( target.indexData == null )
                {
                    _rawIndices = new Vector.<Number>( numTriangles * 3 );
                }
                else
                {
                    _rawIndices = target.indexData;
                }

                     			}
            else
            {
				var numVertComponents:Number = _numVertices*_vertexStride;
                _rawVertexData = new Vector.<Number>(numVertComponents);
                _rawIndices = new Vector.<Number>(numTriangles*3);
                pInvalidateUVs();

			}
			
			// evaluate revolution steps
			var revolutionAngleDeltaR:Number = 2*Math.PI/_segmentsR;
			var revolutionAngleDeltaT:Number = 2*Math.PI/_segmentsT;
			
			var comp1:Number, comp2:Number;
			var t1:Number, t2:Number, n1:Number, n2:Number;
			var startIndex:Number;
			
			// surface
			var a:Number, b:Number, c:Number, d:Number, length:Number;
			
			for (j = 0; j <= _segmentsT; ++j)
            {
				
				startIndex = _vertexOffset + _nextVertexIndex * _vertexStride;
				
				for (i = 0; i <= _segmentsR; ++i)
                {

					// revolution vertex
					revolutionAngleR = i*revolutionAngleDeltaR;
					revolutionAngleT = j*revolutionAngleDeltaT;
					
					length = Math.cos(revolutionAngleT);
					nx = length*Math.cos(revolutionAngleR);
					ny = length*Math.sin(revolutionAngleR);
					nz = Math.sin(revolutionAngleT);
					
					x = _radius*Math.cos(revolutionAngleR) + _tubeRadius*nx;
					y = _radius*Math.sin(revolutionAngleR) + _tubeRadius*ny;
					z = (j == _segmentsT)? 0 : _tubeRadius*nz;
					
					if (_yUp)
                    {

						n1 = -nz;
						n2 = ny;
						t1 = 0;
						t2 = (length? nx/length : x/_radius);
						comp1 = -z;
						comp2 = y;
						
					}
                    else
                    {
						n1 = ny;
						n2 = nz;
						t1 = (length? nx/length : x/_radius);
						t2 = 0;
						comp1 = y;
						comp2 = z;
					}
					
					if (i == _segmentsR)
                    {
						addVertex(x, _rawVertexData[startIndex + 1], _rawVertexData[startIndex + 2],
							nx, n1, n2,
							-(length? ny/length : y/_radius), t1, t2);
					}
                    else
                    {
						addVertex(x, comp1, comp2,
							nx, n1, n2,
							-(length? ny/length : y/_radius), t1, t2);
					}
					
					// close triangle
					if (i > 0 && j > 0)
                    {
						a = _nextVertexIndex - 1; // current
						b = _nextVertexIndex - 2; // previous
						c = b - _segmentsR - 1; // previous of last level
						d = a - _segmentsR - 1; // current of last level
                        addTriangleClockWise(a, b, c);
                        addTriangleClockWise(a, c, d);
					}
				}
			}
			
			// build real data from raw data
			target.updateData(_rawVertexData);
			target.updateIndexData(_rawIndices);
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
			var numUvs:Number = _numVertices*stride;
			
			// need to initialize raw array or can be reused?
			if (target.UVData && numUvs == target.UVData.length)
            {
                data = target.UVData;
            }
			else
            {
				data = new Vector.<Number>( numUvs );
				pInvalidateGeometry();//invalidateGeometry();
			}
			
			// current uv component index
			var currentUvCompIndex:Number = offset;
			
			// surface
			for (j = 0; j <= _segmentsT; ++j)
            {

				for (i = 0; i <= _segmentsR; ++i)
                {
					// revolution vertex
					data[currentUvCompIndex++] = 1 - ( i/_segmentsR )*target.scaleU;
					data[currentUvCompIndex++] = ( j/_segmentsT )*target.scaleV;
					currentUvCompIndex += skip;
				}

			}
			
			// build real data from raw data
			target.updateData(data);
		}
		
		/**		 * The radius of the torus.		 */
		public function get radius():Number
		{
			return _radius;
		}
		
		public function set radius(value:Number):void
		{
            this._radius = value;
            this.pInvalidateGeometry();
		}
		
		/**		 * The radius of the inner tube of the torus.		 */
		public function get tubeRadius():Number
		{
			return _tubeRadius;
		}
		
		public function set tubeRadius(value:Number):void
		{
            this._tubeRadius = value;
            this.pInvalidateGeometry();
		}
		
		/**		 * Defines the number of horizontal segments that make up the torus. Defaults to 16.		 */
		public function get segmentsR():Number
		{
			return _segmentsR;
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
			return _segmentsT;
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
			return _yUp;
		}
		
		public function set yUp(value:Boolean):void
		{
            this._yUp = value;
            this.pInvalidateGeometry();
		}
		
		/**		 * Creates a new <code>Torus</code> object.		 * @param radius The radius of the torus.		 * @param tuebRadius The radius of the inner tube of the torus.		 * @param segmentsR Defines the number of horizontal segments that make up the torus.		 * @param segmentsT Defines the number of vertical segments that make up the torus.		 * @param yUp Defines whether the torus poles should lay on the Y-axis (true) or on the Z-axis (false).		 */
		public function TorusGeometry(radius:Number = 50, tubeRadius:Number = 50, segmentsR:Number = 16, segmentsT:Number = 8, yUp:Boolean = true):void
		{
			super();

            this._radius = radius;
            this._tubeRadius = tubeRadius;
            this._segmentsR = segmentsR;
            this._segmentsT = segmentsT;
			this._yUp = yUp;
		}
	}
}
