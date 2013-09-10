/** Compiled by the Randori compiler v0.2.6.2 on Thu Sep 05 22:19:21 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.lights == "undefined")
	away.lights = {};

away.lights.LightBase = function() {
	this._castsShadows = false;
	this._iSpecularG = 1;
	this._specular = 1;
	this._ambientColor = 0xffffff;
	this._diffuse = 1;
	this._iSpecularB = 1;
	this._colorB = 1;
	this._shadowMapper = null;
	this._iAmbientG = 0;
	this._iAmbientB = 0;
	this._color = 0xffffff;
	this._iDiffuseR = 1;
	this._iAmbientR = 0;
	this._colorG = 1;
	this._ambient = 0;
	this._iDiffuseB = 1;
	this._colorR = 1;
	this._iSpecularR = 1;
	this._iDiffuseG = 1;
	away.entities.Entity.call(this);
};

away.lights.LightBase.prototype.get_castsShadows = function() {
	return this._castsShadows;
};

away.lights.LightBase.prototype.set_castsShadows = function(value) {
	if (this._castsShadows == value) {
		return;
	}
	this._castsShadows = value;
	if (value) {
		if (this._shadowMapper == null) {
			this._shadowMapper = this.pCreateShadowMapper();
		}
		this._shadowMapper.set_light(this);
	} else {
		this._shadowMapper.dispose();
		this._shadowMapper = null;
	}
	this.dispatchEvent(new away.events.LightEvent(away.events.LightEvent.CASTS_SHADOW_CHANGE));
};

away.lights.LightBase.prototype.pCreateShadowMapper = function() {
	throw new away.errors.AbstractMethodError(null, 0);
};

away.lights.LightBase.prototype.get_specular = function() {
	return this._specular;
};

away.lights.LightBase.prototype.set_specular = function(value) {
	if (value < 0) {
		value = 0;
	}
	this._specular = value;
	this.updateSpecular();
};

away.lights.LightBase.prototype.get_diffuse = function() {
	return this._diffuse;
};

away.lights.LightBase.prototype.set_diffuse = function(value) {
	if (value < 0) {
		value = 0;
	}
	this._diffuse = value;
	this.updateDiffuse();
};

away.lights.LightBase.prototype.get_color = function() {
	return this._color;
};

away.lights.LightBase.prototype.set_color = function(value) {
	this._color = value;
	this._colorR = ((this._color >> 16) & 0xff) / 0xff;
	this._colorG = ((this._color >> 8) & 0xff) / 0xff;
	this._colorB = (this._color & 0xff) / 0xff;
	this.updateDiffuse();
	this.updateSpecular();
};

away.lights.LightBase.prototype.get_ambient = function() {
	return this._ambient;
};

away.lights.LightBase.prototype.set_ambient = function(value) {
	if (value < 0) {
		value = 0;
	} else if (value > 1) {
		value = 1;
	}
	this._ambient = value;
	this.updateAmbient();
};

away.lights.LightBase.prototype.get_ambientColor = function() {
	return this._ambientColor;
};

away.lights.LightBase.prototype.set_ambientColor = function(value) {
	this._ambientColor = value;
	this.updateAmbient();
};

away.lights.LightBase.prototype.updateAmbient = function() {
	this._iAmbientR = ((this._ambientColor >> 16) & 0xff) / 0xff * this._ambient;
	this._iAmbientG = ((this._ambientColor >> 8) & 0xff) / 0xff * this._ambient;
	this._iAmbientB = (this._ambientColor & 0xff) / 0xff * this._ambient;
};

away.lights.LightBase.prototype.iGetObjectProjectionMatrix = function(renderable, target) {
	throw new away.errors.AbstractMethodError(null, 0);
};

away.lights.LightBase.prototype.pCreateEntityPartitionNode = function() {
	return new away.partition.LightNode(this);
};

away.lights.LightBase.prototype.get_assetType = function() {
	return away.library.assets.AssetType.LIGHT;
};

away.lights.LightBase.prototype.updateSpecular = function() {
	this._iSpecularR = this._colorR * this._specular;
	this._iSpecularG = this._colorG * this._specular;
	this._iSpecularB = this._colorB * this._specular;
};

away.lights.LightBase.prototype.updateDiffuse = function() {
	this._iDiffuseR = this._colorR * this._diffuse;
	this._iDiffuseG = this._colorG * this._diffuse;
	this._iDiffuseB = this._colorB * this._diffuse;
};

away.lights.LightBase.prototype.get_shadowMapper = function() {
	return this._shadowMapper;
};

away.lights.LightBase.prototype.set_shadowMapper = function(value) {
	this._shadowMapper = value;
	this._shadowMapper.set_light(this);
};

$inherit(away.lights.LightBase, away.entities.Entity);

away.lights.LightBase.className = "away.lights.LightBase";

away.lights.LightBase.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.partition.LightNode');
	p.push('away.errors.AbstractMethodError');
	p.push('away.events.LightEvent');
	p.push('away.library.assets.AssetType');
	return p;
};

away.lights.LightBase.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.lights.LightBase.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 1:
			p = away.entities.Entity.injectionPoints(t);
			break;
		case 2:
			p = away.entities.Entity.injectionPoints(t);
			break;
		case 3:
			p = away.entities.Entity.injectionPoints(t);
			break;
		default:
			p = [];
			break;
	}
	return p;
};

