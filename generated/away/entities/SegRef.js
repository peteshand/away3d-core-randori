/** Compiled by the Randori compiler v0.2.5.2 on Wed Oct 09 20:30:39 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.entities == "undefined")
	away.entities = {};

away.entities.SegRef = function() {
	this.index = 0;
	this.subSetIndex = 0;
	this.segment = null;
	
};

away.entities.SegRef.className = "away.entities.SegRef";

away.entities.SegRef.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.entities.SegRef.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.entities.SegRef.injectionPoints = function(t) {
	return [];
};
