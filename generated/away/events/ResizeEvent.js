/** Compiled by the Randori compiler v0.2.6.2 on Sun Sep 22 11:20:01 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.events == "undefined")
	away.events = {};

away.events.ResizeEvent = function(type, oldHeight, oldWidth) {
	this._oldHeight = 0;
	this._oldWidth = 0;
	oldHeight = oldHeight || NaN;
	oldWidth = oldWidth || NaN;
	away.events.Event.call(this, type);
	this._oldHeight = oldHeight;
	this._oldWidth = oldWidth;
};

away.events.ResizeEvent.RESIZE = "resize";

away.events.ResizeEvent.prototype.get_oldHeight = function() {
	return this._oldHeight;
};

away.events.ResizeEvent.prototype.get_oldWidth = function() {
	return this._oldWidth;
};

$inherit(away.events.ResizeEvent, away.events.Event);

away.events.ResizeEvent.className = "away.events.ResizeEvent";

away.events.ResizeEvent.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.events.ResizeEvent.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.events.ResizeEvent.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'type', t:'String'});
			p.push({n:'oldHeight', t:'Number'});
			p.push({n:'oldWidth', t:'Number'});
			break;
		case 1:
			p = away.events.Event.injectionPoints(t);
			break;
		case 2:
			p = away.events.Event.injectionPoints(t);
			break;
		case 3:
			p = away.events.Event.injectionPoints(t);
			break;
		default:
			p = [];
			break;
	}
	return p;
};

