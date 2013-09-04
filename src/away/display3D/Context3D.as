/**
 * ...
 * @author Gary Paluk - http://www.plugin.io
 */

///<reference path="../_definitions.ts"/>

package away.display3D
{
	import away.display.BitmapData;
	import away.errors.PartialImplementationError;
	import away.geom.Matrix3D;
	import away.geom.Rectangle;
	import randori.webkit.html.canvas.WebGLRenderingContext;
	import randori.webkit.html.HTMLCanvasElement;
	import randori.webkit.page.Window;
	import randori.webkit.html.canvas.WebGLUniformLocation;
	
	public class Context3D
	{
		
		private var _drawing:Boolean;
		private var _blendEnabled:Boolean;
		private var _blendSourceFactor:Number;
		private var _blendDestinationFactor:Number;
		
		private var _currentWrap:Number = 0;
		private var _currentFilter:Number = 0;
		private var _currentMipFilter:Number = 0;
		
		private var _indexBufferList:Vector.<IndexBuffer3D> = new Vector.<IndexBuffer3D>();
		private var _vertexBufferList:Vector.<VertexBuffer3D> = new Vector.<VertexBuffer3D>();
		private var _textureList:Vector.<TextureBase> = new Vector.<TextureBase>();
		private var _programList:Vector.<Program3D> = new Vector.<Program3D>();
		
		private var _samplerStates:Vector.<SamplerState> = new Vector.<SamplerState>();
		
		public static var MAX_SAMPLERS:Number = 8;
		
		//@protected
		public var _gl:WebGLRenderingContext;
		
		//@protected
		public var _currentProgram:Program3D;
		
		public function Context3D(canvas:HTMLCanvasElement):void
		{
			try
			{
				this._gl = WebGLRenderingContext(canvas.getContext("experimental-webgl"));
				if( !this._gl )
				{
					this._gl = WebGLRenderingContext(canvas.getContext("webgl"));
				}
			}
			catch(e)
			{
				//this.dispatchEvent( new away.events.AwayEvent( away.events.AwayEvent.INITIALIZE_FAILED, e ) );
			}
			
			if( this._gl )
			{
				//this.dispatchEvent( new away.events.AwayEvent( away.events.AwayEvent.INITIALIZE_SUCCESS ) );
			}
			else
			{
				//this.dispatchEvent( new away.events.AwayEvent( away.events.AwayEvent.INITIALIZE_FAILED, e ) );
				Window.console.log("WebGL is not available.");
			}
			
			for( var i:Number = 0; i < Context3D.MAX_SAMPLERS; ++i )
			{
				this._samplerStates[ i ] = new SamplerState();
				this._samplerStates[ i ].wrap = Number(WebGLRenderingContext.REPEAT)
				this._samplerStates[ i ].filter = Number(WebGLRenderingContext.LINEAR)
				this._samplerStates[ i ].mipfilter = 0;
			}
		}
		
		public function gl():WebGLRenderingContext
		{
			return _gl;
		}
		
		public function clear(red:Number = 0, green:Number = 0, blue:Number = 0, alpha:Number = 1, depth:Number = 1, stencil:Number = 0, mask:Number = 0):void
		{
			if (!_drawing) 
			{
				updateBlendStatus();
				_drawing = true;
			}
			_gl.clearColor( red, green, blue, alpha );
			_gl.clearDepth( depth );
			_gl.clearStencil( stencil );
			_gl.clear( mask );
		}
		
		public function configureBackBuffer(width:Number, height:Number, antiAlias:Number, enableDepthAndStencil:Boolean = true):void
		{
			if( enableDepthAndStencil )
			{
				_gl.enable( Number(WebGLRenderingContext.STENCIL_TEST) );
				_gl.enable( Number(WebGLRenderingContext.DEPTH_TEST) );
			}
			
			_gl.viewport.width = width;
			_gl.viewport.height = height;
			
            _gl.viewport(0, 0, width, height);
		}
		
		public function createCubeTexture(size:Number, format:String, optimizeForRenderToTexture:Boolean, streamingLevels:Number = 0):CubeTexture 
		{
            var texture: CubeTexture = new CubeTexture( _gl, size );
            _textureList.push( texture );
            return texture;
		}
		
		public function createIndexBuffer(numIndices:Number):IndexBuffer3D
		{
			var indexBuffer:IndexBuffer3D = new IndexBuffer3D( _gl, numIndices );
			_indexBufferList.push( indexBuffer );
			return indexBuffer;
		}
		
		public function createProgram():Program3D
		{
			var program:Program3D = new Program3D( _gl );
			_programList.push( program );
			return program;
		}
		
		public function createTexture(width:Number, height:Number, format:String, optimizeForRenderToTexture:Boolean, streamingLevels:Number = 0):Texture
		{
			//TODO streaming
			var texture: Texture = new Texture( _gl, width, height );
			_textureList.push( texture );
			return texture;
		}
		
		public function createVertexBuffer(numVertices:Number, data32PerVertex:Number):VertexBuffer3D
		{
			var vertexBuffer:VertexBuffer3D = new VertexBuffer3D( _gl, numVertices, data32PerVertex );
			_vertexBufferList.push( vertexBuffer );
			return vertexBuffer;
		}
		
		public function dispose():void
		{
			var i:Number;
			for( i = 0; i < _indexBufferList.length; ++i )
			{
				_indexBufferList[i].dispose();
			}
			_indexBufferList = null;
			
			for( i = 0; i < _vertexBufferList.length; ++i )
			{
				_vertexBufferList[i].dispose();
			}
			_vertexBufferList = null;
			
			for( i = 0; i < _textureList.length; ++i )
			{
				_textureList[i].dispose();
			}
			_textureList = null;
			
			for( i = 0; i < _programList.length; ++i )
			{
				_programList[i].dispose();
			}
			
			for( i = 0; i < _samplerStates.length; ++i )
			{
				_samplerStates[i] = null;
			}
			
			_programList = null;
		}
		
		public function drawToBitmapData(destination:BitmapData):void 
		{
			// TODO drawToBitmapData( destination:away.display.BitmapData )
			
			/*
			rttFramebuffer = gl.createFramebuffer();
			gl.bindFramebuffer(gl.FRAMEBUFFER, rttFramebuffer);
			rttFramebuffer.width = 512;
			rttFramebuffer.height = 512;
			
			rttTexture = gl.createTexture();
			gl.bindTexture(gl.TEXTURE_2D, rttTexture);
			gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.LINEAR);
			gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.LINEAR_MIPMAP_NEAREST);
			gl.generateMipmap(gl.TEXTURE_2D);
			gl.texImage2D(gl.TEXTURE_2D, 0, gl.RGBA, rttFramebuffer.width, rttFramebuffer.height, 0, gl.RGBA, gl.UNSIGNED_BYTE, null);
			
			var renderbuffer = gl.createRenderbuffer();
			gl.bindRenderbuffer(gl.RENDERBUFFER, renderbuffer);
			gl.renderbufferStorage(gl.RENDERBUFFER, gl.DEPTH_COMPONENT16, rttFramebuffer.width, rttFramebuffer.height);

			gl.framebufferTexture2D(gl.FRAMEBUFFER, gl.COLOR_ATTACHMENT0, gl.TEXTURE_2D, rttTexture, 0);
			gl.framebufferRenderbuffer(gl.FRAMEBUFFER, gl.DEPTH_ATTACHMENT, gl.RENDERBUFFER, renderbuffer);
			
			gl.bindTexture(gl.TEXTURE_2D, null);
			gl.bindRenderbuffer(gl.RENDERBUFFER, null);
			gl.bindFramebuffer(gl.FRAMEBUFFER, null);
			*/
			
			throw new PartialImplementationError();
		}
		
		public function drawTriangles(indexBuffer:IndexBuffer3D, firstIndex:Number = 0, numTriangles:Number = -1):void
		{
            /*
			console.log( "======= drawTriangles ======= " )
			console.log( indexBuffer );
			console.log( "firstIndex   >>>>> " + firstIndex );
			console.log( "numTriangles >>>>> " + numTriangles );
			*/
			if ( !_drawing ) 
			{
				throw "Need to clear before drawing if the buffer has not been cleared since the last present() call.";
			}
			
			var numIndices:Number = 0;
			
			if (numTriangles == -1) 
			{
				numIndices = indexBuffer.numIndices;
			}
			else
			{
				numIndices = numTriangles * 3;
			}
			
			_gl.bindBuffer( Number(WebGLRenderingContext.ELEMENT_ARRAY_BUFFER), indexBuffer.glBuffer );
			_gl.drawElements( Number(WebGLRenderingContext.TRIANGLES), numIndices, Number(WebGLRenderingContext.UNSIGNED_SHORT), firstIndex );
		}
		
		public function present():void
		{
			_drawing = false;
			//this._gl.useProgram( null );
		}
		
		public function setBlendFactors(sourceFactor:String, destinationFactor:String):void 
		{
			_blendEnabled = true;
			
			switch( sourceFactor )
			{
				case Context3DBlendFactor.ONE:
						_blendSourceFactor = Number(WebGLRenderingContext.ONE);
					break;
				case Context3DBlendFactor.DESTINATION_ALPHA:
						_blendSourceFactor = Number(WebGLRenderingContext.DST_ALPHA);
					break;
				case Context3DBlendFactor.DESTINATION_COLOR:
						_blendSourceFactor = Number(WebGLRenderingContext.DST_COLOR);
					break;
				case Context3DBlendFactor.ONE:
						_blendSourceFactor = Number(WebGLRenderingContext.ONE);
					break;
				case Context3DBlendFactor.ONE_MINUS_DESTINATION_ALPHA:
						_blendSourceFactor = Number(WebGLRenderingContext.ONE_MINUS_DST_ALPHA);
					break;
				case Context3DBlendFactor.ONE_MINUS_DESTINATION_COLOR:
						_blendSourceFactor = Number(WebGLRenderingContext.ONE_MINUS_DST_COLOR);
					break;
				case Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA:
						_blendSourceFactor = Number(WebGLRenderingContext.ONE_MINUS_SRC_ALPHA);
					break;
				case Context3DBlendFactor.ONE_MINUS_SOURCE_COLOR:
						_blendSourceFactor = Number(WebGLRenderingContext.ONE_MINUS_SRC_COLOR);
					break;
				case Context3DBlendFactor.SOURCE_ALPHA:
						_blendSourceFactor = Number(WebGLRenderingContext.SRC_ALPHA);
					break;
				case Context3DBlendFactor.SOURCE_COLOR:
						_blendSourceFactor = Number(WebGLRenderingContext.SRC_COLOR);
					break;
				case Context3DBlendFactor.ZERO:
						_blendSourceFactor = Number(WebGLRenderingContext.ZERO);
					break;
				default:
						throw "Unknown blend source factor"; // TODO error
					break;
			}
			
			switch( destinationFactor )
			{
				case Context3DBlendFactor.ONE:
						_blendDestinationFactor = Number(WebGLRenderingContext.ONE);
					break;
				case Context3DBlendFactor.DESTINATION_ALPHA:
						_blendDestinationFactor = Number(WebGLRenderingContext.DST_ALPHA);
					break;
				case Context3DBlendFactor.DESTINATION_COLOR:
						_blendDestinationFactor = Number(WebGLRenderingContext.DST_COLOR);
					break;
				case Context3DBlendFactor.ONE:
						_blendDestinationFactor = Number(WebGLRenderingContext.ONE);
					break;
				case Context3DBlendFactor.ONE_MINUS_DESTINATION_ALPHA:
						_blendDestinationFactor = Number(WebGLRenderingContext.ONE_MINUS_DST_ALPHA);
					break;
				case Context3DBlendFactor.ONE_MINUS_DESTINATION_COLOR:
						_blendDestinationFactor = Number(WebGLRenderingContext.ONE_MINUS_DST_COLOR);
					break;
				case Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA:
						_blendDestinationFactor = Number(WebGLRenderingContext.ONE_MINUS_SRC_ALPHA);
					break;
				case Context3DBlendFactor.ONE_MINUS_SOURCE_COLOR:
						_blendDestinationFactor = Number(WebGLRenderingContext.ONE_MINUS_SRC_COLOR);
					break;
				case Context3DBlendFactor.SOURCE_ALPHA:
						_blendDestinationFactor = Number(WebGLRenderingContext.SRC_ALPHA);
					break;
				case Context3DBlendFactor.SOURCE_COLOR:
						_blendDestinationFactor = Number(WebGLRenderingContext.SRC_COLOR);
					break;
				case Context3DBlendFactor.ZERO:
						_blendDestinationFactor = Number(WebGLRenderingContext.ZERO);
					break;
				default:
						throw "Unknown blend destination factor"; // TODO error
					break;
			}
			
			updateBlendStatus();
		}
		
		public function setColorMask(red:Boolean, green:Boolean, blue:Boolean, alpha:Boolean):void 
		{
			_gl.colorMask( red, green, blue, alpha );
		}
		
		public function setCulling(triangleFaceToCull:String):void 
		{
			if( triangleFaceToCull == Context3DTriangleFace.NONE )
			{
				_gl.disable( Number(WebGLRenderingContext.CULL_FACE) );
			}
			else
			{
				_gl.enable( Number(WebGLRenderingContext.CULL_FACE) );
				switch( triangleFaceToCull )
				{
					case Context3DTriangleFace.FRONT:
							_gl.cullFace( Number(WebGLRenderingContext.FRONT) );
						break
					case Context3DTriangleFace.BACK:
							_gl.cullFace( Number(WebGLRenderingContext.BACK) );
						break;
					case Context3DTriangleFace.FRONT_AND_BACK:
							_gl.cullFace( Number(WebGLRenderingContext.FRONT_AND_BACK) );
						break;
					default:
						throw "Unknown Context3DTriangleFace type."; // TODO error
				}
			}
		}
		
		// TODO Context3DCompareMode
		public function setDepthTest(depthMask:Boolean, passCompareMode:String):void 
		{
			switch( passCompareMode )
			{
				case Context3DCompareMode.ALWAYS:
						_gl.depthFunc( Number(WebGLRenderingContext.ALWAYS) );
					break;
				case Context3DCompareMode.EQUAL:
						_gl.depthFunc( Number(WebGLRenderingContext.EQUAL) );
					break;
				case Context3DCompareMode.GREATER:
						_gl.depthFunc( Number(WebGLRenderingContext.GREATER) );
					break;
				case Context3DCompareMode.GREATER_EQUAL:
						_gl.depthFunc( Number(WebGLRenderingContext.GEQUAL) );
					break;
				case Context3DCompareMode.LESS:
						_gl.depthFunc( Number(WebGLRenderingContext.LESS) );
					break;
				case Context3DCompareMode.LESS_EQUAL:
						_gl.depthFunc( Number(WebGLRenderingContext.LEQUAL) );
					break;
				case Context3DCompareMode.NEVER:
						_gl.depthFunc( Number(WebGLRenderingContext.NEVER) );
					break;
				case Context3DCompareMode.NOT_EQUAL:
						_gl.depthFunc( Number(WebGLRenderingContext.NOTEQUAL) );
					break;
				default:
						throw "Unknown Context3DCompareMode type."; // TODO error
					break;
			}
			_gl.depthMask( depthMask );
		}
		
		public function setProgram(program3D:Program3D):void
		{
			//TODO decide on construction/reference resposibilities
			_currentProgram = program3D;
			program3D.focusProgram();
		}
		
		private function getUniformLocationNameFromAgalRegisterIndex(programType:String, firstRegister:Number):String
		{
			switch( programType)
			{
				case Context3DProgramType.VERTEX:
						return "vc";
					break;
				case Context3DProgramType.FRAGMENT:
						return "fc";
					break;
				default:
					throw "Program Type " + programType + " not supported";
			}
		}
		
		/*
		public setProgramConstantsFromByteArray
		*/
		
		public function setProgramConstantsFromMatrix(programType:String, firstRegister:Number, matrix:Matrix3D, transposedMatrix:Boolean = false):void
		{
			var locationName = getUniformLocationNameFromAgalRegisterIndex( programType, firstRegister );
			setGLSLProgramConstantsFromMatrix( locationName, matrix, transposedMatrix );
		}
		
		public static var modulo:Number = 0;		
		public function setProgramConstantsFromArray(programType:String, firstRegister:Number, data:Vector.<Number>, numRegisters:Number = -1):void
		{
			for( var i: Number = 0; i < numRegisters; ++i )
			{
				var currentIndex:Number = i * 4;
				var locationName:String = getUniformLocationNameFromAgalRegisterIndex( programType, firstRegister + i ) + ( i + firstRegister );
				
				setGLSLProgramConstantsFromArray( locationName, data, currentIndex );
			}
		}
		
		/*
		public setGLSLProgramConstantsFromByteArray
		
		*/
		
		public function setGLSLProgramConstantsFromMatrix(locationName:String, matrix:Matrix3D, transposedMatrix:Boolean = false):void 
		{/*
			console.log( "======= setGLSLProgramConstantsFromMatrix ======= " )
			console.log( "locationName : " + locationName );
			console.log( "matrix : " + matrix.rawData );
			console.log( "transposedMatrix : " + transposedMatrix );
			console.log( "================================================= \n" )*/
			var location:WebGLUniformLocation = _gl.getUniformLocation( _currentProgram.glProgram, locationName );
			_gl.uniformMatrix4fv( location, !transposedMatrix, new Float32Array( matrix.rawData ) );
		}
		
		public function setGLSLProgramConstantsFromArray(locationName:String, data:Vector.<Number>, startIndex:Number = 0):void 
		{/*
			console.log( "======= setGLSLProgramConstantsFromArray ======= " )
			console.log( "locationName : " + locationName );
			console.log( "data : " + data );
			console.log( "startIndex : " + startIndex );
			console.log( "================================================ \n" )*/
			var location:WebGLUniformLocation = _gl.getUniformLocation( _currentProgram.glProgram, locationName );
			_gl.uniform4f( location, data[startIndex], data[startIndex+1], data[startIndex+2], data[startIndex+3] );
		}
		
		public function setScissorRectangle(rectangle:Rectangle):void 
		{
			if( !rectangle )
			{
				_gl.disable( Number(WebGLRenderingContext.SCISSOR_TEST) );
				return;
			}
			
			_gl.enable( Number(WebGLRenderingContext.SCISSOR_TEST) );
			_gl.scissor( rectangle.x, rectangle.y, rectangle.width, rectangle.height );
		}
		
		public function setTextureAt(sampler:Number, texture:TextureBase):void
		{
			var locationName:String = "fs" + sampler;
			setGLSLTextureAt( locationName, texture, sampler );
		}
		
		public function setGLSLTextureAt(locationName:String, texture:TextureBase, textureIndex:Number):void
		{
			if( !texture )
			{
				_gl.activeTexture( Number(WebGLRenderingContext.TEXTURE0) + (textureIndex));
				_gl.bindTexture( Number(WebGLRenderingContext.TEXTURE_2D), null );
				return;
			}
			
			var location:WebGLUniformLocation = _gl.getUniformLocation( _currentProgram.glProgram, locationName );
            switch( textureIndex )
			{
                case 0: 
						_gl.activeTexture( Number(WebGLRenderingContext.TEXTURE0) );
					break;
                case 1:
						_gl.activeTexture( Number(WebGLRenderingContext.TEXTURE1) );
					break;
                case 2:
						_gl.activeTexture( Number(WebGLRenderingContext.TEXTURE2) );
					break;
                case 3:
						_gl.activeTexture( Number(WebGLRenderingContext.TEXTURE3) );
					break;
                case 4:
						_gl.activeTexture( Number(WebGLRenderingContext.TEXTURE4) );
					break;
                case 5:
						_gl.activeTexture( Number(WebGLRenderingContext.TEXTURE5) );
					break;
                case 6:
						_gl.activeTexture( Number(WebGLRenderingContext.TEXTURE6) );
					break;
                case 7:
						_gl.activeTexture( Number(WebGLRenderingContext.TEXTURE7) );
					break;
                default:
					throw "Texture " + textureIndex + " is out of bounds.";
            }
			
			_gl.bindTexture( Number(WebGLRenderingContext.TEXTURE_2D), texture.glTexture );
			_gl.uniform1i( location, textureIndex );
			
			var samplerState:SamplerState = _samplerStates[ textureIndex ];
			
			if( samplerState.wrap != _currentWrap )
			{
				_currentWrap = samplerState.wrap;
				_gl.texParameteri( Number(WebGLRenderingContext.TEXTURE_2D), Number(WebGLRenderingContext.TEXTURE_WRAP_S), samplerState.wrap );
				_gl.texParameteri( Number(WebGLRenderingContext.TEXTURE_2D), Number(WebGLRenderingContext.TEXTURE_WRAP_T), samplerState.wrap );
			}
			
			if( samplerState.filter != _currentFilter )
			{
				_gl.texParameteri( Number(WebGLRenderingContext.TEXTURE_2D), Number(WebGLRenderingContext.TEXTURE_MIN_FILTER), samplerState.filter );
				_gl.texParameteri( Number(WebGLRenderingContext.TEXTURE_2D), Number(WebGLRenderingContext.TEXTURE_MAG_FILTER), samplerState.filter );
			}
        }
		
		public function setSamplerStateAt(sampler:Number, wrap:String, filter:String, mipfilter:String):void
		{			
			var glWrap:Number = 0;
			var glFilter:Number = 0;
			var glMipFilter:Number = 0;
			
			switch( wrap )
			{
				case Context3DWrapMode.REPEAT:
						glWrap = Number(WebGLRenderingContext.REPEAT);
					break;
				case Context3DWrapMode.CLAMP:
						glWrap = Number(WebGLRenderingContext.CLAMP_TO_EDGE);
					break;
				default:
					throw "Wrap is not supported: " + wrap;
			}
			
			switch( filter )
			{
				case Context3DTextureFilter.LINEAR:
						glFilter = Number(WebGLRenderingContext.LINEAR);
					break;
				case Context3DTextureFilter.NEAREST:
						glFilter = Number(WebGLRenderingContext.NEAREST);
					break;
				default:
					throw "Filter is not supported " + filter;
			}
			
			switch( mipfilter )
			{
				case Context3DMipFilter.MIPNEAREST:
						glMipFilter = Number(WebGLRenderingContext.NEAREST_MIPMAP_NEAREST);
					break;
				case Context3DMipFilter.MIPLINEAR:
						glMipFilter = Number(WebGLRenderingContext.LINEAR_MIPMAP_LINEAR);
					break;
				case Context3DMipFilter.MIPNONE:
						glMipFilter = Number(WebGLRenderingContext.NONE);
					break;
				default:
					throw "MipFilter is not supported " + mipfilter;
			}
			
			if( 0 <= sampler && sampler < Context3D.MAX_SAMPLERS )
			{
				_samplerStates[ sampler ].wrap = glWrap;
				_samplerStates[ sampler ].filter = glFilter;
				_samplerStates[ sampler ].mipfilter = glMipFilter;
			}
			else
			{
				throw "Sampler is out of bounds.";
			}
		}
		
		public function setVertexBufferAt(index:Number, buffer:VertexBuffer3D, bufferOffset:Number = 0, format:String = null):void
		{
			var locationName:String = "va" + index;
			setGLSLVertexBufferAt( locationName, buffer, bufferOffset, format );
		}
		
		public function setGLSLVertexBufferAt(locationName, buffer:VertexBuffer3D, bufferOffset:Number = 0, format:String = null):void
		{
			
            //if ( buffer == null )return;
			
			var location:Number = Number(_gl.getAttribLocation(_currentProgram.glProgram, locationName));
			if( !buffer )
			{
				
                if ( location > -1 )
                {
				    _gl.disableVertexAttribArray( location );
                }
				return;
				
			}

			_gl.bindBuffer( Number(WebGLRenderingContext.ARRAY_BUFFER), buffer.glBuffer );
			
			var dimension:Number;
			var type:Number = Number(WebGLRenderingContext.FLOAT);
			var numBytes:Number = 4;
			
			switch( format )
			{
				case Context3DVertexBufferFormat.BYTES_4:
						dimension = 4;
					break;
				case Context3DVertexBufferFormat.FLOAT_1:
						dimension = 1;
					break;
				case Context3DVertexBufferFormat.FLOAT_2:
						dimension = 2;
					break;
				case Context3DVertexBufferFormat.FLOAT_3:
						dimension = 3;
					break;
				case Context3DVertexBufferFormat.FLOAT_4:
						dimension = 4;
					break;
				default:
					throw "Buffer format " + format + " is not supported.";
			}
			
			_gl.enableVertexAttribArray( location );
			_gl.vertexAttribPointer( location, dimension, type, false, buffer.data32PerVertex * numBytes, bufferOffset * numBytes );
		}
		
		private function updateBlendStatus():void 
		{
			if ( _blendEnabled ) 
			{
				_gl.enable( Number(WebGLRenderingContext.BLEND) );
				_gl.blendEquation( Number(WebGLRenderingContext.FUNC_ADD) );
				_gl.blendFunc( _blendSourceFactor, _blendDestinationFactor );
			}
			else
			{
				_gl.disable( Number(WebGLRenderingContext.BLEND) );
			}
		}
	}
}