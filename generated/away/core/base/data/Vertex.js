/** Compiled by the Randori compiler v0.2.5.2 on Wed Oct 09 20:30:38 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.core == "undefined")
	away.core = {};
if (typeof away.core.base == "undefined")
	away.core.base = {};
if (typeof away.core.base.data == "undefined")
	away.core.base.data = {};

away.core.base.data.Vertex = function(x, y, z, index) {
	this._x = 0;
	this._y = 0;
	this._z = 0;
	this._index = 0;
	x = x || 0;
	y = y || 0;
	z = z || 0;
	index = index || 0;
	this._x = x;
	this._y = y;
	this._z = z;
	this._index = index;
};

away.core.base.data.Vertex.prototype.set_index = function(ind) {
	this._index = ind;
};

away.core.base.data.Vertex.prototype.get_index = function() {
	return this._index;
};

away.core.base.data.Vertex.prototype.get_x = function() {
	return this._x;
};

away.core.base.data.Vertex.prototype.set_x = function(value) {
	this._x = value;
};

away.core.base.data.Vertex.prototype.get_y = function() {
	return this._y;
};

away.core.base.data.Vertex.prototype.set_y = function(value) {
	this._y = value;
};

away.core.base.data.Vertex.prototype.get_z = function() {
	return this._z;
};

away.core.base.data.Vertex.prototype.set_z = function(value) {
	this._z = value;
};

away.core.base.data.Vertex.prototype.clone = function() {
	return new away.core.base.data.Vertex(this._x, this._y, this._z, 0);
};

away.core.base.data.Vertex.prototype.toString = function() {
	return this._x + "," + this._y + "," + this._z;
};

away.core.base.data.Vertex.className = "away.core.base.data.Vertex";

away.core.base.data.Vertex.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.core.base.data.Vertex.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.core.base.data.Vertex.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'x', t:'Number'});
			p.push({n:'y', t:'Number'});
			p.push({n:'z', t:'Number'});
			p.push({n:'index', t:'Number'});
			break;
		default:
			p = [];
			break;
	}
	return p;
};

