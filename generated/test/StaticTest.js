/** Compiled by the Randori compiler v0.2.6.2 on Sat Sep 21 09:12:02 EST 2013 */

if (typeof test == "undefined")
	var test = {};

test.StaticTest = function() {
	this.addCallback($createStaticDelegate(this, this.Callback));
};

test.StaticTest.prototype.Callback = function() {
	return "test123";
};

test.StaticTest.prototype.addCallback = function(callback) {
	console.log(callback());
};

test.StaticTest.className = "test.StaticTest";

test.StaticTest.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

test.StaticTest.getStaticDependencies = function(t) {
	var p;
	return [];
};

test.StaticTest.injectionPoints = function(t) {
	return [];
};
