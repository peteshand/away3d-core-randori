/** Compiled by the Randori compiler v0.2.6.2 on Wed Sep 04 21:18:25 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.materials == "undefined")
	away.materials = {};
if (typeof away.materials.compilation == "undefined")
	away.materials.compilation = {};

away.materials.compilation.RegisterPool = function(regName, regCount, persistent) {
	this._usedVectorCount = null;
	this._persistent = null;
	this._registerComponents = undefined;
	this._regCompsPool = {};
	this._regName = null;
	this._usedSingleCount = null;
	this._vectorRegisters = null;
	this._regPool = {};
	this._regCount = 0;
	this._regName = regName;
	this._regCount = regCount;
	this._persistent = persistent;
	this.initRegisters(regName, regCount);
};

away.materials.compilation.RegisterPool._regPool = {};

away.materials.compilation.RegisterPool._regCompsPool = {};

away.materials.compilation.RegisterPool.prototype.requestFreeVectorReg = function() {
	for (var i = 0; i < this._regCount; ++i) {
		if (!this.isRegisterUsed(i)) {
			if (this._persistent)
				this._usedVectorCount[i]++;
			return this._vectorRegisters[i];
		}
	}
	throw new Error("Register overflow!", 0);
};

away.materials.compilation.RegisterPool.prototype.requestFreeRegComponent = function() {
	for (var i = 0; i < this._regCount; ++i) {
		if (this._usedVectorCount[i] > 0)
			continue;
		for (var j = 0; j < 4; ++j) {
			if (this._usedSingleCount[j][i] == 0) {
				if (this._persistent) {
					this._usedSingleCount[j][i]++;
				}
				return this._registerComponents[j][i];
			}
		}
	}
	throw new Error("Register overflow!", 0);
};

away.materials.compilation.RegisterPool.prototype.addUsage = function(register, usageCount) {
	if (register._component > -1) {
		this._usedSingleCount[register._component][register.get_index()] += usageCount;
	} else {
		this._usedVectorCount[register.get_index()] += usageCount;
	}
};

away.materials.compilation.RegisterPool.prototype.removeUsage = function(register) {
	if (register._component > -1) {
		if (--this._usedSingleCount[register._component][register.get_index()] < 0) {
			throw new Error("More usages removed than exist!", 0);
		}
	} else {
		if (--this._usedVectorCount[register.get_index()] < 0) {
			throw new Error("More usages removed than exist!", 0);
		}
	}
};

away.materials.compilation.RegisterPool.prototype.dispose = function() {
	this._vectorRegisters = null;
	this._registerComponents = null;
	this._usedSingleCount = null;
	this._usedVectorCount = null;
};

away.materials.compilation.RegisterPool.prototype.hasRegisteredRegs = function() {
	for (var i = 0; i < this._regCount; ++i) {
		if (this.isRegisterUsed(i))
			return true;
	}
	return false;
};

away.materials.compilation.RegisterPool.prototype.initRegisters = function(regName, regCount) {
	var hash = away.materials.compilation.RegisterPool._initPool(regName, regCount);
	this._vectorRegisters = away.materials.compilation.RegisterPool._regPool[hash];
	this._registerComponents = away.materials.compilation.RegisterPool._regCompsPool[hash];
	this._usedVectorCount = this._initArray(regCount, 0);
	this._usedSingleCount = [0, 0, 0, 0];
	this._usedSingleCount[0] = this._initArray([], 0);
	this._usedSingleCount[1] = this._initArray([], 0);
	this._usedSingleCount[2] = this._initArray([], 0);
	this._usedSingleCount[3] = this._initArray([], 0);
};

away.materials.compilation.RegisterPool._initPool = function(regName, regCount) {
	var hash = regName + regCount;
	if (away.materials.compilation.RegisterPool._regPool[hash] != undefined) {
		return hash;
	}
	var vectorRegisters = [];
	away.materials.compilation.RegisterPool._regPool[hash] = vectorRegisters;
	var registerComponents = [[], [], [], []];
	away.materials.compilation.RegisterPool._regCompsPool[hash] = registerComponents;
	for (var i = 0; i < regCount; ++i) {
		vectorRegisters[i] = new away.materials.compilation.ShaderRegisterElement(regName, i, -1);
		for (var j = 0; j < 4; ++j) {
			registerComponents[j][i] = new away.materials.compilation.ShaderRegisterElement(regName, i, j);
		}
	}
	return hash;
};

away.materials.compilation.RegisterPool.prototype.isRegisterUsed = function(index) {
	if (this._usedVectorCount[index] > 0) {
		return true;
	}
	for (var i = 0; i < 4; ++i) {
		if (this._usedSingleCount[i][index] > 0) {
			return true;
		}
	}
	return false;
};

away.materials.compilation.RegisterPool.prototype._initArray = function(a, val) {
	var l = a.length;
	for (var c = 0; c < l; c++) {
		a[c] = val;
	}
	return a;
};

away.materials.compilation.RegisterPool.className = "away.materials.compilation.RegisterPool";

away.materials.compilation.RegisterPool.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.materials.compilation.ShaderRegisterElement');
	return p;
};

away.materials.compilation.RegisterPool.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.materials.compilation.RegisterPool.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'regName', t:'String'});
			p.push({n:'regCount', t:'Number'});
			p.push({n:'persistent', t:'Boolean'});
			break;
		default:
			p = [];
			break;
	}
	return p;
};

