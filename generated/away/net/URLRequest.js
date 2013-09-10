/** Compiled by the Randori compiler v0.2.6.2 on Tue Sep 10 22:28:06 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.net == "undefined")
	away.net = {};

away.net.URLRequest = function(url) {
	this._url = null;
	this.data = null;
	this.method = away.net.URLRequestMethod.GET;
	this.async = true;
	this._url = url;
};

away.net.URLRequest.prototype.get_url = function() {
	return this._url;
};

away.net.URLRequest.prototype.set_url = function(value) {
	this._url = value;
};

away.net.URLRequest.prototype.dispose = function() {
	this.data = null;
	this._url = null;
	this.method = null;
	this.async = null;
};

away.net.URLRequest.className = "away.net.URLRequest";

away.net.URLRequest.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.net.URLRequest.getStaticDependencies = function(t) {
	var p;
	p = [];
	p.push('away.net.URLRequestMethod');
	return p;
};

away.net.URLRequest.injectionPoints = function(t) {
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

