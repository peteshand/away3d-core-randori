/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package away.core.data
{
	public class RenderableListItemPool
	{
		
		private var _pool:Vector.<RenderableListItem>;
		private var _index:Number = 0;
		private var _poolSize:Number = 0;
		
		public function RenderableListItemPool():void
		{
			this._pool = new <RenderableListItem>[];
		}
		
		public function getItem():RenderableListItem
		{
			if( this._index == this._poolSize )
			{
				var item:RenderableListItem = new RenderableListItem();
				this._pool[this._index++] = item;
				++this._poolSize;
				return item;
			} else
			{
				return this._pool[this._index++];
			}
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