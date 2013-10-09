/** Compiled by the Randori compiler v0.2.5.2 on Wed Oct 09 20:30:42 EST 2013 */

if (typeof examples == "undefined")
	var examples = {};

examples.ImageLoadTest = function() {
	var urlRequest = new away.core.net.URLRequest("assets\/130909wall_big.png");
	var imgLoader = new away.core.net.IMGLoader("");
	imgLoader.addEventListener(away.events.Event.COMPLETE, $createStaticDelegate(this, this.imageCompleteHandler), this);
	imgLoader.load(urlRequest);
};

examples.ImageLoadTest.prototype.imageCompleteHandler = function(e) {
	var imageLoader = e.target;
	console.log("Load complete");
};

examples.ImageLoadTest.className = "examples.ImageLoadTest";

examples.ImageLoadTest.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.events.Event');
	p.push('away.core.net.URLRequest');
	p.push('Object');
	p.push('away.core.net.IMGLoader');
	return p;
};

examples.ImageLoadTest.getStaticDependencies = function(t) {
	var p;
	return [];
};

examples.ImageLoadTest.injectionPoints = function(t) {
	return [];
};
