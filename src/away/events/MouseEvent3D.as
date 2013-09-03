///<reference path="../_definitions.ts"/>
package away.events
{
	import away.containers.View3D;
	import away.containers.ObjectContainer3D;
	import away.base.IRenderable;
	import away.materials.MaterialBase;
	import away.geom.Point;
	import away.geom.Vector3D;
	//import away3d.arcane;
	//import away3d.containers.ObjectContainer3D;
	//import away3d.containers.View3D;
	//import away3d.core.base.IRenderable;
	//import away3d.materials.MaterialBase;
	
	//import flash.events.Event;
	//import flash.geom.Point;
	//import flash.geom.Vector3D;
	
	//use namespace arcane;
	
	/**	 * A MouseEvent3D is dispatched when a mouse event occurs over a mouseEnabled object in View3D.	 * todo: we don't have screenZ data, tho this should be easy to implement	 */
	public class MouseEvent3D extends Event
	{
		// Private.
		public var _iAllowedToPropagate:Boolean = true;
		public var _iParentEvent:MouseEvent3D;
		
		/**		 * Defines the value of the type property of a mouseOver3d event object.		 */
		public static var MOUSE_OVER:String = "mouseOver3d";
		
		/**		 * Defines the value of the type property of a mouseOut3d event object.		 */
		public static var MOUSE_OUT:String = "mouseOut3d";
		
		/**		 * Defines the value of the type property of a mouseUp3d event object.		 */
		public static var MOUSE_UP:String = "mouseUp3d";
		
		/**		 * Defines the value of the type property of a mouseDown3d event object.		 */
		public static var MOUSE_DOWN:String = "mouseDown3d";
		
		/**		 * Defines the value of the type property of a mouseMove3d event object.		 */
		public static var MOUSE_MOVE:String = "mouseMove3d";
		
		/**		 * Defines the value of the type property of a rollOver3d event object.		 */
		//		public static ROLL_OVER : string = "rollOver3d";
		
		/**		 * Defines the value of the type property of a rollOut3d event object.		 */
		//		public static ROLL_OUT : string = "rollOut3d";
		
		/**		 * Defines the value of the type property of a click3d event object.		 */
		public static var CLICK:String = "click3d";
		
		/**		 * Defines the value of the type property of a doubleClick3d event object.		 */
		public static var DOUBLE_CLICK:String = "doubleClick3d";
		
		/**		 * Defines the value of the type property of a mouseWheel3d event object.		 */
		public static var MOUSE_WHEEL:String = "mouseWheel3d";
		
		/**		 * The horizontal coordinate at which the event occurred in view coordinates.		 */
		public var screenX:Number;
		
		/**		 * The vertical coordinate at which the event occurred in view coordinates.		 */
		public var screenY:Number;
		
		/**		 * The view object inside which the event took place.		 */
		public var view:View3D;
		
		/**		 * The 3d object inside which the event took place.		 */
		public var object:ObjectContainer3D;
		
		/**		 * The renderable inside which the event took place.		 */
		public var renderable:IRenderable;
		
		/**		 * The material of the 3d element inside which the event took place.		 */
		public var material:MaterialBase;
		
		/**		 * The uv coordinate inside the draw primitive where the event took place.		 */
		public var uv:Point;
		
		/**		 * The index of the face where the event took place.		 */
		public var index:Number;
		
		/**		 * The index of the subGeometry where the event took place.		 */
		public var subGeometryIndex:Number;
		
		/**		 * The position in object space where the event took place		 */
		public var localPosition:Vector3D;
		
		/**		 * The normal in object space where the event took place		 */
		public var localNormal:Vector3D;
		
		/**		 * Indicates whether the Control key is active (true) or inactive (false).		 */
		public var ctrlKey:Boolean;
		
		/**		 * Indicates whether the Alt key is active (true) or inactive (false).		 */
		public var altKey:Boolean;
		
		/**		 * Indicates whether the Shift key is active (true) or inactive (false).		 */
		public var shiftKey:Boolean;
		
		/**		 * Indicates how many lines should be scrolled for each unit the user rotates the mouse wheel.		 */
		public var delta:Number;
		
		/**		 * Create a new MouseEvent3D object.		 * @param type The type of the MouseEvent3D.		 */
		public function MouseEvent3D(type:String):void
		{
			super(type );//, true, true);
		}
		
		/**		 * @inheritDoc		 */
		public function get bubbles():Boolean
		{
			var doesBubble:Boolean = _iAllowedToPropagate ;
            _iAllowedToPropagate = true;
			// Don't bubble if propagation has been stopped.
			return doesBubble;
		}
		
		/**		 * @inheritDoc		 */
		public function stopPropagation():void
		{
            _iAllowedToPropagate = false;

			if (_iParentEvent){

                _iParentEvent.stopPropagation();

            }

		}
		
		/**		 * @inheritDoc		 */
		public function stopImmediatePropagation():void
		{
			_iAllowedToPropagate = false;

			if ( _iParentEvent )
            {

                _iParentEvent.stopImmediatePropagation();

            }

		}
		
		/**		 * Creates a copy of the MouseEvent3D object and sets the value of each property to match that of the original.		 */
		override public function clone():Event
		{
			var result:MouseEvent3D = new MouseEvent3D( type );

            /* TODO: Debug / test - look into isDefaultPrevented			if (isDefaultPrevented())				result.preventDefault();			*/

			result.screenX = screenX;
			result.screenY = screenY;
			
			result.view = view;
			result.object = object;
			result.renderable = renderable;
			result.material = material;
			result.uv = uv;
			result.localPosition = localPosition;
			result.localNormal = localNormal;
			result.index = index;
			result.subGeometryIndex = subGeometryIndex;
			result.delta = delta;
			
			result.ctrlKey = ctrlKey;
			result.shiftKey = shiftKey;
			
			result._iParentEvent = this;
			result._iAllowedToPropagate = _iAllowedToPropagate;
			
			return result;
		}
		
		/**		 * The position in scene space where the event took place		 */
		public function get scenePosition():Vector3D
		{
            if ( object instanceof ObjectContainer3D ) //if (this.object is ObjectContainer3D)
            {

                var objContainer : ObjectContainer3D = ObjectContainer3D(object);
                return objContainer.sceneTransform.transformVector( localPosition );

            }
			else
            {

                return localPosition;

            }

		}
		
		/**		 * The normal in scene space where the event took place		 */
		public function get sceneNormal():Vector3D
		{

            if ( object instanceof ObjectContainer3D ) //if (this.object is ObjectContainer3D)
            {
                var objContainer : ObjectContainer3D = ObjectContainer3D(object);
                var sceneNormal  : Vector3D = objContainer.sceneTransform.deltaTransformVector( localNormal );

                    sceneNormal.normalize();

                return sceneNormal;

            }
            else
            {

                return localNormal;
            }

            /*			if (object is ObjectContainer3D) {				var sceneNormal:Vector3D = ObjectContainer3D(object)				sceneNormal.normalize();				return sceneNormal;			} else				return localNormal;				*/

		}
	}
}
