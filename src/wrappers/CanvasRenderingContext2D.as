package wrappers
{
import randori.webkit.html.ImageData;
import randori.webkit.html.canvas.CanvasRenderingContext2D;

    /**
     * Created with IntelliJ IDEA.
     * User: pete
     * Date: 22/09/13
     * Time: 10:28 PM
     * To change this template use File | Settings | File Templates.
     */
    public class CanvasRenderingContext2D extends randori.webkit.html.canvas.CanvasRenderingContext2D
    {
        public function CanvasRenderingContext2D()
        {

        }

        [JavaScriptMethod(name="putImageData")]
        public function putImageData2(imagedata:ImageData,dx:Number,dy:Number,dirtyX:Number=0,dirtyY:Number = 0,dirtyWidth:Number = 0,dirtyHeight:Number = 0):void
        {

        }
    }
}