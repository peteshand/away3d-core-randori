/** Compiled by the Randori compiler v0.2.6.2 on Sat Sep 28 11:54:27 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.utils == "undefined")
	away.utils = {};

away.utils.Debug = function() {
	this.keyword = null;
	
};

away.utils.Debug.THROW_ERRORS = true;

away.utils.Debug.ENABLE_LOG = true;

away.utils.Debug.LOG_PI_ERRORS = true;

away.utils.Debug.keyword = null;

away.utils.Debug.breakpoint = function() {
	away.utils.Debug["break"]();
};

away.utils.Debug.throwPIROnKeyWordOnly = function(str, enable) {
	enable = enable || true;
	if (!enable) {
		away.utils.Debug.keyword = null;
	} else {
		away.utils.Debug.keyword = str;
	}
};

away.utils.Debug.throwPIR = function(clss, fnc, msg) {
	away.utils.Debug.logPIR("PartialImplementationError " + clss, fnc, msg);
	if (away.utils.Debug.THROW_ERRORS) {
		if (away.utils.Debug.keyword) {
			var e = clss + fnc + msg;
			if (e.indexOf(away.utils.Debug.keyword, 0) == -1) {
				return;
			}
		}
		throw new away.errors.PartialImplementationError(clss + "." + fnc + ": " + msg, 0);
	}
};

away.utils.Debug.logPIR = function(clss, fnc, msg) {
	msg = msg || "";
	if (away.utils.Debug.LOG_PI_ERRORS) {
		console.log(clss + "." + fnc + ": " + msg);
	}
};

away.utils.Debug.log = function(args) {
	if (away.utils.Debug.ENABLE_LOG) {
		console.log.apply(console, arguments);
	}
};

away.utils.Debug.className = "away.utils.Debug";

away.utils.Debug.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.utils.Debug');
	p.push('away.errors.PartialImplementationError');
	return p;
};

away.utils.Debug.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.utils.Debug.injectionPoints = function(t) {
	return [];
};
