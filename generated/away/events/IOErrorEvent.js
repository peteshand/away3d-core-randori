/** Compiled by the Randori compiler v0.2.6.2 on Tue Sep 10 22:28:10 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.events == "undefined")
	away.events = {};

away.events.IOErrorEvent = function(type) {
	away.events.Event.call(this, type);
};

away.events.IOErrorEvent.IO_ERROR = "IOErrorEvent_IO_ERROR";

$inherit(away.events.IOErrorEvent, away.events.Event);

away.events.IOErrorEvent.className = "away.events.IOErrorEvent";

away.events.IOErrorEvent.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.events.IOErrorEvent.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.events.IOErrorEvent.injectionPoints = function(t) {
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

