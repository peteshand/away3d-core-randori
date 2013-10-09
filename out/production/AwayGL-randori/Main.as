package
{
    import away.core.geom.Point;

import examples.AWDSuzanne;
import examples.AWDSuzanneLights;

import examples.PlaneTest;
import examples.ViewPlane;

//import examples.AWDSuzanne;

    import examples.BaseExample;
    import examples.CubeDemo;
    //import examples.PlaneTest;

    import randori.webkit.html.HTMLButtonElement;
    import randori.webkit.html.HTMLTextAreaElement;

    import randori.webkit.page.Window;

    public class Main
    {
        private var exampleClasses:Vector.<Class> = new Vector.<Class>();
        private var exampleVec:Vector.<BaseExample> = new Vector.<BaseExample>();
        public var _exampleIndex:int = -1;

        private var previousBtn:HTMLButtonElement;
        private var nextBtn:HTMLButtonElement;

        public function main()
        {
            exampleClasses.push(PlaneTest);
            exampleClasses.push(ViewPlane);
            exampleClasses.push(CubeDemo);
            exampleClasses.push(AWDSuzanne);
            exampleClasses.push(AWDSuzanneLights);

            var previousBtn:HTMLButtonElement = createBtn("Previous");
            var nextBtn:HTMLButtonElement = createBtn("Next", new Point(80,0));

            var that:Main = this;
            previousBtn.onclick = function(e):void { that.exampleIndex--};
            nextBtn.onclick = function(e):void { that.exampleIndex++};
            exampleIndex = 0;

            //var planeMaterialTest:PlaneMaterialTest = new PlaneMaterialTest();
            //var lightTorus:LightTorus = new LightTorus();
            //var agalaConoileTest:AGALCompileTest = new AGALCompileTest();

            //Window.console.log(ITestInterface(new TestInterface()));

            //var planeTest:PlaneTest = new PlaneTest();

            //var objChiefTestDay2:ObjChiefTestDay = new ObjChiefTestDay();


            //var staticTest:StaticTest = new StaticTest();
            //var doubleTest:DoubleTest = new DoubleTest();
            //var vectorTest:VectorTest = new VectorTest();
            //var superTest:SuperTest = new SuperTest();
            //var agalTorus:AGALTorus = new AGALTorus();
            //var phongTorus:PhongTorus = new PhongTorus();
            //var mipMapTest:MipMapTest = new MipMapTest();

            //var bitmapTextureTest:BitmapTextureTest = new BitmapTextureTest();
            //var bitmapDataTest:BitmapDataTest = new BitmapDataTest();

        }

        private function createBtn(label:String, position:Point=null):HTMLButtonElement
        {
            if (!position) position = new Point(0,0);
            var btn:HTMLButtonElement = Window.document.createElement("BUTTON") as HTMLButtonElement;
            var previousText:HTMLTextAreaElement = Window.document.createTextNode(label) as HTMLTextAreaElement;
            btn.appendChild(previousText);
            Window.document.body.appendChild(btn);
            btn.style.setProperty('z-index', '100');
            btn.style.setProperty('position', 'absolute');
            btn.style.setProperty('margin-left', String(position.x));
            btn.style.setProperty('margin-top', String(position.y));
            return btn;
        }


        public function set exampleIndex(value:int):void
        {
            if (value < 0) value = exampleClasses.length - 1;
            if (value > exampleClasses.length - 1) value = 0;

            if (_exampleIndex == value) return;
            _exampleIndex = value;



            for (var i:int = 0; i < exampleClasses.length; ++i){

                if (i == this.exampleIndex) {
                    if (!exampleVec[i]) {
                        var _Class = exampleClasses[i];
                        exampleVec.push(new _Class(i));
                    }
                    exampleVec[i].Show();
                }
                else if (exampleVec.length > i){
                    if (exampleVec[i]) exampleVec[i].Hide();
                }
            }
        }

        public function get exampleIndex():int
        {
            return _exampleIndex;
        }
    }
}