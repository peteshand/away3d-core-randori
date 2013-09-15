/** Compiled by the Randori compiler v0.2.6.2 on Fri Sep 13 21:20:09 EST 2013 */

if (typeof aglsl == "undefined")
	var aglsl = {};

aglsl.AGLSLCompiler = function() {
	this.glsl = null;
	
};

aglsl.AGLSLCompiler.prototype.compile = function(programType, source) {
	var agalMiniAssembler = new aglsl.assembler.AGALMiniAssembler();
	var tokenizer = new aglsl.AGALTokenizer();
	var data;
	var concatSource;
	switch (programType) {
		case "vertex":
			concatSource = "part vertex 1\n" + source + "endpart";
			agalMiniAssembler.assemble(concatSource);
			data = agalMiniAssembler.r["vertex"].data;
			break;
		case "fragment":
			concatSource = "part fragment 1\n" + source + "endpart";
			agalMiniAssembler.assemble(concatSource);
			data = agalMiniAssembler.r["fragment"].data;
			break;
		default:
			throw "Unknown Context3DProgramType";
	}
	var description = tokenizer.decribeAGALByteArray(data);
	var parser = new aglsl.AGLSLParser();
	this.glsl = parser.parse(description);
	return this.glsl;
};

aglsl.AGLSLCompiler.className = "aglsl.AGLSLCompiler";

aglsl.AGLSLCompiler.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('aglsl.assembler.AGALMiniAssembler');
	p.push('aglsl.AGALTokenizer');
	p.push('aglsl.AGLSLParser');
	return p;
};

aglsl.AGLSLCompiler.getStaticDependencies = function(t) {
	var p;
	return [];
};

aglsl.AGLSLCompiler.injectionPoints = function(t) {
	return [];
};
