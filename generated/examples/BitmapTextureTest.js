/** Compiled by the Randori compiler v0.2.5.2 on Wed Oct 09 20:30:41 EST 2013 */

if (typeof examples == "undefined")
	var examples = {};

examples.BitmapTextureTest = function() {
	this.mipLoader = null;
	this.bitmapData = null;
	this.target = null;
	this.texture = null;
	var canvas = document.createElement("canvas");
	var GL = canvas.getContext("experimental-webgl");
	var mipUrlRequest = new away.core.net.URLRequest("assets\/1024x1024.png");
	this.mipLoader = new away.core.net.IMGLoader("");
	this.mipLoader.load(mipUrlRequest);
	this.mipLoader.addEventListener(away.events.Event.COMPLETE, $createStaticDelegate(this, this.mipImgLoaded), this);
};

examples.BitmapTextureTest.prototype.mipImgLoaded = function(e) {
	var loader = e.target;
	var rect = new away.core.geom.Rectangle(0, 0, this.mipLoader.get_width(), this.mipLoader.get_height());
	this.bitmapData = new away.core.display.BitmapData(loader.get_width(), loader.get_height(), true, -1);
	this.bitmapData.drawImage(this.mipLoader.get_image(), rect, rect);
	this.target = new away.textures.BitmapTexture(this.bitmapData, true);
	away.utils.Debug.log("bitmapData", this.bitmapData);
	away.utils.Debug.log("target", this.target);
};

examples.BitmapTextureTest.className = "examples.BitmapTextureTest";

examples.BitmapTextureTest.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.utils.Debug');
	p.push('away.events.Event');
	p.push('away.core.net.URLRequest');
	p.push('away.textures.BitmapTexture');
	p.push('away.core.geom.Rectangle');
	p.push('away.core.display.BitmapData');
	p.push('away.core.net.IMGLoader');
	return p;
};

examples.BitmapTextureTest.getStaticDependencies = function(t) {
	var p;
	return [];
};

examples.BitmapTextureTest.injectionPoints = function(t) {
	return [];
};
