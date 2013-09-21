package test
{
import randori.webkit.page.Window;

/**
     * Created with IntelliJ IDEA.
     * User: pete
     * Date: 19/09/13
     * Time: 7:07 PM
     * To change this template use File | Settings | File Templates.
     */
    public class DoubleTest
    {
        private var _test:String = "";
        private var _test2:String = "";

        public function DoubleTest()
        {
            test = test2 = 'test123';

            Window.console.log(_test);
            Window.console.log(_test2);
        }

        public function set test2(value:String):void
        {
            _test2 = value;
        }

        public function set test(value:String):void {
            _test = value;
        }
    }
}