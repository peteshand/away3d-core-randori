/** Compiled by the Randori compiler v0.2.5.2 on Wed Oct 09 20:30:38 EST 2013 */

if (typeof aglsl == "undefined")
	var aglsl = {};
if (typeof aglsl.assembler == "undefined")
	aglsl.assembler = {};

aglsl.assembler.SamplerMap = function() {
this._map = null;
};

aglsl.assembler.SamplerMap._map;

aglsl.assembler.SamplerMap.map = function() {
	if (!aglsl.assembler.SamplerMap._map) {
		aglsl.assembler.SamplerMap._map = [];
		aglsl.assembler.SamplerMap._map["rgba"] = new aglsl.assembler.aglsl.assembler.Sampler(8, 0xf, 0);
		aglsl.assembler.SamplerMap._map["rg"] = new aglsl.assembler.aglsl.assembler.Sampler(8, 0xf, 5);
		aglsl.assembler.SamplerMap._map["r"] = new aglsl.assembler.aglsl.assembler.Sampler(8, 0xf, 4);
		aglsl.assembler.SamplerMap._map["compressed"] = new aglsl.assembler.aglsl.assembler.Sampler(8, 0xf, 1);
		aglsl.assembler.SamplerMap._map["compressed_alpha"] = new aglsl.assembler.aglsl.assembler.Sampler(8, 0xf, 2);
		aglsl.assembler.SamplerMap._map["dxt1"] = new aglsl.assembler.aglsl.assembler.Sampler(8, 0xf, 1);
		aglsl.assembler.SamplerMap._map["dxt5"] = new aglsl.assembler.aglsl.assembler.Sampler(8, 0xf, 2);
		aglsl.assembler.SamplerMap._map["2d"] = new aglsl.assembler.aglsl.assembler.Sampler(12, 0xf, 0);
		aglsl.assembler.SamplerMap._map["cube"] = new aglsl.assembler.aglsl.assembler.Sampler(12, 0xf, 1);
		aglsl.assembler.SamplerMap._map["3d"] = new aglsl.assembler.aglsl.assembler.Sampler(12, 0xf, 2);
		aglsl.assembler.SamplerMap._map["centroid"] = new aglsl.assembler.aglsl.assembler.Sampler(16, 1, 1);
		aglsl.assembler.SamplerMap._map["ignoresampler"] = new aglsl.assembler.aglsl.assembler.Sampler(16, 4, 4);
		aglsl.assembler.SamplerMap._map["clamp"] = new aglsl.assembler.aglsl.assembler.Sampler(20, 0xf, 0);
		aglsl.assembler.SamplerMap._map["repeat"] = new aglsl.assembler.aglsl.assembler.Sampler(20, 0xf, 1);
		aglsl.assembler.SamplerMap._map["wrap"] = new aglsl.assembler.aglsl.assembler.Sampler(20, 0xf, 1);
		aglsl.assembler.SamplerMap._map["nomip"] = new aglsl.assembler.aglsl.assembler.Sampler(24, 0xf, 0);
		aglsl.assembler.SamplerMap._map["mipnone"] = new aglsl.assembler.aglsl.assembler.Sampler(24, 0xf, 0);
		aglsl.assembler.SamplerMap._map["mipnearest"] = new aglsl.assembler.aglsl.assembler.Sampler(24, 0xf, 1);
		aglsl.assembler.SamplerMap._map["miplinear"] = new aglsl.assembler.aglsl.assembler.Sampler(24, 0xf, 2);
		aglsl.assembler.SamplerMap._map["nearest"] = new aglsl.assembler.aglsl.assembler.Sampler(28, 0xf, 0);
		aglsl.assembler.SamplerMap._map["linear"] = new aglsl.assembler.aglsl.assembler.Sampler(28, 0xf, 1);
	}
	return aglsl.assembler.SamplerMap._map;
};

aglsl.assembler.SamplerMap.className = "aglsl.assembler.SamplerMap";

aglsl.assembler.SamplerMap.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

aglsl.assembler.SamplerMap.getStaticDependencies = function(t) {
	var p;
	return [];
};

aglsl.assembler.SamplerMap.injectionPoints = function(t) {
	return [];
};
