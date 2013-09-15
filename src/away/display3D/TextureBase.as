/** * ... * @author Gary Paluk - http://www.plugin.io */

///<reference path="../_definitions.ts"/>

package away.display3D
{
	import randori.webkit.html.canvas.WebGLRenderingContext;
	public class TextureBase
	{
		
		public var textureType:String = "";
		public var _gl:WebGLRenderingContext;
		
		public function TextureBase(gl:WebGLRenderingContext):void
		{
			this._gl = gl;
		}
		
		public function dispose():void
		{
			throw "Abstract method must be overridden.";
		}
	}
}