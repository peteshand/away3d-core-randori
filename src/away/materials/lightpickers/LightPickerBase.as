/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package away.materials.lightpickers
{
	import away.library.assets.NamedAssetBase;
	import away.library.assets.IAsset;
	import away.lights.LightBase;
	import away.lights.PointLight;
	import away.lights.DirectionalLight;
	import away.lights.LightProbe;
	import away.library.assets.AssetType;
	import away.core.base.IRenderable;
	import away.core.traverse.EntityCollector;
	import away.core.geom.Vector3D;

	/**	 * LightPickerBase provides an abstract base clase for light picker classes. These classes are responsible for	 * feeding materials with relevant lights. Usually, StaticLightPicker can be used, but LightPickerBase can be	 * extended to provide more application-specific dynamic selection of lights.	 *	 * @see StaticLightPicker	 */
	public class LightPickerBase extends NamedAssetBase implements IAsset
	{
        public var _pNumPointLights:Number = 0;
        public var _pNumDirectionalLights:Number = 0;
        public var _pNumCastingPointLights:Number = 0;
        public var _pNumCastingDirectionalLights:Number = 0;
		public var _pNumLightProbes:Number = 0;

		public var _pAllPickedLights:Vector.<LightBase>;//Vector.<LightBase>
        public var _pPointLights:Vector.<PointLight>;//Vector.<PointLight>
        public var _pCastingPointLights:Vector.<PointLight>;//Vector.<PointLight>
        public var _pDirectionalLights:Vector.<DirectionalLight>;//Vector.<DirectionalLight>
        public var _pCastingDirectionalLights:Vector.<DirectionalLight>;//Vector.<DirectionalLight>
        public var _pLightProbes:Vector.<LightProbe>;//Vector.<LightProbe>
        public var _pLightProbeWeights:Vector.<Number>;

		/**		 * Creates a new LightPickerBase object.		 */
		public function LightPickerBase():void
		{

            super(null);

		}

		/**		 * Disposes resources used by the light picker.		 */
		override public function dispose():void
		{
		}

		/**		 * @inheritDoc		 */
		override public function get assetType():String
		{
			return AssetType.LIGHT_PICKER;
		}
		
		/**		 * The maximum amount of directional lights that will be provided.		 */
		public function get numDirectionalLights():Number
		{
			return this._pNumDirectionalLights;
		}
		
		/**		 * The maximum amount of point lights that will be provided.		 */
		public function get numPointLights():Number
		{
			return this._pNumPointLights;
		}
		
		/**		 * The maximum amount of directional lights that cast shadows.		 */
		public function get numCastingDirectionalLights():Number
		{
			return this._pNumCastingDirectionalLights;
		}
		
		/**		 * The amount of point lights that cast shadows.		 */
		public function get numCastingPointLights():Number
		{
			return this._pNumCastingPointLights;
		}
		
		/**		 * The maximum amount of light probes that will be provided.		 */
		public function get numLightProbes():Number
		{
			return this._pNumLightProbes;
		}

		/**		 * The collected point lights to be used for shading.		 */
		public function get pointLights():Vector.<PointLight>//Vector.<PointLight>		{
			return this._pPointLights;
		}

		/**		 * The collected directional lights to be used for shading.		 */
		public function get directionalLights():Vector.<DirectionalLight>//Vector.<DirectionalLight>		{
			return this._pDirectionalLights;
		}

		/**		 * The collected point lights that cast shadows to be used for shading.		 */
		public function get castingPointLights():Vector.<PointLight>//Vector.<PointLight>		{
			return this._pCastingPointLights;
		}

		/**		 * The collected directional lights that cast shadows to be used for shading.		 */
		public function get castingDirectionalLights():Vector.<DirectionalLight>//:Vector.<DirectionalLight>		{
			return this._pCastingDirectionalLights;
		}

		/**		 * The collected light probes to be used for shading.		 */
		public function get lightProbes():Vector.<LightProbe>//:Vector.<LightProbe>		{
			return this._pLightProbes;
		}

		/**		 * The weights for each light probe, defining their influence on the object.		 */
		public function get lightProbeWeights():Vector.<Number>
		{
			return this._pLightProbeWeights;
		}

		/**		 * A collection of all the collected lights.		 */
		public function get allPickedLights():Vector.<LightBase>//Vector.<LightBase>		{
			return this._pAllPickedLights;
		}
		
		/**		 * Updates set of lights for a given renderable and EntityCollector. Always call super.collectLights() after custom overridden code.		 */
		public function collectLights(renderable:IRenderable, entityCollector:EntityCollector):void
		{
            this.updateProbeWeights(renderable);
		}

		/**		 * Updates the weights for the light probes, based on the renderable's position relative to them.		 * @param renderable The renderble for which to calculate the light probes' influence.		 */
		private function updateProbeWeights(renderable:IRenderable):void
		{
			// todo: this will cause the same calculations to occur per SubMesh. See if this can be improved.
			var objectPos:Vector3D = renderable.sourceEntity.scenePosition;
			var lightPos:Vector3D;

			var rx:Number = objectPos.x, ry:Number = objectPos.y, rz:Number = objectPos.z;
			var dx:Number, dy:Number, dz:Number;
			var w:Number, total:Number = 0;
			var i:Number;
			
			// calculates weights for probes
			for (i = 0; i < this._pNumLightProbes; ++i)
            {

				lightPos = this._pLightProbes[i].scenePosition;
				dx = rx - lightPos.x;
				dy = ry - lightPos.y;
				dz = rz - lightPos.z;
				// weight is inversely proportional to square of distance
				w = dx*dx + dy*dy + dz*dz;
				
				// just... huge if at the same spot
				w = w > .00001? 1/w : 50000000;
				this._pLightProbeWeights[i] = w;
				total += w;
			}
			
			// normalize
			total = 1/total;

			for (i = 0; i < this._pNumLightProbes; ++i)
            {

                this._pLightProbeWeights[i] *= total;

            }

		}
	
	}
}
