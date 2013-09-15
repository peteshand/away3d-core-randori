/** * ... * @author Gary Paluk - http://www.plugin.io */

///<reference path="../_definitions.ts"/>

package away.display3D
{
	import away.geom.Matrix3D;
	import randori.webkit.html.HTMLCanvasElement;
	import randori.webkit.html.canvas.WebGLUniformLocation;
	public class AGLSLContext3D extends Context3D
	{
		
		private var _yFlip:Number = -1;
		
		public function AGLSLContext3D(canvas:HTMLCanvasElement):void
		{
			super( canvas );
		}
		
		//@override
		override public function setProgramConstantsFromMatrix(programType:String, firstRegister:Number, matrix:Matrix3D, transposedMatrix:Boolean = false):void
		{
            /*			console.log( "======== setProgramConstantsFromMatrix ========" );			console.log( "programType       >>> " + programType );			console.log( "firstRegister     >>> " + firstRegister );			console.log( "matrix            >>> " + matrix.rawData );			console.log( "transposedMatrix  >>> " + transposedMatrix );			*/

			var d:Vector.<Number> = matrix.rawData;
			if( transposedMatrix )
			{
				this.setProgramConstantsFromArray( programType, firstRegister, new <Number>[ d[0], d[4], d[8], d[12] ], 1 );
				this.setProgramConstantsFromArray( programType, firstRegister+1, new <Number>[ d[1], d[5], d[9], d[13] ], 1 );
				this.setProgramConstantsFromArray( programType, firstRegister+2, new <Number>[ d[2], d[6], d[10], d[14] ], 1 );
				this.setProgramConstantsFromArray( programType, firstRegister+3, new <Number>[ d[3], d[7], d[11], d[15] ], 1 );
			}
			else
			{
				this.setProgramConstantsFromArray( programType, firstRegister, new <Number>[ d[0], d[1], d[2], d[3] ], 1 );
				this.setProgramConstantsFromArray( programType, firstRegister+1, new <Number>[ d[4], d[5], d[6], d[7] ], 1 );
				this.setProgramConstantsFromArray( programType, firstRegister+2, new <Number>[ d[8], d[9], d[10], d[11] ], 1 );
				this.setProgramConstantsFromArray( programType, firstRegister+3, new <Number>[ d[12], d[13], d[14], d[15] ], 1 );
			}
		}
		
		//@override
		override public function drawTriangles(indexBuffer:IndexBuffer3D, firstIndex:Number = 0, numTriangles:Number = -1):void
		{
            /*			console.log( "======= drawTriangles ========" );			console.log( indexBuffer );			console.log( "firstIndex: " +  firstIndex );			console.log( "numTriangles:" + numTriangles );			*/
			var location:WebGLUniformLocation = _gl.getUniformLocation( this._currentProgram.glProgram, "yflip" );
			_gl.uniform1f( location, this._yFlip );
			super.drawTriangles( indexBuffer, firstIndex, numTriangles );
		}
		
		//@override
		override public function setCulling(triangleFaceToCull:String):void
		{
			switch( triangleFaceToCull )
			{
				case Context3DTriangleFace.FRONT:
						this._yFlip = -1; 
					break
				case Context3DTriangleFace.BACK:
						this._yFlip = 1; // checked
					break;
				case Context3DTriangleFace.FRONT_AND_BACK:
						this._yFlip = 1;
					break;
				case Context3DTriangleFace.NONE:
						this._yFlip = 1; // checked
					break;
				default:
						throw "Unknown culling mode " + triangleFaceToCull + ".";
					break;
			}
		}
	}
}