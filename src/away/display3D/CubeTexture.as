/** * ... * @author Gary Paluk - http://www.plugin.io */

///<reference path="../_definitions.ts"/>

package away.display3D
{
	import away.display.BitmapData;
	import randori.webkit.html.canvas.WebGLTexture;
	import randori.webkit.html.canvas.WebGLRenderingContext;
	import randori.webkit.html.HTMLImageElement;
	public class CubeTexture extends TextureBase
	{
		private var _textures:Vector.<WebGLTexture>;
		private var _size:Number;
		
		public function CubeTexture(gl:WebGLRenderingContext, size:Number):void
		{
			super( gl );
			this._size = size;
			
			textureType = "textureCube";
			
			this._textures = new Vector.<WebGLTexture>();
			for( var i:Number = 0; i < 6; ++i )
			{
				this._textures[i] = _gl.createTexture();
			}
		}
		
		override public function dispose():void
		{
			for( var i:Number = 0; i < 6; ++i )
			{
				_gl.deleteTexture( this._textures[ i ] );
			}
		}
		
		public function uploadFromHTMLImageElement(image:HTMLImageElement, side:Number, miplevel:Number = 0):void
		{
			miplevel = miplevel || 0;

			switch( side )
			{
				case 0:
						_gl.bindTexture( Number(WebGLRenderingContext.TEXTURE_CUBE_MAP), this._textures[0] );
						_gl.texImage2D3( Number(WebGLRenderingContext.TEXTURE_CUBE_MAP_POSITIVE_X), miplevel, Number(WebGLRenderingContext.RGBA), Number(WebGLRenderingContext.RGBA), Number(WebGLRenderingContext.UNSIGNED_BYTE), image );
						_gl.bindTexture( Number(WebGLRenderingContext.TEXTURE_CUBE_MAP), null );
					break;
				case 1:
						_gl.bindTexture( Number(WebGLRenderingContext.TEXTURE_CUBE_MAP), this._textures[1] );
						_gl.texImage2D3( Number(WebGLRenderingContext.TEXTURE_CUBE_MAP_NEGATIVE_X), miplevel, Number(WebGLRenderingContext.RGBA), Number(WebGLRenderingContext.RGBA), Number(WebGLRenderingContext.UNSIGNED_BYTE), image );
						_gl.bindTexture( Number(WebGLRenderingContext.TEXTURE_CUBE_MAP), null );
					break;
				case 2:
						_gl.bindTexture( Number(WebGLRenderingContext.TEXTURE_CUBE_MAP), this._textures[2] );
						_gl.texImage2D3( Number(WebGLRenderingContext.TEXTURE_CUBE_MAP_POSITIVE_Y), miplevel, Number(WebGLRenderingContext.RGBA), Number(WebGLRenderingContext.RGBA), Number(WebGLRenderingContext.UNSIGNED_BYTE), image );
						_gl.bindTexture( Number(WebGLRenderingContext.TEXTURE_CUBE_MAP), null );
					break;
				case 3:
						_gl.bindTexture( Number(WebGLRenderingContext.TEXTURE_CUBE_MAP), this._textures[3] );
						_gl.texImage2D3( Number(WebGLRenderingContext.TEXTURE_CUBE_MAP_NEGATIVE_Y), miplevel, Number(WebGLRenderingContext.RGBA), Number(WebGLRenderingContext.RGBA), Number(WebGLRenderingContext.UNSIGNED_BYTE), image );
						_gl.bindTexture( Number(WebGLRenderingContext.TEXTURE_CUBE_MAP), null );
					break;
				case 4:
						_gl.bindTexture( Number(WebGLRenderingContext.TEXTURE_CUBE_MAP), this._textures[4] );
						_gl.texImage2D3( Number(WebGLRenderingContext.TEXTURE_CUBE_MAP_POSITIVE_Z), miplevel, Number(WebGLRenderingContext.RGBA), Number(WebGLRenderingContext.RGBA), Number(WebGLRenderingContext.UNSIGNED_BYTE), image );
						_gl.bindTexture( Number(WebGLRenderingContext.TEXTURE_CUBE_MAP), null );
					break;
				case 5:
						_gl.bindTexture( Number(WebGLRenderingContext.TEXTURE_CUBE_MAP), this._textures[5] );
						_gl.texImage2D3( Number(WebGLRenderingContext.TEXTURE_CUBE_MAP_NEGATIVE_Z), miplevel, Number(WebGLRenderingContext.RGBA), Number(WebGLRenderingContext.RGBA), Number(WebGLRenderingContext.UNSIGNED_BYTE), image );
						_gl.bindTexture( Number(WebGLRenderingContext.TEXTURE_CUBE_MAP), null );
					break;
				default :
					throw "unknown side type";
			}
		}
		
		public function uploadFromBitmapData(data:BitmapData, side:Number, miplevel:Number = 0):void
		{
			miplevel = miplevel || 0;

			switch( side )
			{
				case 0:
						_gl.bindTexture( Number(WebGLRenderingContext.TEXTURE_CUBE_MAP), this._textures[0] );
						_gl.texImage2D2( Number(WebGLRenderingContext.TEXTURE_CUBE_MAP_POSITIVE_X), miplevel, Number(WebGLRenderingContext.RGBA), Number(WebGLRenderingContext.RGBA), Number(WebGLRenderingContext.UNSIGNED_BYTE), data.imageData );
						_gl.bindTexture( Number(WebGLRenderingContext.TEXTURE_CUBE_MAP), null );
					break;
				case 1:
						_gl.bindTexture( Number(WebGLRenderingContext.TEXTURE_CUBE_MAP), this._textures[1] );
						_gl.texImage2D2( Number(WebGLRenderingContext.TEXTURE_CUBE_MAP_NEGATIVE_X), miplevel, Number(WebGLRenderingContext.RGBA), Number(WebGLRenderingContext.RGBA), Number(WebGLRenderingContext.UNSIGNED_BYTE), data.imageData );
						_gl.bindTexture( Number(WebGLRenderingContext.TEXTURE_CUBE_MAP), null );
					break;
				case 2:
						_gl.bindTexture( Number(WebGLRenderingContext.TEXTURE_CUBE_MAP), this._textures[2] );
						_gl.texImage2D2( Number(WebGLRenderingContext.TEXTURE_CUBE_MAP_POSITIVE_Y), miplevel, Number(WebGLRenderingContext.RGBA), Number(WebGLRenderingContext.RGBA), Number(WebGLRenderingContext.UNSIGNED_BYTE), data.imageData );
						_gl.bindTexture( Number(WebGLRenderingContext.TEXTURE_CUBE_MAP), null );
					break;
				case 3:
						_gl.bindTexture( Number(WebGLRenderingContext.TEXTURE_CUBE_MAP), this._textures[3] );
						_gl.texImage2D2( Number(WebGLRenderingContext.TEXTURE_CUBE_MAP_NEGATIVE_Y), miplevel, Number(WebGLRenderingContext.RGBA), Number(WebGLRenderingContext.RGBA), Number(WebGLRenderingContext.UNSIGNED_BYTE), data.imageData );
						_gl.bindTexture( Number(WebGLRenderingContext.TEXTURE_CUBE_MAP), null );
					break;
				case 4:
						_gl.bindTexture( Number(WebGLRenderingContext.TEXTURE_CUBE_MAP), this._textures[4] );
						_gl.texImage2D2( Number(WebGLRenderingContext.TEXTURE_CUBE_MAP_POSITIVE_Z), miplevel, Number(WebGLRenderingContext.RGBA), Number(WebGLRenderingContext.RGBA), Number(WebGLRenderingContext.UNSIGNED_BYTE), data.imageData );
						_gl.bindTexture( Number(WebGLRenderingContext.TEXTURE_CUBE_MAP), null );
					break;
				case 5:
						_gl.bindTexture( Number(WebGLRenderingContext.TEXTURE_CUBE_MAP), this._textures[5] );
						_gl.texImage2D2( Number(WebGLRenderingContext.TEXTURE_CUBE_MAP_NEGATIVE_Z), miplevel, Number(WebGLRenderingContext.RGBA), Number(WebGLRenderingContext.RGBA), Number(WebGLRenderingContext.UNSIGNED_BYTE), data.imageData );
						_gl.bindTexture( Number(WebGLRenderingContext.TEXTURE_CUBE_MAP), null );
					break;
				default :
					throw "unknown side type";
			}
		}
		
		public function get size():Number
		{
			return this._size;
		}
		
		public function glTextureAt(index:Number):WebGLTexture
		{
			return this._textures[ index ];
		}
	}
}
