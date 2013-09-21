/** Compiled by the Randori compiler v0.2.6.2 on Sat Sep 21 16:02:33 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.events == "undefined")
	away.events = {};

away.events.EventDispatcher = function() {
	this.listeners = [];
	this.lFncLength = 0;
	
};

away.events.EventDispatcher.prototype.addEventListener = function(type, listener, target) {
	if (this.listeners[type] === undefined) {
		this.listeners[type] = [];
	}
	if (this.getEventListenerIndex(type, $createStaticDelegate(this, listener), target) === -1) {
		var d = new away.events.EventData();
		d.listener = listener;
		d.type = type;
		d.target = target;
		this.listeners[type].push(d);
	}
};

away.events.EventDispatcher.prototype.removeEventListener = function(type, listener, target) {
	var index = this.getEventListenerIndex(type, $createStaticDelegate(this, listener), target);
	if (index !== -1) {
		this.listeners[type].splice(index, 1);
	}
};

away.events.EventDispatcher.prototype.dispatchEvent = function(event) {
	var listenerArray = this.listeners[event.type];
	if (listenerArray != null) {
		this.lFncLength = listenerArray.length;
		event.target = this;
		var eventData;
		for (var i = 0; i < this.lFncLength; ++i) {
			eventData = listenerArray[i];
			eventData.listener.call(eventData.target, event);
		}
	}
};

away.events.EventDispatcher.prototype.getEventListenerIndex = function(type, listener, target) {
	if (this.listeners[type] !== undefined) {
		var a = this.listeners[type];
		var l = a.length;
		var d;
		for (var c = 0; c < l; c++) {
			d = a[c];
			if (target == d.target && listener == d.listener) {
				return c;
			}
		}
	}
	return -1;
};

away.events.EventDispatcher.prototype.hasEventListener = function(type, listener, target) {
	if (this.listeners != null && target != null) {
		return (this.getEventListenerIndex(type, $createStaticDelegate(this, listener), target) !== -1);
	} else {
		if (this.listeners[type] !== undefined) {
			var a = this.listeners[type];
			return (a.length > 0);
		}
		return false;
	}
	return false;
};

away.events.EventDispatcher.className = "away.events.EventDispatcher";

away.events.EventDispatcher.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.events.EventData');
	return p;
};

away.events.EventDispatcher.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.events.EventDispatcher.injectionPoints = function(t) {
	return [];
};
