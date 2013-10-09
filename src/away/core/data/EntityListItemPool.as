/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package away.core.data
{
	public class EntityListItemPool
	{
		
		private var _pool:Vector.<EntityListItem>;
		private var _index:Number = 0;
		private var _poolSize:Number = 0;
		
		public function EntityListItemPool():void
		{
			this._pool = new <EntityListItem>[];
		}
		
		public function getItem():EntityListItem
		{
			var item:EntityListItem;
			if( this._index == this._poolSize )
			{
				item = new EntityListItem();
				this._pool[this._index++] = item;
				++this._poolSize;
			}
			else
			{
				item = this._pool[this._index++];
			}
			return item;
		}
		
		public function freeAll():void
		{
			this._index = 0;
		}
		
		public function dispose():void
		{
			this._pool.length = 0;
		}
	}
}