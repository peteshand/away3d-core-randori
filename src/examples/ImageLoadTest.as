package examples {
import away.events.Event;
import away.net.IMGLoader;
import away.net.URLRequest;

import randori.webkit.page.Window;

/**
 * Created with IntelliJ IDEA.
 * User: pete
 * Date: 1/09/13
 * Time: 12:34 PM
 * To change this template use File | Settings | File Templates.
 */
public class ImageLoadTest
{
    public function ImageLoadTest()
    {
        var urlRequest:URLRequest = new URLRequest( "assets/130909wall_big.png" );
        var imgLoader:IMGLoader = new IMGLoader();
        imgLoader.addEventListener( Event.COMPLETE, this.imageCompleteHandler, this );
        imgLoader.load( urlRequest );
    }

    private function imageCompleteHandler(e)
    {
        var imageLoader:IMGLoader = IMGLoader(e.target);
        Window.console.log('Load complete');
    }
}
}