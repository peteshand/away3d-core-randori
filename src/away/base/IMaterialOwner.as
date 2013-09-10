///<reference path="../_definitions.ts"/>
package away.base
{
	import away.materials.MaterialBase;
	import away.animators.IAnimator;
	//import away3d.animators.IAnimator;
	//import away3d.materials.MaterialBase;
	
	/**
	 * IMaterialOwner provides an interface for objects that can use materials.
	 */
	public interface IMaterialOwner
	{
		/**
		 * The material with which to render the object.
		 */
		function get material():MaterialBase; // GET / SET
		function set material(value:MaterialBase):void; // GET / SET

		/**
		 * The animation used by the material to assemble the vertex code.
		 */
		function get animator():IAnimator; // GET in most cases, this will in fact be null
	}
}
