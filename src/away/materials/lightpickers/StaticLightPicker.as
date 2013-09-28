/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package away.materials.lightpickers
{
	import away.lights.LightBase;
	import away.lights.PointLight;
	import away.lights.DirectionalLight;
	import away.lights.LightProbe;
	import away.events.LightEvent;
	import away.utils.VectorInit;
	import away.events.Event;
	//import flash.events.Event;
	
	//import away3d.events.LightEvent;
	//import away3d.lights.DirectionalLight;
	//import away3d.lights.LightBase;
	//import away3d.lights.LightProbe;
	//import away3d.lights.PointLight;

	/**	 * StaticLightPicker is a light picker that provides a static set of lights. The lights can be reassigned, but	 * if the configuration changes (number of directional lights, point lights, etc), a material recompilation may	 * occur.	 */
	public class StaticLightPicker extends LightPickerBase
	{
		private var _lights:Vector.<LightBase>;// not typed in AS3 - should it be lightbase ?

		/**		 * Creates a new StaticLightPicker object.		 * @param lights The lights to be used for shading.		 */
		public function StaticLightPicker(lights):void
		{
            super();
			this.lights = lights;
		}

		/**		 * The lights used for shading.		 */
		public function get lights():Vector.<LightBase>
		{
			return this._lights;
		}

		public function set lights(value:Vector.<LightBase>):void
		{
			var numPointLights:Number = 0;
			var numDirectionalLights:Number = 0;
			var numCastingPointLights:Number = 0;
			var numCastingDirectionalLights:Number = 0;
			var numLightProbes:Number = 0;
			var light:LightBase;
			
			if (this._lights)
				this.clearListeners();
			
			this._lights = value;
			this._pAllPickedLights = value;
            this._pPointLights = new Vector.<PointLight>();
            this._pCastingPointLights = new Vector.<PointLight>();
            this._pDirectionalLights = new Vector.<DirectionalLight>();
            this._pCastingDirectionalLights = new Vector.<DirectionalLight>();
            this._pLightProbes = new Vector.<LightProbe>();
			
			var len:Number = value.length;

			for (var i:Number = 0; i < len; ++i)
            {
				light = value[i];
				light.addEventListener(LightEvent.CASTS_SHADOW_CHANGE, onCastShadowChange , this );

				if (light instanceof PointLight)
                {
					if (light.castsShadows)
						this._pCastingPointLights[numCastingPointLights++] = (light as PointLight);
					else
						this._pPointLights[numPointLights++] = (light as PointLight);
					
				}
                else if (light instanceof DirectionalLight)
                {
					if (light.castsShadows)
						this._pCastingDirectionalLights[numCastingDirectionalLights++] = (light as DirectionalLight);
					else
						this._pDirectionalLights[numDirectionalLights++] = (light as DirectionalLight);

				}
                else if (light instanceof LightProbe)
                {
					this._pLightProbes[numLightProbes++] = (light as LightProbe);

                }
			}
			
			if (this._pNumDirectionalLights == numDirectionalLights && this._pNumPointLights == numPointLights && this._pNumLightProbes == numLightProbes &&
				this._pNumCastingPointLights == numCastingPointLights && this._pNumCastingDirectionalLights == numCastingDirectionalLights) {
				return;
			}
			
			this._pNumDirectionalLights = numDirectionalLights;
			this._pNumCastingDirectionalLights = numCastingDirectionalLights;
			this._pNumPointLights = numPointLights;
			this._pNumCastingPointLights = numCastingPointLights;
			this._pNumLightProbes = numLightProbes;
			
			// MUST HAVE MULTIPLE OF 4 ELEMENTS!
			this._pLightProbeWeights = VectorInit.Num(Math.ceil(numLightProbes/4)*4 );
			
			// notify material lights have changed
			this.dispatchEvent(new Event(Event.CHANGE));

		}

		/**		 * Remove configuration change listeners on the lights.		 */
		private function clearListeners():void
		{
			var len:Number = this._lights.length;
			for (var i:Number = 0; i < len; ++i)
				this._lights[i].removeEventListener(LightEvent.CASTS_SHADOW_CHANGE, onCastShadowChange , this );
		}

		/**		 * Notifies the material of a configuration change.		 */
		private function onCastShadowChange(event:LightEvent):void
		{
			// TODO: Assign to special caster collections, just append it to the lights in SinglePass
			// But keep seperated in multipass
			
			var light:LightBase = (event.target as LightBase);
			
			if (light instanceof PointLight)
            {

                var pl : PointLight = (light as PointLight);
                this.updatePointCasting( pl );

            }
			else if (light instanceof DirectionalLight)
            {

                var dl : DirectionalLight = (light as DirectionalLight);
				this.updateDirectionalCasting( dl );

            }

			this.dispatchEvent(new Event(Event.CHANGE));
		}

		/**		 * Called when a directional light's shadow casting configuration changes.		 */
		private function updateDirectionalCasting(light:DirectionalLight):void
		{

            var dl : DirectionalLight = (light as DirectionalLight);

			if (light.castsShadows)
            {
				-- this._pNumDirectionalLights;
				++this._pNumCastingDirectionalLights;



				this._pDirectionalLights.splice(this._pDirectionalLights.indexOf( dl ), 1);
				this._pCastingDirectionalLights.push(light);

			}
            else
            {
				++this._pNumDirectionalLights;
				--this._pNumCastingDirectionalLights;

				this._pCastingDirectionalLights.splice(this._pCastingDirectionalLights.indexOf( dl ), 1);
				this._pDirectionalLights.push(light);
			}
		}

		/**		 * Called when a point light's shadow casting configuration changes.		 */
		private function updatePointCasting(light:PointLight):void
		{

            var pl : PointLight = (light as PointLight);

			if (light.castsShadows)
            {

				--this._pNumPointLights;
				++this._pNumCastingPointLights;
                this._pPointLights.splice( this._pPointLights.indexOf( pl ), 1);
                this._pCastingPointLights.push(light);

			}
            else
            {

				++this._pNumPointLights;
				--this._pNumCastingPointLights;

                this._pCastingPointLights.splice(this._pCastingPointLights.indexOf( pl ) , 1);
                this._pPointLights.push(light);

			}
		}
	}
}
