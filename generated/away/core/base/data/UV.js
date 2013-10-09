/** Compiled by the Randori compiler v0.2.5.2 on Wed Oct 09 20:30:38 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.core == "undefined")
	away.core = {};
if (typeof away.core.base == "undefined")
	away.core.base = {};
if (typeof away.core.base.data == "undefined")
	away.core.base.data = {};

away.core.base.data.UV = function(u, v) {
	this._u = 0;
	this._v = 0;
	u = u || 0;
	v = v || 0;
	this._u = u;
	this._v = v;
};

away.core.base.data.UV.prototype.get_v = function() {
	return this._v;
};

away.core.base.data.UV.prototype.set_v = function(value) {
	this._v = value;
};

away.core.base.data.UV.prototype.get_u = function() {
	return this._u;
};

away.core.base.data.UV.prototype.set_u = function(value) {
	this._u = value;
};

away.core.base.data.UV.prototype.clone = function() {
	return new away.core.base.data.UV(this._u, this._v);
};

away.core.base.data.UV.prototype.toString = function() {
	return this._u + "," + this._v;
};

away.core.base.data.UV.className = "away.core.base.data.UV";

away.core.base.data.UV.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.core.base.data.UV.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.core.base.data.UV.injectionPoints = function(t) {
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

