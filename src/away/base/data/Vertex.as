/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package away.base.data
{
	
	/**	 * Vertex value object.	 */
	public class Vertex
	{
		private var _x:Number = 0;
		private var _y:Number = 0;
		private var _z:Number = 0;
		private var _index:Number = 0;
		
		/**		 * Creates a new <code>Vertex</code> value object.		 *		 * @param    x            [optional]    The x value. Defaults to 0.		 * @param    y            [optional]    The y value. Defaults to 0.		 * @param    z            [optional]    The z value. Defaults to 0.		 * @param    index        [optional]    The index value. Defaults is NaN.		 */
		public function Vertex(x:Number = 0, y:Number = 0, z:Number = 0, index:Number = 0):void
		{
			x = x || 0;
			y = y || 0;
			z = z || 0;
			index = index || 0;

			this._x = x;
            this._y = y;
            this._z = z;
            this._index = index;
		}
		
		/**		 * To define/store the index of value object		 * @param    ind        The index		 */
		public function set index(ind:Number):void
		{
            this._index = ind;
		}
		
		public function get index():Number
		{
			return this._index;
		}
		
		/**		 * To define/store the x value of the value object		 * @param    value        The x value		 */
		public function get x():Number
		{
			return this._x;
		}
		
		public function set x(value:Number):void
		{
            this._x = value;
		}
		
		/**		 * To define/store the y value of the value object		 * @param    value        The y value		 */
		public function get y():Number
		{
			return this._y;
		}
		
		public function set y(value:Number):void
		{
            this._y = value;
		}
		
		/**		 * To define/store the z value of the value object		 * @param    value        The z value		 */
		public function get z():Number
		{
			return this._z;
		}
		
		public function set z(value:Number):void
		{
            this._z = value;
		}
		
		/**		 * returns a new Vertex value Object		 */
		public function clone():Vertex
		{
			return new Vertex(this._x, this._y, this._z);
		}
		
		/**		 * returns the value object as a string for trace/debug purpose		 */
		public function toString():String
		{
			return this._x + "," + this._y + "," + this._z;
		}
	
	}
}
