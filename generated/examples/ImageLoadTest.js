/** Compiled by the Randori compiler v0.2.6.2 on Tue Sep 24 23:06:53 EST 2013 */

if (typeof examples == "undefined")
	var examples = {};

examples.ImageLoadTest = function() {
	var urlRequest = new away.net.URLRequest("assets\/130909wall_big.png");
	var imgLoader = new away.net.IMGLoader("");
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
	p.push('away.net.URLRequest');
	p.push('away.events.Event');
	p.push('away.net.IMGLoader');
	p.push('Object');
	return p;
};

examples.ImageLoadTest.getStaticDependencies = function(t) {
	var p;
	return [];
};

examples.ImageLoadTest.injectionPoints = function(t) {
	return [];
};
