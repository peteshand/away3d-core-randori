/** Compiled by the Randori compiler v0.2.6.2 on Wed Sep 04 21:18:37 EST 2013 */

if (typeof myTests == "undefined")
	var myTests = {};

myTests.ImageLoadTest = function() {
	var urlRequest = new away.net.URLRequest("assets\/130909wall_big.png");
	var imgLoader = new away.net.IMGLoader("");
	imgLoader.addEventListener(away.events.Event.COMPLETE, $createStaticDelegate(, this.imageCompleteHandler), this);
	imgLoader.load(urlRequest);
};

myTests.ImageLoadTest.prototype.imageCompleteHandler = function(e) {
	var imageLoader = e.target;
	console.log("Load complete");
};

myTests.ImageLoadTest.className = "myTests.ImageLoadTest";

myTests.ImageLoadTest.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.net.URLRequest');
	p.push('away.events.Event');
	p.push('away.net.IMGLoader');
	p.push('Object');
	return p;
};

myTests.ImageLoadTest.getStaticDependencies = function(t) {
	var p;
	return [];
};

myTests.ImageLoadTest.injectionPoints = function(t) {
	return [];
};
