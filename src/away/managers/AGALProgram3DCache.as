///<reference path="../_definitions.ts"/>

package away.managers
{
	import away.events.Stage3DEvent;
	import away.materials.passes.MaterialPassBase;
	import away.display3D.Program3D;
	import aglsl.AGLSLCompiler;
	import away.display3D.Context3DProgramType;
	import randori.webkit.page.Window;

	public class AGALProgram3DCache
	{
		private static var _instances:Vector.<AGALProgram3DCache>;
		
		private var _stage3DProxy:Stage3DProxy;

        private var _program3Ds:Object;
        private var _ids:Object;
        private var _usages:Object;
        private var _keys:Object;
		
		private static var _currentId:Number = 0;
		
		public function AGALProgram3DCache(stage3DProxy:Stage3DProxy, agalProgram3DCacheSingletonEnforcer:AGALProgram3DCacheSingletonEnforcer):void
		{
			if (!agalProgram3DCacheSingletonEnforcer)
            {
				throw new Error("This class is a multiton and cannot be instantiated manually. Use Stage3DManager.getInstance instead.");
            }

			_stage3DProxy = stage3DProxy;

            _program3Ds = new Object();
            _ids = new Object();
            _usages = new Object();
            _keys = new Object();

		}
		
		public static function getInstance(stage3DProxy:Stage3DProxy):AGALProgram3DCache
		{
			var index:Number = stage3DProxy._iStage3DIndex;

            if ( AGALProgram3DCache._instances == null )
            {

                AGALProgram3DCache._instances = new Vector.<AGALProgram3DCache>( 8 );

            }

			
			if ( ! AGALProgram3DCache._instances[index])
            {

                AGALProgram3DCache._instances[index] = new AGALProgram3DCache(stage3DProxy, new AGALProgram3DCacheSingletonEnforcer());

				stage3DProxy.addEventListener(Stage3DEvent.CONTEXT3D_DISPOSED, AGALProgram3DCache.onContext3DDisposed, AGALProgram3DCache );
				stage3DProxy.addEventListener(Stage3DEvent.CONTEXT3D_CREATED, AGALProgram3DCache.onContext3DDisposed, AGALProgram3DCache );
				stage3DProxy.addEventListener(Stage3DEvent.CONTEXT3D_RECREATED, AGALProgram3DCache.onContext3DDisposed, AGALProgram3DCache );
			}
			
			return AGALProgram3DCache._instances[index];

		}
		
		public static function getInstanceFromIndex(index:Number):AGALProgram3DCache
		{
			if (!AGALProgram3DCache._instances[index])
            {
				throw new Error("Instance not created yet!");
            }
			return AGALProgram3DCache._instances[index];
		}
		
		private static function onContext3DDisposed(event:Stage3DEvent):void
		{
			var stage3DProxy:Stage3DProxy = (event.target as Stage3DProxy);

			var index:Number = stage3DProxy._iStage3DIndex;

            AGALProgram3DCache._instances[index].dispose();
            AGALProgram3DCache._instances[index] = null;

			stage3DProxy.removeEventListener(Stage3DEvent.CONTEXT3D_DISPOSED, AGALProgram3DCache.onContext3DDisposed , AGALProgram3DCache);
			stage3DProxy.removeEventListener(Stage3DEvent.CONTEXT3D_CREATED, AGALProgram3DCache.onContext3DDisposed, AGALProgram3DCache);
			stage3DProxy.removeEventListener(Stage3DEvent.CONTEXT3D_RECREATED, AGALProgram3DCache.onContext3DDisposed , AGALProgram3DCache);

		}
		
		public function dispose():void
		{
			for (var key in _program3Ds)
            {

				destroyProgram(key);
            }

			_keys = null;
            _program3Ds = null;
            _usages = null;
		}
		
		public function setProgram3D(pass:MaterialPassBase, vertexCode:String, fragmentCode:String):void
		{
			var stageIndex:Number = _stage3DProxy._iStage3DIndex;
			var program:Program3D;
			var key:String = getKey(vertexCode, fragmentCode);
			
			if (_program3Ds[key] == null)
            {
				_keys[AGALProgram3DCache._currentId] = key;
                _usages[AGALProgram3DCache._currentId] = 0;
                _ids[key] = AGALProgram3DCache._currentId;
				++AGALProgram3DCache._currentId;

				program = _stage3DProxy._iContext3D.createProgram();

                //away.Debug.throwPIR( 'AGALProgram3DCache' , 'setProgram3D' , 'Dependency: AGALMiniAssembler.assemble');

                //TODO: implement AGAL <> GLSL

				//var vertexByteCode:ByteArray = new AGALMiniAssembler(Debug.active).assemble(Context3DProgramType.VERTEX, vertexCode);
				//var fragmentByteCode:ByteArray = new AGALMiniAssembler(Debug.active).assemble(Context3DProgramType.FRAGMENT, fragmentCode);
				//program.upload(vertexByteCode, fragmentByteCode);

                /*                 var vertexByteCode  : ByteArray = new AGLSLCompiler().assemble( Context3DProgramType.VERTEX , vertexCode );                 var fragmentByteCode: ByteArray = new AGLSLCompiler().assemble( Context3DProgramType.FRAGMENT , fragmentCode );                 program.uploadGLSL(vertexByteCode, fragmentByteCode);                 */

                var vertCompiler:AGLSLCompiler = new AGLSLCompiler();
                var fragCompiler:AGLSLCompiler = new AGLSLCompiler();

                var vertString : String = vertCompiler.compile( Context3DProgramType.VERTEX, vertexCode );
                var fragString : String = fragCompiler.compile( Context3DProgramType.FRAGMENT, fragmentCode );

                
                Window.console.log( '===GLSL=========================================================');
                Window.console.log( 'vertString' );
                Window.console.log( vertString );
                Window.console.log( 'fragString' );
                Window.console.log( fragString );

                Window.console.log( '===AGAL=========================================================');
                Window.console.log( 'vertexCode' );
                Window.console.log( vertexCode );
                Window.console.log( 'fragmentCode' );
                Window.console.log( fragmentCode );
                

                program.upload(vertString, fragString);
                /*                 var vertCompiler:aglsl.AGLSLCompiler = new aglsl.AGLSLCompiler();                 var fragCompiler:aglsl.AGLSLCompiler = new aglsl.AGLSLCompiler();                 var vertString : string = vertCompiler.compile( away.display3D.Context3DProgramType.VERTEX, this.pGetVertexCode() );                 var fragString : string = fragCompiler.compile( away.display3D.Context3DProgramType.FRAGMENT, this.pGetFragmentCode() );                 this._program3D.upload( vertString , fragString );                 */

				_program3Ds[key] = program;
			}


			var oldId:Number = pass._iProgram3Dids[stageIndex];
			var newId:Number = _ids[key];
			
			if (oldId != newId)
            {
				if (oldId >= 0)
                {
                    freeProgram3D(oldId);
                }

				_usages[newId]++;

			}
			
			pass._iProgram3Dids[stageIndex] = newId;
			pass._iProgram3Ds[stageIndex] = _program3Ds[key];

		}
		
		public function freeProgram3D(programId:Number):void
		{
			_usages[programId]--;

			if (_usages[programId] == 0)
            {
				destroyProgram(_keys[programId]);
            }

		}
		
		private function destroyProgram(key:String):void
		{
			_program3Ds[key].dispose();
            _program3Ds[key] = null;
			delete _program3Ds[key];
            _ids[key] = -1;

		}
		
		private function getKey(vertexCode:String, fragmentCode:String):String
		{
			return vertexCode + "---" + fragmentCode;
		}
	}
}

import away.events.Stage3DEvent;
import away.materials.passes.MaterialPassBase;
import away.display3D.Program3D;
import aglsl.AGLSLCompiler;
import away.display3D.Context3DProgramType;
	import randori.webkit.page.Window;

class AGALProgram3DCacheSingletonEnforcer
{
}
