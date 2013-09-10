///<reference path="../../_definitions.ts"/>

package away.animators.states
{
	import away.animators.nodes.AnimationNodeBase;
	import away.geom.Vector3D;
	import away.animators.IAnimator;

	/**
	 *
	 */
	public class AnimationStateBase 
	{
		private var _animationNode:AnimationNodeBase;
		private var _rootDelta:Vector3D = new Vector3D();
		private var _positionDeltaDirty:Boolean = true;
		
		private var _time:Number;
		private var _startTime:Number;
		private var _animator:IAnimator;
		
		/**
		 * Returns a 3d vector representing the translation delta of the animating entity for the current timestep of animation
		 */
		public function get positionDelta():Vector3D
		{
			if (_positionDeltaDirty)
            {

                pUpdatePositionDelta();
            }

			return _rootDelta;

		}
		
		public function AnimationStateBase(animator:IAnimator, animationNode:AnimationNodeBase):void
		{
			_animator = animator;
            _animationNode = animationNode;
		}
		
		/**
		 * Resets the start time of the node to a  new value.
		 *
		 * @param startTime The absolute start time (in milliseconds) of the node's starting time.
		 */
		public function offset(startTime:Number):void
		{
            _startTime = startTime;

            _positionDeltaDirty = true;
		}
		
		/**
		 * Updates the configuration of the node to its current state.
		 *
		 * @param time The absolute time (in milliseconds) of the animator's play head position.
		 *
		 * @see away3d.animators.AnimatorBase#update()
		 */
		public function update(time:Number):void
		{
			if (_time == time - _startTime)
            {

                return;

            }

            pUpdateTime(time);

		}
		
		/**
		 * Sets the animation phase of the node.
		 *
		 * @param value The phase value to use. 0 represents the beginning of an animation clip, 1 represents the end.
		 */
		public function phase(value:Number):void
		{

		}
		
		/**
		 * Updates the node's internal playhead position.
		 *
		 * @param time The local time (in milliseconds) of the node's playhead position.
		 */
		public function pUpdateTime(time:Number):void
		{
			_time = time - _startTime;
			
			_positionDeltaDirty = true;
		}
		
		/**
		 * Updates the node's root delta position
		 */
		public function pUpdatePositionDelta():void
		{
		}
	}
}
