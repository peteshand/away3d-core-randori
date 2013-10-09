/** Compiled by the Randori compiler v0.2.5.2 on Wed Oct 09 20:30:40 EST 2013 */


GuiceInjectorBootstrap = function(mainClassName, dynamicClassBaseUrl) {
	this.mainClassName = mainClassName;
	this.dynamicClassBaseUrl = dynamicClassBaseUrl;
};

GuiceInjectorBootstrap.prototype.launch = function() {
	var urlRewriter = new guice.loader.URLRewriterBase(false);
	var loader = new guice.loader.SynchronousClassLoader(new XMLHttpRequest(), urlRewriter, this.dynamicClassBaseUrl);
	var guiceJs = new guice.GuiceJs(loader);
	var injector = guiceJs.createInjector(null);
	var classBuilder = injector.getInstance(guice.InjectionClassBuilder);
	var obj = classBuilder.buildClass(this.mainClassName);
	obj.main();
};

GuiceInjectorBootstrap.className = "GuiceInjectorBootstrap";

GuiceInjectorBootstrap.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('guice.InjectionClassBuilder');
	p.push('guice.loader.SynchronousClassLoader');
	p.push('guice.loader.URLRewriterBase');
	p.push('guice.GuiceJs');
	return p;
};

GuiceInjectorBootstrap.getStaticDependencies = function(t) {
	var p;
	return [];
};

GuiceInjectorBootstrap.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'mainClassName', t:'String'});
			p.push({n:'dynamicClassBaseUrl', t:'String'});
			break;
		default:
			p = [];
			break;
	}
	return p;
};

