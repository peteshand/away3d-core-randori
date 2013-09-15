/** Compiled by the Randori compiler v0.2.6.2 on Fri Sep 13 21:20:09 EST 2013 */

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
	this._accuracyOnBlocks = null;
	this._byteData = null;
	this._compression = 0;
	this._accuracyGeo = null;
	this._cubeTextures = null;
	this._blocks = null;
	this._accuracyProps = null;
	this._newBlockBytes = null;
	this._streaming = null;
	this._propsNrType = 0;
	this._body = null;
	this._defaultBitmapMaterial = null;
	this._depthSizeDic = null;
	this._defaultTexture = null;
	this._version = null;
	this._accuracyMatrix = null;
	this._matrixNrType = 0;
	this._parsed_header = false;
	away.loaders.parsers.ParserBase.call(this, away.loaders.parsers.ParserDataFormat.BINARY);
	this._blocks = [];
	this._blocks[0] = new away.loaders.parsers.AWDParser$AWDBlock();
	this._blocks[0].data = null;
	this.blendModeDic = [];
	this.blendModeDic.push(away.display.BlendMode.NORMAL);
	this.blendModeDic.push(away.display.BlendMode.ADD);
	this.blendModeDic.push(away.display.BlendMode.ALPHA);
	this.blendModeDic.push(away.display.BlendMode.DARKEN);
	this.blendModeDic.push(away.display.BlendMode.DIFFERENCE);
	this.blendModeDic.push(away.display.BlendMode.ERASE);
	this.blendModeDic.push(away.display.BlendMode.HARDLIGHT);
	this.blendModeDic.push(away.display.BlendMode.INVERT);
	this.blendModeDic.push(away.display.BlendMode.LAYER);
	this.blendModeDic.push(away.display.BlendMode.LIGHTEN);
	this.blendModeDic.push(away.display.BlendMode.MULTIPLY);
	this.blendModeDic.push(away.display.BlendMode.NORMAL);
	this.blendModeDic.push(away.display.BlendMode.OVERLAY);
	this.blendModeDic.push(away.display.BlendMode.SCREEN);
	this.blendModeDic.push(away.display.BlendMode.SHADER);
	this.blendModeDic.push(away.display.BlendMode.OVERLAY);
	this._depthSizeDic = [];
	this._depthSizeDic.push(256);
	this._depthSizeDic.push(512);
	this._depthSizeDic.push(2048);
	this._depthSizeDic.push(1024);
	this._version = [];
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
	while (this._body.getBytesAvailable() > 0 && !this.get_parsingPaused()) {
		this.parseNextBlock();
	}
	if (this._body.getBytesAvailable() == 0) {
		this.dispose();
		return away.loaders.parsers.ParserBase.PARSING_DONE;
	} else {
		return away.loaders.parsers.ParserBase.MORE_TO_PARSE;
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
	var blockCompression = away.loaders.parsers.AWDParser$bitFlags.test(flags, bitFlags.FLAG4);
	var blockCompressionLZMA = away.loaders.parsers.AWDParser$bitFlags.test(flags, bitFlags.FLAG5);
	if (this._accuracyOnBlocks) {
		this._accuracyMatrix = away.loaders.parsers.AWDParser$bitFlags.test(flags, bitFlags.FLAG1);
		this._accuracyGeo = away.loaders.parsers.AWDParser$bitFlags.test(flags, bitFlags.FLAG2);
		this._accuracyProps = away.loaders.parsers.AWDParser$bitFlags.test(flags, bitFlags.FLAG3);
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
	block = new away.loaders.parsers.AWDParser$AWDBlock();
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
		console.log("parse version 2.1");
	}
	if (isParsed == false) {
		console.log("type", type);
		switch (type) {
			case 1:
				break;
			case 22:
				break;
			case 23:
				break;
			case 81:
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
				break;
			case 255:
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

away.loaders.parsers.AWDParser.prototype.dispose = function() {
	for (var c in this._blocks) {
		var b = this._blocks[c];
		b.dispose();
	}
};

away.loaders.parsers.AWDParser.prototype.parseVarStr = function() {
	var len = this._newBlockBytes.readUnsignedShort();
	return this._newBlockBytes.readUTFBytes(len);
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
		this._pAddDependency(this._cur_block_id.toString(10), new away.net.URLRequest(url), false, null, true);
	} else {
		data_len = this._newBlockBytes.readUnsignedInt();
		var data;
		data = new away.utils.ByteArray();
		this._newBlockBytes.readBytes(data, 0, data_len);
		data.position = 0;
		away.loaders.parsers.utils.ParserUtil.byteArrayToImage(data);
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
	var props = new away.loaders.parsers.AWDParser$AWDProperties();
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
		var list;
		var num_read;
		var num_elems;
		list = [];
		num_read = 0;
		num_elems = len / elem_len;
		while (num_read < num_elems) {
			list.push(read_func());
			num_read++;
		}
		return list;
	} else {
		var val;
		val = read_func();
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
	this._streaming = away.loaders.parsers.AWDParser$bitFlags.test(flags, bitFlags.FLAG1);
	if ((this._version[0] == 2) && (this._version[1] == 1)) {
		this._accuracyMatrix = away.loaders.parsers.AWDParser$bitFlags.test(flags, bitFlags.FLAG2);
		this._accuracyGeo = away.loaders.parsers.AWDParser$bitFlags.test(flags, bitFlags.FLAG3);
		this._accuracyProps = away.loaders.parsers.AWDParser$bitFlags.test(flags, bitFlags.FLAG4);
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

$inherit(away.loaders.parsers.AWDParser, away.loaders.parsers.ParserBase);

away.loaders.parsers.AWDParser.className = "away.loaders.parsers.AWDParser";

away.loaders.parsers.AWDParser.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.net.URLRequest');
	p.push('away.utils.ByteArray');
	p.push('away.loaders.parsers.AWDParser$bitFlags');
	p.push('away.loaders.misc.ResourceDependency');
	p.push('away.loaders.parsers.utils.ParserUtil');
	p.push('away.display.BlendMode');
	p.push('away.loaders.parsers.ParserDataFormat');
	p.push('away.loaders.parsers.ParserBase');
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

away.loaders.parsers.AWDParser$AWDBlock = function() {
	this.bytes = null;
	this.errorMessages = null;
	this.data = null;
	this.len = null;
	this.extras = null;
	this.id = 0;
	this.geoID = 0;
	this.name = null;
	this.uvsForVertexAnimation = null;
	
};

away.loaders.parsers.AWDParser$AWDBlock.prototype.AWDBlockAWDBlock = function() {
};

away.loaders.parsers.AWDParser$AWDBlock.prototype.dispose = function() {
	this.id = null;
	this.bytes = null;
	this.errorMessages = null;
	this.uvsForVertexAnimation = null;
};

away.loaders.parsers.AWDParser$AWDBlock.prototype.addError = function(errorMsg) {
	if (!this.errorMessages)
		this.errorMessages = [];
	this.errorMessages.push(errorMsg);
};

away.loaders.parsers.AWDParser$bitFlags = function() {
	
};

away.loaders.parsers.AWDParser$bitFlags.FLAG1 = 1;

away.loaders.parsers.AWDParser$bitFlags.FLAG2 = 2;

away.loaders.parsers.AWDParser$bitFlags.FLAG3 = 4;

away.loaders.parsers.AWDParser$bitFlags.FLAG4 = 8;

away.loaders.parsers.AWDParser$bitFlags.FLAG5 = 16;

away.loaders.parsers.AWDParser$bitFlags.FLAG6 = 32;

away.loaders.parsers.AWDParser$bitFlags.FLAG7 = 64;

away.loaders.parsers.AWDParser$bitFlags.FLAG8 = 128;

away.loaders.parsers.AWDParser$bitFlags.FLAG9 = 256;

away.loaders.parsers.AWDParser$bitFlags.FLAG10 = 512;

away.loaders.parsers.AWDParser$bitFlags.FLAG11 = 1024;

away.loaders.parsers.AWDParser$bitFlags.FLAG12 = 2048;

away.loaders.parsers.AWDParser$bitFlags.FLAG13 = 4096;

away.loaders.parsers.AWDParser$bitFlags.FLAG14 = 8192;

away.loaders.parsers.AWDParser$bitFlags.FLAG15 = 16384;

away.loaders.parsers.AWDParser$bitFlags.FLAG16 = 32768;

away.loaders.parsers.AWDParser$bitFlags.test = function(flags, testFlag) {
	return (flags & testFlag) == testFlag;
};

away.loaders.parsers.AWDParser$AWDProperties = function() {
	
};

away.loaders.parsers.AWDParser$AWDProperties.prototype.set = function(key, value) {
	this[key.toString(10)] = value;
};

away.loaders.parsers.AWDParser$AWDProperties.prototype.get = function(key, fallback) {
	if (this.hasOwnProperty(key.toString(10))) {
		return this[key.toString(10)];
	} else {
		return fallback;
	}
};

