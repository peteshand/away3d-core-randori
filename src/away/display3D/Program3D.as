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
			_gl = gl;
			_program = _gl.createProgram();
		}
		
		public function upload(vertexProgram:String, fragmentProgram:String):void
		{
			
			_vertexShader = _gl.createShader( Number(WebGLRenderingContext.VERTEX_SHADER) );
			_fragmentShader = _gl.createShader( Number(WebGLRenderingContext.FRAGMENT_SHADER) );
			
			_gl.shaderSource( _vertexShader, vertexProgram );
			_gl.compileShader( _vertexShader );
			
			if ( !_gl.getShaderParameter( _vertexShader, Number(WebGLRenderingContext.COMPILE_STATUS) ) )
			{
				Window.console.log( _gl.getShaderInfoLog( _vertexShader ) );
				return; //TODO throw errors
			}
			
			_gl.shaderSource( _fragmentShader, fragmentProgram );
			_gl.compileShader( _fragmentShader );
			
			if ( !_gl.getShaderParameter( _fragmentShader, Number(WebGLRenderingContext.COMPILE_STATUS) ) )
			{
				Window.console.log( _gl.getShaderInfoLog( _fragmentShader ) );
				return; //TODO throw errors
			}
			
			_gl.attachShader( _program, _vertexShader );
			_gl.attachShader( _program, _fragmentShader );
			_gl.linkProgram( _program );
			
			if ( !_gl.getProgramParameter( _program, Number(WebGLRenderingContext.LINK_STATUS) ) )
			{
				Window.console.log("Could not link the program."); //TODO throw errors
			}
		}
		
		public function dispose():void
		{
			_gl.deleteProgram( _program );
		}
		
		public function focusProgram():void
		{
			_gl.useProgram( _program );
		}
		
		public function get glProgram():WebGLProgram
		{
			return _program;
		}
	}
}