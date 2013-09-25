/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package away.textures
{
	import away.utils.TextureUtils;
	import away.display3D.TextureBase;
	import away.display.BitmapData;
	import away.materials.utils.MipmapGenerator;
	import away.display3D.Context3D;
	import away.display3D.Context3DTextureFormat;

	public class RenderTexture extends Texture2DBase
	{
		public function RenderTexture(width:Number, height:Number):void
		{
			super();
			this.pSetSize(width, height);
		}
		
		public function set width(value:Number):void
		{
			if (value == this._pWidth)
            {
				return;
            }

			if (!TextureUtils.isDimensionValid(value))
				throw new Error("Invalid size: Width and height must be power of 2 and cannot exceed 2048");
			
			this.invalidateContent();
			this.pSetSize(value, this._pHeight);
		}
		
		public function set height(value:Number):void
		{
			if (value == this._pHeight)
            {
				return;
            }

			if (!TextureUtils.isDimensionValid(value))
            {
				throw new Error("Invalid size: Width and height must be power of 2 and cannot exceed 2048");
            }

			this.invalidateContent();
			this.pSetSize( this._pWidth, value);
		}
		
		override public function pUploadContent(texture:TextureBase):void
		{
			// fake data, to complete texture for sampling
			var bmp:BitmapData = new BitmapData ( this.width, this.height, false, 0xff0000);
			MipmapGenerator.generateMipMaps(bmp, texture);
			bmp.dispose();
		}
		
		override public function pCreateTexture(context:Context3D):TextureBase
		{
			return context.createTexture(this.width, this.height, Context3DTextureFormat.BGRA, true);
		}
	}
}
