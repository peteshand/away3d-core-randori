/** Compiled by the Randori compiler v0.2.6.2 on Tue Sep 03 00:11:46 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.render == "undefined")
	away.render = {};

away.render.Filter3DRenderer = function(stage3DProxy) {
	this._stage3DProxy = null;
	this._requireDepthRender = null;
	this._filterSizesInvalid = true;
	this._mainInputTexture = null;
	this._tasks = null;
	this._filters = null;
	this._rttManager = null;
	this._filterTasksInvalid = null;
	this._stage3DProxy = stage3DProxy;
	this._rttManager = away.managers.RTTBufferManager.getInstance(stage3DProxy);
	this._rttManager.addEventListener(away.events.Event.RESIZE, $createStaticDelegate(, this.onRTTResize), this);
};

away.render.Filter3DRenderer.prototype.onRTTResize = function(event) {
	this._filterSizesInvalid = true;
};

away.render.Filter3DRenderer.prototype.get_requireDepthRender = function() {
	return this._requireDepthRender;
};

away.render.Filter3DRenderer.prototype.getMainInputTexture = function(stage3DProxy) {
	if (this._filterTasksInvalid) {
		this.updateFilterTasks(stage3DProxy);
	}
	return this._mainInputTexture;
};

away.render.Filter3DRenderer.prototype.get_filters = function() {
	return this._filters;
};

away.render.Filter3DRenderer.prototype.set_filters = function(value) {
	this._filters = value;
	this._filterTasksInvalid = true;
	this._requireDepthRender = false;
	if (!this._filters) {
		return;
	}
	for (var i = 0; i < this._filters.length; ++i) {
		var s = this._filters[i];
		var b = (s.requireDepthRender == null) ? false : s.requireDepthRender;
		this._requireDepthRender = this._requireDepthRender || b;
	}
	this._filterSizesInvalid = true;
};

away.render.Filter3DRenderer.prototype.updateFilterTasks = function(stage3DProxy) {
	var len;
	if (this._filterSizesInvalid) {
		this.updateFilterSizes();
	}
	if (!this._filters) {
		this._tasks = null;
		return;
	}
	this._tasks = [];
	len = this._filters.length - 1;
	var filter;
	for (var i = 0; i <= len; ++i) {
		filter = this._filters[i];
		filter.setRenderTargets(i == len ? null : this._filters[i + 1].getMainInputTexture(stage3DProxy), stage3DProxy);
		this._tasks = this._tasks.concat(filter.get_tasks());
	}
	this._mainInputTexture = this._filters[0].getMainInputTexture(stage3DProxy);
};

away.render.Filter3DRenderer.prototype.render = function(stage3DProxy, camera3D, depthTexture) {
	var len;
	var i;
	var task;
	var context = stage3DProxy._iContext3D;
	var indexBuffer = this._rttManager.get_indexBuffer();
	var vertexBuffer = this._rttManager.get_renderToTextureVertexBuffer();
	if (!this._filters) {
		return;
	}
	if (this._filterSizesInvalid) {
		this.updateFilterSizes();
	}
	if (this._filterTasksInvalid) {
		this.updateFilterTasks(stage3DProxy);
	}
	len = this._filters.length;
	for (i = 0; i < len; ++i) {
		this._filters[i].update(stage3DProxy, camera3D);
	}
	len = this._tasks.length;
	if (len > 1) {
		context.setVertexBufferAt(0, vertexBuffer, 0, away.display3D.Context3DVertexBufferFormat.FLOAT_2);
		context.setVertexBufferAt(1, vertexBuffer, 2, away.display3D.Context3DVertexBufferFormat.FLOAT_2);
	}
	for (i = 0; i < len; ++i) {
		task = this._tasks[i];
		stage3DProxy.setRenderTarget(task.get_target(), false, 0);
		if (!task.get_target()) {
			stage3DProxy.set_scissorRect(null);
			vertexBuffer = this._rttManager.get_renderToScreenVertexBuffer();
			context.setVertexBufferAt(0, vertexBuffer, 0, away.display3D.Context3DVertexBufferFormat.FLOAT_2);
			context.setVertexBufferAt(1, vertexBuffer, 2, away.display3D.Context3DVertexBufferFormat.FLOAT_2);
		}
		context.setTextureAt(0, task.getMainInputTexture(stage3DProxy));
		context.setProgram(task.getProgram3D(stage3DProxy));
		context.clear(0.0, 0.0, 0.0, 0.0, 1, 0, 0);
		task.activate(stage3DProxy, camera3D, depthTexture);
		context.setBlendFactors(away.display3D.Context3DBlendFactor.ONE, away.display3D.Context3DBlendFactor.ZERO);
		context.drawTriangles(indexBuffer, 0, 2);
		task.deactivate(stage3DProxy);
	}
	context.setTextureAt(0, null);
	context.setVertexBufferAt(0, null, 0);
	context.setVertexBufferAt(1, null, 0);
};

away.render.Filter3DRenderer.prototype.updateFilterSizes = function() {
	for (var i = 0; i < this._filters.length; ++i) {
		this._filters[i].textureWidth = this._rttManager.get_textureWidth();
		this._filters[i].textureHeight = this._rttManager.get_textureHeight();
	}
	this._filterSizesInvalid = true;
};

away.render.Filter3DRenderer.prototype.dispose = function() {
	this._rttManager.removeEventListener(away.events.Event.RESIZE, $createStaticDelegate(this, this.onRTTResize), this);
	this._rttManager = null;
	this._stage3DProxy = null;
};

away.render.Filter3DRenderer.className = "away.render.Filter3DRenderer";

away.render.Filter3DRenderer.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.events.Event');
	p.push('away.display3D.Context3DBlendFactor');
	p.push('away.display3D.Context3DVertexBufferFormat');
	p.push('away.filters.tasks.Filter3DTaskBase');
	p.push('away.managers.RTTBufferManager');
	p.push('away.filters.Filter3DBase');
	return p;
};

away.render.Filter3DRenderer.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.render.Filter3DRenderer.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'stage3DProxy', t:'away.managers.Stage3DProxy'});
			break;
		default:
			p = [];
			break;
	}
	return p;
};

