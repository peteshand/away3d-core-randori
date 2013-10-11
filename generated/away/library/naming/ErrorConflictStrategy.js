/** Compiled by the Randori compiler v0.2.5.2 on Sat Oct 12 02:16:04 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.library == "undefined")
	away.library = {};
if (typeof away.library.naming == "undefined")
	away.library.naming = {};

away.library.naming.ErrorConflictStrategy = function() {
	away.library.naming.ConflictStrategyBase.call(this);
};

away.library.naming.ErrorConflictStrategy.prototype.resolveConflict = function(changedAsset, oldAsset, assetsDictionary, precedence) {
	throw new away.errors.away.errors.Error("Asset name collision while AssetLibrary.namingStrategy set to AssetLibrary.THROW_ERROR. Asset path: " + changedAsset.get_assetFullPath(), 0, "");
};

away.library.naming.ErrorConflictStrategy.prototype.create = function() {
	return new away.library.naming.ErrorConflictStrategy();
};

$inherit(away.library.naming.ErrorConflictStrategy, away.library.naming.ConflictStrategyBase);

away.library.naming.ErrorConflictStrategy.className = "away.library.naming.ErrorConflictStrategy";

away.library.naming.ErrorConflictStrategy.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.library.naming.ErrorConflictStrategy.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.library.naming.ErrorConflictStrategy.injectionPoints = function(t) {
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

