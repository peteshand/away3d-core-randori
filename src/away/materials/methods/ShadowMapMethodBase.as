/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

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
		public var _pCastingLight:LightBase;
		public var _pShadowMapper:ShadowMapperBase;
		
		public var _pEpsilon:Number = 02;
		public var _pAlpha:Number = 1;

		/**		 * Creates a new ShadowMapMethodBase object.		 * @param castingLight The light used to cast shadows.		 */
		public function ShadowMapMethodBase(castingLight:LightBase):void
		{
			super();
			this._pCastingLight = castingLight;
			castingLight.castsShadows = true;
            this._pShadowMapper = castingLight.shadowMapper;

		}

		/**		 * @inheritDoc		 */
		override public function get assetType():String
		{
			return AssetType.SHADOW_MAP_METHOD;
		}

		/**		 * The "transparency" of the shadows. This allows making shadows less strong.		 */
		public function get alpha():Number
		{
			return this._pAlpha;
		}
		
		public function set alpha(value:Number):void
		{
            this._pAlpha = value;
		}

		/**		 * The light casting the shadows.		 */
		public function get castingLight():LightBase
		{
			return this._pCastingLight;
		}

		/**		 * A small value to counter floating point precision errors when comparing values in the shadow map with the		 * calculated depth value. Increase this if shadow banding occurs, decrease it if the shadow seems to be too detached.		 */
		public function get epsilon():Number
		{
			return this._pEpsilon;
		}
		
		public function set epsilon(value:Number):void
		{
            this._pEpsilon = value;
		}

		/**		 * @inheritDoc		 */
		public function iGetFragmentCode(vo:MethodVO, regCache:ShaderRegisterCache, targetReg:ShaderRegisterElement):String
		{
			throw new AbstractMethodError();
			return null;
		}
	}
}
