
///<reference path="../_definitions.ts" />

package away.primitives
{
	import away.geom.Vector3D;

	/**
	public class WireframeSphere extends WireframePrimitiveBase
	{
		private var _segmentsW:Number;
		private var _segmentsH:Number;
		private var _radius:Number;
		
		/**
		public function WireframeSphere(radius:Number = 50, segmentsW:Number = 16, segmentsH:Number = 12, color:Number = 0xFFFFFF, thickness:Number = 1):void
		{
			super(color, thickness);
			
			this._radius = radius;
            this._segmentsW = segmentsW;
            this._segmentsH = segmentsH;
		}
		
		/**
		override public function pBuildGeometry():void
		{
			var vertices:Vector.<Number> = new Vector.<Number>();
			var v0:Vector3D = new Vector3D();
			var v1:Vector3D = new Vector3D();
			var i:Number, j:Number;
			var numVerts:Number = 0;
			var index:Number = 0;
			
			for (j = 0; j <= _segmentsH; ++j) {
				var horangle:Number = Math.PI*j/_segmentsH;
				var z:Number = -_radius*Math.cos(horangle);
				var ringradius:Number = _radius*Math.sin(horangle);
				
				for (i = 0; i <= _segmentsW; ++i) {
					var verangle:Number = 2*Math.PI*i/_segmentsW;
					var x:Number = ringradius*Math.cos(verangle);
					var y:Number = ringradius*Math.sin(verangle);
					vertices[numVerts++] = x;
					vertices[numVerts++] = -z;
					vertices[numVerts++] = y;
				}
			}
			
			for (j = 1; j <= _segmentsH; ++j)
            {
				for (i = 1; i <= _segmentsW; ++i)
                {
					var a:Number = ((_segmentsW + 1)*j + i)*3;
					var b:Number = ((_segmentsW + 1)*j + i - 1)*3;
					var c:Number = ((_segmentsW + 1)*(j - 1) + i - 1)*3;
					var d:Number = ((_segmentsW + 1)*(j - 1) + i)*3;
					
					if (j == _segmentsH)
                    {
						v0.x = vertices[c];
						v0.y = vertices[c + 1];
						v0.z = vertices[c + 2];
						v1.x = vertices[d];
						v1.y = vertices[d + 1];
						v1.z = vertices[d + 2];
                        pUpdateOrAddSegment(index++, v0, v1);
						v0.x = vertices[a];
						v0.y = vertices[a + 1];
						v0.z = vertices[a + 2];
                        pUpdateOrAddSegment(index++, v0, v1);
					}
                    else if (j == 1)
                    {
						v1.x = vertices[b];
						v1.y = vertices[b + 1];
						v1.z = vertices[b + 2];
						v0.x = vertices[c];
						v0.y = vertices[c + 1];
						v0.z = vertices[c + 2];
                        pUpdateOrAddSegment(index++, v0, v1);
					}
                    else
                    {
						v1.x = vertices[b];
						v1.y = vertices[b + 1];
						v1.z = vertices[b + 2];
						v0.x = vertices[c];
						v0.y = vertices[c + 1];
						v0.z = vertices[c + 2];
                        pUpdateOrAddSegment(index++, v0, v1);
						v1.x = vertices[d];
						v1.y = vertices[d + 1];
						v1.z = vertices[d + 2];
                        pUpdateOrAddSegment(index++, v0, v1);
					}
				}
			}
		}
	}
}