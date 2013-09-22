///<reference path="../../_definitions.ts"/>
package away.animators.states
{
	import away.animators.nodes.AnimationNodeBase;
	import away.geom.Vector3D;
	import away.animators.IAnimator;

	/**	 *	 */
	public class AnimationStateBase 
	{
		private var _animationNode:AnimationNodeBase;
		private var _rootDelta:Vector3D = new Vector3D();
		private var _positionDeltaDirty:Boolean = true;
		
		private var _time:Number;
		private var _startTime:Number;
		private var _animator:IAnimator;
		
		/**		 * Returns a 3d vector representing the translation delta of the animating entity for the current timestep of animation		 */
		public function get positionDelta():Vector3D
		{
			if (this._positionDeltaDirty)
            {

                this.pUpdatePositionDelta();
            }

			return this._rootDelta;

		}
		
		public function AnimationStateBase(animator:IAnimator, animationNode:AnimationNodeBase):void
		{
			this._animator = animator;
            this._animationNode = animationNode;
		}
		
		/**		 * Resets the start time of the node to a  new value.		 *		 * @param startTime The absolute start time (in milliseconds) of the node's starting time.		 */
		public function offset(startTime:Number):void
		{
            this._startTime = startTime;

            this._positionDeltaDirty = true;
		}
		
		/**		 * Updates the configuration of the node to its current state.		 *		 * @param time The absolute time (in milliseconds) of the animator's play head position.		 *		 * @see away3d.animators.AnimatorBase#update()		 */
		public function update(time:Number):void
		{
			if (this._time == time - this._startTime)
            {

                return;

            }

            this.pUpdateTime(time);

		}
		
		/**		 * Sets the animation phase of the node.		 *		 * @param value The phase value to use. 0 represents the beginning of an animation clip, 1 represents the end.		 */
		public function phase(value:Number):void
		{

		}
		
		/**		 * Updates the node's internal playhead position.		 *		 * @param time The local time (in milliseconds) of the node's playhead position.		 */
		public function pUpdateTime(time:Number):void
		{
			this._time = time - this._startTime;
			
			this._positionDeltaDirty = true;
		}
		
		/**		 * Updates the node's root delta position		 */
		public function pUpdatePositionDelta():void
		{
		}
	}
}
