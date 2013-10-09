/** Compiled by the Randori compiler v0.2.5.2 on Wed Oct 09 20:30:41 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.core == "undefined")
	away.core = {};
if (typeof away.core.geom == "undefined")
	away.core.geom = {};

away.core.geom.Rectangle = function(x, y, width, height) {
	x = x || 0;
	y = y || 0;
	width = width || 0;
	height = height || 0;
	this.x = x;
	this.y = y;
	this.width = width;
	this.height = height;
};

away.core.geom.Rectangle.prototype.get_left = function() {
	return this.x;
};

away.core.geom.Rectangle.prototype.get_right = function() {
	return this.x + this.width;
};

away.core.geom.Rectangle.prototype.get_top = function() {
	return this.y;
};

away.core.geom.Rectangle.prototype.get_bottom = function() {
	return this.y + this.height;
};

away.core.geom.Rectangle.prototype.get_topLeft = function() {
	return new away.core.geom.Point(this.x, this.y);
};

away.core.geom.Rectangle.prototype.get_bottomRight = function() {
	return new away.core.geom.Point(this.x + this.width, this.y + this.height);
};

away.core.geom.Rectangle.prototype.clone = function() {
	return new away.core.geom.Rectangle(this.x, this.y, this.width, this.height);
};

away.core.geom.Rectangle.className = "away.core.geom.Rectangle";

away.core.geom.Rectangle.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.core.geom.Point');
	return p;
};

away.core.geom.Rectangle.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.core.geom.Rectangle.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'x', t:'Number'});
			p.push({n:'y', t:'Number'});
			p.push({n:'width', t:'Number'});
			p.push({n:'height', t:'Number'});
			break;
		default:
			p = [];
			break;
	}
	return p;
};

