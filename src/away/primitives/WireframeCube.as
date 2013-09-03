///<reference path="../_definitions.ts"/>

package away.primitives
{
	import away.geom.Vector3D;
	//import flash.geom.Vector3D;
	
	/**
	public class WireframeCube extends WireframePrimitiveBase
	{
		private var _width:Number;
		private var _height:Number;
		private var _depth:Number;
		
		/**
		public function WireframeCube(width:Number = 100, height:Number = 100, depth:Number = 100, color:Number = 0xFFFFFF, thickness:Number = 1):void
		{
			super(color, thickness);
			
			this._width = width;
            this._height = height;
            this._depth = depth;
		}
		
		/**
		public function get width():Number
		{
			return _width;
		}
		
		public function set width(value:Number):void
		{
            this._width = value;
            this.pInvalidateGeometry();
		}
		
		/**
		public function get height():Number
		{
			return _height;
		}
		
		public function set height(value:Number):void
		{
			if (value <= 0)
				throw new Error("Value needs to be greater than 0");
            this._height = value;
            this.pInvalidateGeometry();
		}
		
		/**
		public function get depth():Number
		{
			return _depth;
		}
		
		public function set depth(value:Number):void
		{
            this._depth = value;
            this.pInvalidateGeometry();
		}
		
		/**
		override public function pBuildGeometry():void
		{
			var v0:Vector3D = new Vector3D();
			var v1:Vector3D = new Vector3D();
			var hw:Number = _width*.5;
			var hh:Number = _height*.5;
			var hd:Number = _depth*.5;
			
			v0.x = -hw;
			v0.y = hh;
			v0.z = -hd;
			v1.x = -hw;
			v1.y = -hh;
			v1.z = -hd;
			
			pUpdateOrAddSegment(0, v0, v1);
			v0.z = hd;
			v1.z = hd;
            pUpdateOrAddSegment(1, v0, v1);
			v0.x = hw;
			v1.x = hw;
            pUpdateOrAddSegment(2, v0, v1);
			v0.z = -hd;
			v1.z = -hd;
            pUpdateOrAddSegment(3, v0, v1);
			
			v0.x = -hw;
			v0.y = -hh;
			v0.z = -hd;
			v1.x = hw;
			v1.y = -hh;
			v1.z = -hd;
            pUpdateOrAddSegment(4, v0, v1);
			v0.y = hh;
			v1.y = hh;
            pUpdateOrAddSegment(5, v0, v1);
			v0.z = hd;
			v1.z = hd;
            pUpdateOrAddSegment(6, v0, v1);
			v0.y = -hh;
			v1.y = -hh;
            pUpdateOrAddSegment(7, v0, v1);
			
			v0.x = -hw;
			v0.y = -hh;
			v0.z = -hd;
			v1.x = -hw;
			v1.y = -hh;
			v1.z = hd;
            pUpdateOrAddSegment(8, v0, v1);
			v0.y = hh;
			v1.y = hh;
            pUpdateOrAddSegment(9, v0, v1);
			v0.x = hw;
			v1.x = hw;
            pUpdateOrAddSegment(10, v0, v1);
			v0.y = -hh;
			v1.y = -hh;
            pUpdateOrAddSegment(11, v0, v1);
		}
	}
}