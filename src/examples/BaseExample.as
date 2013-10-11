

package examples
{
import away.containers.View3D;
import away.utils.RequestAnimationFrame;

import randori.webkit.page.Window;

/**
     * Created with IntelliJ IDEA.
     * User: pete
     * Date: 27/09/13
     * Time: 12:10 AM
     * To change this template use File | Settings | File Templates.
     */
    public class BaseExample
    {
        protected var view:View3D;
        public var index:int;
        private var requestAnimationFrame:RequestAnimationFrame;

        public function BaseExample(_index:int)
        {
            this.index = _index;
            requestAnimationFrame = new RequestAnimationFrame(tick, this);

            var that:BaseExample = this;
            Window.onresize = function():void { that.resize(); };
            resize();
        }

        public function Show():void
        {
            if (view) view.canvas.style.setProperty('visibility', 'visible');
            requestAnimationFrame.start();
        }

        public function Hide():void
        {
            if (view) view.canvas.style.setProperty('visibility', 'hidden');
            requestAnimationFrame.stop();
        }

        protected function resize():void
        {

        }

        protected function tick(dt:Number):void
        {

        }
    }
}