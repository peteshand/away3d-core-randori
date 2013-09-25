/** Compiled by the Randori compiler v0.2.6.2 on Tue Sep 24 23:07:00 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.animators == "undefined")
	away.animators = {};
if (typeof away.animators.states == "undefined")
	away.animators.states = {};

away.animators.states.AnimationStateBase = function(animator, animationNode) {
	this._positionDeltaDirty = true;
	this._startTime = 0;
	this._rootDelta = new away.geom.Vector3D(0, 0, 0, 0);
	this._time = 0;
	this._animationNode = null;
	this._animator = null;
	this._animator = animator;
	this._animationNode = animationNode;
};

away.animators.states.AnimationStateBase.prototype.get_positionDelta = function() {
	if (this._positionDeltaDirty) {
		this.pUpdatePositionDelta();
	}
	return this._rootDelta;
};

away.animators.states.AnimationStateBase.prototype.offset = function(startTime) {
	this._startTime = startTime;
	this._positionDeltaDirty = true;
};

away.animators.states.AnimationStateBase.prototype.update = function(time) {
	if (this._time == time - this._startTime) {
		return;
	}
	this.pUpdateTime(time);
};

away.animators.states.AnimationStateBase.prototype.phase = function(value) {
};

away.animators.states.AnimationStateBase.prototype.pUpdateTime = function(time) {
	this._time = time - this._startTime;
	this._positionDeltaDirty = true;
};

away.animators.states.AnimationStateBase.prototype.pUpdatePositionDelta = function() {
};

away.animators.states.AnimationStateBase.className = "away.animators.states.AnimationStateBase";

away.animators.states.AnimationStateBase.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.animators.states.AnimationStateBase.getStaticDependencies = function(t) {
	var p;
	p = [];
	p.push('away.geom.Vector3D');
	return p;
};

away.animators.states.AnimationStateBase.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'animator', t:'away.animators.IAnimator'});
			p.push({n:'animationNode', t:'away.animators.nodes.AnimationNodeBase'});
			break;
		default:
			p = [];
			break;
	}
	return p;
};

