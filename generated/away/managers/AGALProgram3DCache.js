/** Compiled by the Randori compiler v0.2.6.2 on Wed Sep 04 21:18:40 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.managers == "undefined")
	away.managers = {};

away.managers.AGALProgram3DCache = function(stage3DProxy, agalProgram3DCacheSingletonEnforcer) {
	this._stage3DProxy = null;
	this._ids = null;
	this._currentId = 0;
	this._keys = null;
	this._program3Ds = null;
	this._usages = null;
	this._instances = null;
	if (!agalProgram3DCacheSingletonEnforcer) {
		throw new Error("This class is a multiton and cannot be instantiated manually. Use Stage3DManager.getInstance instead.", 0);
	}
	this._stage3DProxy = stage3DProxy;
	this._program3Ds = {};
	this._ids = {};
	this._usages = {};
	this._keys = {};
};

away.managers.AGALProgram3DCache._instances;

away.managers.AGALProgram3DCache._currentId = 0;

away.managers.AGALProgram3DCache.getInstance = function(stage3DProxy) {
	var index = stage3DProxy._iStage3DIndex;
	if (away.managers.AGALProgram3DCache._instances == null) {
		away.managers.AGALProgram3DCache._instances = [null, null, null, null, null, null, null, null];
	}
	if (!away.managers.AGALProgram3DCache._instances[index]) {
		away.managers.AGALProgram3DCache._instances[index] = new away.managers.AGALProgram3DCache(stage3DProxy, new away.managers.AGALProgram3DCache$AGALProgram3DCacheSingletonEnforcer());
		stage3DProxy.addEventListener(away.events.Stage3DEvent.CONTEXT3D_DISPOSED, $createStaticDelegate(away.managers.AGALProgram3DCache, away.managers.AGALProgram3DCache.away.managers.AGALProgram3DCache.onContext3DDisposed), away.managers.AGALProgram3DCache);
		stage3DProxy.addEventListener(away.events.Stage3DEvent.CONTEXT3D_CREATED, $createStaticDelegate(away.managers.AGALProgram3DCache, away.managers.AGALProgram3DCache.away.managers.AGALProgram3DCache.onContext3DDisposed), away.managers.AGALProgram3DCache);
		stage3DProxy.addEventListener(away.events.Stage3DEvent.CONTEXT3D_RECREATED, $createStaticDelegate(away.managers.AGALProgram3DCache, away.managers.AGALProgram3DCache.away.managers.AGALProgram3DCache.onContext3DDisposed), away.managers.AGALProgram3DCache);
	}
	return away.managers.AGALProgram3DCache._instances[index];
};

away.managers.AGALProgram3DCache.getInstanceFromIndex = function(index) {
	if (!away.managers.AGALProgram3DCache._instances[index]) {
		throw new Error("Instance not created yet!", 0);
	}
	return away.managers.AGALProgram3DCache._instances[index];
};

away.managers.AGALProgram3DCache.onContext3DDisposed = function(event) {
	var stage3DProxy = event.target, , , false, "baseline";
	var index = stage3DProxy._iStage3DIndex;
	away.managers.AGALProgram3DCache._instances[index].dispose();
	away.managers.AGALProgram3DCache._instances[index] = null;
	stage3DProxy.removeEventListener(away.events.Stage3DEvent.CONTEXT3D_DISPOSED, $createStaticDelegate(away.managers.AGALProgram3DCache, away.managers.AGALProgram3DCache.away.managers.AGALProgram3DCache.onContext3DDisposed), away.managers.AGALProgram3DCache);
	stage3DProxy.removeEventListener(away.events.Stage3DEvent.CONTEXT3D_CREATED, $createStaticDelegate(away.managers.AGALProgram3DCache, away.managers.AGALProgram3DCache.away.managers.AGALProgram3DCache.onContext3DDisposed), away.managers.AGALProgram3DCache);
	stage3DProxy.removeEventListener(away.events.Stage3DEvent.CONTEXT3D_RECREATED, $createStaticDelegate(away.managers.AGALProgram3DCache, away.managers.AGALProgram3DCache.away.managers.AGALProgram3DCache.onContext3DDisposed), away.managers.AGALProgram3DCache);
};

away.managers.AGALProgram3DCache.prototype.dispose = function() {
	for (var key in this._program3Ds) {
		this.destroyProgram(key);
	}
	this._keys = null;
	this._program3Ds = null;
	this._usages = null;
};

away.managers.AGALProgram3DCache.prototype.setProgram3D = function(pass, vertexCode, fragmentCode) {
	var stageIndex = this._stage3DProxy._iStage3DIndex;
	var program;
	var key = this.getKey(vertexCode, fragmentCode);
	if (this._program3Ds[key] == null) {
		this._keys[away.managers.AGALProgram3DCache._currentId] = key;
		this._usages[away.managers.AGALProgram3DCache._currentId] = 0;
		this._ids[key] = away.managers.AGALProgram3DCache._currentId;
		++away.managers.AGALProgram3DCache._currentId;
		program = this._stage3DProxy._iContext3D.createProgram();
		var vertCompiler = new aglsl.AGLSLCompiler();
		var fragCompiler = new aglsl.AGLSLCompiler();
		var vertString = vertCompiler.compile(away.display3D.Context3DProgramType.VERTEX, vertexCode);
		var fragString = fragCompiler.compile(away.display3D.Context3DProgramType.FRAGMENT, fragmentCode);
		console.log("===GLSL=========================================================");
		console.log("vertString");
		console.log(vertString);
		console.log("fragString");
		console.log(fragString);
		console.log("===AGAL=========================================================");
		console.log("vertexCode");
		console.log(vertexCode);
		console.log("fragmentCode");
		console.log(fragmentCode);
		program.upload(vertString, fragString);
		this._program3Ds[key] = program;
	}
	var oldId = pass._iProgram3Dids[stageIndex];
	var newId = this._ids[key];
	if (oldId != newId) {
		if (oldId >= 0) {
			this.freeProgram3D(oldId);
		}
		this._usages[newId]++;
	}
	pass._iProgram3Dids[stageIndex] = newId;
	pass._iProgram3Ds[stageIndex] = this._program3Ds[key];
};

away.managers.AGALProgram3DCache.prototype.freeProgram3D = function(programId) {
	this._usages[programId]--;
	if (this._usages[programId] == 0) {
		this.destroyProgram(this._keys[programId]);
	}
};

away.managers.AGALProgram3DCache.prototype.destroyProgram = function(key) {
	this._program3Ds[key].dispose();
	this._program3Ds[key] = null;
	delete this._program3Ds[key];
	this._ids[key] = -1;
};

away.managers.AGALProgram3DCache.prototype.getKey = function(vertexCode, fragmentCode) {
	return vertexCode + "---" + fragmentCode;
};

away.managers.AGALProgram3DCache.className = "away.managers.AGALProgram3DCache";

away.managers.AGALProgram3DCache.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.events.Stage3DEvent');
	p.push('away.display3D.Context3DProgramType');
	p.push('aglsl.AGLSLCompiler');
	p.push('away.managers.AGALProgram3DCache');
	return p;
};

away.managers.AGALProgram3DCache.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.managers.AGALProgram3DCache.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'stage3DProxy', t:'away.managers.Stage3DProxy'});
			p.push({n:'agalProgram3DCacheSingletonEnforcer', t:'away.managers.AGALProgram3DCache$AGALProgram3DCacheSingletonEnforcer'});
			break;
		default:
			p = [];
			break;
	}
	return p;
};

