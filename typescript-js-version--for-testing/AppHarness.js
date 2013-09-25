/**
* ...
* @author Gary Paluk - http://www.plugin.io
*/
///<reference path="Away3D.ts"/>
///<reference path="../tests/scene/PhongTorus.ts"/>
///<reference path="../tests/scene/MaterialTorus.ts"/>
///<reference path="../tests/scene/AGALTorus.ts"/>
///<reference path="../tests/aglsl/AssemblerTest.ts"/>
///<reference path="../tests/aglsl/AGALCompilerTest.ts"/>
var away;
(function (away) {
    var AppHarness = (function () {
        function AppHarness() {
            new scene.AGALTorus();
        }
        return AppHarness;
    })();
    away.AppHarness = AppHarness;
})(away || (away = {}));

window.onload = function () {
    var app = new away.AppHarness();
};
//# sourceMappingURL=AppHarness.js.map
