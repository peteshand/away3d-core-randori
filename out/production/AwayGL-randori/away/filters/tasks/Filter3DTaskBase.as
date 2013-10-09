/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package away.filters.tasks
{
	import away.core.display3D.Texture;
	import away.core.display3D.Program3D;
	import away.managers.Stage3DProxy;
	import aglsl.AGLSLCompiler;
	import away.core.display3D.Context3DProgramType;
	import away.errors.AbstractMethodError;
	import away.core.display3D.Context3DTextureFormat;
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
		private var _requireDepthRender:Boolean = false;
		private var _textureScale:Number = 0;
		
		public function Filter3DTaskBase(requireDepthRender:Boolean = false):void
		{

			this._requireDepthRender = requireDepthRender;

		}
		
		/**		 * The texture scale for the input of this texture. This will define the output of the previous entry in the chain		 */
		public function get textureScale():Number
		{

			return this._textureScale;

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

			return this._target;

		}
		
		public function set target(value:Texture):void
		{

			this._target = value;

		}
		
		public function get textureWidth():Number
		{

			return this._textureWidth;

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

			return this._textureHeight;

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

			if (this._textureDimensionsInvalid)
            {

                this.pUpdateTextures(stage);

            }

			
			return this._mainInputTexture;

		}
		
		public function dispose():void
		{

			if (this._mainInputTexture)
            {

                this._mainInputTexture.dispose();

            }

			if (this._program3D)
            {

                this._program3D.dispose();

            }

		}
		
		public function pInvalidateProgram3D():void
		{
			this._program3DInvalid = true;
		}
		
		public function pUpdateProgram3D(stage:Stage3DProxy):void
		{
			if (this._program3D)
            {

                this._program3D.dispose();

            }

			this._program3D = stage._iContext3D.createProgram();

            //away.Debug.log( 'Filder3DTaskBase' , 'pUpdateProgram3D' , 'Program3D.upload / AGAL <> GLSL implementation' );

            // TODO: imeplement AGAL <> GLSL
            //this._program3D.upload(new AGALMiniAssembler(Debug.active).assemble(Context3DProgramType.VERTEX, getVertexCode()),new AGALMiniAssembler(Debug.active).assemble(Context3DProgramType.FRAGMENT, getFragmentCode()));

            //new AGALMiniAssembler(Debug.active).assemble(Context3DProgramType.VERTEX, getVertexCode()),
            //new AGALMiniAssembler(Debug.active).assemble(Context3DProgramType.FRAGMENT, getFragmentCode()));

            var vertCompiler:AGLSLCompiler = new AGLSLCompiler();
            var fragCompiler:AGLSLCompiler = new AGLSLCompiler();

            var vertString : String = vertCompiler.compile( Context3DProgramType.VERTEX, this.pGetVertexCode() );
            var fragString : String = fragCompiler.compile( Context3DProgramType.FRAGMENT, this.pGetFragmentCode() );

            this._program3D.upload( vertString , fragString );
            this._program3DInvalid = false;
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

			if (this._mainInputTexture)
            {

                this._mainInputTexture.dispose();

            }

			
			this._mainInputTexture = stage._iContext3D.createTexture(this._scaledTextureWidth, this._scaledTextureHeight, Context3DTextureFormat.BGRA, true);
			
			this._textureDimensionsInvalid = false;

		}
		
		public function getProgram3D(stage3DProxy:Stage3DProxy):Program3D
		{
			if (this._program3DInvalid)
            {

                this.pUpdateProgram3D( stage3DProxy );

            }

			return this._program3D;
		}
		
		public function activate(stage3DProxy:Stage3DProxy, camera:Camera3D, depthTexture:Texture):void
		{
		}
		
		public function deactivate(stage3DProxy:Stage3DProxy):void
		{
		}
		
		public function get requireDepthRender():Boolean
		{
			return this._requireDepthRender;
		}

	}
}
