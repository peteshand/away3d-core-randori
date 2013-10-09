/** Compiled by the Randori compiler v0.2.5.2 on Wed Oct 09 20:30:40 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.events == "undefined")
	away.events = {};

away.events.ProgressEvent = function(type) {
	this.bytesLoaded = 0;
	this.bytesTotal = 0;
	away.events.Event.call(this, type);
};

away.events.ProgressEvent.PROGRESS = "ProgressEvent_progress";

$inherit(away.events.ProgressEvent, away.events.Event);

away.events.ProgressEvent.className = "away.events.ProgressEvent";

away.events.ProgressEvent.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.events.ProgressEvent.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.events.ProgressEvent.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'type', t:'String'});
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

