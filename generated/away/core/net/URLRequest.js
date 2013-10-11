/** Compiled by the Randori compiler v0.2.5.2 on Sat Oct 12 02:16:06 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.core == "undefined")
	away.core = {};
if (typeof away.core.net == "undefined")
	away.core.net = {};

away.core.net.URLRequest = function(url) {
	this._url = null;
	this.data = null;
	this.method = away.core.net.URLRequestMethod.GET;
	this.async = true;
	url = url || null;
	this._url = url;
};

away.core.net.URLRequest.prototype.get_url = function() {
	return this._url;
};

away.core.net.URLRequest.prototype.set_url = function(value) {
	this._url = value;
};

away.core.net.URLRequest.prototype.dispose = function() {
	this.data = null;
	this._url = null;
	this.method = null;
	this.async = null;
};

away.core.net.URLRequest.className = "away.core.net.URLRequest";

away.core.net.URLRequest.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.core.net.URLRequest.getStaticDependencies = function(t) {
	var p;
	p = [];
	p.push('away.core.net.URLRequestMethod');
	return p;
};

away.core.net.URLRequest.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'url', t:'String'});
			break;
		default:
			p = [];
			break;
	}
	return p;
};

