/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package away.core.geom
{
	public class Rectangle
	{
		public var x:Number = 0;
		public var y:Number = 0;
		public var width:Number = 0;
		public var height:Number = 0;
		
		public function Rectangle(x:Number = 0, y:Number = 0, width:Number = 0, height:Number = 0):void
		{
			x = x || 0;
			y = y || 0;
			width = width || 0;
			height = height || 0;

			this.x = x;
			this.y = y;
			this.width = width;
			this.height = height;
		}
		
		public function get left():Number
		{
			return this.x;
		}
		
		public function get right():Number
		{
			return this.x + this.width;
		}
		
		public function get top():Number
		{
			return this.y;
		}
		
		public function get bottom():Number
		{
			return this.y + this.height;
		}
		
		public function get topLeft():Point
		{
			return new Point( this.x, this.y );
		}
		
		public function get bottomRight():Point
		{
			return new Point( this.x + this.width, this.y + this.height );
		}

        public function clone():Rectangle
        {

            return new Rectangle( this.x , this.y , this.width , this.height );

        }
	}
}