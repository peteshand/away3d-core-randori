/** Compiled by the Randori compiler v0.2.6.2 on Mon Sep 02 23:32:25 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.net == "undefined")
	away.net = {};

away.net.URLVariables = function(source) {
	this._variables = {};
	if (source !== null) {
		this.decode(source);
	}
};

away.net.URLVariables.prototype.decode = function(source) {
	source = source.split("+", 4.294967295E9).join(" ");
	var tokens, re = /[?&]?([^=]+)=([^&]*)/g;
	while (tokens = re.exec(source)) {
		this._variables[decodeURIComponent(tokens[1])] = decodeURIComponent(tokens[2]);
	}
};

away.net.URLVariables.prototype.toString = function() {
	return "";
};

away.net.URLVariables.prototype.get_variables = function() {
	return this._variables;
};

away.net.URLVariables.prototype.get_formData = function() {
	var fd = new FormData();
	for (var s in this._variables) {
		fd.append(s, this._variables[s]);
	}
	return fd;
};

away.net.URLVariables.prototype.set_variables = function(obj) {
	this._variables = obj;
};

away.net.URLVariables.className = "away.net.URLVariables";

away.net.URLVariables.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.net.URLVariables.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.net.URLVariables.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'source', t:'String'});
			break;
		default:
			p = [];
			break;
	}
	return p;
};

