/** Compiled by the Randori compiler v0.2.6.2 on Wed Sep 25 20:13:44 EST 2013 */

if (typeof examples == "undefined")
	var examples = {};

examples.BitmapTextureTest = function() {
	this.mipLoader = null;
	this.bitmapData = null;
	this.target = null;
	this.texture = null;
	var canvas = document.createElement("canvas");
	var GL = canvas.getContext("experimental-webgl");
	var mipUrlRequest = new away.net.URLRequest("assets\/1024x1024.png");
	this.mipLoader = new away.net.IMGLoader("");
	this.mipLoader.load(mipUrlRequest);
	this.mipLoader.addEventListener(away.events.Event.COMPLETE, $createStaticDelegate(this, this.mipImgLoaded), this);
};

examples.BitmapTextureTest.prototype.mipImgLoaded = function(e) {
	var loader = e.target;
	var rect = new away.geom.Rectangle(0, 0, this.mipLoader.get_width(), this.mipLoader.get_height());
	this.bitmapData = new away.display.BitmapData(loader.get_width(), loader.get_height(), true, -1);
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
	p.push('away.net.URLRequest');
	p.push('away.events.Event');
	p.push('away.textures.BitmapTexture');
	p.push('away.net.IMGLoader');
	p.push('away.geom.Rectangle');
	p.push('away.display.BitmapData');
	return p;
};

examples.BitmapTextureTest.getStaticDependencies = function(t) {
	var p;
	return [];
};

examples.BitmapTextureTest.injectionPoints = function(t) {
	return [];
};
