/** Compiled by the Randori compiler v0.2.6.2 on Thu Sep 05 22:29:08 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.textures == "undefined")
	away.textures = {};

away.textures.RenderTexture = function(width, height) {
	away.textures.Texture2DBase.call(this);
	this.pSetSize(width, height);
};

away.textures.RenderTexture.prototype.set_width = function(value) {
	if (value == this._pWidth) {
		return;
	}
	if (!away.utils.TextureUtils.isDimensionValid(value))
		throw new Error("Invalid size: Width and height must be power of 2 and cannot exceed 2048", 0);
	this.invalidateContent();
	this.pSetSize(value, this._pHeight);
};

away.textures.RenderTexture.prototype.set_height = function(value) {
	if (value == this._pHeight) {
		return;
	}
	if (!away.utils.TextureUtils.isDimensionValid(value)) {
		throw new Error("Invalid size: Width and height must be power of 2 and cannot exceed 2048", 0);
	}
	this.invalidateContent();
	this.pSetSize(this._pWidth, value);
};

away.textures.RenderTexture.prototype.pUploadContent = function(texture) {
	var bmp = new away.display.BitmapData(this.get_width(), this.get_height(), false, 0xff0000);
	away.materials.utils.MipmapGenerator.generateMipMaps(bmp, texture, null, false, -1);
	bmp.dispose();
};

away.textures.RenderTexture.prototype.pCreateTexture = function(context) {
	return context.createTexture(this.get_width(), this.get_height(), away.display3D.Context3DTextureFormat.BGRA, true, 0);
};

$inherit(away.textures.RenderTexture, away.textures.Texture2DBase);

away.textures.RenderTexture.className = "away.textures.RenderTexture";

away.textures.RenderTexture.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.materials.utils.MipmapGenerator');
	p.push('away.display3D.Context3DTextureFormat');
	p.push('away.display.BitmapData');
	p.push('away.utils.TextureUtils');
	return p;
};

away.textures.RenderTexture.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.textures.RenderTexture.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'width', t:'Number'});
			p.push({n:'height', t:'Number'});
			break;
		case 1:
			p = away.textures.Texture2DBase.injectionPoints(t);
			break;
		case 2:
			p = away.textures.Texture2DBase.injectionPoints(t);
			break;
		case 3:
			p = away.textures.Texture2DBase.injectionPoints(t);
			break;
		default:
			p = [];
			break;
	}
	return p;
};

