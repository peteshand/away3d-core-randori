/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package aglsl
{
	import aglsl.assembler.AGALMiniAssembler;
	import away.utils.ByteArray;
	
	public class AGLSLCompiler
	{
		
		public var glsl:String = null;
		
		public function compile(programType:String, source:String):String
		{
			var agalMiniAssembler: AGALMiniAssembler = new AGALMiniAssembler();
			var tokenizer:AGALTokenizer = new AGALTokenizer();
			
			var data:ByteArray 
			var concatSource:String;
			switch( programType )
			{
				case "vertex":
					concatSource = "part vertex 1\n" +
									source+
									"endpart";
						agalMiniAssembler.assemble( concatSource );
						data = agalMiniAssembler.r['vertex'].data;
					break;
				case "fragment":
						concatSource = "part fragment 1\n" +
									   source +
									   "endpart";
						agalMiniAssembler.assemble( concatSource );
						data = agalMiniAssembler.r['fragment'].data;
					break;
				default:
					throw "Unknown Context3DProgramType";
			}
			
			var description:Description = tokenizer.decribeAGALByteArray( data );
			
			var parser:AGLSLParser = new AGLSLParser();
			this.glsl = parser.parse( description );
			
			return this.glsl;
		}
	}
	
}