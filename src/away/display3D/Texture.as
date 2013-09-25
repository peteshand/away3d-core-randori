/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package away.display3D
{
	import away.display.BitmapData;
	import randori.webkit.html.canvas.WebGLTexture;
	import randori.webkit.html.canvas.WebGLRenderingContext;
	import randori.webkit.html.HTMLImageElement;
import randori.webkit.page.Window;

public class Texture extends TextureBase
	{
		private var _width:Number = 0;
		private var _height:Number = 0;
		
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
			miplevel = miplevel || 0;
            Window.console.log(_glTexture);
            Window.console.log('miplevel = ' + miplevel);
            Window.console.log(image);

            _gl.bindTexture( Number(WebGLRenderingContext.TEXTURE_2D), _glTexture );
			_gl.texImage2D3( Number(WebGLRenderingContext.TEXTURE_2D), miplevel, Number(WebGLRenderingContext.RGBA), Number(WebGLRenderingContext.RGBA), Number(WebGLRenderingContext.UNSIGNED_BYTE), image );
			_gl.bindTexture( Number(WebGLRenderingContext.TEXTURE_2D), null );
		}
		
		public function uploadFromBitmapData(data:BitmapData, miplevel:Number = 0):void
		{
			miplevel = miplevel || 0;

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