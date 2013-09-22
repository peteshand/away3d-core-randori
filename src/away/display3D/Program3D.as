/** * ... * @author Gary Paluk - http://www.plugin.io */

///<reference path="../_definitions.ts"/>
 
package away.display3D
{
	import randori.webkit.html.canvas.WebGLRenderingContext;
	import randori.webkit.html.canvas.WebGLProgram;
	import randori.webkit.html.canvas.WebGLShader;
	import randori.webkit.page.Window;
	public class Program3D
	{
		
		private var _gl:WebGLRenderingContext;
		private var _program:WebGLProgram;
		private var _vertexShader:WebGLShader;
		private var _fragmentShader:WebGLShader;
		
		public function Program3D(gl:WebGLRenderingContext):void
		{
			this._gl = gl;
			this._program = _gl.createProgram();
		}
		
		public function upload(vertexProgram:String, fragmentProgram:String):void
		{
			
			this._vertexShader = _gl.createShader( Number(WebGLRenderingContext.VERTEX_SHADER) );
			this._fragmentShader = _gl.createShader( Number(WebGLRenderingContext.FRAGMENT_SHADER) );
			
			_gl.shaderSource( this._vertexShader, vertexProgram );
			_gl.compileShader( this._vertexShader );
			
			if ( !_gl.getShaderParameter( this._vertexShader, Number(WebGLRenderingContext.COMPILE_STATUS) ) )
			{
				Window.console.log( _gl.getShaderInfoLog( this._vertexShader ) );
				return; //TODO throw errors
			}
			
			_gl.shaderSource( this._fragmentShader, fragmentProgram );
			_gl.compileShader( this._fragmentShader );
			
			if ( !_gl.getShaderParameter( this._fragmentShader, Number(WebGLRenderingContext.COMPILE_STATUS) ) )
			{
				Window.console.log( _gl.getShaderInfoLog( this._fragmentShader ) );
				return; //TODO throw errors
			}
			
			_gl.attachShader( this._program, this._vertexShader );
			_gl.attachShader( this._program, this._fragmentShader );
			_gl.linkProgram( this._program );
			
			if ( !_gl.getProgramParameter( this._program, Number(WebGLRenderingContext.LINK_STATUS) ) )
			{
				Window.console.log("Could not link the program."); //TODO throw errors
			}
		}
		
		public function dispose():void
		{
			_gl.deleteProgram( this._program );
		}
		
		public function focusProgram():void
		{
			_gl.useProgram( this._program );
		}
		
		public function get glProgram():WebGLProgram
		{
			return this._program;
		}
	}
}