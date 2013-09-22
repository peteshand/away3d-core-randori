
///<reference path="../_definitions.ts"/>

package away.textures
{
	import away.display.BitmapData;
	import away.utils.TextureUtils;
	import away.display3D.TextureBase;
	import away.materials.utils.MipmapGenerator;
	import away.display3D.Texture;

	public class BitmapTexture extends Texture2DBase
	{
		private static var _mipMaps:Array = new Array();
		private static var _mipMapUses:Array = new Array();
		
		private var _bitmapData:BitmapData;
		private var _mipMapHolder:BitmapData;
		private var _generateMipmaps:Boolean;
		
		public function BitmapTexture(bitmapData:BitmapData, generateMipmaps:Boolean = true):void
		{
			generateMipmaps = generateMipmaps || true;

			super();
			
			this.bitmapData         = bitmapData;
			this._generateMipmaps   = generateMipmaps;
		}
		
		public function get bitmapData():BitmapData
		{

			return this._bitmapData;

		}
		
		public function set bitmapData(value:BitmapData):void
		{

			if (value == this._bitmapData)
            {

                return;

            }

			if (!TextureUtils.isBitmapDataValid(value))
            {

                throw new Error("Invalid bitmapData: Width and height must be power of 2 and cannot exceed 2048");

            }


            this.invalidateContent();

			this.pSetSize( value.width, value.height);

            this._bitmapData = value;
			
			if (this._generateMipmaps)
            {

                this.getMipMapHolder();

            }

		}
		
		override public function pUploadContent(texture:TextureBase):void
		{

			if (this._generateMipmaps)
            {

                MipmapGenerator.generateMipMaps(this._bitmapData, texture, this._mipMapHolder, true);

            }
			else
            {

                var tx : Texture = (texture as Texture);
                    tx.uploadFromBitmapData( this._bitmapData , 0 );

            }

		}
		
		private function getMipMapHolder():void
		{
			var newW:Number, newH:Number;
			
			newW = this._bitmapData.width;
			newH = this._bitmapData.height;
			
			if (this._mipMapHolder)
            {

				if (this._mipMapHolder.width == newW && this._bitmapData.height == newH)
                {

                    return;

                }


                this.freeMipMapHolder();

			}
			
			if (!BitmapTexture._mipMaps[newW])
            {

                BitmapTexture._mipMaps[newW] = [];
                BitmapTexture._mipMapUses[newW] = [];

			}

			if (!BitmapTexture._mipMaps[newW][newH])
            {

                this._mipMapHolder = new BitmapData(newW, newH, true);
                BitmapTexture._mipMaps[newW][newH] = new BitmapData(newW, newH, true);

                BitmapTexture._mipMapUses[newW][newH] = 1;

			}
            else
            {

                BitmapTexture._mipMapUses[newW][newH] = BitmapTexture._mipMapUses[newW][newH] + 1;
                this._mipMapHolder = BitmapTexture._mipMaps[newW][newH];

			}
		}
		
		private function freeMipMapHolder():void
		{
			var holderWidth:Number = this._mipMapHolder.width;
			var holderHeight:Number = this._mipMapHolder.height;
			
			if (--BitmapTexture._mipMapUses[holderWidth][holderHeight] == 0)
            {

                BitmapTexture._mipMaps[holderWidth][holderHeight].dispose();
                BitmapTexture._mipMaps[holderWidth][holderHeight] = null;

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
