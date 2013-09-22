/** Compiled by the Randori compiler v0.2.6.2 on Sun Sep 22 12:28:44 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.filters == "undefined")
	away.filters = {};

away.filters.Filter3DBase = function() {
	this._textureHeight = 0;
	this._requireDepthRender = null;
	this._tasks = null;
	this._textureWidth = 0;
	this._tasks = [];
};

away.filters.Filter3DBase.prototype.get_requireDepthRender = function() {
	return this._requireDepthRender;
};

away.filters.Filter3DBase.prototype.pAddTask = function(filter) {
	this._tasks.push(filter);
	if (this._requireDepthRender == null) {
		this._requireDepthRender = filter.get_requireDepthRender();
	}
};

away.filters.Filter3DBase.prototype.get_tasks = function() {
	return this._tasks;
};

away.filters.Filter3DBase.prototype.getMainInputTexture = function(stage3DProxy) {
	return this._tasks[0].getMainInputTexture(stage3DProxy);
};

away.filters.Filter3DBase.prototype.get_textureWidth = function() {
	return this._textureWidth;
};

away.filters.Filter3DBase.prototype.set_textureWidth = function(value) {
	this._textureWidth = value;
	for (var i = 0; i < this._tasks.length; ++i) {
		this._tasks[i].textureWidth = value;
	}
};

away.filters.Filter3DBase.prototype.get_textureHeight = function() {
	return this._textureHeight;
};

away.filters.Filter3DBase.prototype.set_textureHeight = function(value) {
	this._textureHeight = value;
	for (var i = 0; i < this._tasks.length; ++i) {
		this._tasks[i].textureHeight = value;
	}
};

away.filters.Filter3DBase.prototype.setRenderTargets = function(mainTarget, stage3DProxy) {
	this._tasks[this._tasks.length - 1].target = mainTarget;
};

away.filters.Filter3DBase.prototype.dispose = function() {
	for (var i = 0; i < this._tasks.length; ++i) {
		this._tasks[i].dispose();
	}
};

away.filters.Filter3DBase.prototype.update = function(stage, camera) {
};

away.filters.Filter3DBase.className = "away.filters.Filter3DBase";

away.filters.Filter3DBase.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.filters.Filter3DBase.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.filters.Filter3DBase.injectionPoints = function(t) {
	return [];
};
