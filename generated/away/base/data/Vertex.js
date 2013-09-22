/** Compiled by the Randori compiler v0.2.6.2 on Sun Sep 22 11:19:35 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.base == "undefined")
	away.base = {};
if (typeof away.base.data == "undefined")
	away.base.data = {};

away.base.data.Vertex = function(x, y, z, index) {
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

away.base.data.Vertex.prototype.set_index = function(ind) {
	this._index = ind;
};

away.base.data.Vertex.prototype.get_index = function() {
	return this._index;
};

away.base.data.Vertex.prototype.get_x = function() {
	return this._x;
};

away.base.data.Vertex.prototype.set_x = function(value) {
	this._x = value;
};

away.base.data.Vertex.prototype.get_y = function() {
	return this._y;
};

away.base.data.Vertex.prototype.set_y = function(value) {
	this._y = value;
};

away.base.data.Vertex.prototype.get_z = function() {
	return this._z;
};

away.base.data.Vertex.prototype.set_z = function(value) {
	this._z = value;
};

away.base.data.Vertex.prototype.clone = function() {
	return new away.base.data.Vertex(this._x, this._y, this._z, 0);
};

away.base.data.Vertex.prototype.toString = function() {
	return this._x + "," + this._y + "," + this._z;
};

away.base.data.Vertex.className = "away.base.data.Vertex";

away.base.data.Vertex.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.base.data.Vertex.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.base.data.Vertex.injectionPoints = function(t) {
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

