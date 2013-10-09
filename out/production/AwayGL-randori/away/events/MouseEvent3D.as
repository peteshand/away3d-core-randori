/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package away.events
{
	import away.containers.View3D;
	import away.containers.ObjectContainer3D;
	import away.core.base.IRenderable;
	import away.materials.MaterialBase;
	import away.core.geom.Point;
	import away.core.geom.Vector3D;
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
		public var screenX:Number = 0;
		
		/**		 * The vertical coordinate at which the event occurred in view coordinates.		 */
		public var screenY:Number = 0;
		
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
		public var index:Number = 0;
		
		/**		 * The index of the subGeometry where the event took place.		 */
		public var subGeometryIndex:Number = 0;
		
		/**		 * The position in object space where the event took place		 */
		public var localPosition:Vector3D;
		
		/**		 * The normal in object space where the event took place		 */
		public var localNormal:Vector3D;
		
		/**		 * Indicates whether the Control key is active (true) or inactive (false).		 */
		public var ctrlKey:Boolean = false;
		
		/**		 * Indicates whether the Alt key is active (true) or inactive (false).		 */
		public var altKey:Boolean = false;
		
		/**		 * Indicates whether the Shift key is active (true) or inactive (false).		 */
		public var shiftKey:Boolean = false;
		
		/**		 * Indicates how many lines should be scrolled for each unit the user rotates the mouse wheel.		 */
		public var delta:Number = 0;
		
		/**		 * Create a new MouseEvent3D object.		 * @param type The type of the MouseEvent3D.		 */
		public function MouseEvent3D(type:String):void
		{
			super(type );//, true, true);
		}
		
		/**		 * @inheritDoc		 */
		public function get bubbles():Boolean
		{
			var doesBubble:Boolean = this._iAllowedToPropagate ;
            this._iAllowedToPropagate = true;
			// Don't bubble if propagation has been stopped.
			return doesBubble;
		}
		
		/**		 * @inheritDoc		 */
		public function stopPropagation():void
		{
            this._iAllowedToPropagate = false;

			if (this._iParentEvent){

                this._iParentEvent.stopPropagation();

            }

		}
		
		/**		 * @inheritDoc		 */
		public function stopImmediatePropagation():void
		{
			this._iAllowedToPropagate = false;

			if ( this._iParentEvent )
            {

                this._iParentEvent.stopImmediatePropagation();

            }

		}
		
		/**		 * Creates a copy of the MouseEvent3D object and sets the value of each property to match that of the original.		 */
		override public function clone():Event
		{
			var result:MouseEvent3D = new MouseEvent3D( this.type );

            /* TODO: Debug / test - look into isDefaultPrevented			if (isDefaultPrevented())				result.preventDefault();			*/

			result.screenX = this.screenX;
			result.screenY = this.screenY;
			
			result.view = this.view;
			result.object = this.object;
			result.renderable = this.renderable;
			result.material = this.material;
			result.uv = this.uv;
			result.localPosition = this.localPosition;
			result.localNormal = this.localNormal;
			result.index = this.index;
			result.subGeometryIndex = this.subGeometryIndex;
			result.delta = this.delta;
			
			result.ctrlKey = this.ctrlKey;
			result.shiftKey = this.shiftKey;
			
			result._iParentEvent = this;
			result._iAllowedToPropagate = this._iAllowedToPropagate;
			
			return result;
		}
		
		/**		 * The position in scene space where the event took place		 */
		public function get scenePosition():Vector3D
		{
            if ( this.object instanceof ObjectContainer3D ) //if (this.object is ObjectContainer3D)
            {

                var objContainer : ObjectContainer3D = (this.object as ObjectContainer3D);
                return objContainer.sceneTransform.transformVector( this.localPosition );

            }
			else
            {

                return this.localPosition;

            }

		}
		
		/**		 * The normal in scene space where the event took place		 */
		public function get sceneNormal():Vector3D
		{

            if ( this.object instanceof ObjectContainer3D ) //if (this.object is ObjectContainer3D)
            {
                var objContainer : ObjectContainer3D = (this.object as ObjectContainer3D);
                var sceneNormal  : Vector3D = objContainer.sceneTransform.deltaTransformVector( this.localNormal );

                    sceneNormal.normalize();

                return sceneNormal;

            }
            else
            {

                return this.localNormal;
            }

            /*			if (object is ObjectContainer3D) {				var sceneNormal:Vector3D = ObjectContainer3D(object)				sceneNormal.normalize();				return sceneNormal;			} else				return localNormal;				*/

		}
	}
}
