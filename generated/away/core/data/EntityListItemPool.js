/** Compiled by the Randori compiler v0.2.5.2 on Wed Oct 09 20:30:39 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.core == "undefined")
	away.core = {};
if (typeof away.core.data == "undefined")
	away.core.data = {};

away.core.data.EntityListItemPool = function() {
	this._pool = null;
	this._poolSize = 0;
	this._index = 0;
	this._pool = [];
};

away.core.data.EntityListItemPool.prototype.getItem = function() {
	var item;
	if (this._index == this._poolSize) {
		item = new away.core.data.EntityListItem();
		this._pool[this._index++] = item;
		++this._poolSize;
	} else {
		item = this._pool[this._index++];
	}
	return item;
};

away.core.data.EntityListItemPool.prototype.freeAll = function() {
	this._index = 0;
};

away.core.data.EntityListItemPool.prototype.dispose = function() {
	this._pool.length = 0;
};

away.core.data.EntityListItemPool.className = "away.core.data.EntityListItemPool";

away.core.data.EntityListItemPool.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.core.data.EntityListItem');
	return p;
};

away.core.data.EntityListItemPool.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.core.data.EntityListItemPool.injectionPoints = function(t) {
	return [];
};
