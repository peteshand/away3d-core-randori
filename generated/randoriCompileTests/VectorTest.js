/** Compiled by the Randori compiler v0.2.5.2 on Wed Oct 09 20:30:37 EST 2013 */

if (typeof randoriCompileTests == "undefined")
	var randoriCompileTests = {};

randoriCompileTests.VectorTest = function() {
	this._vec = [false];
	randoriCompileTests.VectorTestBase.call(this, false);
};

$inherit(randoriCompileTests.VectorTest, randoriCompileTests.VectorTestBase);

randoriCompileTests.VectorTest.className = "randoriCompileTests.VectorTest";

randoriCompileTests.VectorTest.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

randoriCompileTests.VectorTest.getStaticDependencies = function(t) {
	var p;
	return [];
};

randoriCompileTests.VectorTest.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 1:
			p = randoriCompileTests.VectorTestBase.injectionPoints(t);
			break;
		case 2:
			p = randoriCompileTests.VectorTestBase.injectionPoints(t);
			break;
		case 3:
			p = randoriCompileTests.VectorTestBase.injectionPoints(t);
			break;
		default:
			p = [];
			break;
	}
	return p;
};

