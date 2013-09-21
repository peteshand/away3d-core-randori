/** Compiled by the Randori compiler v0.2.6.2 on Sat Sep 21 16:02:39 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.utils == "undefined")
	away.utils = {};

away.utils.Timer = function(delay, repeatCount) {
	this._running = false;
	this._iid = 0;
	this._repeatCount = 0;
	this._currentCount = 0;
	this._delay = 0;
	away.events.EventDispatcher.call(this);
	this._delay = delay;
	this._repeatCount = repeatCount;
	if (isNaN(delay) || delay < 0) {
		throw new away.errors.Error("Delay is negative or not a number", 0, "");
	}
};

away.utils.Timer.prototype.get_currentCount = function() {
	return this._currentCount;
};

away.utils.Timer.prototype.get_delay = function() {
	return this._delay;
};

away.utils.Timer.prototype.set_delay = function(value) {
	this._delay = value;
	if (this._running) {
		this.stop();
		this.start();
	}
};

away.utils.Timer.prototype.get_repeatCount = function() {
	return this._repeatCount;
};

away.utils.Timer.prototype.set_repeatCount = function(value) {
	this._repeatCount = value;
};

away.utils.Timer.prototype.reset = function() {
	if (this._running) {
		this.stop();
	}
	this._currentCount = 0;
};

away.utils.Timer.prototype.get_running = function() {
	return this._running;
};

away.utils.Timer.prototype.start = function() {
	this._running = true;
	clearInterval(this._iid);
	this._iid = setInterval($createStaticDelegate(this, this.tick), this._delay);
};

away.utils.Timer.prototype.stop = function() {
	this._running = false;
	clearInterval(this._iid);
};

away.utils.Timer.prototype.tick = function() {
	this._currentCount++;
	if ((this._repeatCount > 0) && this._currentCount >= this._repeatCount) {
		this.stop();
		this.dispatchEvent(new away.events.TimerEvent(away.events.TimerEvent.TIMER));
		this.dispatchEvent(new away.events.TimerEvent(away.events.TimerEvent.TIMER_COMPLETE));
	} else {
		this.dispatchEvent(new away.events.TimerEvent(away.events.TimerEvent.TIMER));
	}
};

$inherit(away.utils.Timer, away.events.EventDispatcher);

away.utils.Timer.className = "away.utils.Timer";

away.utils.Timer.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.events.TimerEvent');
	return p;
};

away.utils.Timer.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.utils.Timer.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'delay', t:'Number'});
			p.push({n:'repeatCount', t:'Number'});
			break;
		case 1:
			p = away.events.EventDispatcher.injectionPoints(t);
			break;
		case 2:
			p = away.events.EventDispatcher.injectionPoints(t);
			break;
		case 3:
			p = away.events.EventDispatcher.injectionPoints(t);
			break;
		default:
			p = [];
			break;
	}
	return p;
};

