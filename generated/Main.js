/** Compiled by the Randori compiler v0.2.5.2 on Wed Oct 09 21:45:47 EST 2013 */


Main = function() {
	this.exampleVec = [];
	this.exampleClasses = [];
	this.nextBtn = null;
	this.previousBtn = null;
	this._exampleIndex = -1;
	
};

Main.prototype.main = function() {
	this.exampleClasses.push(examples.PlaneTest);
	this.exampleClasses.push(examples.ViewPlane);
	this.exampleClasses.push(examples.CubeDemo);
	this.exampleClasses.push(examples.AWDSuzanne);
	this.exampleClasses.push(examples.AWDSuzanneLights);
	var previousBtn = this.createBtn("Previous");
	var nextBtn = this.createBtn("Next", new away.core.geom.Point(80, 0));
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
		position = new away.core.geom.Point(0, 0);
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
	if (value < 0)
		value = this.exampleClasses.length - 1;
	if (value > this.exampleClasses.length - 1)
		value = 0;
	if (this._exampleIndex == value)
		return;
	this._exampleIndex = value;
	for (var i = 0; i < this.exampleClasses.length; ++i) {
		if (i == this.get_exampleIndex()) {
			if (!this.exampleVec[i]) {
				var _Class = this.exampleClasses[i];
				this.exampleVec.push(new _Class(i));
			}
			this.exampleVec[i].Show();
		} else if (this.exampleVec.length > i) {
			if (this.exampleVec[i])
				this.exampleVec[i].Hide();
		}
	}
};

Main.prototype.get_exampleIndex = function() {
	return this._exampleIndex;
};Main.className = "Main";

Main.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('examples.AWDSuzanne');
	p.push('examples.CubeDemo');
	p.push('examples.AWDSuzanneLights');
	p.push('examples.PlaneTest');
	p.push('away.core.geom.Point');
	p.push('examples.ViewPlane');
	return p;
};

Main.getStaticDependencies = function(t) {
	var p;
	return [];
};

Main.injectionPoints = function(t) {
	return [];
};
