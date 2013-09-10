/** Compiled by the Randori compiler v0.2.6.2 on Tue Sep 10 22:28:15 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.animators == "undefined")
	away.animators = {};
if (typeof away.animators.nodes == "undefined")
	away.animators.nodes = {};

away.animators.nodes.AnimationNodeBase = function() {
	this._stateClass = null;
	away.library.assets.NamedAssetBase.call(this);
};

away.animators.nodes.AnimationNodeBase.prototype.get_stateClass = function() {
	return this._stateClass;
};

away.animators.nodes.AnimationNodeBase.prototype.dispose = function() {
};

away.animators.nodes.AnimationNodeBase.prototype.get_assetType = function() {
	return away.library.assets.AssetType.ANIMATION_NODE;
};

$inherit(away.animators.nodes.AnimationNodeBase, away.library.assets.NamedAssetBase);

away.animators.nodes.AnimationNodeBase.className = "away.animators.nodes.AnimationNodeBase";

away.animators.nodes.AnimationNodeBase.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.library.assets.AssetType');
	return p;
};

away.animators.nodes.AnimationNodeBase.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.animators.nodes.AnimationNodeBase.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 1:
			p = away.library.assets.NamedAssetBase.injectionPoints(t);
			break;
		case 2:
			p = away.library.assets.NamedAssetBase.injectionPoints(t);
			break;
		case 3:
			p = away.library.assets.NamedAssetBase.injectionPoints(t);
			break;
		default:
			p = [];
			break;
	}
	return p;
};

