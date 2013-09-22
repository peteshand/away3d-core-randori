

///<reference path="../_definitions.ts"/>

package away.textures
{
	import away.display.BitmapData;
	import away.utils.TextureUtils;
	import away.errors.Error;
	import away.display3D.TextureBase;
	import away.materials.utils.MipmapGenerator;
	import away.display3D.Texture;
	import randori.webkit.html.HTMLImageElement;

	public class HTMLImageElementTexture extends Texture2DBase
	{
		private static var _mipMaps:Array = new Array();
		private static var _mipMapUses:Array = new Array();
		
		private var _htmlImageElement:HTMLImageElement;
        private var _generateMipmaps:Boolean;
		private var _mipMapHolder:BitmapData;
		
		public function HTMLImageElementTexture(htmlImageElement:HTMLImageElement, generateMipmaps:Boolean = true):void
		{
			generateMipmaps = generateMipmaps || true;

			super();
			
			this._htmlImageElement= htmlImageElement;
			this._generateMipmaps   = generateMipmaps;
		}
		
		public function get htmlImageElement():HTMLImageElement
		{
			return this._htmlImageElement;
		}
		
		public function set htmlImageElement(value:HTMLImageElement):void
		{

			if (value == this._htmlImageElement)
            {

                return;

            }

			if ( ! TextureUtils.isHTMLImageElementValid( value ) )
            {

                throw new away.errors.Error("Invalid bitmapData: Width and height must be power of 2 and cannot exceed 2048");

            }

            this.invalidateContent();
			this.pSetSize( value.width , value.height );
            this._htmlImageElement = value;
			
			if ( this._generateMipmaps )
            {

                this.getMipMapHolder();

            }

		}
		
		override public function pUploadContent(texture:TextureBase):void
		{

			if (this._generateMipmaps)
            {

                MipmapGenerator.generateHTMLImageElementMipMaps( this._htmlImageElement , texture , this._mipMapHolder , true);

            }
			else
            {

                var tx : Texture = Texture(texture)
                    tx.uploadFromHTMLImageElement( this._htmlImageElement , 0 );

            }

		}
		
		private function getMipMapHolder():void
		{

            var newW : Number  = this._htmlImageElement.width;
            var newH : Number = this._htmlImageElement.height;
			
			if (this._mipMapHolder) {

				if (this._mipMapHolder.width == newW && this._htmlImageElement.height == newH)
                {

                    return;

                }

                this.freeMipMapHolder();

			}
			
			if (!HTMLImageElementTexture._mipMaps[newW])
            {

                HTMLImageElementTexture._mipMaps[newW]      = [];
                HTMLImageElementTexture._mipMapUses[newW]   = [];

			}

			if (!HTMLImageElementTexture._mipMaps[newW][newH])
            {

                this._mipMapHolder = new BitmapData(newW, newH, true);
                HTMLImageElementTexture._mipMaps[newW][newH] = new BitmapData(newW, newH, true);

                HTMLImageElementTexture._mipMapUses[newW][newH] = 1;

			}
            else
            {

                HTMLImageElementTexture._mipMapUses[newW][newH] = HTMLImageElementTexture._mipMapUses[newW][newH] + 1;
                this._mipMapHolder = HTMLImageElementTexture._mipMaps[newW][newH];

			}
		}
		
		private function freeMipMapHolder():void
		{
			var holderWidth     : Number = this._mipMapHolder.width;
			var holderHeight    : Number = this._mipMapHolder.height;
			
			if ( --HTMLImageElementTexture._mipMapUses[holderWidth][holderHeight] == 0 )
            {

                HTMLImageElementTexture._mipMaps[holderWidth][holderHeight].dispose();
                HTMLImageElementTexture._mipMaps[holderWidth][holderHeight] = null;

			}
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			if (this._mipMapHolder)
            {

                this.freeMipMapHolder();

            }

		}

	}
}
