/** Compiled by the Randori compiler v0.2.6.2 on Wed Sep 25 08:00:44 EST 2013 */

if (typeof examples == "undefined")
	var examples = {};

examples.BitmapDataTest = function() {
	this.urlRequest = null;
	this.bitmapData = null;
	this.bitmapDataB = null;
	this.imgLoader = null;
	var canvas = document.createElement("canvas");
	var transparent = true;
	var initcolour = 0xff00ffff;
	this.urlRequest = new away.net.URLRequest("assets\/130909wall_big.png");
	this.imgLoader = new away.net.IMGLoader("");
	this.imgLoader.load(this.urlRequest);
	this.imgLoader.addEventListener(away.events.Event.COMPLETE, $createStaticDelegate(this, this.imgLoaded), this);
	this.imgLoader.addEventListener(away.events.IOErrorEvent.IO_ERROR, $createStaticDelegate(this, this.imgLoadedError), this);
	this.bitmapData = new away.display.BitmapData(256, 256, transparent, initcolour);
	document.body.appendChild(this.bitmapData.get_canvas());
	this.bitmapDataB = new away.display.BitmapData(256, 256, transparent, initcolour);
	this.bitmapDataB.get_canvas().style.position = "absolute";
	this.bitmapDataB.get_canvas().style.left = "540px";
	document.body.appendChild(this.bitmapDataB.get_canvas());
	console["time"]("bitmapdata");
	this.bitmapDataB.lock();
	for (var i = 0; i < 10000; i++) {
		var x = Math.random() * this.bitmapDataB.get_width() | 0;
		var y = Math.random() * this.bitmapDataB.get_height() | 0;
		this.bitmapDataB.setPixel(x, y, Math.random() * 0xffFFFFFF);
	}
	this.bitmapDataB.unlock();
	console["timeEnd"]("bitmapdata");
	var that = this;
	document.onmousedown = function(e) {
		that.onMouseDown(e);
	};
};

examples.BitmapDataTest.prototype.onMouseDown = function(e) {
	if (this.bitmapData.get_width() === 512) {
		if (this.imgLoader.get_loaded()) {
			this.bitmapDataB.lock();
			this.bitmapData.set_width(256);
			this.bitmapData.set_height(256);
			var rect = new away.geom.Rectangle(0, 0, this.imgLoader.get_width(), this.imgLoader.get_height());
			this.bitmapData.drawImage(this.imgLoader.get_image(), rect, rect);
			rect.width = rect.width * 2;
			rect.height = rect.height * 2;
			this.bitmapDataB.copyPixels(this.bitmapData, this.bitmapData.get_rect(), rect);
			for (var d = 0; d < 1000; d++) {
				var x = Math.random() * this.bitmapDataB.get_width() | 0;
				var y = Math.random() * this.bitmapDataB.get_height() | 0;
				this.bitmapDataB.setPixel(x, y, Math.random() * 0xFFFFFFFF);
			}
			this.bitmapDataB.unlock();
		} else {
			this.bitmapData.set_width(256);
			this.bitmapData.set_height(256);
			this.bitmapData.fillRect(this.bitmapData.get_rect(), 0xffff0000);
		}
	} else {
		this.bitmapData.lock();
		this.bitmapData.set_width(512);
		this.bitmapData.set_height(512);
		this.bitmapData.fillRect(this.bitmapData.get_rect(), 0xffff0000);
		for (var d = 0; d < 1000; d++) {
			var x = Math.random() * this.bitmapData.get_width() | 0;
			var y = Math.random() * this.bitmapData.get_height() | 0;
			this.bitmapData.setPixel(x, y, Math.random() * 0xFFFFFFFF);
		}
		this.bitmapData.unlock();
		var targetRect = this.bitmapDataB.get_rect().clone();
		targetRect.width = targetRect.width / 2;
		targetRect.height = targetRect.height / 2;
		this.bitmapDataB.copyPixels(this.bitmapData, this.bitmapDataB.get_rect(), targetRect);
	}
	var m = new away.geom.Matrix(.5, .08, .08, .5, this.imgLoader.get_width() / 2, this.imgLoader.get_height() / 2);
	this.bitmapData.draw(this.bitmapData, m);
	this.bitmapData.setPixel32(0, 0, 0xccff0000);
	this.bitmapData.setPixel32(1, 0, 0xcc00ff00);
	this.bitmapData.setPixel32(2, 0, 0xcc0000ff);
	this.bitmapDataB.draw(this.bitmapData, m);
	console.log("GetPixel 0,0: ", away.utils.ColorUtils.ARGBToHexString(away.utils.ColorUtils.float32ColorToARGB(this.bitmapData.getPixel(0, 0))));
	console.log("GetPixel 1,0: ", away.utils.ColorUtils.ARGBToHexString(away.utils.ColorUtils.float32ColorToARGB(this.bitmapData.getPixel(1, 0))));
	console.log("GetPixel 2,0: ", away.utils.ColorUtils.ARGBToHexString(away.utils.ColorUtils.float32ColorToARGB(this.bitmapData.getPixel(2, 0))));
};

examples.BitmapDataTest.prototype.imgLoadedError = function(e) {
	console.log("error");
};

examples.BitmapDataTest.prototype.imgLoaded = function(e) {
	this.bitmapData.drawImage(this.imgLoader.get_image(), new away.geom.Rectangle(0, 0, this.imgLoader.get_width(), this.imgLoader.get_height()), new away.geom.Rectangle(0, 0, this.imgLoader.get_width() / 2, this.imgLoader.get_height() / 2));
	var m = new away.geom.Matrix(.5, .08, .08, .5, this.imgLoader.get_width() / 2, this.imgLoader.get_height() / 2);
	this.bitmapData.draw(this.bitmapData, m);
};

examples.BitmapDataTest.className = "examples.BitmapDataTest";

examples.BitmapDataTest.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.net.URLRequest');
	p.push('away.events.Event');
	p.push('away.net.IMGLoader');
	p.push('away.geom.Matrix');
	p.push('away.geom.Rectangle');
	p.push('away.display.BitmapData');
	p.push('away.utils.ColorUtils');
	p.push('away.events.IOErrorEvent');
	return p;
};

examples.BitmapDataTest.getStaticDependencies = function(t) {
	var p;
	return [];
};

examples.BitmapDataTest.injectionPoints = function(t) {
	return [];
};
