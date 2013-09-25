/** Compiled by the Randori compiler v0.2.6.2 on Wed Sep 25 08:00:47 EST 2013 */

if (typeof examples == "undefined")
	var examples = {};

examples.MipMapTest = function() {
	this.w = 0;
	this.mipLoader = null;
	this._rect = new away.geom.Rectangle(0, 0, 0, 0);
	this.sourceBitmap = null;
	this.h = 0;
	this.mipMap = null;
	this._matrix = new away.geom.Matrix(1, 0, 0, 1, 0, 0);
	var mipUrlRequest = new away.net.URLRequest("assets\/1024x1024.png");
	this.mipLoader = new away.net.IMGLoader("");
	this.mipLoader.load(mipUrlRequest);
	this.mipLoader.addEventListener(away.events.Event.COMPLETE, $createStaticDelegate(this, this.mipImgLoaded), this);
	var that = this;
	document.onmousedown = function(e) {
		that.onMouseDown(e);
	};
};

examples.MipMapTest.prototype.mipImgLoaded = function(e) {
	alert("Each click will generate a level of MipMap");
	var loader = e.target;
	this.sourceBitmap = new away.display.BitmapData(1024, 1024, true, 0xff0000);
	this.sourceBitmap.drawImage(loader.get_image(), this.sourceBitmap.get_rect(), this.sourceBitmap.get_rect());
	this.sourceBitmap.get_canvas().style.position = "absolute";
	this.sourceBitmap.get_canvas().style.left = "0px";
	this.sourceBitmap.get_canvas().style.top = "1030px";
	this.mipMap = new away.display.BitmapData(1024, 1024, true, 0xff0000);
	this.mipMap.get_canvas().style.position = "absolute";
	this.mipMap.get_canvas().style.left = "0px";
	this.mipMap.get_canvas().style.top = "0px";
	document.body.appendChild(this.mipMap.get_canvas());
	this._rect.width = this.sourceBitmap.get_width();
	this._rect.height = this.sourceBitmap.get_height();
	this.w = this.sourceBitmap.get_width();
	this.h = this.sourceBitmap.get_height();
};

examples.MipMapTest.prototype.onMouseDown = function(e) {
	this.generateMipMap(this.sourceBitmap, this.mipMap);
};

examples.MipMapTest.prototype.generateMipMap = function(source, mipmap, alpha, side) {
	var c = this.w;
	var i;
	console["time"]("MipMap" + c);
	if ((this.w >= 1) || (this.h >= 1)) {
		if (alpha) {
			mipmap.fillRect(this._rect, 0);
		}
		this._matrix.a = this._rect.width / source.get_width();
		this._matrix.d = this._rect.height / source.get_height();
		mipmap.set_width(this.w);
		mipmap.set_height(this.h);
		mipmap.copyPixels(source, source.get_rect(), new away.geom.Rectangle(0, 0, this.w, this.h));
		this.w >>= 1;
		this.h >>= 1;
		this._rect.width = this.w > 1 ? this.w : 1;
		this._rect.height = this.h > 1 ? this.h : 1;
	}
	console.log("TextureUtils.isBitmapDataValid: ", away.utils.TextureUtils.isBitmapDataValid(mipmap));
	console["timeEnd"]("MipMap" + c);
};

examples.MipMapTest.className = "examples.MipMapTest";

examples.MipMapTest.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.net.URLRequest');
	p.push('away.events.Event');
	p.push('away.net.IMGLoader');
	p.push('away.geom.Rectangle');
	p.push('away.display.BitmapData');
	p.push('away.utils.TextureUtils');
	return p;
};

examples.MipMapTest.getStaticDependencies = function(t) {
	var p;
	p = [];
	p.push('away.geom.Matrix');
	p.push('away.geom.Rectangle');
	return p;
};

examples.MipMapTest.injectionPoints = function(t) {
	return [];
};
