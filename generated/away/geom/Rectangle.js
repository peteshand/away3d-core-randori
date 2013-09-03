/** Compiled by the Randori compiler v0.2.6.2 on Mon Sep 02 23:32:29 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.geom == "undefined")
	away.geom = {};

away.geom.Rectangle = function(x, y, width, height) {
	this.x = x;
	this.y = y;
	this.width = width;
	this.height = height;
};

away.geom.Rectangle.prototype.get_left = function() {
	return this.x;
};

away.geom.Rectangle.prototype.get_right = function() {
	return this.x + this.width;
};

away.geom.Rectangle.prototype.get_top = function() {
	return this.y;
};

away.geom.Rectangle.prototype.get_bottom = function() {
	return this.y + this.height;
};

away.geom.Rectangle.prototype.get_topLeft = function() {
	return new away.geom.Point(this.x, this.y);
};

away.geom.Rectangle.prototype.get_bottomRight = function() {
	return new away.geom.Point(this.x + this.width, this.y + this.height);
};

away.geom.Rectangle.prototype.clone = function() {
	return new away.geom.Rectangle(this.x, this.y, this.width, this.height);
};

away.geom.Rectangle.className = "away.geom.Rectangle";

away.geom.Rectangle.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.geom.Point');
	return p;
};

away.geom.Rectangle.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.geom.Rectangle.injectionPoints = function(t) {
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

