/** Compiled by the Randori compiler v0.2.6.2 on Tue Sep 10 22:28:08 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.utils == "undefined")
	away.utils = {};

away.utils.CSS = function() {
	
};

away.utils.CSS.setCanvasSize = function(canvas, width, height) {
	canvas.style.width = width + "px";
	canvas.style.height = height + "px";
	canvas.width = width;
	canvas.height = height;
};

away.utils.CSS.setCanvasWidth = function(canvas, width) {
	canvas.style.width = width + "px";
	canvas.width = width;
};

away.utils.CSS.setCanvasHeight = function(canvas, height) {
	canvas.style.height = height + "px";
	canvas.height = height;
};

away.utils.CSS.setCanvasX = function(canvas, x) {
	canvas.style.position = "absolute";
	canvas.style.left = x + "px";
};

away.utils.CSS.setCanvasY = function(canvas, y) {
	canvas.style.position = "absolute";
	canvas.style.top = y + "px";
};

away.utils.CSS.getCanvasVisibility = function(canvas) {
	return canvas.style.visibility == "visible";
};

away.utils.CSS.setCanvasVisibility = function(canvas, visible) {
	if (visible) {
		canvas.style.visibility = "visible";
	} else {
		canvas.style.visibility = "hidden";
	}
};

away.utils.CSS.setCanvasAlpha = function(canvas, alpha) {
	var context = canvas.getContext("2d");
	context.globalAlpha = alpha;
};

away.utils.CSS.setCanvasPosition = function(canvas, x, y, absolute) {
	if (absolute) {
		canvas.style.position = "absolute";
	} else {
		canvas.style.position = "relative";
	}
	canvas.style.left = x + "px";
	canvas.style.top = y + "px";
};

away.utils.CSS.className = "away.utils.CSS";

away.utils.CSS.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.utils.CSS.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.utils.CSS.injectionPoints = function(t) {
	return [];
};
