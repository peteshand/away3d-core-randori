/** * ... * @author Gary Paluk - http://www.plugin.io */

///<reference path="../_definitions.ts" />

package away.controllers
{
	import away.geom.Vector3D;
	import away.containers.ObjectContainer3D;
	import away.entities.Entity;
	import away.events.Object3DEvent;
	public class LookAtController extends ControllerBase
	{
		public var _pLookAtPosition:Vector3D;
		public var _pLookAtObject:ObjectContainer3D;
		public var _pOrigin:Vector3D = new Vector3D(0.0, 0.0, 0.0);
		
		public function LookAtController(targetObject:Entity = null, lookAtObject:ObjectContainer3D = null):void
		{
			super( targetObject );
			if( lookAtObject )
			{
				this.lookAtObject = lookAtObject;
			}
			else
			{
				this.lookAtPosition = new Vector3D();
			}
		}
		
		public function get lookAtPosition():Vector3D
		{
			return _pLookAtPosition;
		}
		
		public function set lookAtPosition(val:Vector3D):void
		{
			if( this._pLookAtObject )
			{
				this._pLookAtObject.removeEventListener( Object3DEvent.SCENETRANSFORM_CHANGED, this.onLookAtObjectChanged, this );
				this._pLookAtObject = null;
			}
			
			this._pLookAtPosition = val;
			this.pNotifyUpdate();
		}
		
		public function get lookAtObject():ObjectContainer3D
		{
			return _pLookAtObject;
		}
		
		public function set lookAtObject(val:ObjectContainer3D):void
		{
			if( this._pLookAtPosition )
			{
				this._pLookAtPosition = null;
			}
			
			if( this._pLookAtObject == val )
			{
				return;
			}
			
			if( this._pLookAtObject )
			{
				this._pLookAtObject.removeEventListener( Object3DEvent.SCENETRANSFORM_CHANGED, this.onLookAtObjectChanged, this );
			}
			this._pLookAtObject = val;
			
			if( this._pLookAtObject )
			{
				this._pLookAtObject.addEventListener( Object3DEvent.SCENETRANSFORM_CHANGED, this.onLookAtObjectChanged, this );
			}
			
			this.pNotifyUpdate();
		}
		
		//@override
		override public function update(interpolate:Boolean = true):void
		{
			interpolate = interpolate; // prevents unused warning
			
			if( _pTargetObject )
			{
				if( _pLookAtPosition )
				{
					_pTargetObject.lookAt( _pLookAtPosition );
				}
				else if( _pLookAtObject )
				{
					_pTargetObject.lookAt( _pLookAtObject.scene? _pLookAtObject.scenePosition : _pLookAtObject.position );
				}
			}
		}
		
		private function onLookAtObjectChanged(event:Object3DEvent):void
		{
			pNotifyUpdate();
		}
		
	}
}