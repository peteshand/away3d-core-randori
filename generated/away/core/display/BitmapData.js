/** Compiled by the Randori compiler v0.2.5.2 on Sat Oct 12 02:16:01 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.core == "undefined")
	away.core = {};
if (typeof away.core.display == "undefined")
	away.core.display = {};

away.core.display.BitmapData = function(width, height, transparent, fillColor) {
	this._locked = false;
	this._context = null;
	this._rect = null;
	this._alpha = 1;
	this._transparent = false;
	this._imageData = null;
	this._imageCanvas = null;
	fillColor = fillColor || -1;
	this._transparent = transparent;
	this._imageCanvas = document.createElement("canvas");
	this._imageCanvas.width = width;
	this._imageCanvas.height = height;
	this._context = this._imageCanvas.getContext("2d");
	this._rect = new away.core.geom.Rectangle(0, 0, width, height);
	if (fillColor != -1) {
		if (this._transparent) {
			this._alpha = away.utils.ColorUtils.float32ColorToARGB(fillColor)[0] / 255;
		} else {
			this._alpha = 1;
		}
		this.fillRect(this._rect, fillColor);
	}
};

away.core.display.BitmapData.prototype.dispose = function() {
	this._context = null;
	this._imageCanvas = null;
	this._imageData = null;
	this._rect = null;
	this._transparent = null;
	this._locked = null;
};

away.core.display.BitmapData.prototype.lock = function() {
	this._locked = true;
	this._imageData = this._context.getImageData(0, 0, this._rect.width, this._rect.height);
};

away.core.display.BitmapData.prototype.unlock = function() {
	this._locked = false;
	if (this._imageData) {
		this._context.putImageData(this._imageData, 0, 0, 0, 0, 0, 0);
		this._imageData = null;
	}
};

away.core.display.BitmapData.prototype.getPixel = function(x, y) {
	var r;
	var g;
	var b;
	var a;
	var index = (x + y * this._imageCanvas.width) * 4;
	if (!this._locked) {
		this._imageData = this._context.getImageData(0, 0, this._rect.width, this._rect.height);
		r = this._imageData.data[index + 0];
		g = this._imageData.data[index + 1];
		b = this._imageData.data[index + 2];
		a = this._imageData.data[index + 3];
	} else {
		if (this._imageData) {
			this._context.putImageData(this._imageData, 0, 0, 0, 0, 0, 0);
		}
		this._imageData = this._context.getImageData(0, 0, this._rect.width, this._rect.height);
		r = this._imageData.data[index + 0];
		g = this._imageData.data[index + 1];
		b = this._imageData.data[index + 2];
		a = this._imageData.data[index + 3];
	}
	if (!this._locked) {
		this._imageData = null;
	}
	return (a << 24) | (r << 16) | (g << 8) | b;
};

away.core.display.BitmapData.prototype.setPixel = function(x, y, color) {
	var argb = away.utils.ColorUtils.float32ColorToARGB(color);
	if (!this._locked) {
		this._imageData = this._context.getImageData(0, 0, this._rect.width, this._rect.height);
	}
	if (this._imageData) {
		var index = (x + y * this._imageCanvas.width) * 4;
		this._imageData.data[index + 0] = argb[1];
		this._imageData.data[index + 1] = argb[2];
		this._imageData.data[index + 2] = argb[3];
		this._imageData.data[index + 3] = 255;
	}
	if (!this._locked) {
		this._context.putImageData(this._imageData, 0, 0, 0, 0, 0, 0);
		this._imageData = null;
	}
};

away.core.display.BitmapData.prototype.setPixel32 = function(x, y, color) {
	var argb = away.utils.ColorUtils.float32ColorToARGB(color);
	if (!this._locked) {
		this._imageData = this._context.getImageData(0, 0, this._rect.width, this._rect.height);
	}
	if (this._imageData) {
		var index = (x + y * this._imageCanvas.width) * 4;
		this._imageData.data[index + 0] = argb[1];
		this._imageData.data[index + 1] = argb[2];
		this._imageData.data[index + 2] = argb[3];
		this._imageData.data[index + 3] = argb[0];
	}
	if (!this._locked) {
		this._context.putImageData(this._imageData, 0, 0, 0, 0, 0, 0);
		this._imageData = null;
	}
};

away.core.display.BitmapData.prototype.drawImage = function(img, sourceRect, destRect) {
	if (this._locked) {
		if (this._imageData) {
			this._context.putImageData(this._imageData, 0, 0, 0, 0, 0, 0);
		}
		this._drawImage(img, sourceRect, destRect);
		if (this._imageData) {
			this._imageData = this._context.getImageData(0, 0, this._rect.width, this._rect.height);
		}
	} else {
		this._drawImage(img, sourceRect, destRect);
	}
};

away.core.display.BitmapData.prototype._drawImage = function(img, sourceRect, destRect) {
	if (img instanceof away.core.display.BitmapData) {
		var bmd = img;
		this._context.drawImage(bmd.get_canvas(), sourceRect.x, sourceRect.y, sourceRect.width, sourceRect.height, destRect.x, destRect.y, destRect.width, destRect.height);
	} else if (img instanceof HTMLImageElement) {
		var image = img;
		this._context.drawImage(image, sourceRect.x, sourceRect.y, sourceRect.width, sourceRect.height, destRect.x, destRect.y, destRect.width, destRect.height);
	}
};

away.core.display.BitmapData.prototype.copyPixels = function(bmpd, sourceRect, destRect) {
	if (this._locked) {
		if (this._imageData) {
			this._context.putImageData(this._imageData, 0, 0, 0, 0, 0, 0);
		}
		this._copyPixels(bmpd, sourceRect, destRect);
		if (this._imageData) {
			this._imageData = this._context.getImageData(0, 0, this._rect.width, this._rect.height);
		}
	} else {
		this._copyPixels(bmpd, sourceRect, destRect);
	}
};

away.core.display.BitmapData.prototype._copyPixels = function(bmpd, sourceRect, destRect) {
	if (bmpd instanceof away.core.display.BitmapData) {
		var bmd = bmpd;
		this._context.drawImage(bmd.get_canvas(), sourceRect.x, sourceRect.y, sourceRect.width, sourceRect.height, destRect.x, destRect.y, destRect.width, destRect.height);
	} else if (bmpd instanceof HTMLImageElement) {
		var image = bmpd;
		this._context.drawImage(image, sourceRect.x, sourceRect.y, sourceRect.width, sourceRect.height, destRect.x, destRect.y, destRect.width, destRect.height);
	}
};

away.core.display.BitmapData.prototype.fillRect = function(rect, color) {
	if (this._locked) {
		if (this._imageData) {
			this._context.putImageData(this._imageData, 0, 0, 0, 0, 0, 0);
		}
		this._context.fillStyle = this.hexToRGBACSS(color);
		this._context.fillRect(rect.x, rect.y, rect.width, rect.height);
		if (this._imageData) {
			this._imageData = this._context.getImageData(0, 0, this._rect.width, this._rect.height);
		}
	} else {
		this._context.fillStyle = this.hexToRGBACSS(color);
		this._context.fillRect(rect.x, rect.y, rect.width, rect.height);
	}
};

away.core.display.BitmapData.prototype.draw = function(source, matrix) {
	if (this._locked) {
		if (this._imageData) {
			this._context.putImageData(this._imageData, 0, 0, 0, 0, 0, 0);
		}
		this._draw(source, matrix);
		if (this._imageData) {
			this._imageData = this._context.getImageData(0, 0, this._rect.width, this._rect.height);
		}
	} else {
		this._draw(source, matrix);
	}
};

away.core.display.BitmapData.prototype._draw = function(source, matrix) {
	if (source instanceof away.core.display.BitmapData) {
		var bmd = source;
		this._context.save();
		this._context.setTransform(matrix.a, matrix.b, matrix.c, matrix.d, matrix.tx, matrix.ty);
		this._context.drawImage(bmd.get_canvas(), 0, 0);
		this._context.restore();
	} else if (source instanceof HTMLImageElement) {
		var image = source;
		this._context.save();
		this._context.setTransform(matrix.a, matrix.b, matrix.c, matrix.d, matrix.tx, matrix.ty);
		this._context.drawImage(image, 0, 0);
		this._context.restore();
	}
};

away.core.display.BitmapData.prototype.set_imageData = function(value) {
	this._context.putImageData(value, 0, 0, 0, 0, 0, 0);
};

away.core.display.BitmapData.prototype.get_imageData = function() {
	return this._context.getImageData(0, 0, this._rect.width, this._rect.height);
};

away.core.display.BitmapData.prototype.get_width = function() {
	return this._imageCanvas.width;
};

away.core.display.BitmapData.prototype.set_width = function(value) {
	this._rect.width = value;
	this._imageCanvas.width = value;
};

away.core.display.BitmapData.prototype.get_height = function() {
	return this._imageCanvas.height;
};

away.core.display.BitmapData.prototype.set_height = function(value) {
	this._rect.height = value;
	this._imageCanvas.height = value;
};

away.core.display.BitmapData.prototype.get_rect = function() {
	return this._rect;
};

away.core.display.BitmapData.prototype.get_canvas = function() {
	return this._imageCanvas;
};

away.core.display.BitmapData.prototype.get_context = function() {
	return this._context;
};

away.core.display.BitmapData.prototype.hexToRGBACSS = function(d) {
	var argb = away.utils.ColorUtils.float32ColorToARGB(d);
	if (this._transparent == false) {
		argb[0] = 1;
		return "rgba(" + argb[1] + "," + argb[2] + "," + argb[3] + "," + argb[0] + ")";
	}
	return "rgba(" + argb[1] + "," + argb[2] + "," + argb[3] + "," + argb[0] / 255 + ")";
};

away.core.display.BitmapData.className = "away.core.display.BitmapData";

away.core.display.BitmapData.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.core.geom.Matrix');
	p.push('away.utils.ColorUtils');
	p.push('away.core.geom.Rectangle');
	return p;
};

away.core.display.BitmapData.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.core.display.BitmapData.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'width', t:'Number'});
			p.push({n:'height', t:'Number'});
			p.push({n:'transparent', t:'Boolean'});
			p.push({n:'fillColor', t:'Number'});
			break;
		default:
			p = [];
			break;
	}
	return p;
};

