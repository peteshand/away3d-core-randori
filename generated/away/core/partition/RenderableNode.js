/** Compiled by the Randori compiler v0.2.5.2 on Sat Oct 12 02:16:04 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.core == "undefined")
	away.core = {};
if (typeof away.core.partition == "undefined")
	away.core.partition = {};

away.core.partition.RenderableNode = function(renderable) {
	this._renderable = null;
	var e = renderable;
	away.core.partition.EntityNode.call(this, e);
	this._renderable = renderable;
};

away.core.partition.RenderableNode.prototype.acceptTraverser = function(traverser) {
	if (traverser.enterNode(this)) {
		away.core.partition.EntityNode.prototype.acceptTraverser.call(this,traverser);
		traverser.applyRenderable(this._renderable);
	}
};

$inherit(away.core.partition.RenderableNode, away.core.partition.EntityNode);

away.core.partition.RenderableNode.className = "away.core.partition.RenderableNode";

away.core.partition.RenderableNode.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.core.partition.RenderableNode.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.core.partition.RenderableNode.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'renderable', t:'away.core.base.IRenderable'});
			break;
		case 1:
			p = away.core.partition.EntityNode.injectionPoints(t);
			break;
		case 2:
			p = away.core.partition.EntityNode.injectionPoints(t);
			break;
		case 3:
			p = away.core.partition.EntityNode.injectionPoints(t);
			break;
		default:
			p = [];
			break;
	}
	return p;
};

