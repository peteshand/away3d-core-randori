/**
 * ...
 * @author Gary Paluk - http://www.plugin.io
 */
///<reference path="../_definitions.ts"/>

package away.display3D
{
	import randori.webkit.html.canvas.WebGLRenderingContext;
	import randori.webkit.html.canvas.WebGLTexture;
	public class TextureBase
	{
		public var _gl:WebGLRenderingContext;
		private var _glTexture:WebGLTexture;
		
		public function TextureBase(gl:WebGLRenderingContext):void
		{
			_gl = gl;
			_glTexture = _gl.createTexture();
		}
		
		public function dispose():void
		{
			_gl.deleteTexture( _glTexture );
		}
		
		public function get glTexture():WebGLTexture
		{
			return _glTexture;
		}
	}
}