/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package away.materials.passes
{
	import away.textures.Texture2DBase;
	import away.utils.VectorInit;
	import away.core.display3D.Context3DTextureFormat;
	import away.core.base.IRenderable;
	import away.managers.Stage3DProxy;
	import away.cameras.Camera3D;
	import away.core.geom.Matrix3D;
	import away.core.display3D.Context3D;
	import away.core.geom.Vector3D;
	import away.core.display3D.Context3DProgramType;
	import away.core.math.Matrix3DUtils;
	//import away3d.arcane;
	//import away3d.cameras.Camera3D;
	//import away3d.core.base.IRenderable;
	//import away3d.managers.Stage3DProxy;
	//import away3d.core.math.Matrix3DUtils;
	//import away3d.textures.Texture2DBase;
	
	//import flash.display3D.Context3D;
	//import flash.display3D.Context3DProgramType;
	//import flash.display3D.Context3DTextureFormat;
	//import flash.geom.Matrix3D;
	//import flash.geom.Vector3D;
	
	//use namespace arcane;
	/**	 * DistanceMapPass is a pass that writes distance values to a depth map as a 32-bit value exploded over the 4 texture channels.	 * This is used to render omnidirectional shadow maps.	 */
	public class DistanceMapPass extends MaterialPassBase
	{
		private var _fragmentData:Vector.<Number>;
		private var _vertexData:Vector.<Number>;
		private var _alphaThreshold:Number = 0;
		private var _alphaMask:Texture2DBase;

		/**		 * Creates a new DistanceMapPass object.		 */
		public function DistanceMapPass():void
		{

			super(false);

			this._fragmentData = new <Number>[1, 255.0, 65025.0, 16581375.0, 1.0/255.0, 1.0/255.0, 1.0/255.0, 0.0, 0.0, 0.0, 0, 0];
			this._vertexData = VectorInit.Num(4);
			this._vertexData[3] = 1;
			this._pNumUsedVertexConstants = 9;
		}
		
		/**		 * The minimum alpha value for which pixels should be drawn. This is used for transparency that is either		 * invisible or entirely opaque, often used with textures for foliage, etc.		 * Recommended values are 0 to disable alpha, or 0.5 to create smooth edges. Default value is 0 (disabled).		 */
		public function get alphaThreshold():Number
		{
			return this._alphaThreshold;
		}
		
		public function set alphaThreshold(value:Number):void
		{
			if (value < 0)
            {

                value = 0;

            }
			else if (value > 1)
            {


                value = 1;

            }

			if (value == this._alphaThreshold)
            {

                return;

            }

			
			if (value == 0 || this._alphaThreshold == 0)
            {

                this.iInvalidateShaderProgram();

            }

			
			this._alphaThreshold = value;
			this._fragmentData[8] = this._alphaThreshold;
		}

		/**		 * A texture providing alpha data to be able to prevent semi-transparent pixels to write to the alpha mask.		 * Usually the diffuse texture when alphaThreshold is used.		 */
		public function get alphaMask():Texture2DBase
		{
			return this._alphaMask;
		}
		
		public function set alphaMask(value:Texture2DBase):void
		{
			this._alphaMask = value;
		}
		
		/**		 * @inheritDoc		 */
		override public function iGetVertexCode():String
		{

            //TODO: AGAL<> GLSL

			var code:String;
			code = "m44 op, vt0, vc0		\n" +
				"m44 vt1, vt0, vc5		\n" +
				"sub v0, vt1, vc9		\n";
			
			if (this._alphaThreshold > 0)
            {

				code += "mov v1, va1\n";

				this._pNumUsedTextures = 1;
				this._pNumUsedStreams = 2;

			}
            else
            {

				this._pNumUsedTextures = 0;
				this._pNumUsedStreams = 1;

			}
			
			return code;
		}
		
		/**		 * @inheritDoc		 */
		override public function iGetFragmentCode(animationCode:String):String
		{
			// TODO: not used
			animationCode = animationCode;
			var code:String;
			var wrap:String = this._pRepeat? "wrap" : "clamp";
			var filter:String;
			
			if (this._pSmooth)
            {

                filter = this._pMipmap? "linear,miplinear" : "linear";

            }
			else
            {

                filter = this._pMipmap? "nearest,mipnearest" : "nearest";


            }

            //TODO: AGAL<> GLSL
			
			// squared distance to view
			code = "dp3 ft2.z, v0.xyz, v0.xyz	\n" +
				"mul ft0, fc0, ft2.z	\n" +
				"frc ft0, ft0			\n" +
				"mul ft1, ft0.yzww, fc1	\n";
			
			if (this._alphaThreshold > 0)
            {

				var format:String;

				switch (this._alphaMask.format)
                {

					case Context3DTextureFormat.COMPRESSED:

						format = "dxt1,";

						break;

					case "compressedAlpha":

						format = "dxt5,";

						break;

					default:

						format = "";

				}

				code += "tex ft3, v1, fs0 <2d," + filter + "," + format + wrap + ">\n" +
					"sub ft3.w, ft3.w, fc2.x\n" +
					"kil ft3.w\n";
			}
			
			code += "sub oc, ft0, ft1		\n";
			
			return code;
		}
		
		/**		 * @inheritDoc		 */
		override public function iRender(renderable:IRenderable, stage3DProxy:Stage3DProxy, camera:Camera3D, viewProjection:Matrix3D):void
		{
			var context:Context3D = stage3DProxy._iContext3D;
			var pos:Vector3D = camera.scenePosition;
			
			this._vertexData[0] = pos.x;
            this._vertexData[1] = pos.y;
            this._vertexData[2] = pos.z;
            this._vertexData[3] = 1;
			
			var sceneTransform:Matrix3D = renderable.getRenderSceneTransform(camera);
			
			context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 5, sceneTransform, true);

			context.setProgramConstantsFromArray(Context3DProgramType.VERTEX, 9, this._vertexData, 1);
			
			if (this._alphaThreshold > 0)
            {

                renderable.activateUVBuffer(1, stage3DProxy);

            }

			
			var matrix:Matrix3D = Matrix3DUtils.CALCULATION_MATRIX;

			matrix.copyFrom(sceneTransform);
			matrix.append(viewProjection);

			context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, matrix, true);
			renderable.activateVertexBuffer(0, stage3DProxy);
			context.drawTriangles(renderable.getIndexBuffer(stage3DProxy), 0, renderable.numTriangles);
		}
		
		/**		 * @inheritDoc		 */
		override public function iActivate(stage3DProxy:Stage3DProxy, camera:Camera3D):void
		{
			var context:Context3D = stage3DProxy._iContext3D;
			super.iActivate(stage3DProxy, camera);
			
			var f:Number = camera.lens.far;
			
			f = 1/(2*f*f);
			// sqrt(f*f+f*f) is largest possible distance for any frustum, so we need to divide by it. Rarely a tight fit, but with 32 bits precision, it's enough.
			this._fragmentData[0] = 1*f;
            this._fragmentData[1] = 255.0*f;
            this._fragmentData[2] = 65025.0*f;
            this._fragmentData[3] = 16581375.0*f;
			
			if (this._alphaThreshold > 0)
            {

                context.setTextureAt(0, this._alphaMask.getTextureForStage3D(stage3DProxy));
				context.setProgramConstantsFromArray(Context3DProgramType.FRAGMENT, 0, this._fragmentData, 3);

			}
            else
            {

                context.setProgramConstantsFromArray(Context3DProgramType.FRAGMENT, 0, this._fragmentData, 2);
            }

		}
	}
}
