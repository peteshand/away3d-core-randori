/** Compiled by the Randori compiler v0.2.6.2 on Sat Sep 28 11:54:54 EST 2013 */


Main = function() {
	this.exampleVec = [];
	this.exampleClasses = [];
	this.nextBtn = null;
	this.previousBtn = null;
	this._exampleIndex = -1;
	
};

Main.prototype.main = function() {
	this.exampleClasses.push(examples.PlaneTest);
	this.exampleClasses.push(examples.CubeDemo);
	this.exampleClasses.push(examples.AWDSuzanne);
	var previousBtn = this.createBtn("Previous");
	var nextBtn = this.createBtn("Next", new away.geom.Point(80, 0));
	var that = this;
	previousBtn.onclick = function(e) {
		that.set_exampleIndex(that.get_exampleIndex() - 1);
	};
	nextBtn.onclick = function(e) {
		that.set_exampleIndex(that.get_exampleIndex() + 1);
	};
	this.set_exampleIndex(0);
};

Main.prototype.createBtn = function(label, position) {
	if (!position)
		position = new away.geom.Point(0, 0);
	var btn = document.createElement("BUTTON");
	var previousText = document.createTextNode(label);
	btn.appendChild(previousText);
	document.body.appendChild(btn);
	btn.style.setProperty("z-index", "100");
	btn.style.setProperty("position", "absolute");
	btn.style.setProperty("margin-left", position.x);
	btn.style.setProperty("margin-top", position.y);
	return btn;
};

Main.prototype.set_exampleIndex = function(value) {
	if (this._exampleIndex == value)
		return;
	this._exampleIndex = value;
	if (this._exampleIndex < 0)
		this._exampleIndex = this.exampleClasses.length - 1;
	if (this._exampleIndex > this.exampleClasses.length - 1)
		this._exampleIndex = 0;
	for (var i = 0; i < this.exampleClasses.length; ++i) {
		if (!this.exampleVec[i]) {
			var _Class = this.exampleClasses[i];
			this.exampleVec.push(new _Class(i));
		}
		if (i == this.get_exampleIndex())
			this.exampleVec[i].Show();
		else
			this.exampleVec[i].Hide();
	}
};

Main.prototype.get_exampleIndex = function() {
	return this._exampleIndex;
};Main.className = "Main";

Main.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.geom.Point');
	p.push('examples.AWDSuzanne');
	p.push('examples.CubeDemo');
	p.push('examples.PlaneTest');
	return p;
};

Main.getStaticDependencies = function(t) {
	var p;
	return [];
};

Main.injectionPoints = function(t) {
	return [];
};
