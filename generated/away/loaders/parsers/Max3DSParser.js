/** Compiled by the Randori compiler v0.2.5.2 on Sat Oct 12 02:16:06 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.loaders == "undefined")
	away.loaders = {};
if (typeof away.loaders.parsers == "undefined")
	away.loaders.parsers = {};

away.loaders.parsers.Max3DSParser = function() {
	this._cur_mat = null;
	this._cur_mat_end = 0;
	this._cur_obj_end = 0;
	this._materials = null;
	this._byteData = null;
	this._cur_obj = null;
	this._textures = null;
	this._unfinalized_objects = null;
	away.loaders.parsers.ParserBase.call(this, away.loaders.parsers.ParserDataFormat.BINARY);
};

away.loaders.parsers.Max3DSParser.supportsType = function(extension) {
	extension = extension.toLowerCase();
	return extension == "3ds";
};

away.loaders.parsers.Max3DSParser.supportsData = function(data) {
	var ba;
	ba = away.loaders.parsers.utils.ParserUtil.toByteArray(data);
	if (ba) {
		ba.position = 0;
		if (ba.readShort() == 0x4d4d)
			return true;
	}
	return false;
};

away.loaders.parsers.Max3DSParser.prototype._iResolveDependency = function(resourceDependency) {
	if (resourceDependency.get_assets().length == 1) {
		var asset;
		asset = resourceDependency.get_assets()[0];
		if (asset.get_assetType() == away.library.assets.AssetType.TEXTURE) {
			var tex;
			tex = this._textures[resourceDependency.get_id()];
			tex.texture = asset;
		}
	}
};

away.loaders.parsers.Max3DSParser.prototype._iResolveDependencyFailure = function(resourceDependency) {
};

away.loaders.parsers.Max3DSParser.prototype._pProceedParsing = function() {
	if (!this._byteData) {
		this._byteData = this._pGetByteData();
		this._byteData.position = 0;
		this._textures = {};
		this._materials = {};
		this._unfinalized_objects = {};
	}
	while (this._pHasTime()) {
		if (this._cur_mat && this._byteData.position >= this._cur_mat_end)
			this.finalizeCurrentMaterial(); else if (this._cur_obj && this._byteData.position >= this._cur_obj_end) {
			this._unfinalized_objects[this._cur_obj.name] = this._cur_obj;
			this._cur_obj_end = 1.7976931348623157E308;
			this._cur_obj = null;
		}
		if (this._byteData.getBytesAvailable() > 0) {
			var cid;
			var len;
			var end;
			cid = this._byteData.readUnsignedShort();
			len = this._byteData.readUnsignedInt();
			end = this._byteData.position + (len - 6);
			switch (cid) {
				case 0x4D4D:
				
				case 0x3D3D:
				
				case 0xB000:
					continue;
					break;
				case 0xAFFF:
					this._cur_mat_end = end;
					this._cur_mat = this.parseMaterial();
					break;
				case 0x4000:
					this._cur_obj_end = end;
					this._cur_obj = new away.loaders.parsers.ObjectVO();
					this._cur_obj.name = this.readNulTermstring();
					this._cur_obj.materials = away.utils.VectorInit.Str(0, "");
					this._cur_obj.materialFaces = {};
					break;
				case 0x4100:
					this._cur_obj.type = away.library.assets.AssetType.MESH;
					break;
				case 0x4110:
					this.parseVertexList();
					break;
				case 0x4120:
					this.parseFaceList();
					break;
				case 0x4140:
					this.parseUVList();
					break;
				case 0x4130:
					this.parseFaceMaterialList();
					break;
				case 0x4160:
					this._cur_obj.transform = this.readTransform();
					break;
				case 0xB002:
					this.parseObjectAnimation(end);
					break;
				case 0x4150:
					this.parseSmoothingGroups();
					break;
				default:
					this._byteData.position += (len - 6);
					break;
			}
			if (this.get_dependencies().length) {
				this._pPauseAndRetrieveDependencies();
				break;
			}
		}
	}
	if (this._byteData.getBytesAvailable() || this._cur_obj || this._cur_mat)
		return away.loaders.parsers.ParserBase.MORE_TO_PARSE; else {
		var name;
		for (name in this._unfinalized_objects) {
			var obj;
			obj = this.constructObject(this._unfinalized_objects[name]);
			if (obj)
				this._pFinalizeAsset(obj, name);
		}
		return away.loaders.parsers.ParserBase.PARSING_DONE;
	}
};

away.loaders.parsers.Max3DSParser.prototype.parseMaterial = function() {
	var mat;
	mat = new away.loaders.parsers.MaterialVO();
	while (this._byteData.position < this._cur_mat_end) {
		var cid;
		var len;
		var end;
		cid = this._byteData.readUnsignedShort();
		len = this._byteData.readUnsignedInt();
		end = this._byteData.position + (len - 6);
		switch (cid) {
			case 0xA000:
				mat.name = this.readNulTermstring();
				break;
			case 0xA010:
				mat.ambientColor = this.readColor();
				break;
			case 0xA020:
				mat.diffuseColor = this.readColor();
				break;
			case 0xA030:
				mat.specularColor = this.readColor();
				break;
			case 0xA081:
				mat.twoSided = true;
				break;
			case 0xA200:
				mat.colorMap = this.parseTexture(end);
				break;
			case 0xA204:
				mat.specularMap = this.parseTexture(end);
				break;
			default:
				this._byteData.position = end;
				break;
		}
	}
	return mat;
};

away.loaders.parsers.Max3DSParser.prototype.parseTexture = function(end) {
	var tex;
	tex = new away.loaders.parsers.TextureVO();
	while (this._byteData.position < end) {
		var cid;
		var len;
		cid = this._byteData.readUnsignedShort();
		len = this._byteData.readUnsignedInt();
		switch (cid) {
			case 0xA300:
				tex.url = this.readNulTermstring();
				break;
			default:
				this._byteData.position += (len - 6);
				break;
		}
	}
	this._textures[tex.url] = tex;
	this._pAddDependency(tex.url, new away.core.net.URLRequest(tex.url), false, null, false);
	return tex;
};

away.loaders.parsers.Max3DSParser.prototype.parseVertexList = function() {
	var i;
	var len;
	var count;
	count = this._byteData.readUnsignedShort();
	this._cur_obj.verts = away.utils.VectorInit.Num(count * 3, 0);
	i = 0;
	len = this._cur_obj.verts.length;
	while (i < len) {
		var x, y, z;
		x = this._byteData.readFloat();
		y = this._byteData.readFloat();
		z = this._byteData.readFloat();
		this._cur_obj.verts[i++] = x;
		this._cur_obj.verts[i++] = z;
		this._cur_obj.verts[i++] = y;
	}
};

away.loaders.parsers.Max3DSParser.prototype.parseFaceList = function() {
	var i;
	var len;
	var count;
	count = this._byteData.readUnsignedShort();
	this._cur_obj.indices = away.utils.VectorInit.Num(count * 3, 0);
	i = 0;
	len = this._cur_obj.indices.length;
	while (i < len) {
		var i0, i1, i2;
		i0 = this._byteData.readUnsignedShort();
		i1 = this._byteData.readUnsignedShort();
		i2 = this._byteData.readUnsignedShort();
		this._cur_obj.indices[i++] = i0;
		this._cur_obj.indices[i++] = i2;
		this._cur_obj.indices[i++] = i1;
		this._byteData.position += 2;
	}
	this._cur_obj.smoothingGroups = away.utils.VectorInit.Num(count, 0);
};

away.loaders.parsers.Max3DSParser.prototype.parseSmoothingGroups = function() {
	var len = this._cur_obj.indices.length / 3;
	var i = 0;
	while (i < len) {
		this._cur_obj.smoothingGroups[i] = this._byteData.readUnsignedInt();
		i++;
	}
};

away.loaders.parsers.Max3DSParser.prototype.parseUVList = function() {
	var i;
	var len;
	var count;
	count = this._byteData.readUnsignedShort();
	this._cur_obj.uvs = away.utils.VectorInit.Num(count * 2, 0);
	i = 0;
	len = this._cur_obj.uvs.length;
	while (i < len) {
		this._cur_obj.uvs[i++] = this._byteData.readFloat();
		this._cur_obj.uvs[i++] = 1.0 - this._byteData.readFloat();
	}
};

away.loaders.parsers.Max3DSParser.prototype.parseFaceMaterialList = function() {
	var mat;
	var count;
	var i;
	var faces;
	mat = this.readNulTermstring();
	count = this._byteData.readUnsignedShort();
	faces = away.utils.VectorInit.Num(count, 0);
	i = 0;
	while (i < faces.length)
		faces[i++] = this._byteData.readUnsignedShort();
	this._cur_obj.materials.push(mat);
	this._cur_obj.materialFaces[mat] = faces;
};

away.loaders.parsers.Max3DSParser.prototype.parseObjectAnimation = function(end) {
	var vo;
	var obj;
	var pivot;
	var name;
	var hier;
	pivot = new away.core.geom.Vector3D(0, 0, 0, 0);
	while (this._byteData.position < end) {
		var cid;
		var len;
		cid = this._byteData.readUnsignedShort();
		len = this._byteData.readUnsignedInt();
		switch (cid) {
			case 0xb010:
				name = this.readNulTermstring();
				this._byteData.position += 4;
				hier = this._byteData.readShort();
				break;
			case 0xb013:
				pivot.x = this._byteData.readFloat();
				pivot.z = this._byteData.readFloat();
				pivot.y = this._byteData.readFloat();
				break;
			default:
				this._byteData.position += (len - 6);
				break;
		}
	}
	if (name != "$$$DUMMY" && this._unfinalized_objects.hasOwnProperty(name)) {
		vo = this._unfinalized_objects[name];
		obj = this.constructObject(vo, pivot);
		if (obj)
			this._pFinalizeAsset(obj, vo.name);
		delete this._unfinalized_objects[name];
	}
};

away.loaders.parsers.Max3DSParser.prototype.constructObject = function(obj, pivot) {
	pivot = pivot || null;
	if (obj.type == away.library.assets.AssetType.MESH) {
		var i;
		var subs;
		var geom;
		var mat;
		var mesh;
		var mtx;
		var vertices;
		var faces;
		if (obj.materials.length > 1)
			console.log("The Away3D 3DS parser does not support multiple materials per mesh at this point.");
		if (!obj.indices || obj.indices.length == 0)
			return null;
		vertices = away.utils.VectorInit.AnyClass(obj.verts.length / 3);
		faces = away.utils.VectorInit.AnyClass(obj.indices.length / 3);
		this.prepareData(vertices, faces, obj);
		this.applySmoothGroups(vertices, faces);
		obj.verts = away.utils.VectorInit.Num(vertices.length * 3, 0);
		for (i = 0; i < vertices.length; i++) {
			obj.verts[i * 3] = vertices[i].x;
			obj.verts[i * 3 + 1] = vertices[i].y;
			obj.verts[i * 3 + 2] = vertices[i].z;
		}
		obj.indices = away.utils.VectorInit.Num(faces.length * 3, 0);
		for (i = 0; i < faces.length; i++) {
			obj.indices[i * 3] = faces[i].a;
			obj.indices[i * 3 + 1] = faces[i].b;
			obj.indices[i * 3 + 2] = faces[i].c;
		}
		if (obj.uvs) {
			obj.uvs = away.utils.VectorInit.Num(vertices.length * 2, 0);
			for (i = 0; i < vertices.length; i++) {
				obj.uvs[i * 2] = vertices[i].u;
				obj.uvs[i * 2 + 1] = vertices[i].v;
			}
		}
		geom = new away.core.base.Geometry();
		subs = away.utils.GeometryUtils.fromVectors(obj.verts, obj.indices, obj.uvs, null, null, null, null, 0);
		for (i = 0; i < subs.length; i++)
			geom.get_subGeometries().push(subs[i]);
		if (obj.materials.length > 0) {
			var mname;
			mname = obj.materials[0];
			mat = this._materials[mname].material;
		}
		if (pivot) {
			if (obj.transform) {
				var dat = obj.transform.concat();
				dat[12] = 0;
				dat[13] = 0;
				dat[14] = 0;
				mtx = new away.core.geom.Matrix3D(dat);
				pivot = mtx.transformVector(pivot);
			}
			pivot.scaleBy(-1);
			mtx = new away.core.geom.Matrix3D();
			mtx.appendTranslation(pivot.x, pivot.y, pivot.z);
			geom.applyTransformation(mtx);
		}
		if (obj.transform) {
			mtx = new away.core.geom.Matrix3D(obj.transform);
			mtx.invert();
			geom.applyTransformation(mtx);
		}
		this._pFinalizeAsset(geom, obj.name.concat("_geom"));
		mesh = new away.entities.Mesh(geom, mat);
		mesh.set_transform(new away.core.geom.Matrix3D(obj.transform));
		return mesh;
	}
	return null;
};

away.loaders.parsers.Max3DSParser.prototype.prepareData = function(vertices, faces, obj) {
	var i;
	var j;
	var k;
	var len = obj.verts.length;
	for (i = 0, j = 0, k = 0; i < len;) {
		var v = new away.loaders.parsers.VertexVO();
		v.x = obj.verts[i++];
		v.y = obj.verts[i++];
		v.z = obj.verts[i++];
		if (obj.uvs) {
			v.u = obj.uvs[j++];
			v.v = obj.uvs[j++];
		}
		vertices[k++] = v;
	}
	len = obj.indices.length;
	for (i = 0, k = 0; i < len;) {
		var f = new away.loaders.parsers.FaceVO();
		f.a = obj.indices[i++];
		f.b = obj.indices[i++];
		f.c = obj.indices[i++];
		f.smoothGroup = obj.smoothingGroups[k];
		faces[k++] = f;
	}
};

away.loaders.parsers.Max3DSParser.prototype.applySmoothGroups = function(vertices, faces) {
	var i;
	var j;
	var k;
	var l;
	var len;
	var numVerts = vertices.length;
	var numFaces = faces.length;
	var vGroups = away.utils.VectorInit.VecNum(numVerts, 0);
	for (i = 0; i < numVerts; i++)
		vGroups[i] = away.utils.VectorInit.Num(0, 0);
	for (i = 0; i < numFaces; i++) {
		var face = faces[i];
		for (j = 0; j < 3; j++) {
			var groups = vGroups[(j == 0) ? face.a : (j == 1) ? face.b : face.c];
			var group = face.smoothGroup;
			for (k = groups.length - 1; k >= 0; k--) {
				if ((group & groups[k]) > 0) {
					group |= groups[k];
					groups.splice(k, 1);
					k = groups.length - 1;
				}
			}
			groups.push(group);
		}
	}
	var vClones = away.utils.VectorInit.VecNum(numVerts, 0);
	for (i = 0; i < numVerts; i++) {
		if ((len = vGroups[i].length) < 1)
			continue;
		var clones = away.utils.VectorInit.Num(len, 0);
		vClones[i] = clones;
		clones[0] = i;
		var v0 = vertices[i];
		for (j = 1; j < len; j++) {
			var v1 = new away.loaders.parsers.VertexVO();
			v1.x = v0.x;
			v1.y = v0.y;
			v1.z = v0.z;
			v1.u = v0.u;
			v1.v = v0.v;
			clones[j] = vertices.length;
			vertices.push(v1);
		}
	}
	numVerts = vertices.length;
	for (i = 0; i < numFaces; i++) {
		face = faces[i];
		group = face.smoothGroup;
		for (j = 0; j < 3; j++) {
			k = (j == 0) ? face.a : (j == 1) ? face.b : face.c;
			groups = vGroups[k];
			len = groups.length;
			clones = vClones[k];
			for (l = 0; l < len; l++) {
				if (((group == 0) && (groups[l] == 0)) || ((group & groups[l]) > 0)) {
					var index = clones[l];
					if (group == 0) {
						groups.splice(l, 1);
						clones.splice(l, 1);
					}
					if (j == 0)
						face.a = index;
					else if (j == 1)
						face.b = index;
					else
						face.c = index;
					l = len;
				}
			}
		}
	}
};

away.loaders.parsers.Max3DSParser.prototype.finalizeCurrentMaterial = function() {
	var mat;
	if (this.get_materialMode() < 2) {
		if (this._cur_mat.colorMap)
			mat = new away.materials.TextureMaterial(this._cur_mat.colorMap.texture || away.materials.utils.DefaultMaterialManager.getDefaultTexture(), true, false, false);
		else
			mat = new away.materials.ColorMaterial(this._cur_mat.diffuseColor, 1);
		mat.set_ambientColor(this._cur_mat.ambientColor);
		mat.set_specularColor(this._cur_mat.specularColor);
	} else {
		if (this._cur_mat.colorMap)
			mat = new away.materials.TextureMultiPassMaterial(this._cur_mat.colorMap.texture || away.materials.utils.DefaultMaterialManager.getDefaultTexture(), true, false, true);
		else
			mat = new away.materials.ColorMultiPassMaterial(this._cur_mat.diffuseColor);
		mat.set_ambientColor(this._cur_mat.ambientColor);
		mat.set_specularColor(this._cur_mat.specularColor);
	}
	mat.set_bothSides(this._cur_mat.twoSided);
	this._pFinalizeAsset(mat, this._cur_mat.name);
	this._materials[this._cur_mat.name] = this._cur_mat;
	this._cur_mat.material = mat;
	this._cur_mat = null;
};

away.loaders.parsers.Max3DSParser.prototype.readNulTermstring = function() {
	var chr;
	var str = "";
	while ((chr = this._byteData.readUnsignedByte()) > 0)
		str += String.fromCharCode(chr);
	return str;
};

away.loaders.parsers.Max3DSParser.prototype.readTransform = function() {
	var data;
	data = away.utils.VectorInit.Num(16, 0);
	data[0] = this._byteData.readFloat();
	data[2] = this._byteData.readFloat();
	data[1] = this._byteData.readFloat();
	data[3] = 0;
	data[8] = this._byteData.readFloat();
	data[10] = this._byteData.readFloat();
	data[9] = this._byteData.readFloat();
	data[11] = 0;
	data[4] = this._byteData.readFloat();
	data[6] = this._byteData.readFloat();
	data[5] = this._byteData.readFloat();
	data[7] = 0;
	data[12] = this._byteData.readFloat();
	data[14] = this._byteData.readFloat();
	data[13] = this._byteData.readFloat();
	data[15] = 1;
	return data;
};

away.loaders.parsers.Max3DSParser.prototype.readColor = function() {
	var cid;
	var len;
	var r, g, b;
	cid = this._byteData.readUnsignedShort();
	len = this._byteData.readUnsignedInt();
	switch (cid) {
		case 0x0010:
			r = this._byteData.readFloat() * 255;
			g = this._byteData.readFloat() * 255;
			b = this._byteData.readFloat() * 255;
			break;
		case 0x0011:
			r = this._byteData.readUnsignedByte();
			g = this._byteData.readUnsignedByte();
			b = this._byteData.readUnsignedByte();
			break;
		default:
			this._byteData.position += (len - 6);
			break;
	}
	return (r << 16) | (g << 8) | b;
};

$inherit(away.loaders.parsers.Max3DSParser, away.loaders.parsers.ParserBase);

away.loaders.parsers.Max3DSParser.className = "away.loaders.parsers.Max3DSParser";

away.loaders.parsers.Max3DSParser.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.loaders.parsers.FaceVO');
	p.push('away.core.net.URLRequest');
	p.push('away.materials.TextureMaterial');
	p.push('away.loaders.parsers.ParserDataFormat');
	p.push('away.loaders.parsers.ParserBase');
	p.push('away.loaders.parsers.MaterialVO');
	p.push('away.loaders.parsers.VertexVO');
	p.push('away.materials.ColorMultiPassMaterial');
	p.push('away.loaders.parsers.ObjectVO');
	p.push('away.loaders.parsers.TextureVO');
	p.push('away.utils.GeometryUtils');
	p.push('away.entities.Mesh');
	p.push('away.core.geom.Vector3D');
	p.push('away.core.geom.Matrix3D');
	p.push('away.loaders.parsers.utils.ParserUtil');
	p.push('away.materials.TextureMultiPassMaterial');
	p.push('away.utils.VectorInit');
	p.push('away.materials.ColorMaterial');
	p.push('away.library.assets.AssetType');
	p.push('away.core.base.Geometry');
	p.push('away.materials.utils.DefaultMaterialManager');
	return p;
};

away.loaders.parsers.Max3DSParser.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.loaders.parsers.Max3DSParser.injectionPoints = function(t) {
	var p;
	switch (t) {
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

