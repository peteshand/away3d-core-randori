/** Compiled by the Randori compiler v0.2.5.2 on Wed Oct 09 20:30:37 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.core == "undefined")
	away.core = {};
if (typeof away.core.partition == "undefined")
	away.core.partition = {};

away.core.partition.CameraNode = function(camera) {
	away.core.partition.EntityNode.call(this, camera);
};

away.core.partition.CameraNode.prototype.acceptTraverser = function(traverser) {
};

$inherit(away.core.partition.CameraNode, away.core.partition.EntityNode);

away.core.partition.CameraNode.className = "away.core.partition.CameraNode";

away.core.partition.CameraNode.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.core.partition.CameraNode.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.core.partition.CameraNode.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'camera', t:'away.cameras.Camera3D'});
			break;
		case 1:
			p = away.core.partition.EntityNode.injectionPoints(t);
			break;
		case 2:
			p = away.core.partition.EntityNode.injectionPoints(t);
			break;
		case 3:
			p = away.core.partition.EntityNode.injectionPoints(t);
			break;
		default:
			p = [];
			break;
	}
	return p;
};

