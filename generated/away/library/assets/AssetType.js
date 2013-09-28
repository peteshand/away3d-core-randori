/** Compiled by the Randori compiler v0.2.6.2 on Sat Sep 28 11:54:08 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.library == "undefined")
	away.library = {};
if (typeof away.library.assets == "undefined")
	away.library.assets = {};

away.library.assets.AssetType = function() {
	
};

away.library.assets.AssetType.ENTITY = "entity";

away.library.assets.AssetType.SKYBOX = "skybox";

away.library.assets.AssetType.CAMERA = "camera";

away.library.assets.AssetType.SEGMENT_SET = "segmentSet";

away.library.assets.AssetType.MESH = "mesh";

away.library.assets.AssetType.GEOMETRY = "geometry";

away.library.assets.AssetType.SKELETON = "skeleton";

away.library.assets.AssetType.SKELETON_POSE = "skeletonPose";

away.library.assets.AssetType.CONTAINER = "container";

away.library.assets.AssetType.TEXTURE = "texture";

away.library.assets.AssetType.TEXTURE_PROJECTOR = "textureProjector";

away.library.assets.AssetType.MATERIAL = "material";

away.library.assets.AssetType.ANIMATION_SET = "animationSet";

away.library.assets.AssetType.ANIMATION_STATE = "animationState";

away.library.assets.AssetType.ANIMATION_NODE = "animationNode";

away.library.assets.AssetType.ANIMATOR = "animator";

away.library.assets.AssetType.STATE_TRANSITION = "stateTransition";

away.library.assets.AssetType.LIGHT = "light";

away.library.assets.AssetType.LIGHT_PICKER = "lightPicker";

away.library.assets.AssetType.SHADOW_MAP_METHOD = "shadowMapMethod";

away.library.assets.AssetType.EFFECTS_METHOD = "effectsMethod";

away.library.assets.AssetType.className = "away.library.assets.AssetType";

away.library.assets.AssetType.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.library.assets.AssetType.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.library.assets.AssetType.injectionPoints = function(t) {
	return [];
};
