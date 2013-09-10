/** Compiled by the Randori compiler v0.2.6.2 on Thu Sep 05 22:19:27 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.data == "undefined")
	away.data = {};

away.data.RenderableListItem = function() {
this.renderable = null;
this.zIndex = 0;
this.materialId = 0;
this.cascaded = null;
this.next = null;
this.renderSceneTransform = null;
this.renderOrderId = 0;
};

away.data.RenderableListItem.className = "away.data.RenderableListItem";

away.data.RenderableListItem.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.data.RenderableListItem.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.data.RenderableListItem.injectionPoints = function(t) {
	return [];
};
