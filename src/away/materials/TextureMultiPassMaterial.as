///<reference path="../_definitions.ts"/>

package away.materials
{
	import away.textures.Texture2DBase;

	/**
	public class TextureMultiPassMaterial extends MultiPassMaterialBase
	{
		private var _animateUVs:Boolean = false;

		/**
		public function TextureMultiPassMaterial(texture:Texture2DBase = null, smooth:Boolean = true, repeat:Boolean = false, mipmap:Boolean = true):void
		{
			super();
			this.texture = texture;
			this.smooth = smooth;
			this.repeat = repeat;
			this.mipmap = mipmap;
		}

		/**
		public function get animateUVs():Boolean
		{
			return _animateUVs;
		}
		
		public function set animateUVs(value:Boolean):void
		{
			this._animateUVs = value;
		}
		
		/**
		public function get texture():Texture2DBase
		{
			return diffuseMethod.texture;
		}
		
		public function set texture(value:Texture2DBase):void
		{
			this.diffuseMethod.texture = value;
		}
		
		/**
		public function get ambientTexture():Texture2DBase
		{
			return ambientMethod.texture;
		}
		
		public function set ambientTexture(value:Texture2DBase):void
		{
			this.ambientMethod.texture = value;
            this.diffuseMethod.iUseAmbientTexture = (value != null );
		}
		
		override public function pUpdateScreenPasses():void
		{
			super.pUpdateScreenPasses();

			if (_pEffectsPass)
                _pEffectsPass.animateUVs = _animateUVs;
		}
	}
}