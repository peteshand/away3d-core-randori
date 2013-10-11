/** Compiled by the Randori compiler v0.2.5.2 on Sat Oct 12 02:16:06 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.events == "undefined")
	away.events = {};

away.events.ParserEvent = function(type, message) {
	this._message = null;
	message = message || "";
	away.events.Event.call(this, type);
	this._message = message;
};

away.events.ParserEvent.PARSE_COMPLETE = "parseComplete";

away.events.ParserEvent.PARSE_ERROR = "parseError";

away.events.ParserEvent.READY_FOR_DEPENDENCIES = "readyForDependencies";

away.events.ParserEvent.prototype.get_message = function() {
	return this._message;
};

away.events.ParserEvent.prototype.clone = function() {
	return new away.events.ParserEvent(this.type, this.get_message());
};

$inherit(away.events.ParserEvent, away.events.Event);

away.events.ParserEvent.className = "away.events.ParserEvent";

away.events.ParserEvent.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.events.ParserEvent.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.events.ParserEvent.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'type', t:'String'});
			p.push({n:'message', t:'String'});
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

