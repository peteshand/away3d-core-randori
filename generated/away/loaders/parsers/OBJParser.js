/** Compiled by the Randori compiler v0.2.6.2 on Wed Sep 04 21:18:41 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.loaders == "undefined")
	away.loaders = {};
if (typeof away.loaders.parsers == "undefined")
	away.loaders.parsers = {};

away.loaders.parsers.OBJParser = function(scale) {
	this._charIndex = 0;
	this._currentGroup = null;
	this._stringLength = 0;
	this._materialIDs = null;
	this._vertexNormals = null;
	this._materialSpecularData = null;
	this._vertexIndex = 0;
	this._realIndices = undefined;
	this._vertices = null;
	this._currentObject = null;
	this._currentMaterialGroup = null;
	this._startedParsing = null;
	this._textData = null;
	this._scale = 0;
	this._materialLoaded = null;
	this._mtlLibLoaded = true;
	this._objects = null;
	this._lastMtlID = null;
	this._activeMaterialID = "";
	this._uvs = null;
	this._meshes = null;
	this._objectIndex = 0;
	this._oldIndex = 0;
	this._mtlLib = null;
	away.loaders.parsers.ParserBase.call(this, away.loaders.parsers.ParserDataFormat.PLAIN_TEXT);
	this._scale = scale;
};

away.loaders.parsers.OBJParser.prototype.set_scale = function(value) {
	this._scale = value;
};

away.loaders.parsers.OBJParser.supportsType = function(extension) {
	extension = extension.toLowerCase();
	return extension == "obj";
};

away.loaders.parsers.OBJParser.supportsData = function(data) {
	var content = away.loaders.parsers.utils.ParserUtil.toString(data);
	var hasV = false;
	var hasF = false;
	if (content) {
		hasV = content.indexOf("\nv ", 0) != -1;
		hasF = content.indexOf("\nf ", 0) != -1;
	}
	return hasV && hasF;
};

away.loaders.parsers.OBJParser.prototype._iResolveDependency = function(resourceDependency) {
	if (resourceDependency.get_id() == "mtl") {
		var str = away.loaders.parsers.utils.ParserUtil.toString(resourceDependency.get_data());
		this.parseMtl(str);
	} else {
		var asset;
		if (resourceDependency.get_assets().length != 1) {
			return;
		}
		asset = resourceDependency.get_assets()[0];
		if (asset.get_assetType() == away.library.assets.AssetType.TEXTURE) {
			var lm = new away.loaders.parsers.OBJParser$LoadedMaterial();
			lm.materialID = resourceDependency.get_id();
			lm.texture = asset;
			this._materialLoaded.push(lm);
			if (this._meshes.length > 0) {
				this.applyMaterial(lm);
			}
		}
	}
};

away.loaders.parsers.OBJParser.prototype._iResolveDependencyFailure = function(resourceDependency) {
	if (resourceDependency.get_id() == "mtl") {
		this._mtlLib = false;
		this._mtlLibLoaded = false;
	} else {
		var lm = new away.loaders.parsers.OBJParser$LoadedMaterial();
		lm.materialID = resourceDependency.get_id();
		this._materialLoaded.push(lm);
	}
	if (this._meshes.length > 0)
		this.applyMaterial(lm);
};

away.loaders.parsers.OBJParser.prototype._pProceedParsing = function() {
	var line;
	var creturn = String.fromCharCode(10);
	var trunk;
	if (!this._startedParsing) {
		this._textData = this._pGetTextData();
		this._textData = this._textData.replace(/\\[\r\n]+\s*/gm, " ");
	}
	if (this._textData.indexOf(creturn, 0) == -1)
		creturn = String.fromCharCode(13);
	if (!this._startedParsing) {
		this._startedParsing = true;
		this._vertices = [];
		this._vertexNormals = [];
		this._materialIDs = [];
		this._materialLoaded = [];
		this._meshes = [];
		this._uvs = [];
		this._stringLength = this._textData.length;
		this._charIndex = this._textData.indexOf(creturn, 0);
		this._oldIndex = 0;
		this._objects = [];
		this._objectIndex = 0;
	}
	while (this._charIndex < this._stringLength && this._pHasTime()) {
		this._charIndex = this._textData.indexOf(creturn, this._oldIndex);
		if (this._charIndex == -1)
			this._charIndex = this._stringLength;
		line = this._textData.substring(this._oldIndex, this._charIndex);
		line = line.split("\r", 4.294967295E9).join("");
		line = line.replace("  ", " ");
		trunk = line.split(" ", 4.294967295E9);
		this._oldIndex = this._charIndex + 1;
		this.parseLine(trunk);
		if (this.get_parsingPaused()) {
			return away.loaders.parsers.ParserBase.MORE_TO_PARSE;
		}
	}
	if (this._charIndex >= this._stringLength) {
		if (this._mtlLib && !this._mtlLibLoaded) {
			return away.loaders.parsers.ParserBase.MORE_TO_PARSE;
		}
		this.translate();
		this.applyMaterials();
		return away.loaders.parsers.ParserBase.PARSING_DONE;
	}
	return away.loaders.parsers.ParserBase.MORE_TO_PARSE;
};

