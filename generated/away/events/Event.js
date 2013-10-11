/** Compiled by the Randori compiler v0.2.5.2 on Sat Oct 12 02:16:01 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.events == "undefined")
	away.events = {};

away.events.Event = function(type) {
	this.target = undefined;
	this.type = type;
};

away.events.Event.COMPLETE = "Event_Complete";

away.events.Event.OPEN = "Event_Open";

away.events.Event.ENTER_FRAME = "enterframe";

away.events.Event.EXIT_FRAME = "exitframe";

away.events.Event.RESIZE = "resize";

away.events.Event.CONTEXT3D_CREATE = "context3DCreate";

away.events.Event.ERROR = "error";

away.events.Event.CHANGE = "change";

away.events.Event.prototype.clone = function() {
	return new away.events.Event(this.type);
};

away.events.Event.className = "away.events.Event";

away.events.Event.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.events.Event.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.events.Event.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'type', t:'String'});
			break;
		default:
			p = [];
			break;
	}
	return p;
};

