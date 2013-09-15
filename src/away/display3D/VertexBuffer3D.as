/** * ... * @author Gary Paluk - http://www.plugin.io */

///<reference path="../_definitions.ts"/>

package away.display3D
{
	import randori.webkit.html.canvas.WebGLRenderingContext;
	import randori.webkit.html.canvas.WebGLBuffer;
	import randori.webkit.page.Window;
	
	public class VertexBuffer3D
	{
		
		private var _gl:WebGLRenderingContext;
		private var _numVertices:Number;
		private var _data32PerVertex:Number;
		private var _buffer:WebGLBuffer;
	
		public function VertexBuffer3D(gl:WebGLRenderingContext, numVertices:Number, data32PerVertex:Number):void
		{
			this._gl = gl;
			this._buffer = _gl.createBuffer();
			this._numVertices = numVertices;
			this._data32PerVertex = data32PerVertex;
		}
		
		public function uploadFromArray(vertices:Vector.<Number>, startVertex:Number, numVertices:Number):void
		{
			_gl.bindBuffer( Number(WebGLRenderingContext.ARRAY_BUFFER), this._buffer );

			Window.console.log( "** WARNING upload not fully implemented, startVertex & numVertices not considered." );
			// TODO add offsets , startVertex, numVertices * this._data32PerVertex
			_gl.bufferData3( Number(WebGLRenderingContext.ARRAY_BUFFER), new Float32Array( vertices ), Number(WebGLRenderingContext.STATIC_DRAW) );
		}
		
		public function get numVertices():Number
		{
			return this._numVertices;
		}
		
		public function get data32PerVertex():Number
		{
			return this._data32PerVertex;
		}
		
		public function get glBuffer():WebGLBuffer
		{
			return this._buffer;
		}
		
		public function dispose():void
		{
			_gl.deleteBuffer( this._buffer );
		}
	}
}