/** Compiled by the Randori compiler v0.2.5.2 on Sat Oct 12 02:16:03 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.loaders == "undefined")
	away.loaders = {};
if (typeof away.loaders.parsers == "undefined")
	away.loaders.parsers = {};

away.loaders.parsers.ParserBase = function(format, loaderType) {
	this._frameLimit = 0;
	this._lastFrameTime = 0;
	this._materialMode = 0;
	this._iFileName = null;
	this._dependencies = null;
	this._data = null;
	this._parsingPaused = false;
	this._dataFormat = null;
	this._timer = null;
	this._loaderType = away.loaders.parsers.ParserLoaderType.URL_LOADER;
	this._parsingFailure = false;
	this._parsingComplete = false;
	loaderType = loaderType || null;
	away.events.EventDispatcher.call(this);
	if (loaderType) {
		this._loaderType = loaderType;
	}
	this._materialMode = 0;
	this._dataFormat = format;
	this._dependencies = [];
};

away.loaders.parsers.ParserBase.supportsType = function(extension) {
	throw new away.errors.AbstractMethodError(null, 0);
	return false;
};

away.loaders.parsers.ParserBase.PARSING_DONE = true;

away.loaders.parsers.ParserBase.MORE_TO_PARSE = false;

away.loaders.parsers.ParserBase.prototype.isBitmapDataValid = function(bitmapData) {
	var isValid = away.utils.TextureUtils.isBitmapDataValid(bitmapData);
	if (!isValid) {
		console.log(">> Bitmap loaded is not having power of 2 dimensions or is higher than 2048");
	}
	return isValid;
};

away.loaders.parsers.ParserBase.prototype.set_parsingFailure = function(b) {
	this._parsingFailure = b;
};

away.loaders.parsers.ParserBase.prototype.get_parsingFailure = function() {
	return this._parsingFailure;
};

away.loaders.parsers.ParserBase.prototype.get_parsingPaused = function() {
	return this._parsingPaused;
};

away.loaders.parsers.ParserBase.prototype.get_parsingComplete = function() {
	return this._parsingComplete;
};

away.loaders.parsers.ParserBase.prototype.set_materialMode = function(newMaterialMode) {
	this._materialMode = newMaterialMode;
};

away.loaders.parsers.ParserBase.prototype.get_materialMode = function() {
	return this._materialMode;
};

away.loaders.parsers.ParserBase.prototype.get_loaderType = function() {
	return this._loaderType;
};

away.loaders.parsers.ParserBase.prototype.set_loaderType = function(value) {
	this._loaderType = value;
};

away.loaders.parsers.ParserBase.prototype.get_data = function() {
	return this._data;
};

away.loaders.parsers.ParserBase.prototype.get_dataFormat = function() {
	return this._dataFormat;
};

away.loaders.parsers.ParserBase.prototype.parseAsync = function(data, frameLimit) {
	frameLimit = frameLimit || 30;
	this._data = data;
	this.startParsing(frameLimit);
};

away.loaders.parsers.ParserBase.prototype.get_dependencies = function() {
	return this._dependencies;
};

away.loaders.parsers.ParserBase.prototype._iResolveDependency = function(resourceDependency) {
	throw new away.errors.AbstractMethodError(null, 0);
};

away.loaders.parsers.ParserBase.prototype._iResolveDependencyFailure = function(resourceDependency) {
	throw new away.errors.AbstractMethodError(null, 0);
};

away.loaders.parsers.ParserBase.prototype._iResolveDependencyName = function(resourceDependency, asset) {
	return asset.get_name();
};

away.loaders.parsers.ParserBase.prototype._iResumeParsingAfterDependencies = function() {
	this._parsingPaused = false;
	if (this._timer) {
		this._timer.start();
	}
};

away.loaders.parsers.ParserBase.prototype._pFinalizeAsset = function(asset, name) {
	name = name || null;
	var type_event;
	var type_name;
	if (name != null) {
		asset.set_name(name);
	}
	switch (asset.get_assetType()) {
		case away.library.assets.AssetType.LIGHT_PICKER:
			type_name = "lightPicker";
			type_event = away.events.AssetEvent.LIGHTPICKER_COMPLETE;
			break;
		case away.library.assets.AssetType.LIGHT:
			type_name = "light";
			type_event = away.events.AssetEvent.LIGHT_COMPLETE;
			break;
		case away.library.assets.AssetType.ANIMATOR:
			type_name = "animator";
			type_event = away.events.AssetEvent.ANIMATOR_COMPLETE;
			break;
		case away.library.assets.AssetType.ANIMATION_SET:
			type_name = "animationSet";
			type_event = away.events.AssetEvent.ANIMATION_SET_COMPLETE;
			break;
		case away.library.assets.AssetType.ANIMATION_STATE:
			type_name = "animationState";
			type_event = away.events.AssetEvent.ANIMATION_STATE_COMPLETE;
			break;
		case away.library.assets.AssetType.ANIMATION_NODE:
			type_name = "animationNode";
			type_event = away.events.AssetEvent.ANIMATION_NODE_COMPLETE;
			break;
		case away.library.assets.AssetType.STATE_TRANSITION:
			type_name = "stateTransition";
			type_event = away.events.AssetEvent.STATE_TRANSITION_COMPLETE;
			break;
		case away.library.assets.AssetType.TEXTURE:
			type_name = "texture";
			type_event = away.events.AssetEvent.TEXTURE_COMPLETE;
			break;
		case away.library.assets.AssetType.TEXTURE_PROJECTOR:
			type_name = "textureProjector";
			type_event = away.events.AssetEvent.TEXTURE_PROJECTOR_COMPLETE;
			break;
		case away.library.assets.AssetType.CONTAINER:
			type_name = "container";
			type_event = away.events.AssetEvent.CONTAINER_COMPLETE;
			break;
		case away.library.assets.AssetType.GEOMETRY:
			type_name = "geometry";
			type_event = away.events.AssetEvent.GEOMETRY_COMPLETE;
			break;
		case away.library.assets.AssetType.MATERIAL:
			type_name = "material";
			type_event = away.events.AssetEvent.MATERIAL_COMPLETE;
			break;
		case away.library.assets.AssetType.MESH:
			type_name = "mesh";
			type_event = away.events.AssetEvent.MESH_COMPLETE;
			break;
		case away.library.assets.AssetType.SKELETON:
			type_name = "skeleton";
			type_event = away.events.AssetEvent.SKELETON_COMPLETE;
			break;
		case away.library.assets.AssetType.SKELETON_POSE:
			type_name = "skelpose";
			type_event = away.events.AssetEvent.SKELETON_POSE_COMPLETE;
			break;
		case away.library.assets.AssetType.ENTITY:
			type_name = "entity";
			type_event = away.events.AssetEvent.ENTITY_COMPLETE;
			break;
		case away.library.assets.AssetType.SKYBOX:
			type_name = "skybox";
			type_event = away.events.AssetEvent.SKYBOX_COMPLETE;
			break;
		case away.library.assets.AssetType.CAMERA:
			type_name = "camera";
			type_event = away.events.AssetEvent.CAMERA_COMPLETE;
			break;
		case away.library.assets.AssetType.SEGMENT_SET:
			type_name = "segmentSet";
			type_event = away.events.AssetEvent.SEGMENT_SET_COMPLETE;
			break;
		case away.library.assets.AssetType.EFFECTS_METHOD:
			type_name = "effectsMethod";
			type_event = away.events.AssetEvent.EFFECTMETHOD_COMPLETE;
			break;
		case away.library.assets.AssetType.SHADOW_MAP_METHOD:
			type_name = "effectsMethod";
			type_event = away.events.AssetEvent.SHADOWMAPMETHOD_COMPLETE;
			break;
		default:
			throw new away.errors.away.errors.Error("Unhandled asset type " + asset.get_assetType() + ". Report as bug!", 0, "");
			break;
	}
	if (!asset.get_name())
		asset.set_name(type_name);
	this.dispatchEvent(new away.events.AssetEvent(away.events.AssetEvent.ASSET_COMPLETE, asset));
	this.dispatchEvent(new away.events.AssetEvent(type_event, asset));
};

away.loaders.parsers.ParserBase.prototype._pProceedParsing = function() {
	throw new away.errors.AbstractMethodError(null, 0);
	return true;
};

away.loaders.parsers.ParserBase.prototype._pDieWithError = function(message) {
	message = message || "Unknown parsing error";
	if (this._timer) {
		this._timer.removeEventListener(away.events.TimerEvent.TIMER, $createStaticDelegate(this, this._pOnInterval), this);
		this._timer.stop();
		this._timer = null;
	}
	this.dispatchEvent(new away.events.ParserEvent(away.events.ParserEvent.PARSE_ERROR, message));
};

away.loaders.parsers.ParserBase.prototype._pAddDependency = function(id, req, retrieveAsRawData, data, suppressErrorEvents) {
	data = data || null;
	this._dependencies.push(new away.loaders.misc.ResourceDependency(id, req, data, this, retrieveAsRawData, suppressErrorEvents));
};

away.loaders.parsers.ParserBase.prototype._pPauseAndRetrieveDependencies = function() {
	if (this._timer) {
		this._timer.stop();
	}
	this._parsingPaused = true;
	this.dispatchEvent(new away.events.ParserEvent(away.events.ParserEvent.READY_FOR_DEPENDENCIES, ""));
};

away.loaders.parsers.ParserBase.prototype._pHasTime = function() {
	return ((new Date().getTime() - this._lastFrameTime) < this._frameLimit);
};

away.loaders.parsers.ParserBase.prototype._pOnInterval = function(event) {
	event = event || null;
	this._lastFrameTime = new Date().getTime();
	if (this._pProceedParsing() && !this._parsingFailure) {
		this._pFinishParsing();
	}
};

away.loaders.parsers.ParserBase.prototype.startParsing = function(frameLimit) {
	this._frameLimit = frameLimit;
	this._timer = new away.utils.Timer(this._frameLimit, 0);
	this._timer.addEventListener(away.events.TimerEvent.TIMER, $createStaticDelegate(this, this._pOnInterval), this);
	this._timer.start();
};

away.loaders.parsers.ParserBase.prototype._pFinishParsing = function() {
	if (this._timer) {
		this._timer.removeEventListener(away.events.TimerEvent.TIMER, $createStaticDelegate(this, this._pOnInterval), this);
		this._timer.stop();
	}
	this._timer = null;
	this._parsingComplete = true;
	this.dispatchEvent(new away.events.ParserEvent(away.events.ParserEvent.PARSE_COMPLETE, ""));
};

away.loaders.parsers.ParserBase.prototype._pGetTextData = function() {
	return away.loaders.parsers.utils.ParserUtil.toString(this._data, 0);
};

away.loaders.parsers.ParserBase.prototype._pGetByteData = function() {
	return away.loaders.parsers.utils.ParserUtil.toByteArray(this._data);
};

$inherit(away.loaders.parsers.ParserBase, away.events.EventDispatcher);

away.loaders.parsers.ParserBase.className = "away.loaders.parsers.ParserBase";

away.loaders.parsers.ParserBase.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.events.TimerEvent');
	p.push('away.loaders.misc.ResourceDependency');
	p.push('away.utils.Timer');
	p.push('away.errors.AbstractMethodError');
	p.push('away.events.ParserEvent');
	p.push('away.loaders.parsers.utils.ParserUtil');
	p.push('away.events.AssetEvent');
	p.push('away.library.assets.AssetType');
	p.push('away.utils.TextureUtils');
	return p;
};

away.loaders.parsers.ParserBase.getStaticDependencies = function(t) {
	var p;
	p = [];
	p.push('away.loaders.parsers.ParserLoaderType');
	return p;
};

away.loaders.parsers.ParserBase.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'format', t:'String'});
			p.push({n:'loaderType', t:'String'});
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

