/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package away.materials.methods
{
	import away.textures.Texture2DBase;
	import away.materials.compilation.ShaderRegisterElement;
	import away.managers.Stage3DProxy;
	import away.materials.compilation.ShaderRegisterCache;

	/**	 * SimpleWaterNormalMethod provides a basic normal map method to create water ripples by translating two wave normal maps.	 */
	public class SimpleWaterNormalMethod extends BasicNormalMethod
	{
		private var _texture2:Texture2DBase;
		private var _normalTextureRegister2:ShaderRegisterElement;
		private var _useSecondNormalMap:Boolean = false;
		private var _water1OffsetX:Number = 0;
		private var _water1OffsetY:Number = 0;
		private var _water2OffsetX:Number = 0;
		private var _water2OffsetY:Number = 0;

		/**		 * Creates a new SimpleWaterNormalMethod object.		 * @param waveMap1 A normal map containing one layer of a wave structure.		 * @param waveMap2 A normal map containing a second layer of a wave structure.		 */
		public function SimpleWaterNormalMethod(waveMap1:Texture2DBase, waveMap2:Texture2DBase):void
		{
			super();
			this.normalMap = waveMap1;
            this.secondaryNormalMap = waveMap2;
		}

		/**		 * @inheritDoc		 */
		override public function iInitConstants(vo:MethodVO):void
		{
			var index:Number = vo.fragmentConstantsIndex;
			vo.fragmentData[index] = .5;
			vo.fragmentData[index + 1] = 0;
			vo.fragmentData[index + 2] = 0;
			vo.fragmentData[index + 3] = 1;
		}

		/**		 * @inheritDoc		 */
		override public function iInitVO(vo:MethodVO):void
		{
			super.iInitVO(vo);
			
			this._useSecondNormalMap = this.normalMap != this.secondaryNormalMap;
		}

		/**		 * The translation of the first wave layer along the X-axis.		 */
		public function get water1OffsetX():Number
		{
			return this._water1OffsetX;
		}
		
		public function set water1OffsetX(value:Number):void
		{
			this._water1OffsetX = value;
		}

		/**		 * The translation of the first wave layer along the Y-axis.		 */
		public function get water1OffsetY():Number
		{
			return this._water1OffsetY;
		}
		
		public function set water1OffsetY(value:Number):void
		{
			this._water1OffsetY = value;
		}

		/**		 * The translation of the second wave layer along the X-axis.		 */
		public function get water2OffsetX():Number
		{
			return this._water2OffsetX;
		}
		
		public function set water2OffsetX(value:Number):void
		{
			this._water2OffsetX = value;
		}

		/**		 * The translation of the second wave layer along the Y-axis.		 */
		public function get water2OffsetY():Number
		{
			return this._water2OffsetY;
		}
		
		public function set water2OffsetY(value:Number):void
		{
			this._water2OffsetY = value;
		}

		/**		 * @inheritDoc		 */
		override public function set normalMap(value:Texture2DBase):void
		{
			if (!value)
            {
				return;
            }
			this.setNormalMap( value );
		}

		/**		 * A second normal map that will be combined with the first to create a wave-like animation pattern.		 */
		public function get secondaryNormalMap():Texture2DBase
		{
			return this._texture2;
		}
		
		public function set secondaryNormalMap(value:Texture2DBase):void
		{
            this._texture2 = value;
		}

		/**		 * @inheritDoc		 */
		override public function iCleanCompilationData():void
		{
			super.iCleanCompilationData();
			this._normalTextureRegister2 = null;
		}

		/**		 * @inheritDoc		 */
		override public function dispose():void
		{
			super.dispose();
			this._texture2 = null;
		}

		/**		 * @inheritDoc		 */
		override public function iActivate(vo:MethodVO, stage3DProxy:Stage3DProxy):void
		{
			super.iActivate(vo, stage3DProxy);
			
			var data:Vector.<Number> = vo.fragmentData;
			var index:Number = vo.fragmentConstantsIndex;
			
			data[index + 4] = this._water1OffsetX;
			data[index + 5] = this._water1OffsetY;
			data[index + 6] = this._water2OffsetX;
			data[index + 7] = this._water2OffsetY;
			
			//if (this._useSecondNormalMap >= 0)
            if (this._useSecondNormalMap )
				stage3DProxy._iContext3D.setTextureAt(vo.texturesIndex + 1, this._texture2.getTextureForStage3D(stage3DProxy));
		}

		/**		 * @inheritDoc		 */
		public function getFragmentCode(vo:MethodVO, regCache:ShaderRegisterCache, targetReg:ShaderRegisterElement):String
		{
			var temp:ShaderRegisterElement = regCache.getFreeFragmentVectorTemp();
			var dataReg:ShaderRegisterElement = regCache.getFreeFragmentConstant();
			var dataReg2:ShaderRegisterElement = regCache.getFreeFragmentConstant();
			this._pNormalTextureRegister = regCache.getFreeTextureReg();
            this._normalTextureRegister2 = this._useSecondNormalMap? regCache.getFreeTextureReg() : this._pNormalTextureRegister;
			vo.texturesIndex = this._pNormalTextureRegister.index;
			
			vo.fragmentConstantsIndex = dataReg.index*4;
			return "add " + temp + ", " + this._sharedRegisters.uvVarying + ", " + dataReg2 + ".xyxy\n" +
				this.pGetTex2DSampleCode(vo, targetReg, this._pNormalTextureRegister, this.normalMap, temp) +
				"add " + temp + ", " + this._sharedRegisters.uvVarying + ", " + dataReg2 + ".zwzw\n" +
				this.pGetTex2DSampleCode(vo, temp, this._normalTextureRegister2, this._texture2, temp) +
				"add " + targetReg + ", " + targetReg + ", " + temp + "		\n" +
				"mul " + targetReg + ", " + targetReg + ", " + dataReg + ".x	\n" +
				"sub " + targetReg + ".xyz, " + targetReg + ".xyz, " + this._sharedRegisters.commons + ".xxx	\n" +
				"nrm " + targetReg + ".xyz, " + targetReg + ".xyz							\n";
		
		}
	}
}
