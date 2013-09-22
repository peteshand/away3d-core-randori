/** * ... * @author Gary Paluk - http://www.plugin.io */

///<reference path="../_definitions.ts" />

package away.controllers
{
	import away.entities.Entity;
	import away.errors.AbstractMethodError;
	public class ControllerBase
	{
		
		public var _pAutoUpdate:Boolean = true;
		public var _pTargetObject:Entity;
		
		public function ControllerBase(targetObject:Entity = null):void
		{
			targetObject = targetObject || null;

			this.targetObject = targetObject;
		}
		
		public function pNotifyUpdate():void
		{
			if( this._pTargetObject && this._pTargetObject.iGetImplicitPartition() && this._pAutoUpdate )
			{
				this._pTargetObject.iGetImplicitPartition().iMarkForUpdate( this._pTargetObject );
			}
		}
		
		public function get targetObject():Entity
		{
			return this._pTargetObject;
		}
		
		public function set targetObject(val:Entity):void
		{
			if( this._pTargetObject == val )
			{
				return;
			}
			
			if( this._pTargetObject && this._pAutoUpdate )
			{
				this._pTargetObject._iController = null;
			}
			this._pTargetObject = val;
			
			if( this._pTargetObject && this._pAutoUpdate )
			{
				this._pTargetObject._iController = this;
			}
			this.pNotifyUpdate();
		}
		
		public function get autoUpdate():Boolean
		{
			return this._pAutoUpdate;
		}
		
		public function set autoUpdate(val:Boolean):void
		{
			if( this._pAutoUpdate == val )
			{
				return;
			}
			this._pAutoUpdate = val;
			
			if( this._pTargetObject ) 
			{
				if ( this._pTargetObject )
				{
					this._pTargetObject._iController = this;
				}
				else
				{
					this._pTargetObject._iController = null;
				}
			}
		}
		
		public function update(interpolate:Boolean = true):void
		{
			interpolate = interpolate || true;

			throw new AbstractMethodError();
		}
	}
}