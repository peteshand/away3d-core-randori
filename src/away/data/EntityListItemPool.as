/**
 * ...
 * @author Gary Paluk - http://www.plugin.io
 */
///<reference path="../_definitions.ts"/>

package away.data
{
	public class EntityListItemPool
	{
		
		private var _pool:Vector.<EntityListItem>;
		private var _index:Number = 0;
		private var _poolSize:Number = 0;
		
		public function EntityListItemPool():void
		{
			_pool = new <EntityListItem>[];
		}
		
		public function getItem():EntityListItem
		{
			var item:EntityListItem;
			if( _index == _poolSize )
			{
				item = new EntityListItem();
				_pool[_index++] = item;
				++_poolSize;
			}
			else
			{
				item = _pool[_index++];
			}
			return item;
		}
		
		public function freeAll():void
		{
			_index = 0;
		}
		
		public function dispose():void
		{
			_pool.length = 0;
		}
	}
}