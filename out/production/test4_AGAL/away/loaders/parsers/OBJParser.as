/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package away.loaders.parsers
{
	import away.entities.Mesh;
	import away.core.base.data.Vertex;
	import away.core.base.data.UV;
	import away.loaders.parsers.utils.ParserUtil;
	import away.loaders.misc.ResourceDependency;
	import away.library.assets.IAsset;
	import away.library.assets.AssetType;
	import away.textures.Texture2DBase;
	import away.utils.VectorInit;
	import away.core.base.Geometry;
	import away.materials.MaterialBase;
	import away.materials.TextureMaterial;
	import away.materials.utils.DefaultMaterialManager;
	import away.materials.TextureMultiPassMaterial;
	import away.core.base.ISubGeometry;
	import away.utils.GeometryUtils;
	import away.materials.methods.BasicSpecularMethod;
	import away.core.net.URLRequest;
	import away.materials.ColorMaterial;
	import away.materials.ColorMultiPassMaterial;
	import randori.webkit.page.Window;

	/**	 * OBJParser provides a parser for the OBJ data type.	 */
	public class OBJParser extends ParserBase
	{
		private var _textData:String = null;
		private var _startedParsing:Boolean = false;
		private var _charIndex:Number = 0;
		private var _oldIndex:Number = 0;
		private var _stringLength:Number = 0;
		private var _currentObject:ObjectGroup;
		private var _currentGroup:Group;
		private var _currentMaterialGroup:MaterialGroup;
		private var _objects:Vector.<ObjectGroup>;
		private var _materialIDs:Vector.<String>;
		private var _materialLoaded:Vector.<LoadedMaterial>;
		private var _materialSpecularData:Vector.<SpecularData>;
		private var _meshes:Vector.<Mesh>;
		private var _lastMtlID:String = null;
		private var _objectIndex:Number = 0;
		private var _realIndices;
		private var _vertexIndex:Number = 0;
		private var _vertices:Vector.<Vertex>;
		private var _vertexNormals:Vector.<Vertex>;
		private var _uvs:Vector.<UV>;
		private var _scale:Number = 0;
		private var _mtlLib:Boolean = false;
		private var _mtlLibLoaded:Boolean = true;
		private var _activeMaterialID:String = "";
		
		/**		 * Creates a new OBJParser object.		 * @param uri The url or id of the data or file to be parsed.		 * @param extra The holder for extra contextual data that the parser might need.		 */
		public function OBJParser(scale:Number = 1):void
		{
			scale = scale || 1;

			super(ParserDataFormat.PLAIN_TEXT);
			this._scale = scale;
		}
		
		/**		 * Scaling factor applied directly to vertices data		 * @param value The scaling factor.		 */
		public function set scale(value:Number):void
		{
			this._scale = value;
		}
		
		/**		 * Indicates whether or not a given file extension is supported by the parser.		 * @param extension The file extension of a potential file to be parsed.		 * @return Whether or not the given file type is supported.		 */
		public static function supportsType(extension:String):Boolean
		{
			extension = extension.toLowerCase();
			return extension == "obj";
		}
		
		/**		 * Tests whether a data block can be parsed by the parser.		 * @param data The data block to potentially be parsed.		 * @return Whether or not the given data is supported.		 */
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
		
		/**		 * @inheritDoc		 */
		override public function _iResolveDependency(resourceDependency:ResourceDependency):void
		{
			if (resourceDependency.id == 'mtl')
            {
				var str:String = ParserUtil.toString(resourceDependency.data);
				this.parseMtl(str);
				
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
					    lm.texture = (asset as Texture2DBase);
					
					this._materialLoaded.push(lm);
					
					if (this._meshes.length > 0)
                    {
						this.applyMaterial(lm);
                    }
				}
			}
		}
		
		/**		 * @inheritDoc		 */
		override public function _iResolveDependencyFailure(resourceDependency:ResourceDependency):void
		{
			if (resourceDependency.id == "mtl")
            {
				this._mtlLib = false;
				this._mtlLibLoaded = false;
			}
            else
            {
				var lm:LoadedMaterial = new LoadedMaterial();
				    lm.materialID = resourceDependency.id;
				this._materialLoaded.push(lm);
			}
			
			if (this._meshes.length > 0)
				this.applyMaterial(lm);
		}
		
		/**		 * @inheritDoc		 */
		override public function _pProceedParsing():Boolean
		{
			var line:String;
			var creturn:String = String.fromCharCode(10);
			var trunk;
			
			if (!this._startedParsing)
            {
				this._textData = this._pGetTextData();
				// Merge linebreaks that are immediately preceeded by
				// the "escape" backward slash into single lines.
				this._textData = this._textData.replace(/\\[\r\n]+\s*/gm, ' ');
			}
			
			if (this._textData.indexOf(creturn) == -1)
				creturn = String.fromCharCode(13);
			
			if (!this._startedParsing)
            {
				this._startedParsing = true;
                this._vertices = new Vector.<Vertex>();
                this._vertexNormals = new Vector.<Vertex>();
                this._materialIDs = VectorInit.Str();
                this._materialLoaded = new Vector.<LoadedMaterial>();
                this._meshes = new Vector.<Mesh>();
                this._uvs = new Vector.<UV>();
                this._stringLength = this._textData.length;
                this._charIndex = this._textData.indexOf(creturn, 0);
                this._oldIndex = 0;
                this._objects = new Vector.<ObjectGroup>();
                this._objectIndex = 0;
			}
			
			while (this._charIndex < this._stringLength && this._pHasTime())
            {
				this._charIndex = this._textData.indexOf(creturn, this._oldIndex);
				
				if (this._charIndex == -1)
                    this._charIndex = this._stringLength;
				
				line = this._textData.substring(this._oldIndex, this._charIndex);
				line = line.split('\r').join("");
				line = line.replace("  ", " ");
				trunk = line.split(" ");
                this._oldIndex = this._charIndex + 1;
                this.parseLine(trunk);
				
				// If whatever was parsed on this line resulted in the
				// parsing being paused to retrieve dependencies, break
				// here and do not continue parsing until un-paused.
				if (this.parsingPaused)
                {
					return ParserBase.MORE_TO_PARSE;
                }

			}
			
			if (this._charIndex >= this._stringLength)
            {
				
				if (this._mtlLib && !this._mtlLibLoaded)
                {
					return ParserBase.MORE_TO_PARSE;
                }

				this.translate();
				this.applyMaterials();
				
				return ParserBase.PARSING_DONE;
			}
			
			return ParserBase.MORE_TO_PARSE;
		}
		
		/**		 * Parses a single line in the OBJ file.		 */
		private function parseLine(trunk):void
		{
			switch (trunk[0])
            {

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

					if (this._mtlLib)
                    {

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
		}
		
		/**		 * Converts the parsed data into an Away3D scenegraph structure		 */
		private function translate():void
		{
			for (var objIndex:Number = 0; objIndex < this._objects.length; ++objIndex)
            {
				var groups:Vector.<Group> = this._objects[objIndex].groups;
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
						this.translateMaterialGroup(materialGroups[m], geometry);
					
					if (geometry.subGeometries.length == 0)
						continue;
					
					// Finalize and force type-based name
					this._pFinalizeAsset( (geometry as IAsset) ) ;//, "");

					if (this.materialMode < 2)
						bmMaterial = new TextureMaterial(DefaultMaterialManager.getDefaultTexture());
					else
						bmMaterial = new TextureMultiPassMaterial(DefaultMaterialManager.getDefaultTexture());
					//bmMaterial = new TextureMaterial(DefaultMaterialManager.getDefaultTexture());
					mesh = new Mesh(geometry, bmMaterial);
					
					if (this._objects[objIndex].name)
                    {
						// this is a full independent object ('o' tag in OBJ file)
						mesh.name = this._objects[objIndex].name;

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
					
					this._meshes.push(mesh);
					
					if (groups[g].materialID != "")
						bmMaterial.name = groups[g].materialID + "~" + mesh.name;
					else
						bmMaterial.name = this._lastMtlID + "~" + mesh.name;
					
					if (mesh.subMeshes.length > 1)
                    {
						for (sm = 1; sm < mesh.subMeshes.length; ++sm)
							mesh.subMeshes[sm].material = bmMaterial;
					}

                    this._pFinalizeAsset((mesh as IAsset));
				}
			}
		}
		
		/**		 * Translates an obj's material group to a subgeometry.		 * @param materialGroup The material group data to convert.		 * @param geometry The Geometry to contain the converted SubGeometry.		 */
		private function translateMaterialGroup(materialGroup:MaterialGroup, geometry:Geometry):void
		{
			var faces:Vector.<FaceData> = materialGroup.faces;
			var face:FaceData;
			var numFaces:Number = faces.length;
			var numVerts:Number;
			var subs:Vector.<ISubGeometry>;
			
			var vertices:Vector.<Number> = VectorInit.Num();
			var uvs:Vector.<Number> = VectorInit.Num();
			var normals:Vector.<Number> = VectorInit.Num();
			var indices:Vector.<Number> /*uint*/ = VectorInit.Num();
			
			this._realIndices = [];
            this._vertexIndex = 0;
			
			var j:Number;
			for (var i:Number = 0; i < numFaces; ++i)
            {

				face = faces[i];
				numVerts = face.indexIds.length - 1;

				for (j = 1; j < numVerts; ++j)
                {

					this.translateVertexData(face, j, vertices, uvs, indices, normals);
                    this.translateVertexData(face, 0, vertices, uvs, indices, normals);
                    this.translateVertexData(face, j + 1, vertices, uvs, indices, normals);
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
			
			if (!this._realIndices[face.indexIds[vertexIndex]])
            {

				index = this._vertexIndex;
				this._realIndices[face.indexIds[vertexIndex]] = ++this._vertexIndex;
				vertex = this._vertices[face.vertexIndices[vertexIndex] - 1];
				vertices.push(vertex.x*this._scale, vertex.y*this._scale, vertex.z*this._scale);
				
				if (face.normalIndices.length > 0) {
					vertexNormal = this._vertexNormals[face.normalIndices[vertexIndex] - 1];
					normals.push(vertexNormal.x, vertexNormal.y, vertexNormal.z);
				}
				
				if (face.uvIndices.length > 0) {
					
					try {
						uv = this._uvs[face.uvIndices[vertexIndex] - 1];
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
				index = this._realIndices[face.indexIds[vertexIndex]] - 1;
            }

			indices.push(index);
		}
		
		/**		 * Creates a new object group.		 * @param trunk The data block containing the object tag and its parameters		 */
		private function createObject(trunk):void
		{
			this._currentGroup = null;
            this._currentMaterialGroup = null;
            this._objects.push(this._currentObject = new ObjectGroup());
			
			if (trunk)
                this._currentObject.name = trunk[1];
		}
		
		/**		 * Creates a new group.		 * @param trunk The data block containing the group tag and its parameters		 */
		private function createGroup(trunk):void
		{
			if (!this._currentObject)
                this.createObject(null);
            this._currentGroup = new Group();

            this._currentGroup.materialID = this._activeMaterialID;
			
			if (trunk)
                this._currentGroup.name = trunk[1];
            this._currentObject.groups.push(this._currentGroup);

            this.createMaterialGroup(null);
		}
		
		/**		 * Creates a new material group.		 * @param trunk The data block containing the material tag and its parameters		 */
		private function createMaterialGroup(trunk):void
		{
            this._currentMaterialGroup = new MaterialGroup();
			if (trunk)
                this._currentMaterialGroup.url = trunk[1];
            this._currentGroup.materialGroups.push(this._currentMaterialGroup);
		}
		
		/**		 * Reads the next vertex coordinates.		 * @param trunk The data block containing the vertex tag and its parameters		 */
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

                v1 = (nTrunk[0] as Number);
                v2 = (nTrunk[1] as Number);
                v3 = (-nTrunk[2] as Number);
                this._vertices.push(new Vertex( v1, v2, v3 ));

			}
            else
            {
                v1 = (parseFloat(trunk[1] ) as Number);
                v2 = (parseFloat(trunk[2] ) as Number);
                v3 = (-parseFloat(trunk[3] ) as Number);

                this._vertices.push(new Vertex(v1, v2, v3 ));
            }

		}
		
		/**		 * Reads the next uv coordinates.		 * @param trunk The data block containing the uv tag and its parameters		 */
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
				this._uvs.push(new UV( nTrunk[0], 1 - nTrunk[1]));

			}
            else
            {
                this._uvs.push(new UV( parseFloat(trunk[1]), 1 - parseFloat(trunk[2])));
            }

		}
		
		/**		 * Reads the next vertex normal coordinates.		 * @param trunk The data block containing the vertex normal tag and its parameters		 */
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
				this._vertexNormals.push(new Vertex(nTrunk[0], nTrunk[1], -nTrunk[2]));
				
			}
            else
            {
                this._vertexNormals.push(new Vertex(parseFloat(trunk[1]), parseFloat(trunk[2]), -parseFloat(trunk[3])));
            }
		}
		
		/**		 * Reads the next face's indices.		 * @param trunk The data block containing the face tag and its parameters		 */
		private function parseFace(trunk):void
		{
			var len:Number = trunk.length;
			var face:FaceData = new FaceData();
			
			if (!this._currentGroup)
            {
                this.createGroup(null);
            }

			var indices;
			for (var i:Number = 1; i < len; ++i)
            {

				if (trunk[i] == "")
                {
					continue;
                }

				indices = trunk[i].split("/");
				face.vertexIndices.push(this.parseIndex(parseInt(indices[0]), this._vertices.length));

				if (indices[1] && String(indices[1]).length > 0)
					face.uvIndices.push(this.parseIndex(parseInt(indices[1]), this._uvs.length));

				if (indices[2] && String(indices[2]).length > 0)
					face.normalIndices.push(this.parseIndex(parseInt(indices[2]), this._vertexNormals.length));

				face.indexIds.push(trunk[i]);
			}
			
			this._currentMaterialGroup.faces.push(face);
		}
		
		/**		 * This is a hack around negative face coords		 */
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
				
				diffuseColor = 0xFFFFFF;
				ambientColor = 0xFFFFFF;
				specularColor = 0xFFFFFF;

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
							this._lastMtlID = trunk.join("");
                            this._lastMtlID = (this._lastMtlID == "")? "def000" : this._lastMtlID;
							
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
									mapkd = this.parseMapKdString(trunk);
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
						    specularData.materialID = this._lastMtlID;
						
						if (!this._materialSpecularData)
							this._materialSpecularData = new Vector.<SpecularData>();
						
						this._materialSpecularData.push(specularData);

					}
					
					this._pAddDependency(this._lastMtlID, new URLRequest(mapkd));
					
				}
                else if (useColor && !isNaN(diffuseColor))
                {
					
					var lm:LoadedMaterial = new LoadedMaterial();
					lm.materialID = this._lastMtlID;
					
					if (alpha == 0)
						Window.console.log("Warning: an alpha value of 0 was found in mtl color tag (Tr or d) ref:" + this._lastMtlID + ", mesh(es) using it will be invisible!");
					
					var cm:MaterialBase;

					if (this.materialMode < 2)
                    {
						cm = new ColorMaterial(diffuseColor);

                        var colorMat : ColorMaterial = (cm as ColorMaterial);

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

                        var colorMultiMat : ColorMultiPassMaterial = (cm as ColorMultiPassMaterial);


                        colorMultiMat.ambientColor = ambientColor;
                        colorMultiMat.repeat = true;

						if (useSpecular)
                        {
                            colorMultiMat.specularColor = specularColor;
                            colorMultiMat.specular = specular;
						}
					}
					
					lm.cm = cm;

					this._materialLoaded.push(lm);
					
					if (this._meshes.length > 0)
						this.applyMaterial(lm);
					
				}
			}
			
			this._mtlLibLoaded = true;
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
			this._pAddDependency('mtl', new URLRequest(mtlurl), true);
			this._pPauseAndRetrieveDependencies();//
		}
		
		private function applyMaterial(lm:LoadedMaterial):void
		{
			var decomposeID;
			var mesh:Mesh;
			var mat:MaterialBase;
			var j:Number;
			var specularData:SpecularData;
			
			for (var i:Number = 0; i < this._meshes.length; ++i)
            {
				mesh = this._meshes[i];
				decomposeID = mesh.material.name.split("~");
				
				if (decomposeID[0] == lm.materialID) {
					
					if (lm.cm) {
						if (mesh.material)
							mesh.material = null;
						mesh.material = lm.cm;
						
					}
                    else if (lm.texture)
                    {
						if (this.materialMode < 2) { // if materialMode is 0 or 1, we create a SinglePass
							mat = (mesh.material as TextureMaterial);

                            var tm : TextureMaterial = (mat as TextureMaterial);

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
                            else if (this._materialSpecularData)
                            {

								for (j = 0; j < this._materialSpecularData.length; ++j)
                                {
									specularData = this._materialSpecularData[j];

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
							mat = (mesh.material as TextureMultiPassMaterial);

                            var tmMult : TextureMultiPassMaterial = (mat as TextureMultiPassMaterial);

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
                            else if (this._materialSpecularData)
                            {
								for (j = 0; j < this._materialSpecularData.length; ++j)
                                {
									specularData = this._materialSpecularData[j];

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
                    this._meshes.splice(i, 1);
					--i;
				}
			}
			
			if (lm.cm || mat)
                this._pFinalizeAsset(lm.cm || mat);
		}
		
		private function applyMaterials():void
		{
			if (this._materialLoaded.length == 0)
				return;
			
			for (var i:Number = 0; i < this._materialLoaded.length; ++i)
                this.applyMaterial(this._materialLoaded[i]);
		}
	}
}





