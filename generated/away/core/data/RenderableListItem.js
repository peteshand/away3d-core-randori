/** Compiled by the Randori compiler v0.2.5.2 on Wed Oct 09 20:30:39 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.core == "undefined")
	away.core = {};
if (typeof away.core.data == "undefined")
	away.core.data = {};

away.core.data.RenderableListItem = function() {
this.renderable = null;
this.zIndex = 0;
this.materialId = 0;
this.cascaded = false;
this.next = null;
this.renderSceneTransform = null;
this.renderOrderId = 0;
};

away.core.data.RenderableListItem.className = "away.core.data.RenderableListItem";

away.core.data.RenderableListItem.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.core.data.RenderableListItem.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.core.data.RenderableListItem.injectionPoints = function(t) {
	return [];
};
