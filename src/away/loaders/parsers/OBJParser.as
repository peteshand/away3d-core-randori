///<reference path="../../_definitions.ts"/>

package away.loaders.parsers
{
	import away.entities.Mesh;
	import away.base.data.Vertex;
	import away.base.data.UV;
	import away.loaders.parsers.utils.ParserUtil;
	import away.loaders.misc.ResourceDependency;
	import away.library.assets.IAsset;
	import away.library.assets.AssetType;
	import away.textures.Texture2DBase;
	import away.base.Geometry;
	import away.materials.MaterialBase;
	import away.materials.TextureMaterial;
	import away.materials.utils.DefaultMaterialManager;
	import away.materials.TextureMultiPassMaterial;
	import away.base.ISubGeometry;
	import away.utils.GeometryUtils;
	import away.materials.methods.BasicSpecularMethod;
	import away.net.URLRequest;
	import away.materials.ColorMaterial;
	import away.materials.ColorMultiPassMaterial;
	import randori.webkit.page.Window;

	/**
	public class OBJParser extends ParserBase
	{
		private var _textData:String;
		private var _startedParsing:Boolean;
		private var _charIndex:Number;
		private var _oldIndex:Number;
		private var _stringLength:Number;
		private var _currentObject:ObjectGroup;
		private var _currentGroup:Group;
		private var _currentMaterialGroup:MaterialGroup;
		private var _objects:Vector.<ObjectGroup>;
		private var _materialIDs:Vector.<String>;
		private var _materialLoaded:Vector.<LoadedMaterial>;
		private var _materialSpecularData:Vector.<SpecularData>;
		private var _meshes:Vector.<Mesh>;
		private var _lastMtlID:String;
		private var _objectIndex:Number;
		private var _realIndices;
		private var _vertexIndex:Number;
		private var _vertices:Vector.<Vertex>;
		private var _vertexNormals:Vector.<Vertex>;
		private var _uvs:Vector.<UV>;
		private var _scale:Number;
		private var _mtlLib:Boolean;
		private var _mtlLibLoaded:Boolean = true;
		private var _activeMaterialID:String = "";
		
		/**
		public function OBJParser(scale:Number = 1):void
		{
			super(ParserDataFormat.PLAIN_TEXT);
			this._scale = scale;
		}
		
		/**
		public function set scale(value:Number):void
		{
			this._scale = value;
		}
		
		/**
		public static function supportsType(extension:String):Boolean
		{
			extension = extension.toLowerCase();
			return extension == "obj";
		}
		
		/**
		public static function supportsData(data:*):Boolean
		{
			var content:String = ParserUtil.toString(data);
			var hasV : Boolean = false;
			var hasF : Boolean = false;
			
			if (content)
            {
				hasV = content.indexOf("\nv ") != -1;
				hasF = content.indexOf("\nf ") != -1;
			}
			
			return hasV && hasF;
		}
		
		/**
		override public function _iResolveDependency(resourceDependency:ResourceDependency):void
		{
			if (resourceDependency.id == 'mtl')
            {
				var str:String = ParserUtil.toString(resourceDependency.data);
				parseMtl(str);
				
			}
            else
            {
				var asset:IAsset;

				if (resourceDependency.assets.length != 1)
                {
					return;
                }

				asset = resourceDependency.assets[0];
				
				if (asset.assetType == AssetType.TEXTURE)
                {

					var lm:LoadedMaterial = new LoadedMaterial();
					    lm.materialID = resourceDependency.id;
					    lm.texture = Texture2DBase(asset);
					
					_materialLoaded.push(lm);
					
					if (_meshes.length > 0)
                    {
						applyMaterial(lm);
                    }
				}
			}
		}
		
		/**
		override public function _iResolveDependencyFailure(resourceDependency:ResourceDependency):void
		{
			if (resourceDependency.id == "mtl")
            {
				_mtlLib = false;
				_mtlLibLoaded = false;
			}
            else
            {
				var lm:LoadedMaterial = new LoadedMaterial();
				    lm.materialID = resourceDependency.id;
				_materialLoaded.push(lm);
			}
			
			if (_meshes.length > 0)
				applyMaterial(lm);
		}
		
		/**
		override public function _pProceedParsing():Boolean
		{
			var line:String;
			var creturn:String = String.fromCharCode(10);
			var trunk;
			
			if (!_startedParsing)
            {
				_textData = _pGetTextData();
				// Merge linebreaks that are immediately preceeded by
				// the "escape" backward slash into single lines.
				_textData = _textData.replace(/\\[\r\n]+\s*/gm, ' ');
			}
			
			if (_textData.indexOf(creturn) == -1)
				creturn = String.fromCharCode(13);
			
			if (!_startedParsing)
            {
				_startedParsing = true;
                _vertices = new Vector.<Vertex>();
                _vertexNormals = new Vector.<Vertex>();
                _materialIDs = new Vector.<String>();
                _materialLoaded = new Vector.<LoadedMaterial>();
                _meshes = new Vector.<Mesh>();
                _uvs = new Vector.<UV>();
                _stringLength = _textData.length;
                _charIndex = _textData.indexOf(creturn, 0);
                _oldIndex = 0;
                _objects = new Vector.<ObjectGroup>();
                _objectIndex = 0;
			}
			
			while (_charIndex < _stringLength && _pHasTime())
            {
				_charIndex = _textData.indexOf(creturn, _oldIndex);
				
				if (_charIndex == -1)
                    _charIndex = _stringLength;
				
				line = _textData.substring(_oldIndex, _charIndex);
				line = line.split('\r').join("");
				line = line.replace("  ", " ");
				trunk = line.split(" ");
                _oldIndex = _charIndex + 1;
                parseLine(trunk);
				
				// If whatever was parsed on this line resulted in the
				// parsing being paused to retrieve dependencies, break
				// here and do not continue parsing until un-paused.
				if (parsingPaused)
                {
					return ParserBase.MORE_TO_PARSE;
                }

			}
			
			if (_charIndex >= _stringLength)
            {
				
				if (_mtlLib && !_mtlLibLoaded)
                {
					return ParserBase.MORE_TO_PARSE;
                }

				translate();
				applyMaterials();
				
				return ParserBase.PARSING_DONE;
			}
			
			return ParserBase.MORE_TO_PARSE;
		}
		
		/**
		private function parseLine(trunk):void
		{
			switch (trunk[0])
            {

				case "mtllib":

					_mtlLib = true;
                    _mtlLibLoaded = false;
                    loadMtl(trunk[1]);

					break;

				case "g":

                    createGroup(trunk);

					break;

				case "o":

                    createObject(trunk);

					break;

				case "usemtl":

					if (_mtlLib)
                    {

						if (!trunk[1])
							trunk[1] = "def000";

                        _materialIDs.push(trunk[1]);
                        _activeMaterialID = trunk[1];

						if (_currentGroup)
                            _currentGroup.materialID = _activeMaterialID;
					}

					break;

				case "v":

                    parseVertex(trunk);

					break;

				case "vt":

                    parseUV(trunk);

					break;

				case "vn":

                    parseVertexNormal(trunk);

					break;

				case "f":

                    parseFace(trunk);

			}
		}
		
		/**
		private function translate():void
		{
			for (var objIndex:Number = 0; objIndex < _objects.length; ++objIndex)
            {
				var groups:Vector.<Group> = _objects[objIndex].groups;
				var numGroups:Number = groups.length;
				var materialGroups:Vector.<MaterialGroup>;
				var numMaterialGroups:Number;
				var geometry:Geometry;
				var mesh:Mesh;
				
				var m:Number;
				var sm:Number;
				var bmMaterial:MaterialBase;
				
				for (var g:Number = 0; g < numGroups; ++g)
                {
					geometry = new Geometry();
					materialGroups = groups[g].materialGroups;
					numMaterialGroups = materialGroups.length;
					
					for (m = 0; m < numMaterialGroups; ++m)
						translateMaterialGroup(materialGroups[m], geometry);
					
					if (geometry.subGeometries.length == 0)
						continue;
					
					// Finalize and force type-based name
					_pFinalizeAsset( IAsset(geometry)) ;//, "");

					if (materialMode < 2)
						bmMaterial = new TextureMaterial(DefaultMaterialManager.getDefaultTexture());
					else
						bmMaterial = new TextureMultiPassMaterial(DefaultMaterialManager.getDefaultTexture());
					//bmMaterial = new TextureMaterial(DefaultMaterialManager.getDefaultTexture());
					mesh = new Mesh(geometry, bmMaterial);
					
					if (_objects[objIndex].name)
                    {
						// this is a full independent object ('o' tag in OBJ file)
						mesh.name = _objects[objIndex].name;

					}
                    else if (groups[g].name)
                    {

						// this is a group so the sub groups contain the actual mesh object names ('g' tag in OBJ file)
						mesh.name = groups[g].name;

					}
                    else
                    {
						// No name stored. Use empty string which will force it
						// to be overridden by finalizeAsset() to type default.
						mesh.name = "";
					}
					
					_meshes.push(mesh);
					
					if (groups[g].materialID != "")
						bmMaterial.name = groups[g].materialID + "~" + mesh.name;
					else
						bmMaterial.name = _lastMtlID + "~" + mesh.name;
					
					if (mesh.subMeshes.length > 1)
                    {
						for (sm = 1; sm < mesh.subMeshes.length; ++sm)
							mesh.subMeshes[sm].material = bmMaterial;
					}

                    _pFinalizeAsset(IAsset(mesh));
				}
			}
		}
		
		/**
		private function translateMaterialGroup(materialGroup:MaterialGroup, geometry:Geometry):void
		{
			var faces:Vector.<FaceData> = materialGroup.faces;
			var face:FaceData;
			var numFaces:Number = faces.length;
			var numVerts:Number;
			var subs:Vector.<ISubGeometry>;
			
			var vertices:Vector.<Number> = new Vector.<Number>();
			var uvs:Vector.<Number> = new Vector.<Number>();
			var normals:Vector.<Number> = new Vector.<Number>();
			var indices:Vector.<Number> /*uint*/ = new Vector.<Number>();
			
			_realIndices = [];
            _vertexIndex = 0;
			
			var j:Number;
			for (var i:Number = 0; i < numFaces; ++i)
            {

				face = faces[i];
				numVerts = face.indexIds.length - 1;

				for (j = 1; j < numVerts; ++j)
                {

					translateVertexData(face, j, vertices, uvs, indices, normals);
                    translateVertexData(face, 0, vertices, uvs, indices, normals);
                    translateVertexData(face, j + 1, vertices, uvs, indices, normals);
				}
			}
			if (vertices.length > 0)
            {
				subs = GeometryUtils.fromVectors(vertices, indices, uvs, normals, null, null, null);
				for (i = 0; i < subs.length; i++)
                {
					geometry.addSubGeometry(subs[i]);
                }
			}
		}
		
		private function translateVertexData(face:FaceData, vertexIndex:Number, vertices:Vector.<Number>, uvs:Vector.<Number>, indices:Vector.<Number>/*uint*/, normals:Vector.<Number>):void
		{
			var index:Number;
			var vertex:Vertex;
			var vertexNormal:Vertex;
			var uv:UV;
			
			if (!_realIndices[face.indexIds[vertexIndex]])
            {

				index = _vertexIndex;
				_realIndices[face.indexIds[vertexIndex]] = ++_vertexIndex;
				vertex = _vertices[face.vertexIndices[vertexIndex] - 1];
				vertices.push(vertex.x*_scale, vertex.y*_scale, vertex.z*_scale);
				
				if (face.normalIndices.length > 0) {
					vertexNormal = _vertexNormals[face.normalIndices[vertexIndex] - 1];
					normals.push(vertexNormal.x, vertexNormal.y, vertexNormal.z);
				}
				
				if (face.uvIndices.length > 0) {
					
					try {
						uv = _uvs[face.uvIndices[vertexIndex] - 1];
						uvs.push(uv.u, uv.v);
						
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
				
			}
            else
            {
				index = _realIndices[face.indexIds[vertexIndex]] - 1;
            }

			indices.push(index);
		}
		
		/**
		private function createObject(trunk):void
		{
			_currentGroup = null;
            _currentMaterialGroup = null;
            _objects.push(_currentObject = new ObjectGroup());
			
			if (trunk)
                _currentObject.name = trunk[1];
		}
		
		/**
		private function createGroup(trunk):void
		{
			if (!_currentObject)
                createObject(null);
            _currentGroup = new Group();

            _currentGroup.materialID = _activeMaterialID;
			
			if (trunk)
                _currentGroup.name = trunk[1];
            _currentObject.groups.push(_currentGroup);

            createMaterialGroup(null);
		}
		
		/**
		private function createMaterialGroup(trunk):void
		{
            _currentMaterialGroup = new MaterialGroup();
			if (trunk)
                _currentMaterialGroup.url = trunk[1];
            _currentGroup.materialGroups.push(_currentMaterialGroup);
		}
		
		/**
		private function parseVertex(trunk):void
		{
			//for the very rare cases of other delimiters/charcodes seen in some obj files

            var v1: Number, v2:Number , v3:Number;
			if (trunk.length > 4)
            {
				var nTrunk = [];
				var val:Number;

				for (var i:Number = 1; i < trunk.length; ++i)
                {
					val = parseFloat(trunk[i]);
					if (!isNaN(val))
						nTrunk.push(val);
				}

                v1 = Number(nTrunk[0]);
                v2 = Number(nTrunk[1]);
                v3 = Number(-nTrunk[2]);
                _vertices.push(new Vertex( v1, v2, v3 ));

			}
            else
            {
                v1 = Number(parseFloat(trunk[1]));
                v2 = Number(parseFloat(trunk[2]));
                v3 = Number(-parseFloat(trunk[3]));

                _vertices.push(new Vertex(v1, v2, v3 ));
            }

		}
		
		/**
		private function parseUV(trunk):void
		{
            if (trunk.length > 3)
            {
				var nTrunk = [];
				var val:Number;
				for (var i:Number = 1; i < trunk.length; ++i)
                {
					val = parseFloat(trunk[i]);
					if (!isNaN(val))
						nTrunk.push(val);
				}
				_uvs.push(new UV( 1 - nTrunk[0], 1 - nTrunk[1]));

			}
            else
            {
                _uvs.push(new UV( 1 - parseFloat(trunk[1]), 1 - parseFloat(trunk[2])));
            }

		}
		
		/**
		private function parseVertexNormal(trunk):void
		{
			if (trunk.length > 4) {
				var nTrunk = [];
				var val:Number;
				for (var i:Number = 1; i < trunk.length; ++i) {
					val = parseFloat(trunk[i]);
					if (!isNaN(val))
						nTrunk.push(val);
				}
				_vertexNormals.push(new Vertex(nTrunk[0], nTrunk[1], -nTrunk[2]));
				
			}
            else
            {
                _vertexNormals.push(new Vertex(parseFloat(trunk[1]), parseFloat(trunk[2]), -parseFloat(trunk[3])));
            }
		}
		
		/**
		private function parseFace(trunk):void
		{
			var len:Number = trunk.length;
			var face:FaceData = new FaceData();
			
			if (!_currentGroup)
            {
                createGroup(null);
            }

			var indices;
			for (var i:Number = 1; i < len; ++i)
            {

				if (trunk[i] == "")
                {
					continue;
                }

				indices = trunk[i].split("/");
				face.vertexIndices.push(parseIndex(parseInt(indices[0]), _vertices.length));

				if (indices[1] && String(indices[1]).length > 0)
					face.uvIndices.push(parseIndex(parseInt(indices[1]), _uvs.length));

				if (indices[2] && String(indices[2]).length > 0)
					face.normalIndices.push(parseIndex(parseInt(indices[2]), _vertexNormals.length));

				face.indexIds.push(trunk[i]);
			}
			
			_currentMaterialGroup.faces.push(face);
		}
		
		/**
		private function parseIndex(index:Number, length:Number):Number
		{
			if (index < 0)
				return index + length + 1;
			else
				return index;
		}
		
		private function parseMtl(data:String):void
		{
			var materialDefinitions = data.split('newmtl');
			var lines;
			var trunk;
			var j:Number;
			
			var basicSpecularMethod:BasicSpecularMethod;
			var useSpecular:Boolean;
			var useColor:Boolean;
			var diffuseColor:Number;
			var ambientColor:Number;
			var specularColor:Number;
			var specular:Number;
			var alpha:Number;
			var mapkd:String;
			
			for (var i:Number = 0; i < materialDefinitions.length; ++i) {


                lines = (materialDefinitions[i].split('\r')).join("").split('\n');
				//lines = (materialDefinitions[i].split('\r') as Array).join("").split('\n');
				
				if (lines.length == 1)
					lines = materialDefinitions[i].split(String.fromCharCode(13));
				
				diffuseColor = ambientColor = specularColor = 0xFFFFFF;
				specular = 0;
				useSpecular = false;
				useColor = false;
				alpha = 1;
				mapkd = "";
				
				for (j = 0; j < lines.length; ++j)
                {

					lines[j] = lines[j].replace(/\s+$/, "");
					
					if (lines[j].substring(0, 1) != "#" && (j == 0 || lines[j] != "")) {
						trunk = lines[j].split(" ");
						
						if (String(trunk[0]).charCodeAt(0) == 9 || String(trunk[0]).charCodeAt(0) == 32)
							trunk[0] = trunk[0].substring(1, trunk[0].length);
						
						if (j == 0)
                        {
							_lastMtlID = trunk.join("");
                            _lastMtlID = (_lastMtlID == "")? "def000" : _lastMtlID;
							
						}
                        else
                        {
							
							switch (trunk[0])
                            {
								
								case "Ka":
									if (trunk[1] && !isNaN(Number(trunk[1])) && trunk[2] && !isNaN(Number(trunk[2])) && trunk[3] && !isNaN(Number(trunk[3])))
										ambientColor = trunk[1]*255 << 16 | trunk[2]*255 << 8 | trunk[3]*255;
									break;
								
								case "Ks":
									if (trunk[1] && !isNaN(Number(trunk[1])) && trunk[2] && !isNaN(Number(trunk[2])) && trunk[3] && !isNaN(Number(trunk[3]))) {
										specularColor = trunk[1]*255 << 16 | trunk[2]*255 << 8 | trunk[3]*255;
										useSpecular = true;
									}
									break;
								
								case "Ns":
									if (trunk[1] && !isNaN(Number(trunk[1])))
										specular = Number(trunk[1])*0.001;
									if (specular == 0)
										useSpecular = false;
									break;
								
								case "Kd":
									if (trunk[1] && !isNaN(Number(trunk[1])) && trunk[2] && !isNaN(Number(trunk[2])) && trunk[3] && !isNaN(Number(trunk[3]))) {
										diffuseColor = trunk[1]*255 << 16 | trunk[2]*255 << 8 | trunk[3]*255;
										useColor = true;
									}
									break;
								
								case "tr":
								case "d":
									if (trunk[1] && !isNaN(Number(trunk[1])))
										alpha = Number(trunk[1]);
									break;
								
								case "map_Kd":
									mapkd = parseMapKdString(trunk);
									mapkd = mapkd.replace(/\\/g, "/");
							}
						}
					}
				}
				
				if (mapkd != "")
                {
					
					if (useSpecular)
                    {
						
						basicSpecularMethod = new BasicSpecularMethod();
						basicSpecularMethod.specularColor = specularColor;
						basicSpecularMethod.specular = specular;
						
						var specularData:SpecularData = new SpecularData();
						    specularData.alpha = alpha;
						    specularData.basicSpecularMethod = basicSpecularMethod;
						    specularData.materialID = _lastMtlID;
						
						if (!_materialSpecularData)
							_materialSpecularData = new Vector.<SpecularData>();
						
						_materialSpecularData.push(specularData);

					}
					
					_pAddDependency(_lastMtlID, new URLRequest(mapkd));
					
				}
                else if (useColor && !isNaN(diffuseColor))
                {
					
					var lm:LoadedMaterial = new LoadedMaterial();
					lm.materialID = _lastMtlID;
					
					if (alpha == 0)
						Window.console.log("Warning: an alpha value of 0 was found in mtl color tag (Tr or d) ref:" + _lastMtlID + ", mesh(es) using it will be invisible!");
					
					var cm:MaterialBase;

					if (materialMode < 2)
                    {
						cm = new ColorMaterial(diffuseColor);

                        var colorMat : ColorMaterial = ColorMaterial(cm);

                        colorMat.alpha = alpha;
                        colorMat.ambientColor = ambientColor;
                        colorMat.repeat = true;

						if (useSpecular)
                        {
                            colorMat.specularColor = specularColor;
                            colorMat.specular = specular;
						}

					}
                    else
                    {
						cm = new ColorMultiPassMaterial(diffuseColor);

                        var colorMultiMat : ColorMultiPassMaterial = ColorMultiPassMaterial(cm);


                        colorMultiMat.ambientColor = ambientColor;
                        colorMultiMat.repeat = true;

						if (useSpecular)
                        {
                            colorMultiMat.specularColor = specularColor;
                            colorMultiMat.specular = specular;
						}
					}
					
					lm.cm = cm;

					_materialLoaded.push(lm);
					
					if (_meshes.length > 0)
						applyMaterial(lm);
					
				}
			}
			
			_mtlLibLoaded = true;
		}
		
		private function parseMapKdString(trunk):String
		{
			var url:String = "";
			var i:Number;
			var breakflag:Boolean;
			
			for (i = 1; i < trunk.length; ) {
				switch (trunk[i]) {
					case "-blendu":
					case "-blendv":
					case "-cc":
					case "-clamp":
					case "-texres":
						i += 2; //Skip ahead 1 attribute
						break;
					case "-mm":
						i += 3; //Skip ahead 2 attributes
						break;
					case "-o":
					case "-s":
					case "-t":
						i += 4; //Skip ahead 3 attributes
						continue;
					default:
						breakflag = true;
						break;
				}
				
				if (breakflag)
					break;
			}
			
			//Reconstruct URL/filename
			for (i; i < trunk.length; i++) {
				url += trunk[i];
				url += " ";
			}
			
			//Remove the extraneous space and/or newline from the right side
			url = url.replace(/\s+$/, "");
			
			return url;
		}
		
		private function loadMtl(mtlurl:String):void
		{
			// Add raw-data dependency to queue and load dependencies now,
			// which will pause the parsing in the meantime.
			_pAddDependency('mtl', new URLRequest(mtlurl), true);
			_pPauseAndRetrieveDependencies();//
		}
		
		private function applyMaterial(lm:LoadedMaterial):void
		{
			var decomposeID;
			var mesh:Mesh;
			var mat:MaterialBase;
			var j:Number;
			var specularData:SpecularData;
			
			for (var i:Number = 0; i < _meshes.length; ++i)
            {
				mesh = _meshes[i];
				decomposeID = mesh.material.name.split("~");
				
				if (decomposeID[0] == lm.materialID) {
					
					if (lm.cm) {
						if (mesh.material)
							mesh.material = null;
						mesh.material = lm.cm;
						
					}
                    else if (lm.texture)
                    {
						if (materialMode < 2) { // if materialMode is 0 or 1, we create a SinglePass
							mat = TextureMaterial(mesh.material);

                            var tm : TextureMaterial = TextureMaterial(mat);

							tm.texture = lm.texture;
                            tm.ambientColor = lm.ambientColor;
                            tm.alpha = lm.alpha;
                            tm.repeat = true;
							
							if (lm.specularMethod)
                            {

								// By setting the specularMethod property to null before assigning
								// the actual method instance, we avoid having the properties of
								// the new method being overridden with the settings from the old
								// one, which is default behavior of the setter.
                                tm.specularMethod = null;
                                tm.specularMethod = lm.specularMethod;

							}
                            else if (_materialSpecularData)
                            {

								for (j = 0; j < _materialSpecularData.length; ++j)
                                {
									specularData = _materialSpecularData[j];

									if (specularData.materialID == lm.materialID)
                                    {
										tm.specularMethod = null; // Prevent property overwrite (see above)
                                        tm.specularMethod = specularData.basicSpecularMethod;
                                        tm.ambientColor = specularData.ambientColor;
                                        tm.alpha = specularData.alpha;
										break;
									}
								}
							}
						} else { //if materialMode==2 this is a MultiPassTexture					
							mat = TextureMultiPassMaterial(mesh.material);

                            var tmMult : TextureMultiPassMaterial = TextureMultiPassMaterial(mat);

                            tmMult.texture = lm.texture;
                            tmMult.ambientColor = lm.ambientColor;
                            tmMult.repeat = true;
							
							if (lm.specularMethod)
                            {
								// By setting the specularMethod property to null before assigning
								// the actual method instance, we avoid having the properties of
								// the new method being overridden with the settings from the old
								// one, which is default behavior of the setter.
                                tmMult.specularMethod = null;
                                tmMult.specularMethod = lm.specularMethod;
							}
                            else if (_materialSpecularData)
                            {
								for (j = 0; j < _materialSpecularData.length; ++j)
                                {
									specularData = _materialSpecularData[j];

									if (specularData.materialID == lm.materialID)
                                    {
                                        tmMult.specularMethod = null; // Prevent property overwrite (see above)
                                        tmMult.specularMethod = specularData.basicSpecularMethod;
                                        tmMult.ambientColor = specularData.ambientColor;

										break;

									}
								}
							}
						}
					}
					
					mesh.material.name = decomposeID[1]? decomposeID[1] : decomposeID[0];
                    _meshes.splice(i, 1);
					--i;
				}
			}
			
			if (lm.cm || mat)
                _pFinalizeAsset(lm.cm || mat);
		}
		
		private function applyMaterials():void
		{
			if (_materialLoaded.length == 0)
				return;
			
			for (var i:Number = 0; i < _materialLoaded.length; ++i)
                applyMaterial(_materialLoaded[i]);
		}
	}
}

import away.entities.Mesh;
import away.base.data.Vertex;
import away.base.data.UV;
import away.loaders.parsers.utils.ParserUtil;
import away.loaders.misc.ResourceDependency;
import away.library.assets.IAsset;
import away.library.assets.AssetType;
import away.textures.Texture2DBase;
import away.base.Geometry;
import away.materials.MaterialBase;
import away.materials.TextureMaterial;
import away.materials.utils.DefaultMaterialManager;
import away.materials.TextureMultiPassMaterial;
import away.base.ISubGeometry;
import away.utils.GeometryUtils;
import away.materials.methods.BasicSpecularMethod;
import away.net.URLRequest;
import away.materials.ColorMaterial;
import away.materials.ColorMultiPassMaterial;
	import randori.webkit.page.Window;

class ObjectGroup
{
	public var name:String;
	public var groups:Vector.<Group> = new Vector.<Group>();

    public function ObjectGroup():void
	{
	}
}
class Group
{
	public var name:String;
	public var materialID:String;
	public var materialGroups:Vector.<MaterialGroup> = new Vector.<MaterialGroup>();

    public function Group():void
	{
	}
}
class MaterialGroup
{
	public var url:String;
	public var faces:Vector.<FaceData> = new Vector.<FaceData>();
	
	public function MaterialGroup():void
	{
	}
}
class SpecularData
{
	public var materialID:String;
	public var basicSpecularMethod:BasicSpecularMethod;
	public var ambientColor:Number = 0xFFFFFF;
	public var alpha:Number = 1;
	
	public function SpecularData():void
	{
	}
}
class LoadedMaterial
{
	//import away3d.materials.ColorMaterial;
	
	public var materialID:String;
	public var texture:Texture2DBase;
	public var cm:MaterialBase;
	public var specularMethod:BasicSpecularMethod;
	public var ambientColor:Number = 0xFFFFFF;
	public var alpha:Number = 1;
	
	public function LoadedMaterial():void
	{
	}
}
class FaceData
{
	public var vertexIndices:Vector.<Number>/*uint*/ = new Vector.<Number>();
	public var uvIndices:Vector.<Number>/*uint*/ = new Vector.<Number>();
	public var normalIndices:Vector.<Number>/*uint*/ = new Vector.<Number>();
	public var indexIds:Vector.<String> = new Vector.<String>(); // used for real index lookups
	public function FaceData():void
	{
	}
}




