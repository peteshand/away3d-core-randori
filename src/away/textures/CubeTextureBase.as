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
	public class CubeTextureBase extends TextureProxyBase
	{
		public function CubeTextureBase():void
		{
			super();
		}
		
		public function get size():Number
		{
			//TODO replace this with this._pWidth (requires change in super class to reflect the protected declaration)
			return this.width;
		}
		
		//@override
		override public function pCreateTexture(context:Context3D):TextureBase
		{
			return context.createCubeTexture( this.width, Context3DTextureFormat.BGRA, false );
		}
	}
}