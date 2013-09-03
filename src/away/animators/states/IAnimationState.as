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
		function phase(value:Number):void;
	}
}