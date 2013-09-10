///<reference path="../../_definitions.ts"/>
package away.animators.states
{
	import away.geom.Vector3D;
	public interface IAnimationState
	{
		function get positionDelta():Vector3D; // GET
		
		function offset(startTime:Number):void;
		
		function update(time:Number):void;
		
		/**
		 * Sets the animation phase of the node.
		 *
		 * @param value The phase value to use. 0 represents the beginning of an animation clip, 1 represents the end.
		 */
		function phase(value:Number):void;
	}
}
