

package examples
{
import away.core.display.BitmapData;
import away.core.display3D.Texture;
import away.core.geom.Rectangle;
import away.core.net.IMGLoader;
import away.core.net.URLRequest;
import away.events.Event;
    import away.textures.BitmapTexture;
    import away.utils.Debug;

import randori.webkit.html.HTMLCanvasElement;
import randori.webkit.page.Window;

public class BitmapTextureTest
    {
        private var mipLoader:IMGLoader;
        private var bitmapData:BitmapData;
        private var target:BitmapTexture;
        private var texture:Texture;

        public function BitmapTextureTest()
        {
            var canvas:HTMLCanvasElement = Window.document.createElement('canvas') as HTMLCanvasElement;
            var GL = canvas.getContext("experimental-webgl");

            var mipUrlRequest = new URLRequest( 'assets/1024x1024.png');
            mipLoader = new IMGLoader();
            mipLoader.load( mipUrlRequest );
            mipLoader.addEventListener( Event.COMPLETE , mipImgLoaded , this );
        }

        private function mipImgLoaded( e )
        {

            var loader : IMGLoader = e.target as IMGLoader;
            var rect : Rectangle = new Rectangle(0, 0, mipLoader.width, mipLoader.height);

            bitmapData = new BitmapData(loader.width, loader.height);
            bitmapData.drawImage(mipLoader.image, rect,  rect);

            //texture = new away.display3D.Texture( loader.width , loader.height );
            target = new BitmapTexture( bitmapData , true );//new HTMLImageElementTexture( loader.image , false );

            Debug.log('bitmapData', bitmapData );
            //Debug.log('texture', texture );
            Debug.log('target', target );
        }
    }
}