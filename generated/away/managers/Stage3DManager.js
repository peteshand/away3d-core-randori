/** Compiled by the Randori compiler v0.2.6.2 on Mon Sep 02 23:32:26 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.managers == "undefined")
	away.managers = {};

away.managers.Stage3DManager = function(stage, stage3DManagerSingletonEnforcer) {
	this._stageProxies = null;
	this._numStageProxies = 0;
	this._stage = null;
	this._instances = null;
	if (!stage3DManagerSingletonEnforcer) {
		throw new Error("This class is a multiton and cannot be instantiated manually. Use Stage3DManager.getInstance instead.", 0);
	}
	this._stage = stage;
	if (!away.managers.Stage3DManager._stageProxies) {
		away.managers.Stage3DManager._stageProxies = [];
	}
};

away.managers.Stage3DManager._instances;

away.managers.Stage3DManager._stageProxies;

away.managers.Stage3DManager._numStageProxies = 0;

away.managers.Stage3DManager.getInstance = function(stage) {
	var stage3dManager = away.managers.Stage3DManager.getStage3DManagerByStageRef(stage);
	if (stage3dManager == null) {
		stage3dManager = new away.managers.Stage3DManager(stage, new away.managers.Stage3DManagerSingletonEnforcer());
		var stageInstanceData = new away.managers.Stage3DManagerInstanceData();
		stageInstanceData.stage = stage;
		stageInstanceData.stage3DManager = stage3dManager;
		away.managers.Stage3DManager._instances.push(stageInstanceData);
	}
	return stage3dManager;
};

away.managers.Stage3DManager.getStage3DManagerByStageRef = function(stage) {
	if (away.managers.Stage3DManager._instances == null) {
		away.managers.Stage3DManager._instances = [];
	}
	var l = away.managers.Stage3DManager._instances.length;
	var s;
	for (var c = 0; c < l; c++) {
		s = away.managers.Stage3DManager._instances[c];
		if (s.stage == stage) {
			return s.stage3DManager;
		}
	}
	return null;
};

away.managers.Stage3DManager.prototype.getStage3DProxy = function(index, forceSoftware, profile) {
	if (!away.managers.Stage3DManager._stageProxies[index]) {
		away.managers.Stage3DManager._numStageProxies++;
		away.managers.Stage3DManager._stageProxies[index] = new away.managers.Stage3DProxy(index, this._stage.stage3Ds[index], this, forceSoftware, profile);
	}
	return away.managers.Stage3DManager._stageProxies[index];
};

away.managers.Stage3DManager.prototype.iRemoveStage3DProxy = function(stage3DProxy) {
	away.managers.Stage3DManager._numStageProxies--;
	away.managers.Stage3DManager._stageProxies[stage3DProxy._iStage3DIndex] = null;
};

away.managers.Stage3DManager.prototype.getFreeStage3DProxy = function(forceSoftware, profile) {
	var i = 0;
	var len = away.managers.Stage3DManager._stageProxies.length;
	while (i < len) {
		if (!away.managers.Stage3DManager._stageProxies[i]) {
			this.getStage3DProxy(i, forceSoftware, profile);
			away.managers.Stage3DManager._stageProxies[i].width = this._stage.get_stageWidth();
			away.managers.Stage3DManager._stageProxies[i].height = this._stage.get_stageHeight();
			return away.managers.Stage3DManager._stageProxies[i];
		}
		++i;
	}
	throw new Error("Too many Stage3D instances used!", 0);
	return null;
};

away.managers.Stage3DManager.prototype.get_hasFreeStage3DProxy = function() {
	return away.managers.Stage3DManager._numStageProxies < away.managers.Stage3DManager._stageProxies.length ? true : false;
};

away.managers.Stage3DManager.prototype.get_numProxySlotsFree = function() {
	return away.managers.Stage3DManager._stageProxies.length - away.managers.Stage3DManager._numStageProxies;
};

away.managers.Stage3DManager.prototype.get_numProxySlotsUsed = function() {
	return away.managers.Stage3DManager._numStageProxies;
};

away.managers.Stage3DManager.prototype.get_numProxySlotsTotal = function() {
	return away.managers.Stage3DManager._stageProxies.length;
};

away.managers.Stage3DManager.className = "away.managers.Stage3DManager";

away.managers.Stage3DManager.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.managers.Stage3DManagerSingletonEnforcer');
	p.push('away.managers.Stage3DManagerInstanceData');
	p.push('away.managers.Stage3DProxy');
	return p;
};

away.managers.Stage3DManager.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.managers.Stage3DManager.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'stage', t:'away.display.Stage'});
			p.push({n:'stage3DManagerSingletonEnforcer', t:'away.managers.Stage3DManagerSingletonEnforcer'});
			break;
		default:
			p = [];
			break;
	}
	return p;
};

