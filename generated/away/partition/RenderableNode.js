/** Compiled by the Randori compiler v0.2.6.2 on Sat Sep 21 16:02:16 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.partition == "undefined")
	away.partition = {};

away.partition.RenderableNode = function(renderable) {
	this._renderable = null;
	var e = renderable;
	away.partition.EntityNode.call(this, e);
	this._renderable = renderable;
};

away.partition.RenderableNode.prototype.acceptTraverser = function(traverser) {
	if (traverser.enterNode(this)) {
		away.partition.EntityNode.prototype.acceptTraverser.call(this,traverser);
		traverser.applyRenderable(this._renderable);
	}
};

$inherit(away.partition.RenderableNode, away.partition.EntityNode);

away.partition.RenderableNode.className = "away.partition.RenderableNode";

away.partition.RenderableNode.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.partition.RenderableNode.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.partition.RenderableNode.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'renderable', t:'away.base.IRenderable'});
			break;
		case 1:
			p = away.partition.EntityNode.injectionPoints(t);
			break;
		case 2:
			p = away.partition.EntityNode.injectionPoints(t);
			break;
		case 3:
			p = away.partition.EntityNode.injectionPoints(t);
			break;
		default:
			p = [];
			break;
	}
	return p;
};

