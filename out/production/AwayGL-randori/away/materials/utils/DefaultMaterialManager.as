/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package away.materials.utils
{
	import away.core.display.BitmapData;
	import away.materials.TextureMaterial;
	import away.textures.BitmapTexture;
	import away.core.base.IMaterialOwner;

	public class DefaultMaterialManager
	{
		private static var _defaultTextureBitmapData:BitmapData;
		private static var _defaultMaterial:TextureMaterial;
		private static var _defaultTexture:BitmapTexture;

		public static function getDefaultMaterial(renderable:IMaterialOwner = null):TextureMaterial
		{
			renderable = renderable || null;

			if (!DefaultMaterialManager._defaultTexture)
            {
                DefaultMaterialManager.createDefaultTexture();
            }

			
			if (!DefaultMaterialManager._defaultMaterial)
            {
                DefaultMaterialManager.createDefaultMaterial();
            }

			return DefaultMaterialManager._defaultMaterial;

		}
		
		public static function getDefaultTexture(renderable:IMaterialOwner = null):BitmapTexture
		{
			renderable = renderable || null;

			if (!DefaultMaterialManager._defaultTexture)
            {
                DefaultMaterialManager.createDefaultTexture();

            }

			return DefaultMaterialManager._defaultTexture;

		}
		
		private static function createDefaultTexture():void
		{
            DefaultMaterialManager._defaultTextureBitmapData = DefaultMaterialManager.createCheckeredBitmapData();//new away.display.BitmapData(8, 8, false, 0x000000);
			
			//create chekerboard
            /*			var i:number, j:number;			for (i = 0; i < 8; i++)            {				for (j = 0; j < 8; j++)                {					if ((j & 1) ^ (i & 1))                    {                        DefaultMaterialManager._defaultTextureBitmapData.setPixel(i, j, 0XFFFFFF);                    }				}			}            */

            DefaultMaterialManager._defaultTexture = new BitmapTexture( DefaultMaterialManager._defaultTextureBitmapData , false );
            DefaultMaterialManager._defaultTexture.name = "defaultTexture";
		}

        public static function createCheckeredBitmapData():BitmapData
        {
            var b : BitmapData = new BitmapData(8, 8, false, 0x000000);

            //create chekerboard
            var i:Number, j:Number;
            for (i = 0; i < 8; i++)
            {
                for (j = 0; j < 8; j++)
                {
                    if ((j & 1) ^ (i & 1))
                    {
                        b.setPixel(i, j, 0XFFFFFF);
                    }
                }
            }

            return b;

        }
		
		private static function createDefaultMaterial():void
		{
            DefaultMaterialManager._defaultMaterial         = new TextureMaterial( DefaultMaterialManager._defaultTexture );
            DefaultMaterialManager._defaultMaterial.mipmap  = false;
            DefaultMaterialManager._defaultMaterial.smooth  = false;
            DefaultMaterialManager._defaultMaterial.name    = "defaultMaterial";

		}
	}
}
