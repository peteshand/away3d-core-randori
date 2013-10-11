/** Compiled by the Randori compiler v0.2.5.2 on Sat Oct 12 02:16:07 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.materials == "undefined")
	away.materials = {};

away.materials.SegmentMaterial = function(thickness) {
	this._screenPass = null;
	thickness = thickness || 1.25;
	away.materials.MaterialBase.call(this);
	this.set_bothSides(true);
	this.pAddPass(this._screenPass = new away.materials.passes.SegmentPass(thickness));
	this._screenPass.set_material(this);
};

$inherit(away.materials.SegmentMaterial, away.materials.MaterialBase);

away.materials.SegmentMaterial.className = "away.materials.SegmentMaterial";

away.materials.SegmentMaterial.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.materials.passes.SegmentPass');
	return p;
};

away.materials.SegmentMaterial.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.materials.SegmentMaterial.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'thickness', t:'Number'});
			break;
		case 1:
			p = away.materials.MaterialBase.injectionPoints(t);
			break;
		case 2:
			p = away.materials.MaterialBase.injectionPoints(t);
			break;
		case 3:
			p = away.materials.MaterialBase.injectionPoints(t);
			break;
		default:
			p = [];
			break;
	}
	return p;
};

