/** Compiled by the Randori compiler v0.2.6.2 on Tue Sep 03 00:11:46 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.textures == "undefined")
	away.textures = {};

away.textures.CubeTextureBase = function() {
	away.textures.TextureProxyBase.call(this);
};

away.textures.CubeTextureBase.prototype.get_size = function() {
	return this.get_width();
};

away.textures.CubeTextureBase.prototype.pCreateTexture = function(context) {
	return context.createCubeTexture(this.get_width(), away.display3D.Context3DTextureFormat.BGRA, false, 0);
};

$inherit(away.textures.CubeTextureBase, away.textures.TextureProxyBase);

away.textures.CubeTextureBase.className = "away.textures.CubeTextureBase";

away.textures.CubeTextureBase.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.display3D.Context3DTextureFormat');
	return p;
};

away.textures.CubeTextureBase.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.textures.CubeTextureBase.injectionPoints = function(t) {
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

