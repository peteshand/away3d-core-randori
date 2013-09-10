/** * ... * @author Gary Paluk - http://www.plugin.io */

///<reference path="../_definitions.ts"/>

package away.display3D
{
	import away.display.BitmapData;
	import randori.webkit.html.canvas.WebGLRenderingContext;
	import randori.webkit.html.HTMLImageElement;
	public class Texture extends TextureBase
	{
		
		private var _width:Number;
		private var _height:Number;
		
		public function Texture(gl:WebGLRenderingContext, width:Number, height:Number):void
		{
			super( gl );
			_width = width;
			_height = height;
			
			_gl.bindTexture( Number(WebGLRenderingContext.TEXTURE_2D), glTexture );
			_gl.texImage2D1( Number(WebGLRenderingContext.TEXTURE_2D), 0, Number(WebGLRenderingContext.RGBA), width, height, 0, Number(WebGLRenderingContext.RGBA), Number(WebGLRenderingContext.UNSIGNED_BYTE), null );
		}
		
		public function get width():Number
		{
			return _width;
		}
		
		public function get height():Number
		{
			return _height;
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