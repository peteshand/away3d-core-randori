/** Compiled by the Randori compiler v0.2.5.2 on Wed Oct 09 20:30:39 EST 2013 */

if (typeof examples == "undefined")
	var examples = {};

examples.BaseExample = function(_index) {
	this.requestAnimationFrame = null;
	this.index = 0;
	this.view = null;
	this.index = _index;
	this.requestAnimationFrame = new away.utils.RequestAnimationFrame($createStaticDelegate(this, this.tick), this);
	var that = this;
	onresize = function() {
		that.resize();
	};
	this.resize();
};

examples.BaseExample.prototype.Show = function() {
	if (this.view)
		this.view.get_canvas().style.setProperty("visibility", "visible");
	this.requestAnimationFrame.start();
};

examples.BaseExample.prototype.Hide = function() {
	if (this.view)
		this.view.get_canvas().style.setProperty("visibility", "hidden");
	this.requestAnimationFrame.stop();
};

examples.BaseExample.prototype.resize = function() {
};

examples.BaseExample.prototype.tick = function(dt) {
};

examples.BaseExample.className = "examples.BaseExample";

examples.BaseExample.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.utils.RequestAnimationFrame');
	return p;
};

examples.BaseExample.getStaticDependencies = function(t) {
	var p;
	return [];
};

examples.BaseExample.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'_index', t:'int'});
			break;
		default:
			p = [];
			break;
	}
	return p;
};

