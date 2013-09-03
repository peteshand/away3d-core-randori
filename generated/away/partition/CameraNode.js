/** Compiled by the Randori compiler v0.2.6.2 on Mon Sep 02 23:32:29 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.partition == "undefined")
	away.partition = {};

away.partition.CameraNode = function(camera) {
	away.partition.EntityNode.call(this, camera);
};

away.partition.CameraNode.prototype.acceptTraverser = function(traverser) {
};

$inherit(away.partition.CameraNode, away.partition.EntityNode);

away.partition.CameraNode.className = "away.partition.CameraNode";

away.partition.CameraNode.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.partition.CameraNode.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.partition.CameraNode.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'camera', t:'away.cameras.Camera3D'});
			break;
		case 1:
			p = away.partition.EntityNode.injectionPoints(t);
			break;
		case 2:
			p = away.partition.EntityNode.injectionPoints(t);
			break;
		case 3:
			p = away.partition.EntityNode.injectionPoints(t);
			break;
		default:
			p = [];
			break;
	}
	return p;
};

