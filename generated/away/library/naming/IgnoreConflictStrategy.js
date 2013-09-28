/** Compiled by the Randori compiler v0.2.6.2 on Sat Sep 28 11:54:55 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.library == "undefined")
	away.library = {};
if (typeof away.library.naming == "undefined")
	away.library.naming = {};

away.library.naming.IgnoreConflictStrategy = function() {
	away.library.naming.ConflictStrategyBase.call(this);
};

away.library.naming.IgnoreConflictStrategy.prototype.resolveConflict = function(changedAsset, oldAsset, assetsDictionary, precedence) {
	return;
};

away.library.naming.IgnoreConflictStrategy.prototype.create = function() {
	return new away.library.naming.IgnoreConflictStrategy();
};

$inherit(away.library.naming.IgnoreConflictStrategy, away.library.naming.ConflictStrategyBase);

away.library.naming.IgnoreConflictStrategy.className = "away.library.naming.IgnoreConflictStrategy";

away.library.naming.IgnoreConflictStrategy.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.library.naming.IgnoreConflictStrategy.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.library.naming.IgnoreConflictStrategy.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 1:
			p = away.library.naming.ConflictStrategyBase.injectionPoints(t);
			break;
		case 2:
			p = away.library.naming.ConflictStrategyBase.injectionPoints(t);
			break;
		case 3:
			p = away.library.naming.ConflictStrategyBase.injectionPoints(t);
			break;
		default:
			p = [];
			break;
	}
	return p;
};

