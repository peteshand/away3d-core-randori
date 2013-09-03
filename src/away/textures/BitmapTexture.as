
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
			super();
			
			this.bitmapData         = bitmapData;
			this._generateMipmaps   = generateMipmaps;
		}
		
		public function get bitmapData():BitmapData
		{

			return _bitmapData;

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

			if (_generateMipmaps)
            {

                MipmapGenerator.generateMipMaps(_bitmapData, texture, _mipMapHolder, true);

            }
			else
            {

                var tx : Texture = Texture(texture);
                    tx.uploadFromBitmapData( _bitmapData , 0 );

            }

		}
		
		private function getMipMapHolder():void
		{
			var newW:Number, newH:Number;
			
			newW = _bitmapData.width;
			newH = _bitmapData.height;
			
			if (_mipMapHolder)
            {

				if (_mipMapHolder.width == newW && _bitmapData.height == newH)
                {

                    return;

                }


                freeMipMapHolder();

			}
			
			if (!BitmapTexture._mipMaps[newW])
            {

                BitmapTexture._mipMaps[newW] = [];
                BitmapTexture._mipMapUses[newW] = [];

			}

			if (!BitmapTexture._mipMaps[newW][newH])
            {

                _mipMapHolder = BitmapTexture._mipMaps[newW][newH] = new BitmapData(newW, newH, true);
                BitmapTexture._mipMapUses[newW][newH] = 1;

			}
            else
            {

                BitmapTexture._mipMapUses[newW][newH] = BitmapTexture._mipMapUses[newW][newH] + 1;
                _mipMapHolder = BitmapTexture._mipMaps[newW][newH];

			}
		}
		
		private function freeMipMapHolder():void
		{
			var holderWidth:Number = _mipMapHolder.width;
			var holderHeight:Number = _mipMapHolder.height;
			
			if (--BitmapTexture._mipMapUses[holderWidth][holderHeight] == 0)
            {

                BitmapTexture._mipMaps[holderWidth][holderHeight].dispose();
                BitmapTexture._mipMaps[holderWidth][holderHeight] = null;

			}
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			if (_mipMapHolder)
            {

                freeMipMapHolder();
            }

		}

	}

}
