/** Compiled by the Randori compiler v0.2.6.2 on Sat Sep 21 08:57:20 EST 2013 */

if (typeof test == "undefined")
	var test = {};

test.DoubleTest = function() {
	this._test = "";
	this._test2 = "";
	this.set_test(this.set_test2("test123"));
	console.log(this._test);
	console.log(this._test2);
};

test.DoubleTest.prototype.set_test2 = function(value) {
	this._test2 = value;
};

test.DoubleTest.prototype.set_test = function(value) {
	this._test = value;
};

test.DoubleTest.className = "test.DoubleTest";

test.DoubleTest.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

test.DoubleTest.getStaticDependencies = function(t) {
	var p;
	return [];
};

test.DoubleTest.injectionPoints = function(t) {
	return [];
};
