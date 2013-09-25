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
	import randori.webkit.html.canvas.WebGLBuffer;
	public class IndexBuffer3D
	{
		
		private var _gl:WebGLRenderingContext;
		private var _numIndices:Number = 0;
		private var _buffer:WebGLBuffer;
		
		public function IndexBuffer3D(gl:WebGLRenderingContext, numIndices:Number):void
		{
			this._gl = gl;
			this._buffer = _gl.createBuffer();
			this._numIndices = numIndices;
		}
		
		public function uploadFromArray(data:Vector.<Number>, startOffset:Number, count:Number):void
		{
			_gl.bindBuffer( Number(WebGLRenderingContext.ELEMENT_ARRAY_BUFFER), this._buffer );
			
			// TODO add index offsets
			_gl.bufferData3( Number(WebGLRenderingContext.ELEMENT_ARRAY_BUFFER), new Uint16Array( data ), Number(WebGLRenderingContext.STATIC_DRAW) );
		}
		
		public function dispose():void
		{
			_gl.deleteBuffer( this._buffer );
		}
		
		public function get numIndices():Number
		{
			return this._numIndices;
		}
		
		public function get glBuffer():WebGLBuffer
		{
			return this._buffer;
		}
	}
}