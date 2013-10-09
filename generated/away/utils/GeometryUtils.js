/** Compiled by the Randori compiler v0.2.5.2 on Wed Oct 09 20:30:40 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.utils == "undefined")
	away.utils = {};

away.utils.GeometryUtils = function() {
	
};

away.utils.GeometryUtils.fromVectors = function(verts, indices, uvs, normals, tangents, weights, jointIndices, triangleOffset) {
	triangleOffset = triangleOffset || 0;
	var LIMIT_VERTS = 3 * 0xffff;
	var LIMIT_INDICES = 15 * 0xffff;
	var subs = [];
	if (uvs && !uvs.length)
		uvs = null;
	if (normals && !normals.length)
		normals = null;
	if (tangents && !tangents.length)
		tangents = null;
	if (weights && !weights.length)
		weights = null;
	if (jointIndices && !jointIndices.length)
		jointIndices = null;
	if ((indices.length >= LIMIT_INDICES) || (verts.length >= LIMIT_VERTS)) {
		var i;
		var len;
		var outIndex;
		var j;
		var splitVerts = away.utils.VectorInit.Num(0, 0);
		var splitIndices = away.utils.VectorInit.Num(0, 0);
		var splitUvs = (uvs != null) ? away.utils.VectorInit.Num(0, 0) : null;
		var splitNormals = (normals != null) ? away.utils.VectorInit.Num(0, 0) : null;
		var splitTangents = (tangents != null) ? away.utils.VectorInit.Num(0, 0) : null;
		var splitWeights = (weights != null) ? away.utils.VectorInit.Num(0, 0) : null;
		var splitJointIndices = (jointIndices != null) ? away.utils.VectorInit.Num(0, 0) : null;
		var mappings = away.utils.VectorInit.Num(verts.length / 3, 0);
		i = mappings.length;
		while (i-- > 0) {
			mappings[i] = -1;
		}
		var originalIndex;
		var splitIndex;
		var o0;
		var o1;
		var o2;
		var s0;
		var s1;
		var s2;
		var su;
		var ou;
		var sv;
		var ov;
		outIndex = 0;
		len = indices.length;
		for (i = 0; i < len; i += 3) {
			splitIndex = splitVerts.length + 6;
			if (((outIndex + 2) >= LIMIT_INDICES) || (splitIndex >= LIMIT_VERTS)) {
				subs.push(away.utils.GeometryUtils.constructSubGeometry(splitVerts, splitIndices, splitUvs, splitNormals, splitTangents, splitWeights, splitJointIndices, triangleOffset));
				splitVerts = away.utils.VectorInit.Num(0, 0);
				splitIndices = away.utils.VectorInit.Num(0, 0);
				splitUvs = (uvs != null) ? away.utils.VectorInit.Num(0, 0) : null;
				splitNormals = (normals != null) ? away.utils.VectorInit.Num(0, 0) : null;
				splitTangents = (tangents != null) ? away.utils.VectorInit.Num(0, 0) : null;
				splitWeights = (weights != null) ? away.utils.VectorInit.Num(0, 0) : null;
				splitJointIndices = (jointIndices != null) ? away.utils.VectorInit.Num(0, 0) : null;
				splitIndex = 0;
				j = mappings.length;
				while (j-- > 0) {
					mappings[j] = -1;
				}
				outIndex = 0;
			}
			for (j = 0; j < 3; j++) {
				originalIndex = indices[i + j];
				if (mappings[originalIndex] >= 0) {
					splitIndex = mappings[originalIndex];
				} else {
					o0 = originalIndex * 3 + 0;
					o1 = originalIndex * 3 + 1;
					o2 = originalIndex * 3 + 2;
					splitIndex = splitVerts.length / 3;
					s0 = splitIndex * 3 + 0;
					s1 = splitIndex * 3 + 1;
					s2 = splitIndex * 3 + 2;
					splitVerts[s0] = verts[o0];
					splitVerts[s1] = verts[o1];
					splitVerts[s2] = verts[o2];
					if (uvs) {
						su = splitIndex * 2 + 0;
						sv = splitIndex * 2 + 1;
						ou = originalIndex * 2 + 0;
						ov = originalIndex * 2 + 1;
						splitUvs[su] = uvs[ou];
						splitUvs[sv] = uvs[ov];
					}
					if (normals) {
						splitNormals[s0] = normals[o0];
						splitNormals[s1] = normals[o1];
						splitNormals[s2] = normals[o2];
					}
					if (tangents) {
						splitTangents[s0] = tangents[o0];
						splitTangents[s1] = tangents[o1];
						splitTangents[s2] = tangents[o2];
					}
					if (weights) {
						splitWeights[s0] = weights[o0];
						splitWeights[s1] = weights[o1];
						splitWeights[s2] = weights[o2];
					}
					if (jointIndices) {
						splitJointIndices[s0] = jointIndices[o0];
						splitJointIndices[s1] = jointIndices[o1];
						splitJointIndices[s2] = jointIndices[o2];
					}
					mappings[originalIndex] = splitIndex;
				}
				splitIndices[outIndex + j] = splitIndex;
			}
			outIndex += 3;
		}
		if (splitVerts.length > 0) {
			subs.push(away.utils.GeometryUtils.constructSubGeometry(splitVerts, splitIndices, splitUvs, splitNormals, splitTangents, splitWeights, splitJointIndices, triangleOffset));
		}
	} else {
		subs.push(away.utils.GeometryUtils.constructSubGeometry(verts, indices, uvs, normals, tangents, weights, jointIndices, triangleOffset));
	}
	return subs;
};

away.utils.GeometryUtils.constructSubGeometry = function(verts, indices, uvs, normals, tangents, weights, jointIndices, triangleOffset) {
	var sub;
	if (weights && jointIndices) {
		away.utils.Debug.throwPIR("GeometryUtils", "constructSubGeometry", "Dependency: SkinnedSubGeometry");
		sub = new away.core.base.SkinnedSubGeometry(weights.length / (verts.length / 3));
		var ssg = sub;
	} else {
		sub = new away.core.base.CompactSubGeometry();
	}
	sub.updateIndexData(indices);
	sub.fromVectors(verts, uvs, normals, tangents);
	return sub;
};

away.utils.GeometryUtils.interleaveBuffers = function(numVertices, vertices, normals, tangents, uvs, suvs) {
	var i, compIndex, uvCompIndex, interleavedCompIndex;
	var interleavedBuffer;
	interleavedBuffer = away.utils.VectorInit.Num(0, 0);
	for (i = 0; i < numVertices; ++i) {
		uvCompIndex = i * 2;
		compIndex = i * 3;
		interleavedCompIndex = i * 13;
		interleavedBuffer[interleavedCompIndex] = vertices ? vertices[compIndex] : 0;
		interleavedBuffer[interleavedCompIndex + 1] = vertices ? vertices[compIndex + 1] : 0;
		interleavedBuffer[interleavedCompIndex + 2] = vertices ? vertices[compIndex + 2] : 0;
		interleavedBuffer[interleavedCompIndex + 3] = normals ? normals[compIndex] : 0;
		interleavedBuffer[interleavedCompIndex + 4] = normals ? normals[compIndex + 1] : 0;
		interleavedBuffer[interleavedCompIndex + 5] = normals ? normals[compIndex + 2] : 0;
		interleavedBuffer[interleavedCompIndex + 6] = tangents ? tangents[compIndex] : 0;
		interleavedBuffer[interleavedCompIndex + 7] = tangents ? tangents[compIndex + 1] : 0;
		interleavedBuffer[interleavedCompIndex + 8] = tangents ? tangents[compIndex + 2] : 0;
		interleavedBuffer[interleavedCompIndex + 9] = uvs ? uvs[uvCompIndex] : 0;
		interleavedBuffer[interleavedCompIndex + 10] = uvs ? uvs[uvCompIndex + 1] : 0;
		interleavedBuffer[interleavedCompIndex + 11] = suvs ? suvs[uvCompIndex] : 0;
		interleavedBuffer[interleavedCompIndex + 12] = suvs ? suvs[uvCompIndex + 1] : 0;
	}
	return interleavedBuffer;
};

away.utils.GeometryUtils.getMeshSubgeometryIndex = function(subGeometry) {
	var index;
	var subGeometries = subGeometry.get_parentGeometry().get_subGeometries();
	for (var i = 0; i < subGeometries.length; ++i) {
		if (subGeometries[i] == subGeometry) {
			index = i;
			break;
		}
	}
	return index;
};

away.utils.GeometryUtils.getMeshSubMeshIndex = function(subMesh) {
	var index;
	var subMeshes = subMesh.get_iParentMesh().get_subMeshes();
	for (var i = 0; i < subMeshes.length; ++i) {
		if (subMeshes[i] == subMesh) {
			index = i;
			break;
		}
	}
	return index;
};

away.utils.GeometryUtils.className = "away.utils.GeometryUtils";

away.utils.GeometryUtils.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.utils.Debug');
	p.push('away.core.base.CompactSubGeometry');
	p.push('away.core.base.SkinnedSubGeometry');
	p.push('away.utils.VectorInit');
	return p;
};

away.utils.GeometryUtils.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.utils.GeometryUtils.injectionPoints = function(t) {
	return [];
};
