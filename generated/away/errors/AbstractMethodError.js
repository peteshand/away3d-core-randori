/** Compiled by the Randori compiler v0.2.6.2 on Sun Sep 22 11:19:29 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.errors == "undefined")
	away.errors = {};

away.errors.AbstractMethodError = function(message, id) {
	message = message || null;
	id = id || 0;
	away.errors.Error.call(this, message || "An abstract method was called! Either an instance of an abstract class was created, or an abstract method was not overridden by the subclass.", id, "");
};

$inherit(away.errors.AbstractMethodError, away.errors.Error);

away.errors.AbstractMethodError.className = "away.errors.AbstractMethodError";

away.errors.AbstractMethodError.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.errors.AbstractMethodError.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.errors.AbstractMethodError.injectionPoints = function(t) {
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

