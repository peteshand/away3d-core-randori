/** Compiled by the Randori compiler v0.2.6.2 on Sun Sep 22 11:20:03 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.library == "undefined")
	away.library = {};
if (typeof away.library.naming == "undefined")
	away.library.naming = {};

away.library.naming.NumSuffixConflictStrategy = function(separator) {
	this._separator = null;
	this._next_suffix = null;
	separator = separator || ".";
	away.library.naming.ConflictStrategyBase.call(this);
	this._separator = separator;
	this._next_suffix = {};
};

away.library.naming.NumSuffixConflictStrategy.prototype.resolveConflict = function(changedAsset, oldAsset, assetsDictionary, precedence) {
	var orig;
	var new_name;
	var base;
	var suffix;
	orig = changedAsset.get_name();
	if (orig.indexOf(this._separator, 0) >= 0) {
		base = orig.substring(0, orig.lastIndexOf(this._separator, 2147483647));
		suffix = parseInt(orig.substring(base.length - 1, 2147483647), 0);
		if (isNaN(suffix)) {
			base = orig;
			suffix = 0;
		}
	} else {
		base = orig;
		suffix = 0;
	}
	if (suffix == 0 && this._next_suffix.hasOwnProperty(base)) {
		suffix = this._next_suffix[base];
	}
	do {
		suffix++;
		new_name = base.concat(this._separator, suffix.toString(10));
	} while (assetsDictionary.hasOwnProperty(new_name));
	this._next_suffix[base] = suffix;
	this._pUpdateNames(oldAsset.get_assetNamespace(), new_name, oldAsset, changedAsset, assetsDictionary, precedence);
};

away.library.naming.NumSuffixConflictStrategy.prototype.create = function() {
	return new away.library.naming.NumSuffixConflictStrategy(this._separator);
};

$inherit(away.library.naming.NumSuffixConflictStrategy, away.library.naming.ConflictStrategyBase);

away.library.naming.NumSuffixConflictStrategy.className = "away.library.naming.NumSuffixConflictStrategy";

away.library.naming.NumSuffixConflictStrategy.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('*away.library.assets.IAsset');
	return p;
};

away.library.naming.NumSuffixConflictStrategy.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.library.naming.NumSuffixConflictStrategy.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'separator', t:'String'});
			break;
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

