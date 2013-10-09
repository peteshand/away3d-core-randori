/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package away.materials.compilation
{
	
	/**	 * A single register element (an entire register or a single register's component) used by the RegisterPool.	 */
	public class ShaderRegisterElement
	{
		private var _regName:String = null;
		private var _index:Number = 0;
		private var _toStr:String = null;
		
		private static var COMPONENTS:Vector.<String> = new <String>['x','y','z','w'];
		
		public var _component:Number = 0;
		
		/**		 * Creates a new ShaderRegisterElement object.		 * @param regName The name of the register.		 * @param index The index of the register.		 * @param component The register's component, if not the entire register is represented.		 */
		public function ShaderRegisterElement(regName:String, index:Number, component:Number = -1):void
		{
			component = component || -1;

			this._component = component;
			this._regName = regName;
            this._index = index;

            this._toStr = this._regName;
			
			if (this._index >= 0)
            {

                this._toStr += this._index;

            }

			if (component > -1)
            {

                this._toStr += "." + ShaderRegisterElement.COMPONENTS[component];

            }

		}
		
		/**		 * Converts the register or the components AGAL string representation.		 */
		public function toString():String
		{
			return this._toStr;
		}
		
		/**		 * The register's name.		 */
		public function get regName():String
		{
			return this._regName;
		}
		
		/**		 * The register's index.		 */
		public function get index():Number
		{
			return this._index;
		}
	}
}
