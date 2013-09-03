///<reference path="../../_definitions.ts"/>

package away.base.data
{
	
	/**
	public class Vertex
	{
		private var _x:Number;
		private var _y:Number;
		private var _z:Number;
		private var _index:Number;
		
		/**
		public function Vertex(x:Number = 0, y:Number = 0, z:Number = 0, index:Number = 0):void
		{
			this._x = x;
            this._y = y;
            this._z = z;
            this._index = index;
		}
		
		/**
		public function set index(ind:Number):void
		{
            this._index = ind;
		}
		
		public function get index():Number
		{
			return _index;
		}
		
		/**
		public function get x():Number
		{
			return _x;
		}
		
		public function set x(value:Number):void
		{
            this._x = value;
		}
		
		/**
		public function get y():Number
		{
			return _y;
		}
		
		public function set y(value:Number):void
		{
            this._y = value;
		}
		
		/**
		public function get z():Number
		{
			return _z;
		}
		
		public function set z(value:Number):void
		{
            this._z = value;
		}
		
		/**
		public function clone():Vertex
		{
			return new Vertex(_x, _y, _z);
		}
		
		/**
		public function toString():String
		{
			return _x + "," + _y + "," + _z;
		}
	
	}
}