/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package away.textures
{
	import away.display.BitmapData;
	import away.utils.TextureUtils;
	import away.display3D.TextureBase;
	import away.display3D.CubeTexture;
	import away.utils.VectorInit;
	public class BitmapCubeTexture extends CubeTextureBase
	{

		private var _bitmapDatas:Vector.<BitmapData>;
        private var _useMipMaps:Boolean = false;

		public function BitmapCubeTexture(posX:BitmapData, negX:BitmapData, posY:BitmapData, negY:BitmapData, posZ:BitmapData, negZ:BitmapData):void
		{
			super();
			
			this._bitmapDatas = VectorInit.AnyClass(BitmapData, 6);
			this.testSize( this._bitmapDatas[0] = posX );
            this.testSize( this._bitmapDatas[1] = negX );
            this.testSize( this._bitmapDatas[2] = posY );
            this.testSize( this._bitmapDatas[3] = negY );
            this.testSize( this._bitmapDatas[4] = posZ );
            this.testSize( this._bitmapDatas[5] = negZ );
			
			this.pSetSize(posX.width, posX.height);
		}
		
		/**		 * The texture on the cube's right face.		 */
		public function get positiveX():BitmapData
		{
			return this._bitmapDatas[0];
		}
		
		public function set positiveX(value:BitmapData):void
		{
			this.testSize(value);
			this.invalidateContent();
			this.pSetSize(value.width, value.height);
			this._bitmapDatas[0] = value;
		}
		
		/**		 * The texture on the cube's left face.		 */
		public function get negativeX():BitmapData
		{
			return this._bitmapDatas[1];
		}
		
		public function set negativeX(value:BitmapData):void
		{
			this.testSize(value);
            this.invalidateContent();
            this.pSetSize(value.width, value.height);
            this._bitmapDatas[1] = value;
		}
		
		/**		 * The texture on the cube's top face.		 */
		public function get positiveY():BitmapData
		{
			return this._bitmapDatas[2];
		}
		
		public function set positiveY(value:BitmapData):void
		{
            this.testSize(value);
            this.invalidateContent();
            this.pSetSize(value.width, value.height);
            this._bitmapDatas[2] = value;
		}
		
		/**		 * The texture on the cube's bottom face.		 */
		public function get negativeY():BitmapData
		{
			return this._bitmapDatas[3];
		}
		
		public function set negativeY(value:BitmapData):void
		{
            this.testSize(value);
            this.invalidateContent();
            this.pSetSize(value.width, value.height);
            this._bitmapDatas[3] = value;
		}
		
		/**		 * The texture on the cube's far face.		 */
		public function get positiveZ():BitmapData
		{
			return this._bitmapDatas[4];
		}
		
		public function set positiveZ(value:BitmapData):void
		{
            this.testSize(value);
            this.invalidateContent();
            this.pSetSize(value.width, value.height);
            this._bitmapDatas[4] = value;
		}
		
		/**		 * The texture on the cube's near face.		 */
		public function get negativeZ():BitmapData
		{
			return this._bitmapDatas[5];
		}
		
		public function set negativeZ(value:BitmapData):void
		{
            this.testSize(value);
            this.invalidateContent();
            this.pSetSize(value.width, value.height);
            this._bitmapDatas[5] = value;
		}
		
		private function testSize(value:BitmapData):void
		{
			if (value.width != value.height)
				throw new Error("BitmapData should have equal width and height!");
			if (!TextureUtils.isBitmapDataValid(value))
				throw new Error("Invalid bitmapData: Width and height must be power of 2 and cannot exceed 2048");
		}
		
		override public function pUploadContent(texture:TextureBase):void
		{
			for (var i:Number = 0; i < 6; ++i)
            {
                if ( this._useMipMaps )
                {

                    //away.materials.MipmapGenerator.generateMipMaps(this._bitmapDatas[i], texture, null, false, i);

                }
                else
                {

                    var tx : CubeTexture = (texture as CubeTexture);
                        tx.uploadFromBitmapData( this._bitmapDatas[i] , i , 0 );

                }


            }
		}
	}
}
