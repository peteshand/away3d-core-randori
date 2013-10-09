/** Compiled by the Randori compiler v0.2.5.2 on Wed Oct 09 20:30:40 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.core == "undefined")
	away.core = {};
if (typeof away.core.net == "undefined")
	away.core.net = {};

away.core.net.URLVariables = function(source) {
	this._variables = {};
	source = source || null;
	if (source !== null) {
		this.decode(source);
	}
};

away.core.net.URLVariables.prototype.decode = function(source) {
	source = source.split("+", 4.294967295E9).join(" ");
	var re = /[?&]?([^=]+)=([^&]*)/g;
	var tokens = re;
	while (tokens = re.exec(source)) {
		this._variables[decodeURIComponent(tokens[1])] = decodeURIComponent(tokens[2]);
	}
};

away.core.net.URLVariables.prototype.toString = function() {
	return "";
};

away.core.net.URLVariables.prototype.get_variables = function() {
	return this._variables;
};

away.core.net.URLVariables.prototype.get_formData = function() {
	var fd = new FormData();
	for (var s in this._variables) {
		fd.append(s, this._variables[s]);
	}
	return fd;
};

away.core.net.URLVariables.prototype.set_variables = function(obj) {
	this._variables = obj;
};

away.core.net.URLVariables.className = "away.core.net.URLVariables";

away.core.net.URLVariables.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.core.net.URLVariables.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.core.net.URLVariables.injectionPoints = function(t) {
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

