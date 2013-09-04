/** Compiled by the Randori compiler v0.2.6.2 on Wed Sep 04 21:18:29 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.data == "undefined")
	away.data = {};

away.data.RenderableListItemPool = function() {
	this._pool = null;
	this._poolSize = 0;
	this._index = 0;
	this._pool = [];
};

away.data.RenderableListItemPool.prototype.getItem = function() {
	if (this._index == this._poolSize) {
		var item = new away.data.RenderableListItem();
		this._pool[this._index++] = item;
		++this._poolSize;
		return item;
	} else {
		return this._pool[this._index++];
	}
};

away.data.RenderableListItemPool.prototype.freeAll = function() {
	this._index = 0;
};

away.data.RenderableListItemPool.prototype.dispose = function() {
	this._pool.length = 0;
};

away.data.RenderableListItemPool.className = "away.data.RenderableListItemPool";

away.data.RenderableListItemPool.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.data.RenderableListItem');
	return p;
};

away.data.RenderableListItemPool.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.data.RenderableListItemPool.injectionPoints = function(t) {
	return [];
};
