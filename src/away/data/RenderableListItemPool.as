/** * ... * @author Gary Paluk - http://www.plugin.io */

package away.data
{
	public class RenderableListItemPool
	{
		
		private var _pool:Vector.<RenderableListItem>;
		private var _index:Number = 0;
		private var _poolSize:Number = 0;
		
		public function RenderableListItemPool():void
		{
			_pool = new <RenderableListItem>[];
		}
		
		public function getItem():RenderableListItem
		{
			if( _index == _poolSize )
			{
				var item:RenderableListItem = new RenderableListItem();
				_pool[_index++] = item;
				++_poolSize;
				return item;
			} else
			{
				return _pool[_index++];
			}
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