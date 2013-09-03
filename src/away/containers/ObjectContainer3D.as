/** * ... * @author Gary Paluk - http://www.plugin.io */
 
///<reference path="../_definitions.ts" />

package away.containers
{
	import away.base.Object3D;
	import away.geom.Matrix3D;
	import away.partition.Partition3D;
	import away.events.Object3DEvent;
	import away.geom.Vector3D;
	import away.library.assets.AssetType;
	import away.events.Scene3DEvent;
	import away.errors.Error;
	public class ObjectContainer3D extends Object3D
	{
		public var _iAncestorsAllowMouseEnabled:Boolean;
		public var _iIsRoot:Boolean;
		
		public var _pScene:Scene3D;
		public var _pParent:ObjectContainer3D;
		public var _pSceneTransform:Matrix3D = new Matrix3D();
		public var _pSceneTransformDirty:Boolean = true;
		
		public var _pExplicitPartition:Partition3D;
		public var _pImplicitPartition:Partition3D;
		public var _pMouseEnabled:Boolean;
		
		private var _sceneTransformChanged:Object3DEvent;
		private var _scenechanged:Object3DEvent;
		private var _children:Vector.<ObjectContainer3D> = new Vector.<ObjectContainer3D>();
		private var _mouseChildren:Boolean = true;
		private var _oldScene:Scene3D;
		private var _inverseSceneTransform:Matrix3D = new Matrix3D();
		private var _inverseSceneTransformDirty:Boolean = true;
		private var _scenePosition:Vector3D = new Vector3D();
		private var _scenePositionDirty:Boolean = true;
		private var _explicitVisibility:Boolean = true;
		private var _implicitVisibility:Boolean = true;
		private var _listenToSceneTransformChanged:Boolean;
		private var _listenToSceneChanged:Boolean;
		
		public var _pIgnoreTransform:Boolean = false;
		
		public function ObjectContainer3D():void
		{
			super();
		}
		
		public function getIgnoreTransform():Boolean
		{
			return _pIgnoreTransform;
		}
		
		public function setIgnoreTransform(value:Boolean):void
		{
			_pIgnoreTransform = value;
			_pSceneTransformDirty = !value;
			_inverseSceneTransformDirty = !value;
			_scenePositionDirty = !value;
			
			if( value ) {
				_pSceneTransform.identity();
				_scenePosition.setTo( 0, 0, 0 );
			}
		}

        /*        public get iImplicitPartition():away.partition.Partition3D        {            return this._pImplicitPartition;        }        */
        public function iGetImplicitPartition():Partition3D
        {

            return _pImplicitPartition;
        }

        /*		public set iImplicitPartition( value:away.partition.Partition3D )		{            this.iSetImplicitPartition( value );		}        */
        public function iSetImplicitPartition(value:Partition3D):void
        {

            if (value == _pImplicitPartition)
                return;

            var i:Number = 0;
            var len:Number = _children.length;
            var child:ObjectContainer3D;

            _pImplicitPartition = value;

            while (i < len)
            {
                child = _children[i++];

                // assign implicit partition if no explicit one is given
                if (!child._pExplicitPartition)
                    child._pImplicitPartition = value;
            }

            /*            if ( value == this._pImplicitPartition )            {                return;            }            console.log( 'ObjectContainer3D','iSetImplicitPartition' , value );            var i:number = 0;            var len:number = this._children.length;            var child:away.containers.ObjectContainer3D;            this._pImplicitPartition = value;            while (i < len)            {                child = this._children[i++];                if( !child._pExplicitPartition )                {                    child._pImplicitPartition = value;                }            }            */

        }
		
		public function get _iIsVisible():Boolean
		{
			return _implicitVisibility && _explicitVisibility;
		}
		
		public function iSetParent(value:ObjectContainer3D):void
		{
			_pParent = value;

			pUpdateMouseChildren();
			
			if( value == null ) {
				scene = null;
				return;
			}
			
			notifySceneTransformChange();
			notifySceneChange();
		}
		
		private function notifySceneTransformChange():void
		{
			if ( _pSceneTransformDirty || _pIgnoreTransform )
			{
				return;
			}
			
			pInvalidateSceneTransform();
			
			var i:Number = 0;
			var len:Number = _children.length;
			
			while( i < len )
			{
				_children[i++].notifySceneTransformChange();
			}
			
			if( _listenToSceneTransformChanged )
			{
				if( !_sceneTransformChanged )
				{
					_sceneTransformChanged = new Object3DEvent( Object3DEvent.SCENETRANSFORM_CHANGED, this );
				}
				dispatchEvent( _sceneTransformChanged );
			}
		}
		
		private function notifySceneChange():void
		{
			notifySceneTransformChange();
			
			var i:Number;
			var len:Number = _children.length;
			
			while(i < len)
			{
				_children[i++].notifySceneChange();
			}
			
			if( _listenToSceneChanged )
			{
				if( !_scenechanged )
				{
					_scenechanged = new Object3DEvent( Object3DEvent.SCENE_CHANGED, this );
				}
				dispatchEvent( _scenechanged );
			}
		}
		
		public function pUpdateMouseChildren():void
		{

			if( _pParent && !_pParent._iIsRoot )
			{
				_iAncestorsAllowMouseEnabled = _pParent._iAncestorsAllowMouseEnabled && _pParent.mouseChildren;
			}
			else
			{
				_iAncestorsAllowMouseEnabled = mouseChildren;
			}
			
			var len:Number = _children.length;
			for( var i:Number = 0; i < len; ++i )
			{
				_children[i].pUpdateMouseChildren();
			}
		}
		
		public function get mouseEnabled():Boolean
		{
			return _pMouseEnabled;
		}
		
		public function set mouseEnabled(value:Boolean):void
		{
			this._pMouseEnabled = value;
			this.pUpdateMouseChildren();
		}

        /**         * @inheritDoc         */
        override public function iInvalidateTransform():void
        {
            super.iInvalidateTransform();

            notifySceneTransformChange();
        }


        public function pInvalidateSceneTransform():void
		{
			_pSceneTransformDirty = !_pIgnoreTransform;
			_inverseSceneTransformDirty = !_pIgnoreTransform;
			_scenePositionDirty = !_pIgnoreTransform;
		}
		
		public function pUpdateSceneTransform():void
		{
			if ( _pParent && !_pParent._iIsRoot )
			{
				_pSceneTransform.copyFrom( _pParent.sceneTransform );
				_pSceneTransform.prepend( transform );
			}
			else
			{
				_pSceneTransform.copyFrom( transform );
			}
			_pSceneTransformDirty = false;
		}
		
		public function get mouseChildren():Boolean
		{
			return _mouseChildren;
		}
		
		public function set mouseChildren(value:Boolean):void
		{
			this._mouseChildren = value;
			this.pUpdateMouseChildren();
		}
		
		public function get visible():Boolean
		{
			return _explicitVisibility;
		}
		
		public function set visible(value:Boolean):void
		{
			var len:Number = this._children.length;
			
			this._explicitVisibility = value;
			
			for( var i:Number = 0; i < len; ++i )
			{
				this._children[i].updateImplicitVisibility();
			}
		}
		
		override public function get assetType():String
		{
			return AssetType.CONTAINER;
		}
		
		public function get scenePosition():Vector3D
		{
			if ( _scenePositionDirty )
			{
				sceneTransform.copyColumnTo( 3, _scenePosition );
				_scenePositionDirty = false;
			}
			return _scenePosition;
		}
		
		public function get minX():Number
		{
			var i:Number;
			var len:Number = _children.length;
			var min:Number = Number.POSITIVE_INFINITY;
			var m:Number;
			
			while( i < len ) {
				var child:ObjectContainer3D = _children[i++];
				m = child.minX + child.x;
				if( m < min )
				{
					min = m;
				}
			}
			return min;
		}
		
		public function get minY():Number
		{
			var i:Number;
			var len:Number = _children.length;
			var min:Number = Number.POSITIVE_INFINITY;
			var m:Number;
			
			while( i < len )
			{
				var child:ObjectContainer3D = _children[i++];
				m = child.minY + child.y;
				if( m < min )
				{
					min = m;
				}
			}
			return min;
		}
		
		public function get minZ():Number
		{
			var i:Number;
			var len:Number = _children.length;
			var min:Number = Number.POSITIVE_INFINITY;
			var m:Number;
			
			while( i < len )
			{
				var child:ObjectContainer3D = _children[i++];
				m = child.minZ + child.z;
				if( m < min )
				{
					min = m;
				}
			}
			return min;
		}
		
		public function get maxX():Number
		{
			var i:Number;
			var len:Number = _children.length;
			var max:Number = Number.NEGATIVE_INFINITY;
			var m:Number;
			
			while( i < len ) {
				var child:ObjectContainer3D = _children[i++];
				m = child.maxX + child.x;
				if( m > max )
				{
					max = m;
				}
			}
			return max;
		}
		
		public function get maxY():Number
		{
			var i:Number;
			var len:Number = _children.length;
			var max:Number = Number.NEGATIVE_INFINITY;
			var m:Number;
			
			while( i < len )
			{
				var child:ObjectContainer3D = _children[i++];
				m = child.maxY + child.y;
				if( m > max )
				{
					max = m;
				}
			}
			return max;
		}
		
		public function get maxZ():Number
		{
			var i:Number;
			var len:Number = _children.length;
			var max:Number = Number.NEGATIVE_INFINITY;
			var m:Number;
			
			while( i < len ) {
				var child:ObjectContainer3D = _children[i++];
				m = child.maxZ + child.z;
				if( m > max )
				{
					max = m;
				}
			}
			return max;
		}
		
		public function get partition():Partition3D
		{
			return _pExplicitPartition;
		}
		
		public function set partition(value:Partition3D):void
		{
			this._pExplicitPartition = value;
			this.iSetImplicitPartition( value ? value : ( this._pParent ? this._pParent.iGetImplicitPartition() : null) );
		}
		
		public function get sceneTransform():Matrix3D
		{
			if( _pSceneTransformDirty )
			{
				pUpdateSceneTransform();
			}
			return _pSceneTransform;
		}

        public function get scene():Scene3D
        {
            return _pScene;
        }

        public function set scene(value:Scene3D):void
        {

            this.setScene( value );

        }

        public function setScene(value:Scene3D):void
        {

            //console.log( 'ObjectContainer3D' , 'setScene' , value );

            var i:Number = 0;
            var len:Number = _children.length;

            while (i < len)
            {
                _children[i++].scene = value;
            }

            if (_pScene == value)
                return;

            // test to see if we're switching roots while we're already using a scene partition
            if (value == null)
                _oldScene = _pScene;

            if (_pExplicitPartition && _oldScene && _oldScene != _pScene)
                partition = null;

            if (value)
            {
                _oldScene = null;
            }
            // end of stupid partition test code

            _pScene = value;

            if (_pScene)
            {
                _pScene.dispatchEvent(new Scene3DEvent(Scene3DEvent.ADDED_TO_SCENE, this));
            }
            else if (_oldScene)
            {
                _oldScene.dispatchEvent(new Scene3DEvent(Scene3DEvent.REMOVED_FROM_SCENE, this));
            }

        }
		
		public function get inverseSceneTransform():Matrix3D
		{
			if ( _inverseSceneTransformDirty )
			{
				_inverseSceneTransform.copyFrom( sceneTransform );
				_inverseSceneTransform.invert();
				_inverseSceneTransformDirty = false;
			}
			return _inverseSceneTransform;
		}
		
		public function get parent():ObjectContainer3D
		{
			return _pParent;
		}
		
		public function contains(child:ObjectContainer3D):Boolean
		{
			return _children.indexOf( child ) >= 0;
		}
		
		public function addChild(child:ObjectContainer3D):ObjectContainer3D
		{
			if (child == null)
			{
				throw new away.errors.Error("Parameter child cannot be null.");
			}
			
			if (child._pParent)
			{
				child._pParent.removeChild(child);
			}

            //console.log( 'ObjectContainer3D' , 'addChild' , 'child._pExplicitPartition' ,  child._pExplicitPartition );

			if (!child._pExplicitPartition)
			{

                //console.log( 'ObjectContainer3D' , 'addChild' , 'set iImplicitPartition' ,  this._pImplicitPartition);

                child.iSetImplicitPartition( _pImplicitPartition );
				//child.iImplicitPartition = this._pImplicitPartition;
			}
			
			child.iSetParent( this );
			child.scene = _pScene;
			child.notifySceneTransformChange();
			child.pUpdateMouseChildren();
			child.updateImplicitVisibility();
			
			_children.push(child);
			
			return child;
		}
		
		public function addChildren(childarray:ObjectContainer3D):void
		{
			for(var child in childarray )
			{
				addChild( child );
			}
		}
		
		public function removeChild(child:ObjectContainer3D):void
		{
			if ( child == null )
			{
				throw new away.errors.Error("Parameter child cannot be null");
			}
			
			var childIndex:Number = _children.indexOf(child);
			
			if ( childIndex == -1 )
			{
				throw new away.errors.Error("Parameter is not a child of the caller");
			}
			
			removeChildInternal( childIndex, child );
		}
		
		public function removeChildAt(index:Number):void
		{
			var child:ObjectContainer3D = _children[index];
			removeChildInternal( index, child );
		}
		
		private function removeChildInternal(childIndex:Number, child:ObjectContainer3D):void
		{
			_children.splice( childIndex, 1 );
			child.iSetParent( null );
			
			if ( !child._pExplicitPartition )
			{
				child.iSetImplicitPartition( null );
			}
		}
		
		public function getChildAt(index:Number):ObjectContainer3D
		{
			return _children[index];
		}
		
		public function get numChildren():Number
		{
			return _children.length;
		}
		
		//@override 
		override public function lookAt(target:Vector3D, upAxis:Vector3D = null):void
		{

			super.lookAt( target, upAxis );
			notifySceneTransformChange();
		}
		
		//@override
		override public function translateLocal(axis:Vector3D, distance:Number):void
		{
    		super.translateLocal( axis, distance );
			notifySceneTransformChange();
		}
		
		//@override
		override public function dispose():void
		{
			if( parent )
			{
				parent.removeChild( this );
			}
		}
		
		public function disposeWithChildren():void
		{
			dispose();
			while( numChildren > 0 )
			{
				getChildAt(0).dispose();
			}
		}
		
		//override

		override public function clone():Object3D
		{
			var clone:ObjectContainer3D = new ObjectContainer3D();
			clone.pivotPoint = pivotPoint;
			clone.transform = transform;
			clone.partition = partition;
			clone.name = name;
			
			var len:Number = _children.length;
			
			for(var i:Number = 0; i < len; ++i)
			{
				clone.addChild( ObjectContainer3D(_children[i].clone()));
			}
			// todo: implement for all subtypes
			return clone;
		}

		
		//@override
		override public function rotate(axis:Vector3D, angle:Number):void
		{
			super.rotate(axis, angle);
			notifySceneTransformChange();
		}
		
		//TODO override public function dispatchEvent(event:Event):Boolean
		
		public function updateImplicitVisibility():void
		{
			var len:Number = _children.length;
			
			_implicitVisibility = _pParent._explicitVisibility && _pParent._implicitVisibility;
			
			for (var i:Number = 0; i < len; ++i)
			{
				_children[i].updateImplicitVisibility();
			}
		}
		
		//TODO override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		//TODO override public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
		
	}
}