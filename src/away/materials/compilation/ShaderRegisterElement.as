///<reference path="../../_definitions.ts"/>
package away.materials.compilation
{
	
	/**
	 * A single register element (an entire register or a single register's component) used by the RegisterPool.
	 */
	public class ShaderRegisterElement
	{
		private var _regName:String;
		private var _index:Number;
		private var _toStr:String;
		
		private static var COMPONENTS = "x";
		
		public var _component:Number;
		
		/**
		 * Creates a new ShaderRegisterElement object.
		 * @param regName The name of the register.
		 * @param index The index of the register.
		 * @param component The register's component, if not the entire register is represented.
		 */
		public function ShaderRegisterElement(regName:String, index:Number, component:Number = -1):void
		{
			_component = component;
			_regName = regName;
            _index = index;

            _toStr = _regName;
			
			if (_index >= 0)
            {

                _toStr += _index;

            }

			if (component > -1)
            {

                _toStr += "." + ShaderRegisterElement.COMPONENTS[component];

            }

		}
		
		/**
		 * Converts the register or the components AGAL string representation.
		 */
		public function toString():String
		{
			return _toStr;
		}
		
		/**
		 * The register's name.
		 */
		public function get regName():String
		{
			return _regName;
		}
		
		/**
		 * The register's index.
		 */
		public function get index():Number
		{
			return _index;
		}
	}
}
