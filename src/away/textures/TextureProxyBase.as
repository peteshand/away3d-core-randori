/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

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
	import away.utils.VectorInit;

	public class TextureProxyBase extends NamedAssetBase implements IAsset
	{
		private var _format:String = Context3DTextureFormat.BGRA;
		private var _hasMipmaps:Boolean = true;

		private var _textures:Vector.<TextureBase>;
		private var _dirty:Vector.<Context3D>;

		public var _pWidth:Number = 0;
        public var _pHeight:Number = 0;

		public function TextureProxyBase():void
		{

            super(null);

            this._textures      = VectorInit.AnyClass(TextureBase,  8 );//_textures = new Vector.<TextureBase>(8);
            this._dirty         = VectorInit.AnyClass(Context3D,  8 );//_dirty = new Vector.<Context3D>(8);

		}

        /**         *         * @returns {boolean}         */
		public function get hasMipMaps():Boolean
		{
			return this._hasMipmaps;
		}

        /**         *         * @returns {string}         */
		public function get format():String
		{
			return this._format;
		}

        /**         *         * @returns {string}         */
		override public function get assetType():String
		{
			return AssetType.TEXTURE;
		}

        /**         *         * @returns {number}         */
		public function get width():Number
		{
			return this._pWidth;
		}

        /**         *         * @returns {number}         */
		public function get height():Number
		{
			return this._pHeight;
		}

		public function getTextureForStage3D(stage3DProxy:Stage3DProxy):TextureBase
		{
			var contextIndex : Number = stage3DProxy._iStage3DIndex;

			var tex : TextureBase = this._textures[contextIndex];

			var context : Context3D = stage3DProxy._iContext3D;//_context3D;

			if (!tex || this._dirty[contextIndex] != context)
            {

				this._textures[contextIndex] = this.pCreateTexture(context);
				tex = this.pCreateTexture(context);

				this._dirty[contextIndex] = context;
				this.pUploadContent(tex);//_pUploadContent

			}

			return tex;
		}

        /**         *         * @param texture         * @private         */
		public function pUploadContent(texture:TextureBase):void
		{

            throw new AbstractMethodError();

		}

        /**         *         * @param width         * @param height         * @private         */
		public function pSetSize(width:Number, height:Number):void
		{

			if (this._pWidth != width || this._pHeight != height)
            {

                this.pInvalidateSize();

            }

            this._pWidth     = width;
            this._pHeight    = height;

		}

        /**         *         */
		public function invalidateContent():void
		{

			for (var i : Number = 0; i < 8; ++i)
            {

				this._dirty[i] = null;

			}

		}

        /**         *         * @private         */
		public function pInvalidateSize():void
		{
			var tex : TextureBase;
			for (var i : Number = 0; i < 8; ++i)
            {

				tex = this._textures[i];

				if (tex)
                {
					tex.dispose();

					this._textures[i]   = null;
					this._dirty[i]      = null;

				}

			}

		}

        /**         *         * @param context         * @private         */
		public function pCreateTexture(context:Context3D):TextureBase
		{
            throw new AbstractMethodError();
		}

		/**		 * @inheritDoc		 */
		override public function dispose():void
		{
			for (var i : Number = 0; i < 8; ++i)
            {

                if (this._textures[i])
                {

                    this._textures[i].dispose();
                }

            }

		}

	}
}