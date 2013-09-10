
///<reference path="../_definitions.ts"/>

package away.textures
{
	import away.library.assets.NamedAssetBase;
	import away.library.assets.IAsset;
	import away.display3D.Context3DTextureFormat;
	import away.display3D.TextureBase;
	import away.display3D.Context3D;
	import away.library.assets.AssetType;
	import away.managers.Stage3DProxy;
	import away.errors.AbstractMethodError;

	public class TextureProxyBase extends NamedAssetBase implements IAsset
	{
		private var _format:String = Context3DTextureFormat.BGRA;
		private var _hasMipmaps:Boolean = true;

		private var _textures:Vector.<TextureBase>;
		private var _dirty:Vector.<Context3D>;

		public var _pWidth:Number;
        public var _pHeight:Number;

		public function TextureProxyBase():void
		{

            super();

            _textures      = new Vector.<TextureBase>( 8 );//_textures = new Vector.<TextureBase>(8);
            _dirty         = new Vector.<Context3D>( 8 );//_dirty = new Vector.<Context3D>(8);

		}

        /**
         *
         * @returns {boolean}
         */
		public function get hasMipMaps():Boolean
		{
			return _hasMipmaps;
		}

        /**
         *
         * @returns {string}
         */
		public function get format():String
		{
			return _format;
		}

        /**
         *
         * @returns {string}
         */
		override public function get assetType():String
		{
			return AssetType.TEXTURE;
		}

        /**
         *
         * @returns {number}
         */
		public function get width():Number
		{
			return _pWidth;
		}

        /**
         *
         * @returns {number}
         */
		public function get height():Number
		{
			return _pHeight;
		}

		public function getTextureForStage3D(stage3DProxy:Stage3DProxy):TextureBase
		{
			var contextIndex : Number = stage3DProxy._iStage3DIndex;

			var tex : TextureBase = _textures[contextIndex];

			var context : Context3D = stage3DProxy._iContext3D;//_context3D;

			if (!tex || _dirty[contextIndex] != context)
            {

				_textures[contextIndex] = tex = pCreateTexture(context);
				_dirty[contextIndex] = context;
				pUploadContent(tex);//_pUploadContent

			}

			return tex;
		}

        /**
         *
         * @param texture
         * @private
         */
		public function pUploadContent(texture:TextureBase):void
		{

            throw new AbstractMethodError();

		}

        /**
         *
         * @param width
         * @param height
         * @private
         */
		public function pSetSize(width:Number, height:Number):void
		{

			if (_pWidth != width || _pHeight != height)
            {

                pInvalidateSize();

            }

            _pWidth     = width;
            _pHeight    = height;

		}

        /**
         *
         */
		public function invalidateContent():void
		{

			for (var i : Number = 0; i < 8; ++i)
            {

				_dirty[i] = null;

			}

		}

        /**
         *
         * @private
         */
		public function pInvalidateSize():void
		{
			var tex : TextureBase;
			for (var i : Number = 0; i < 8; ++i)
            {

				tex = _textures[i];

				if (tex)
                {
					tex.dispose();

					_textures[i]   = null;
					_dirty[i]      = null;

				}

			}

		}

        /**
         *
         * @param context
         * @private
         */
		public function pCreateTexture(context:Context3D):TextureBase
		{
            throw new AbstractMethodError();
		}

		/**
		 * @inheritDoc
		 */
		override public function dispose():void
		{
			for (var i : Number = 0; i < 8; ++i)
            {

                if (_textures[i])
                {

                    _textures[i].dispose();
                }

            }

		}

	}
}