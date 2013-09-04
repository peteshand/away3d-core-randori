/** Compiled by the Randori compiler v0.2.6.2 on Wed Sep 04 21:18:39 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.sort == "undefined")
	away.sort = {};

away.sort.RenderableMergeSort = function() {
};

away.sort.RenderableMergeSort.prototype.sort = function(collector) {
	collector.set_opaqueRenderableHead(this.mergeSortByMaterial(collector.get_opaqueRenderableHead()));
	collector.set_blendedRenderableHead(this.mergeSortByDepth(collector.get_blendedRenderableHead()));
};

away.sort.RenderableMergeSort.prototype.mergeSortByDepth = function(head) {
	var headB;
	var fast;
	var slow;
	if (!head || !head.next) {
		return head;
	}
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
	head = this.mergeSortByDepth(head);
	headB = this.mergeSortByDepth(headB);
	var result;
	var curr;
	var l;
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
};

away.sort.RenderableMergeSort.prototype.mergeSortByMaterial = function(head) {
	var headB;
	var fast, slow;
	if (!head || !head.next) {
		return head;
	}
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
	head = this.mergeSortByMaterial(head);
	headB = this.mergeSortByMaterial(headB);
	var result;
	var curr;
	var l;
	var cmp = 0;
	if (!head)
		return headB;
	if (!headB)
		return head;
	while (head && headB && head != null && headB != null) {
		var aid = head.renderOrderId;
		var bid = headB.renderOrderId;
		if (aid == bid) {
			var ma = head.materialId;
			var mb = headB.materialId;
			if (ma == mb) {
				if (head.zIndex < headB.zIndex)
					cmp = 1;
				else
					cmp = -1;
			}
			else if (ma > mb)
				cmp = 1;
			else
				cmp = -1;
		}
		else if (aid > bid)
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
};

away.sort.RenderableMergeSort.className = "away.sort.RenderableMergeSort";

away.sort.RenderableMergeSort.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.traverse.EntityCollector');
	return p;
};

away.sort.RenderableMergeSort.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.sort.RenderableMergeSort.injectionPoints = function(t) {
	return [];
};
