/** Compiled by the Randori compiler v0.2.6.2 on Mon Sep 02 23:32:13 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.events == "undefined")
	away.events = {};

away.events.EventData = function() {
	this.listener = null;
	this.target = null;
	this.type = null;
	
};

away.events.EventData.className = "away.events.EventData";

away.events.EventData.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.events.EventData.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.events.EventData.injectionPoints = function(t) {
	return [];
};