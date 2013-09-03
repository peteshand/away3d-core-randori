

///<reference path="../_definitions.ts"/>

package away.textures
{
	import away.display3D.Context3D;
	import away.display3D.TextureBase;
	import away.display3D.Context3DTextureFormat;

	
	//use namespace arcane;
	
	public class Texture2DBase extends TextureProxyBase
	{
		public function Texture2DBase():void
		{
			super();
		}
		
		override public function pCreateTexture(context:Context3D):TextureBase
		{
			return context.createTexture(width, height, Context3DTextureFormat.BGRA, false);
		}
	}
}
