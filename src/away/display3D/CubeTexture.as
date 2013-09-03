/** * ... * @author Gary Paluk - http://www.plugin.io */

///<reference path="../_definitions.ts"/>

package away.display3D
{
	import away.display.BitmapData;
	import randori.webkit.html.canvas.WebGLRenderingContext;
	import randori.webkit.html.HTMLImageElement;
	
	public class CubeTexture extends TextureBase
	{
		private var _size:Number;
		
		public function CubeTexture(gl:WebGLRenderingContext, size:Number):void
		{
			super( gl );
			this._size = size;
		}
		
		public function uploadFromHTMLImageElement(image:HTMLImageElement, miplevel:Number = 0):void
		{
			_gl.texImage2D3( Number(WebGLRenderingContext.TEXTURE_2D), miplevel, Number(WebGLRenderingContext.RGBA), Number(WebGLRenderingContext.RGBA), Number(WebGLRenderingContext.UNSIGNED_BYTE), image );
		}
		
		public function uploadFromBitmapData(data:BitmapData, miplevel:Number = 0):void
		{
			_gl.texImage2D2( Number(WebGLRenderingContext.TEXTURE_2D), miplevel, Number(WebGLRenderingContext.RGBA), Number(WebGLRenderingContext.RGBA), Number(WebGLRenderingContext.UNSIGNED_BYTE), data.imageData );
		}
	}
}
