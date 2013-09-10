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
			targetObject = targetObject;
		}
		
		public function pNotifyUpdate():void
		{
			if( _pTargetObject && _pTargetObject.iGetImplicitPartition() && _pAutoUpdate )
			{
				_pTargetObject.iGetImplicitPartition().iMarkForUpdate( _pTargetObject );
			}
		}
		
		public function get targetObject():Entity
		{
			return _pTargetObject;
		}
		
		public function set targetObject(val:Entity):void
		{
			if( _pTargetObject == val )
			{
				return;
			}
			
			if( _pTargetObject && _pAutoUpdate )
			{
				_pTargetObject._iController = null;
			}
			_pTargetObject = val;
			
			if( _pTargetObject && _pAutoUpdate )
			{
				_pTargetObject._iController = this;
			}
			pNotifyUpdate();
		}
		
		public function get autoUpdate():Boolean
		{
			return _pAutoUpdate;
		}
		
		public function set autoUpdate(val:Boolean):void
		{
			if( _pAutoUpdate == val )
			{
				return;
			}
			_pAutoUpdate = val;
			
			if( _pTargetObject ) 
			{
				if ( _pTargetObject )
				{
					_pTargetObject._iController = this;
				}
				else
				{
					_pTargetObject._iController = null;
				}
			}
		}
		
		public function update(interpolate:Boolean = true):void
		{
			throw new AbstractMethodError();
		}
	}
}