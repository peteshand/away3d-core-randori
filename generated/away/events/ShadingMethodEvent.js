/** Compiled by the Randori compiler v0.2.6.2 on Tue Sep 24 23:06:48 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.events == "undefined")
	away.events = {};

away.events.ShadingMethodEvent = function(type) {
	away.events.Event.call(this, type);
};

away.events.ShadingMethodEvent.SHADER_INVALIDATED = "ShaderInvalidated";

$inherit(away.events.ShadingMethodEvent, away.events.Event);

away.events.ShadingMethodEvent.className = "away.events.ShadingMethodEvent";

away.events.ShadingMethodEvent.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.events.ShadingMethodEvent.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.events.ShadingMethodEvent.injectionPoints = function(t) {
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

