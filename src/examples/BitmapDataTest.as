

package examples
{
import away.core.display.BitmapData;
import away.core.geom.Matrix;
import away.core.geom.Rectangle;
import away.core.net.IMGLoader;
import away.core.net.URLRequest;
import away.events.Event;
import away.events.IOErrorEvent;
import away.utils.ColorUtils;

import randori.webkit.html.HTMLCanvasElement;

import randori.webkit.page.Window;

/**
     * Created with IntelliJ IDEA.
     * User: pete
     * Date: 22/09/13
     * Time: 9:48 PM
     * To change this template use File | Settings | File Templates.
     */
    public class BitmapDataTest
    {
        private var bitmapData  : BitmapData;
        private var bitmapDataB : BitmapData;
        private var imgLoader   : IMGLoader;
        private var urlRequest  : URLRequest;
        
        public function BitmapDataTest()
        {
            var canvas : HTMLCanvasElement = Window.document.createElement('canvas') as HTMLCanvasElement;
            //var GL = canvas.getContext("experimental-webgl");

            var transparent : Boolean = true;
            var initcolour  : Number = 0xff00ffff;

            urlRequest = new URLRequest( "assets/130909wall_big.png");
            imgLoader  = new IMGLoader();
            imgLoader.load( urlRequest );
            imgLoader.addEventListener( Event.COMPLETE , imgLoaded , this );
            imgLoader.addEventListener( IOErrorEvent.IO_ERROR, imgLoadedError , this );

            //---------------------------------------
            // BitmapData Object - 1
            bitmapData = new BitmapData( 256 ,  256 , transparent , initcolour );
            Window.document.body.appendChild( bitmapData.canvas );

            //---------------------------------------
            // BitmapData Object - 2
            bitmapDataB = new BitmapData( 256 ,  256 , transparent , initcolour );
            bitmapDataB.canvas.style.position = 'absolute';
            bitmapDataB.canvas.style.left = '540px';
            Window.document.body.appendChild( bitmapDataB.canvas );

            //---------------------------------------
            // BitmapData - setPixel test
            Window.console['time']("bitmapdata"); // start setPixel operation benchmark ( TypeScript does not support Window.console.time - so hacking it in ) .

            bitmapDataB.lock();

            for (var i = 0; i < 10000; i++)
            {

                var x = Math.random() * bitmapDataB.width | 0; // |0 to truncate to Int32
                var y = Math.random() * bitmapDataB.height | 0;
                bitmapDataB.setPixel(x, y, Math.random() * 0xffFFFFFF ); // 255 opaque

            }

            bitmapDataB.unlock();
            Window.console['timeEnd']("bitmapdata"); // benchmark the setPixel operation

            var that:BitmapDataTest = this;
            Window.document.onmousedown = function( e ):void
            {
                that.onMouseDown( e );
            }
        }

        private function onMouseDown( e )
        {
    
            if ( bitmapData.width === 512 ) // Test to toggle resize of bitmapData
            {
    
                if ( imgLoader.loaded ) // If image is loaded copy that to the BitmapData object
                {
    
                    bitmapDataB.lock(); // Lock bitmap - speeds up setPixelOperations
    
    
                    //---------------------------------------
                    // Resize BitmapData
                    bitmapData.width  = 256;
                    bitmapData.height = 256;
    
                    //---------------------------------------
                    // copy loaded image to first BitmapData
    
                    var rect : Rectangle = new Rectangle( 0 , 0 , imgLoader.width , imgLoader.height );
                    bitmapData.drawImage( imgLoader.image , rect ,  rect );
    
                    //---------------------------------------
                    // copy image into second bitmap data ( and scale it up 2X )
                    rect.width = rect.width * 2;
                    rect.height = rect.height * 2;
    
                    bitmapDataB.copyPixels( bitmapData , bitmapData.rect , rect );
    
                    //---------------------------------------
                    // draw random pixels
    
                    for (var d = 0; d < 1000; d++)
                    {
    
                        var x = Math.random() * bitmapDataB.width | 0; // |0 to truncate to Int32
                        var y = Math.random() * bitmapDataB.height | 0;
                        bitmapDataB.setPixel(x, y, Math.random() * 0xFFFFFFFF ); // 255 opaque
    
                    }
    
                    bitmapDataB.unlock(); // Unlock bitmapdata
    
                }
                else
                {
    
                    //---------------------------------------
                    // image is not loaded - fill bitmapdata with red
                    bitmapData.width  = 256;
                    bitmapData.height = 256;
                    bitmapData.fillRect( bitmapData.rect , 0xffff0000 );
                }
    
            }
            else
            {
    
                //---------------------------------------
                // resize bitmapdata;
    
                bitmapData.lock();
    
                bitmapData.width  = 512;
                bitmapData.height = 512;
                bitmapData.fillRect( bitmapData.rect , 0xffff0000 ); // fill it RED
    
                for (var d = 0; d < 1000; d++)
                {
    
                    var x = Math.random() * bitmapData.width | 0; // |0 to truncate to Int32
                    var y = Math.random() * bitmapData.height | 0;
                    bitmapData.setPixel(x, y, Math.random() * 0xFFFFFFFF );
    
                }
    
                bitmapData.unlock();
                //---------------------------------------
                // copy bitmapdata
    
                var targetRect          = bitmapDataB.rect.clone();
                targetRect.width    = targetRect.width / 2;
                targetRect.height   = targetRect.height / 2;
    
                bitmapDataB.copyPixels( bitmapData , bitmapDataB.rect ,  targetRect ); // copy first bitmapdata object into the second one
    
    
    
            }
    
            var m : Matrix = new Matrix(.5, .08 , .08 ,.5 , imgLoader.width / 2 , imgLoader.height / 2);
            bitmapData.draw( bitmapData , m );
    
            bitmapData.setPixel32(0, 0, 0xccff0000 ) ;
            bitmapData.setPixel32(1, 0, 0xcc00ff00 ) ;
            bitmapData.setPixel32(2, 0, 0xcc0000ff ) ;
    
            bitmapDataB.draw( bitmapData , m );
    
            Window.console.log( 'GetPixel 0,0: ' , ColorUtils.ARGBToHexString( ColorUtils.float32ColorToARGB( bitmapData.getPixel( 0 , 0 ) ) ) );
            Window.console.log( 'GetPixel 1,0: ' , ColorUtils.ARGBToHexString( ColorUtils.float32ColorToARGB( bitmapData.getPixel( 1 , 0 ) ) ) );
            Window.console.log( 'GetPixel 2,0: ' , ColorUtils.ARGBToHexString( ColorUtils.float32ColorToARGB( bitmapData.getPixel( 2 , 0 ) ) ) );
    
    
    
        }
    
        private function imgLoadedError( e : away.events.IOErrorEvent )
        {
    
            Window.console.log( 'error');
    
        }
    
        private function imgLoaded( e : away.events.Event )
        {
    
            bitmapData.drawImage( imgLoader.image , new Rectangle( 0 , 0 , imgLoader.width , imgLoader.height ) ,new Rectangle( 0 , 0 , imgLoader.width  / 2, imgLoader.height / 2 ));
    
            var m : Matrix = new Matrix(.5, .08 , .08 ,.5 , imgLoader.width / 2 , imgLoader.height / 2);
            bitmapData.draw( bitmapData , m );
    
        }
    }
}