/** Compiled by the Randori compiler v0.2.6.2 on Tue Sep 24 22:31:39 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.errors == "undefined")
	away.errors = {};

away.errors.Error = function(message, id, _name) {
	this._messsage = "";
	this._errorID = 0;
	message = message || "";
	id = id || 0;
	_name = _name || "";
	this._messsage = message;
	this._name = $createStaticDelegate(this, this.get_name);
	this._errorID = id;
};

away.errors.Error.prototype.get_message = function() {
	return this._messsage;
};

away.errors.Error.prototype.set_message = function(value) {
	this._messsage = value;
};

away.errors.Error.prototype.get_name = function() {
	return this._name;
};

away.errors.Error.prototype.set_name = function(value) {
	this._name = value;
};

away.errors.Error.prototype.get_errorID = function() {
	return this._errorID;
};

away.errors.Error.className = "away.errors.Error";

away.errors.Error.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.errors.Error.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.errors.Error.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'message', t:'String'});
			p.push({n:'id', t:'Number'});
			p.push({n:'_name', t:'String'});
			break;
		default:
			p = [];
			break;
	}
	return p;
};

