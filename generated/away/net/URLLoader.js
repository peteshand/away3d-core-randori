/** Compiled by the Randori compiler v0.2.6.2 on Sat Sep 21 16:02:39 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.net == "undefined")
	away.net = {};

away.net.URLLoader = function() {
	this._bytesLoaded = 0;
	this._loadError = false;
	this._data = null;
	this._dataFormat = away.net.URLLoaderDataFormat.TEXT;
	this._XHR = null;
	this._request = null;
	this._bytesTotal = 0;
	away.events.EventDispatcher.call(this);
};

away.net.URLLoader.prototype.load = function(request) {
	this.initXHR();
	this._request = request;
	if (request.method === away.net.URLRequestMethod.POST) {
		this.postRequest(request);
	} else {
		this.getRequest(request);
	}
};

away.net.URLLoader.prototype.close = function() {
	this._XHR.abort();
	this.disposeXHR();
};

away.net.URLLoader.prototype.dispose = function() {
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

away.net.URLLoader.prototype.set_dataFormat = function(format) {
	if (format === away.net.URLLoaderDataFormat.BLOB || format === away.net.URLLoaderDataFormat.ARRAY_BUFFER || format === away.net.URLLoaderDataFormat.BINARY || format === away.net.URLLoaderDataFormat.TEXT || format === away.net.URLLoaderDataFormat.VARIABLES) {
		this._dataFormat = format;
	} else {
		throw new away.errors.Error("URLLoader error: incompatible dataFormat", 0, "");
	}
};

away.net.URLLoader.prototype.get_dataFormat = function() {
	return this._dataFormat;
};

away.net.URLLoader.prototype.get_data = function() {
	return this._data;
};

away.net.URLLoader.prototype.get_bytesLoaded = function() {
	return this._bytesLoaded;
};

away.net.URLLoader.prototype.get_bytesTotal = function() {
	return this._bytesTotal;
};

away.net.URLLoader.prototype.get_request = function() {
	return this._request;
};

away.net.URLLoader.prototype.setResponseType = function(xhr, responseType) {
	switch (responseType) {
		case away.net.URLLoaderDataFormat.ARRAY_BUFFER:
		
		case away.net.URLLoaderDataFormat.BLOB:
		
		case away.net.URLLoaderDataFormat.TEXT:
			xhr.responseType = responseType;
			break;
		case away.net.URLLoaderDataFormat.VARIABLES:
			xhr.responseType = away.net.URLLoaderDataFormat.TEXT;
			break;
		case away.net.URLLoaderDataFormat.BINARY:
			xhr.responseType = "";
			break;
	}
};

away.net.URLLoader.prototype.getRequest = function(request) {
	try {
		this._XHR.open(request.method, request.get_url(), request.async);
		this.setResponseType(this._XHR, this._dataFormat);
		this._XHR.send();
	} catch (e) {
		this.handleXmlHttpRequestException(e);
	}
};

away.net.URLLoader.prototype.postRequest = function(request) {
	this._loadError = false;
	this._XHR.open(request.method, request.get_url(), request.async);
	if (request.data != null) {
		if (request.data instanceof away.net.URLVariables) {
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

away.net.URLLoader.prototype.handleXmlHttpRequestException = function(error) {
	switch (error.code) {
		}
	};
	
	away.net.URLLoader.prototype.initXHR = function() {
		if (!this._XHR) {
			this._XHR = new XMLHttpRequest();
			this._XHR.onloadstart = this.onLoadStart;
			this._XHR.onprogress = this.onProgress;
			this._XHR.onabort = this.onAbort;
			this._XHR.onerror = $createStaticDelegate(this, this.onLoadError);
			this._XHR.onload = $createStaticDelegate(this, this.onLoadComplete);
			this._XHR.ontimeout = this.onTimeOut;
			this._XHR.onloadend = this.onLoadEnd;
			this._XHR.onreadystatechange = this.onReadyStateChange;
		}
	};
	
	away.net.URLLoader.prototype.disposeXHR = function() {
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
	
	away.net.URLLoader.prototype.decodeURLVariables = function(source) {
		var result = {};
		source = source.split("+", 4.294967295E9).join(" ");
		var tokens, re = /[?&]?([^=]+)=([^&]*)/g;
		while (tokens = re.exec(source)) {
			result[decodeURIComponent(tokens[1])] = decodeURIComponent(tokens[2]);
		}
		return result;
	};
	
	away.net.URLLoader.prototype.onReadyStateChange = function(event) {
		if (this._XHR.readyState == 4) {
			if (this._XHR.status == 404) {
				this._loadError = true;
				this.dispatchEvent(new away.events.IOErrorEvent(away.events.IOErrorEvent.IO_ERROR));
			}
			this.dispatchEvent(new away.events.HTTPStatusEvent(away.events.HTTPStatusEvent.HTTP_STATUS, this._XHR.status));
		}
	};
	
	away.net.URLLoader.prototype.onLoadEnd = function(event) {
		if (this._loadError === true)
			return;
	};
	
	away.net.URLLoader.prototype.onTimeOut = function(event) {
	};
	
	away.net.URLLoader.prototype.onAbort = function(event) {
	};
	
	away.net.URLLoader.prototype.onProgress = function(event) {
		this._bytesTotal = event.total;
		this._bytesLoaded = event.loaded;
		var progressEvent = new away.events.ProgressEvent(away.events.ProgressEvent.PROGRESS);
		progressEvent.bytesLoaded = this._bytesLoaded;
		progressEvent.bytesTotal = this._bytesTotal;
		this.dispatchEvent(progressEvent);
	};
	
	away.net.URLLoader.prototype.onLoadStart = function(event) {
		this.dispatchEvent(new away.events.Event(away.events.Event.OPEN));
	};
	
	away.net.URLLoader.prototype.onLoadComplete = function(event) {
		if (this._loadError === true)
			return;
		switch (this._dataFormat) {
			case away.net.URLLoaderDataFormat.TEXT:
				this._data = this._XHR.responseText;
				break;
			case away.net.URLLoaderDataFormat.VARIABLES:
				this._data = this.decodeURLVariables(this._XHR.responseText);
				break;
			case away.net.URLLoaderDataFormat.BLOB:
			
			case away.net.URLLoaderDataFormat.ARRAY_BUFFER:
			
			case away.net.URLLoaderDataFormat.BINARY:
				this._data = this._XHR.response;
				break;
			default:
				this._data = this._XHR.responseText;
				break;
		}
		this.dispatchEvent(new away.events.Event(away.events.Event.COMPLETE));
	};
	
	away.net.URLLoader.prototype.onLoadError = function(event) {
		this._loadError = true;
		this.dispatchEvent(new away.events.IOErrorEvent(away.events.IOErrorEvent.IO_ERROR));
	};
	
	$inherit(away.net.URLLoader, away.events.EventDispatcher);
	
	away.net.URLLoader.className = "away.net.URLLoader";
	
	away.net.URLLoader.getRuntimeDependencies = function(t) {
		var p;
		p = [];
		p.push('away.net.URLRequest');
		p.push('away.net.URLRequestMethod');
		p.push('away.events.Event');
		p.push('away.events.ProgressEvent');
		p.push('away.events.HTTPStatusEvent');
		p.push('away.net.URLLoaderDataFormat');
		p.push('away.net.URLVariables');
		p.push('away.events.IOErrorEvent');
		return p;
	};
	
	away.net.URLLoader.getStaticDependencies = function(t) {
		var p;
		p = [];
		p.push('away.net.URLLoaderDataFormat');
		return p;
	};
	
	away.net.URLLoader.injectionPoints = function(t) {
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
	
	