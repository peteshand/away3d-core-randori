/** Compiled by the Randori compiler v0.2.6.2 on Tue Sep 10 22:28:14 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.display3D == "undefined")
	away.display3D = {};

away.display3D.Context3D = function(canvas) {
	this._currentWrap = 0;
	this._blendDestinationFactor = 0;
	this._blendSourceFactor = 0;
	this._vertexBufferList = [];
	this._currentFilter = 0;
	this._samplerStates = [];
	this._blendEnabled = null;
	this._currentMipFilter = 0;
	this._drawing = null;
	this._indexBufferList = [];
	this._textureList = [];
	this._programList = [];
	this._gl = null;
	this._currentProgram = null;
	try {
		this._gl = canvas.getContext("experimental-webgl");
		if (!this._gl) {
			this._gl = canvas.getContext("webgl");
		}
	} catch (e) {
	}
	if (this._gl) {
	} else {
		console.log("WebGL is not available.");
	}
	for (var i = 0; i < away.display3D.Context3D.MAX_SAMPLERS; ++i) {
		this._samplerStates[i] = new away.display3D.SamplerState();
		this._samplerStates[i].wrap = 10497;
		this._samplerStates[i].filter = 9729;
		this._samplerStates[i].mipfilter = 0;
	}
};

away.display3D.Context3D.MAX_SAMPLERS = 8;

away.display3D.Context3D.prototype.gl = function() {
	return this._gl;
};

away.display3D.Context3D.prototype.clear = function(red, green, blue, alpha, depth, stencil, mask) {
	if (!this._drawing) {
		this.updateBlendStatus();
		this._drawing = true;
	}
	this._gl.clearColor(red, green, blue, alpha);
	this._gl.clearDepth(depth);
	this._gl.clearStencil(stencil);
	this._gl.clear(mask);
};

away.display3D.Context3D.prototype.configureBackBuffer = function(width, height, antiAlias, enableDepthAndStencil) {
	if (enableDepthAndStencil) {
		this._gl.enable(2960);
		this._gl.enable(2929);
	}
	this._gl.viewport.width = width;
	this._gl.viewport.height = height;
	this._gl.viewport(0, 0, width, height);
};

away.display3D.Context3D.prototype.createCubeTexture = function(size, format, optimizeForRenderToTexture, streamingLevels) {
	var texture = new away.display3D.CubeTexture(this._gl, size);
	this._textureList.push(texture);
	return texture;
};

away.display3D.Context3D.prototype.createIndexBuffer = function(numIndices) {
	var indexBuffer = new away.display3D.IndexBuffer3D(this._gl, numIndices);
	this._indexBufferList.push(indexBuffer);
	return indexBuffer;
};

away.display3D.Context3D.prototype.createProgram = function() {
	var program = new away.display3D.Program3D(this._gl);
	this._programList.push(program);
	return program;
};

away.display3D.Context3D.prototype.createTexture = function(width, height, format, optimizeForRenderToTexture, streamingLevels) {
	var texture = new away.display3D.Texture(this._gl, width, height);
	this._textureList.push(texture);
	return texture;
};

away.display3D.Context3D.prototype.createVertexBuffer = function(numVertices, data32PerVertex) {
	var vertexBuffer = new away.display3D.VertexBuffer3D(this._gl, numVertices, data32PerVertex);
	this._vertexBufferList.push(vertexBuffer);
	return vertexBuffer;
};

away.display3D.Context3D.prototype.dispose = function() {
	var i;
	for (i = 0; i < this._indexBufferList.length; ++i) {
		this._indexBufferList[i].dispose();
	}
	this._indexBufferList = null;
	for (i = 0; i < this._vertexBufferList.length; ++i) {
		this._vertexBufferList[i].dispose();
	}
	this._vertexBufferList = null;
	for (i = 0; i < this._textureList.length; ++i) {
		this._textureList[i].dispose();
	}
	this._textureList = null;
	for (i = 0; i < this._programList.length; ++i) {
		this._programList[i].dispose();
	}
	for (i = 0; i < this._samplerStates.length; ++i) {
		this._samplerStates[i] = null;
	}
	this._programList = null;
};

away.display3D.Context3D.prototype.drawToBitmapData = function(destination) {
	throw new away.errors.PartialImplementationError("", 0);
};

away.display3D.Context3D.prototype.drawTriangles = function(indexBuffer, firstIndex, numTriangles) {
	if (!this._drawing) {
		throw "Need to clear before drawing if the buffer has not been cleared since the last present() call.";
	}
	var numIndices = 0;
	if (numTriangles == -1) {
		numIndices = indexBuffer.get_numIndices();
	} else {
		numIndices = numTriangles * 3;
	}
	this._gl.bindBuffer(34963, indexBuffer.get_glBuffer());
	this._gl.drawElements(4, numIndices, 5123, firstIndex);
};

away.display3D.Context3D.prototype.present = function() {
	this._drawing = false;
};

away.display3D.Context3D.prototype.setBlendFactors = function(sourceFactor, destinationFactor) {
	this._blendEnabled = true;
	switch (sourceFactor) {
		case away.display3D.Context3DBlendFactor.ONE:
			this._blendSourceFactor = 1;
			break;
		case away.display3D.Context3DBlendFactor.DESTINATION_ALPHA:
			this._blendSourceFactor = 772;
			break;
		case away.display3D.Context3DBlendFactor.DESTINATION_COLOR:
			this._blendSourceFactor = 774;
			break;
		case away.display3D.Context3DBlendFactor.ONE:
			this._blendSourceFactor = 1;
			break;
		case away.display3D.Context3DBlendFactor.ONE_MINUS_DESTINATION_ALPHA:
			this._blendSourceFactor = 773;
			break;
		case away.display3D.Context3DBlendFactor.ONE_MINUS_DESTINATION_COLOR:
			this._blendSourceFactor = 775;
			break;
		case away.display3D.Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA:
			this._blendSourceFactor = 771;
			break;
		case away.display3D.Context3DBlendFactor.ONE_MINUS_SOURCE_COLOR:
			this._blendSourceFactor = 769;
			break;
		case away.display3D.Context3DBlendFactor.SOURCE_ALPHA:
			this._blendSourceFactor = 770;
			break;
		case away.display3D.Context3DBlendFactor.SOURCE_COLOR:
			this._blendSourceFactor = 768;
			break;
		case away.display3D.Context3DBlendFactor.ZERO:
			this._blendSourceFactor = 0;
			break;
		default:
			throw "Unknown blend source factor";
			break;
	}
	switch (destinationFactor) {
		case away.display3D.Context3DBlendFactor.ONE:
			this._blendDestinationFactor = 1;
			break;
		case away.display3D.Context3DBlendFactor.DESTINATION_ALPHA:
			this._blendDestinationFactor = 772;
			break;
		case away.display3D.Context3DBlendFactor.DESTINATION_COLOR:
			this._blendDestinationFactor = 774;
			break;
		case away.display3D.Context3DBlendFactor.ONE:
			this._blendDestinationFactor = 1;
			break;
		case away.display3D.Context3DBlendFactor.ONE_MINUS_DESTINATION_ALPHA:
			this._blendDestinationFactor = 773;
			break;
		case away.display3D.Context3DBlendFactor.ONE_MINUS_DESTINATION_COLOR:
			this._blendDestinationFactor = 775;
			break;
		case away.display3D.Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA:
			this._blendDestinationFactor = 771;
			break;
		case away.display3D.Context3DBlendFactor.ONE_MINUS_SOURCE_COLOR:
			this._blendDestinationFactor = 769;
			break;
		case away.display3D.Context3DBlendFactor.SOURCE_ALPHA:
			this._blendDestinationFactor = 770;
			break;
		case away.display3D.Context3DBlendFactor.SOURCE_COLOR:
			this._blendDestinationFactor = 768;
			break;
		case away.display3D.Context3DBlendFactor.ZERO:
			this._blendDestinationFactor = 0;
			break;
		default:
			throw "Unknown blend destination factor";
			break;
	}
	this.updateBlendStatus();
};

away.display3D.Context3D.prototype.setColorMask = function(red, green, blue, alpha) {
	this._gl.colorMask(red, green, blue, alpha);
};

away.display3D.Context3D.prototype.setCulling = function(triangleFaceToCull) {
	if (triangleFaceToCull == away.display3D.Context3DTriangleFace.NONE) {
		this._gl.disable(2884);
	} else {
		this._gl.enable(2884);
		switch (triangleFaceToCull) {
			case away.display3D.Context3DTriangleFace.FRONT:
				this._gl.cullFace(1028);
				break;
			case away.display3D.Context3DTriangleFace.BACK:
				this._gl.cullFace(1029);
				break;
			case away.display3D.Context3DTriangleFace.FRONT_AND_BACK:
				this._gl.cullFace(1032);
				break;
			default:
				throw "Unknown Context3DTriangleFace type.";
		}
	}
};

away.display3D.Context3D.prototype.setDepthTest = function(depthMask, passCompareMode) {
	switch (passCompareMode) {
		case away.display3D.Context3DCompareMode.ALWAYS:
			this._gl.depthFunc(519);
			break;
		case away.display3D.Context3DCompareMode.EQUAL:
			this._gl.depthFunc(514);
			break;
		case away.display3D.Context3DCompareMode.GREATER:
			this._gl.depthFunc(516);
			break;
		case away.display3D.Context3DCompareMode.GREATER_EQUAL:
			this._gl.depthFunc(518);
			break;
		case away.display3D.Context3DCompareMode.LESS:
			this._gl.depthFunc(513);
			break;
		case away.display3D.Context3DCompareMode.LESS_EQUAL:
			this._gl.depthFunc(515);
			break;
		case away.display3D.Context3DCompareMode.NEVER:
			this._gl.depthFunc(512);
			break;
		case away.display3D.Context3DCompareMode.NOT_EQUAL:
			this._gl.depthFunc(517);
			break;
		default:
			throw "Unknown Context3DCompareMode type.";
			break;
	}
	this._gl.depthMask(depthMask);
};

away.display3D.Context3D.prototype.setProgram = function(program3D) {
	this._currentProgram = program3D;
	program3D.focusProgram();
};

away.display3D.Context3D.prototype.getUniformLocationNameFromAgalRegisterIndex = function(programType, firstRegister) {
	switch (programType) {
		case away.display3D.Context3DProgramType.VERTEX:
			return "vc";
			break;
		case away.display3D.Context3DProgramType.FRAGMENT:
			return "fc";
			break;
		default:
			throw "Program Type " + programType + " not supported";
	}
};

away.display3D.Context3D.prototype.setProgramConstantsFromMatrix = function(programType, firstRegister, matrix, transposedMatrix) {
	var locationName = this.getUniformLocationNameFromAgalRegisterIndex(programType, firstRegister);
	this.setGLSLProgramConstantsFromMatrix(locationName, matrix, transposedMatrix);
};

away.display3D.Context3D.modulo = 0;

away.display3D.Context3D.prototype.setProgramConstantsFromArray = function(programType, firstRegister, data, numRegisters) {
	for (var i = 0; i < numRegisters; ++i) {
		var currentIndex = i * 4;
		var locationName = this.getUniformLocationNameFromAgalRegisterIndex(programType, firstRegister + i) + (i + firstRegister);
		this.setGLSLProgramConstantsFromArray(locationName, data, currentIndex);
	}
};

away.display3D.Context3D.prototype.setGLSLProgramConstantsFromMatrix = function(locationName, matrix, transposedMatrix) {
	var location = this._gl.getUniformLocation(this._currentProgram.get_glProgram(), locationName);
	this._gl.uniformMatrix4fv(location, !transposedMatrix, new Float32Array(matrix.rawData));
};

away.display3D.Context3D.prototype.setGLSLProgramConstantsFromArray = function(locationName, data, startIndex) {
	var location = this._gl.getUniformLocation(this._currentProgram.get_glProgram(), locationName);
	this._gl.uniform4f(location, data[startIndex], data[startIndex + 1], data[startIndex + 2], data[startIndex + 3]);
};

away.display3D.Context3D.prototype.setScissorRectangle = function(rectangle) {
	if (!rectangle) {
		this._gl.disable(3089);
		return;
	}
	this._gl.enable(3089);
	this._gl.scissor(rectangle.x, rectangle.y, rectangle.width, rectangle.height);
};

away.display3D.Context3D.prototype.setTextureAt = function(sampler, texture) {
	var locationName = "fs" + sampler;
	this.setGLSLTextureAt(locationName, texture, sampler);
};

away.display3D.Context3D.prototype.setGLSLTextureAt = function(locationName, texture, textureIndex) {
	if (!texture) {
		this._gl.activeTexture(33984 + textureIndex);
		this._gl.bindTexture(3553, null);
		return;
	}
	var location = this._gl.getUniformLocation(this._currentProgram.get_glProgram(), locationName);
	switch (textureIndex) {
		case 0:
			this._gl.activeTexture(33984);
			break;
		case 1:
			this._gl.activeTexture(33985);
			break;
		case 2:
			this._gl.activeTexture(33986);
			break;
		case 3:
			this._gl.activeTexture(33987);
			break;
		case 4:
			this._gl.activeTexture(33988);
			break;
		case 5:
			this._gl.activeTexture(33989);
			break;
		case 6:
			this._gl.activeTexture(33990);
			break;
		case 7:
			this._gl.activeTexture(33991);
			break;
		default:
			throw "Texture " + textureIndex + " is out of bounds.";
	}
	this._gl.bindTexture(3553, texture.get_glTexture());
	this._gl.uniform1i(location, textureIndex);
	var samplerState = this._samplerStates[textureIndex];
	if (samplerState.wrap != this._currentWrap) {
		this._currentWrap = samplerState.wrap;
		this._gl.texParameteri(3553, 10242, samplerState.wrap);
		this._gl.texParameteri(3553, 10243, samplerState.wrap);
	}
	if (samplerState.filter != this._currentFilter) {
		this._gl.texParameteri(3553, 10241, samplerState.filter);
		this._gl.texParameteri(3553, 10240, samplerState.filter);
	}
};

away.display3D.Context3D.prototype.setSamplerStateAt = function(sampler, wrap, filter, mipfilter) {
	var glWrap = 0;
	var glFilter = 0;
	var glMipFilter = 0;
	switch (wrap) {
		case away.display3D.Context3DWrapMode.REPEAT:
			glWrap = 10497;
			break;
		case away.display3D.Context3DWrapMode.CLAMP:
			glWrap = 33071;
			break;
		default:
			throw "Wrap is not supported: " + wrap;
	}
	switch (filter) {
		case away.display3D.Context3DTextureFilter.LINEAR:
			glFilter = 9729;
			break;
		case away.display3D.Context3DTextureFilter.NEAREST:
			glFilter = 9728;
			break;
		default:
			throw "Filter is not supported " + filter;
	}
	switch (mipfilter) {
		case away.display3D.Context3DMipFilter.MIPNEAREST:
			glMipFilter = 9984;
			break;
		case away.display3D.Context3DMipFilter.MIPLINEAR:
			glMipFilter = 9987;
			break;
		case away.display3D.Context3DMipFilter.MIPNONE:
			glMipFilter = 0;
			break;
		default:
			throw "MipFilter is not supported " + mipfilter;
	}
	if (0 <= sampler && sampler < away.display3D.Context3D.MAX_SAMPLERS) {
		this._samplerStates[sampler].wrap = glWrap;
		this._samplerStates[sampler].filter = glFilter;
		this._samplerStates[sampler].mipfilter = glMipFilter;
	} else {
		throw "Sampler is out of bounds.";
	}
};

away.display3D.Context3D.prototype.setVertexBufferAt = function(index, buffer, bufferOffset, format) {
	var locationName = "va" + index;
	this.setGLSLVertexBufferAt(locationName, buffer, bufferOffset, format);
};

away.display3D.Context3D.prototype.setGLSLVertexBufferAt = function(locationName, buffer, bufferOffset, format) {
	var location = this._gl.getAttribLocation(this._currentProgram.get_glProgram(), locationName);
	if (!buffer) {
		if (location > -1) {
			this._gl.disableVertexAttribArray(location);
		}
		return;
	}
	this._gl.bindBuffer(34962, buffer.get_glBuffer());
	var dimension;
	var type = 5126;
	var numBytes = 4;
	switch (format) {
		case away.display3D.Context3DVertexBufferFormat.BYTES_4:
			dimension = 4;
			break;
		case away.display3D.Context3DVertexBufferFormat.FLOAT_1:
			dimension = 1;
			break;
		case away.display3D.Context3DVertexBufferFormat.FLOAT_2:
			dimension = 2;
			break;
		case away.display3D.Context3DVertexBufferFormat.FLOAT_3:
			dimension = 3;
			break;
		case away.display3D.Context3DVertexBufferFormat.FLOAT_4:
			dimension = 4;
			break;
		default:
			throw "Buffer format " + format + " is not supported.";
	}
	this._gl.enableVertexAttribArray(location);
	this._gl.vertexAttribPointer(location, dimension, type, false, buffer.get_data32PerVertex() * numBytes, bufferOffset * numBytes);
};

away.display3D.Context3D.prototype.updateBlendStatus = function() {
	if (this._blendEnabled) {
		this._gl.enable(3042);
		this._gl.blendEquation(32774);
		this._gl.blendFunc(this._blendSourceFactor, this._blendDestinationFactor);
	} else {
		this._gl.disable(3042);
	}
};

away.display3D.Context3D.className = "away.display3D.Context3D";

away.display3D.Context3D.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.display3D.TextureBase');
	p.push('away.display3D.Program3D');
	p.push('away.display3D.SamplerState');
	p.push('away.display3D.IndexBuffer3D');
	p.push('away.display3D.Context3DTriangleFace');
	p.push('away.display3D.Context3DWrapMode');
	p.push('away.display3D.Context3DProgramType');
	p.push('away.display3D.Texture');
	p.push('away.errors.PartialImplementationError');
	p.push('away.display3D.Context3DTextureFilter');
	p.push('away.display3D.Context3DCompareMode');
	p.push('away.display3D.CubeTexture');
	p.push('away.display3D.Context3DVertexBufferFormat');
	p.push('away.display3D.Context3DMipFilter');
	p.push('away.display3D.Context3DBlendFactor');
	p.push('away.geom.Matrix3D');
	p.push('Float32Array');
	p.push('away.geom.Rectangle');
	p.push('away.display3D.VertexBuffer3D');
	return p;
};

away.display3D.Context3D.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.display3D.Context3D.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'canvas', t:'HTMLCanvasElement'});
			break;
		default:
			p = [];
			break;
	}
	return p;
};

