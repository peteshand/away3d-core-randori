///<reference path="../../_definitions.ts"/>
package away.materials.compilation
{
	import away.materials.methods.MethodVO;
	import away.materials.LightSources;
	//import away3d.materials.LightSources;
	//import away3d.materials.methods.MethodVO;

	/**	 * MethodDependencyCounter keeps track of the number of dependencies for "named registers" used across methods.	 * Named registers are that are not necessarily limited to a single method. They are created by the compiler and	 * passed on to methods. The compiler uses the results to reserve usages through RegisterPool, which can be removed	 * each time a method has been compiled into the shader.	 *	 * @see RegisterPool.addUsage	 */
	public class MethodDependencyCounter
	{
		private var _projectionDependencies:Number;
		private var _normalDependencies:Number;
		private var _viewDirDependencies:Number;
		private var _uvDependencies:Number;
		private var _secondaryUVDependencies:Number;
		private var _globalPosDependencies:Number;
		private var _tangentDependencies:Number;
		private var _usesGlobalPosFragment:Boolean = false;
		private var _numPointLights:Number;
		private var _lightSourceMask:Number;

		/**		 * Creates a new MethodDependencyCounter object.		 */
		public function MethodDependencyCounter():void
		{
		}

		/**		 * Clears dependency counts for all registers. Called when recompiling a pass.		 */
		public function reset():void
		{
			_projectionDependencies = 0;
            _normalDependencies = 0;
            _viewDirDependencies = 0;
            _uvDependencies = 0;
            _secondaryUVDependencies = 0;
            _globalPosDependencies = 0;
            _tangentDependencies = 0;
            _usesGlobalPosFragment = false;
		}

		/**		 * Sets the amount of lights that have a position associated with them.		 * @param numPointLights The amount of point lights.		 * @param lightSourceMask The light source types used by the material.		 */
		public function setPositionedLights(numPointLights:Number, lightSourceMask:Number):void
		{
            _numPointLights = numPointLights;
            _lightSourceMask = lightSourceMask;
		}

		/**		 * Increases dependency counters for the named registers listed as required by the given MethodVO.		 * @param methodVO the MethodVO object for which to include dependencies.		 */
		public function includeMethodVO(methodVO:MethodVO):void
		{
			if (methodVO.needsProjection){

                ++_projectionDependencies;

            }

			if (methodVO.needsGlobalVertexPos)
            {

				++_globalPosDependencies;

				if (methodVO.needsGlobalFragmentPos)
                {

                    _usesGlobalPosFragment = true;

                }

			}
            else if (methodVO.needsGlobalFragmentPos)
            {

				++_globalPosDependencies;
                _usesGlobalPosFragment = true;

			}

			if (methodVO.needsNormals)
            {

                ++_normalDependencies;

            }

			if (methodVO.needsTangents)
            {

                ++_tangentDependencies;

            }

			if (methodVO.needsView)
            {

                ++_viewDirDependencies;

            }

			if (methodVO.needsUV)
            {

                ++_uvDependencies;

            }

			if (methodVO.needsSecondaryUV)
            {

                ++_secondaryUVDependencies;

            }

		}

		/**		 * The amount of tangent vector dependencies (fragment shader).		 */
		public function get tangentDependencies():Number
		{
			return _tangentDependencies;
		}

		/**		 * Indicates whether there are any dependencies on the world-space position vector.		 */
		public function get usesGlobalPosFragment():Boolean
		{
			return _usesGlobalPosFragment;
		}

		/**		 * The amount of dependencies on the projected position.		 */
		public function get projectionDependencies():Number
		{
			return _projectionDependencies;
		}

		/**		 * The amount of dependencies on the normal vector.		 */
		public function get normalDependencies():Number
		{
			return _normalDependencies;
		}

		/**		 * The amount of dependencies on the view direction.		 */
		public function get viewDirDependencies():Number
		{
			return _viewDirDependencies;
		}

		/**		 * The amount of dependencies on the primary UV coordinates.		 */
		public function get uvDependencies():Number
		{
			return _uvDependencies;
		}

		/**		 * The amount of dependencies on the secondary UV coordinates.		 */
		public function get secondaryUVDependencies():Number
		{
			return _secondaryUVDependencies;
		}

		/**		 * The amount of dependencies on the global position. This can be 0 while hasGlobalPosDependencies is true when		 * the global position is used as a temporary value (fe to calculate the view direction)		 */
		public function get globalPosDependencies():Number
		{
			return _globalPosDependencies;
		}

		/**		 * Adds any external world space dependencies, used to force world space calculations.		 */
		public function addWorldSpaceDependencies(fragmentLights:Boolean):void
		{
			if (_viewDirDependencies > 0)
            {

                ++_globalPosDependencies;

            }

			
			if (_numPointLights > 0 && (_lightSourceMask & LightSources.LIGHTS))
            {
				++_globalPosDependencies;

				if (fragmentLights)
                {

                    _usesGlobalPosFragment = true;

                }

			}
		}
	}
}
