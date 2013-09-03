///<reference path="../_definitions.ts"/>

// Reference note: http://www.w3schools.com/jsref/dom_obj_event.asp

package away.managers
{
	import away.containers.View3D;
	import away.geom.Vector3D;
	import away.pick.PickingCollisionVO;
	import away.events.MouseEvent3D;
	import away.pick.IPicker;
	import away.pick.PickingType;
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
	
	/**
	public class Mouse3DManager
	{
		private static var _view3Ds:Object;
		private static var _view3DLookup:Vector.<View3D>;
		private static var _viewCount:Number = 0;
		
		private var _activeView:View3D;
		private var _updateDirty:Boolean = true;
		private var _nullVector:Vector3D = new Vector3D();
		public static var _pCollidingObject:PickingCollisionVO;//Protected
		private static var _collidingViewObjects:Vector.<PickingCollisionVO>;//Vector.<PickingCollisionVO>;
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
		private var _forceMouseMove:Boolean;
		private var _mousePicker:IPicker = PickingType.RAYCAST_FIRST_ENCOUNTERED;
		private var _childDepth:Number = 0;
		private static var _previousCollidingView:Number = -1;
		private static var _collidingView:Number = -1;
		private var _collidingDownObject:PickingCollisionVO;
		private var _collidingUpObject:PickingCollisionVO;


		/**
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
            /*
		}

		public function fireMouseEvents():void
		{

            throw new PartialImplementationError( 'View3D().layeredView' )

            /*
		}
		
		public function addViewLayer(view:View3D):void
		{
            throw new PartialImplementationError( 'Stage3DProxy, Stage, DisplayObjectContainer ( as3 / native ) ' );

            /*

		}
		
		public function enableMouseListeners(view:View3D):void
		{
            throw new PartialImplementationError( 'MouseEvent ( as3 / native ) as3 <> JS Conversion' );

            /*
		}
		
		public function disableMouseListeners(view:View3D):void
		{
            throw new PartialImplementationError( 'MouseEvent ( as3 / native ) as3 <> JS Conversion' );

            /*

		}
		
		public function dispose():void
		{
			_mousePicker.dispose();
		}
		
		// ---------------------------------------------------------------------
		// Private.
		// ---------------------------------------------------------------------
		
		private function queueDispatch(event:MouseEvent3D, sourceEvent:MouseEvent, collider:PickingCollisionVO = null):void
		{
            throw new PartialImplementationError( 'MouseEvent ( as3 / native ) as3 <> JS Conversion' );

            /*
		}
		
		private function reThrowEvent(event:MouseEvent):void
		{

            /*

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
		
		private function traverseDisplayObjects(container:*):void //:DisplayObjectContainer)
            throw new PartialImplementationError( 'DisplayObjectContainer ( as3 / native ) as3 <> JS Conversion' );
            /*
		}
		
		// ---------------------------------------------------------------------
		// Listeners.
		// ---------------------------------------------------------------------
		
		private function onMouseMove(event:MouseEvent):void
		{

            throw new PartialImplementationError( 'MouseEvent ( as3 / native ) as3 <> JS Conversion' );

            /*
		}
		
		private function onMouseOut(event:MouseEvent):void
		{

            _activeView = null;

            if (Mouse3DManager._pCollidingObject)
            {

                queueDispatch(Mouse3DManager._mouseOut, event, Mouse3DManager._pCollidingObject);

            }

			_updateDirty = true;

            throw new PartialImplementationError( 'MouseEvent ( as3 / native ) as3 <> JS Conversion' );

		}
		
		private function onMouseOver(event:MouseEvent):void
		{

            /*

            throw new PartialImplementationError( 'MouseEvent ( as3 / native ) as3 <> JS Conversion' );

		}
		
		private function onClick(event:MouseEvent):void
		{
            /*
            throw new PartialImplementationError( 'MouseEvent ( as3 / native ) as3 <> JS Conversion' );

		}
		
		private function onDoubleClick(event:MouseEvent):void
		{
            if ( Mouse3DManager._pCollidingObject)
            {
                queueDispatch( Mouse3DManager._mouseDoubleClick, event);
            }
			else
            {
                reThrowEvent(event);
            }

			_updateDirty = true;
		}
		
		private function onMouseDown(event:MouseEvent):void
		{
            /*
            throw new PartialImplementationError( 'MouseEvent ( as3 / native ) as3 <> JS Conversion' );
		}
		
		private function onMouseUp(event:MouseEvent):void
		{
            /*
            throw new PartialImplementationError( 'MouseEvent ( as3 / native ) as3 <> JS Conversion' );

		}
		
		private function onMouseWheel(event:MouseEvent):void
		{
            /*
            throw new PartialImplementationError( 'MouseEvent ( as3 / native ) as3 <> JS Conversion' );

        }
		
		// ---------------------------------------------------------------------
		// Getters & setters.
		// ---------------------------------------------------------------------
		
		public function get forceMouseMove():Boolean
		{
			return _forceMouseMove;
		}
		
		public function set forceMouseMove(value:Boolean):void
		{
            this._forceMouseMove = value;
		}
		
		public function get mousePicker():IPicker
		{
			return _mousePicker;
		}
		
		public function set mousePicker(value:IPicker):void
		{
			this._mousePicker = value;
		}
	}
}