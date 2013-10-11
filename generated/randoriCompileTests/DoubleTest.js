/** Compiled by the Randori compiler v0.2.5.2 on Sat Oct 12 02:16:08 EST 2013 */

if (typeof randoriCompileTests == "undefined")
	var randoriCompileTests = {};

randoriCompileTests.DoubleTest = function() {
	this._test = "";
	this._test2 = "";
	this.set_test(this.set_test2("test123"));
	console.log(this._test);
	console.log(this._test2);
};

randoriCompileTests.DoubleTest.prototype.set_test2 = function(value) {
	this._test2 = value;
};

randoriCompileTests.DoubleTest.prototype.set_test = function(value) {
	this._test = value;
};

randoriCompileTests.DoubleTest.className = "randoriCompileTests.DoubleTest";

randoriCompileTests.DoubleTest.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

randoriCompileTests.DoubleTest.getStaticDependencies = function(t) {
	var p;
	return [];
};

randoriCompileTests.DoubleTest.injectionPoints = function(t) {
	return [];
};
