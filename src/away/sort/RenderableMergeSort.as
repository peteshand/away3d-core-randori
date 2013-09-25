/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package away.sort
{
	import away.traverse.EntityCollector;
	import away.data.RenderableListItem;
	public class RenderableMergeSort implements IEntitySorter
	{
		public function RenderableMergeSort():void
		{
		}
		
		public function sort(collector:EntityCollector):void
		{
			collector.opaqueRenderableHead = this.mergeSortByMaterial(collector.opaqueRenderableHead);
			collector.blendedRenderableHead = this.mergeSortByDepth(collector.blendedRenderableHead);
		}
		
		private function mergeSortByDepth(head:RenderableListItem):RenderableListItem
		{
			var headB:RenderableListItem;
			var fast:RenderableListItem;
			var slow:RenderableListItem;
			
			if( !head || !head.next )
			{
				return head;
			}
			
			// split in two sublists
			slow = head;
			fast = head.next;
			
			while (fast) {
				fast = fast.next;
				if (fast) {
					slow = slow.next;
					fast = fast.next;
				}
			}
			
			headB = slow.next;
			slow.next = null;
			
			// recurse
			head = this.mergeSortByDepth(head);
			headB = this.mergeSortByDepth(headB);
			
			// merge sublists while respecting order
			var result:RenderableListItem;
			var curr:RenderableListItem;
			var l:RenderableListItem;
			
			if (!head)
				return headB;
			if (!headB)
				return head;
			
			while (head && headB) {
				if (head.zIndex < headB.zIndex) {
					l = head;
					head = head.next;
				} else {
					l = headB;
					headB = headB.next;
				}
				
				if (!result)
					result = l;
				else
					curr.next = l;
				
				curr = l;
			}
			
			if (head)
				curr.next = head;
			else if (headB)
				curr.next = headB;
			
			return result;
		}
		
		private function mergeSortByMaterial(head:RenderableListItem):RenderableListItem
		{
			var headB:RenderableListItem;
			var fast:RenderableListItem, slow:RenderableListItem;
			
			if (!head || !head.next)
			{
				return head;
			}
			
			// split in two sublists
			slow = head;
			fast = head.next;
			
			while (fast) {
				fast = fast.next;
				if (fast) {
					slow = slow.next;
					fast = fast.next;
				}
			}
			
			headB = slow.next;
			slow.next = null;
			
			// recurse
			head = this.mergeSortByMaterial(head);
			headB = this.mergeSortByMaterial(headB);
			
			// merge sublists while respecting order
			var result:RenderableListItem;
			var curr:RenderableListItem;
			var l:RenderableListItem;
			var cmp:Number = 0;
			
			if (!head)
				return headB;
			if (!headB)
				return head;
			
			while (head && headB && head != null && headB != null) {
				
				// first sort per render order id (reduces program3D switches),
				// then on material id (reduces setting props),
				// then on zIndex (reduces overdraw)
				var aid:Number = head.renderOrderId;
				var bid:Number = headB.renderOrderId;
				
				if (aid == bid) {
					var ma:Number = head.materialId;
					var mb:Number = headB.materialId;
					
					if (ma == mb) {
						if (head.zIndex < headB.zIndex)
							cmp = 1;
						else
							cmp = -1;
					} else if (ma > mb)
						cmp = 1;
					else
						cmp = -1;
				} else if (aid > bid)
					cmp = 1;
				else
					cmp = -1;
				
				if (cmp < 0) {
					l = head;
					head = head.next;
				} else {
					l = headB;
					headB = headB.next;
				}
				
				if (!result) {
					result = l;
					curr = l;
				} else {
					curr.next = l;
					curr = l;
				}
			}
			
			if (head)
				curr.next = head;
			else if (headB)
				curr.next = headB;
			
			return result;
		}
	}
}