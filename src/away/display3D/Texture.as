/** * ... * @author Gary Paluk - http://www.plugin.io */

///<reference path="../_definitions.ts"/>

package away.display3D
{
	import away.display.BitmapData;
	import randori.webkit.html.canvas.WebGLTexture;
	import randori.webkit.html.canvas.WebGLRenderingContext;
	import randori.webkit.html.HTMLImageElement;
	public class Texture extends TextureBase
	{
		private var _width:Number;
		private var _height:Number;
		
		private var _glTexture:WebGLTexture;
		
		public function Texture(gl:WebGLRenderingContext, width:Number, height:Number):void
		{
			super( gl );
			
			textureType = "texture2d";
			this._width = width;
			this._height = height;
			
			_glTexture = _gl.createTexture();
		}
		
		override public function dispose():void
		{
			_gl.deleteTexture( _glTexture );
		}
		
		public function get width():Number
		{
			return this._width;
		}
		
		public function get height():Number
		{
			return this._height;
		}
		
		public function uploadFromHTMLImageElement(image:HTMLImageElement, miplevel:Number = 0):void
		{
			_gl.bindTexture( Number(WebGLRenderingContext.TEXTURE_2D), _glTexture );
			_gl.texImage2D3( Number(WebGLRenderingContext.TEXTURE_2D), miplevel, Number(WebGLRenderingContext.RGBA), Number(WebGLRenderingContext.RGBA), Number(WebGLRenderingContext.UNSIGNED_BYTE), image );
			_gl.bindTexture( Number(WebGLRenderingContext.TEXTURE_2D), null );
		}
		
		public function uploadFromBitmapData(data:BitmapData, miplevel:Number = 0):void
		{
			_gl.bindTexture( Number(WebGLRenderingContext.TEXTURE_2D), _glTexture );
			_gl.texImage2D2( Number(WebGLRenderingContext.TEXTURE_2D), miplevel, Number(WebGLRenderingContext.RGBA), Number(WebGLRenderingContext.RGBA), Number(WebGLRenderingContext.UNSIGNED_BYTE), data.imageData );
			_gl.bindTexture( Number(WebGLRenderingContext.TEXTURE_2D), null );
		}
		
		public function get glTexture():WebGLTexture
		{
			return this._glTexture;
		}
		
	}
}