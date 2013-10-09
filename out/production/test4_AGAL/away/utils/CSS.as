/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package away.utils
{
	import randori.webkit.html.HTMLCanvasElement;
	public class CSS
	{
        public static function setCanvasSize(canvas:HTMLCanvasElement, width:Number, height:Number):void
        {
            canvas.style.width = width + "px";
            canvas.style.height = height + "px";
            canvas.width = width;
            canvas.height = height;
        }

        public static function setCanvasWidth(canvas:HTMLCanvasElement, width:Number):void
        {
            canvas.style.width = width + "px";
            canvas.width = width;
        }

        public static function setCanvasHeight(canvas:HTMLCanvasElement, height:Number):void
        {
            canvas.style.height = height + "px";
            canvas.height = height;
        }

        public static function setCanvasX(canvas:HTMLCanvasElement, x:Number):void
        {
            canvas.style.position = 'absolute';
            canvas.style.left = x + "px";
        }

        public static function setCanvasY(canvas:HTMLCanvasElement, y:Number):void
        {
            canvas.style.position = 'absolute';
            canvas.style.top = y + "px";
        }

        public static function getCanvasVisibility(canvas:HTMLCanvasElement):Boolean
        {
            return canvas.style.visibility == 'visible';
        }

        public static function setCanvasVisibility(canvas:HTMLCanvasElement, visible:Boolean):void
		{
			if( visible )
			{
				canvas.style.visibility = 'visible';
			}
			else
			{
				canvas.style.visibility = 'hidden';
			}
		}
		
		public static function setCanvasAlpha(canvas:HTMLCanvasElement, alpha:Number):void
		{
			var context = canvas.getContext( "2d" );
			context.globalAlpha = alpha;
		}
		
		public static function setCanvasPosition(canvas:HTMLCanvasElement, x:Number, y:Number, absolute:Boolean = false):void
		{
			absolute = absolute || false;

			if( absolute )
			{
				canvas.style.position = "absolute";
			}
			else
			{
				canvas.style.position = "relative";
			}
			
			canvas.style.left = x + "px";
			canvas.style.top = y + "px";
		}
	}
}