away.loaders.parsers.OBJParser.prototype.parseLine = function(trunk) {
	switch (trunk[0]) {
		case "mtllib":
			this._mtlLib = true;
			this._mtlLibLoaded = false;
			this.loadMtl(trunk[1]);
			break;
		case "g":
			this.createGroup(trunk);
			break;
		case "o":
			this.createObject(trunk);
			break;
		case "usemtl":
			if (this._mtlLib) {
				if (!trunk[1])
					trunk[1] = "def000";
				this._materialIDs.push(trunk[1]);
				this._activeMaterialID = trunk[1];
				if (this._currentGroup)
					this._currentGroup.materialID = this._activeMaterialID;
			}
			break;
		case "v":
			this.parseVertex(trunk);
			break;
		case "vt":
			this.parseUV(trunk);
			break;
		case "vn":
			this.parseVertexNormal(trunk);
			break;
		case "f":
			this.parseFace(trunk);
	}
};

away.loaders.parsers.OBJParser.prototype.translate = function() {
	for (var objIndex = 0; objIndex < this._objects.length; ++objIndex) {
		var groups = this._objects[objIndex].groups;
		var numGroups = groups.length;
		var materialGroups;
		var numMaterialGroups;
		var geometry;
		var mesh;
		var m;
		var sm;
		var bmMaterial;
		for (var g = 0; g < numGroups; ++g) {
			geometry = new away.base.Geometry();
			materialGroups = groups[g].materialGroups;
			numMaterialGroups = materialGroups.length;
			for (m = 0; m < numMaterialGroups; ++m)
				this.translateMaterialGroup(materialGroups[m], geometry);
			if (geometry.get_subGeometries().length == 0)
				continue;
			this._pFinalizeAsset(IAsset(geometry));
			if (this.get_materialMode() < 2)
				bmMaterial = new away.materials.TextureMaterial(away.materials.utils.DefaultMaterialManager.getDefaultTexture(), true, false, false);
			else
				bmMaterial = new away.materials.TextureMultiPassMaterial(away.materials.utils.DefaultMaterialManager.getDefaultTexture(), true, false, true);
			mesh = new away.entities.Mesh(geometry, bmMaterial);
			if (this._objects[objIndex].name) {
				mesh.set_name(this._objects[objIndex].name);
			} else if (groups[g].name) {
				mesh.set_name(groups[g].name);
			} else {
				mesh.set_name("");
			}
			this._meshes.push(mesh);
			if (groups[g].materialID != "")
				bmMaterial.set_name(groups[g].materialID + "~" + mesh.get_name());
			else
				bmMaterial.set_name(this._lastMtlID + "~" + mesh.get_name());
			if (mesh.get_subMeshes().length > 1) {
				for (sm = 1; sm < mesh.get_subMeshes().length; ++sm)
					mesh.get_subMeshes()[sm].material = bmMaterial;
			}
			this._pFinalizeAsset(IAsset(mesh));
		}
	}
};

away.loaders.parsers.OBJParser.prototype.translateMaterialGroup = function(materialGroup, geometry) {
	var faces = materialGroup.faces;
	var face;
	var numFaces = faces.length;
	var numVerts;
	var subs;
	var vertices = [];
	var uvs = [];
	var normals = [];
	var indices = [];
	this._realIndices = [];
	this._vertexIndex = 0;
	var j;
	for (var i = 0; i < numFaces; ++i) {
		face = faces[i];
		numVerts = face.indexIds.length - 1;
		for (j = 1; j < numVerts; ++j) {
			this.translateVertexData(face, j, vertices, uvs, indices, normals);
			this.translateVertexData(face, 0, vertices, uvs, indices, normals);
			this.translateVertexData(face, j + 1, vertices, uvs, indices, normals);
		}
	}
	if (vertices.length > 0) {
		subs = away.utils.GeometryUtils.fromVectors(vertices, indices, uvs, normals, null, null, null, 0);
		for (i = 0; i < subs.length; i++) {
			geometry.addSubGeometry(subs[i]);
		}
	}
};

