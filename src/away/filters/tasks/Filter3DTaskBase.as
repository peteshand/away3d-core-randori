
///<reference path="../../_definitions.ts"/>

package away.filters.tasks
{
	import away.display3D.Texture;
	import away.display3D.Program3D;
	import away.managers.Stage3DProxy;
	import aglsl.AGLSLCompiler;
	import away.display3D.Context3DProgramType;
	import away.errors.AbstractMethodError;
	import away.display3D.Context3DTextureFormat;
	import away.cameras.Camera3D;

	public class Filter3DTaskBase
	{
		private var _mainInputTexture:Texture;
		
		private var _scaledTextureWidth:Number = -1;
		private var _scaledTextureHeight:Number = -1;
		private var _textureWidth:Number = -1;
		private var _textureHeight:Number = -1;
		private var _textureDimensionsInvalid:Boolean = true;
		private var _program3DInvalid:Boolean = true;
		private var _program3D:Program3D;
		private var _target:Texture;
		private var _requireDepthRender:Boolean;
		private var _textureScale:Number = 0;
		
		public function Filter3DTaskBase(requireDepthRender:Boolean = false):void
		{

			this._requireDepthRender = requireDepthRender;

		}
		
		/**		 * The texture scale for the input of this texture. This will define the output of the previous entry in the chain		 */
		public function get textureScale():Number
		{

			return _textureScale;

		}
		
		public function set textureScale(value:Number):void
		{

			if (this._textureScale == value)
            {

                return;

            }

			this._textureScale = value;
            this._scaledTextureWidth = this._textureWidth >> this._textureScale;
            this._scaledTextureHeight = this._textureHeight >> this._textureScale;
            this._textureDimensionsInvalid = true;

		}
		
		public function get target():Texture
		{

			return _target;

		}
		
		public function set target(value:Texture):void
		{

			this._target = value;

		}
		
		public function get textureWidth():Number
		{

			return _textureWidth;

		}
		
		public function set textureWidth(value:Number):void
		{

			if (this._textureWidth == value)
            {

                return;

            }

			this._textureWidth = value;
            this._scaledTextureWidth = this._textureWidth >> this._textureScale;
            this._textureDimensionsInvalid = true;

		}
		
		public function get textureHeight():Number
		{

			return _textureHeight;

		}
		
		public function set textureHeight(value:Number):void
		{

			if (this._textureHeight == value)
            {

                return;

            }

            this._textureHeight = value;
            this._scaledTextureHeight = this._textureHeight >> this._textureScale;
            this._textureDimensionsInvalid = true;

		}
		
		public function getMainInputTexture(stage:Stage3DProxy):Texture
		{

			if (_textureDimensionsInvalid)
            {

                pUpdateTextures(stage);

            }

			
			return _mainInputTexture;

		}
		
		public function dispose():void
		{

			if (_mainInputTexture)
            {

                _mainInputTexture.dispose();

            }

			if (_program3D)
            {

                _program3D.dispose();

            }

		}
		
		public function pInvalidateProgram3D():void
		{
			_program3DInvalid = true;
		}
		
		public function pUpdateProgram3D(stage:Stage3DProxy):void
		{
			if (_program3D)
            {

                _program3D.dispose();

            }

			_program3D = stage._iContext3D.createProgram();

            //away.Debug.log( 'Filder3DTaskBase' , 'pUpdateProgram3D' , 'Program3D.upload / AGAL <> GLSL implementation' );

            // TODO: imeplement AGAL <> GLSL
            //this._program3D.upload(new AGALMiniAssembler(Debug.active).assemble(Context3DProgramType.VERTEX, getVertexCode()),new AGALMiniAssembler(Debug.active).assemble(Context3DProgramType.FRAGMENT, getFragmentCode()));

            //new AGALMiniAssembler(Debug.active).assemble(Context3DProgramType.VERTEX, getVertexCode()),
            //new AGALMiniAssembler(Debug.active).assemble(Context3DProgramType.FRAGMENT, getFragmentCode()));

            var vertCompiler:AGLSLCompiler = new AGLSLCompiler();
            var fragCompiler:AGLSLCompiler = new AGLSLCompiler();

            var vertString : String = vertCompiler.compile( Context3DProgramType.VERTEX, pGetVertexCode() );
            var fragString : String = fragCompiler.compile( Context3DProgramType.FRAGMENT, pGetFragmentCode() );

            _program3D.upload( vertString , fragString );
            _program3DInvalid = false;
		}
		
		public function pGetVertexCode():String
		{

            // TODO: imeplement AGAL <> GLSL

			return "mov op, va0\n" + "mov v0, va1\n";

		}
		
		public function pGetFragmentCode():String
		{

			throw new AbstractMethodError();

			return null;

		}
		
		public function pUpdateTextures(stage:Stage3DProxy):void
		{

			if (_mainInputTexture)
            {

                _mainInputTexture.dispose();

            }

			
			_mainInputTexture = stage._iContext3D.createTexture(_scaledTextureWidth, _scaledTextureHeight, Context3DTextureFormat.BGRA, true);
			
			_textureDimensionsInvalid = false;

		}
		
		public function getProgram3D(stage3DProxy:Stage3DProxy):Program3D
		{
			if (_program3DInvalid)
            {

                pUpdateProgram3D( stage3DProxy );

            }

			return _program3D;
		}
		
		public function activate(stage3DProxy:Stage3DProxy, camera:Camera3D, depthTexture:Texture):void
		{
		}
		
		public function deactivate(stage3DProxy:Stage3DProxy):void
		{
		}
		
		public function get requireDepthRender():Boolean
		{
			return _requireDepthRender;
		}

	}
}
