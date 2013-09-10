/** Compiled by the Randori compiler v0.2.6.2 on Tue Sep 10 22:28:05 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.events == "undefined")
	away.events = {};

away.events.LoaderEvent = function(type, url, isDependency, errmsg) {
	this._url = null;
	this._isDependency = null;
	this._message = null;
	this._isDefaultPrevented = null;
	away.events.Event.call(this, type);
	this._url = url;
	this._message = errmsg;
	this._isDependency = isDependency;
};

away.events.LoaderEvent.LOAD_ERROR = "loadError";

away.events.LoaderEvent.RESOURCE_COMPLETE = "resourceComplete";

away.events.LoaderEvent.DEPENDENCY_COMPLETE = "dependencyComplete";

away.events.LoaderEvent.prototype.get_url = function() {
	return this._url;
};

away.events.LoaderEvent.prototype.get_message = function() {
	return this._message;
};

away.events.LoaderEvent.prototype.get_isDependency = function() {
	return this._isDependency;
};

away.events.LoaderEvent.prototype.clone = function() {
	return new away.events.LoaderEvent(this.type, this._url, this._isDependency, this._message);
};

$inherit(away.events.LoaderEvent, away.events.Event);

away.events.LoaderEvent.className = "away.events.LoaderEvent";

away.events.LoaderEvent.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.events.LoaderEvent.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.events.LoaderEvent.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'type', t:'String'});
			p.push({n:'url', t:'String'});
			p.push({n:'isDependency', t:'Boolean'});
			p.push({n:'errmsg', t:'String'});
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