away.loaders.parsers.OBJParser.prototype.translateVertexData = function(face, vertexIndex, vertices, uvs, indices, normals) {
	var index;
	var vertex;
	var vertexNormal;
	var uv;
	if (!this._realIndices[face.indexIds[vertexIndex]]) {
		index = this._vertexIndex;
		this._realIndices[face.indexIds[vertexIndex]] = ++this._vertexIndex;
		vertex = this._vertices[face.vertexIndices[vertexIndex] - 1];
		vertices.push(vertex.get_x() * this._scale, vertex.get_y() * this._scale, vertex.get_z() * this._scale);
		if (face.normalIndices.length > 0) {
			vertexNormal = this._vertexNormals[face.normalIndices[vertexIndex] - 1];
			normals.push(vertexNormal.get_x(), vertexNormal.get_y(), vertexNormal.get_z());
		}
		if (face.uvIndices.length > 0) {
			try {
				uv = this._uvs[face.uvIndices[vertexIndex] - 1];
				uvs.push(uv.get_u(), uv.get_v());
			} catch (e) {
				switch (vertexIndex) {
					case 0:
						uvs.push(0, 1);
						break;
					case 1:
						uvs.push(.5, 0);
						break;
					case 2:
						uvs.push(1, 1);
				}
			}
		}
	} else {
		index = this._realIndices[face.indexIds[vertexIndex]] - 1;
	}
	indices.push(index);
};

away.loaders.parsers.OBJParser.prototype.createObject = function(trunk) {
	this._currentGroup = null;
	this._currentMaterialGroup = null;
	this._objects.push(this._currentObject = new away.loaders.parsers.OBJParser$ObjectGroup());
	if (trunk)
		this._currentObject.name = trunk[1];
};

away.loaders.parsers.OBJParser.prototype.createGroup = function(trunk) {
	if (!this._currentObject)
		this.createObject(null);
	this._currentGroup = new away.loaders.parsers.OBJParser$Group();
	this._currentGroup.materialID = this._activeMaterialID;
	if (trunk)
		this._currentGroup.name = trunk[1];
	this._currentObject.groups.push(this._currentGroup);
	this.createMaterialGroup(null);
};

away.loaders.parsers.OBJParser.prototype.createMaterialGroup = function(trunk) {
	this._currentMaterialGroup = new away.loaders.parsers.OBJParser$MaterialGroup();
	if (trunk)
		this._currentMaterialGroup.url = trunk[1];
	this._currentGroup.materialGroups.push(this._currentMaterialGroup);
};

away.loaders.parsers.OBJParser.prototype.parseVertex = function(trunk) {
	var v1, v2, v3;
	if (trunk.length > 4) {
		var nTrunk = [];
		var val;
		for (var i = 1; i < trunk.length; ++i) {
			val = parseFloat(trunk[i]);
			if (!isNaN(val))
				nTrunk.push(val);
		}
		v1 = nTrunk[0];
		v2 = nTrunk[1];
		v3 = -nTrunk[2];
		this._vertices.push(new away.base.data.Vertex(v1, v2, v3, 0));
	} else {
		v1 = parseFloat(trunk[1]);
		v2 = parseFloat(trunk[2]);
		v3 = -parseFloat(trunk[3]);
		this._vertices.push(new away.base.data.Vertex(v1, v2, v3, 0));
	}
};

away.loaders.parsers.OBJParser.prototype.parseUV = function(trunk) {
	if (trunk.length > 3) {
		var nTrunk = [];
		var val;
		for (var i = 1; i < trunk.length; ++i) {
			val = parseFloat(trunk[i]);
			if (!isNaN(val))
				nTrunk.push(val);
		}
		this._uvs.push(new away.base.data.UV(1 - nTrunk[0], 1 - nTrunk[1]));
	} else {
		this._uvs.push(new away.base.data.UV(1 - parseFloat(trunk[1]), 1 - parseFloat(trunk[2])));
	}
};

