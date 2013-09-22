/** Compiled by the Randori compiler v0.2.6.2 on Sun Sep 22 11:19:58 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.events == "undefined")
	away.events = {};

away.events.TimerEvent = function(type) {
	away.events.Event.call(this, type);
};

away.events.TimerEvent.TIMER = "timer";

away.events.TimerEvent.TIMER_COMPLETE = "timerComplete";

$inherit(away.events.TimerEvent, away.events.Event);

away.events.TimerEvent.className = "away.events.TimerEvent";

away.events.TimerEvent.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.events.TimerEvent.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.events.TimerEvent.injectionPoints = function(t) {
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

