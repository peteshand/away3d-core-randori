/** Compiled by the Randori compiler v0.2.6.2 on Sat Sep 21 16:02:31 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.textures == "undefined")
	away.textures = {};

away.textures.Texture2DBase = function() {
	away.textures.TextureProxyBase.call(this);
};

away.textures.Texture2DBase.prototype.pCreateTexture = function(context) {
	return context.createTexture(this.get_width(), this.get_height(), away.display3D.Context3DTextureFormat.BGRA, false, 0);
};

$inherit(away.textures.Texture2DBase, away.textures.TextureProxyBase);

away.textures.Texture2DBase.className = "away.textures.Texture2DBase";

away.textures.Texture2DBase.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.display3D.Context3DTextureFormat');
	return p;
};

away.textures.Texture2DBase.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.textures.Texture2DBase.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 1:
			p = away.textures.TextureProxyBase.injectionPoints(t);
			break;
		case 2:
			p = away.textures.TextureProxyBase.injectionPoints(t);
			break;
		case 3:
			p = away.textures.TextureProxyBase.injectionPoints(t);
			break;
		default:
			p = [];
			break;
	}
	return p;
};

