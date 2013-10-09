/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package away.textures
{
	import away.core.display3D.Context3D;
	import away.core.display3D.TextureBase;
	import away.core.display3D.Context3DTextureFormat;

	
	//use namespace arcane;
	
	public class Texture2DBase extends TextureProxyBase
	{
		public function Texture2DBase():void
		{
			super();
		}
		
		override public function pCreateTexture(context:Context3D):TextureBase
		{
			return context.createTexture(this.width, this.height, Context3DTextureFormat.BGRA, false);
		}
	}
}
