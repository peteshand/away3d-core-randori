/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package away.materials.passes
{
	import away.textures.CubeTextureBase;
	import away.core.display3D.Context3DTextureFormat;
	import away.core.base.IRenderable;
	import away.managers.Stage3DProxy;
	import away.cameras.Camera3D;
	import away.core.geom.Matrix3D;
	import away.core.display3D.Context3D;
	import away.core.geom.Vector3D;
	import away.core.display3D.Context3DProgramType;
	import away.core.display3D.Context3DCompareMode;

	/**	 * SkyBoxPass provides a material pass exclusively used to render sky boxes from a cube texture.	 */
	public class SkyBoxPass extends MaterialPassBase
	{
		private var _cubeTexture:CubeTextureBase;
		private var _vertexData:Vector.<Number>;
		
		/**		 * Creates a new SkyBoxPass object.		 */
		public function SkyBoxPass():void
		{
			super(false);
			this.mipmap = false;
			this._pNumUsedTextures = 1;
            this._vertexData = new <Number>[ 0, 0, 0, 0, 1, 1, 1, 1 ];
		}
		
		/**		 * The cube texture to use as the skybox.		 */
		public function get cubeTexture():CubeTextureBase
		{
			return this._cubeTexture;
		}
		
		public function set cubeTexture(value:CubeTextureBase):void
		{
			this._cubeTexture = value;
		}
		
		/**		 * @inheritDoc		 */
		override public function iGetVertexCode():String
		{
			return "mul vt0, va0, vc5		\n" +
				"add vt0, vt0, vc4		\n" +
				"m44 op, vt0, vc0		\n" +
				"mov v0, va0\n";
		}
		
		/**		 * @inheritDoc		 */
		override public function iGetFragmentCode(animationCode:String):String
		{
			var format:String;
			switch (this._cubeTexture.format) {
				case Context3DTextureFormat.COMPRESSED:
					format = "dxt1,";
					break;
				case "compressedAlpha":
					format = "dxt5,";
					break;
				default:
					format = "";
			}

			var mip:String = ",mipnone";

			if (this._cubeTexture.hasMipMaps)
            {
				mip = ",miplinear";
            }
			return "tex ft0, v0, fs0 <cube," + format + "linear,clamp" + mip + ">	\n" +
				"mov oc, ft0							\n";
		}

		/**		 * @inheritDoc		 */
		override public function iRender(renderable:IRenderable, stage3DProxy:Stage3DProxy, camera:Camera3D, viewProjection:Matrix3D):void
		{
			var context:Context3D = stage3DProxy._iContext3D;
			var pos:Vector3D = camera.scenePosition;
			this._vertexData[0] = pos.x;
            this._vertexData[1] = pos.y;
            this._vertexData[2] = pos.z;
            this._vertexData[4] = camera.lens.far/Math.sqrt(3);
            this._vertexData[5] = camera.lens.far/Math.sqrt(3);
            this._vertexData[6] = camera.lens.far/Math.sqrt(3);

			context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, viewProjection, true);
			context.setProgramConstantsFromArray(Context3DProgramType.VERTEX, 4, this._vertexData, 2);
			renderable.activateVertexBuffer(0, stage3DProxy);
			context.drawTriangles(renderable.getIndexBuffer(stage3DProxy), 0, renderable.numTriangles);
		}
		
		/**		 * @inheritDoc		 */
		override public function iActivate(stage3DProxy:Stage3DProxy, camera:Camera3D):void
		{
			super.iActivate(stage3DProxy, camera);
			var context:Context3D = stage3DProxy._iContext3D;
			context.setDepthTest(false, Context3DCompareMode.LESS);
			context.setTextureAt(0, this._cubeTexture.getTextureForStage3D(stage3DProxy));
		}
	}
}
