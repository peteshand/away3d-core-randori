/** Compiled by the Randori compiler v0.2.5.2 on Sat Oct 12 02:16:04 EST 2013 */

if (typeof randoriCompileTests == "undefined")
	var randoriCompileTests = {};

randoriCompileTests.SuperTest = function() {
	this._vec = [];
	randoriCompileTests.SuperTestBase.call(this, false);
};

$inherit(randoriCompileTests.SuperTest, randoriCompileTests.SuperTestBase);

randoriCompileTests.SuperTest.className = "randoriCompileTests.SuperTest";

randoriCompileTests.SuperTest.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

randoriCompileTests.SuperTest.getStaticDependencies = function(t) {
	var p;
	return [];
};

randoriCompileTests.SuperTest.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 1:
			p = randoriCompileTests.SuperTestBase.injectionPoints(t);
			break;
		case 2:
			p = randoriCompileTests.SuperTestBase.injectionPoints(t);
			break;
		case 3:
			p = randoriCompileTests.SuperTestBase.injectionPoints(t);
			break;
		default:
			p = [];
			break;
	}
	return p;
};

