///<reference path="../../_definitions.ts"/>

package away.materials.compilation
{
	
	/**
	public class ShaderRegisterElement
	{
		private var _regName:String;
		private var _index:Number;
		private var _toStr:String;
		
		private static var COMPONENTS = "x";
		
		public var _component:Number;
		
		/**
		public function ShaderRegisterElement(regName:String, index:Number, component:Number = -1):void
		{
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
		
		/**
		public function toString():String
		{
			return _toStr;
		}
		
		/**
		public function get regName():String
		{
			return _regName;
		}
		
		/**
		public function get index():Number
		{
			return _index;
		}
	}
}