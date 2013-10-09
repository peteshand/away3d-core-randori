/** Compiled by the Randori compiler v0.2.5.2 on Wed Oct 09 20:30:41 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.core == "undefined")
	away.core = {};
if (typeof away.core.data == "undefined")
	away.core.data = {};

away.core.data.RenderableListItemPool = function() {
	this._pool = null;
	this._poolSize = 0;
	this._index = 0;
	this._pool = [];
};

away.core.data.RenderableListItemPool.prototype.getItem = function() {
	if (this._index == this._poolSize) {
		var item = new away.core.data.RenderableListItem();
		this._pool[this._index++] = item;
		++this._poolSize;
		return item;
	} else {
		return this._pool[this._index++];
	}
};

away.core.data.RenderableListItemPool.prototype.freeAll = function() {
	this._index = 0;
};

away.core.data.RenderableListItemPool.prototype.dispose = function() {
	this._pool.length = 0;
};

away.core.data.RenderableListItemPool.className = "away.core.data.RenderableListItemPool";

away.core.data.RenderableListItemPool.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.core.data.RenderableListItem');
	return p;
};

away.core.data.RenderableListItemPool.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.core.data.RenderableListItemPool.injectionPoints = function(t) {
	return [];
};
