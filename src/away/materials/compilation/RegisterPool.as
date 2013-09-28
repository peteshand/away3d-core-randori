/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package away.materials.compilation
{
	import away.utils.VectorInit;
	//import flash.utils.Dictionary;
	
	/**	 * RegisterPool is used by the shader compilation process to keep track of which registers of a certain type are	 * currently used and should not be allowed to be written to. Either entire registers can be requested and locked,	 * or single components (x, y, z, w) of a single register.	 * It is used by ShaderRegisterCache to track usages of individual register types.	 *	 * @see away3d.materials.compilation.ShaderRegisterCache	 */
	public class RegisterPool
	{
		private static var _regPool:Object = new Object();//= new Dictionary()
		private static var _regCompsPool:Object = new Object();//new Dictionary()
		
		private var _vectorRegisters:Vector.<ShaderRegisterElement>;//Vector.<ShaderRegisterElement>
		private var _registerComponents;
		
		private var _regName:String = null;
		private var _usedSingleCount:Vector.<Vector.<Number>>;//Vector.<Vector.<uint>>
		private var _usedVectorCount:Vector.<Number>;/*uint*/
		private var _regCount:Number = 0;
		
		private var _persistent:Boolean = false;
		
		/**		 * Creates a new RegisterPool object.		 * @param regName The base name of the register type ("ft" for fragment temporaries, "vc" for vertex constants, etc)		 * @param regCount The amount of available registers of this type.		 * @param persistent Whether or not registers, once reserved, can be freed again. For example, temporaries are not persistent, but constants are.		 */
		public function RegisterPool(regName:String, regCount:Number, persistent:Boolean = true):void
		{
			persistent = persistent || true;

			this._regName = regName;
            this._regCount = regCount;
            this._persistent = persistent;
            this.initRegisters(regName, regCount);
		}
		
		/**		 * Retrieve an entire vector register that's still available.		 */
		public function requestFreeVectorReg():ShaderRegisterElement
		{
			for (var i:Number = 0; i < this._regCount; ++i)
            {

				if (!this.isRegisterUsed(i))
                {
					if (this._persistent)
						this._usedVectorCount[i]++;

					return this._vectorRegisters[i];

				}
			}
			
			throw new Error("Register overflow!");
		}
		
		/**		 * Retrieve a single vector component that's still available.		 */
		public function requestFreeRegComponent():ShaderRegisterElement
		{

            //away.Debug.log( 'RegisterPool' , 'requestFreeRegComponent' , this._regCount);

			for (var i:Number = 0; i < this._regCount; ++i)
            {

                //away.Debug.log( 'RegisterPool' , 'requestFreeRegComponent' , this._regCount , 'this._usedVectorCount:' + this._usedVectorCount[i] );

				if (this._usedVectorCount[i] > 0)
					continue;

				for (var j:Number = 0; j < 4; ++j)
                {

					if (this._usedSingleCount[j][i] == 0)
                    {

						if (this._persistent)
                        {

                            this._usedSingleCount[j][i]++;

                        }

						return this._registerComponents[j][i];

					}
				}
			}
			
			throw new Error("Register overflow!");
		}
		
		/**		 * Marks a register as used, so it cannot be retrieved. The register won't be able to be used until removeUsage		 * has been called usageCount times again.		 * @param register The register to mark as used.		 * @param usageCount The amount of usages to add.		 */
		public function addUsage(register:ShaderRegisterElement, usageCount:Number):void
		{
			if (register._component > -1)
            {

                this._usedSingleCount[register._component][register.index] += usageCount;

            }
			else
            {

                this._usedVectorCount[register.index] += usageCount;

            }

		}
		
		/**		 * Removes a usage from a register. When usages reach 0, the register is freed again.		 * @param register The register for which to remove a usage.		 */
		public function removeUsage(register:ShaderRegisterElement):void
		{
			if (register._component > -1)
            {

				if (--this._usedSingleCount[register._component][register.index] < 0)
                {

                    throw new Error("More usages removed than exist!");

                }


			}
            else
            {
				if (--this._usedVectorCount[register.index] < 0)
                {

                    throw new Error("More usages removed than exist!");

                }

			}
		}

		/**		 * Disposes any resources used by the current RegisterPool object.		 */
		public function dispose():void
		{
			this._vectorRegisters = null;
            this._registerComponents = null;
            this._usedSingleCount = null;
            this._usedVectorCount = null;
		}
		
		/**		 * Indicates whether or not any registers are in use.		 */
		public function hasRegisteredRegs():Boolean
		{
			for (var i:Number = 0; i < this._regCount; ++i)
            {

				if (this.isRegisterUsed(i))
					return true;

			}
			
			return false;
		}
		
		/**		 * Initializes all registers.		 */
		private function initRegisters(regName:String, regCount:Number):void
		{
			
			var hash:String = RegisterPool._initPool(regName, regCount);
			
			this._vectorRegisters = RegisterPool._regPool[hash];
			this._registerComponents = RegisterPool._regCompsPool[hash];
			
			this._usedVectorCount = Vector.<Number>(regCount);

            this._usedSingleCount = VectorInit.VecNum(4);
			this._usedSingleCount[0] = VectorInit.Num(regCount );
            this._usedSingleCount[1] = VectorInit.Num(regCount );
            this._usedSingleCount[2] = VectorInit.Num(regCount );
            this._usedSingleCount[3] = VectorInit.Num(regCount );

            //console.log( 'this._usedVectorCount: ' , this._usedVectorCount );
            //console.log( 'this._usedSingleCount: ' , this._usedSingleCount );

		}
		
		private static function _initPool(regName:String, regCount:Number):String
		{
			var hash:String = regName + regCount;
			
			if (RegisterPool._regPool[hash] != undefined)
            {

                return hash;

            }

			var vectorRegisters:Vector.<ShaderRegisterElement> = VectorInit.AnyClass(ShaderRegisterElement, regCount);///Vector.<ShaderRegisterElement> = new Vector.<ShaderRegisterElement>(regCount, true);
            RegisterPool._regPool[hash] = vectorRegisters;
			
			var registerComponents = [
				[],
				[],
				[],
				[]
				];
            RegisterPool._regCompsPool[hash] = registerComponents;
			
			for (var i:Number = 0; i < regCount; ++i)
            {

				vectorRegisters[i] = new ShaderRegisterElement(regName, i);
				
				for (var j:Number = 0; j < 4; ++j)
                {

                    registerComponents[j][i] = new ShaderRegisterElement(regName, i, j);

                }

			}

            //console.log ( 'RegisterPool._regCompsPool[hash] : ' , RegisterPool._regCompsPool[hash]  );
            //console.log ( 'RegisterPool._regPool[hash] : ' , RegisterPool._regPool[hash]  );

			return hash;
		}


		/**		 * Check if the temp register is either used for single or vector use		 */
		private function isRegisterUsed(index:Number):Boolean
		{
			if (this._usedVectorCount[index] > 0)
            {

                return true;

            }

			for (var i:Number = 0; i < 4; ++i)
            {

				if (this._usedSingleCount[i][index] > 0)
                {

                    return true;

                }

			}
			
			return false;
		}
	}
}
