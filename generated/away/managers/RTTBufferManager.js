/** Compiled by the Randori compiler v0.2.6.2 on Tue Sep 03 00:11:46 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.managers == "undefined")
	away.managers = {};

away.managers.RTTBufferManager = function(se, stage3DProxy) {
	this._textureHeight = -1;
	this._viewHeight = -1;
	this._renderToTextureRect = null;
	this._textureWidth = -1;
	this._renderToScreenVertexBuffer = null;
	this._instances = null;
	this._textureRatioY = 0;
	this._textureRatioX = 0;
	this._buffersInvalid = true;
	this._viewWidth = -1;
	this._stage3DProxy = null;
	this._indexBuffer = null;
	this._renderToTextureVertexBuffer = null;
	away.events.EventDispatcher.call(this);
	if (!se) {
		throw new Error("No cheating the multiton!", 0);
	}
	this._renderToTextureRect = new away.geom.Rectangle(0, 0, 0, 0);
	this._stage3DProxy = stage3DProxy;
};

away.managers.RTTBufferManager._instances;

away.managers.RTTBufferManager.getInstance = function(stage3DProxy) {
	if (!stage3DProxy)
		throw new Error("stage3DProxy key cannot be null!", 0);
	if (away.managers.RTTBufferManager._instances == null) {
		away.managers.RTTBufferManager._instances = [];
	}
	var rttBufferManager = away.managers.RTTBufferManager.getRTTBufferManagerFromStage3DProxy(stage3DProxy);
	if (rttBufferManager == null) {
		rttBufferManager = new away.managers.RTTBufferManager(new away.managers.SingletonEnforcer(), stage3DProxy);
		var vo = new away.managers.RTTBufferManagerVO();
		vo.stage3dProxy = stage3DProxy;
		vo.rttbfm = rttBufferManager;
		away.managers.RTTBufferManager._instances.push(vo);
	}
	return rttBufferManager;
};

away.managers.RTTBufferManager.getRTTBufferManagerFromStage3DProxy = function(stage3DProxy) {
	var l = away.managers.RTTBufferManager._instances.length;
	var r;
	for (var c = 0; c < l; c++) {
		r = away.managers.RTTBufferManager._instances[c];
		if (r.stage3dProxy === stage3DProxy) {
			return r.rttbfm;
		}
	}
	return null;
};

away.managers.RTTBufferManager.deleteRTTBufferManager = function(stage3DProxy) {
	var l = away.managers.RTTBufferManager._instances.length;
	var r;
	for (var c = 0; c < l; c++) {
		r = away.managers.RTTBufferManager._instances[c];
		if (r.stage3dProxy === stage3DProxy) {
			away.managers.RTTBufferManager._instances.splice(c, 1);
			return;
		}
	}
};

away.managers.RTTBufferManager.prototype.get_textureRatioX = function() {
	if (this._buffersInvalid) {
		this.updateRTTBuffers();
	}
	return this._textureRatioX;
};

away.managers.RTTBufferManager.prototype.get_textureRatioY = function() {
	if (this._buffersInvalid) {
		this.updateRTTBuffers();
	}
	return this._textureRatioY;
};

away.managers.RTTBufferManager.prototype.get_viewWidth = function() {
	return this._viewWidth;
};

away.managers.RTTBufferManager.prototype.set_viewWidth = function(value) {
	if (value == this._viewWidth) {
		return;
	}
	this._viewWidth = value;
	this._buffersInvalid = true;
	this._textureWidth = away.utils.TextureUtils.getBestPowerOf2(this._viewWidth);
	if (this._textureWidth > this._viewWidth) {
		this._renderToTextureRect.x = Math.floor((this._textureWidth - this._viewWidth) * .5);
		this._renderToTextureRect.width = this._viewWidth;
	} else {
		this._renderToTextureRect.x = 0;
		this._renderToTextureRect.width = this._textureWidth;
	}
	this.dispatchEvent(new away.events.Event(away.events.Event.RESIZE));
};

away.managers.RTTBufferManager.prototype.get_viewHeight = function() {
	return this._viewHeight;
};

away.managers.RTTBufferManager.prototype.set_viewHeight = function(value) {
	if (value == this._viewHeight) {
		return;
	}
	this._viewHeight = value;
	this._buffersInvalid = true;
	this._textureHeight = away.utils.TextureUtils.getBestPowerOf2(this._viewHeight);
	if (this._textureHeight > this._viewHeight) {
		this._renderToTextureRect.y = Math.floor((this._textureHeight - this._viewHeight) * .5);
		this._renderToTextureRect.height = this._viewHeight;
	} else {
		this._renderToTextureRect.y = 0;
		this._renderToTextureRect.height = this._textureHeight;
	}
	this.dispatchEvent(new away.events.Event(away.events.Event.RESIZE));
};

away.managers.RTTBufferManager.prototype.get_renderToTextureVertexBuffer = function() {
	if (this._buffersInvalid) {
		this.updateRTTBuffers();
	}
	return this._renderToTextureVertexBuffer;
};

away.managers.RTTBufferManager.prototype.get_renderToScreenVertexBuffer = function() {
	if (this._buffersInvalid) {
		this.updateRTTBuffers();
	}
	return this._renderToScreenVertexBuffer;
};

away.managers.RTTBufferManager.prototype.get_indexBuffer = function() {
	return this._indexBuffer;
};

away.managers.RTTBufferManager.prototype.get_renderToTextureRect = function() {
	if (this._buffersInvalid) {
		this.updateRTTBuffers();
	}
	return this._renderToTextureRect;
};

away.managers.RTTBufferManager.prototype.get_textureWidth = function() {
	return this._textureWidth;
};

away.managers.RTTBufferManager.prototype.get_textureHeight = function() {
	return this._textureHeight;
};

away.managers.RTTBufferManager.prototype.dispose = function() {
	away.managers.RTTBufferManager.deleteRTTBufferManager(this._stage3DProxy);
	if (this._indexBuffer) {
		this._indexBuffer.dispose();
		this._renderToScreenVertexBuffer.dispose();
		this._renderToTextureVertexBuffer.dispose();
		this._renderToScreenVertexBuffer = null;
		this._renderToTextureVertexBuffer = null;
		this._indexBuffer = null;
	}
};

away.managers.RTTBufferManager.prototype.updateRTTBuffers = function() {
	var context = this._stage3DProxy._iContext3D;
	var textureVerts;
	var screenVerts;
	var x;
	var y;
	if (this._renderToTextureVertexBuffer == null) {
		this._renderToTextureVertexBuffer = context.createVertexBuffer(4, 5);
	}
	if (this._renderToScreenVertexBuffer == null) {
		this._renderToScreenVertexBuffer = context.createVertexBuffer(4, 5);
	}
	if (!this._indexBuffer) {
		this._indexBuffer = context.createIndexBuffer(6);
		this._indexBuffer.uploadFromArray([2, 1, 0, 3, 2, 0], 0, 6);
	}
	this._textureRatioX = x = Math.min(this._viewWidth / this._textureWidth, 1);
	this._textureRatioY = y = Math.min(this._viewHeight / this._textureHeight, 1);
	var u1 = (1 - x) * .5;
	var u2 = (x + 1) * .5;
	var v1 = (y + 1) * .5;
	var v2 = (1 - y) * .5;
	textureVerts = [-x, -y, u1, v1, 0, x, -y, u2, v1, 1, x, y, u2, v2, 2, -x, y, u1, v2, 3];
	screenVerts = [-1, -1, u1, v1, 0, 1, -1, u2, v1, 1, 1, 1, u2, v2, 2, -1, 1, u1, v2, 3];
	this._renderToTextureVertexBuffer.uploadFromArray(textureVerts, 0, 4);
	this._renderToScreenVertexBuffer.uploadFromArray(screenVerts, 0, 4);
	this._buffersInvalid = false;
};

$inherit(away.managers.RTTBufferManager, away.events.EventDispatcher);

away.managers.RTTBufferManager.className = "away.managers.RTTBufferManager";

away.managers.RTTBufferManager.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.managers.RTTBufferManagerVO');
	p.push('away.events.Event');
	p.push('away.managers.SingletonEnforcer');
	p.push('away.geom.Rectangle');
	p.push('away.utils.TextureUtils');
	return p;
};

away.managers.RTTBufferManager.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.managers.RTTBufferManager.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'se', t:'away.managers.SingletonEnforcer'});
			p.push({n:'stage3DProxy', t:'away.managers.Stage3DProxy'});
			break;
		case 1:
			p = away.events.EventDispatcher.injectionPoints(t);
			break;
		case 2:
			p = away.events.EventDispatcher.injectionPoints(t);
			break;
		case 3:
			p = away.events.EventDispatcher.injectionPoints(t);
			break;
		default:
			p = [];
			break;
	}
	return p;
};