away.loaders.parsers.OBJParser.prototype.parseVertexNormal = function(trunk) {
	if (trunk.length > 4) {
		var nTrunk = [];
		var val;
		for (var i = 1; i < trunk.length; ++i) {
			val = parseFloat(trunk[i]);
			if (!isNaN(val))
				nTrunk.push(val);
		}
		this._vertexNormals.push(new away.base.data.Vertex(nTrunk[0], nTrunk[1], -nTrunk[2], 0));
	} else {
		this._vertexNormals.push(new away.base.data.Vertex(parseFloat(trunk[1]), parseFloat(trunk[2]), -parseFloat(trunk[3]), 0));
	}
};

away.loaders.parsers.OBJParser.prototype.parseFace = function(trunk) {
	var len = trunk.length;
	var face = new away.loaders.parsers.OBJParser$FaceData();
	if (!this._currentGroup) {
		this.createGroup(null);
	}
	var indices;
	for (var i = 1; i < len; ++i) {
		if (trunk[i] == "") {
			continue;
		}
		indices = trunk[i].split("\/");
		face.vertexIndices.push(this.parseIndex(parseInt(indices[0], 0), this._vertices.length));
		if (indices[1] && indices[1].length > 0)
			face.uvIndices.push(this.parseIndex(parseInt(indices[1], 0), this._uvs.length));
		if (indices[2] && indices[2].length > 0)
			face.normalIndices.push(this.parseIndex(parseInt(indices[2], 0), this._vertexNormals.length));
		face.indexIds.push(trunk[i]);
	}
	this._currentMaterialGroup.faces.push(face);
};

away.loaders.parsers.OBJParser.prototype.parseIndex = function(index, length) {
	if (index < 0)
		return index + length + 1;
	else
		return index;
};

away.loaders.parsers.OBJParser.prototype.parseMtl = function(data) {
	var materialDefinitions = data.split("newmtl", 4.294967295E9);
	var lines;
	var trunk;
	var j;
	var basicSpecularMethod;
	var useSpecular;
	var useColor;
	var diffuseColor;
	var ambientColor;
	var specularColor;
	var specular;
	var alpha;
	var mapkd;
	for (var i = 0; i < materialDefinitions.length; ++i) {
		lines = materialDefinitions[i].split("\r").join("").split("\n");
		if (lines.length == 1)
			lines = materialDefinitions[i].split(String.fromCharCode(13));
		diffuseColor = ambientColor = specularColor = 0xFFFFFF;
		specular = 0;
		useSpecular = false;
		useColor = false;
		alpha = 1;
		mapkd = "";
		for (j = 0; j < lines.length; ++j) {
			lines[j] = lines[j].replace(/\s+$/, "");
			if (lines[j].substring(0, 1) != "#" && (j == 0 || lines[j] != "")) {
				trunk = lines[j].split(" ");
				if (trunk[0].charCodeAt(0) == 9 || trunk[0].charCodeAt(0) == 32)
					trunk[0] = trunk[0].substring(1, trunk[0].length);
				if (j == 0) {
					this._lastMtlID = trunk.join("");
					this._lastMtlID = (this._lastMtlID == "") ? "def000" : this._lastMtlID;
				} else {
					switch (trunk[0]) {
						case "Ka":
							if (trunk[1] && !isNaN(trunk[1]) && trunk[2] && !isNaN(trunk[2]) && trunk[3] && !isNaN(trunk[3]))
								ambientColor = trunk[1] * 255 << 16 | trunk[2] * 255 << 8 | trunk[3] * 255;
							break;
						case "Ks":
							if (trunk[1] && !isNaN(trunk[1]) && trunk[2] && !isNaN(trunk[2]) && trunk[3] && !isNaN(trunk[3])) {
								specularColor = trunk[1] * 255 << 16 | trunk[2] * 255 << 8 | trunk[3] * 255;
								useSpecular = true;
							}
							break;
						case "Ns":
							if (trunk[1] && !isNaN(trunk[1]))
								specular = trunk[1] * 0.001;
							if (specular == 0)
								useSpecular = false;
							break;
						case "Kd":
							if (trunk[1] && !isNaN(trunk[1]) && trunk[2] && !isNaN(trunk[2]) && trunk[3] && !isNaN(trunk[3])) {
								diffuseColor = trunk[1] * 255 << 16 | trunk[2] * 255 << 8 | trunk[3] * 255;
								useColor = true;
							}
							break;
						case "tr":
						
						case "d":
							if (trunk[1] && !isNaN(trunk[1]))
								alpha = trunk[1];
							break;
						case "map_Kd":
							mapkd = this.parseMapKdString(trunk);
							mapkd = mapkd.replace(/\\/g, "\/");
					}
				}
			}
		}
		if (mapkd != "") {
			if (useSpecular) {
				basicSpecularMethod = new away.materials.methods.BasicSpecularMethod();
				basicSpecularMethod.set_specularColor(specularColor);
				basicSpecularMethod.set_specular(specular);
				var specularData = new away.loaders.parsers.OBJParser$SpecularData();
				specularData.alpha = alpha;
				specularData.basicSpecularMethod = basicSpecularMethod;
				specularData.materialID = this._lastMtlID;
				if (!this._materialSpecularData)
					this._materialSpecularData = [];
				this._materialSpecularData.push(specularData);
			}
			this._pAddDependency(this._lastMtlID, new away.net.URLRequest(mapkd), false, null, false);
		} else if (useColor && !isNaN(diffuseColor)) {
			var lm = new away.loaders.parsers.OBJParser$LoadedMaterial();
			lm.materialID = this._lastMtlID;
			if (alpha == 0)
				console.log("Warning: an alpha value of 0 was found in mtl color tag (Tr or d) ref:" + this._lastMtlID + ", mesh(es) using it will be invisible!");
			var cm;
			if (this.get_materialMode() < 2) {
				cm = new away.materials.ColorMaterial(diffuseColor, 1);
				var colorMat = cm, 1;
				colorMat.set_alpha(alpha);
				colorMat.set_ambientColor(ambientColor);
				colorMat.set_repeat(true);
				if (useSpecular) {
					colorMat.set_specularColor(specularColor);
					colorMat.set_specular(specular);
				}
			} else {
				cm = new away.materials.ColorMultiPassMaterial(diffuseColor);
				var colorMultiMat = cm;
				colorMultiMat.set_ambientColor(ambientColor);
				colorMultiMat.set_repeat(true);
				if (useSpecular) {
					colorMultiMat.set_specularColor(specularColor);
					colorMultiMat.set_specular(specular);
				}
			}
			lm.cm = cm;
			this._materialLoaded.push(lm);
			if (this._meshes.length > 0)
				this.applyMaterial(lm);
		}
	}
	this._mtlLibLoaded = true;
};

