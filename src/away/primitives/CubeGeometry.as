///<reference path="../_definitions.ts"/>
package away.primitives
{
	import away.base.CompactSubGeometry;
	import away.utils.VectorNumber;
	//import away3d.arcane;
	//import away3d.core.base.CompactSubGeometry;
	
	//use namespace arcane;
	
	/**	 * A Cube primitive mesh.	 */
	public class CubeGeometry extends PrimitiveBase
	{
		private var _width:Number;
		private var _height:Number;
		private var _depth:Number;
		private var _tile6:Boolean;
		
		private var _segmentsW:Number;
		private var _segmentsH:Number;
		private var _segmentsD:Number;
		
		/**		 * Creates a new Cube object.		 * @param width The size of the cube along its X-axis.		 * @param height The size of the cube along its Y-axis.		 * @param depth The size of the cube along its Z-axis.		 * @param segmentsW The number of segments that make up the cube along the X-axis.		 * @param segmentsH The number of segments that make up the cube along the Y-axis.		 * @param segmentsD The number of segments that make up the cube along the Z-axis.		 * @param tile6 The type of uv mapping to use. When true, a texture will be subdivided in a 2x3 grid, each used for a single face. When false, the entire image is mapped on each face.		 */
		public function CubeGeometry(width:Number = 100, height:Number = 100, depth:Number = 100, segmentsW:Number = 1, segmentsH:Number = 1, segmentsD:Number = 1, tile6:Boolean = true):void
		{
			width = width || 100;
			height = height || 100;
			depth = depth || 100;
			segmentsW = segmentsW || 1;
			segmentsH = segmentsH || 1;
			segmentsD = segmentsD || 1;
			tile6 = tile6 || true;

			super();
			
			this._width = width;
            this._height = height;
            this._depth = depth;
            this._segmentsW = segmentsW;
            this._segmentsH = segmentsH;
            this._segmentsD = segmentsD;
            this._tile6 = tile6;
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
		
		/**		 * The type of uv mapping to use. When false, the entire image is mapped on each face.		 * When true, a texture will be subdivided in a 3x2 grid, each used for a single face.		 * Reading the tiles from left to right, top to bottom they represent the faces of the		 * cube in the following order: bottom, top, back, left, front, right. This creates		 * several shared edges (between the top, front, left and right faces) which simplifies		 * texture painting.		 */
		public function get tile6():Boolean
		{
			return this._tile6;
		}
		
		public function set tile6(value:Boolean):void
		{
            this._tile6 = value;
            this.pInvalidateGeometry();
		}
		
		/**		 * The number of segments that make up the cube along the X-axis. Defaults to 1.		 */
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
		
		/**		 * The number of segments that make up the cube along the Y-axis. Defaults to 1.		 */
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
		
		/**		 * The number of segments that make up the cube along the Z-axis. Defaults to 1.		 */
		public function get segmentsD():Number
		{
			return this._segmentsD;
		}
		
		public function set segmentsD(value:Number):void
		{
            this._segmentsD = value;
            this.pInvalidateGeometry();
            this.pInvalidateUVs();
		}
		
		/**		 * @inheritDoc		 */
		override public function pBuildGeometry(target:CompactSubGeometry):void
		{
			var data:Vector.<Number>;
			var indices:Vector.<Number> /*uint*/;
			
			var tl:Number, tr:Number, bl:Number, br:Number;
			var i:Number, j:Number, inc:Number = 0;
			
			var vidx:Number, fidx:Number; // indices
			var hw:Number, hh:Number, hd:Number; // halves
			var dw:Number, dh:Number, dd:Number; // deltas
			
			var outer_pos:Number;
			
			var numVerts:Number = ((this._segmentsW + 1)*(this._segmentsH + 1) +
				(this._segmentsW + 1)*(this._segmentsD + 1) +
				(this._segmentsH + 1)*(this._segmentsD + 1))*2;
			
			var stride:Number = target.vertexStride;
			var skip:Number = stride - 9;
			
			if (numVerts == target.numVertices)
            {

				data = target.vertexData;

                indices = ( target.indexData ) ? target.indexData : VectorNumber.init((this._segmentsW*this._segmentsH + this._segmentsW*this._segmentsD + this._segmentsH*this._segmentsD)*12 );
                //indices = target.indexData || new Vector.<uint>((_segmentsW*_segmentsH + _segmentsW*_segmentsD + _segmentsH*_segmentsD)*12, true);

			} else {
				data = VectorNumber.init( numVerts*stride );
				indices = VectorNumber.init((this._segmentsW*this._segmentsH + this._segmentsW*this._segmentsD + this._segmentsH*this._segmentsD)*12 );
                this.pInvalidateUVs();
			}
			
			// Indices
			vidx = target.vertexOffset;
			fidx = 0;
			
			// half cube dimensions
			hw = this._width/2;
			hh = this._height/2;
			hd = this._depth/2;
			
			// Segment dimensions
			dw = this._width/this._segmentsW;
			dh = this._height/this._segmentsH;
			dd = this._depth/this._segmentsD;
			
			for (i = 0; i <= this._segmentsW; i++) {
				outer_pos = -hw + i*dw;
				
				for (j = 0; j <= this._segmentsH; j++) {
					// front
					data[vidx++] = outer_pos;
					data[vidx++] = -hh + j*dh;
					data[vidx++] = -hd;
					data[vidx++] = 0;
					data[vidx++] = 0;
					data[vidx++] = -1;
					data[vidx++] = 1;
					data[vidx++] = 0;
					data[vidx++] = 0;
					vidx += skip;
					
					// back
					data[vidx++] = outer_pos;
					data[vidx++] = -hh + j*dh;
					data[vidx++] = hd;
					data[vidx++] = 0;
					data[vidx++] = 0;
					data[vidx++] = 1;
					data[vidx++] = -1;
					data[vidx++] = 0;
					data[vidx++] = 0;
					vidx += skip;
					
					if (i && j) {
						tl = 2*((i - 1)*(this._segmentsH + 1) + (j - 1));
						tr = 2*(i*(this._segmentsH + 1) + (j - 1));
						bl = tl + 2;
						br = tr + 2;
						
						indices[fidx++] = tl;
						indices[fidx++] = bl;
						indices[fidx++] = br;
						indices[fidx++] = tl;
						indices[fidx++] = br;
						indices[fidx++] = tr;
						indices[fidx++] = tr + 1;
						indices[fidx++] = br + 1;
						indices[fidx++] = bl + 1;
						indices[fidx++] = tr + 1;
						indices[fidx++] = bl + 1;
						indices[fidx++] = tl + 1;
					}
				}
			}
			
			inc += 2*(this._segmentsW + 1)*(this._segmentsH + 1);
			
			for (i = 0; i <= this._segmentsW; i++) {
				outer_pos = -hw + i*dw;
				
				for (j = 0; j <= this._segmentsD; j++) {
					// top
					data[vidx++] = outer_pos;
					data[vidx++] = hh;
					data[vidx++] = -hd + j*dd;
					data[vidx++] = 0;
					data[vidx++] = 1;
					data[vidx++] = 0;
					data[vidx++] = 1;
					data[vidx++] = 0;
					data[vidx++] = 0;
					vidx += skip;
					
					// bottom
					data[vidx++] = outer_pos;
					data[vidx++] = -hh;
					data[vidx++] = -hd + j*dd;
					data[vidx++] = 0;
					data[vidx++] = -1;
					data[vidx++] = 0;
					data[vidx++] = 1;
					data[vidx++] = 0;
					data[vidx++] = 0;
					vidx += skip;
					
					if (i && j) {
						tl = inc + 2*((i - 1)*(this._segmentsD + 1) + (j - 1));
						tr = inc + 2*(i*(this._segmentsD + 1) + (j - 1));
						bl = tl + 2;
						br = tr + 2;
						
						indices[fidx++] = tl;
						indices[fidx++] = bl;
						indices[fidx++] = br;
						indices[fidx++] = tl;
						indices[fidx++] = br;
						indices[fidx++] = tr;
						indices[fidx++] = tr + 1;
						indices[fidx++] = br + 1;
						indices[fidx++] = bl + 1;
						indices[fidx++] = tr + 1;
						indices[fidx++] = bl + 1;
						indices[fidx++] = tl + 1;
					}
				}
			}
			
			inc += 2*(this._segmentsW + 1)*(this._segmentsD + 1);
			
			for (i = 0; i <= this._segmentsD; i++) {
				outer_pos = hd - i*dd;
				
				for (j = 0; j <= this._segmentsH; j++) {
					// left
					data[vidx++] = -hw;
					data[vidx++] = -hh + j*dh;
					data[vidx++] = outer_pos;
					data[vidx++] = -1;
					data[vidx++] = 0;
					data[vidx++] = 0;
					data[vidx++] = 0;
					data[vidx++] = 0;
					data[vidx++] = -1;
					vidx += skip;
					
					// right
					data[vidx++] = hw;
					data[vidx++] = -hh + j*dh;
					data[vidx++] = outer_pos;
					data[vidx++] = 1;
					data[vidx++] = 0;
					data[vidx++] = 0;
					data[vidx++] = 0;
					data[vidx++] = 0;
					data[vidx++] = 1;
					vidx += skip;
					
					if (i && j) {
						tl = inc + 2*((i - 1)*(this._segmentsH + 1) + (j - 1));
						tr = inc + 2*(i*(this._segmentsH + 1) + (j - 1));
						bl = tl + 2;
						br = tr + 2;
						
						indices[fidx++] = tl;
						indices[fidx++] = bl;
						indices[fidx++] = br;
						indices[fidx++] = tl;
						indices[fidx++] = br;
						indices[fidx++] = tr;
						indices[fidx++] = tr + 1;
						indices[fidx++] = br + 1;
						indices[fidx++] = bl + 1;
						indices[fidx++] = tr + 1;
						indices[fidx++] = bl + 1;
						indices[fidx++] = tl + 1;
					}
				}
			}
			
			target.updateData(data);
			target.updateIndexData(indices);
		}
		
		/**		 * @inheritDoc		 */
		override public function pBuildUVs(target:CompactSubGeometry):void
		{
			var i:Number, j:Number, uidx:Number;
			var data:Vector.<Number>;
			
			var u_tile_dim:Number, v_tile_dim:Number;
			var u_tile_step:Number, v_tile_step:Number;
			var tl0u:Number, tl0v:Number;
			var tl1u:Number, tl1v:Number;
			var du:Number, dv:Number;
			var stride:Number = target.UVStride;
			var numUvs:Number = ((this._segmentsW + 1)*(this._segmentsH + 1) +
				(this._segmentsW + 1)*(this._segmentsD + 1) +
				(this._segmentsH + 1)*(this._segmentsD + 1))*2*stride;
			var skip:Number = stride - 2;
			
			if (target.UVData && numUvs == target.UVData.length)
				data = target.UVData;
			else {
				data = VectorNumber.init( numUvs );
                this.pInvalidateGeometry();
			}
			
			if (this._tile6) {
				u_tile_dim = 1/3;
				u_tile_step = 1/3;

				v_tile_dim = 1/2;
				v_tile_step = 1/2;

			} else {
				u_tile_dim = 1;
				v_tile_dim = 1;

				u_tile_step = 0;
				v_tile_step = 0;

			}
			
			// Create planes two and two, the same way that they were
			// constructed in the buildGeometry() function. First calculate
			// the top-left UV coordinate for both planes, and then loop
			// over the points, calculating the UVs from these numbers.
			
			// When tile6 is true, the layout is as follows:
			//       .-----.-----.-----. (1,1)
			//       | Bot |  T  | Bak |
			//       |-----+-----+-----|
			//       |  L  |  F  |  R  |
			// (0,0)'-----'-----'-----'
			
			uidx = target.UVOffset;
			
			// FRONT / BACK
			tl0u = 1*u_tile_step;
			tl0v = 1*v_tile_step;
			tl1u = 2*u_tile_step;
			tl1v = 0*v_tile_step;
			du = u_tile_dim/this._segmentsW;
			dv = v_tile_dim/this._segmentsH;
			for (i = 0; i <= this._segmentsW; i++) {
				for (j = 0; j <= this._segmentsH; j++) {
					data[uidx++] = ( tl0u + i*du )*target.scaleU  ;
					data[uidx++] = ( tl0v + (v_tile_dim - j*dv))*target.scaleV;
					uidx += skip;
					data[uidx++] = ( tl1u + (u_tile_dim - i*du))*target.scaleU;
					data[uidx++] = ( tl1v + (v_tile_dim - j*dv))*target.scaleV;
					uidx += skip;
				}
			}
			
			// TOP / BOTTOM
			tl0u = 1*u_tile_step;
			tl0v = 0*v_tile_step;
			tl1u = 0*u_tile_step;
			tl1v = 0*v_tile_step;
			du = u_tile_dim/this._segmentsW;
			dv = v_tile_dim/this._segmentsD;
			for (i = 0; i <= this._segmentsW; i++) {
				for (j = 0; j <= this._segmentsD; j++) {
					data[uidx++] = ( tl0u + i*du)*target.scaleU;
					data[uidx++] = ( tl0v + (v_tile_dim - j*dv))*target.scaleV;
					uidx += skip;
					data[uidx++] = ( tl1u + i*du)*target.scaleU;
					data[uidx++] = ( tl1v + j*dv)*target.scaleV;
					uidx += skip;
				}
			}
			
			// LEFT / RIGHT
			tl0u = 0*u_tile_step;
			tl0v = 1*v_tile_step;
			tl1u = 2*u_tile_step;
			tl1v = 1*v_tile_step;
			du = u_tile_dim/this._segmentsD;
			dv = v_tile_dim/this._segmentsH;
			for (i = 0; i <= this._segmentsD; i++) {
				for (j = 0; j <= this._segmentsH; j++) {
					data[uidx++] = ( tl0u + i*du)*target.scaleU;;
					data[uidx++] = ( tl0v + (v_tile_dim - j*dv))*target.scaleV;
					uidx += skip;
					data[uidx++] = ( tl1u + (u_tile_dim - i*du))*target.scaleU;
					data[uidx++] = ( tl1v + (v_tile_dim - j*dv))*target.scaleV;
					uidx += skip;
				}
			}
			
			target.updateData(data);
		}
	}
}
