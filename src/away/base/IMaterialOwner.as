///<reference path="../_definitions.ts"/>
/** * @module away.base */
package away.base
{
	import away.materials.MaterialBase;
	import away.animators.IAnimator;
    /**     *	 * IMaterialOwner provides an interface for objects that can use materials.     *     * @interface away.base.IMaterialOwner	 */
	public interface IMaterialOwner
	{
		/**		 * The material with which to render the object.		 */
		function get material():MaterialBase; // GET / SET		function set material(value:MaterialBase):void; // GET / SET
		/**		 * The animation used by the material to assemble the vertex code.		 */
		function get animator():IAnimator; // GET in most cases, this will in fact be null	}
}
