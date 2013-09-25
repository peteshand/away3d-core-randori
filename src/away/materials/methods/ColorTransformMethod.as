/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package away.materials.methods
{
	import away.geom.ColorTransform;
	import away.materials.compilation.ShaderRegisterCache;
	import away.materials.compilation.ShaderRegisterElement;
	import away.managers.Stage3DProxy;
	//import away3d.arcane;
	//import away3d.managers.Stage3DProxy;
	//import away3d.materials.compilation.ShaderRegisterCache;
	//import away3d.materials.compilation.ShaderRegisterElement;
	
	//import flash.geom.ColorTransform;
	
	//use namespace arcane;
	
	/**	 * ColorTransformMethod provides a shading method that changes the colour of a material analogous to a	 * ColorTransform object.	 */
	public class ColorTransformMethod extends EffectMethodBase
	{
		private var _colorTransform:ColorTransform;
		
		/**		 * Creates a new ColorTransformMethod.		 */
		public function ColorTransformMethod():void
		{
			super();
		}
		
		/**		 * The ColorTransform object to transform the colour of the material with.		 */
		public function get colorTransform():ColorTransform
		{
			return this._colorTransform;
		}
		
		public function set colorTransform(value:ColorTransform):void
		{
            this._colorTransform = value;
		}
		
		/**		 * @inheritDoc		 */
		override public function iGetFragmentCode(vo:MethodVO, regCache:ShaderRegisterCache, targetReg:ShaderRegisterElement):String
		{
			var code:String = "";
			var colorMultReg:ShaderRegisterElement = regCache.getFreeFragmentConstant();
			var colorOffsReg:ShaderRegisterElement = regCache.getFreeFragmentConstant();

			vo.fragmentConstantsIndex = colorMultReg.index*4;

            //TODO: AGAL <> GLSL

			code += "mul " + targetReg.toString() + ", " + targetReg.toString() + ", " + colorMultReg.toString() + "\n" +
				"add " + targetReg.toString() + ", " + targetReg.toString() + ", " + colorOffsReg.toString() + "\n";

			return code;
		}
		
		/**		 * @inheritDoc		 */
		override public function iActivate(vo:MethodVO, stage3DProxy:Stage3DProxy):void
		{
			var inv:Number = 1/0xff;
			var index:Number = vo.fragmentConstantsIndex;
			var data:Vector.<Number> = vo.fragmentData;

			data[index] = this._colorTransform.redMultiplier;
			data[index + 1] = this._colorTransform.greenMultiplier;
			data[index + 2] = this._colorTransform.blueMultiplier;
			data[index + 3] = this._colorTransform.alphaMultiplier;
			data[index + 4] = this._colorTransform.redOffset*inv;
			data[index + 5] = this._colorTransform.greenOffset*inv;
			data[index + 6] = this._colorTransform.blueOffset*inv;
			data[index + 7] = this._colorTransform.alphaOffset*inv;

		}
	}
}
