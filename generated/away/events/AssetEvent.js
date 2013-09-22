/** Compiled by the Randori compiler v0.2.6.2 on Sun Sep 22 11:20:03 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.events == "undefined")
	away.events = {};

away.events.AssetEvent = function(type, asset, prevName) {
	this._prevName = null;
	this._asset = null;
	asset = asset || null;
	prevName = prevName || null;
	away.events.Event.call(this, type);
	this._asset = asset;
	this._prevName = prevName || this._asset ? this._asset.get_name() : null;
};

away.events.AssetEvent.ASSET_COMPLETE = "assetComplete";

away.events.AssetEvent.ENTITY_COMPLETE = "entityComplete";

away.events.AssetEvent.SKYBOX_COMPLETE = "skyboxComplete";

away.events.AssetEvent.CAMERA_COMPLETE = "cameraComplete";

away.events.AssetEvent.MESH_COMPLETE = "meshComplete";

away.events.AssetEvent.GEOMETRY_COMPLETE = "geometryComplete";

away.events.AssetEvent.SKELETON_COMPLETE = "skeletonComplete";

away.events.AssetEvent.SKELETON_POSE_COMPLETE = "skeletonPoseComplete";

away.events.AssetEvent.CONTAINER_COMPLETE = "containerComplete";

away.events.AssetEvent.TEXTURE_COMPLETE = "textureComplete";

away.events.AssetEvent.TEXTURE_PROJECTOR_COMPLETE = "textureProjectorComplete";

away.events.AssetEvent.MATERIAL_COMPLETE = "materialComplete";

away.events.AssetEvent.ANIMATOR_COMPLETE = "animatorComplete";

away.events.AssetEvent.ANIMATION_SET_COMPLETE = "animationSetComplete";

away.events.AssetEvent.ANIMATION_STATE_COMPLETE = "animationStateComplete";

away.events.AssetEvent.ANIMATION_NODE_COMPLETE = "animationNodeComplete";

away.events.AssetEvent.STATE_TRANSITION_COMPLETE = "stateTransitionComplete";

away.events.AssetEvent.SEGMENT_SET_COMPLETE = "segmentSetComplete";

away.events.AssetEvent.LIGHT_COMPLETE = "lightComplete";

away.events.AssetEvent.LIGHTPICKER_COMPLETE = "lightPickerComplete";

away.events.AssetEvent.EFFECTMETHOD_COMPLETE = "effectMethodComplete";

away.events.AssetEvent.SHADOWMAPMETHOD_COMPLETE = "shadowMapMethodComplete";

away.events.AssetEvent.ASSET_RENAME = "assetRename";

away.events.AssetEvent.ASSET_CONFLICT_RESOLVED = "assetConflictResolved";

away.events.AssetEvent.TEXTURE_SIZE_ERROR = "textureSizeError";

away.events.AssetEvent.prototype.get_asset = function() {
	return this._asset;
};

away.events.AssetEvent.prototype.get_assetPrevName = function() {
	return this._prevName;
};

away.events.AssetEvent.prototype.clone = function() {
	return new away.events.AssetEvent(this.type, this.get_asset(), this.get_assetPrevName());
};

$inherit(away.events.AssetEvent, away.events.Event);

away.events.AssetEvent.className = "away.events.AssetEvent";

away.events.AssetEvent.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.events.AssetEvent.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.events.AssetEvent.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'type', t:'String'});
			p.push({n:'asset', t:'away.library.assets.IAsset'});
			p.push({n:'prevName', t:'String'});
			break;
		case 1:
			p = away.events.Event.injectionPoints(t);
			break;
		case 2:
			p = away.events.Event.injectionPoints(t);
			break;
		case 3:
			p = away.events.Event.injectionPoints(t);
			break;
		default:
			p = [];
			break;
	}
	return p;
};

