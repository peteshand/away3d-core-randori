/** Compiled by the Randori compiler v0.2.6.2 on Sat Sep 21 16:02:33 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.events == "undefined")
	away.events = {};

away.events.LensEvent = function(type, lens) {
	this._lens = null;
	away.events.Event.call(this, type);
	this._lens = lens;
};

away.events.LensEvent.MATRIX_CHANGED = "matrixChanged";

away.events.LensEvent.prototype.get_lens = function() {
	return this._lens;
};

$inherit(away.events.LensEvent, away.events.Event);

away.events.LensEvent.className = "away.events.LensEvent";

away.events.LensEvent.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.events.LensEvent.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.events.LensEvent.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'type', t:'String'});
			p.push({n:'lens', t:'away.cameras.lenses.LensBase'});
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

