/** Compiled by the Randori compiler v0.2.6.2 on Thu Sep 05 22:19:27 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.errors == "undefined")
	away.errors = {};

away.errors.ArgumentError = function(message, id) {
	away.errors.Error.call(this, message || "ArgumentError", id, "");
};

$inherit(away.errors.ArgumentError, away.errors.Error);

away.errors.ArgumentError.className = "away.errors.ArgumentError";

away.errors.ArgumentError.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.errors.ArgumentError.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.errors.ArgumentError.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'message', t:'String'});
			p.push({n:'id', t:'Number'});
			break;
		case 1:
			p = away.errors.Error.injectionPoints(t);
			break;
		case 2:
			p = away.errors.Error.injectionPoints(t);
			break;
		case 3:
			p = away.errors.Error.injectionPoints(t);
			break;
		default:
			p = [];
			break;
	}
	return p;
};

