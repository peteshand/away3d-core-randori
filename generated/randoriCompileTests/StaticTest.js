/** Compiled by the Randori compiler v0.2.5.2 on Sat Oct 12 02:16:09 EST 2013 */

if (typeof randoriCompileTests == "undefined")
	var randoriCompileTests = {};

randoriCompileTests.StaticTest = function() {
	this.addCallback($createStaticDelegate(this, this.Callback));
};

randoriCompileTests.StaticTest.prototype.Callback = function() {
	return "test123";
};

randoriCompileTests.StaticTest.prototype.addCallback = function(callback) {
	console.log(callback());
};

randoriCompileTests.StaticTest.className = "randoriCompileTests.StaticTest";

randoriCompileTests.StaticTest.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

randoriCompileTests.StaticTest.getStaticDependencies = function(t) {
	var p;
	return [];
};

randoriCompileTests.StaticTest.injectionPoints = function(t) {
	return [];
};
