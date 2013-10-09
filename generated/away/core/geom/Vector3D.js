/** Compiled by the Randori compiler v0.2.5.2 on Wed Oct 09 20:30:41 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.core == "undefined")
	away.core = {};
if (typeof away.core.geom == "undefined")
	away.core.geom = {};

away.core.geom.Vector3D = function(x, y, z, w) {
	x = x || 0;
	y = y || 0;
	z = z || 0;
	w = w || 0;
	this.x = x;
	this.y = y;
	this.z = z;
	this.w = w;
};

away.core.geom.Vector3D.X_AXIS = new away.core.geom.Vector3D(1, 0, 0, 0);

away.core.geom.Vector3D.Y_AXIS = new away.core.geom.Vector3D(0, 1, 0, 0);

away.core.geom.Vector3D.Z_AXIS = new away.core.geom.Vector3D(0, 0, 1, 0);

away.core.geom.Vector3D.prototype.get_length = function() {
	return Math.sqrt(this.x * this.x + this.y * this.y + this.z * this.z);
};

away.core.geom.Vector3D.prototype.get_lengthSquared = function() {
	return (this.x * this.x + this.y * this.y + this.z * this.z);
};

away.core.geom.Vector3D.prototype.add = function(a) {
	return new away.core.geom.Vector3D(this.x + a.x, this.y + a.y, this.z + a.z, this.w + a.w);
};

away.core.geom.Vector3D.angleBetween = function(a, b) {
	return Math.acos(a.dotProduct(b) / (a.get_length() * b.get_length()));
};

away.core.geom.Vector3D.prototype.clone = function() {
	return new away.core.geom.Vector3D(this.x, this.y, this.z, this.w);
};

away.core.geom.Vector3D.prototype.copyFrom = function(src) {
	this.x = src.x;
	this.y = src.y;
	this.z = src.z;
	this.w = src.w;
};

away.core.geom.Vector3D.prototype.crossProduct = function(a) {
	return new away.core.geom.Vector3D(this.y * a.z - this.z * a.y, this.z * a.x - this.x * a.z, this.x * a.y - this.y * a.x, 1);
};

away.core.geom.Vector3D.prototype.decrementBy = function(a) {
	this.x -= a.x;
	this.y -= a.y;
	this.z -= a.z;
};

away.core.geom.Vector3D.distance = function(pt1, pt2) {
	var x = (pt1.x - pt2.x);
	var y = (pt1.y - pt2.y);
	var z = (pt1.z - pt2.z);
	return Math.sqrt(x * x + y * y + z * z);
};

away.core.geom.Vector3D.prototype.dotProduct = function(a) {
	return this.x * a.x + this.y * a.y + this.z * a.z;
};

away.core.geom.Vector3D.prototype.equals = function(cmp, allFour) {
	return (this.x == cmp.x && this.y == cmp.y && this.z == cmp.z && (!allFour || this.w == cmp.w));
};

away.core.geom.Vector3D.prototype.incrementBy = function(a) {
	this.x += a.x;
	this.y += a.y;
	this.z += a.z;
};

away.core.geom.Vector3D.prototype.nearEquals = function(cmp, epsilon, allFour) {
	return ((Math.abs(this.x - cmp.x) < epsilon) && (Math.abs(this.y - cmp.y) < epsilon) && (Math.abs(this.z - cmp.z) < epsilon) && (!allFour || Math.abs(this.w - cmp.w) < epsilon));
};

away.core.geom.Vector3D.prototype.negate = function() {
	this.x = -this.x;
	this.y = -this.y;
	this.z = -this.z;
};

away.core.geom.Vector3D.prototype.normalize = function() {
	var invLength = 1 / this.get_length();
	if (invLength != 0) {
		this.x *= invLength;
		this.y *= invLength;
		this.z *= invLength;
		return;
	}
	throw "Cannot divide by zero.";
};

away.core.geom.Vector3D.prototype.project = function() {
	this.x /= this.w;
	this.y /= this.w;
	this.z /= this.w;
};

away.core.geom.Vector3D.prototype.scaleBy = function(s) {
	this.x *= s;
	this.y *= s;
	this.z *= s;
};

away.core.geom.Vector3D.prototype.setTo = function(xa, ya, za) {
	this.x = xa;
	this.y = ya;
	this.z = za;
};

away.core.geom.Vector3D.prototype.subtract = function(a) {
	return new away.core.geom.Vector3D(this.x - a.x, this.y - a.y, this.z - a.z, 0);
};

away.core.geom.Vector3D.prototype.toString = function() {
	return "[Vector3D] (x:" + this.x + " ,y:" + this.y + ", z" + this.z + ", w:" + this.w + ")";
};

away.core.geom.Vector3D.className = "away.core.geom.Vector3D";

away.core.geom.Vector3D.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.core.geom.Vector3D.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.core.geom.Vector3D.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'x', t:'Number'});
			p.push({n:'y', t:'Number'});
			p.push({n:'z', t:'Number'});
			p.push({n:'w', t:'Number'});
			break;
		default:
			p = [];
			break;
	}
	return p;
};

