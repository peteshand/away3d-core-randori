
///<reference path="../_definitions.ts"/>

package away.events
{
	import away.library.assets.IAsset;
	//import away3d.library.assets.IAsset;

	//import flash.events.Event;
    /**     * @class away.events.AssetEvent     */
	public class AssetEvent extends Event
	{
		public static var ASSET_COMPLETE:String = "assetComplete";
		public static var ENTITY_COMPLETE:String = "entityComplete";
		public static var SKYBOX_COMPLETE:String = "skyboxComplete";
		public static var CAMERA_COMPLETE:String = "cameraComplete";
		public static var MESH_COMPLETE:String = "meshComplete";
		public static var GEOMETRY_COMPLETE:String = "geometryComplete";
		public static var SKELETON_COMPLETE:String = "skeletonComplete";
		public static var SKELETON_POSE_COMPLETE:String = "skeletonPoseComplete";
		public static var CONTAINER_COMPLETE:String = "containerComplete";
		public static var TEXTURE_COMPLETE:String = "textureComplete";
		public static var TEXTURE_PROJECTOR_COMPLETE:String = "textureProjectorComplete";
		public static var MATERIAL_COMPLETE:String = "materialComplete";
		public static var ANIMATOR_COMPLETE:String = "animatorComplete";
		public static var ANIMATION_SET_COMPLETE:String = "animationSetComplete";
		public static var ANIMATION_STATE_COMPLETE:String = "animationStateComplete";
		public static var ANIMATION_NODE_COMPLETE:String = "animationNodeComplete";
		public static var STATE_TRANSITION_COMPLETE:String = "stateTransitionComplete";
		public static var SEGMENT_SET_COMPLETE:String = "segmentSetComplete";
		public static var LIGHT_COMPLETE:String = "lightComplete";
		public static var LIGHTPICKER_COMPLETE:String = "lightPickerComplete";
		public static var EFFECTMETHOD_COMPLETE:String = "effectMethodComplete";
		public static var SHADOWMAPMETHOD_COMPLETE:String = "shadowMapMethodComplete";
		
		public static var ASSET_RENAME:String = 'assetRename';
		public static var ASSET_CONFLICT_RESOLVED:String = 'assetConflictResolved';
		
		public static var TEXTURE_SIZE_ERROR:String = 'textureSizeError';

		private var _asset:IAsset;
		private var _prevName:String;
		
		public function AssetEvent(type:String, asset:IAsset = null, prevName:String = null):void
		{
			super(type);
			
			this._asset = asset;
            this._prevName = prevName || (this._asset? this._asset.name : null);
		}
		
		
		public function get asset():IAsset
		{
			return this._asset;
		}
		
		
		public function get assetPrevName():String
		{
			return this._prevName;
		}
		
		
		override public function clone():Event
		{
			return (new AssetEvent(this.type , this.asset , this.assetPrevName ) as Event);
		}
	}
}