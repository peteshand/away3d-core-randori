/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package away.materials.compilation
{
	import away.materials.methods.MethodVO;
	import away.materials.LightSources;
	//import away3d.materials.LightSources;
	//import away3d.materials.methods.MethodVO;

	/**	 * MethodDependencyCounter keeps track of the number of dependencies for "named registers" used across methods.	 * Named registers are that are not necessarily limited to a single method. They are created by the compiler and	 * passed on to methods. The compiler uses the results to reserve usages through RegisterPool, which can be removed	 * each time a method has been compiled into the shader.	 *	 * @see RegisterPool.addUsage	 */
	public class MethodDependencyCounter
	{
		private var _projectionDependencies:Number = 0;
		private var _normalDependencies:Number = 0;
		private var _viewDirDependencies:Number = 0;
		private var _uvDependencies:Number = 0;
		private var _secondaryUVDependencies:Number = 0;
		private var _globalPosDependencies:Number = 0;
		private var _tangentDependencies:Number = 0;
		private var _usesGlobalPosFragment:Boolean = false;
		private var _numPointLights:Number = 0;
		private var _lightSourceMask:Number = 0;

		/**		 * Creates a new MethodDependencyCounter object.		 */
		public function MethodDependencyCounter():void
		{
		}

		/**		 * Clears dependency counts for all registers. Called when recompiling a pass.		 */
		public function reset():void
		{
			this._projectionDependencies = 0;
            this._normalDependencies = 0;
            this._viewDirDependencies = 0;
            this._uvDependencies = 0;
            this._secondaryUVDependencies = 0;
            this._globalPosDependencies = 0;
            this._tangentDependencies = 0;
            this._usesGlobalPosFragment = false;
		}

		/**		 * Sets the amount of lights that have a position associated with them.		 * @param numPointLights The amount of point lights.		 * @param lightSourceMask The light source types used by the material.		 */
		public function setPositionedLights(numPointLights:Number, lightSourceMask:Number):void
		{
            this._numPointLights = numPointLights;
            this._lightSourceMask = lightSourceMask;
		}

		/**		 * Increases dependency counters for the named registers listed as required by the given MethodVO.		 * @param methodVO the MethodVO object for which to include dependencies.		 */
		public function includeMethodVO(methodVO:MethodVO):void
		{
			if (methodVO.needsProjection){

                ++this._projectionDependencies;

            }

			if (methodVO.needsGlobalVertexPos)
            {

				++this._globalPosDependencies;

				if (methodVO.needsGlobalFragmentPos)
                {

                    this._usesGlobalPosFragment = true;

                }

			}
            else if (methodVO.needsGlobalFragmentPos)
            {

				++this._globalPosDependencies;
                this._usesGlobalPosFragment = true;

			}

			if (methodVO.needsNormals)
            {

                ++this._normalDependencies;

            }

			if (methodVO.needsTangents)
            {

                ++this._tangentDependencies;

            }

			if (methodVO.needsView)
            {

                ++this._viewDirDependencies;

            }

			if (methodVO.needsUV)
            {

                ++this._uvDependencies;

            }

			if (methodVO.needsSecondaryUV)
            {

                ++this._secondaryUVDependencies;

            }

		}

		/**		 * The amount of tangent vector dependencies (fragment shader).		 */
		public function get tangentDependencies():Number
		{
			return this._tangentDependencies;
		}

		/**		 * Indicates whether there are any dependencies on the world-space position vector.		 */
		public function get usesGlobalPosFragment():Boolean
		{
			return this._usesGlobalPosFragment;
		}

		/**		 * The amount of dependencies on the projected position.		 */
		public function get projectionDependencies():Number
		{
			return this._projectionDependencies;
		}

		/**		 * The amount of dependencies on the normal vector.		 */
		public function get normalDependencies():Number
		{
			return this._normalDependencies;
		}

		/**		 * The amount of dependencies on the view direction.		 */
		public function get viewDirDependencies():Number
		{
			return this._viewDirDependencies;
		}

		/**		 * The amount of dependencies on the primary UV coordinates.		 */
		public function get uvDependencies():Number
		{
			return this._uvDependencies;
		}

		/**		 * The amount of dependencies on the secondary UV coordinates.		 */
		public function get secondaryUVDependencies():Number
		{
			return this._secondaryUVDependencies;
		}

		/**		 * The amount of dependencies on the global position. This can be 0 while hasGlobalPosDependencies is true when		 * the global position is used as a temporary value (fe to calculate the view direction)		 */
		public function get globalPosDependencies():Number
		{
			return this._globalPosDependencies;
		}

		/**		 * Adds any external world space dependencies, used to force world space calculations.		 */
		public function addWorldSpaceDependencies(fragmentLights:Boolean):void
		{
			if (this._viewDirDependencies > 0)
            {

                ++this._globalPosDependencies;

            }

			
			if (this._numPointLights > 0 && (this._lightSourceMask & LightSources.LIGHTS))
            {
				++this._globalPosDependencies;

				if (fragmentLights)
                {

                    this._usesGlobalPosFragment = true;

                }

			}
		}
	}
}
