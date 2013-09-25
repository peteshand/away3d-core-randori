/** Compiled by the Randori compiler v0.2.6.2 on Wed Sep 25 08:00:45 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.materials == "undefined")
	away.materials = {};
if (typeof away.materials.compilation == "undefined")
	away.materials.compilation = {};

away.materials.compilation.ShaderRegisterElement = function(regName, index, component) {
	this.COMPONENTS = ["x", "y", "z", "w"];
	this._component = 0;
	this._index = 0;
	this._regName = null;
	this._toStr = null;
	component = component || -1;
	this._component = component;
	this._regName = regName;
	this._index = index;
	this._toStr = this._regName;
	if (this._index >= 0) {
		this._toStr += this._index;
	}
	if (component > -1) {
		this._toStr += "." + away.materials.compilation.ShaderRegisterElement.COMPONENTS[component];
	}
};

away.materials.compilation.ShaderRegisterElement.COMPONENTS = ["x", "y", "z", "w"];

away.materials.compilation.ShaderRegisterElement.prototype.toString = function() {
	return this._toStr;
};

away.materials.compilation.ShaderRegisterElement.prototype.get_regName = function() {
	return this._regName;
};

away.materials.compilation.ShaderRegisterElement.prototype.get_index = function() {
	return this._index;
};

away.materials.compilation.ShaderRegisterElement.className = "away.materials.compilation.ShaderRegisterElement";

away.materials.compilation.ShaderRegisterElement.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.materials.compilation.ShaderRegisterElement.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.materials.compilation.ShaderRegisterElement.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'regName', t:'String'});
			p.push({n:'index', t:'Number'});
			p.push({n:'component', t:'Number'});
			break;
		default:
			p = [];
			break;
	}
	return p;
};

