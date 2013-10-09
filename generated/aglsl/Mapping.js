/** Compiled by the Randori compiler v0.2.5.2 on Wed Oct 09 20:30:39 EST 2013 */

if (typeof aglsl == "undefined")
	var aglsl = {};

aglsl.Mapping = function() {
	this._agal2glsllut = null;
	
};

aglsl.Mapping._agal2glsllut;

aglsl.Mapping.agal2glsllut = function() {
	if (!aglsl.Mapping._agal2glsllut) {
		aglsl.Mapping._agal2glsllut = [new aglsl.OpLUT("%dest = %cast(%a);\n", 0, true, true, false, null, null, null, null, null, null), new aglsl.OpLUT("%dest = %cast(%a + %b);\n", 0, true, true, true, null, null, null, null, null, null), new aglsl.OpLUT("%dest = %cast(%a - %b);\n", 0, true, true, true, null, null, null, null, null, null), new aglsl.OpLUT("%dest = %cast(%a * %b);\n", 0, true, true, true, null, null, null, null, null, null), new aglsl.OpLUT("%dest = %cast(%a \/ %b);\n", 0, true, true, true, null, null, null, null, null, null), new aglsl.OpLUT("%dest = %cast(1.0) \/ %a;\n", 0, true, true, false, null, null, null, null, null, null), new aglsl.OpLUT("%dest = %cast(min(%a,%b));\n", 0, true, true, true, null, null, null, null, null, null), new aglsl.OpLUT("%dest = %cast(max(%a,%b));\n", 0, true, true, true, null, null, null, null, null, null), new aglsl.OpLUT("%dest = %cast(fract(%a));\n", 0, true, true, false, null, null, null, null, null, null), new aglsl.OpLUT("%dest = %cast(sqrt(abs(%a)));\n", 0, true, true, false, null, null, null, null, null, null), new aglsl.OpLUT("%dest = %cast(inversesqrt(abs(%a)));\n", 0, true, true, false, null, null, null, null, null, null), new aglsl.OpLUT("%dest = %cast(pow(abs(%a),%b));\n", 0, true, true, true, null, null, null, null, null, null), new aglsl.OpLUT("%dest = %cast(log2(abs(%a)));\n", 0, true, true, false, null, null, null, null, null, null), new aglsl.OpLUT("%dest = %cast(exp2(%a));\n", 0, true, true, false, null, null, null, null, null, null), new aglsl.OpLUT("%dest = %cast(normalize(%a));\n", 0, true, true, false, null, null, true, null, null, null), new aglsl.OpLUT("%dest = %cast(sin(%a));\n", 0, true, true, false, null, null, null, null, null, null), new aglsl.OpLUT("%dest = %cast(cos(%a));\n", 0, true, true, false, null, null, null, null, null, null), new aglsl.OpLUT("%dest = %cast(cross(vec3(%a),vec3(%b)));\n", 0, true, true, true, null, null, true, null, null, null), new aglsl.OpLUT("%dest = %cast(dot(vec3(%a),vec3(%b)));\n", 0, true, true, true, null, null, true, null, null, null), new aglsl.OpLUT("%dest = %cast(dot(vec4(%a),vec4(%b)));\n", 0, true, true, true, null, null, true, null, null, null), new aglsl.OpLUT("%dest = %cast(abs(%a));\n", 0, true, true, false, null, null, null, null, null, null), new aglsl.OpLUT("%dest = %cast(%a * -1.0);\n", 0, true, true, false, null, null, null, null, null, null), new aglsl.OpLUT("%dest = %cast(clamp(%a,0.0,1.0));\n", 0, true, true, false, null, null, null, null, null, null), new aglsl.OpLUT("%dest = %cast(dot(vec3(%a),vec3(%b)));\n", null, true, true, true, 3, 3, true, null, null, null), new aglsl.OpLUT("%dest = %cast(dot(vec4(%a),vec4(%b)));\n", null, true, true, true, 4, 4, true, null, null, null), new aglsl.OpLUT("%dest = %cast(dot(vec4(%a),vec4(%b)));\n", null, true, true, true, 4, 3, true, null, null, null), new aglsl.OpLUT("%dest = %cast(dFdx(%a));\n", 0, true, true, false, null, null, null, null, null, null), new aglsl.OpLUT("%dest = %cast(dFdx(%a));\n", 0, true, true, false, null, null, null, null, null, null), new aglsl.OpLUT("if (float(%a)==float(%b)) {;\n", 0, false, true, true, null, null, null, true, null, null), new aglsl.OpLUT("if (float(%a)!=float(%b)) {;\n", 0, false, true, true, null, null, null, true, null, null), new aglsl.OpLUT("if (float(%a)>=float(%b)) {;\n", 0, false, true, true, null, null, null, true, null, null), new aglsl.OpLUT("if (float(%a)<float(%b)) {;\n", 0, false, true, true, null, null, null, true, null, null), new aglsl.OpLUT("} else {;\n", 0, false, false, false, null, null, null, null, null, null), new aglsl.OpLUT("};\n", 0, false, false, false, null, null, null, null, null, null), new aglsl.OpLUT(null, null, null, null, false, null, null, null, null, null, null), new aglsl.OpLUT(null, null, null, null, false, null, null, null, null, null, null), new aglsl.OpLUT(null, null, null, null, false, null, null, null, null, null, null), new aglsl.OpLUT(null, null, null, null, false, null, null, null, null, null, null), new aglsl.OpLUT("%dest = %cast(texture%texdimLod(%b,%texsize(%a)).%dm);\n", null, true, true, true, null, null, null, null, true, null), new aglsl.OpLUT("if ( float(%a)<0.0 ) discard;\n", null, false, true, false, null, null, null, true, null, null), new aglsl.OpLUT("%dest = %cast(texture%texdim(%b,%texsize(%a)%lod).%dm);\n", null, true, true, true, null, null, true, null, true, true), new aglsl.OpLUT("%dest = %cast(greaterThanEqual(%a,%b).%dm);\n", 0, true, true, true, null, null, true, null, true, null), new aglsl.OpLUT("%dest = %cast(lessThan(%a,%b).%dm);\n", 0, true, true, true, null, null, true, null, true, null), new aglsl.OpLUT("%dest = %cast(sign(%a));\n", 0, true, true, false, null, null, null, null, null, null), new aglsl.OpLUT("%dest = %cast(equal(%a,%b).%dm);\n", 0, true, true, false, null, null, true, null, true, null), new aglsl.OpLUT("%dest = %cast(notEqual(%a,%b).%dm);\n", 0, true, true, true, null, null, true, null, true, null)];
	}
	return aglsl.Mapping._agal2glsllut;
};

aglsl.Mapping.className = "aglsl.Mapping";

aglsl.Mapping.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('aglsl.OpLUT');
	return p;
};

aglsl.Mapping.getStaticDependencies = function(t) {
	var p;
	return [];
};

aglsl.Mapping.injectionPoints = function(t) {
	return [];
};
