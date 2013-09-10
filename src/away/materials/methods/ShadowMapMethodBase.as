///<reference path="../../_definitions.ts"/>

package away.materials.methods
{
	import away.library.assets.IAsset;
	import away.lights.LightBase;
	import away.lights.shadowmaps.ShadowMapperBase;
	import away.library.assets.AssetType;
	import away.materials.compilation.ShaderRegisterCache;
	import away.materials.compilation.ShaderRegisterElement;
	import away.errors.AbstractMethodError;
	//import away3d.*;
	//import away3d.errors.*;
	//import away3d.library.assets.*;
	//import away3d.lights.*;
	//import away3d.lights.shadowmaps.*;
	//import away3d.materials.compilation.*;
	
	//use namespace arcane;

	/**	 * ShadowMapMethodBase provides an abstract base method for shadow map methods.	 */
	public class ShadowMapMethodBase extends ShadingMethodBase implements IAsset
	{
		private var _castingLight:LightBase;
		private var _shadowMapper:ShadowMapperBase;
		
		private var _epsilon:Number = 02;
		private var _alpha:Number = 1;

		/**		 * Creates a new ShadowMapMethodBase object.		 * @param castingLight The light used to cast shadows.		 */
		public function ShadowMapMethodBase(castingLight:LightBase):void
		{
			super();
			_castingLight = castingLight;
			castingLight.castsShadows = true;
            _shadowMapper = castingLight.shadowMapper;

		}

		/**		 * @inheritDoc		 */
		override public function get assetType():String
		{
			return AssetType.SHADOW_MAP_METHOD;
		}

		/**		 * The "transparency" of the shadows. This allows making shadows less strong.		 */
		public function get alpha():Number
		{
			return _alpha;
		}
		
		public function set alpha(value:Number):void
		{
            _alpha = value;
		}

		/**		 * The light casting the shadows.		 */
		public function get castingLight():LightBase
		{
			return _castingLight;
		}

		/**		 * A small value to counter floating point precision errors when comparing values in the shadow map with the		 * calculated depth value. Increase this if shadow banding occurs, decrease it if the shadow seems to be too detached.		 */
		public function get epsilon():Number
		{
			return _epsilon;
		}
		
		public function set epsilon(value:Number):void
		{
            _epsilon = value;
		}

		/**		 * @inheritDoc		 */
		public function iGetFragmentCode(vo:MethodVO, regCache:ShaderRegisterCache, targetReg:ShaderRegisterElement):String
		{
			throw new AbstractMethodError();
			return null;
		}
	}
}
