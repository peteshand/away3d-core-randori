/** * ... * @author Gary Paluk - http://www.plugin.io */

///<reference path="../_definitions.ts" />

package away.display
{
	import away.events.EventDispatcher;
	import away.display3D.Context3D;
	import away.display3D.AGLSLContext3D;
	import away.events.Event;
	import away.utils.CSS;
	import randori.webkit.html.HTMLCanvasElement;
	
	public class Stage3D extends EventDispatcher
	{
		private var _context3D:Context3D;
		private var _canvas:HTMLCanvasElement;
        private var _width:Number;
        private var _height:Number;
        private var _x:Number;
        private var _y:Number;
		
		public function Stage3D(canvas:HTMLCanvasElement):void
		{
			super();
			this._canvas = canvas;
		}
		
		public function requestContext(aglslContext:Boolean = false):void
		{
			try
			{
				if( aglslContext )
				{
					this._context3D = new AGLSLContext3D( this._canvas );
				}
				else
				{
					this._context3D = new Context3D( this._canvas );
				}

			}
			catch( e )
			{
                this.dispatchEvent( new Event( Event.ERROR ) );
			}
			
			if( this._context3D )
			{
				this.dispatchEvent( new Event( Event.CONTEXT3D_CREATE ) );
			}
		}

        public function set width(v:Number):void
        {
            this._width = v;
            CSS.setCanvasWidth( this._canvas, v );
        }

        public function get width():Number
        {
            return this._width;
        }

        public function set height(v:Number):void
        {
            this._height = v;
            CSS.setCanvasHeight( this._canvas, v );
        }

        public function get height():Number
        {
            return this._height;
        }

        public function set x(v:Number):void
        {
            this._x = v;
            CSS.setCanvasX( this._canvas, v );
        }

        public function get x():Number
        {
            return this._x;
        }

        public function set y(v:Number):void
        {
            this._y = v;
            CSS.setCanvasY( this._canvas, v );
        }

        public function get y():Number
        {
            return this._y;
        }

        public function set visible(v:Boolean):void
        {
            CSS.setCanvasVisibility( this._canvas, v );
        }

        public function get visible():Boolean
        {
            return CSS.getCanvasVisibility( this._canvas );
        }

		public function get canvas():HTMLCanvasElement
		{
			return this._canvas;
		}
		
		public function get context3D():Context3D
		{
			return this._context3D;
		}
		
	}
}