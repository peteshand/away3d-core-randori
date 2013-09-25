/** Compiled by the Randori compiler v0.2.6.2 on Sun Sep 22 22:43:38 EST 2013 */

if (typeof wrappers == "undefined")
	var wrappers = {};

wrappers.CanvasRenderingContext2D = function() {
};

wrappers.CanvasRenderingContext2D.prototype.putImageData = function(imagedata, dx, dy, dirtyX, dirtyY, dirtyWidth, dirtyHeight) {
};

$inherit(wrappers.CanvasRenderingContext2D, randori.webkit.html.canvas.CanvasRenderingContext2D);

wrappers.CanvasRenderingContext2D.className = "wrappers.CanvasRenderingContext2D";

wrappers.CanvasRenderingContext2D.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

wrappers.CanvasRenderingContext2D.getStaticDependencies = function(t) {
	var p;
	return [];
};

wrappers.CanvasRenderingContext2D.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 1:
			p = randori.webkit.html.canvas.CanvasRenderingContext2D.injectionPoints(t);
			break;
		case 2:
			p = randori.webkit.html.canvas.CanvasRenderingContext2D.injectionPoints(t);
			break;
		case 3:
			p = randori.webkit.html.canvas.CanvasRenderingContext2D.injectionPoints(t);
			break;
		default:
			p = [];
			break;
	}
	return p;
};

