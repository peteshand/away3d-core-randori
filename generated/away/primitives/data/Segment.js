/** Compiled by the Randori compiler v0.2.6.2 on Wed Sep 04 21:18:40 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.primitives == "undefined")
	away.primitives = {};
if (typeof away.primitives.data == "undefined")
	away.primitives.data = {};

away.primitives.data.Segment = function(start, end, anchor, colorStart, colorEnd, thickness) {
	this._pEndR = 0;
	this._subSetIndex = -1;
	this._pStartG = 0;
	this._pStartB = 0;
	this._pEnd = null;
	this._endColor = 0;
	this._pStart = null;
	this._pSegmentsBase = null;
	this._index = -1;
	this._startColor = 0;
	this._pEndB = 0;
	this._pEndG = 0;
	this._pStartR = 0;
	this._pThickness = 0;
	anchor = null;
	this._pThickness = thickness * 0.5;
	this._pStart = start;
	this._pEnd = end;
	this.set_startColor(colorStart);
	this.set_endColor(colorEnd);
};

away.primitives.data.Segment.prototype.updateSegment = function(start, end, anchor, colorStart, colorEnd, thickness) {
	anchor = null;
	this._pStart = start;
	this._pEnd = end;
	if (this._startColor != colorStart) {
		this.set_startColor(colorStart);
	}
	if (this._endColor != colorEnd) {
		this.set_endColor(colorEnd);
	}
	this._pThickness = thickness * 0.5;
	this.update();
};

away.primitives.data.Segment.prototype.get_start = function() {
	return this._pStart;
};

away.primitives.data.Segment.prototype.set_start = function(value) {
	this._pStart = value;
	this.update();
};

away.primitives.data.Segment.prototype.get_end = function() {
	return this._pEnd;
};

away.primitives.data.Segment.prototype.set_end = function(value) {
	this._pEnd = value;
	this.update();
};

away.primitives.data.Segment.prototype.get_thickness = function() {
	return this._pThickness * 2;
};

away.primitives.data.Segment.prototype.set_thickness = function(value) {
	this._pThickness = value * 0.5;
	this.update();
};

away.primitives.data.Segment.prototype.get_startColor = function() {
	return this._startColor;
};

away.primitives.data.Segment.prototype.set_startColor = function(color) {
	this._pStartR = ((color >> 16) & 0xff) / 255;
	this._pStartG = ((color >> 8) & 0xff) / 255;
	this._pStartB = (color & 0xff) / 255;
	this._startColor = color;
	this.update();
};

away.primitives.data.Segment.prototype.get_endColor = function() {
	return this._endColor;
};

away.primitives.data.Segment.prototype.set_endColor = function(color) {
	this._pEndR = ((color >> 16) & 0xff) / 255;
	this._pEndG = ((color >> 8) & 0xff) / 255;
	this._pEndB = (color & 0xff) / 255;
	this._endColor = color;
	this.update();
};

away.primitives.data.Segment.prototype.dispose = function() {
	this._pStart = null;
	this._pEnd = null;
};

away.primitives.data.Segment.prototype.get_iIndex = function() {
	return this._index;
};

away.primitives.data.Segment.prototype.set_iIndex = function(ind) {
	this._index = ind;
};

away.primitives.data.Segment.prototype.get_iSubSetIndex = function() {
	return this._subSetIndex;
};

away.primitives.data.Segment.prototype.set_iSubSetIndex = function(ind) {
	this._subSetIndex = ind;
};

away.primitives.data.Segment.prototype.set_iSegmentsBase = function(segBase) {
	this._pSegmentsBase = segBase;
};

away.primitives.data.Segment.prototype.update = function() {
	if (!this._pSegmentsBase) {
		return;
	}
	this._pSegmentsBase.iUpdateSegment(this);
};

away.primitives.data.Segment.className = "away.primitives.data.Segment";

away.primitives.data.Segment.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.primitives.data.Segment.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.primitives.data.Segment.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'start', t:'away.geom.Vector3D'});
			p.push({n:'end', t:'away.geom.Vector3D'});
			p.push({n:'anchor', t:'away.geom.Vector3D'});
			p.push({n:'colorStart', t:'Number'});
			p.push({n:'colorEnd', t:'Number'});
			p.push({n:'thickness', t:'Number'});
			break;
		default:
			p = [];
			break;
	}
	return p;
};

