/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package away.managers
{
	import away.containers.View3D;
	import away.core.geom.Vector3D;
	import away.core.pick.PickingCollisionVO;
	import away.events.MouseEvent3D;
	import away.core.pick.IPicker;
	import away.core.pick.PickingType;
	import away.errors.PartialImplementationError;
	import randori.webkit.dom.MouseEvent;
	//import away3d.arcane;
	//import away3d.containers.ObjectContainer3D;
	//import away3d.containers.View3D;
	//import away3d.core.pick.IPicker;
	//import away3d.core.pick.PickingCollisionVO;
	//import away3d.core.pick.PickingType;
	//import away3d.events.MouseEvent3D;
	
	//import flash.display.DisplayObject;
	//import flash.display.DisplayObjectContainer;
	//import flash.display.Stage;
	//import flash.events.MouseEvent;
	//import flash.geom.Vector3D;
	//import flash.utils.Dictionary;
	
	//use namespace arcane;
	
	/**	 * Mouse3DManager enforces a singleton pattern and is not intended to be instanced.	 * it provides a manager class for detecting 3D mouse hits on View3D objects and sending out 3D mouse events.	 */
	public class Mouse3DManager
	{
		private static var _view3Ds:Object;
		private static var _view3DLookup:Vector.<View3D>;
		private static var _viewCount:Number = 0;
		
		private var _activeView:View3D;
		private var _updateDirty:Boolean = true;
		private var _nullVector:Vector3D = new Vector3D();
		public static var _pCollidingObject:PickingCollisionVO;//Protected
		private static var _previousCollidingObject:PickingCollisionVO;
		private static var _collidingViewObjects:Vector.<PickingCollisionVO>;//Vector.<PickingCollisionVO>
		private static var _queuedEvents:Vector.<MouseEvent3D> = new Vector.<MouseEvent3D>();//Vector.<MouseEvent3D> = new Vector.<MouseEvent3D>()

        // TODO: AS3 <> Conversion
		//private _mouseMoveEvent:away.events.MouseEvent = new away.events.MouseEvent(away.events.MouseEvent.MOUSE_MOVE);
		
		private static var _mouseUp:MouseEvent3D = new MouseEvent3D(MouseEvent3D.MOUSE_UP);
		private static var _mouseClick:MouseEvent3D = new MouseEvent3D(MouseEvent3D.CLICK);
		private static var _mouseOut:MouseEvent3D = new MouseEvent3D(MouseEvent3D.MOUSE_OUT);
		private static var _mouseDown:MouseEvent3D = new MouseEvent3D(MouseEvent3D.MOUSE_DOWN);
		private static var _mouseMove:MouseEvent3D = new MouseEvent3D(MouseEvent3D.MOUSE_MOVE);
		private static var _mouseOver:MouseEvent3D = new MouseEvent3D(MouseEvent3D.MOUSE_OVER);
		private static var _mouseWheel:MouseEvent3D = new MouseEvent3D(MouseEvent3D.MOUSE_WHEEL);
		private static var _mouseDoubleClick:MouseEvent3D = new MouseEvent3D(MouseEvent3D.DOUBLE_CLICK);
		private var _forceMouseMove:Boolean = false;
		private var _mousePicker:IPicker = PickingType.RAYCAST_FIRST_ENCOUNTERED;
		private var _childDepth:Number = 0;
		private static var _previousCollidingView:Number = -1;
		private static var _collidingView:Number = -1;
		private var _collidingDownObject:PickingCollisionVO;
		private var _collidingUpObject:PickingCollisionVO;


		/**		 * Creates a new <code>Mouse3DManager</code> object.		 */
		public function Mouse3DManager():void
		{

			if (!Mouse3DManager._view3Ds)
            {
                Mouse3DManager._view3Ds         = new Object();
                Mouse3DManager._view3DLookup    = new Vector.<View3D> () ;//Vector.<View3D>();
			}

		}
		
		// ---------------------------------------------------------------------
		// Interface.
		// ---------------------------------------------------------------------

        // TODO: required dependency stage3DProxy
		public function updateCollider(view:View3D):void
		{
            throw new PartialImplementationError( 'stage3DProxy');
            /*			this._previousCollidingView = this._collidingView;						if (view) {				// Clear the current colliding objects for multiple views if backBuffer just cleared				if (view.stage3DProxy.bufferClear)					_collidingViewObjects = new Vector.<PickingCollisionVO>(_viewCount);								if (!view.shareContext) {					if (view == _activeView && (_forceMouseMove || _updateDirty)) { // If forceMouseMove is off, and no 2D mouse events dirtied the update, don't update either.						_collidingObject = _mousePicker.getViewCollision(view.mouseX, view.mouseY, view);					}				} else {					if (view.getBounds(view.parent).contains(view.mouseX + view.x, view.mouseY + view.y)) {						if (!_collidingViewObjects)							_collidingViewObjects = new Vector.<PickingCollisionVO>(_viewCount);						_collidingObject = _collidingViewObjects[_view3Ds[view]] = _mousePicker.getViewCollision(view.mouseX, view.mouseY, view);					}				}			}			*/
		}

		public function fireMouseEvents():void
		{

            throw new PartialImplementationError( 'View3D().layeredView' )

            /*			var i:number;			var len:number;			var event:away.events.MouseEvent3D;			var dispatcher:away.containers.ObjectContainer3D;			// If multiple view are used, determine the best hit based on the depth intersection.			if ( Mouse3DManager._collidingViewObjects )            {                Mouse3DManager._pCollidingObject = null;//_collidingObject = null;				// Get the top-most view colliding object				var distance:number = Infinity;				var view:away.containers.View3D;				for (var v:number = Mouse3DManager._viewCount - 1; v >= 0; v--)                {					view = _view3DLookup[v];					if ( Mouse3DManager._collidingViewObjects[v] && (view.layeredView || Mouse3DManager._collidingViewObjects[v].rayEntryDistance < distance))                    {						distance = Mouse3DManager._collidingViewObjects[v].rayEntryDistance;                        Mouse3DManager._pCollidingObject = Mouse3DManager._collidingViewObjects[v];//_collidingObject = Mouse3DManager._collidingViewObjects[v];						if (view.layeredView)                        {                            break;                        }					}				}			}						// If colliding object has changed, queue over/out events.			if (Mouse3DManager._pCollidingObject  != Mouse3DManager._previousCollidingObject)            {				if (Mouse3DManager._previousCollidingObject)                {                    this.queueDispatch(Mouse3DManager._mouseOut, this._mouseMoveEvent, Mouse3DManager._previousCollidingObject);                }				if (Mouse3DManager._pCollidingObject)                {                    this.queueDispatch(Mouse3DManager._mouseOver, this._mouseMoveEvent, Mouse3DManager._pCollidingObject );                }			}						// Fire mouse move events here if forceMouseMove is on.			if ( this._forceMouseMove && Mouse3DManager._pCollidingObject)            {                this.queueDispatch( Mouse3DManager._mouseMove, this._mouseMoveEvent, Mouse3DManager._pCollidingObject);            }						// Dispatch all queued events.			len = Mouse3DManager._queuedEvents.length;			for (i = 0; i < len; ++i)            {				// Only dispatch from first implicitly enabled object ( one that is not a child of a mouseChildren = false hierarchy ).				event = Mouse3DManager._queuedEvents[i];				dispatcher = event.object;				while (dispatcher && ! dispatcher._iAncestorsAllowMouseEnabled )                {                    dispatcher = dispatcher.parent;                }								if (dispatcher)                {                    dispatcher.dispatchEvent(event);                }			}            Mouse3DManager._queuedEvents.length = 0;						this._updateDirty = false;            Mouse3DManager._previousCollidingObject = Mouse3DManager._pCollidingObject;//_collidingObject;            //*/
		}
		
		public function addViewLayer(view:View3D):void
		{
            throw new PartialImplementationError( 'Stage3DProxy, Stage, DisplayObjectContainer ( as3 / native ) ' );

            /*			var stg:Stage = view.stage;						// Add instance to mouse3dmanager to fire mouse events for multiple views			if (!view.stage3DProxy.mouse3DManager)				view.stage3DProxy.mouse3DManager = this;						if (!hasKey(view))				_view3Ds[view] = 0;						_childDepth = 0;			traverseDisplayObjects(stg);			_viewCount = _childDepth;			*/

		}
		
		public function enableMouseListeners(view:View3D):void
		{
            throw new PartialImplementationError( 'MouseEvent ( as3 / native ) as3 <> JS Conversion' );

            /*			view.addEventListener(MouseEvent.CLICK, onClick);			view.addEventListener(MouseEvent.DOUBLE_CLICK, onDoubleClick);			view.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);			view.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);			view.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);			view.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);			view.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);			view.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);			*/
		}
		
		public function disableMouseListeners(view:View3D):void
		{
            throw new PartialImplementationError( 'MouseEvent ( as3 / native ) as3 <> JS Conversion' );

            /*			view.removeEventListener(MouseEvent.CLICK, onClick);			view.removeEventListener(MouseEvent.DOUBLE_CLICK, onDoubleClick);			view.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);			view.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);			view.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);			view.removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);			view.removeEventListener(MouseEvent.MOUSE_OVER, onMouseOver);			view.removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);			*/

		}
		
		public function dispose():void
		{
			this._mousePicker.dispose();
		}
		
		// ---------------------------------------------------------------------
		// Private.
		// ---------------------------------------------------------------------
		
		private function queueDispatch(event:MouseEvent3D, sourceEvent:MouseEvent, collider:PickingCollisionVO = null):void
		{
			collider = collider || null;

            throw new PartialImplementationError( 'MouseEvent ( as3 / native ) as3 <> JS Conversion' );

            /*			// 2D properties.			event.ctrlKey = sourceEvent.ctrlKey;			event.altKey = sourceEvent.altKey;			event.shiftKey = sourceEvent.shiftKey;			event.delta = sourceEvent.delta;			event.screenX = sourceEvent.localX;			event.screenY = sourceEvent.localY;						collider ||= _collidingObject;						// 3D properties.			if (collider) {				// Object.				event.object = collider.entity;				event.renderable = collider.renderable;				// UV.				event.uv = collider.uv;				// Position.				event.localPosition = collider.localPosition? collider.localPosition.clone() : null;				// Normal.				event.localNormal = collider.localNormal? collider.localNormal.clone() : null;				// Face index.				event.index = collider.index;				// SubGeometryIndex.				event.subGeometryIndex = collider.subGeometryIndex;							} else {				// Set all to null.				event.uv = null;				event.object = null;				event.localPosition = _nullVector;				event.localNormal = _nullVector;				event.index = 0;				event.subGeometryIndex = 0;			}						// Store event to be dispatched later.			_queuedEvents.push(event);			*/
		}
		
		private function reThrowEvent(event:MouseEvent):void
		{

            /*			if (!this._activeView || (this._activeView && !this._activeView._pShareContext))            {				return;            }            // TODO: Debug / keep on eye on this one :            for (var v in Mouse3DManager._view3Ds)            {				if (v != this._activeView && Mouse3DManager._view3Ds[v] < Mouse3DManager._view3Ds[this._activeView])                {                    v.dispatchEvent(event);                }			}            */

            throw new PartialImplementationError( 'MouseEvent - AS3 <> JS Conversion' );

		}
		
		private function hasKey(view:View3D):Boolean
		{

			for (var v in Mouse3DManager._view3Ds) {

				if ( v === view)
                {

                    return true;

                }

			}

			return false;
		}
		
		private function traverseDisplayObjects(container:*):void //:DisplayObjectContainer)		{
            throw new PartialImplementationError( 'DisplayObjectContainer ( as3 / native ) as3 <> JS Conversion' );
            /*			var childCount:number = container.numChildren;			var c:number = 0;			var child:DisplayObject;			for (c = 0; c < childCount; c++) {				child = container.getChildAt(c);				for (var v:* in _view3Ds) {					if (child == v) {						_view3Ds[child] = _childDepth;						_view3DLookup[_childDepth] = v;						_childDepth++;					}				}				if (child is DisplayObjectContainer)					traverseDisplayObjects(child as DisplayObjectContainer);			}			*/
		}
		
		// ---------------------------------------------------------------------
		// Listeners.
		// ---------------------------------------------------------------------
		
		private function onMouseMove(event:MouseEvent):void
		{

            throw new PartialImplementationError( 'MouseEvent ( as3 / native ) as3 <> JS Conversion' );

            /*			if (Mouse3DManager._pCollidingObject)            {                this.queueDispatch(Mouse3DManager._mouseMove, this._mouseMoveEvent = event);            }			else            {                this.reThrowEvent(event);            }			this._updateDirty = true;			*/
		}
		
		private function onMouseOut(event:MouseEvent):void
		{

            this._activeView = null;

            if (Mouse3DManager._pCollidingObject)
            {

                this.queueDispatch(Mouse3DManager._mouseOut, event, Mouse3DManager._pCollidingObject);

            }

			this._updateDirty = true;

            throw new PartialImplementationError( 'MouseEvent ( as3 / native ) as3 <> JS Conversion' );

		}
		
		private function onMouseOver(event:MouseEvent):void
		{

            /*            this._activeView = <away.containers.View3D> event.target ;//as View3D); // TODO: target was changed from currentTarget ( which might cause a bug ) .			//_activeView = (event.currentTarget as View3D);			if ( Mouse3DManager._pCollidingObject && Mouse3DManager._previousCollidingObject !=  Mouse3DManager._pCollidingObject)            {                this.queueDispatch( Mouse3DManager._mouseOver, event, Mouse3DManager._pCollidingObject);            }			else            {                this.reThrowEvent(event);            }			this._updateDirty = true;            */

            throw new PartialImplementationError( 'MouseEvent ( as3 / native ) as3 <> JS Conversion' );

		}
		
		private function onClick(event:MouseEvent):void
		{
            /*            if ( Mouse3DManager._pCollidingObject)            {				this.queueDispatch(Mouse3DManager._mouseClick, event);			}            else            {                this.reThrowEvent(event);            }			this._updateDirty = true;            */
            throw new PartialImplementationError( 'MouseEvent ( as3 / native ) as3 <> JS Conversion' );

		}
		
		private function onDoubleClick(event:MouseEvent):void
		{
            if ( Mouse3DManager._pCollidingObject)
            {
                this.queueDispatch( Mouse3DManager._mouseDoubleClick, event);
            }
			else
            {
                this.reThrowEvent(event);
            }

			this._updateDirty = true;
		}
		
		private function onMouseDown(event:MouseEvent):void
		{
            /*			this._activeView = <away.containers.View3D> event.target ;//as View3D); // TODO: target was changed from currentTarget ( which might cause a bug ) .			this.updateCollider(this._activeView); // ensures collision check is done with correct mouse coordinates on mobile            if ( Mouse3DManager._pCollidingObject)            {                this.queueDispatch( Mouse3DManager._mouseDown, event);                Mouse3DManager._previousCollidingObject = Mouse3DManager._pCollidingObject;//_collidingObject;			}            else            {                this.reThrowEvent(event);            }			this._updateDirty = true;            */
            throw new PartialImplementationError( 'MouseEvent ( as3 / native ) as3 <> JS Conversion' );
		}
		
		private function onMouseUp(event:MouseEvent):void
		{
            /*			if ( Mouse3DManager._pCollidingObject)            {				this.queueDispatch( Mouse3DManager._mouseUp , event );                Mouse3DManager._previousCollidingObject = Mouse3DManager._pCollidingObject;			}            else            {                this.reThrowEvent(event);            }			this._updateDirty = true;            */
            throw new PartialImplementationError( 'MouseEvent ( as3 / native ) as3 <> JS Conversion' );

		}
		
		private function onMouseWheel(event:MouseEvent):void
		{
            /*			if (Mouse3DManager._pCollidingObject)            {                this.queueDispatch(Mouse3DManager._mouseWheel, event);            }			else            {                this.reThrowEvent(event);            }            this._updateDirty = true;            */
            throw new PartialImplementationError( 'MouseEvent ( as3 / native ) as3 <> JS Conversion' );

        }
		
		// ---------------------------------------------------------------------
		// Getters & setters.
		// ---------------------------------------------------------------------
		
		public function get forceMouseMove():Boolean
		{
			return this._forceMouseMove;
		}
		
		public function set forceMouseMove(value:Boolean):void
		{
            this._forceMouseMove = value;
		}
		
		public function get mousePicker():IPicker
		{
			return this._mousePicker;
		}
		
		public function set mousePicker(value:IPicker):void
		{
			this._mousePicker = value;
		}
	}
}
