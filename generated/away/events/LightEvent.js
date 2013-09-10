/** Compiled by the Randori compiler v0.2.6.2 on Thu Sep 05 22:21:01 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.events == "undefined")
	away.events = {};

away.events.LightEvent = function(type) {
	away.events.Event.call(this, type);
};

away.events.LightEvent.CASTS_SHADOW_CHANGE = "castsShadowChange";

away.events.LightEvent.prototype.clone = function() {
	return new away.events.LightEvent(this.type);
};

$inherit(away.events.LightEvent, away.events.Event);

away.events.LightEvent.className = "away.events.LightEvent";

away.events.LightEvent.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.events.LightEvent.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.events.LightEvent.injectionPoints = function(t) {
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

