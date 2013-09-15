/** * ... * @author Gary Paluk - http://www.plugin.io */

///<reference path="../_definitions.ts"/>

package away.textures
{
	import away.display3D.Context3D;
	import away.display3D.TextureBase;
	import away.display3D.Context3DTextureFormat;
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