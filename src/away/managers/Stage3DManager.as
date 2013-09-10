
///<reference path="../_definitions.ts"/>

package away.managers
{
	import away.display.Stage;
	//import away3d.arcane;
	
	//import flash.display.Stage;
	//import flash.utils.Dictionary;
	
	//use namespace arcane;
	
	/**
	 * The Stage3DManager class provides a multiton object that handles management for Stage3D objects. Stage3D objects
	 * should not be requested directly, but are exposed by a Stage3DProxy.
	 *
	 * @see away3d.core.managers.Stage3DProxy
	 */
	public class Stage3DManager
	{
        //private static _instances:Object;
        private static var _instances:Vector.<Stage3DManagerInstanceData>;
		private static var _stageProxies:Vector.<Stage3DProxy>;//.<Stage3DProxy>;
		private static var _numStageProxies:Number = 0;
		
		private var _stage:Stage;
		
		/**
		 * Creates a new Stage3DManager class.
		 * @param stage The Stage object that contains the Stage3D objects to be managed.
		 * @private
		 */
		public function Stage3DManager(stage:Stage, stage3DManagerSingletonEnforcer:Stage3DManagerSingletonEnforcer):void
		{
			if (!stage3DManagerSingletonEnforcer)
            {
                throw new Error("This class is a multiton and cannot be instantiated manually. Use Stage3DManager.getInstance instead.");
            }

			_stage = stage;
			
			if (!Stage3DManager._stageProxies)
            {
                Stage3DManager._stageProxies = new Vector.<Stage3DProxy>( _stage.stage3Ds.length ) ;
				Stage3DManager._stageProxies[_stage.stage3Ds.length-1] = undefined;//, true);
            }

		}
		
		/**
		 * Gets a Stage3DManager instance for the given Stage object.
		 * @param stage The Stage object that contains the Stage3D objects to be managed.
		 * @return The Stage3DManager instance for the given Stage object.
		 */
		public static function getInstance(stage:Stage):Stage3DManager
		{

            var stage3dManager : Stage3DManager = Stage3DManager.getStage3DManagerByStageRef( stage );

            if ( stage3dManager == null)
            {

                stage3dManager = new Stage3DManager( stage , new Stage3DManagerSingletonEnforcer());

                var stageInstanceData : Stage3DManagerInstanceData = new Stage3DManagerInstanceData();
                    stageInstanceData.stage = stage;
                    stageInstanceData.stage3DManager = stage3dManager;

                Stage3DManager._instances.push( stageInstanceData );

            }

			return stage3dManager;

		}

        /**
         *
         * @param stage
         * @returns {  away.managers.Stage3DManager }
         * @constructor
         */
        private static function getStage3DManagerByStageRef(stage:Stage):Stage3DManager
        {

            if ( Stage3DManager._instances == null )
            {

                Stage3DManager._instances = new Vector.<Stage3DManagerInstanceData>();

            }

            var l : Number = Stage3DManager._instances.length;
            var s : Stage3DManagerInstanceData;

            for ( var c : Number = 0 ; c < l ; c ++ )
            {

                s = Stage3DManager._instances[c];

                if ( s.stage == stage ){

                    return s.stage3DManager;

                }


            }

            return null;

        }

		/**
		 * Requests the Stage3DProxy for the given index.
		 * @param index The index of the requested Stage3D.
		 * @param forceSoftware Whether to force software mode even if hardware acceleration is available.
		 * @param profile The compatibility profile, an enumeration of Context3DProfile
		 * @return The Stage3DProxy for the given index.
		 */
		public function getStage3DProxy(index:Number, forceSoftware:Boolean = false, profile:String = "baseline"):Stage3DProxy
		{
			if (!Stage3DManager._stageProxies[index])
            {

                Stage3DManager._numStageProxies++;
                Stage3DManager._stageProxies[index] = new Stage3DProxy(index, _stage.stage3Ds[index], this, forceSoftware, profile);

			}
			
			return Stage3DManager._stageProxies[index];
		}
		
		/**
		 * Removes a Stage3DProxy from the manager.
		 * @param stage3DProxy
		 * @private
		 */
		public function iRemoveStage3DProxy(stage3DProxy:Stage3DProxy):void
		{
            Stage3DManager._numStageProxies--;
            Stage3DManager._stageProxies[ stage3DProxy._iStage3DIndex ] = null;
		}
		
		/**
		 * Get the next available stage3DProxy. An error is thrown if there are no Stage3DProxies available
		 * @param forceSoftware Whether to force software mode even if hardware acceleration is available.
		 * @param profile The compatibility profile, an enumeration of Context3DProfile
		 * @return The allocated stage3DProxy
		 */
		public function getFreeStage3DProxy(forceSoftware:Boolean = false, profile:String = "baseline"):Stage3DProxy
		{
			var i:Number = 0;
			var len:Number = Stage3DManager._stageProxies.length;

            //console.log( Stage3DManager._stageProxies );

			while (i < len)
            {

				if ( ! Stage3DManager._stageProxies[i] )
                {

                    getStage3DProxy(i, forceSoftware, profile);

                    Stage3DManager._stageProxies[i].width = _stage.stageWidth;
                    Stage3DManager._stageProxies[i].height = _stage.stageHeight;

					return Stage3DManager._stageProxies[i];

				}

				++i;

			}
			
			throw new Error("Too many Stage3D instances used!");
			return null;

		}
		
		/**
		 * Checks if a new stage3DProxy can be created and managed by the class.
		 * @return true if there is one slot free for a new stage3DProxy
		 */
		public function get hasFreeStage3DProxy():Boolean
		{
			return Stage3DManager._numStageProxies < Stage3DManager._stageProxies.length? true : false;
		}
		
		/**
		 * Returns the amount of stage3DProxy objects that can be created and managed by the class
		 * @return the amount of free slots
		 */
		public function get numProxySlotsFree():Number
		{
			return Stage3DManager._stageProxies.length - Stage3DManager._numStageProxies;
		}
		
		/**
		 * Returns the amount of Stage3DProxy objects currently managed by the class.
		 * @return the amount of slots used
		 */
		public function get numProxySlotsUsed():Number
		{
			return Stage3DManager._numStageProxies;
		}
		
		/**
		 * Returns the maximum amount of Stage3DProxy objects that can be managed by the class
		 * @return the maximum amount of Stage3DProxy objects that can be managed by the class
		 */
		public function get numProxySlotsTotal():Number
		{
			return Stage3DManager._stageProxies.length;
		}
	}
}