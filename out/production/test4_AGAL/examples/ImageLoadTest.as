
package examples
{
import away.core.net.IMGLoader;
import away.core.net.URLRequest;
import away.events.Event;

import randori.webkit.page.Window;

public class ImageLoadTest
{
    public function ImageLoadTest()
    {
        var urlRequest:URLRequest = new URLRequest( "assets/130909wall_big.png" );
        var imgLoader:IMGLoader = new IMGLoader();
        imgLoader.addEventListener( Event.COMPLETE, imageCompleteHandler, this );
        imgLoader.load( urlRequest );
    }

    private function imageCompleteHandler(e)
    {
        var imageLoader:IMGLoader = IMGLoader(e.target);
        Window.console.log('Load complete');
    }
}
}