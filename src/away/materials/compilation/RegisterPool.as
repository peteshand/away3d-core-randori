///<reference path="../../_definitions.ts"/>

package away.materials.compilation
{
	//import flash.utils.Dictionary;
	
	/**
	public class RegisterPool
	{
		private static var _regPool:Object = new Object();//= new Dictionary();
		private var _vectorRegisters:Vector.<ShaderRegisterElement>;//Vector.<ShaderRegisterElement>;
		
		private var _regName:String;
		private var _usedSingleCount:Vector.<Vector.<Number>>;//Vector.<Vector.<uint>>;
		private var _regCount:Number;
		
		private var _persistent:Boolean;
		
		/**
		public function RegisterPool(regName:String, regCount:Number, persistent:Boolean = true):void
		{
			this._regName = regName;
            this._regCount = regCount;
            this._persistent = persistent;
            this.initRegisters(regName, regCount);
		}
		
		/**
		public function requestFreeVectorReg():ShaderRegisterElement
		{
			for (var i:Number = 0; i < _regCount; ++i)
            {

				if (!isRegisterUsed(i))
                {
					if (_persistent)
						_usedVectorCount[i]++;

					return _vectorRegisters[i];

				}
			}
			
			throw new Error("Register overflow!");
		}
		
		/**
		public function requestFreeRegComponent():ShaderRegisterElement
		{

            //away.Debug.log( 'RegisterPool' , 'requestFreeRegComponent' , this._regCount);

			for (var i:Number = 0; i < _regCount; ++i)
            {

                //away.Debug.log( 'RegisterPool' , 'requestFreeRegComponent' , this._regCount , 'this._usedVectorCount:' + this._usedVectorCount[i] );

				if (_usedVectorCount[i] > 0)
					continue;

				for (var j:Number = 0; j < 4; ++j)
                {

					if (_usedSingleCount[j][i] == 0)
                    {

						if (_persistent)
                        {

                            _usedSingleCount[j][i]++;

                        }

						return _registerComponents[j][i];

					}
				}
			}
			
			throw new Error("Register overflow!");
		}
		
		/**
		public function addUsage(register:ShaderRegisterElement, usageCount:Number):void
		{
			if (register._component > -1)
            {

                _usedSingleCount[register._component][register.index] += usageCount;

            }
			else
            {

                _usedVectorCount[register.index] += usageCount;

            }

		}
		
		/**
		public function removeUsage(register:ShaderRegisterElement):void
		{
			if (register._component > -1)
            {

				if (--_usedSingleCount[register._component][register.index] < 0)
                {

                    throw new Error("More usages removed than exist!");

                }


			}
            else
            {
				if (--_usedVectorCount[register.index] < 0)
                {

                    throw new Error("More usages removed than exist!");

                }

			}
		}

		/**
		public function dispose():void
		{
			_vectorRegisters = null;
            _registerComponents = null;
            _usedSingleCount = null;
            _usedVectorCount = null;
		}
		
		/**
		public function hasRegisteredRegs():Boolean
		{
			for (var i:Number = 0; i < _regCount; ++i)
            {

				if (isRegisterUsed(i))
					return true;

			}
			
			return false;
		}
		
		/**
		private function initRegisters(regName:String, regCount:Number):void
		{
			
			var hash:String = RegisterPool._initPool(regName, regCount);
			
			_vectorRegisters = RegisterPool._regPool[hash];
			_registerComponents = RegisterPool._regCompsPool[hash];
			
			_usedVectorCount = _initArray( Vector.<Number>(regCount) , 0 ) ;//new Vector.<uint>(regCount, true);

            _usedSingleCount = new Vector.<Vector.<Number>>( 4 ); //this._usedSingleCount = new Vector.<Vector.<uint>>(4, true);
			_usedSingleCount[0] = _initArray( new Vector.<Number>(regCount ) , 0 );//new Array<number>(regCount ) ;//, true);
            _usedSingleCount[1] = _initArray( new Vector.<Number>(regCount ) , 0 );//new Array<number>(regCount ) ;//new Vector.<uint>(regCount, true);
            _usedSingleCount[2] = _initArray( new Vector.<Number>(regCount ) , 0 );//new Array<number>(regCount ) ;//new Vector.<uint>(regCount, true);
            _usedSingleCount[3] = _initArray( new Vector.<Number>(regCount ) , 0 );//new Array<number>(regCount ) ;//new Vector.<uint>(regCount, true);

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

			var vectorRegisters:Vector.<ShaderRegisterElement> = new Vector.<ShaderRegisterElement>(regCount);///Vector.<ShaderRegisterElement> = new Vector.<ShaderRegisterElement>(regCount, true);
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


		/**
		private function isRegisterUsed(index:Number):Boolean
		{
			if (_usedVectorCount[index] > 0)
            {

                return true;

            }

			for (var i:Number = 0; i < 4; ++i)
            {

				if (_usedSingleCount[i][index] > 0)
                {

                    return true;

                }

			}
			
			return false;
		}


        private function _initArray(a:Vector.<Number>, val:*):Vector.<Number>
        {

            var l : Number = a.length;

            for ( var c : Number = 0 ; c < l ; c ++ )
            {

                a[c] = val;

            }

            return a;

        }

	}

}