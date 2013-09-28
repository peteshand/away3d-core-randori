/** Compiled by the Randori compiler v0.2.6.2 on Sat Sep 28 11:54:57 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.errors == "undefined")
	away.errors = {};

away.errors.DocumentError = function(message, id) {
	message = message || "DocumentError";
	id = id || 0;
	away.errors.Error.call(this, message, id, "");
};

away.errors.DocumentError.DOCUMENT_DOES_NOT_EXIST = "documentDoesNotExist";

$inherit(away.errors.DocumentError, away.errors.Error);

away.errors.DocumentError.className = "away.errors.DocumentError";

away.errors.DocumentError.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.errors.DocumentError.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.errors.DocumentError.injectionPoints = function(t) {
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

