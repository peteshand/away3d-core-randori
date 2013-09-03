///<reference path="../_definitions.ts"/>

package away.materials
{
	import away.display.BlendMode;

	/**
	public class ColorMaterial extends SinglePassMaterialBase
	{
		private var _diffuseAlpha:Number = 1;
		
		/**
		public function ColorMaterial(color:Number = 0xcccccc, alpha:Number = 1):void
		{

			super();

			this.color = color;
			this.alpha = alpha;

		}
		
		/**
		public function get alpha():Number
		{
			return _pScreenPass.diffuseMethod.diffuseAlpha;
		}
		
		public function set alpha(value:Number):void
		{
			if (value > 1)
            {

                value = 1;

            }
			else if (value < 0)
            {

                value = 0;
            }

			this._pScreenPass.diffuseMethod.diffuseAlpha = this._diffuseAlpha = value;
            this._pScreenPass.preserveAlpha = this.requiresBlending;
            this._pScreenPass.setBlendMode( this.getBlendMode() == BlendMode.NORMAL && this.requiresBlending? BlendMode.LAYER : this.getBlendMode());
		}
		
		/**
		public function get color():Number
		{
			return _pScreenPass.diffuseMethod.diffuseColor;
		}
		
		public function set color(value:Number):void
		{
            this._pScreenPass.diffuseMethod.diffuseColor = value;
		}
		
		/**
		override public function get requiresBlending():Boolean
		{
			return getRequiresBlending() || _diffuseAlpha < 1;
		}
	}
}