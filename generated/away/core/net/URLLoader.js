/** Compiled by the Randori compiler v0.2.5.2 on Wed Oct 09 20:30:41 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.core == "undefined")
	away.core = {};
if (typeof away.core.net == "undefined")
	away.core.net = {};

away.core.net.URLLoader = function() {
	this._bytesLoaded = 0;
	this._loadError = false;
	this._data = null;
	this._dataFormat = away.core.net.URLLoaderDataFormat.TEXT;
	this._XHR = null;
	this._request = null;
	this._bytesTotal = 0;
	away.events.EventDispatcher.call(this);
};

away.core.net.URLLoader.prototype.load = function(request) {
	this.initXHR();
	this._request = request;
	if (request.method === away.core.net.URLRequestMethod.POST) {
		this.postRequest(request);
	} else {
		this.getRequest(request);
	}
};

away.core.net.URLLoader.prototype.close = function() {
	this._XHR.abort();
	this.disposeXHR();
};

away.core.net.URLLoader.prototype.dispose = function() {
	if (this._XHR) {
		this._XHR.abort();
	}
	this.disposeXHR();
	this._data = null;
	this._dataFormat = null;
	this._bytesLoaded = null;
	this._bytesTotal = null;
	this._request = null;
};

away.core.net.URLLoader.prototype.set_dataFormat = function(format) {
	if (format === away.core.net.URLLoaderDataFormat.BLOB || format === away.core.net.URLLoaderDataFormat.ARRAY_BUFFER || format === away.core.net.URLLoaderDataFormat.BINARY || format === away.core.net.URLLoaderDataFormat.TEXT || format === away.core.net.URLLoaderDataFormat.VARIABLES) {
		this._dataFormat = format;
	} else {
		throw new away.errors.away.errors.Error("URLLoader error: incompatible dataFormat", 0, "");
	}
};

away.core.net.URLLoader.prototype.get_dataFormat = function() {
	return this._dataFormat;
};

away.core.net.URLLoader.prototype.get_data = function() {
	return this._data;
};

away.core.net.URLLoader.prototype.get_bytesLoaded = function() {
	return this._bytesLoaded;
};

away.core.net.URLLoader.prototype.get_bytesTotal = function() {
	return this._bytesTotal;
};

away.core.net.URLLoader.prototype.get_request = function() {
	return this._request;
};

away.core.net.URLLoader.prototype.setResponseType = function(xhr, responseType) {
	switch (responseType) {
		case away.core.net.URLLoaderDataFormat.ARRAY_BUFFER:
		
		case away.core.net.URLLoaderDataFormat.BLOB:
		
		case away.core.net.URLLoaderDataFormat.TEXT:
			xhr.responseType = responseType;
			break;
		case away.core.net.URLLoaderDataFormat.VARIABLES:
			xhr.responseType = away.core.net.URLLoaderDataFormat.TEXT;
			break;
		case away.core.net.URLLoaderDataFormat.BINARY:
			xhr.responseType = "";
			break;
	}
};

away.core.net.URLLoader.prototype.getRequest = function(request) {
	try {
		this._XHR.open(request.method, request.get_url(), request.async);
		this.setResponseType(this._XHR, this._dataFormat);
		this._XHR.send();
	} catch (e) {
		this.handleXmlHttpRequestException(e);
	}
};

away.core.net.URLLoader.prototype.postRequest = function(request) {
	this._loadError = false;
	this._XHR.open(request.method, request.get_url(), request.async);
	if (request.data != null) {
		if (request.data instanceof away.core.net.URLVariables) {
			var urlVars = request.data;
			try {
				this._XHR.responseType = "text";
				this._XHR.send(urlVars.get_formData());
			} catch (e) {
				this.handleXmlHttpRequestException(e);
			}
		} else {
			this.setResponseType(this._XHR, this._dataFormat);
			if (request.data) {
				this._XHR.send(request.data);
			} else {
				this._XHR.send();
			}
		}
	} else {
		this._XHR.send();
	}
};

away.core.net.URLLoader.prototype.handleXmlHttpRequestException = function(error) {
};

away.core.net.URLLoader.prototype.initXHR = function() {
	if (!this._XHR) {
		this._XHR = new XMLHttpRequest();
		var that = this;
		this._XHR.onloadstart = function(event) {
			that.onLoadStart(event);
		};
		this._XHR.onprogress = function(event) {
			that.onProgress(event);
		};
		this._XHR.onabort = function(event) {
			that.onAbort(event);
		};
		this._XHR.onerror = function(event) {
			that.onLoadError(event);
		};
		this._XHR.onload = function(event) {
			that.onLoadComplete(event);
		};
		this._XHR.ontimeout = function(event) {
			that.onTimeOut(event);
		};
		this._XHR.onloadend = function(event) {
			that.onLoadEnd(event);
		};
		this._XHR.onreadystatechange = function(event) {
			that.onReadyStateChange(event);
		};
	}
};

away.core.net.URLLoader.prototype.disposeXHR = function() {
	if (this._XHR !== null) {
		this._XHR.onloadstart = null;
		this._XHR.onprogress = null;
		this._XHR.onabort = null;
		this._XHR.onerror = null;
		this._XHR.onload = null;
		this._XHR.ontimeout = null;
		this._XHR.onloadend = null;
		this._XHR = null;
	}
};

away.core.net.URLLoader.prototype.decodeURLVariables = function(source) {
	var result = {};
	source = source.split("+", 4.294967295E9).join(" ");
	var re = /[?&]?([^=]+)=([^&]*)/g;
	var tokens = re;
	while (tokens = re.exec(source)) {
		result[decodeURIComponent(tokens[1])] = decodeURIComponent(tokens[2]);
	}
	return result;
};

away.core.net.URLLoader.prototype.onReadyStateChange = function(event) {
	if (this._XHR.readyState == 4) {
		if (this._XHR.status == 404) {
			this._loadError = true;
			this.dispatchEvent(new away.events.IOErrorEvent(away.events.IOErrorEvent.IO_ERROR));
		}
		this.dispatchEvent(new away.events.HTTPStatusEvent(away.events.HTTPStatusEvent.HTTP_STATUS, this._XHR.status));
	}
};

away.core.net.URLLoader.prototype.onLoadEnd = function(event) {
	if (this._loadError === true)
		return;
};

away.core.net.URLLoader.prototype.onTimeOut = function(event) {
};

away.core.net.URLLoader.prototype.onAbort = function(event) {
};

away.core.net.URLLoader.prototype.onProgress = function(event) {
	this._bytesTotal = event.total;
	this._bytesLoaded = event.loaded;
	var progressEvent = new away.events.ProgressEvent(away.events.ProgressEvent.PROGRESS);
	progressEvent.bytesLoaded = this._bytesLoaded;
	progressEvent.bytesTotal = this._bytesTotal;
	this.dispatchEvent(progressEvent);
};

away.core.net.URLLoader.prototype.onLoadStart = function(event) {
	this.dispatchEvent(new away.events.Event(away.events.Event.OPEN));
};

away.core.net.URLLoader.prototype.onLoadComplete = function(event) {
	if (this._loadError === true)
		return;
	switch (this._dataFormat) {
		case away.core.net.URLLoaderDataFormat.TEXT:
			this._data = this._XHR.responseText;
			break;
		case away.core.net.URLLoaderDataFormat.VARIABLES:
			this._data = this.decodeURLVariables(this._XHR.responseText);
			break;
		case away.core.net.URLLoaderDataFormat.BLOB:
		
		case away.core.net.URLLoaderDataFormat.ARRAY_BUFFER:
		
		case away.core.net.URLLoaderDataFormat.BINARY:
			this._data = this._XHR.response;
			break;
		default:
			this._data = this._XHR.responseText;
			break;
	}
	this.dispatchEvent(new away.events.Event(away.events.Event.COMPLETE));
};

away.core.net.URLLoader.prototype.onLoadError = function(event) {
	this._loadError = true;
	this.dispatchEvent(new away.events.IOErrorEvent(away.events.IOErrorEvent.IO_ERROR));
};

$inherit(away.core.net.URLLoader, away.events.EventDispatcher);

away.core.net.URLLoader.className = "away.core.net.URLLoader";

away.core.net.URLLoader.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.events.Event');
	p.push('away.events.ProgressEvent');
	p.push('away.core.net.URLRequest');
	p.push('away.events.HTTPStatusEvent');
	p.push('away.core.net.URLRequestMethod');
	p.push('away.core.net.URLVariables');
	p.push('away.core.net.URLLoaderDataFormat');
	p.push('away.events.IOErrorEvent');
	return p;
};

away.core.net.URLLoader.getStaticDependencies = function(t) {
	var p;
	p = [];
	p.push('away.core.net.URLLoaderDataFormat');
	return p;
};

away.core.net.URLLoader.injectionPoints = function(t) {
	var p;
	switch (t) {
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

