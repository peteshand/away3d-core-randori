///<reference path="../_definitions.ts"/>

package away.primitives
{
	import away.base.CompactSubGeometry;

	/**	 * A Cylinder primitive mesh.	 */
	public class CylinderGeometry extends PrimitiveBase
	{
		public var _pBottomRadius:Number;
        public var _pSegmentsW:Number;
        public var _pSegmentsH:Number;
        
		private var _topRadius:Number;
		private var _height:Number;

		private var _topClosed:Boolean;
		private var _bottomClosed:Boolean;
		private var _surfaceClosed:Boolean;
		private var _yUp:Boolean;
		private var _rawData:Vector.<Number>;
		private var _rawIndices:Vector.<Number>/*uint*/;
		private var _nextVertexIndex:Number;
		private var _currentIndex:Number = 0;
		private var _currentTriangleIndex:Number;
		private var _numVertices:Number = 0;
		private var _stride:Number;
		private var _vertexOffset:Number;
		
		private function addVertex(px:Number, py:Number, pz:Number, nx:Number, ny:Number, nz:Number, tx:Number, ty:Number, tz:Number):void
		{
			var compVertInd:Number = _vertexOffset + _nextVertexIndex*_stride; // current component vertex index
            _rawData[compVertInd++] = px;
            _rawData[compVertInd++] = py;
            _rawData[compVertInd++] = pz;
            _rawData[compVertInd++] = nx;
            _rawData[compVertInd++] = ny;
            _rawData[compVertInd++] = nz;
            _rawData[compVertInd++] = tx;
            _rawData[compVertInd++] = ty;
            _rawData[compVertInd++] = tz;
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
			
			_stride = target.vertexStride;
            _vertexOffset = target.vertexOffset;
			
			// reset utility variables
            _numVertices = 0;
            _nextVertexIndex = 0;
            _currentIndex = 0;
            _currentTriangleIndex = 0;
			
			// evaluate target number of vertices, triangles and indices
			if (_surfaceClosed)
            {
                _numVertices += (_pSegmentsH + 1)*(_pSegmentsW + 1); // segmentsH + 1 because of closure, segmentsW + 1 because of UV unwrapping
				numTriangles += _pSegmentsH*_pSegmentsW*2; // each level has segmentW quads, each of 2 triangles
			}
			if (_topClosed)
            {
                _numVertices += 2*(_pSegmentsW + 1); // segmentsW + 1 because of unwrapping
				numTriangles += _pSegmentsW; // one triangle for each segment
			}
			if (_bottomClosed)
            {
                _numVertices += 2*(_pSegmentsW + 1);
				numTriangles += _pSegmentsW;
			}
			
			// need to initialize raw arrays or can be reused?
			if (_numVertices == target.numVertices)
            {
                _rawData = target.vertexData;

                if ( target.indexData )
                {
                    _rawIndices = target.indexData
                }
                else
                {
                    _rawIndices =  new Vector.<Number>(numTriangles*3);
                }

			}
            else
            {
				var numVertComponents:Number = _numVertices*_stride;
                _rawData = new Vector.<Number>(numVertComponents);
                _rawIndices = new Vector.<Number>(numTriangles*3);
			}
			
			// evaluate revolution steps
			var revolutionAngleDelta:Number = 2*Math.PI/_pSegmentsW;
			
			// top
			if (_topClosed && _topRadius > 0) {
				
				z = -0.5*_height;
				
				for (i = 0; i <= _pSegmentsW; ++i) {
					// central vertex
					if (_yUp) {
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

                    addVertex(0, comp1, comp2, 0, t1, t2, 1, 0, 0);
					
					// revolution vertex
					revolutionAngle = i*revolutionAngleDelta;
					x = _topRadius*Math.cos(revolutionAngle);
					y = _topRadius*Math.sin(revolutionAngle);
					
					if (_yUp)
                    {
						comp1 = -z;
						comp2 = y;
					}
                    else
                    {
						comp1 = y;
						comp2 = z;
					}
					
					if (i == _pSegmentsW)
                        addVertex(_rawData[startIndex + _stride], _rawData[startIndex + _stride + 1], _rawData[startIndex + _stride + 2], 0, t1, t2, 1, 0, 0);
					else
                        addVertex(x, comp1, comp2, 0, t1, t2, 1, 0, 0);
					
					if (i > 0) // add triangle
						addTriangleClockWise(_nextVertexIndex - 1, _nextVertexIndex - 3, _nextVertexIndex - 2);
				}
			}
			
			// bottom
			if (_bottomClosed && _pBottomRadius > 0)
            {
				
				z = 0.5*_height;
				
				startIndex = _vertexOffset + _nextVertexIndex*_stride;
				
				for (i = 0; i <= _pSegmentsW; ++i)
                {
					if (_yUp)
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

                    addVertex(0, comp1, comp2, 0, t1, t2, 1, 0, 0);
					
					// revolution vertex
					revolutionAngle = i*revolutionAngleDelta;
					x = _pBottomRadius*Math.cos(revolutionAngle);
					y = _pBottomRadius*Math.sin(revolutionAngle);
					
					if (_yUp) {
						comp1 = -z;
						comp2 = y;
					} else {
						comp1 = y;
						comp2 = z;
					}
					
					if (i == _pSegmentsW)
                        addVertex(x, _rawData[startIndex + 1], _rawData[startIndex + 2], 0, t1, t2, 1, 0, 0);
					else
                        addVertex(x, comp1, comp2, 0, t1, t2, 1, 0, 0);
					
					if (i > 0) // add triangle
                        addTriangleClockWise(_nextVertexIndex - 2, _nextVertexIndex - 3, _nextVertexIndex - 1);
				}
			}
			
			// The normals on the lateral surface all have the same incline, i.e.
			// the "elevation" component (Y or Z depending on yUp) is constant.
			// Same principle goes for the "base" of these vectors, which will be
			// calculated such that a vector [base,elev] will be a unit vector.
			dr = (_pBottomRadius - _topRadius);
			latNormElev = dr/_height;
			latNormBase = (latNormElev == 0)? 1 : _height/dr;
			
			// lateral surface
			if (_surfaceClosed)
            {
				var a:Number;
                var b:Number;
                var c:Number;
                var d:Number;
				var na0:Number, na1:Number, naComp1:Number, naComp2:Number;
				
				for (j = 0; j <= _pSegmentsH; ++j)
                {
					radius = _topRadius - ((j/_pSegmentsH)*(_topRadius - _pBottomRadius));
					z = -(_height/2) + (j/_pSegmentsH*_height);
					
					startIndex = _vertexOffset + _nextVertexIndex*_stride;
					
					for (i = 0; i <= _pSegmentsW; ++i)
                    {
						// revolution vertex
						revolutionAngle = i*revolutionAngleDelta;
						x = radius*Math.cos(revolutionAngle);
						y = radius*Math.sin(revolutionAngle);
						na0 = latNormBase*Math.cos(revolutionAngle);
						na1 = latNormBase*Math.sin(revolutionAngle);
						
						if (_yUp)
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
						
						if (i == _pSegmentsW)
                        {
                            addVertex( _rawData[startIndex], _rawData[startIndex + 1], _rawData[startIndex + 2],
								            na0, latNormElev, na1,
								            na1, t1, t2);
						}
                        else
                        {
                            addVertex( x, comp1, comp2,
								            na0, naComp1, naComp2,
								            -na1, t1, t2);
						}
						
						// close triangle
						if (i > 0 && j > 0) {
							a = _nextVertexIndex - 1; // current
							b = _nextVertexIndex - 2; // previous
							c = b - _pSegmentsW - 1; // previous of last level
							d = a - _pSegmentsW - 1; // current of last level
                            addTriangleClockWise(a, b, c);
                            addTriangleClockWise(a, c, d);
						}
					}
				}
			}
			
			// build real data from raw data
			target.updateData(_rawData);
			target.updateIndexData(_rawIndices);
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
			var numUvs:Number = _numVertices*stride;
			
			// need to initialize raw array or can be reused?
			if (target.UVData && numUvs == target.UVData.length)
            {
				UVData = target.UVData;
            }
			else
            {
				UVData = new Vector.<Number>(numUvs);
				pInvalidateGeometry();
			}
			
			// evaluate revolution steps
			var revolutionAngleDelta:Number = 2*Math.PI/_pSegmentsW;
			
			// current uv component index
			var currentUvCompIndex:Number = target.UVOffset;
			
			// top
			if (_topClosed)
            {
				for (i = 0; i <= _pSegmentsW; ++i)
                {
					
					revolutionAngle = i*revolutionAngleDelta;
					x = 0.5 + 0.5* -Math.cos(revolutionAngle);
					y = 0.5 + 0.5*Math.sin(revolutionAngle);
					
					UVData[currentUvCompIndex++] = 1 - ( 0.5*target.scaleU ) ; // central vertex
					UVData[currentUvCompIndex++] = 0.5*target.scaleV;
					currentUvCompIndex += skip;
					UVData[currentUvCompIndex++] = 1 - ( x*target.scaleU ) ; // revolution vertex
					UVData[currentUvCompIndex++] = y*target.scaleV;
					currentUvCompIndex += skip;
				}
			}
			
			// bottom
			if (_bottomClosed)
            {
				for (i = 0; i <= _pSegmentsW; ++i)
                {
					
					revolutionAngle = i*revolutionAngleDelta;
					x = 0.5 + 0.5*Math.cos(revolutionAngle);
					y = 0.5 + 0.5*Math.sin(revolutionAngle);
					
					UVData[currentUvCompIndex++] = 1 - ( 0.5*target.scaleU ) ; // central vertex
					UVData[currentUvCompIndex++] = 0.5*target.scaleV;
					currentUvCompIndex += skip;
					UVData[currentUvCompIndex++] = 1 - ( x*target.scaleU ) ; // revolution vertex
					UVData[currentUvCompIndex++] = y*target.scaleV;
					currentUvCompIndex += skip;
				}
			}
			
			// lateral surface
			if (_surfaceClosed)
            {
				for (j = 0; j <= _pSegmentsH; ++j)
                {
					for (i = 0; i <= _pSegmentsW; ++i)
                    {
						// revolution vertex
						UVData[currentUvCompIndex++] = 1 - ( ( i/_pSegmentsW )*target.scaleU ) ;
						UVData[currentUvCompIndex++] = ( j/_pSegmentsH )*target.scaleV;
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
			return _topRadius;
		}
		
		public function set topRadius(value:Number):void
		{
            this._topRadius = value;
            this.pInvalidateGeometry();
		}
		
		/**		 * The radius of the bottom end of the cylinder.		 */
		public function get bottomRadius():Number
		{
			return _pBottomRadius;
		}
		
		public function set bottomRadius(value:Number):void
		{
            this._pBottomRadius = value;
            this.pInvalidateGeometry();
		}
		
		/**		 * The radius of the top end of the cylinder.		 */
		public function get height():Number
		{
			return _height;
		}
		
		public function set height(value:Number):void
		{
            this._height = value;
            this.pInvalidateGeometry();
		}
		
		/**		 * Defines the number of horizontal segments that make up the cylinder. Defaults to 16.		 */
		public function get segmentsW():Number
		{
			return _pSegmentsW;
		}

        public function set segmentsW(value:Number):void
        {
            this.setSegmentsW( value );
        }

        public function setSegmentsW(value:Number):void
        {
            _pSegmentsW = value;
            pInvalidateGeometry();
            pInvalidateUVs();
        }
		
		/**		 * Defines the number of vertical segments that make up the cylinder. Defaults to 1.		 */
		public function get segmentsH():Number
		{
			return _pSegmentsH;
		}

        public function set segmentsH(value:Number):void
        {

            this.setSegmentsH( value )

        }

        public function setSegmentsH(value:Number):void
        {
            _pSegmentsH = value;
            pInvalidateGeometry();
            pInvalidateUVs();

        }
		
		/**		 * Defines whether the top end of the cylinder is closed (true) or open.		 */
		public function get topClosed():Boolean
		{
			return _topClosed;
		}
		
		public function set topClosed(value:Boolean):void
		{
            this._topClosed = value;
            this.pInvalidateGeometry();
		}
		
		/**		 * Defines whether the bottom end of the cylinder is closed (true) or open.		 */
		public function get bottomClosed():Boolean
		{
			return _bottomClosed;
		}
		
		public function set bottomClosed(value:Boolean):void
		{
            this._bottomClosed = value;
            this.pInvalidateGeometry();
		}
		
		/**		 * Defines whether the cylinder poles should lay on the Y-axis (true) or on the Z-axis (false).		 */
		public function get yUp():Boolean
		{
			return _yUp;
		}
		
		public function set yUp(value:Boolean):void
		{
            this._yUp = value;
            this.pInvalidateGeometry();
		}
		
		/**		 * Creates a new Cylinder object.		 * @param topRadius The radius of the top end of the cylinder.		 * @param bottomRadius The radius of the bottom end of the cylinder		 * @param height The radius of the bottom end of the cylinder		 * @param segmentsW Defines the number of horizontal segments that make up the cylinder. Defaults to 16.		 * @param segmentsH Defines the number of vertical segments that make up the cylinder. Defaults to 1.		 * @param topClosed Defines whether the top end of the cylinder is closed (true) or open.		 * @param bottomClosed Defines whether the bottom end of the cylinder is closed (true) or open.		 * @param yUp Defines whether the cone poles should lay on the Y-axis (true) or on the Z-axis (false).		 */
		public function CylinderGeometry(topRadius:Number = 50, bottomRadius:Number = 50, height:Number = 100, segmentsW:Number = 16, segmentsH:Number = 1, topClosed:Boolean = true, bottomClosed:Boolean = true, surfaceClosed:Boolean = true, yUp:Boolean = true):void
		{
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
