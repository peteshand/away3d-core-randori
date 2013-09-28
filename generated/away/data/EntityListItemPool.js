/** Compiled by the Randori compiler v0.2.6.2 on Sat Sep 28 11:54:22 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.data == "undefined")
	away.data = {};

away.data.EntityListItemPool = function() {
	this._pool = null;
	this._poolSize = 0;
	this._index = 0;
	this._pool = [];
};

away.data.EntityListItemPool.prototype.getItem = function() {
	var item;
	if (this._index == this._poolSize) {
		item = new away.data.EntityListItem();
		this._pool[this._index++] = item;
		++this._poolSize;
	} else {
		item = this._pool[this._index++];
	}
	return item;
};

away.data.EntityListItemPool.prototype.freeAll = function() {
	this._index = 0;
};

away.data.EntityListItemPool.prototype.dispose = function() {
	this._pool.length = 0;
};

away.data.EntityListItemPool.className = "away.data.EntityListItemPool";

away.data.EntityListItemPool.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.data.EntityListItem');
	return p;
};

away.data.EntityListItemPool.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.data.EntityListItemPool.injectionPoints = function(t) {
	return [];
};
