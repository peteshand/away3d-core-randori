/**
* ...
* @author Gary Paluk - http://www.plugin.io
*/
var __extends = this.__extends || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    __.prototype = b.prototype;
    d.prototype = new __();
};
///<reference path="away/_definitions.ts"/>
var away;
(function (away) {
    var Away3D = (function (_super) {
        __extends(Away3D, _super);
        function Away3D() {
            _super.call(this);
        }
        return Away3D;
    })(away.events.EventDispatcher);
    away.Away3D = Away3D;
})(away || (away = {}));
//# sourceMappingURL=Away3D.js.map
