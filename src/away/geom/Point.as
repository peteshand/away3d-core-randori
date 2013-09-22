/** * ... * @author Gary Paluk - http://www.plugin.io */
 
package away.geom
{
	public class Point
	{
		public var x:Number;
		public var y:Number;
		
		public function Point(x:Number = 0, y:Number = 0):void
		{
			x = x || 0;
			y = y || 0;

			this.x = x;
			this.y = y;
		}
		
	}
}