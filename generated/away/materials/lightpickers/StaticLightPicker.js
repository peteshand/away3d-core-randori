/** Compiled by the Randori compiler v0.2.5.2 on Sat Oct 12 02:16:06 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.materials == "undefined")
	away.materials = {};
if (typeof away.materials.lightpickers == "undefined")
	away.materials.lightpickers = {};

away.materials.lightpickers.StaticLightPicker = function(lights) {
	this._lights = null;
	away.materials.lightpickers.LightPickerBase.call(this);
	this.set_lights(lights);
};

away.materials.lightpickers.StaticLightPicker.prototype.get_lights = function() {
	return this._lights;
};

away.materials.lightpickers.StaticLightPicker.prototype.set_lights = function(value) {
	var numPointLights = 0;
	var numDirectionalLights = 0;
	var numCastingPointLights = 0;
	var numCastingDirectionalLights = 0;
	var numLightProbes = 0;
	var light;
	if (this._lights)
		this.clearListeners();
	this._lights = value;
	this._pAllPickedLights = value;
	this._pPointLights = [];
	this._pCastingPointLights = [];
	this._pDirectionalLights = [];
	this._pCastingDirectionalLights = [];
	this._pLightProbes = [];
	var len = value.length;
	for (var i = 0; i < len; ++i) {
		light = value[i];
		light.addEventListener(away.events.LightEvent.CASTS_SHADOW_CHANGE, $createStaticDelegate(this, this.onCastShadowChange), this);
		if (light instanceof away.lights.PointLight) {
			if (light.get_castsShadows())
				this._pCastingPointLights[numCastingPointLights++] = light;
			else
				this._pPointLights[numPointLights++] = light;
		} else if (light instanceof away.lights.DirectionalLight) {
			if (light.get_castsShadows())
				this._pCastingDirectionalLights[numCastingDirectionalLights++] = light;
			else
				this._pDirectionalLights[numDirectionalLights++] = light;
		} else if (light instanceof away.lights.LightProbe) {
			this._pLightProbes[numLightProbes++] = light;
		}
	}
	if (this._pNumDirectionalLights == numDirectionalLights && this._pNumPointLights == numPointLights && this._pNumLightProbes == numLightProbes && this._pNumCastingPointLights == numCastingPointLights && this._pNumCastingDirectionalLights == numCastingDirectionalLights) {
		return;
	}
	this._pNumDirectionalLights = numDirectionalLights;
	this._pNumCastingDirectionalLights = numCastingDirectionalLights;
	this._pNumPointLights = numPointLights;
	this._pNumCastingPointLights = numCastingPointLights;
	this._pNumLightProbes = numLightProbes;
	this._pLightProbeWeights = away.utils.VectorInit.Num(Math.ceil(numLightProbes / 4) * 4, 0);
	this.dispatchEvent(new away.events.Event(away.events.Event.CHANGE));
};

away.materials.lightpickers.StaticLightPicker.prototype.clearListeners = function() {
	var len = this._lights.length;
	for (var i = 0; i < len; ++i)
		this._lights[i].removeEventListener(away.events.LightEvent.CASTS_SHADOW_CHANGE, $createStaticDelegate(this, this.onCastShadowChange), this);
};

away.materials.lightpickers.StaticLightPicker.prototype.onCastShadowChange = function(event) {
	var light = event.target;
	if (light instanceof away.lights.PointLight) {
		var pl = light;
		this.updatePointCasting(pl);
	} else if (light instanceof away.lights.DirectionalLight) {
		var dl = light;
		this.updateDirectionalCasting(dl);
	}
	this.dispatchEvent(new away.events.Event(away.events.Event.CHANGE));
};

away.materials.lightpickers.StaticLightPicker.prototype.updateDirectionalCasting = function(light) {
	var dl = light;
	if (light.get_castsShadows()) {
		--this._pNumDirectionalLights;
		++this._pNumCastingDirectionalLights;
		this._pDirectionalLights.splice(this._pDirectionalLights.indexOf(dl, 0), 1);
		this._pCastingDirectionalLights.push(light);
	} else {
		++this._pNumDirectionalLights;
		--this._pNumCastingDirectionalLights;
		this._pCastingDirectionalLights.splice(this._pCastingDirectionalLights.indexOf(dl, 0), 1);
		this._pDirectionalLights.push(light);
	}
};

away.materials.lightpickers.StaticLightPicker.prototype.updatePointCasting = function(light) {
	var pl = light;
	if (light.get_castsShadows()) {
		--this._pNumPointLights;
		++this._pNumCastingPointLights;
		this._pPointLights.splice(this._pPointLights.indexOf(pl, 0), 1);
		this._pCastingPointLights.push(light);
	} else {
		++this._pNumPointLights;
		--this._pNumCastingPointLights;
		this._pCastingPointLights.splice(this._pCastingPointLights.indexOf(pl, 0), 1);
		this._pPointLights.push(light);
	}
};

$inherit(away.materials.lightpickers.StaticLightPicker, away.materials.lightpickers.LightPickerBase);

away.materials.lightpickers.StaticLightPicker.className = "away.materials.lightpickers.StaticLightPicker";

away.materials.lightpickers.StaticLightPicker.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.lights.LightProbe');
	p.push('away.events.Event');
	p.push('away.lights.PointLight');
	p.push('away.lights.DirectionalLight');
	p.push('away.events.LightEvent');
	p.push('away.utils.VectorInit');
	return p;
};

away.materials.lightpickers.StaticLightPicker.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.materials.lightpickers.StaticLightPicker.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'lights', t:'Object'});
			break;
		case 1:
			p = away.materials.lightpickers.LightPickerBase.injectionPoints(t);
			break;
		case 2:
			p = away.materials.lightpickers.LightPickerBase.injectionPoints(t);
			break;
		case 3:
			p = away.materials.lightpickers.LightPickerBase.injectionPoints(t);
			break;
		default:
			p = [];
			break;
	}
	return p;
};

