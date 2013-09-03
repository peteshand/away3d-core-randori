/** * ... * @author Gary Paluk - http://www.plugin.io */

///<reference path="../_definitions.ts"/>


package away.geom
{
	public class Rectangle
	{
		public var x:Number;
		public var y:Number;
		public var width:Number;
		public var height:Number;
		
		public function Rectangle(x:Number = 0, y:Number = 0, width:Number = 0, height:Number = 0):void
		{
			this.x = x;
			this.y = y;
			this.width = width;
			this.height = height;
		}
		
		public function get left():Number
		{
			return x;
		}
		
		public function get right():Number
		{
			return x + width;
		}
		
		public function get top():Number
		{
			return y;
		}
		
		public function get bottom():Number
		{
			return y + height;
		}
		
		public function get topLeft():Point
		{
			return new Point( x, y );
		}
		
		public function get bottomRight():Point
		{
			return new Point( x + width, y + height );
		}

        public function clone():Rectangle
        {

            return new Rectangle( x , y , width , height );

        }
	}
}