away.loaders.parsers.OBJParser.prototype.parseMapKdString = function(trunk) {
	var url = "";
	var i;
	var breakflag;
	for (i = 1; i < trunk.length;) {
		switch (trunk[i]) {
			case "-blendu":
			
			case "-blendv":
			
			case "-cc":
			
			case "-clamp":
			
			case "-texres":
				i += 2;
				break;
			case "-mm":
				i += 3;
				break;
			case "-o":
			
			case "-s":
			
			case "-t":
				i += 4;
				continue;
			default:
				breakflag = true;
				break;
		}
		if (breakflag)
			break;
	}
	for (i; i < trunk.length; i++) {
		url += trunk[i];
		url += " ";
	}
	url = url.replace(/\s+$/, "");
	return url;
};

away.loaders.parsers.OBJParser.prototype.loadMtl = function(mtlurl) {
	this._pAddDependency("mtl", new away.net.URLRequest(mtlurl), true, null, false);
	this._pPauseAndRetrieveDependencies();
};

away.loaders.parsers.OBJParser.prototype.applyMaterial = function(lm) {
	var decomposeID;
	var mesh;
	var mat;
	var j;
	var specularData;
	for (var i = 0; i < this._meshes.length; ++i) {
		mesh = this._meshes[i];
		decomposeID = mesh.get_material().get_name().split("~", 4.294967295E9);
		if (decomposeID[0] == lm.materialID) {
			if (lm.cm) {
				if (mesh.get_material())
					mesh.set_material(null);
				mesh.set_material(lm.cm);
			} else if (lm.texture) {
				if (this.get_materialMode() < 2) {
					mat = mesh.get_material(), true, false, false;
					var tm = mat, true, false, false;
					tm.set_texture(lm.texture);
					tm.set_ambientColor(lm.ambientColor);
					tm.set_alpha(lm.alpha);
					tm.set_repeat(true);
					if (lm.specularMethod) {
						tm.set_specularMethod(null);
						tm.set_specularMethod(lm.specularMethod);
					} else if (this._materialSpecularData) {
						for (j = 0; j < this._materialSpecularData.length; ++j) {
							specularData = this._materialSpecularData[j];
							if (specularData.materialID == lm.materialID) {
								tm.set_specularMethod(null);
								tm.set_specularMethod(specularData.basicSpecularMethod);
								tm.set_ambientColor(specularData.ambientColor);
								tm.set_alpha(specularData.alpha);
								break;
							}
						}
					}
				} else {
					mat = mesh.get_material(), true, false, true;
					var tmMult = mat, true, false, true;
					tmMult.set_texture(lm.texture);
					tmMult.set_ambientColor(lm.ambientColor);
					tmMult.set_repeat(true);
					if (lm.specularMethod) {
						tmMult.set_specularMethod(null);
						tmMult.set_specularMethod(lm.specularMethod);
					} else if (this._materialSpecularData) {
						for (j = 0; j < this._materialSpecularData.length; ++j) {
							specularData = this._materialSpecularData[j];
							if (specularData.materialID == lm.materialID) {
								tmMult.set_specularMethod(null);
								tmMult.set_specularMethod(specularData.basicSpecularMethod);
								tmMult.set_ambientColor(specularData.ambientColor);
								break;
							}
						}
					}
				}
			}
			mesh.get_material().set_name(decomposeID[1] ? decomposeID[1] : decomposeID[0]);
			this._meshes.splice(i, 1);
			--i;
		}
	}
	if (lm.cm || mat)
		this._pFinalizeAsset(lm.cm || mat);
};

