/** Compiled by the Randori compiler v0.2.5.2 on Wed Oct 09 20:30:37 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.primitives == "undefined")
	away.primitives = {};

away.primitives.WireframePrimitiveBase = function(color, thickness) {
	this._thickness = 0;
	this._color = 0;
	this._geomDirty = true;
	color = color || 0xffffff;
	thickness = thickness || 1;
	away.entities.SegmentSet.call(this);
	if (thickness <= 0) {
		thickness = 1;
	}
	this._color = color;
	this._thickness = thickness;
	this.set_mouseChildren(false);
	this.set_mouseEnabled(this.get_mouseChildren());
};

away.primitives.WireframePrimitiveBase.prototype.get_color = function() {
	return this._color;
};

away.primitives.WireframePrimitiveBase.prototype.set_color = function(value) {
	this._color = value;
	for (var segRef in this._pSegments) {
		segRef.segment.endColor = value;
		segRef.segment.startColor = segRef.segment.endColor;
	}
};

away.primitives.WireframePrimitiveBase.prototype.get_thickness = function() {
	return this._thickness;
};

away.primitives.WireframePrimitiveBase.prototype.set_thickness = function(value) {
	this._thickness = value;
	for (var segRef in this._pSegments) {
		segRef.segment.thickness = value;
		segRef.segment.thickness = segRef.segment.thickness;
	}
};

away.primitives.WireframePrimitiveBase.prototype.removeAllSegments = function() {
	away.entities.SegmentSet.prototype.removeAllSegments.call(this);
};

away.primitives.WireframePrimitiveBase.prototype.getBounds = function() {
	if (this._geomDirty) {
		this.updateGeometry();
	}
	return away.entities.SegmentSet.prototype.getBounds.call(this);
};

away.primitives.WireframePrimitiveBase.prototype.pBuildGeometry = function() {
	throw new away.errors.AbstractMethodError(null, 0);
};

away.primitives.WireframePrimitiveBase.prototype.pInvalidateGeometry = function() {
	this._geomDirty = true;
	this.pInvalidateBounds();
};

away.primitives.WireframePrimitiveBase.prototype.updateGeometry = function() {
	this.pBuildGeometry();
	this._geomDirty = false;
};

away.primitives.WireframePrimitiveBase.prototype.pUpdateOrAddSegment = function(index, v0, v1) {
	var segment;
	var s;
	var e;
	if ((segment = this.getSegment(index)) != null) {
		s = segment.get_start();
		e = segment.get_end();
		s.x = v0.x;
		s.y = v0.y;
		s.z = v0.z;
		e.x = v1.x;
		e.y = v1.y;
		e.z = v1.z;
		segment.updateSegment(s, e, null, this._color, this._color, this._thickness);
	} else {
		this.addSegment(new away.primitives.LineSegment(v0.clone(), v1.clone(), this._color, this._color, this._thickness));
	}
};

away.primitives.WireframePrimitiveBase.prototype.pUpdateMouseChildren = function() {
	this._iAncestorsAllowMouseEnabled = false;
};

$inherit(away.primitives.WireframePrimitiveBase, away.entities.SegmentSet);

away.primitives.WireframePrimitiveBase.className = "away.primitives.WireframePrimitiveBase";

away.primitives.WireframePrimitiveBase.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.primitives.LineSegment');
	p.push('away.errors.AbstractMethodError');
	return p;
};

away.primitives.WireframePrimitiveBase.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.primitives.WireframePrimitiveBase.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'color', t:'Number'});
			p.push({n:'thickness', t:'Number'});
			break;
		case 1:
			p = away.entities.SegmentSet.injectionPoints(t);
			break;
		case 2:
			p = away.entities.SegmentSet.injectionPoints(t);
			break;
		case 3:
			p = away.entities.SegmentSet.injectionPoints(t);
			break;
		default:
			p = [];
			break;
	}
	return p;
};

