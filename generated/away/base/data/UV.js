/** Compiled by the Randori compiler v0.2.6.2 on Sat Sep 28 11:54:23 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.base == "undefined")
	away.base = {};
if (typeof away.base.data == "undefined")
	away.base.data = {};

away.base.data.UV = function(u, v) {
	this._u = 0;
	this._v = 0;
	u = u || 0;
	v = v || 0;
	this._u = u;
	this._v = v;
};

away.base.data.UV.prototype.get_v = function() {
	return this._v;
};

away.base.data.UV.prototype.set_v = function(value) {
	this._v = value;
};

away.base.data.UV.prototype.get_u = function() {
	return this._u;
};

away.base.data.UV.prototype.set_u = function(value) {
	this._u = value;
};

away.base.data.UV.prototype.clone = function() {
	return new away.base.data.UV(this._u, this._v);
};

away.base.data.UV.prototype.toString = function() {
	return this._u + "," + this._v;
};

away.base.data.UV.className = "away.base.data.UV";

away.base.data.UV.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.base.data.UV.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.base.data.UV.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'u', t:'Number'});
			p.push({n:'v', t:'Number'});
			break;
		default:
			p = [];
			break;
	}
	return p;
};

