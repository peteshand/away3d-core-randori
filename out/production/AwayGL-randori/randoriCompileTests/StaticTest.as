package randoriCompileTests
{
import away.events.ShadingMethodEvent;

import randori.webkit.page.Window;

/**
     * Created with IntelliJ IDEA.
     * User: pete
     * Date: 21/09/13
     * Time: 8:36 AM
     * To change this template use File | Settings | File Templates.
     */
    public class StaticTest
    {
        public function StaticTest()
        {
            addCallback(Callback);
        }

        private function Callback():String
        {
            return 'test123';
        }

        public function addCallback(callback:Function):void
        {
            Window.console.log(callback());
        }
    }
}