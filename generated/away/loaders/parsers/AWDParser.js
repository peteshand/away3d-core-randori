/** Compiled by the Randori compiler v0.2.5.2 on Wed Oct 09 20:30:42 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.loaders == "undefined")
	away.loaders = {};
if (typeof away.loaders.parsers == "undefined")
	away.loaders.parsers = {};

away.loaders.parsers.AWDParser = function() {
	this._debug = true;
	this._geoNrType = 0;
	this.blendModeDic = null;
	this._texture_users = {};
	this._startedParsing = false;
	this._cur_block_id = 0;
	this._accuracyOnBlocks = false;
	this._byteData = null;
	this._compression = 0;
	this._accuracyGeo = false;
	this._cubeTextures = null;
	this._blocks = null;
	this._accuracyProps = false;
	this._defaultCubeTexture = null;
	this._newBlockBytes = null;
	this._streaming = false;
	this._propsNrType = 0;
	this._body = null;
	this._defaultBitmapMaterial = null;
	this._depthSizeDic = null;
	this._defaultTexture = null;
	this._version = null;
	this._accuracyMatrix = false;
	this._matrixNrType = 0;
	this._parsed_header = false;
	away.loaders.parsers.ParserBase.call(this, away.loaders.parsers.ParserDataFormat.BINARY);
	this._blocks = [];
	this._blocks[0] = new away.loaders.parsers.AWDBlock();
	this._blocks[0].data = null;
	this.blendModeDic = away.utils.VectorInit.Str(0, "");
	this.blendModeDic.push(away.core.display.BlendMode.NORMAL);
	this.blendModeDic.push(away.core.display.BlendMode.ADD);
	this.blendModeDic.push(away.core.display.BlendMode.ALPHA);
	this.blendModeDic.push(away.core.display.BlendMode.DARKEN);
	this.blendModeDic.push(away.core.display.BlendMode.DIFFERENCE);
	this.blendModeDic.push(away.core.display.BlendMode.ERASE);
	this.blendModeDic.push(away.core.display.BlendMode.HARDLIGHT);
	this.blendModeDic.push(away.core.display.BlendMode.INVERT);
	this.blendModeDic.push(away.core.display.BlendMode.LAYER);
	this.blendModeDic.push(away.core.display.BlendMode.LIGHTEN);
	this.blendModeDic.push(away.core.display.BlendMode.MULTIPLY);
	this.blendModeDic.push(away.core.display.BlendMode.NORMAL);
	this.blendModeDic.push(away.core.display.BlendMode.OVERLAY);
	this.blendModeDic.push(away.core.display.BlendMode.SCREEN);
	this.blendModeDic.push(away.core.display.BlendMode.SHADER);
	this.blendModeDic.push(away.core.display.BlendMode.OVERLAY);
	this._depthSizeDic = away.utils.VectorInit.Num(0, 0);
	this._depthSizeDic.push(256);
	this._depthSizeDic.push(512);
	this._depthSizeDic.push(2048);
	this._depthSizeDic.push(1024);
	this._version = away.utils.VectorInit.Num(0, 0);
};

away.loaders.parsers.AWDParser.COMPRESSIONMODE_LZMA = "lzma";

away.loaders.parsers.AWDParser.UNCOMPRESSED = 0;

away.loaders.parsers.AWDParser.DEFLATE = 1;

away.loaders.parsers.AWDParser.LZMA = 2;

away.loaders.parsers.AWDParser.INT8 = 1;

away.loaders.parsers.AWDParser.INT16 = 2;

away.loaders.parsers.AWDParser.INT32 = 3;

away.loaders.parsers.AWDParser.UINT8 = 4;

away.loaders.parsers.AWDParser.UINT16 = 5;

away.loaders.parsers.AWDParser.UINT32 = 6;

away.loaders.parsers.AWDParser.FLOAT32 = 7;

away.loaders.parsers.AWDParser.FLOAT64 = 8;

away.loaders.parsers.AWDParser.BOOL = 21;

away.loaders.parsers.AWDParser.COLOR = 22;

away.loaders.parsers.AWDParser.BADDR = 23;

away.loaders.parsers.AWDParser.AWDSTRING = 31;

away.loaders.parsers.AWDParser.AWDBYTEARRAY = 32;

away.loaders.parsers.AWDParser.VECTOR2x1 = 41;

away.loaders.parsers.AWDParser.VECTOR3x1 = 42;

away.loaders.parsers.AWDParser.VECTOR4x1 = 43;

away.loaders.parsers.AWDParser.MTX3x2 = 44;

away.loaders.parsers.AWDParser.MTX3x3 = 45;

away.loaders.parsers.AWDParser.MTX4x3 = 46;

away.loaders.parsers.AWDParser.MTX4x4 = 47;

away.loaders.parsers.AWDParser.supportsType = function(extension) {
	extension = extension.toLowerCase();
	return extension == "awd";
};

away.loaders.parsers.AWDParser.supportsData = function(data) {
	return (away.loaders.parsers.utils.ParserUtil.toString(data, 3) == "AWD");
};

away.loaders.parsers.AWDParser.prototype._iResolveDependency = function(resourceDependency) {
	if (resourceDependency.get_assets().length == 1) {
		var isCubeTextureArray = resourceDependency.get_id().split("#", 4.294967295E9);
		var ressourceID = isCubeTextureArray[0];
		var asset;
		var thisBitmapTexture;
		var block;
		if (isCubeTextureArray.length == 1) {
			asset = resourceDependency.get_assets()[0];
			if (asset) {
				var mat;
				var users;
				block = this._blocks[resourceDependency.get_id()];
				block.data = asset;
				asset.resetAssetPath(block.name, null, true);
				block.name = asset.get_name();
				this._pFinalizeAsset(asset);
				if (this._debug) {
					console.log("Successfully loaded Bitmap for texture");
					console.log("Parsed texture: Name = " + block.name);
				}
			}
		}
		if (isCubeTextureArray.length > 1) {
			thisBitmapTexture = resourceDependency.get_assets()[0];
			var tx = thisBitmapTexture;
			this._cubeTextures[isCubeTextureArray[1]] = tx.get_htmlImageElement();
			this._texture_users[ressourceID].push(1);
			if (this._debug) {
				console.log("Successfully loaded Bitmap " + this._texture_users[ressourceID].length + " \/ 6 for Cubetexture");
			}
			if (this._texture_users[ressourceID].length == this._cubeTextures.length) {
				var posX = this._cubeTextures[0];
				var negX = this._cubeTextures[1];
				var posY = this._cubeTextures[2];
				var negY = this._cubeTextures[3];
				var posZ = this._cubeTextures[4];
				var negZ = this._cubeTextures[5];
				asset = new away.textures.HTMLImageElementCubeTexture(posX, negX, posY, negY, posZ, negZ);
				block = this._blocks[ressourceID];
				block.data = asset;
				asset.resetAssetPath(block.name, null, true);
				block.name = asset.get_name();
				this._pFinalizeAsset(asset);
				if (this._debug) {
					console.log("Parsed CubeTexture: Name = " + block.name);
				}
			}
		}
	}
};

away.loaders.parsers.AWDParser.prototype._iResolveDependencyFailure = function(resourceDependency) {
};

away.loaders.parsers.AWDParser.prototype._iResolveDependencyName = function(resourceDependency, asset) {
	var oldName = asset.get_name();
	if (asset) {
		var block = this._blocks[parseInt(resourceDependency.get_id(), 0)];
		asset.resetAssetPath(block.name, null, true);
	}
	var newName = asset.get_name();
	asset.set_name(oldName);
	return newName;
};

away.loaders.parsers.AWDParser.prototype._pProceedParsing = function() {
	if (!this._startedParsing) {
		this._byteData = this._pGetByteData();
		this._startedParsing = true;
	}
	if (!this._parsed_header) {
		this.parseHeader();
		switch (this._compression) {
			case away.loaders.parsers.AWDParser.DEFLATE:
			
			case away.loaders.parsers.AWDParser.LZMA:
				this._pDieWithError("Compressed AWD formats not yet supported");
				break;
			case away.loaders.parsers.AWDParser.UNCOMPRESSED:
				this._body = this._byteData;
				break;
		}
		this._parsed_header = true;
	}
	if (this._body) {
		while (this._body.getBytesAvailable() > 0 && !this.get_parsingPaused()) {
			this.parseNextBlock();
		}
		if (this._body.getBytesAvailable() == 0) {
			this.dispose();
			return away.loaders.parsers.ParserBase.PARSING_DONE;
		} else {
			return away.loaders.parsers.ParserBase.MORE_TO_PARSE;
		}
	} else {
		switch (this._compression) {
			case away.loaders.parsers.AWDParser.DEFLATE:
			
			case away.loaders.parsers.AWDParser.LZMA:
				if (this._debug) {
					console.log("(!) AWDParser Error: Compressed AWD formats not yet supported (!)");
				}
				break;
		}
		return away.loaders.parsers.ParserBase.PARSING_DONE;
	}
};

away.loaders.parsers.AWDParser.prototype.dispose = function() {
	for (var c in this._blocks) {
		var b = this._blocks[c];
		b.dispose();
	}
};

away.loaders.parsers.AWDParser.prototype.parseNextBlock = function() {
	var block;
	var assetData;
	var isParsed = false;
	var ns;
	var type;
	var flags;
	var len;
	this._cur_block_id = this._body.readUnsignedInt();
	ns = this._body.readUnsignedByte();
	type = this._body.readUnsignedByte();
	flags = this._body.readUnsignedByte();
	len = this._body.readUnsignedInt();
	var blockCompression = away.loaders.parsers.bitFlags.test(flags, away.loaders.parsers.bitFlags.FLAG4);
	var blockCompressionLZMA = away.loaders.parsers.bitFlags.test(flags, away.loaders.parsers.bitFlags.FLAG5);
	if (this._accuracyOnBlocks) {
		this._accuracyMatrix = away.loaders.parsers.bitFlags.test(flags, away.loaders.parsers.bitFlags.FLAG1);
		this._accuracyGeo = away.loaders.parsers.bitFlags.test(flags, away.loaders.parsers.bitFlags.FLAG2);
		this._accuracyProps = away.loaders.parsers.bitFlags.test(flags, away.loaders.parsers.bitFlags.FLAG3);
		this._geoNrType = away.loaders.parsers.AWDParser.FLOAT32;
		if (this._accuracyGeo) {
			this._geoNrType = away.loaders.parsers.AWDParser.FLOAT64;
		}
		this._matrixNrType = away.loaders.parsers.AWDParser.FLOAT32;
		if (this._accuracyMatrix) {
			this._matrixNrType = away.loaders.parsers.AWDParser.FLOAT64;
		}
		this._propsNrType = away.loaders.parsers.AWDParser.FLOAT32;
		if (this._accuracyProps) {
			this._propsNrType = away.loaders.parsers.AWDParser.FLOAT64;
		}
	}
	var blockEndAll = this._body.position + len;
	if (len > this._body.getBytesAvailable()) {
		this._pDieWithError("AWD2 block length is bigger than the bytes that are available!");
		this._body.position += this._body.getBytesAvailable();
		return;
	}
	this._newBlockBytes = new away.utils.ByteArray();
	this._body.readBytes(this._newBlockBytes, 0, len);
	if (blockCompression) {
		this._pDieWithError("Compressed AWD formats not yet supported");
	}
	this._newBlockBytes.position = 0;
	block = new away.loaders.parsers.AWDBlock();
	block.len = this._newBlockBytes.position + len;
	block.id = this._cur_block_id;
	var blockEndBlock = this._newBlockBytes.position + len;
	if (blockCompression) {
		this._pDieWithError("Compressed AWD formats not yet supported");
	}
	if (this._debug) {
		console.log("AWDBlock:  ID = " + this._cur_block_id + " | TypeID = " + type + " | Compression = " + blockCompression + " | Matrix-Precision = " + this._accuracyMatrix + " | Geometry-Precision = " + this._accuracyGeo + " | Properties-Precision = " + this._accuracyProps);
	}
	this._blocks[this._cur_block_id] = block;
	if ((this._version[0] == 2) && (this._version[1] == 1)) {
		switch (type) {
			case 11:
				this.parsePrimitves(this._cur_block_id);
				isParsed = true;
				break;
			case 31:
				break;
			case 41:
				this.parseLight(this._cur_block_id);
				isParsed = true;
				break;
			case 42:
				this.parseCamera(this._cur_block_id);
				isParsed = true;
				break;
			case 51:
				this.parseLightPicker(this._cur_block_id);
				isParsed = true;
				break;
			case 81:
				this.parseMaterial_v1(this._cur_block_id);
				isParsed = true;
				break;
			case 83:
				this.parseCubeTexture(this._cur_block_id);
				isParsed = true;
				break;
			case 91:
				this.parseSharedMethodBlock(this._cur_block_id);
				isParsed = true;
				break;
			case 92:
				this.parseShadowMethodBlock(this._cur_block_id);
				isParsed = true;
				break;
			case 111:
				break;
			case 112:
				break;
			case 113:
				break;
			case 122:
				break;
			case 253:
				this.parseCommand(this._cur_block_id);
				isParsed = true;
				break;
		}
	}
	if (isParsed == false) {
		switch (type) {
			case 1:
				this.parseTriangleGeometrieBlock(this._cur_block_id);
				break;
			case 22:
				this.parseContainer(this._cur_block_id);
				break;
			case 23:
				this.parseMeshInstance(this._cur_block_id);
				break;
			case 81:
				this.parseMaterial(this._cur_block_id);
				break;
			case 82:
				this.parseTexture(this._cur_block_id);
				break;
			case 101:
				break;
			case 102:
				break;
			case 103:
				break;
			case 121:
				break;
			case 254:
				this.parseNameSpace(this._cur_block_id);
				break;
			case 255:
				this.parseMetaData(this._cur_block_id);
				break;
			default:
				if (this._debug) {
					console.log("AWDBlock:   Unknown BlockType  (BlockID = " + this._cur_block_id + ") - Skip " + len + " bytes");
				}
				this._newBlockBytes.position += len;
				break;
		}
	}
	var msgCnt = 0;
	if (this._newBlockBytes.position == blockEndBlock) {
		if (this._debug) {
			if (block.errorMessages) {
				while (msgCnt < block.errorMessages.length) {
					console.log("        (!) Error: " + block.errorMessages[msgCnt] + " (!)");
					msgCnt++;
				}
			}
		}
		if (this._debug) {
			console.log("\n");
		}
	} else {
		if (this._debug) {
			console.log("  (!)(!)(!) Error while reading AWDBlock ID " + this._cur_block_id + " = skip to next block");
			if (block.errorMessages) {
				while (msgCnt < block.errorMessages.length) {
					console.log("        (!) Error: " + block.errorMessages[msgCnt] + " (!)");
					msgCnt++;
				}
			}
		}
	}
	this._body.position = blockEndAll;
	this._newBlockBytes = null;
};

away.loaders.parsers.AWDParser.prototype.parseTriangleGeometrieBlock = function(blockID) {
	var geom = new away.core.base.Geometry();
	var name = this.parseVarStr();
	var num_subs = this._newBlockBytes.readUnsignedShort();
	var props = this.parseProperties({1:this._geoNrType, 2:this._geoNrType});
	var geoScaleU = props.get(1, 1);
	var geoScaleV = props.get(2, 1);
	var subs_parsed = 0;
	while (subs_parsed < num_subs) {
		var i;
		var sm_len, sm_end;
		var sub_geoms;
		var w_indices;
		var weights;
		sm_len = this._newBlockBytes.readUnsignedInt();
		sm_end = this._newBlockBytes.position + sm_len;
		var subProps = this.parseProperties({1:this._geoNrType, 2:this._geoNrType});
		while (this._newBlockBytes.position < sm_end) {
			var idx = 0;
			var str_ftype, str_type, str_len, str_end;
			str_type = this._newBlockBytes.readUnsignedByte();
			str_ftype = this._newBlockBytes.readUnsignedByte();
			str_len = this._newBlockBytes.readUnsignedInt();
			str_end = this._newBlockBytes.position + str_len;
			var x, y, z;
			if (str_type == 1) {
				var verts = away.utils.VectorInit.Num(0, 0);
				while (this._newBlockBytes.position < str_end) {
					x = this.readNumber(this._accuracyGeo);
					y = this.readNumber(this._accuracyGeo);
					z = this.readNumber(this._accuracyGeo);
					verts[idx++] = x;
					verts[idx++] = y;
					verts[idx++] = z;
				}
			} else if (str_type == 2) {
				var indices = away.utils.VectorInit.Num(0, 0);
				while (this._newBlockBytes.position < str_end) {
					indices[idx++] = this._newBlockBytes.readUnsignedShort();
				}
			} else if (str_type == 3) {
				var uvs = away.utils.VectorInit.Num(0, 0);
				while (this._newBlockBytes.position < str_end) {
					uvs[idx++] = this.readNumber(this._accuracyGeo);
				}
			} else if (str_type == 4) {
				var normals = away.utils.VectorInit.Num(0, 0);
				while (this._newBlockBytes.position < str_end) {
					normals[idx++] = this.readNumber(this._accuracyGeo);
				}
			} else if (str_type == 6) {
				w_indices = away.utils.VectorInit.Num(0, 0);
				while (this._newBlockBytes.position < str_end) {
					w_indices[idx++] = this._newBlockBytes.readUnsignedShort() * 3;
				}
			} else if (str_type == 7) {
				weights = away.utils.VectorInit.Num(0, 0);
				while (this._newBlockBytes.position < str_end) {
					weights[idx++] = this.readNumber(this._accuracyGeo);
				}
			} else {
				this._newBlockBytes.position = str_end;
			}
		}
		this.parseUserAttributes();
		sub_geoms = away.utils.GeometryUtils.fromVectors(verts, indices, uvs, normals, null, weights, w_indices, 0);
		var scaleU = subProps.get(1, 1);
		var scaleV = subProps.get(2, 1);
		var setSubUVs = false;
		if ((geoScaleU != scaleU) || (geoScaleV != scaleV)) {
			setSubUVs = true;
			scaleU = geoScaleU / scaleU;
			scaleV = geoScaleV / scaleV;
		}
		for (i = 0; i < sub_geoms.length; i++) {
			if (setSubUVs)
				sub_geoms[i].scaleUV(scaleU, scaleV);
			geom.addSubGeometry(sub_geoms[i]);
		}
		subs_parsed++;
	}
	if ((geoScaleU != 1) || (geoScaleV != 1))
		geom.scaleUV(geoScaleU, geoScaleV);
	this.parseUserAttributes();
	this._pFinalizeAsset(geom, name);
	this._blocks[blockID].data = geom;
	if (this._debug) {
		console.log("Parsed a TriangleGeometry: Name = " + name + "| SubGeometries = " + sub_geoms.length);
	}
};

away.loaders.parsers.AWDParser.prototype.parsePrimitves = function(blockID) {
	var name;
	var geom;
	var primType;
	var subs_parsed;
	var props;
	var bsm;
	name = this.parseVarStr();
	primType = this._newBlockBytes.readUnsignedByte();
	props = this.parseProperties({101:this._geoNrType, 102:this._geoNrType, 103:this._geoNrType, 110:this._geoNrType, 111:this._geoNrType, 301:away.loaders.parsers.AWDParser.UINT16, 302:away.loaders.parsers.AWDParser.UINT16, 303:away.loaders.parsers.AWDParser.UINT16, 701:away.loaders.parsers.AWDParser.BOOL, 702:away.loaders.parsers.AWDParser.BOOL, 703:away.loaders.parsers.AWDParser.BOOL, 704:away.loaders.parsers.AWDParser.BOOL});
	var primitveTypes = ["Unsupported Type-ID", "PlaneGeometry", "CubeGeometry", "SphereGeometry", "CylinderGeometry", "ConeGeometry", "CapsuleGeometry", "TorusGeometry"];
	switch (primType) {
		case 1:
			geom = new away.primitives.PlaneGeometry(props.get(101, 100), props.get(102, 100), props.get(301, 1), props.get(302, 1), props.get(701, true), props.get(702, false));
			break;
		case 2:
			geom = new away.primitives.CubeGeometry(props.get(101, 100), props.get(102, 100), props.get(103, 100), props.get(301, 1), props.get(302, 1), props.get(303, 1), props.get(701, true));
			break;
		case 3:
			geom = new away.primitives.SphereGeometry(props.get(101, 50), props.get(301, 16), props.get(302, 12), props.get(701, true));
			break;
		case 4:
			geom = new away.primitives.CylinderGeometry(props.get(101, 50), props.get(102, 50), props.get(103, 100), props.get(301, 16), props.get(302, 1), true, true, true, true);
			if (!props.get(701, true))
				geom.set_topClosed(false);
			if (!props.get(702, true))
				geom.set_bottomClosed(false);
			if (!props.get(703, true))
				geom.set_yUp(false);
			break;
		case 5:
			geom = new away.primitives.ConeGeometry(props.get(101, 50), props.get(102, 100), props.get(301, 16), props.get(302, 1), props.get(701, true), props.get(702, true));
			break;
		case 6:
			geom = new away.primitives.CapsuleGeometry(props.get(101, 50), props.get(102, 100), props.get(301, 16), props.get(302, 15), props.get(701, true));
			break;
		case 7:
			geom = new away.primitives.TorusGeometry(props.get(101, 50), props.get(102, 50), props.get(301, 16), props.get(302, 8), props.get(701, true));
			break;
		default:
			geom = new away.core.base.Geometry();
			console.log("ERROR: UNSUPPORTED PRIMITIVE_TYPE");
			break;
	}
	if ((props.get(110, 1) != 1) || (props.get(111, 1) != 1)) {
		geom.get_subGeometries();
		geom.scaleUV(props.get(110, 1), props.get(111, 1));
	}
	this.parseUserAttributes();
	geom.set_name(name);
	this._pFinalizeAsset(geom, name);
	this._blocks[blockID].data = geom;
	if (this._debug) {
		if ((primType < 0) || (primType > 7)) {
			primType = 0;
		}
		console.log("Parsed a Primivite: Name = " + name + "| type = " + primitveTypes[primType]);
	}
};

away.loaders.parsers.AWDParser.prototype.parseContainer = function(blockID) {
	var name;
	var par_id;
	var mtx;
	var ctr;
	var parent;
	par_id = this._newBlockBytes.readUnsignedInt();
	mtx = this.parseMatrix3D();
	name = this.parseVarStr();
	var parentName = "Root (TopLevel)";
	ctr = new away.containers.ObjectContainer3D();
	ctr.set_transform(mtx);
	var returnedArray = this.getAssetByID(par_id, [away.library.assets.AssetType.CONTAINER, away.library.assets.AssetType.LIGHT, away.library.assets.AssetType.MESH, away.library.assets.AssetType.ENTITY, away.library.assets.AssetType.SEGMENT_SET], "SingleTexture");
	if (returnedArray[0]) {
		var obj = returnedArray[1].addChild(ctr);
		parentName = returnedArray[1].get_name();
	} else if (par_id > 0) {
		this._blocks[blockID].addError("Could not find a parent for this ObjectContainer3D");
	}
	if ((this._version[0] == 2) && (this._version[1] == 1)) {
		var props = this.parseProperties({1:this._matrixNrType, 2:this._matrixNrType, 3:this._matrixNrType, 4:away.loaders.parsers.AWDParser.UINT8});
		ctr.set_pivotPoint(new away.core.geom.Vector3D(props.get(1, 0), props.get(2, 0), props.get(3, 0), 0));
	} else {
		this.parseProperties(null);
	}
	ctr.extra = this.parseUserAttributes();
	this._pFinalizeAsset(ctr, name);
	this._blocks[blockID].data = ctr;
	if (this._debug) {
		console.log("Parsed a Container: Name = \'" + name + "\' | Parent-Name = " + parentName);
	}
};

away.loaders.parsers.AWDParser.prototype.parseMeshInstance = function(blockID) {
	var num_materials;
	var materials_parsed;
	var parent;
	var par_id = this._newBlockBytes.readUnsignedInt();
	var mtx = this.parseMatrix3D();
	var name = this.parseVarStr();
	var parentName = "Root (TopLevel)";
	var data_id = this._newBlockBytes.readUnsignedInt();
	var geom;
	var returnedArrayGeometry = this.getAssetByID(data_id, [away.library.assets.AssetType.GEOMETRY], "SingleTexture");
	if (returnedArrayGeometry[0]) {
		geom = returnedArrayGeometry[1];
	} else {
		this._blocks[blockID].addError("Could not find a Geometry for this Mesh. A empty Geometry is created!");
		geom = new away.core.base.Geometry();
	}
	this._blocks[blockID].geoID = data_id;
	var materials = [];
	num_materials = this._newBlockBytes.readUnsignedShort();
	var materialNames = away.utils.VectorInit.Str(0, "");
	materials_parsed = 0;
	var returnedArrayMaterial;
	while (materials_parsed < num_materials) {
		var mat_id;
		mat_id = this._newBlockBytes.readUnsignedInt();
		returnedArrayMaterial = this.getAssetByID(mat_id, [away.library.assets.AssetType.MATERIAL], "SingleTexture");
		if (!returnedArrayMaterial[0] && (mat_id > 0)) {
			this._blocks[blockID].addError("Could not find Material Nr " + materials_parsed + " (ID = " + mat_id + " ) for this Mesh");
		}
		var m = returnedArrayMaterial[1];
		materials.push(m);
		materialNames.push(m.get_name());
		materials_parsed++;
	}
	var mesh = new away.entities.Mesh(geom, null);
	mesh.set_transform(mtx);
	var returnedArrayParent = this.getAssetByID(par_id, [away.library.assets.AssetType.CONTAINER, away.library.assets.AssetType.LIGHT, away.library.assets.AssetType.MESH, away.library.assets.AssetType.ENTITY, away.library.assets.AssetType.SEGMENT_SET], "SingleTexture");
	if (returnedArrayParent[0]) {
		var objC = returnedArrayParent[1];
		objC.addChild(mesh);
		parentName = objC.get_name();
	} else if (par_id > 0) {
		this._blocks[blockID].addError("Could not find a parent for this Mesh");
	}
	if (materials.length >= 1 && mesh.get_subMeshes().length == 1) {
		mesh.set_material(materials[0]);
	} else if (materials.length > 1) {
		var i;
		for (i = 0; i < mesh.get_subMeshes().length; i++) {
			mesh.get_subMeshes()[i].material = materials[Math.min(materials.length - 1, i)];
		}
	}
	if ((this._version[0] == 2) && (this._version[1] == 1)) {
		var props = this.parseProperties({1:this._matrixNrType, 2:this._matrixNrType, 3:this._matrixNrType, 4:away.loaders.parsers.AWDParser.UINT8, 5:away.loaders.parsers.AWDParser.BOOL});
		mesh.set_pivotPoint(new away.core.geom.Vector3D(props.get(1, 0), props.get(2, 0), props.get(3, 0), 0));
		mesh.set_castsShadows(props.get(5, true));
	} else {
		this.parseProperties(null);
	}
	mesh.extra = this.parseUserAttributes();
	this._pFinalizeAsset(mesh, name);
	this._blocks[blockID].data = mesh;
	if (this._debug) {
		console.log("Parsed a Mesh: Name = \'" + name + "\' | Parent-Name = " + parentName + "| Geometry-Name = " + geom.get_name() + " | SubMeshes = " + mesh.get_subMeshes().length + " | Mat-Names = " + materialNames.toString());
	}
};

away.loaders.parsers.AWDParser.prototype.parseLight = function(blockID) {
	var light;
	var newShadowMapper;
	var par_id = this._newBlockBytes.readUnsignedInt();
	var mtx = this.parseMatrix3D();
	var name = this.parseVarStr();
	var lightType = this._newBlockBytes.readUnsignedByte();
	var props = this.parseProperties({1:this._propsNrType, 2:this._propsNrType, 3:away.loaders.parsers.AWDParser.COLOR, 4:this._propsNrType, 5:this._propsNrType, 6:away.loaders.parsers.AWDParser.BOOL, 7:away.loaders.parsers.AWDParser.COLOR, 8:this._propsNrType, 9:away.loaders.parsers.AWDParser.UINT8, 10:away.loaders.parsers.AWDParser.UINT8, 11:this._propsNrType, 12:away.loaders.parsers.AWDParser.UINT16, 21:this._matrixNrType, 22:this._matrixNrType, 23:this._matrixNrType});
	var shadowMapperType = props.get(9, 0);
	var parentName = "Root (TopLevel)";
	var lightTypes = new String["Unsupported LightType", "PointLight", "DirectionalLight"]();
	var shadowMapperTypes = new String["No ShadowMapper", "DirectionalShadowMapper", "NearDirectionalShadowMapper", "CascadeShadowMapper", "CubeMapShadowMapper"]();
	if (lightType == 1) {
		light = new away.lights.PointLight();
		light.set_radius(props.get(1, 90000));
		light.set_fallOff(props.get(2, 100000));
		if (shadowMapperType > 0) {
			if (shadowMapperType == 4) {
				newShadowMapper = new away.lights.shadowmaps.CubeMapShadowMapper();
			}
		}
		light.set_transform(mtx);
	}
	if (lightType == 2) {
		light = new away.lights.DirectionalLight(props.get(21, 0), props.get(22, -1), props.get(23, 1));
		if (shadowMapperType > 0) {
			if (shadowMapperType == 1) {
				newShadowMapper = new away.lights.shadowmaps.DirectionalShadowMapper();
			}
		}
	}
	light.set_color(props.get(3, 0xffffff));
	light.set_specular(props.get(4, 1.0));
	light.set_diffuse(props.get(5, 1.0));
	light.set_ambientColor(props.get(7, 0xffffff));
	light.set_ambient(props.get(8, 0.0));
	if (newShadowMapper) {
		if (newShadowMapper instanceof away.lights.shadowmaps.CubeMapShadowMapper) {
			if (props.get(10, 1) != 1) {
				newShadowMapper.set_depthMapSize(this._depthSizeDic[props.get(10, 1)]);
			}
		} else {
			if (props.get(10, 2) != 2) {
				newShadowMapper.set_depthMapSize(this._depthSizeDic[props.get(10, 2)]);
			}
		}
		light.set_shadowMapper(newShadowMapper);
		light.set_castsShadows(true);
	}
	if (par_id != 0) {
		var returnedArrayParent = this.getAssetByID(par_id, [away.library.assets.AssetType.CONTAINER, away.library.assets.AssetType.LIGHT, away.library.assets.AssetType.MESH, away.library.assets.AssetType.ENTITY, away.library.assets.AssetType.SEGMENT_SET], "SingleTexture");
		if (returnedArrayParent[0]) {
			returnedArrayParent[1].addChild(light);
			parentName = returnedArrayParent[1].get_name();
		} else {
			this._blocks[blockID].addError("Could not find a parent for this Light");
		}
	}
	this.parseUserAttributes();
	this._pFinalizeAsset(light, name);
	this._blocks[blockID].data = light;
	if (this._debug)
		console.log("Parsed a Light: Name = \'" + name + "\' | Type = " + lightTypes[lightType] + " | Parent-Name = " + parentName + " | ShadowMapper-Type = " + shadowMapperTypes[shadowMapperType]);
};

away.loaders.parsers.AWDParser.prototype.parseCamera = function(blockID) {
	var par_id = this._newBlockBytes.readUnsignedInt();
	var mtx = this.parseMatrix3D();
	var name = this.parseVarStr();
	var parentName = "Root (TopLevel)";
	var lens;
	this._newBlockBytes.readUnsignedByte();
	this._newBlockBytes.readShort();
	var lenstype = this._newBlockBytes.readShort();
	var props = this.parseProperties({101:this._propsNrType, 102:this._propsNrType, 103:this._propsNrType, 104:this._propsNrType});
	switch (lenstype) {
		case 5001:
			lens = new away.cameras.lenses.PerspectiveLens(props.get(101, 60));
			break;
		case 5002:
			lens = new away.cameras.lenses.OrthographicLens(props.get(101, 500));
			break;
		case 5003:
			lens = new away.cameras.lenses.OrthographicOffCenterLens(props.get(101, -400), props.get(102, 400), props.get(103, -300), props.get(104, 300));
			break;
		default:
			console.log("unsupportedLenstype");
			return;
	}
	var camera = new away.cameras.Camera3D(lens);
	camera.set_transform(mtx);
	var returnedArrayParent = this.getAssetByID(par_id, [away.library.assets.AssetType.CONTAINER, away.library.assets.AssetType.LIGHT, away.library.assets.AssetType.MESH, away.library.assets.AssetType.ENTITY, away.library.assets.AssetType.SEGMENT_SET], "SingleTexture");
	if (returnedArrayParent[0]) {
		var objC = returnedArrayParent[1];
		objC.addChild(camera);
		parentName = objC.get_name();
	} else if (par_id > 0) {
		this._blocks[blockID].addError("Could not find a parent for this Camera");
	}
	camera.set_name(name);
	props = this.parseProperties({1:this._matrixNrType, 2:this._matrixNrType, 3:this._matrixNrType, 4:away.loaders.parsers.AWDParser.UINT8});
	camera.set_pivotPoint(new away.core.geom.Vector3D(props.get(1, 0), props.get(2, 0), props.get(3, 0), 0));
	camera.extra = this.parseUserAttributes();
	this._pFinalizeAsset(camera, name);
	this._blocks[blockID].data = camera;
	if (this._debug) {
		console.log("Parsed a Camera: Name = \'" + name + "\' | Lenstype = " + lens + " | Parent-Name = " + parentName);
	}
};

away.loaders.parsers.AWDParser.prototype.parseLightPicker = function(blockID) {
	var name = this.parseVarStr();
	var numLights = this._newBlockBytes.readUnsignedShort();
	var lightsArray = [];
	var k = 0;
	var lightID = 0;
	var returnedArrayLight;
	var lightsArrayNames = away.utils.VectorInit.Str(0, "");
	for (k = 0; k < numLights; k++) {
		lightID = this._newBlockBytes.readUnsignedInt();
		returnedArrayLight = this.getAssetByID(lightID, [away.library.assets.AssetType.LIGHT], "SingleTexture");
		if (returnedArrayLight[0]) {
			lightsArray.push(returnedArrayLight[1]);
			lightsArrayNames.push(returnedArrayLight[1].get_name());
		} else {
			this._blocks[blockID].addError("Could not find a Light Nr " + k + " (ID = " + lightID + " ) for this LightPicker");
		}
	}
	if (lightsArray.length == 0) {
		this._blocks[blockID].addError("Could not create this LightPicker, cause no Light was found.");
		this.parseUserAttributes();
		return;
	}
	var lightPick = new away.materials.lightpickers.StaticLightPicker(lightsArray);
	lightPick.set_name(name);
	this.parseUserAttributes();
	this._pFinalizeAsset(lightPick, name);
	this._blocks[blockID].data = lightPick;
	if (this._debug) {
		console.log("Parsed a StaticLightPicker: Name = \'" + name + "\' | Texture-Name = " + lightsArrayNames.toString());
	}
};

away.loaders.parsers.AWDParser.prototype.parseMaterial = function(blockID) {
	var name;
	var type;
	var props;
	var mat;
	var attributes;
	var finalize;
	var num_methods;
	var methods_parsed;
	var returnedArray;
	name = this.parseVarStr();
	type = this._newBlockBytes.readUnsignedByte();
	num_methods = this._newBlockBytes.readUnsignedByte();
	props = this.parseProperties({1:away.loaders.parsers.AWDParser.INT32, 2:away.loaders.parsers.AWDParser.BADDR, 10:this._propsNrType, 11:away.loaders.parsers.AWDParser.BOOL, 12:this._propsNrType, 13:away.loaders.parsers.AWDParser.BOOL});
	methods_parsed = 0;
	while (methods_parsed < num_methods) {
		var method_type;
		method_type = this._newBlockBytes.readUnsignedShort();
		this.parseProperties(null);
		this.parseUserAttributes();
		methods_parsed += 1;
	}
	var debugString = "";
	attributes = this.parseUserAttributes();
	if (type === 1) {
		debugString += "Parsed a ColorMaterial(SinglePass): Name = \'" + name + "\' | ";
		var color;
		color = props.get(1, 0xcccccc);
		if (this.get_materialMode() < 2)
			mat = new away.materials.ColorMaterial(color, props.get(10, 1.0));
		else
			mat = new away.materials.ColorMultiPassMaterial(color);
	} else if (type === 2) {
		var tex_addr = props.get(2, 0);
		returnedArray = this.getAssetByID(tex_addr, [away.library.assets.AssetType.TEXTURE], "SingleTexture");
		if (!returnedArray[0] && (tex_addr > 0)) {
			this._blocks[blockID].addError("Could not find the DiffsueTexture (ID = " + tex_addr + " ) for this Material");
		}
		if (this.get_materialMode() < 2) {
			mat = new away.materials.TextureMaterial(returnedArray[1], true, false, false);
			var txMaterial = mat;
			txMaterial.set_alphaBlending(props.get(11, false));
			txMaterial.set_alpha(props.get(10, 1.0));
			debugString += "Parsed a TextureMaterial(SinglePass): Name = \'" + name + "\' | Texture-Name = " + mat.get_name();
		} else {
			mat = new away.materials.TextureMultiPassMaterial(returnedArray[1], true, false, true);
			debugString += "Parsed a TextureMaterial(MultipAss): Name = \'" + name + "\' | Texture-Name = " + mat.get_name();
		}
	}
	mat.extra = attributes;
	if (this.get_materialMode() < 2) {
		var spmb = mat;
		spmb.set_alphaThreshold(props.get(12, 0.0));
	} else {
		var mpmb = mat;
		mpmb.set_alphaThreshold(props.get(12, 0.0));
	}
	mat.set_repeat(props.get(13, false));
	this._pFinalizeAsset(mat, name);
	this._blocks[blockID].data = mat;
	if (this._debug) {
		console.log(debugString);
	}
};

away.loaders.parsers.AWDParser.prototype.parseMaterial_v1 = function(blockID) {
	var mat;
	var normalTexture;
	var specTexture;
	var returnedArray;
	var name = this.parseVarStr();
	var type = this._newBlockBytes.readUnsignedByte();
	var num_methods = this._newBlockBytes.readUnsignedByte();
	var props = this.parseProperties({1:away.loaders.parsers.AWDParser.UINT32, 2:away.loaders.parsers.AWDParser.BADDR, 3:away.loaders.parsers.AWDParser.BADDR, 4:away.loaders.parsers.AWDParser.UINT8, 5:away.loaders.parsers.AWDParser.BOOL, 6:away.loaders.parsers.AWDParser.BOOL, 7:away.loaders.parsers.AWDParser.BOOL, 8:away.loaders.parsers.AWDParser.BOOL, 9:away.loaders.parsers.AWDParser.UINT8, 10:this._propsNrType, 11:away.loaders.parsers.AWDParser.BOOL, 12:this._propsNrType, 13:away.loaders.parsers.AWDParser.BOOL, 15:this._propsNrType, 16:away.loaders.parsers.AWDParser.UINT32, 17:away.loaders.parsers.AWDParser.BADDR, 18:this._propsNrType, 19:this._propsNrType, 20:away.loaders.parsers.AWDParser.UINT32, 21:away.loaders.parsers.AWDParser.BADDR, 22:away.loaders.parsers.AWDParser.BADDR});
	var spezialType = props.get(4, 0);
	var debugString = "";
	if (spezialType >= 2) {
		this._blocks[blockID].addError("Material-spezialType \'" + spezialType + "\' is not supported, can only be 0:singlePass, 1:MultiPass !");
		return;
	}
	if (this.get_materialMode() == 1) {
		spezialType = 0;
	} else if (this.get_materialMode() == 2) {
		spezialType = 1;
	}
	if (spezialType < 2) {
		if (type == 1) {
			var color = props.get(1, 0xcccccc);
			if (spezialType == 1) {
				mat = new away.materials.ColorMultiPassMaterial(color);
				debugString += "Parsed a ColorMaterial(MultiPass): Name = \'" + name + "\' | ";
			} else {
				mat = new away.materials.ColorMaterial(color, props.get(10, 1.0));
				mat.set_alphaBlending(props.get(11, false));
				debugString += "Parsed a ColorMaterial(SinglePass): Name = \'" + name + "\' | ";
			}
		} else if (type == 2) {
			var tex_addr = props.get(2, 0);
			returnedArray = this.getAssetByID(tex_addr, [away.library.assets.AssetType.TEXTURE], "SingleTexture");
			if (!returnedArray[0] && (tex_addr > 0)) {
				this._blocks[blockID].addError("Could not find the DiffuseTexture (ID = " + tex_addr + " ) for this TextureMaterial");
			}
			var texture = returnedArray[1];
			var ambientTexture;
			var ambientTex_addr = props.get(17, 0);
			returnedArray = this.getAssetByID(ambientTex_addr, [away.library.assets.AssetType.TEXTURE], "SingleTexture");
			if (!returnedArray[0] && (ambientTex_addr != 0)) {
				this._blocks[blockID].addError("Could not find the AmbientTexture (ID = " + ambientTex_addr + " ) for this TextureMaterial");
			}
			if (returnedArray[0]) {
				ambientTexture = returnedArray[1];
			}
			if (spezialType == 1) {
				mat = new away.materials.TextureMultiPassMaterial(texture, true, false, true);
				debugString += "Parsed a TextureMaterial(MultiPass): Name = \'" + name + "\' | Texture-Name = " + texture.get_name();
				if (ambientTexture) {
					mat.set_ambientTexture(ambientTexture);
					debugString += " | AmbientTexture-Name = " + ambientTexture.get_name();
				}
			} else {
				mat = new away.materials.TextureMaterial(texture, true, false, false);
				debugString += "Parsed a TextureMaterial(SinglePass): Name = \'" + name + "\' | Texture-Name = " + texture.get_name();
				if (ambientTexture) {
					mat.set_ambientTexture(ambientTexture);
					debugString += " | AmbientTexture-Name = " + ambientTexture.get_name();
				}
				mat.set_alpha(props.get(10, 1.0));
				mat.set_alphaBlending(props.get(11, false));
			}
		}
		var normalTex_addr = props.get(3, 0);
		returnedArray = this.getAssetByID(normalTex_addr, [away.library.assets.AssetType.TEXTURE], "SingleTexture");
		if (!returnedArray[0] && (normalTex_addr != 0)) {
			this._blocks[blockID].addError("Could not find the NormalTexture (ID = " + normalTex_addr + " ) for this TextureMaterial");
		}
		if (returnedArray[0]) {
			normalTexture = returnedArray[1];
			debugString += " | NormalTexture-Name = " + normalTexture.get_name();
		}
		var specTex_addr = props.get(21, 0);
		returnedArray = this.getAssetByID(specTex_addr, [away.library.assets.AssetType.TEXTURE], "SingleTexture");
		if (!returnedArray[0] && (specTex_addr != 0)) {
			this._blocks[blockID].addError("Could not find the SpecularTexture (ID = " + specTex_addr + " ) for this TextureMaterial");
		}
		if (returnedArray[0]) {
			specTexture = returnedArray[1];
			debugString += " | SpecularTexture-Name = " + specTexture.get_name();
		}
		var lightPickerAddr = props.get(22, 0);
		returnedArray = this.getAssetByID(lightPickerAddr, [away.library.assets.AssetType.LIGHT_PICKER], "SingleTexture");
		if (!returnedArray[0] && lightPickerAddr) {
			this._blocks[blockID].addError("Could not find the LightPicker (ID = " + lightPickerAddr + " ) for this TextureMaterial");
		} else {
			mat.set_lightPicker(returnedArray[1]);
		}
		mat.set_smooth(props.get(5, true));
		mat.set_mipmap(props.get(6, true));
		mat.set_bothSides(props.get(7, false));
		mat.set_alphaPremultiplied(props.get(8, false));
		mat.set_blendMode(this.blendModeDic[props.get(9, 0)]);
		mat.set_repeat(props.get(13, false));
		if (spezialType == 0) {
			if (normalTexture) {
				mat.set_normalMap(normalTexture);
			}
			if (specTexture) {
				mat.set_specularMap(specTexture);
			}
			mat.set_alphaThreshold(props.get(12, 0.0));
			mat.set_ambient(props.get(15, 1.0));
			mat.set_ambientColor(props.get(16, 0xffffff));
			mat.set_specular(props.get(18, 1.0));
			mat.set_gloss(props.get(19, 50));
			mat.set_specularColor(props.get(20, 0xffffff));
		} else {
			if (normalTexture) {
				mat.set_normalMap(normalTexture);
			}
			if (specTexture) {
				mat.set_specularMap(specTexture);
			}
			mat.set_alphaThreshold(props.get(12, 0.0));
			mat.set_ambient(props.get(15, 1.0));
			mat.set_ambientColor(props.get(16, 0xffffff));
			mat.set_specular(props.get(18, 1.0));
			mat.set_gloss(props.get(19, 50));
			mat.set_specularColor(props.get(20, 0xffffff));
		}
		var methods_parsed = 0;
		var targetID;
		while (methods_parsed < num_methods) {
			var method_type;
			method_type = this._newBlockBytes.readUnsignedShort();
			props = this.parseProperties({1:away.loaders.parsers.AWDParser.BADDR, 2:away.loaders.parsers.AWDParser.BADDR, 3:away.loaders.parsers.AWDParser.BADDR, 101:this._propsNrType, 102:this._propsNrType, 103:this._propsNrType, 201:away.loaders.parsers.AWDParser.UINT32, 202:away.loaders.parsers.AWDParser.UINT32, 301:away.loaders.parsers.AWDParser.UINT16, 302:away.loaders.parsers.AWDParser.UINT16, 401:away.loaders.parsers.AWDParser.UINT8, 402:away.loaders.parsers.AWDParser.UINT8, 601:away.loaders.parsers.AWDParser.COLOR, 602:away.loaders.parsers.AWDParser.COLOR, 701:away.loaders.parsers.AWDParser.BOOL, 702:away.loaders.parsers.AWDParser.BOOL, 801:away.loaders.parsers.AWDParser.MTX4x4});
			switch (method_type) {
				case 999:
					targetID = props.get(1, 0);
					returnedArray = this.getAssetByID(targetID, [away.library.assets.AssetType.EFFECTS_METHOD], "SingleTexture");
					if (!returnedArray[0]) {
						this._blocks[blockID].addError("Could not find the EffectMethod (ID = " + targetID + " ) for this Material");
					} else {
						if (spezialType == 0) {
							mat.addMethod(returnedArray[1]);
						}
						if (spezialType == 1) {
							mat.addMethod(returnedArray[1]);
						}
						debugString += " | EffectMethod-Name = " + returnedArray[1].get_name();
					}
					break;
				case 998:
					targetID = props.get(1, 0);
					returnedArray = this.getAssetByID(targetID, [away.library.assets.AssetType.SHADOW_MAP_METHOD], "SingleTexture");
					if (!returnedArray[0]) {
						this._blocks[blockID].addError("Could not find the ShadowMethod (ID = " + targetID + " ) for this Material");
					} else {
						if (spezialType == 0) {
							mat.set_shadowMethod(returnedArray[1]);
						}
						if (spezialType == 1) {
							mat.set_shadowMethod(returnedArray[1]);
						}
						debugString += " | ShadowMethod-Name = " + returnedArray[1].get_name();
					}
					break;
			}
			this.parseUserAttributes();
			methods_parsed += 1;
		}
	}
	mat.extra = this.parseUserAttributes();
	this._pFinalizeAsset(mat, name);
	this._blocks[blockID].data = mat;
	if (this._debug) {
		console.log(debugString);
	}
};

away.loaders.parsers.AWDParser.prototype.parseTexture = function(blockID) {
	var asset;
	this._blocks[blockID].name = this.parseVarStr();
	var type = this._newBlockBytes.readUnsignedByte();
	var data_len;
	this._texture_users[this._cur_block_id.toString(10)] = [];
	if (type == 0) {
		data_len = this._newBlockBytes.readUnsignedInt();
		var url;
		url = this._newBlockBytes.readUTFBytes(data_len);
		this._pAddDependency(this._cur_block_id.toString(10), new away.core.net.URLRequest(url), false, null, true);
	} else {
		data_len = this._newBlockBytes.readUnsignedInt();
		var data;
		data = new away.utils.ByteArray();
		this._newBlockBytes.readBytes(data, 0, data_len);
		this._pAddDependency(this._cur_block_id.toString(10), null, false, away.loaders.parsers.utils.ParserUtil.byteArrayToImage(data), true);
	}
	this.parseProperties(null);
	this._blocks[blockID].extras = this.parseUserAttributes();
	this._pPauseAndRetrieveDependencies();
	this._blocks[blockID].data = asset;
	if (this._debug) {
		var textureStylesNames = ["external", "embed"];
		console.log("Start parsing a " + textureStylesNames[type] + " Bitmap for Texture");
	}
};

away.loaders.parsers.AWDParser.prototype.parseCubeTexture = function(blockID) {
	var data_len;
	var asset;
	var i;
	this._cubeTextures = [];
	this._texture_users[this._cur_block_id.toString(10)] = [];
	var type = this._newBlockBytes.readUnsignedByte();
	this._blocks[blockID].name = this.parseVarStr();
	for (i = 0; i < 6; i++) {
		this._texture_users[this._cur_block_id.toString(10)] = [];
		this._cubeTextures.push(null);
		if (type == 0) {
			data_len = this._newBlockBytes.readUnsignedInt();
			var url;
			url = this._newBlockBytes.readUTFBytes(data_len);
			this._pAddDependency(this._cur_block_id.toString(10) + "#" + i, new away.core.net.URLRequest(url), false, null, true);
		} else {
			data_len = this._newBlockBytes.readUnsignedInt();
			var data;
			data = new away.utils.ByteArray();
			this._newBlockBytes.readBytes(data, 0, data_len);
			this._pAddDependency(this._cur_block_id.toString(10) + "#" + i, null, false, data, true);
		}
	}
	this.parseProperties(null);
	this._blocks[blockID].extras = this.parseUserAttributes();
	this._pPauseAndRetrieveDependencies();
	this._blocks[blockID].data = asset;
	if (this._debug) {
		var textureStylesNames = ["external", "embed"];
		console.log("Start parsing 6 " + textureStylesNames[type] + " Bitmaps for CubeTexture");
	}
};

away.loaders.parsers.AWDParser.prototype.parseSharedMethodBlock = function(blockID) {
	var asset;
	this._blocks[blockID].name = this.parseVarStr();
	asset = this.parseSharedMethodList(blockID);
	this.parseUserAttributes();
	this._blocks[blockID].data = asset;
	this._pFinalizeAsset(asset, this._blocks[blockID].name);
	this._blocks[blockID].data = asset;
	if (this._debug) {
		console.log("Parsed a EffectMethod: Name = " + asset.get_name() + " Type = " + asset);
	}
};

away.loaders.parsers.AWDParser.prototype.parseShadowMethodBlock = function(blockID) {
	var type;
	var data_len;
	var asset;
	var shadowLightID;
	this._blocks[blockID].name = this.parseVarStr();
	shadowLightID = this._newBlockBytes.readUnsignedInt();
	var returnedArray = this.getAssetByID(shadowLightID, [away.library.assets.AssetType.LIGHT], "SingleTexture");
	if (!returnedArray[0]) {
		this._blocks[blockID].addError("Could not find the TargetLight (ID = " + shadowLightID + " ) for this ShadowMethod - ShadowMethod not created");
		return;
	}
	asset = this.parseShadowMethodList(returnedArray[1], blockID);
	if (!asset)
		return;
	this.parseUserAttributes();
	this._pFinalizeAsset(asset, this._blocks[blockID].name);
	this._blocks[blockID].data = asset;
	if (this._debug) {
		console.log("Parsed a ShadowMapMethodMethod: Name = " + asset.get_name() + " | Type = " + asset + " | Light-Name = ", returnedArray[1].get_name());
	}
};

away.loaders.parsers.AWDParser.prototype.parseCommand = function(blockID) {
	var hasBlocks = (this._newBlockBytes.readUnsignedByte() == 1);
	var par_id = this._newBlockBytes.readUnsignedInt();
	var mtx = this.parseMatrix3D();
	var name = this.parseVarStr();
	var parentObject;
	var targetObject;
	var returnedArray = this.getAssetByID(par_id, [away.library.assets.AssetType.CONTAINER, away.library.assets.AssetType.LIGHT, away.library.assets.AssetType.MESH, away.library.assets.AssetType.ENTITY, away.library.assets.AssetType.SEGMENT_SET], "SingleTexture");
	if (returnedArray[0]) {
		parentObject = returnedArray[1];
	}
	var numCommands = this._newBlockBytes.readShort();
	var typeCommand = this._newBlockBytes.readShort();
	var props = this.parseProperties({1:away.loaders.parsers.AWDParser.BADDR});
	switch (typeCommand) {
		case 1:
			var targetID = props.get(1, 0);
			var returnedArrayTarget = this.getAssetByID(targetID, [away.library.assets.AssetType.LIGHT, away.library.assets.AssetType.TEXTURE_PROJECTOR], "SingleTexture");
			if (!returnedArrayTarget[0] && (targetID != 0)) {
				this._blocks[blockID].addError("Could not find the light (ID = " + targetID + " ( for this CommandBock!");
				return;
			}
			targetObject = returnedArrayTarget[1];
			if (parentObject) {
				parentObject.addChild(targetObject);
			}
			targetObject.set_transform(mtx);
			break;
	}
	if (targetObject) {
		props = this.parseProperties({1:this._matrixNrType, 2:this._matrixNrType, 3:this._matrixNrType, 4:away.loaders.parsers.AWDParser.UINT8});
		targetObject.set_pivotPoint(new away.core.geom.Vector3D(props.get(1, 0), props.get(2, 0), props.get(3, 0), 0));
		targetObject.extra = this.parseUserAttributes();
	}
	this._blocks[blockID].data = targetObject;
	if (this._debug) {
		console.log("Parsed a CommandBlock: Name = \'" + name);
	}
};

away.loaders.parsers.AWDParser.prototype.parseMetaData = function(blockID) {
	var props = this.parseProperties({1:away.loaders.parsers.AWDParser.UINT32, 2:away.loaders.parsers.AWDParser.AWDSTRING, 3:away.loaders.parsers.AWDParser.AWDSTRING, 4:away.loaders.parsers.AWDParser.AWDSTRING, 5:away.loaders.parsers.AWDParser.AWDSTRING});
	if (this._debug) {
		console.log("Parsed a MetaDataBlock: TimeStamp         = " + props.get(1, 0));
		console.log("                        EncoderName       = " + props.get(2, "unknown"));
		console.log("                        EncoderVersion    = " + props.get(3, "unknown"));
		console.log("                        GeneratorName     = " + props.get(4, "unknown"));
		console.log("                        GeneratorVersion  = " + props.get(5, "unknown"));
	}
};

away.loaders.parsers.AWDParser.prototype.parseNameSpace = function(blockID) {
	var id = this._newBlockBytes.readUnsignedByte();
	var nameSpaceString = this.parseVarStr();
	if (this._debug)
		console.log("Parsed a NameSpaceBlock: ID = " + id + " | String = " + nameSpaceString);
};

away.loaders.parsers.AWDParser.prototype.parseShadowMethodList = function(light, blockID) {
	var methodType = this._newBlockBytes.readUnsignedShort();
	var shadowMethod;
	var props = this.parseProperties({1:away.loaders.parsers.AWDParser.BADDR, 2:away.loaders.parsers.AWDParser.BADDR, 3:away.loaders.parsers.AWDParser.BADDR, 101:this._propsNrType, 102:this._propsNrType, 103:this._propsNrType, 201:away.loaders.parsers.AWDParser.UINT32, 202:away.loaders.parsers.AWDParser.UINT32, 301:away.loaders.parsers.AWDParser.UINT16, 302:away.loaders.parsers.AWDParser.UINT16, 401:away.loaders.parsers.AWDParser.UINT8, 402:away.loaders.parsers.AWDParser.UINT8, 601:away.loaders.parsers.AWDParser.COLOR, 602:away.loaders.parsers.AWDParser.COLOR, 701:away.loaders.parsers.AWDParser.BOOL, 702:away.loaders.parsers.AWDParser.BOOL, 801:away.loaders.parsers.AWDParser.MTX4x4});
	var targetID;
	var returnedArray;
	switch (methodType) {
		}
		this.parseUserAttributes();
		return shadowMethod;
	};
	
	away.loaders.parsers.AWDParser.prototype.parseSharedMethodList = function(blockID) {
		var methodType = this._newBlockBytes.readUnsignedShort();
		var effectMethodReturn;
		var props = this.parseProperties({1:away.loaders.parsers.AWDParser.BADDR, 2:away.loaders.parsers.AWDParser.BADDR, 3:away.loaders.parsers.AWDParser.BADDR, 101:this._propsNrType, 102:this._propsNrType, 103:this._propsNrType, 104:this._propsNrType, 105:this._propsNrType, 106:this._propsNrType, 107:this._propsNrType, 201:away.loaders.parsers.AWDParser.UINT32, 202:away.loaders.parsers.AWDParser.UINT32, 301:away.loaders.parsers.AWDParser.UINT16, 302:away.loaders.parsers.AWDParser.UINT16, 401:away.loaders.parsers.AWDParser.UINT8, 402:away.loaders.parsers.AWDParser.UINT8, 601:away.loaders.parsers.AWDParser.COLOR, 602:away.loaders.parsers.AWDParser.COLOR, 701:away.loaders.parsers.AWDParser.BOOL, 702:away.loaders.parsers.AWDParser.BOOL});
		var targetID;
		var returnedArray;
		switch (methodType) {
			}
			this.parseUserAttributes();
			return effectMethodReturn;
		};
		
		away.loaders.parsers.AWDParser.prototype.parseUserAttributes = function() {
			var attributes;
			var list_len;
			var attibuteCnt;
			list_len = this._newBlockBytes.readUnsignedInt();
			if (list_len > 0) {
				var list_end;
				attributes = {};
				list_end = this._newBlockBytes.position + list_len;
				while (this._newBlockBytes.position < list_end) {
					var ns_id;
					var attr_key;
					var attr_type;
					var attr_len;
					var attr_val;
					ns_id = this._newBlockBytes.readUnsignedByte();
					attr_key = this.parseVarStr();
					attr_type = this._newBlockBytes.readUnsignedByte();
					attr_len = this._newBlockBytes.readUnsignedInt();
					if ((this._newBlockBytes.position + attr_len) > list_end) {
						console.log("           Error in reading attribute # " + attibuteCnt + " = skipped to end of attribute-list");
						this._newBlockBytes.position = list_end;
						return attributes;
					}
					switch (attr_type) {
						case away.loaders.parsers.AWDParser.AWDSTRING:
							attr_val = this._newBlockBytes.readUTFBytes(attr_len);
							break;
						case away.loaders.parsers.AWDParser.INT8:
							attr_val = this._newBlockBytes.readByte();
							break;
						case away.loaders.parsers.AWDParser.INT16:
							attr_val = this._newBlockBytes.readShort();
							break;
						case away.loaders.parsers.AWDParser.INT32:
							attr_val = this._newBlockBytes.readInt();
							break;
						case away.loaders.parsers.AWDParser.BOOL:
						
						case away.loaders.parsers.AWDParser.UINT8:
							attr_val = this._newBlockBytes.readUnsignedByte();
							break;
						case away.loaders.parsers.AWDParser.UINT16:
							attr_val = this._newBlockBytes.readUnsignedShort();
							break;
						case away.loaders.parsers.AWDParser.UINT32:
						
						case away.loaders.parsers.AWDParser.BADDR:
							attr_val = this._newBlockBytes.readUnsignedInt();
							break;
						case away.loaders.parsers.AWDParser.FLOAT32:
							attr_val = this._newBlockBytes.readFloat();
							break;
						case away.loaders.parsers.AWDParser.FLOAT64:
							attr_val = this._newBlockBytes.readDouble();
							break;
						default:
							attr_val = "unimplemented attribute type " + attr_type;
							this._newBlockBytes.position += attr_len;
							break;
					}
					if (this._debug) {
						console.log("attribute = name: " + attr_key + "  \/ value = " + attr_val);
					}
					attributes[attr_key] = attr_val;
					attibuteCnt += 1;
				}
			}
			return attributes;
		};
		
		away.loaders.parsers.AWDParser.prototype.parseProperties = function(expected) {
			var list_end;
			var list_len;
			var propertyCnt = 0;
			var props = new away.loaders.parsers.AWDProperties();
			list_len = this._newBlockBytes.readUnsignedInt();
			list_end = this._newBlockBytes.position + list_len;
			if (expected) {
				while (this._newBlockBytes.position < list_end) {
					var len;
					var key;
					var type;
					key = this._newBlockBytes.readUnsignedShort();
					len = this._newBlockBytes.readUnsignedInt();
					if ((this._newBlockBytes.position + len) > list_end) {
						console.log("           Error in reading property # " + propertyCnt + " = skipped to end of propertie-list");
						this._newBlockBytes.position = list_end;
						return props;
					}
					if (expected.hasOwnProperty(key.toString(10))) {
						type = expected[key];
						props.set(key, this.parseAttrValue(type, len));
					} else {
						this._newBlockBytes.position += len;
					}
					propertyCnt += 1;
				}
			} else {
				this._newBlockBytes.position = list_end;
			}
			return props;
		};
		
		away.loaders.parsers.AWDParser.prototype.parseAttrValue = function(type, len) {
			var elem_len;
			var read_func;
			switch (type) {
				case away.loaders.parsers.AWDParser.BOOL:
				
				case away.loaders.parsers.AWDParser.INT8:
					elem_len = 1;
					read_func = this._newBlockBytes.readByte;
					break;
				case away.loaders.parsers.AWDParser.INT16:
					elem_len = 2;
					read_func = this._newBlockBytes.readShort;
					break;
				case away.loaders.parsers.AWDParser.INT32:
					elem_len = 4;
					read_func = this._newBlockBytes.readInt;
					break;
				case away.loaders.parsers.AWDParser.UINT8:
					elem_len = 1;
					read_func = this._newBlockBytes.readUnsignedByte;
					break;
				case away.loaders.parsers.AWDParser.UINT16:
					elem_len = 2;
					read_func = this._newBlockBytes.readUnsignedShort;
					break;
				case away.loaders.parsers.AWDParser.UINT32:
				
				case away.loaders.parsers.AWDParser.COLOR:
				
				case away.loaders.parsers.AWDParser.BADDR:
					elem_len = 4;
					read_func = this._newBlockBytes.readUnsignedInt;
					break;
				case away.loaders.parsers.AWDParser.FLOAT32:
					elem_len = 4;
					read_func = this._newBlockBytes.readFloat;
					break;
				case away.loaders.parsers.AWDParser.FLOAT64:
					elem_len = 8;
					read_func = this._newBlockBytes.readDouble;
					break;
				case away.loaders.parsers.AWDParser.AWDSTRING:
					return this._newBlockBytes.readUTFBytes(len);
				case away.loaders.parsers.AWDParser.VECTOR2x1:
				
				case away.loaders.parsers.AWDParser.VECTOR3x1:
				
				case away.loaders.parsers.AWDParser.VECTOR4x1:
				
				case away.loaders.parsers.AWDParser.MTX3x2:
				
				case away.loaders.parsers.AWDParser.MTX3x3:
				
				case away.loaders.parsers.AWDParser.MTX4x3:
				
				case away.loaders.parsers.AWDParser.MTX4x4:
					elem_len = 8;
					read_func = this._newBlockBytes.readDouble;
					break;
			}
			if (elem_len < len) {
				var list = [];
				var num_read = 0;
				var num_elems = len / elem_len;
				while (num_read < num_elems) {
					list.push(read_func.apply(this._newBlockBytes));
					num_read++;
				}
				return list;
			} else {
				var val = read_func.apply(this._newBlockBytes);
				return val;
			}
		};
		
		away.loaders.parsers.AWDParser.prototype.parseHeader = function() {
			var flags;
			var body_len;
			this._byteData.position = 3;
			this._version[0] = this._byteData.readUnsignedByte();
			this._version[1] = this._byteData.readUnsignedByte();
			flags = this._byteData.readUnsignedShort();
			this._streaming = away.loaders.parsers.bitFlags.test(flags, away.loaders.parsers.bitFlags.FLAG1);
			if ((this._version[0] == 2) && (this._version[1] == 1)) {
				this._accuracyMatrix = away.loaders.parsers.bitFlags.test(flags, away.loaders.parsers.bitFlags.FLAG2);
				this._accuracyGeo = away.loaders.parsers.bitFlags.test(flags, away.loaders.parsers.bitFlags.FLAG3);
				this._accuracyProps = away.loaders.parsers.bitFlags.test(flags, away.loaders.parsers.bitFlags.FLAG4);
			}
			this._geoNrType = away.loaders.parsers.AWDParser.FLOAT32;
			if (this._accuracyGeo) {
				this._geoNrType = away.loaders.parsers.AWDParser.FLOAT64;
			}
			this._matrixNrType = away.loaders.parsers.AWDParser.FLOAT32;
			if (this._accuracyMatrix) {
				this._matrixNrType = away.loaders.parsers.AWDParser.FLOAT64;
			}
			this._propsNrType = away.loaders.parsers.AWDParser.FLOAT32;
			if (this._accuracyProps) {
				this._propsNrType = away.loaders.parsers.AWDParser.FLOAT64;
			}
			this._compression = this._byteData.readUnsignedByte();
			if (this._debug) {
				console.log("Import AWDFile of version = " + this._version[0] + " - " + this._version[1]);
				console.log("Global Settings = Compression = " + this._compression + " | Streaming = " + this._streaming + " | Matrix-Precision = " + this._accuracyMatrix + " | Geometry-Precision = " + this._accuracyGeo + " | Properties-Precision = " + this._accuracyProps);
			}
			body_len = this._byteData.readUnsignedInt();
			if (!this._streaming && body_len != this._byteData.getBytesAvailable()) {
				this._pDieWithError("AWD2 body length does not match header integrity field");
			}
		};
		
		away.loaders.parsers.AWDParser.prototype.parseVarStr = function() {
			var len = this._newBlockBytes.readUnsignedShort();
			return this._newBlockBytes.readUTFBytes(len);
		};
		
		away.loaders.parsers.AWDParser.prototype.getAssetByID = function(assetID, assetTypesToGet, extraTypeInfo) {
			extraTypeInfo = extraTypeInfo || "SingleTexture";
			var returnArray = [];
			var typeCnt = 0;
			if (assetID > 0) {
				if (this._blocks[assetID]) {
					if (this._blocks[assetID].data) {
						while (typeCnt < assetTypesToGet.length) {
							var iasset = this._blocks[assetID].data;
							if (iasset.get_assetType() == assetTypesToGet[typeCnt]) {
								if ((assetTypesToGet[typeCnt] == away.library.assets.AssetType.TEXTURE) && (extraTypeInfo == "CubeTexture")) {
									if (this._blocks[assetID].data instanceof away.textures.HTMLImageElementCubeTexture) {
										returnArray.push(true);
										returnArray.push(this._blocks[assetID].data);
										return returnArray;
									}
								}
								if ((assetTypesToGet[typeCnt] == away.library.assets.AssetType.TEXTURE) && (extraTypeInfo == "SingleTexture")) {
									if (this._blocks[assetID].data instanceof away.textures.HTMLImageElementTexture) {
										returnArray.push(true);
										returnArray.push(this._blocks[assetID].data);
										return returnArray;
									}
								} else {
									returnArray.push(true);
									returnArray.push(this._blocks[assetID].data);
									return returnArray;
								}
							}
							if ((assetTypesToGet[typeCnt] == away.library.assets.AssetType.GEOMETRY) && (iasset.get_assetType() == away.library.assets.AssetType.MESH)) {
								var mesh = this._blocks[assetID].data;
								returnArray.push(true);
								returnArray.push(mesh.get_geometry());
								return returnArray;
							}
							typeCnt++;
						}
					}
				}
			}
			returnArray.push(false);
			returnArray.push(this.getDefaultAsset(assetTypesToGet[0], extraTypeInfo));
			return returnArray;
		};
		
		away.loaders.parsers.AWDParser.prototype.getDefaultAsset = function(assetType, extraTypeInfo) {
			switch (true) {
				case (assetType == away.library.assets.AssetType.TEXTURE):
					if (extraTypeInfo == "CubeTexture")
						return this.getDefaultCubeTexture();
					if (extraTypeInfo == "SingleTexture")
						return this.getDefaultTexture();
					break;
				case (assetType == away.library.assets.AssetType.MATERIAL):
					return this.getDefaultMaterial();
					break;
				default:
					break;
			}
			return null;
		};
		
		away.loaders.parsers.AWDParser.prototype.getDefaultMaterial = function() {
			if (!this._defaultBitmapMaterial)
				this._defaultBitmapMaterial = away.materials.utils.DefaultMaterialManager.getDefaultMaterial();
			return this._defaultBitmapMaterial;
		};
		
		away.loaders.parsers.AWDParser.prototype.getDefaultTexture = function() {
			if (!this._defaultTexture) {
				this._defaultTexture = away.materials.utils.DefaultMaterialManager.getDefaultTexture();
			}
			return this._defaultTexture;
		};
		
		away.loaders.parsers.AWDParser.prototype.getDefaultCubeTexture = function() {
			if (!this._defaultCubeTexture) {
				var defaultBitmap = away.materials.utils.DefaultMaterialManager.createCheckeredBitmapData();
				this._defaultCubeTexture = new away.textures.BitmapCubeTexture(defaultBitmap, defaultBitmap, defaultBitmap, defaultBitmap, defaultBitmap, defaultBitmap);
				this._defaultCubeTexture.set_name("defaultTexture");
			}
			return this._defaultCubeTexture;
		};
		
		away.loaders.parsers.AWDParser.prototype.readNumber = function(precision) {
			if (precision)
				return this._newBlockBytes.readDouble();
			return this._newBlockBytes.readFloat();
		};
		
		away.loaders.parsers.AWDParser.prototype.parseMatrix3D = function() {
			return new away.core.geom.Matrix3D(this.parseMatrix43RawData());
		};
		
		away.loaders.parsers.AWDParser.prototype.parseMatrix32RawData = function() {
			var i;
			var mtx_raw = away.utils.VectorInit.Num(6, 0);
			for (i = 0; i < 6; i++) {
				mtx_raw[i] = this._newBlockBytes.readFloat();
			}
			return mtx_raw;
		};
		
		away.loaders.parsers.AWDParser.prototype.parseMatrix43RawData = function() {
			var mtx_raw = away.utils.VectorInit.Num(16, 0);
			mtx_raw[0] = this.readNumber(this._accuracyMatrix);
			mtx_raw[1] = this.readNumber(this._accuracyMatrix);
			mtx_raw[2] = this.readNumber(this._accuracyMatrix);
			mtx_raw[3] = 0.0;
			mtx_raw[4] = this.readNumber(this._accuracyMatrix);
			mtx_raw[5] = this.readNumber(this._accuracyMatrix);
			mtx_raw[6] = this.readNumber(this._accuracyMatrix);
			mtx_raw[7] = 0.0;
			mtx_raw[8] = this.readNumber(this._accuracyMatrix);
			mtx_raw[9] = this.readNumber(this._accuracyMatrix);
			mtx_raw[10] = this.readNumber(this._accuracyMatrix);
			mtx_raw[11] = 0.0;
			mtx_raw[12] = this.readNumber(this._accuracyMatrix);
			mtx_raw[13] = this.readNumber(this._accuracyMatrix);
			mtx_raw[14] = this.readNumber(this._accuracyMatrix);
			mtx_raw[15] = 1.0;
			if (isNaN(mtx_raw[0])) {
				mtx_raw[0] = 1;
				mtx_raw[1] = 0;
				mtx_raw[2] = 0;
				mtx_raw[4] = 0;
				mtx_raw[5] = 1;
				mtx_raw[6] = 0;
				mtx_raw[8] = 0;
				mtx_raw[9] = 0;
				mtx_raw[10] = 1;
				mtx_raw[12] = 0;
				mtx_raw[13] = 0;
				mtx_raw[14] = 0;
			}
			return mtx_raw;
		};
		
		$inherit(away.loaders.parsers.AWDParser, away.loaders.parsers.ParserBase);
		
		away.loaders.parsers.AWDParser.className = "away.loaders.parsers.AWDParser";
		
		away.loaders.parsers.AWDParser.getRuntimeDependencies = function(t) {
			var p;
			p = [];
			p.push('away.lights.LightBase');
			p.push('away.textures.HTMLImageElementCubeTexture');
			p.push('away.core.net.URLRequest');
			p.push('away.lights.DirectionalLight');
			p.push('away.materials.TextureMaterial');
			p.push('away.primitives.ConeGeometry');
			p.push('away.cameras.Camera3D');
			p.push('away.loaders.parsers.AWDBlock');
			p.push('away.textures.HTMLImageElementTexture');
			p.push('away.materials.ColorMultiPassMaterial');
			p.push('away.primitives.CubeGeometry');
			p.push('away.utils.GeometryUtils');
			p.push('away.cameras.lenses.PerspectiveLens');
			p.push('away.cameras.lenses.OrthographicOffCenterLens');
			p.push('away.materials.lightpickers.StaticLightPicker');
			p.push('away.cameras.lenses.OrthographicLens');
			p.push('away.primitives.CylinderGeometry');
			p.push('away.core.geom.Matrix3D');
			p.push('away.loaders.parsers.utils.ParserUtil');
			p.push('away.materials.TextureMultiPassMaterial');
			p.push('away.lights.shadowmaps.DirectionalShadowMapper');
			p.push('away.utils.VectorInit');
			p.push('away.core.base.Geometry');
			p.push('away.library.assets.AssetType');
			p.push('away.lights.shadowmaps.CubeMapShadowMapper');
			p.push('away.primitives.SphereGeometry');
			p.push('away.utils.ByteArray');
			p.push('away.materials.MaterialBase');
			p.push('away.lights.PointLight');
			p.push('away.primitives.CapsuleGeometry');
			p.push('Object');
			p.push('away.primitives.TorusGeometry');
			p.push('away.loaders.parsers.ParserDataFormat');
			p.push('away.loaders.parsers.ParserBase');
			p.push('away.primitives.PlaneGeometry');
			p.push('away.textures.BitmapCubeTexture');
			p.push('away.loaders.misc.ResourceDependency');
			p.push('away.loaders.parsers.AWDProperties');
			p.push('away.core.display.BlendMode');
			p.push('away.core.geom.Vector3D');
			p.push('away.entities.Mesh');
			p.push('away.loaders.parsers.bitFlags');
			p.push('away.materials.ColorMaterial');
			p.push('away.containers.ObjectContainer3D');
			p.push('away.materials.utils.DefaultMaterialManager');
			return p;
		};
		
		away.loaders.parsers.AWDParser.getStaticDependencies = function(t) {
			var p;
			return [];
		};
		
		away.loaders.parsers.AWDParser.injectionPoints = function(t) {
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
		
		