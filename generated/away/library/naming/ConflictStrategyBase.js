/** Compiled by the Randori compiler v0.2.5.2 on Sat Oct 12 02:16:03 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.library == "undefined")
	away.library = {};
if (typeof away.library.naming == "undefined")
	away.library.naming = {};

away.library.naming.ConflictStrategyBase = function() {
};

away.library.naming.ConflictStrategyBase.prototype.resolveConflict = function(changedAsset, oldAsset, assetsDictionary, precedence) {
	throw new away.errors.AbstractMethodError(null, 0);
};

away.library.naming.ConflictStrategyBase.prototype.create = function() {
	throw new away.errors.AbstractMethodError(null, 0);
};

away.library.naming.ConflictStrategyBase.prototype._pUpdateNames = function(ns, nonConflictingName, oldAsset, newAsset, assetsDictionary, precedence) {
	var loser_prev_name;
	var winner;
	var loser;
	winner = (precedence === away.library.naming.ConflictPrecedence.FAVOR_NEW) ? newAsset : oldAsset;
	loser = (precedence === away.library.naming.ConflictPrecedence.FAVOR_NEW) ? oldAsset : newAsset;
	loser_prev_name = loser.get_name();
	assetsDictionary[winner.get_name()] = winner;
	assetsDictionary[nonConflictingName] = loser;
	loser.resetAssetPath(nonConflictingName, ns, false);
	loser.dispatchEvent(new away.events.AssetEvent(away.events.AssetEvent.ASSET_CONFLICT_RESOLVED, loser, loser_prev_name));
};

away.library.naming.ConflictStrategyBase.className = "away.library.naming.ConflictStrategyBase";

away.library.naming.ConflictStrategyBase.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.library.naming.ConflictPrecedence');
	p.push('away.errors.AbstractMethodError');
	p.push('away.events.AssetEvent');
	return p;
};

away.library.naming.ConflictStrategyBase.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.library.naming.ConflictStrategyBase.injectionPoints = function(t) {
	return [];
};
