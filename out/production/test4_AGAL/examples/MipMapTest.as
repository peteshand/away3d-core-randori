
package examples
{
import away.core.display.BitmapData;
import away.core.geom.Matrix;
import away.core.geom.Rectangle;
import away.core.net.IMGLoader;
import away.core.net.URLRequest;
import away.events.Event;
import away.utils.TextureUtils;

import randori.webkit.page.Window;

/**
     * Created with IntelliJ IDEA.
     * User: pete
     * Date: 23/09/13
     * Time: 7:35 AM
     * To change this template use File | Settings | File Templates.
     */
    public class MipMapTest
    {
        private var mipLoader       : IMGLoader;
        private var sourceBitmap    : BitmapData;
        private var mipMap          : BitmapData;
        private var _rect           : Rectangle = new Rectangle();
        private var _matrix         : Matrix = new Matrix();
        private var w               : Number;
        private var h               : Number;
            
        public function MipMapTest()
        {
            //---------------------------------------
            // Load a PNG

            var mipUrlRequest = new URLRequest( 'assets/1024x1024.png');
            mipLoader  = new IMGLoader();
            mipLoader.load( mipUrlRequest );
            mipLoader.addEventListener( Event.COMPLETE , mipImgLoaded , this );

            var that:MipMapTest = this;
            Window.document.onmousedown = function(e):void
            {
                that.onMouseDown(e);
            }
        }

        private function mipImgLoaded( e )
        {
            Window.alert('Each click will generate a level of MipMap');

            var loader : IMGLoader = e.target as IMGLoader;

            sourceBitmap = new BitmapData(1024, 1024, true, 0xff0000);
            sourceBitmap.drawImage(loader.image, sourceBitmap.rect, sourceBitmap.rect);
            sourceBitmap.canvas.style.position  = 'absolute';
            sourceBitmap.canvas.style.left      = '0px';
            sourceBitmap.canvas.style.top       = '1030px';

            //Window.document.body.appendChild( sourceBitmap.canvas );

            mipMap = new BitmapData( 1024 , 1024 , true , 0xff0000 );
            mipMap.canvas.style.position  = 'absolute';
            mipMap.canvas.style.left      = '0px';
            mipMap.canvas.style.top       = '0px';

            Window.document.body.appendChild( mipMap.canvas );

            _rect.width    = sourceBitmap.width;
            _rect.height   = sourceBitmap.height;

            w = sourceBitmap.width;
            h = sourceBitmap.height;

        }

        private function onMouseDown( e )
        {

            generateMipMap( sourceBitmap ,  mipMap );

        }




        public function generateMipMap( source : BitmapData , mipmap : BitmapData = null, alpha:Boolean = false, side:Number = -1)
        {
            var c : Number = w;
            var i:Number;

            Window.console['time']('MipMap' + c);

            if ( (w >= 1 ) || (h >= 1) )
            {
                if (alpha){
                    mipmap.fillRect(_rect, 0);
                }

                _matrix.a = _rect.width / source.width;
                _matrix.d = _rect.height / source.height;

                mipmap.width = w;
                mipmap.height= h;
                mipmap.copyPixels(source, source.rect, new Rectangle(0 ,0 ,w ,h));

                w >>= 1;
                h >>= 1;

                _rect.width = w > 1? w : 1;
                _rect.height = h > 1? h : 1;
            }

            Window.console.log( 'TextureUtils.isBitmapDataValid: ' , TextureUtils.isBitmapDataValid( mipmap ));
            Window.console['timeEnd']('MipMap' + c);
        }
    }
}