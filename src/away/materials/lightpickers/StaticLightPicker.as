///<reference path="../../_definitions.ts"/>
package away.materials.lightpickers
{
	import away.lights.LightBase;
	import away.lights.PointLight;
	import away.lights.DirectionalLight;
	import away.lights.LightProbe;
	import away.events.LightEvent;
	import away.events.Event;
	//import flash.events.Event;
	
	//import away3d.events.LightEvent;
	//import away3d.lights.DirectionalLight;
	//import away3d.lights.LightBase;
	//import away3d.lights.LightProbe;
	//import away3d.lights.PointLight;

	/**
	 * StaticLightPicker is a light picker that provides a static set of lights. The lights can be reassigned, but
	 * if the configuration changes (number of directional lights, point lights, etc), a material recompilation may
	 * occur.
	 */
	public class StaticLightPicker extends LightPickerBase
	{
		private var _lights:Vector.<LightBase>; // not typed in AS3 - should it be lightbase ?

		/**
		 * Creates a new StaticLightPicker object.
		 * @param lights The lights to be used for shading.
		 */
		public function StaticLightPicker(lights):void
		{
            super();
			lights = lights;
		}

		/**
		 * The lights used for shading.
		 */
		public function get lights():Vector.<LightBase>
		{
			return _lights;
		}

		public function set lights(value:Vector.<LightBase>):void
		{
			var numPointLights:Number = 0;
			var numDirectionalLights:Number = 0;
			var numCastingPointLights:Number = 0;
			var numCastingDirectionalLights:Number = 0;
			var numLightProbes:Number = 0;
			var light:LightBase;
			
			if (_lights)
				clearListeners();
			
			_lights = value;
			_pAllPickedLights = value;
            _pPointLights = new Vector.<PointLight>();
            _pCastingPointLights = new Vector.<PointLight>();
            _pDirectionalLights = new Vector.<DirectionalLight>();
            _pCastingDirectionalLights = new Vector.<DirectionalLight>();
            _pLightProbes = new Vector.<LightProbe>();
			
			var len:Number = value.length;

			for (var i:Number = 0; i < len; ++i)
            {
				light = value[i];
				light.addEventListener(LightEvent.CASTS_SHADOW_CHANGE, onCastShadowChange , this );

				if (light instanceof PointLight)
                {
					if (light.castsShadows)
						_pCastingPointLights[numCastingPointLights++] = (light as PointLight);
					else
						_pPointLights[numPointLights++] = (light as PointLight);
					
				}
                else if (light instanceof DirectionalLight)
                {
					if (light.castsShadows)
						_pCastingDirectionalLights[numCastingDirectionalLights++] = (light as DirectionalLight);
					else
						_pDirectionalLights[numDirectionalLights++] = (light as DirectionalLight);

				}
                else if (light instanceof LightProbe)
                {
					_pLightProbes[numLightProbes++] = (light as LightProbe);

                }
			}
			
			if (_pNumDirectionalLights == numDirectionalLights && _pNumPointLights == numPointLights && _pNumLightProbes == numLightProbes &&
				_pNumCastingPointLights == numCastingPointLights && _pNumCastingDirectionalLights == numCastingDirectionalLights) {
				return;
			}
			
			_pNumDirectionalLights = numDirectionalLights;
			_pNumCastingDirectionalLights = numCastingDirectionalLights;
			_pNumPointLights = numPointLights;
			_pNumCastingPointLights = numCastingPointLights;
			_pNumLightProbes = numLightProbes;
			
			// MUST HAVE MULTIPLE OF 4 ELEMENTS!
			_pLightProbeWeights = new Vector.<Number>(Math.ceil(numLightProbes/4)*4 );
			
			// notify material lights have changed
			dispatchEvent(new Event(Event.CHANGE));

		}

		/**
		 * Remove configuration change listeners on the lights.
		 */
		private function clearListeners():void
		{
			var len:Number = _lights.length;
			for (var i:Number = 0; i < len; ++i)
				_lights[i].removeEventListener(LightEvent.CASTS_SHADOW_CHANGE, onCastShadowChange , this );
		}

		/**
		 * Notifies the material of a configuration change.
		 */
		private function onCastShadowChange(event:LightEvent):void
		{
			// TODO: Assign to special caster collections, just append it to the lights in SinglePass
			// But keep seperated in multipass
			
			var light:LightBase = (event.target as LightBase);
			
			if (light instanceof PointLight)
            {

                var pl : PointLight = (light as PointLight);
                updatePointCasting( pl );

            }
			else if (light instanceof DirectionalLight)
            {

                var dl : DirectionalLight = (light as DirectionalLight);
				updateDirectionalCasting( dl );

            }

			dispatchEvent(new Event(Event.CHANGE));
		}

		/**
		 * Called when a directional light's shadow casting configuration changes.
		 */
		private function updateDirectionalCasting(light:DirectionalLight):void
		{

            var dl : DirectionalLight = (light as DirectionalLight);

			if (light.castsShadows)
            {
				-- _pNumDirectionalLights;
				++_pNumCastingDirectionalLights;



				_pDirectionalLights.splice(_pDirectionalLights.indexOf( dl ), 1);
				_pCastingDirectionalLights.push(light);

			}
            else
            {
				++_pNumDirectionalLights;
				--_pNumCastingDirectionalLights;

				_pCastingDirectionalLights.splice(_pCastingDirectionalLights.indexOf( dl ), 1);
				_pDirectionalLights.push(light);
			}
		}

		/**
		 * Called when a point light's shadow casting configuration changes.
		 */
		private function updatePointCasting(light:PointLight):void
		{

            var pl : PointLight = (light as PointLight);

			if (light.castsShadows)
            {

				--_pNumPointLights;
				++_pNumCastingPointLights;
                _pPointLights.splice( _pPointLights.indexOf( pl ), 1);
                _pCastingPointLights.push(light);

			}
            else
            {

				++_pNumPointLights;
				--_pNumCastingPointLights;

                _pCastingPointLights.splice(_pCastingPointLights.indexOf( pl ) , 1);
                _pPointLights.push(light);

			}
		}
	}
}
