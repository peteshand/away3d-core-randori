/** Compiled by the Randori compiler v0.2.5.2 on Wed Oct 09 20:30:39 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.library == "undefined")
	away.library = {};
if (typeof away.library.naming == "undefined")
	away.library.naming = {};

away.library.naming.ConflictStrategy = function() {
	
};

away.library.naming.ConflictStrategy.APPEND_NUM_SUFFIX = new away.library.naming.NumSuffixConflictStrategy(".");

away.library.naming.ConflictStrategy.IGNORE = new away.library.naming.IgnoreConflictStrategy();

away.library.naming.ConflictStrategy.THROW_ERROR = new away.library.naming.ErrorConflictStrategy();

away.library.naming.ConflictStrategy.className = "away.library.naming.ConflictStrategy";

away.library.naming.ConflictStrategy.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.library.naming.ConflictStrategy.getStaticDependencies = function(t) {
	var p;
	p = [];
	p.push('away.library.naming.IgnoreConflictStrategy');
	p.push('away.library.naming.NumSuffixConflictStrategy');
	p.push('away.library.naming.ErrorConflictStrategy');
	return p;
};

away.library.naming.ConflictStrategy.injectionPoints = function(t) {
	return [];
};
