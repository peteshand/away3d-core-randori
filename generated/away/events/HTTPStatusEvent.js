/** Compiled by the Randori compiler v0.2.6.2 on Tue Sep 10 22:28:04 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.events == "undefined")
	away.events = {};

away.events.HTTPStatusEvent = function(type, status) {
	away.events.Event.call(this, type);
	this.status = status;
};

away.events.HTTPStatusEvent.HTTP_STATUS = "HTTPStatusEvent_HTTP_STATUS";

$inherit(away.events.HTTPStatusEvent, away.events.Event);

away.events.HTTPStatusEvent.className = "away.events.HTTPStatusEvent";

away.events.HTTPStatusEvent.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.events.HTTPStatusEvent.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.events.HTTPStatusEvent.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'type', t:'String'});
			p.push({n:'status', t:'Number'});
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

