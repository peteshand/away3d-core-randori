/** * ... * @author Gary Paluk - http://www.plugin.io */
 
///<reference path="../_definitions.ts" />

package away.display
{
	import away.events.EventDispatcher;
	import away.errors.DocumentError;
	import away.events.Event;
	import away.errors.ArgumentError;
	import away.geom.Rectangle;
	import randori.webkit.page.Window;
	import randori.webkit.html.HTMLCanvasElement;
	
	public class Stage extends EventDispatcher
	{
		
		private static var STAGE3D_MAX_QUANTITY:Number = 8;
		public var stage3Ds:Vector.<Stage3D>;
		
		private var _stageHeight:Number;
		private var _stageWidth:Number;
		
		public function Stage(width:Number = 640, height:Number = 480):void
		{
			super();

            // Move ( to Sprite ) / possibly remove:
			if( !Window.document )
			{
				throw new DocumentError( "A root document object does not exist." );
			}
			
			this.initStage3DObjects();
			this.resize( width, height );

		}
		
		public function resize(width:Number, height:Number):void
		{
			this._stageHeight = height;
			this._stageWidth = width;

            var s3d : Stage3D;

			for( var i: Number = 0; i <  Stage.STAGE3D_MAX_QUANTITY; ++i )
			{

                s3d         = this.stage3Ds[ i ];
                s3d.width   = width;
                s3d.height  = height;
                s3d.x       = 0;
                s3d.y       = 0;

				//away.utils.CSS.setCanvasSize( this.stage3Ds[ i ].canvas, width, height );
				//away.utils.CSS.setCanvasPosition( this.stage3Ds[ i ].canvas, 0, 0, true );
			}
			this.dispatchEvent( new Event( Event.RESIZE ) );
		}
		
		public function getStage3DAt(index:Number):Stage3D
		{
			if( 0 <= index && index < Stage.STAGE3D_MAX_QUANTITY )
			{
				return this.stage3Ds[ index ];
			}
			throw new away.errors.ArgumentError( "Index is out of bounds [0.." + Stage.STAGE3D_MAX_QUANTITY + "]" );
		}
		
		public function initStage3DObjects():void
		{
			this.stage3Ds = new <Stage3D>[];

			for( var i: Number = 0; i < Stage.STAGE3D_MAX_QUANTITY; ++i )
			{

				var canvas  : HTMLCanvasElement     = this.createHTMLCanvasElement();
                var stage3D : Stage3D  = new Stage3D( canvas );
                    stage3D.addEventListener( Event.CONTEXT3D_CREATE , onContextCreated , this );

				this.stage3Ds.push( stage3D );

			}

		}

        private function onContextCreated(e:Event):void
        {

            var stage3D : Stage3D = (e.target as Stage3D);
            this.addChildHTMLElement( stage3D.canvas );
        }

		private function createHTMLCanvasElement():HTMLCanvasElement
		{
			return HTMLCanvasElement(Window.document.createElement("canvas") );
		}
		
		private function addChildHTMLElement(canvas:HTMLCanvasElement):void
		{
			Window.document.body.appendChild( canvas );
		}

        public function get stageWidth():Number
        {

            return this._stageWidth;

        }

        public function get stageHeight():Number
        {

            return this._stageHeight;

        }

        public function get rect():Rectangle
        {

            return new Rectangle( 0 ,0 , this._stageWidth , this._stageHeight );

        }
	}
}