away.loaders.parsers.OBJParser.prototype.applyMaterials = function() {
	if (this._materialLoaded.length == 0)
		return;
	for (var i = 0; i < this._materialLoaded.length; ++i)
		this.applyMaterial(this._materialLoaded[i]);
};

$inherit(away.loaders.parsers.OBJParser, away.loaders.parsers.ParserBase);

away.loaders.parsers.OBJParser.className = "away.loaders.parsers.OBJParser";

away.loaders.parsers.OBJParser.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.base.data.Vertex');
	p.push('away.base.Geometry');
	p.push('away.materials.TextureMaterial');
	p.push('away.base.data.UV');
	p.push('away.loaders.parsers.ParserDataFormat');
	p.push('away.loaders.parsers.ParserBase');
	p.push('away.materials.ColorMultiPassMaterial');
	p.push('away.net.URLRequest');
	p.push('away.utils.GeometryUtils');
	p.push('away.loaders.misc.ResourceDependency');
	p.push('away.entities.Mesh');
	p.push('away.materials.methods.BasicSpecularMethod');
	p.push('away.loaders.parsers.utils.ParserUtil');
	p.push('away.materials.TextureMultiPassMaterial');
	p.push('away.materials.ColorMaterial');
	p.push('away.library.assets.AssetType');
	p.push('away.materials.utils.DefaultMaterialManager');
	return p;
};

away.loaders.parsers.OBJParser.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.loaders.parsers.OBJParser.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'scale', t:'Number'});
			break;
		case 1:
			p = away.loaders.parsers.ParserBase.injectionPoints(t);
			break;
		case 2:
			p = away.loaders.parsers.ParserBase.injectionPoints(t);
			break;
		case 3:
			p = away.loaders.parsers.ParserBase.injectionPoints(t);
			break;
		default:
			p = [];
			break;
	}
	return p;
};

away.loaders.parsers.OBJParser$ObjectGroup = function() {
this.name = null;
this.groups = [];
};

away.loaders.parsers.OBJParser$Group = function() {
this.name = null;
this.materialID = null;
this.materialGroups = [];
};

away.loaders.parsers.OBJParser$MaterialGroup = function() {
this.url = null;
this.faces = [];
};

away.loaders.parsers.OBJParser$SpecularData = function() {
this.materialID = null;
this.basicSpecularMethod = null;
this.ambientColor = 0xFFFFFF;
this.alpha = 1;
};

away.loaders.parsers.OBJParser$LoadedMaterial = function() {
this.cm = null;
this.ambientColor = 0xFFFFFF;
this.texture = null;
this.alpha = 1;
this.materialID = null;
this.specularMethod = null;
};

away.loaders.parsers.OBJParser$FaceData = function() {
this.vertexIndices = [];
this.uvIndices = [];
this.normalIndices = [];
this.indexIds = [];
};

