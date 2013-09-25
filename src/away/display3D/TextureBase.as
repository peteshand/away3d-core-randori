/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package away.display3D
{
	import randori.webkit.html.canvas.WebGLRenderingContext;
	public class TextureBase
	{
		
		public var textureType:String = "";
		public var _gl:WebGLRenderingContext;
		
		public function TextureBase(gl:WebGLRenderingContext):void
		{
			this._gl = gl;
		}
		
		public function dispose():void
		{
			throw "Abstract method must be overridden.";
		}
	}
}