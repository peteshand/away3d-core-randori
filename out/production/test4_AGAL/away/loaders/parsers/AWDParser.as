/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package away.loaders.parsers
{
	import away.utils.ByteArray;
	import away.textures.BitmapTexture;
	import away.materials.TextureMaterial;
	import away.textures.BitmapCubeTexture;
	import away.utils.VectorInit;
	import away.core.display.BlendMode;
	import away.loaders.parsers.utils.ParserUtil;
	import away.loaders.misc.ResourceDependency;
	import away.textures.TextureProxyBase;
	import away.textures.Texture2DBase;
	import away.library.assets.IAsset;
	import away.textures.HTMLImageElementTexture;
	import away.textures.HTMLImageElementCubeTexture;
	import away.core.base.Geometry;
	import away.core.base.ISubGeometry;
	import away.utils.GeometryUtils;
	import away.core.geom.Matrix3D;
	import away.primitives.PlaneGeometry;
	import away.primitives.CubeGeometry;
	import away.primitives.SphereGeometry;
	import away.primitives.CylinderGeometry;
	import away.primitives.ConeGeometry;
	import away.primitives.CapsuleGeometry;
	import away.primitives.TorusGeometry;
	import away.containers.ObjectContainer3D;
	import away.library.assets.AssetType;
	import away.core.geom.Vector3D;
	import away.materials.MaterialBase;
	import away.entities.Mesh;
	import away.lights.LightBase;
	import away.lights.shadowmaps.ShadowMapperBase;
	import away.lights.PointLight;
	import away.lights.shadowmaps.CubeMapShadowMapper;
	import away.lights.DirectionalLight;
	import away.lights.shadowmaps.DirectionalShadowMapper;
	import away.cameras.lenses.LensBase;
	import away.cameras.lenses.PerspectiveLens;
	import away.cameras.lenses.OrthographicLens;
	import away.cameras.lenses.OrthographicOffCenterLens;
	import away.cameras.Camera3D;
	import away.materials.lightpickers.LightPickerBase;
	import away.materials.lightpickers.StaticLightPicker;
	import away.materials.ColorMaterial;
	import away.materials.ColorMultiPassMaterial;
	import away.materials.TextureMultiPassMaterial;
	import away.materials.SinglePassMaterialBase;
	import away.materials.MultiPassMaterialBase;
	import away.materials.methods.EffectMethodBase;
	import away.materials.methods.ShadowMapMethodBase;
	import away.core.net.URLRequest;
	import away.textures.CubeTextureBase;
	import away.materials.utils.DefaultMaterialManager;
	import away.core.display.BitmapData;
	import randori.webkit.page.Window;

	/**	 * AWDParser provides a parser for the AWD data type.	 */
	public class AWDParser extends ParserBase
	{
		//set to "true" to have some traces in the Console
		private var _debug:Boolean = true;
		private var _byteData:ByteArray;
		private var _startedParsing:Boolean = false;
		private var _cur_block_id:Number = 0;
		private var _blocks:Vector.<AWDBlock>;
		private var _newBlockBytes:ByteArray;
		private var _version:Vector.<Number>;
		private var _compression:Number = 0;
		private var _accuracyOnBlocks:Boolean = false;
		private var _accuracyMatrix:Boolean = false;
		private var _accuracyGeo:Boolean = false;
		private var _accuracyProps:Boolean = false;
		private var _matrixNrType:Number = 0;
		private var _geoNrType:Number = 0;
		private var _propsNrType:Number = 0;
		private var _streaming:Boolean = false;
		private var _texture_users:Object = {};
		private var _parsed_header:Boolean = false;
		private var _body:ByteArray;
		private var _defaultTexture:BitmapTexture;// HTML IMAGE TEXTURE >? !
		private var _cubeTextures:Array;
		private var _defaultBitmapMaterial:TextureMaterial;
		private var _defaultCubeTexture:BitmapCubeTexture;

		public static var COMPRESSIONMODE_LZMA:String = "lzma";
		public static var UNCOMPRESSED:Number = 0;
		public static var DEFLATE:Number = 1;
		public static var LZMA:Number = 2;
		public static var INT8:Number = 1;
		public static var INT16:Number = 2;
		public static var INT32:Number = 3;
		public static var UINT8:Number = 4;
		public static var UINT16:Number = 5;
		public static var UINT32:Number = 6;
		public static var FLOAT32:Number = 7;
		public static var FLOAT64:Number = 8;
		public static var BOOL:Number = 21;
		public static var COLOR:Number = 22;
		public static var BADDR:Number = 23;
		public static var AWDSTRING:Number = 31;
		public static var AWDBYTEARRAY:Number = 32;
		public static var VECTOR2x1:Number = 41;
		public static var VECTOR3x1:Number = 42;
		public static var VECTOR4x1:Number = 43;
		public static var MTX3x2:Number = 44;
		public static var MTX3x3:Number = 45;
		public static var MTX4x3:Number = 46;
		public static var MTX4x4:Number = 47;

		private var blendModeDic:Vector.<String>;
		private var _depthSizeDic:Vector.<Number>;
		
		/**		 * Creates a new AWDParser object.		 * @param uri The url or id of the data or file to be parsed.		 * @param extra The holder for extra contextual data that the parser might need.		 */
		public function AWDParser():void
		{
			super( ParserDataFormat.BINARY );
			
			this._blocks = new Vector.<AWDBlock>();
            this._blocks[0] = new AWDBlock();
            this._blocks[0].data = null; // Zero address means null in AWD
			
			this.blendModeDic = VectorInit.Str(); // used to translate ints to blendMode-strings
            this.blendModeDic.push(BlendMode.NORMAL);
            this.blendModeDic.push(BlendMode.ADD);
            this.blendModeDic.push(BlendMode.ALPHA);
            this.blendModeDic.push(BlendMode.DARKEN);
            this.blendModeDic.push(BlendMode.DIFFERENCE);
            this.blendModeDic.push(BlendMode.ERASE);
            this.blendModeDic.push(BlendMode.HARDLIGHT);
            this.blendModeDic.push(BlendMode.INVERT);
            this.blendModeDic.push(BlendMode.LAYER);
            this.blendModeDic.push(BlendMode.LIGHTEN);
            this.blendModeDic.push(BlendMode.MULTIPLY);
            this.blendModeDic.push(BlendMode.NORMAL);
            this.blendModeDic.push(BlendMode.OVERLAY);
            this.blendModeDic.push(BlendMode.SCREEN);
            this.blendModeDic.push(BlendMode.SHADER);
            this.blendModeDic.push(BlendMode.OVERLAY);
			
			this._depthSizeDic = VectorInit.Num(); // used to translate ints to depthSize-values
            this._depthSizeDic.push(256);
            this._depthSizeDic.push(512);
            this._depthSizeDic.push(2048);
            this._depthSizeDic.push(1024);
            this._version = VectorInit.Num();//[]; // will contain 2 int (major-version, minor-version) for awd-version-check
		}
		
		/**		 * Indicates whether or not a given file extension is supported by the parser.		 * @param extension The file extension of a potential file to be parsed.		 * @return Whether or not the given file type is supported.		 */
		public static function supportsType(extension:String):Boolean
		{
			extension = extension.toLowerCase();
			return extension == "awd";
		}
		
		/**		 * Tests whether a data block can be parsed by the parser.		 * @param data The data block to potentially be parsed.		 * @return Whether or not the given data is supported.		 */
		public static function supportsData(data:*):Boolean
		{
			return (ParserUtil.toString(data, 3) == 'AWD');
		}

        /**         * @inheritDoc         */
        override public function _iResolveDependency(resourceDependency:ResourceDependency):void
        {
            // this function will be called when Dependency has finished loading.
            // the Assets waiting for this Bitmap, can be Texture or CubeTexture.
            // if the Bitmap is awaited by a CubeTexture, we need to check if its the last Bitmap of the CubeTexture,
            // so we know if we have to finalize the Asset (CubeTexture) or not.
            if (resourceDependency.assets.length == 1)
            {
                var isCubeTextureArray  : Array = resourceDependency.id.split("#");
                var ressourceID         : String = isCubeTextureArray[0];
                var asset               : TextureProxyBase;
                var thisBitmapTexture   : Texture2DBase;
                var block               : AWDBlock;

                if (isCubeTextureArray.length == 1) // Not a cube texture
                {
                    asset = (resourceDependency.assets[0] as Texture2DBase);
                    if (asset)
                    {
                        var mat     : TextureMaterial;
                        var users   : Array;

                        block       = this._blocks[ resourceDependency.id ];
                        block.data  = asset; // Store finished asset

                        // Reset name of texture to the one defined in the AWD file,
                        // as opposed to whatever the image parser came up with.
                        asset.resetAssetPath(block.name, null, true);
                        block.name = asset.name;
                        // Finalize texture asset to dispatch texture event, which was
                        // previously suppressed while the dependency was loaded.
                        this._pFinalizeAsset( (asset as IAsset) );

                        if (this._debug)
                        {
                            Window.console.log("Successfully loaded Bitmap for texture");
                            Window.console.log("Parsed texture: Name = " + block.name);
                        }
                    }
                }

                if (isCubeTextureArray.length > 1) // Cube Texture
                {
                    thisBitmapTexture = (resourceDependency.assets[0] as BitmapTexture);

                    var tx : HTMLImageElementTexture = (thisBitmapTexture as HTMLImageElementTexture);

                    this._cubeTextures[ isCubeTextureArray[1] ] = tx.htmlImageElement; // ?
                    this._texture_users[ressourceID].push(1);

                    if (this._debug)
                    {
                        Window.console.log("Successfully loaded Bitmap " + this._texture_users[ressourceID].length + " / 6 for Cubetexture");
                    }
                    if (this._texture_users[ressourceID].length == this._cubeTextures.length)
                    {

                        var posX : * = this._cubeTextures[0];
                        var negX : * = this._cubeTextures[1];
                        var posY : * = this._cubeTextures[2];
                        var negY : * = this._cubeTextures[3];
                        var posZ : * = this._cubeTextures[4];
                        var negZ : * = this._cubeTextures[5];

                        asset       = new HTMLImageElementCubeTexture( posX , negX , posY , negY , posZ , negZ ) ;
                        block       = this._blocks[ressourceID];
                        block.data  = asset; // Store finished asset

                        // Reset name of texture to the one defined in the AWD file,
                        // as opposed to whatever the image parser came up with.
                        asset.resetAssetPath(block.name, null, true);
                        block.name = asset.name;
                        // Finalize texture asset to dispatch texture event, which was
                        // previously suppressed while the dependency was loaded.
                        this._pFinalizeAsset(  (asset as IAsset) );
                        if (this._debug)
                        {
                            Window.console.log("Parsed CubeTexture: Name = " + block.name);
                        }
                    }
                }

            }
        }

        /**         * @inheritDoc         */
        override public function _iResolveDependencyFailure(resourceDependency:ResourceDependency):void
        {
            //not used - if a dependcy fails, the awaiting Texture or CubeTexture will never be finalized, and the default-bitmaps will be used.
            // this means, that if one Bitmap of a CubeTexture fails, the CubeTexture will have the DefaultTexture applied for all six Bitmaps.
        }

        /**         * Resolve a dependency name         *         * @param resourceDependency The dependency to be resolved.         */
        override public function _iResolveDependencyName(resourceDependency:ResourceDependency, asset:IAsset):String
        {
            var oldName:String = asset.name;

            if (asset)
            {
                var block:AWDBlock = this._blocks[parseInt(resourceDependency.id)];
                // Reset name of texture to the one defined in the AWD file,
                // as opposed to whatever the image parser came up with.
                asset.resetAssetPath(block.name, null, true);
            }

            var newName:String = asset.name;

            asset.name = oldName;

            return newName;

        }

        /**         * @inheritDoc         */
        override public function _pProceedParsing():Boolean
        {

            if ( ! this._startedParsing )
            {
                this._byteData = this._pGetByteData();//getByteData();
                this._startedParsing = true;
            }

            if ( ! this._parsed_header )
            {

                //----------------------------------------------------------------------------
                // LITTLE_ENDIAN - Default for ArrayBuffer / Not implemented in ByteArray
                //----------------------------------------------------------------------------
                //this._byteData.endian = Endian.LITTLE_ENDIAN;
                //----------------------------------------------------------------------------

                //----------------------------------------------------------------------------
                // Parse header and decompress body if needed
                this.parseHeader();

                switch (this._compression)
                {

                    case AWDParser.DEFLATE:
                    case AWDParser.LZMA:
                            this._pDieWithError( 'Compressed AWD formats not yet supported');
                            break;

                    case AWDParser.UNCOMPRESSED:
                        this._body = this._byteData;
                        break;

                    //----------------------------------------------------------------------------
                    // Compressed AWD Formats not yet supported
                    //----------------------------------------------------------------------------

                    /*                    case AWDParser.DEFLATE:                        this._body = new away.utils.ByteArray();                        this._byteData.readBytes(this._body, 0, this._byteData.getBytesAvailable());                        this._body.uncompress();                        break;                    case AWDParser.LZMA:                        this._body = new away.utils.ByteArray();                        this._byteData.readBytes(this._body, 0, this._byteData.getBytesAvailable());                        this._body.uncompress(COMPRESSIONMODE_LZMA);                        break;                    //*/

                }

                this._parsed_header = true;

                //----------------------------------------------------------------------------
                // LITTLE_ENDIAN - Default for ArrayBuffer / Not implemented in ByteArray
                //----------------------------------------------------------------------------
                //this._body.endian = Endian.LITTLE_ENDIAN;// Should be default
                //----------------------------------------------------------------------------

            }

            if ( this._body )
            {

                while (this._body.getBytesAvailable() > 0 && ! this.parsingPaused ) //&& this._pHasTime() )
                {
                    this.parseNextBlock();

                }

                //----------------------------------------------------------------------------
                // Return complete status
                if (this._body.getBytesAvailable() == 0)
                {
                    this.dispose();
                    return  ParserBase.PARSING_DONE;
                }
                else
                {
                    return  ParserBase.MORE_TO_PARSE;
                }
            }
            else
            {

                switch (this._compression)
                {

                    case AWDParser.DEFLATE:
                    case AWDParser.LZMA:

                        if ( this._debug )
                        {
                            Window.console.log("(!) AWDParser Error: Compressed AWD formats not yet supported (!)");
                        }

                        break;

                }
                                // Error - most likely _body not set because we do not support compression.
                return  ParserBase.PARSING_DONE;

            }

        }

        private function dispose():void
        {

            for ( var c in this._blocks)
            {

                var b : AWDBlock = (this._blocks[c]) as AWDBlock;
                    b.dispose();

            }

        }

        private function parseNextBlock():void
        {
            var block       : AWDBlock;
            var assetData   : IAsset;
            var isParsed    : Boolean = false;
            var ns          : Number;
            var type        : Number;
            var flags       : Number;
            var len         : Number;

            this._cur_block_id = this._body.readUnsignedInt();

            ns      = this._body.readUnsignedByte();
            type    = this._body.readUnsignedByte();
            flags   = this._body.readUnsignedByte();
            len     = this._body.readUnsignedInt();

            var blockCompression        :Boolean        = bitFlags.test(flags, bitFlags.FLAG4);
            var blockCompressionLZMA    :Boolean        = bitFlags.test(flags, bitFlags.FLAG5);

            if (this._accuracyOnBlocks)
            {
                this._accuracyMatrix        = bitFlags.test(flags, bitFlags.FLAG1);
                this._accuracyGeo           = bitFlags.test(flags, bitFlags.FLAG2);
                this._accuracyProps         = bitFlags.test(flags, bitFlags.FLAG3);
                this._geoNrType             = AWDParser.FLOAT32;

                if (this._accuracyGeo)
                {
                    this._geoNrType     = AWDParser.FLOAT64;
                }

                this._matrixNrType      = AWDParser.FLOAT32;

                if (this._accuracyMatrix)
                {
                    this._matrixNrType  = AWDParser.FLOAT64;
                }

                this._propsNrType       = AWDParser.FLOAT32;

                if (this._accuracyProps)
                {
                    this._propsNrType   = AWDParser.FLOAT64;
                }
            }

            var blockEndAll:Number = this._body.position + len;

            if (len > this._body.getBytesAvailable() )
            {
                this._pDieWithError('AWD2 block length is bigger than the bytes that are available!');
                this._body.position += this._body.getBytesAvailable();
                return;
            }
            this._newBlockBytes = new ByteArray();


            this._body.readBytes(this._newBlockBytes, 0, len);

            //----------------------------------------------------------------------------
            // Compressed AWD Formats not yet supported

            if ( blockCompression )
            {
                this._pDieWithError( 'Compressed AWD formats not yet supported');

                /*                 if (blockCompressionLZMA)                 {                 this._newBlockBytes.uncompress(AWDParser.COMPRESSIONMODE_LZMA);                 }                 else                 {                 this._newBlockBytes.uncompress();                 }                 */

            }

            //----------------------------------------------------------------------------
            // LITTLE_ENDIAN - Default for ArrayBuffer / Not implemented in ByteArray
            //----------------------------------------------------------------------------
            //this._newBlockBytes.endian = Endian.LITTLE_ENDIAN;
            //----------------------------------------------------------------------------

            this._newBlockBytes.position = 0;
            block       = new AWDBlock();
            block.len   = this._newBlockBytes.position + len;
            block.id    = this._cur_block_id;

            var blockEndBlock : Number = this._newBlockBytes.position + len;

            if (blockCompression)
            {
                this._pDieWithError( 'Compressed AWD formats not yet supported');
                //blockEndBlock   = this._newBlockBytes.position + this._newBlockBytes.length;
                //block.len       = blockEndBlock;
            }

            if (this._debug)
            {
                Window.console.log("AWDBlock:  ID = " + this._cur_block_id + " | TypeID = " + type + " | Compression = " + blockCompression + " | Matrix-Precision = " + this._accuracyMatrix + " | Geometry-Precision = " + this._accuracyGeo + " | Properties-Precision = " + this._accuracyProps);
            }

            this._blocks[this._cur_block_id] = block;

            if ((this._version[0] == 2) && (this._version[1] == 1))
            {

                 switch (type)
                 {
                     case 11:
                         this.parsePrimitves(this._cur_block_id);
                         isParsed = true;
                         break;
                     case 31:
                         //this.parseSkyBoxInstance(this._cur_block_id);
                         //isParsed = true;
                         break;
                     case 41:
                         this.parseLight(this._cur_block_id);
                         isParsed = true;
                         break;
                     case 42:
                         this.parseCamera(this._cur_block_id);
                         isParsed = true;
                         break;

                     //  case 43:
                     //      parseTextureProjector(_cur_block_id);
                     //      isParsed = true;
                     //      break;

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

                         //------------------------------------------------------------------
                         // Not yet supported - animation packages are not yet implemented
                         //------------------------------------------------------------------

                         //this.parseMeshPoseAnimation(this._cur_block_id, true);
                         //isParsed = true;
                         break;
                     case 112:

                         //------------------------------------------------------------------
                         // Not yet supported - animation packages are not yet implemented
                         //------------------------------------------------------------------

                         //this.parseMeshPoseAnimation(this._cur_block_id);
                         //isParsed = true;
                         break;
                     case 113:

                         //------------------------------------------------------------------
                         // Not yet supported - animation packages are not yet implemented
                         //------------------------------------------------------------------

                         //this.parseVertexAnimationSet(this._cur_block_id);
                         //isParsed = true;
                         break;
                     case 122:

                         //------------------------------------------------------------------
                         // Not yet supported - animation packages are not yet implemented
                         //------------------------------------------------------------------

                         //this.parseAnimatorSet(this._cur_block_id);
                         //isParsed = true;
                         break;
                     case 253:
                         this.parseCommand(this._cur_block_id);
                         isParsed = true;
                         break;
                 }
                 //*/
            }
            //*
            if (isParsed == false)
            {
                switch (type)
                {

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

                        //------------------------------------------------------------------
                        // Not yet supported - animation packages are not yet implemented
                        //------------------------------------------------------------------

                        //this.parseSkeleton(this._cur_block_id);

                        break;
                    case 102:

                        //------------------------------------------------------------------
                        // Not yet supported - animation packages are not yet implemented
                        //------------------------------------------------------------------

                        //this.parseSkeletonPose(this._cur_block_id);
                        break;
                    case 103:

                        //------------------------------------------------------------------
                        // Not yet supported - animation packages are not yet implemented
                        //------------------------------------------------------------------

                        //this.parseSkeletonAnimation(this._cur_block_id);
                        break;
                    case 121:

                        //------------------------------------------------------------------
                        // Not yet supported - animation packages are not yet implemented
                        //------------------------------------------------------------------

                        //this.parseUVAnimation(this._cur_block_id);
                        break;
                    case 254:
                        this.parseNameSpace(this._cur_block_id);
                        break;
                    case 255:
                        this.parseMetaData(this._cur_block_id);
                        break;
                    default:
                        if (this._debug)
                        {
                            Window.console.log("AWDBlock:   Unknown BlockType  (BlockID = " + this._cur_block_id + ") - Skip " + len + " bytes");
                        }
                        this._newBlockBytes.position += len;
                        break;
                }
            }
            //*/

            var msgCnt:Number = 0;
            if (this._newBlockBytes.position == blockEndBlock)
            {
                if (this._debug)
                {
                    if (block.errorMessages)
                    {
                        while (msgCnt < block.errorMessages.length)
                        {
                            Window.console.log("        (!) Error: " + block.errorMessages[msgCnt] + " (!)");
                            msgCnt++;
                        }
                    }
                }
                if (this._debug)
                {
                    Window.console.log("\n");
                }
            }
            else
            {
                if (this._debug)
                {

                    Window.console.log("  (!)(!)(!) Error while reading AWDBlock ID " + this._cur_block_id + " = skip to next block");

                    if (block.errorMessages)
                    {
                        while (msgCnt < block.errorMessages.length)
                        {
                            Window.console.log("        (!) Error: " + block.errorMessages[msgCnt] + " (!)");
                            msgCnt++;
                        }
                    }
                }
            }

            this._body.position = blockEndAll;
            this._newBlockBytes = null;

        }


        //--Parser Blocks---------------------------------------------------------------------------

        //Block ID = 1
        private function parseTriangleGeometrieBlock(blockID:Number):void
        {

            var geom:Geometry = new Geometry();

            // Read name and sub count
            var name:String = this.parseVarStr();
            var num_subs:Number = this._newBlockBytes.readUnsignedShort();

            // Read optional properties
            var props:AWDProperties = this.parseProperties({1:this._geoNrType, 2:this._geoNrType});
            var geoScaleU:Number = props.get(1, 1);
            var geoScaleV:Number = props.get(2, 1);

            // Loop through sub meshes
            var subs_parsed:Number = 0;
            while (subs_parsed < num_subs)
            {
                var i:Number;
                var sm_len:Number, sm_end:Number;
                var sub_geoms:Vector.<ISubGeometry>;
                var w_indices:Vector.<Number>;
                var weights:Vector.<Number>;

                sm_len = this._newBlockBytes.readUnsignedInt();
                sm_end = this._newBlockBytes.position + sm_len;

                // Ignore for now
                var subProps:AWDProperties = this.parseProperties({1:this._geoNrType, 2:this._geoNrType});
                // Loop through data streams
                while (this._newBlockBytes.position < sm_end) {
                    var idx:Number= 0;
                    var str_ftype:Number, str_type:Number, str_len:Number, str_end:Number;

                    // Type, field type, length
                    str_type = this._newBlockBytes.readUnsignedByte();
                    str_ftype = this._newBlockBytes.readUnsignedByte();
                    str_len = this._newBlockBytes.readUnsignedInt();
                    str_end = this._newBlockBytes.position + str_len;

                    var x:Number, y:Number, z:Number;

                    if (str_type == 1)
                    {
                        var verts:Vector.<Number> = VectorInit.Num();

                        while (this._newBlockBytes.position < str_end)
                        {
                            // TODO: Respect stream field type
                            x = this.readNumber(this._accuracyGeo);
                            y = this.readNumber(this._accuracyGeo);
                            z = this.readNumber(this._accuracyGeo);

                            verts[idx++] = x;
                            verts[idx++] = y;
                            verts[idx++] = z;
                        }
                    }
                    else if (str_type == 2)
                    {
                        var indices:Vector.<Number> = VectorInit.Num();

                        while (this._newBlockBytes.position < str_end)
                        {
                            // TODO: Respect stream field type
                            indices[idx++] = this._newBlockBytes.readUnsignedShort();
                        }

                    }
                    else if (str_type == 3)
                    {
                        var uvs:Vector.<Number> = VectorInit.Num();
                        while (this._newBlockBytes.position < str_end)
                        {
                            uvs[idx++] = this.readNumber(this._accuracyGeo);

                        }
                    }
                    else if (str_type == 4)
                    {

                        var normals:Vector.<Number> = VectorInit.Num();

                        while (this._newBlockBytes.position < str_end)
                        {
                            normals[idx++] = this.readNumber(this._accuracyGeo);
                        }

                    }
                    else if (str_type == 6)
                    {
                        w_indices = VectorInit.Num();

                        while (this._newBlockBytes.position < str_end)
                        {
                            w_indices[idx++] = this._newBlockBytes.readUnsignedShort()*3; // TODO: Respect stream field type
                        }

                    }
                    else if (str_type == 7)
                    {

                        weights = VectorInit.Num();

                        while (this._newBlockBytes.position < str_end)
                        {
                            weights[idx++] = this.readNumber(this._accuracyGeo);
                        }
                    }
                    else
                    {
                        this._newBlockBytes.position = str_end;
                    }

                }

                this.parseUserAttributes(); // Ignore sub-mesh attributes for now

                sub_geoms = GeometryUtils.fromVectors(verts, indices, uvs, normals, null, weights, w_indices);

                var scaleU:Number = subProps.get(1, 1);
                var scaleV:Number = subProps.get(2, 1);
                var setSubUVs:Boolean = false; //this should remain false atm, because in AwayBuilder the uv is only scaled by the geometry

                if ((geoScaleU != scaleU) || (geoScaleV != scaleV))
                {
                    setSubUVs = true;
                    scaleU = geoScaleU/scaleU;
                    scaleV = geoScaleV/scaleV;
                }

                for (i = 0; i < sub_geoms.length; i++) {
                    if (setSubUVs)
                        sub_geoms[i].scaleUV(scaleU, scaleV);
                    geom.addSubGeometry(sub_geoms[i]);
                    // TODO: Somehow map in-sub to out-sub indices to enable look-up
                    // when creating meshes (and their material assignments.)
                }
                subs_parsed++;
            }
            if ((geoScaleU != 1) || (geoScaleV != 1))
                geom.scaleUV(geoScaleU, geoScaleV);
            this.parseUserAttributes();
            this._pFinalizeAsset( (geom as IAsset), name );
            this._blocks[blockID].data = geom;

            if (this._debug)
            {
                Window.console.log("Parsed a TriangleGeometry: Name = " + name + "| SubGeometries = " + sub_geoms.length);
            }

        }

        //Block ID = 11
        private function parsePrimitves(blockID:Number):void
        {
            var name        : String;
            var geom        : Geometry;
            var primType    : Number;
            var subs_parsed : Number;
            var props       : AWDProperties;
            var bsm         : Matrix3D;

            // Read name and sub count
            name        = this.parseVarStr();
            primType    = this._newBlockBytes.readUnsignedByte();
            props       = this.parseProperties({101:this._geoNrType, 102:this._geoNrType, 103:this._geoNrType, 110:this._geoNrType, 111:this._geoNrType, 301:AWDParser.UINT16, 302:AWDParser.UINT16, 303:AWDParser.UINT16, 701:AWDParser.BOOL, 702:AWDParser.BOOL, 703:AWDParser.BOOL, 704:AWDParser.BOOL});

            var primitveTypes:Array = ["Unsupported Type-ID", "PlaneGeometry", "CubeGeometry", "SphereGeometry", "CylinderGeometry", "ConeGeometry", "CapsuleGeometry", "TorusGeometry"]

            switch (primType)
            {
                // to do, not all properties are set on all primitives

                case 1:
                    geom = new PlaneGeometry(props.get(101, 100), props.get(102, 100), props.get(301, 1), props.get(302, 1), props.get(701, true), props.get(702, false));
                    break;

                case 2:
                    geom = new CubeGeometry(props.get(101, 100), props.get(102, 100), props.get(103, 100), props.get(301, 1), props.get(302, 1), props.get(303, 1), props.get(701, true));
                    break;

                case 3:
                    geom = new SphereGeometry(props.get(101, 50), props.get(301, 16), props.get(302, 12), props.get(701, true));
                    break;

                case 4:
                    geom = new CylinderGeometry(props.get(101, 50), props.get(102, 50), props.get(103, 100), props.get(301, 16), props.get(302, 1), true, true, true); // bool701, bool702, bool703, bool704);
                    if (!props.get(701, true))
                        ((geom as CylinderGeometry)).topClosed = false;
                    if (!props.get(702, true))
                        ((geom as CylinderGeometry)).bottomClosed = false;
                    if (!props.get(703, true))
                        ((geom as CylinderGeometry)).yUp = false;

                    break;

                case 5:
                    geom = new ConeGeometry(props.get(101, 50), props.get(102, 100), props.get(301, 16), props.get(302, 1), props.get(701, true), props.get(702, true));
                    break;

                case 6:
                    geom = new CapsuleGeometry(props.get(101, 50), props.get(102, 100), props.get(301, 16), props.get(302, 15), props.get(701, true));
                    break;

                case 7:
                    geom = new TorusGeometry(props.get(101, 50), props.get(102, 50), props.get(301, 16), props.get(302, 8), props.get(701, true));
                    break;

                default:
                    geom = new Geometry();
                    Window.console.log("ERROR: UNSUPPORTED PRIMITIVE_TYPE");
                    break;
            }

            if ((props.get(110, 1) != 1) || (props.get(111, 1) != 1))
            {
                geom.subGeometries;
                geom.scaleUV(props.get(110, 1), props.get(111, 1));
            }

            this.parseUserAttributes();
            geom.name = name;
            this._pFinalizeAsset( (geom as IAsset), name );
            this._blocks[blockID].data = geom;

            if (this._debug)
            {
                if ((primType < 0) || (primType > 7))
                {
                    primType = 0;
                }
                Window.console.log("Parsed a Primivite: Name = " + name + "| type = " + primitveTypes[primType]);
            }
        }

        // Block ID = 22
        private function parseContainer(blockID:Number):void
        {
            var name    : String;
            var par_id  : Number;
            var mtx     : Matrix3D;
            var ctr     : ObjectContainer3D;
            var parent  : ObjectContainer3D;

            par_id  = this._newBlockBytes.readUnsignedInt();
            mtx     = this.parseMatrix3D();
            name    = this.parseVarStr();

            var parentName:String   = "Root (TopLevel)";
            ctr                     = new ObjectContainer3D();
            ctr.transform           = mtx;

            var returnedArray:Array = this.getAssetByID(par_id, new <String>[AssetType.CONTAINER, AssetType.LIGHT, AssetType.MESH, AssetType.ENTITY, AssetType.SEGMENT_SET]);

            if (returnedArray[0])
            {
                var obj : ObjectContainer3D = ( (returnedArray[1] as ObjectContainer3D) ).addChild(ctr );
                parentName = ((returnedArray[1] as ObjectContainer3D)).name;
            }
            else if (par_id > 0)
            {
                this._blocks[ blockID ].addError("Could not find a parent for this ObjectContainer3D");
            }

            // in AWD version 2.1 we read the Container properties
            if ((this._version[0] == 2) && (this._version[1] == 1))
            {
                var props:AWDProperties = this.parseProperties({1:this._matrixNrType, 2:this._matrixNrType, 3:this._matrixNrType, 4:AWDParser.UINT8});
                ctr.pivotPoint = new Vector3D(props.get(1, 0), props.get(2, 0), props.get(3, 0));
            }
            // in other versions we do not read the Container properties
            else
            {
                this.parseProperties(null);
            }

            // the extraProperties should only be set for AWD2.1-Files, but is read for both versions
            ctr.extra = this.parseUserAttributes();

            this._pFinalizeAsset( (ctr as IAsset), name );
            this._blocks[blockID].data = ctr;

            if (this._debug)
            {
                Window.console.log("Parsed a Container: Name = '" + name + "' | Parent-Name = " + parentName);
            }
        }

        // Block ID = 23
        private function parseMeshInstance(blockID:Number):void
        {
            var num_materials:Number;
            var materials_parsed:Number;
            var parent:ObjectContainer3D;
            var par_id:Number = this._newBlockBytes.readUnsignedInt();
            var mtx:Matrix3D = this.parseMatrix3D();
            var name:String = this.parseVarStr();
            var parentName:String = "Root (TopLevel)";
            var data_id:Number = this._newBlockBytes.readUnsignedInt();
            var geom:Geometry;
            var returnedArrayGeometry:Array = this.getAssetByID(data_id, new <String>[AssetType.GEOMETRY])

            if (returnedArrayGeometry[0])
            {
                geom = (returnedArrayGeometry[1] as Geometry);
            }
            else
            {
                this._blocks[blockID].addError("Could not find a Geometry for this Mesh. A empty Geometry is created!");
                geom = new Geometry();
            }

            this._blocks[blockID].geoID = data_id;
            var materials:Vector.<MaterialBase> = new Vector.<MaterialBase>();
            num_materials = this._newBlockBytes.readUnsignedShort();

            var materialNames:Vector.<String> = VectorInit.Str();
            materials_parsed = 0;

            var returnedArrayMaterial:Array;

            while (materials_parsed < num_materials)
            {
                var mat_id:Number;
                mat_id = this._newBlockBytes.readUnsignedInt();
                returnedArrayMaterial = this.getAssetByID(mat_id, new <String>[AssetType.MATERIAL])
                if ((!returnedArrayMaterial[0]) && (mat_id > 0))
                {
                    this._blocks[blockID].addError("Could not find Material Nr " + materials_parsed + " (ID = " + mat_id + " ) for this Mesh");
                }

                var m : MaterialBase = (returnedArrayMaterial[1] as MaterialBase);

                materials.push(m);
                materialNames.push(m.name);

                materials_parsed++;
            }

            var mesh:Mesh = new Mesh(geom, null);
                mesh.transform = mtx;

            var returnedArrayParent:Array = this.getAssetByID(par_id, new <String>[AssetType.CONTAINER, AssetType.LIGHT, AssetType.MESH, AssetType.ENTITY, AssetType.SEGMENT_SET])

            if (returnedArrayParent[0])
            {
                var objC : ObjectContainer3D = (returnedArrayParent[1] as ObjectContainer3D);
                    objC.addChild(mesh);
                parentName = objC.name;
            }
            else if (par_id > 0)
            {
                this._blocks[blockID].addError("Could not find a parent for this Mesh");
            }

            if (materials.length >= 1 && mesh.subMeshes.length == 1)
            {
                mesh.material = materials[0];
            }
            else if (materials.length > 1)
            {
                var i:Number;

                // Assign each sub-mesh in the mesh a material from the list. If more sub-meshes
                // than materials, repeat the last material for all remaining sub-meshes.
                for (i = 0; i < mesh.subMeshes.length; i++)
                {
                    mesh.subMeshes[i].material = materials[Math.min(materials.length - 1, i)];
                }
            }
            if ((this._version[0] == 2) && (this._version[1] == 1))
            {
                var props:AWDProperties = this.parseProperties({1:this._matrixNrType, 2:this._matrixNrType, 3:this._matrixNrType, 4:AWDParser.UINT8, 5:AWDParser.BOOL});
                mesh.pivotPoint = new Vector3D(Number(props.get(1, 0)), Number(props.get(2, 0)), Number(props.get(3, 0)));
                mesh.castsShadows = props.get(5, true);
            }
            else
            {
                this.parseProperties(null);
            }

            mesh.extra = this.parseUserAttributes();

            this._pFinalizeAsset( (mesh as IAsset), name );
            this._blocks[blockID].data = mesh;

            if (this._debug)
            {
                Window.console.log("Parsed a Mesh: Name = '" + name + "' | Parent-Name = " + parentName + "| Geometry-Name = " + geom.name + " | SubMeshes = " + mesh.subMeshes.length + " | Mat-Names = " + materialNames.toString());
            }
        }

        //Block ID = 41
        private function parseLight(blockID:Number):void
        {
            var light           : LightBase;
            var newShadowMapper : ShadowMapperBase;

            var par_id          : Number                = this._newBlockBytes.readUnsignedInt();
            var mtx             : Matrix3D    = this.parseMatrix3D();
            var name            : String                = this.parseVarStr();
            var lightType       : Number                = this._newBlockBytes.readUnsignedByte();
            var props           : AWDProperties         = this.parseProperties({1:this._propsNrType, 2:this._propsNrType, 3:AWDParser.COLOR, 4:this._propsNrType, 5:this._propsNrType, 6:AWDParser.BOOL, 7:AWDParser.COLOR, 8:this._propsNrType, 9:AWDParser.UINT8, 10:AWDParser.UINT8, 11:this._propsNrType, 12:AWDParser.UINT16, 21:this._matrixNrType, 22:this._matrixNrType, 23:this._matrixNrType});
            var shadowMapperType: Number                = props.get(9, 0);
            var parentName      : String                = "Root (TopLevel)";
            var lightTypes      : Vector.<String>         = new String["Unsupported LightType", "PointLight", "DirectionalLight"];
            var shadowMapperTypes : Vector.<String>       = new String["No ShadowMapper", "DirectionalShadowMapper", "NearDirectionalShadowMapper", "CascadeShadowMapper", "CubeMapShadowMapper"];

            if (lightType == 1)
            {
                light = new PointLight();

                ((light as PointLight)).radius     = props.get(1 , 90000 );
                ((light as PointLight)).fallOff    = props.get(2 , 100000 );

                if (shadowMapperType > 0)
                {
                    if (shadowMapperType == 4)
                    {
                        newShadowMapper = new CubeMapShadowMapper();
                    }
                }

                light.transform = mtx;

            }

            if (lightType == 2)
            {

                light = new DirectionalLight(props.get(21, 0), props.get(22, -1), props.get(23, 1));

                if (shadowMapperType > 0)
                {
                    if (shadowMapperType == 1)
                    {
                        newShadowMapper = new DirectionalShadowMapper();
                    }

                    //if (shadowMapperType == 2)
                    //  newShadowMapper = new NearDirectionalShadowMapper(props.get(11, 0.5));
                    //if (shadowMapperType == 3)
                    //   newShadowMapper = new CascadeShadowMapper(props.get(12, 3));

                }

            }
            light.color         = props.get(3, 0xffffff);
            light.specular      = props.get(4, 1.0);
            light.diffuse       = props.get(5, 1.0);
            light.ambientColor  = props.get(7, 0xffffff);
            light.ambient       = props.get(8, 0.0);

            // if a shadowMapper has been created, adjust the depthMapSize if needed, assign to light and set castShadows to true
            if (newShadowMapper)
            {
                if (newShadowMapper instanceof CubeMapShadowMapper )
                {
                    if (props.get(10, 1) != 1)
                    {
                        newShadowMapper.depthMapSize = this._depthSizeDic[props.get(10, 1)];
                    }
                }
                else
                {
                    if (props.get(10, 2) != 2)
                    {
                        newShadowMapper.depthMapSize = this._depthSizeDic[props.get(10, 2)];
                    }
                }

                light.shadowMapper = newShadowMapper;
                light.castsShadows = true;
            }

            if (par_id != 0)
            {

                var returnedArrayParent : Array = this.getAssetByID(par_id, new <String>[AssetType.CONTAINER, AssetType.LIGHT, AssetType.MESH, AssetType.ENTITY, AssetType.SEGMENT_SET])

                if (returnedArrayParent[0])
                {
                    ((returnedArrayParent[1] as ObjectContainer3D)).addChild(light );
                    parentName = ((returnedArrayParent[1] as ObjectContainer3D)).name;
                }
                else
                {
                    this._blocks[blockID].addError("Could not find a parent for this Light");
                }
            }

            this.parseUserAttributes();

            this._pFinalizeAsset( (light as IAsset), name );

            this._blocks[blockID].data = light;

            if (this._debug)
                Window.console.log("Parsed a Light: Name = '" + name + "' | Type = " + lightTypes[lightType] + " | Parent-Name = " + parentName + " | ShadowMapper-Type = " + shadowMapperTypes[shadowMapperType]);

        }

        //Block ID = 43
        private function parseCamera(blockID:Number):void
        {

            var par_id      : Number                = this._newBlockBytes.readUnsignedInt();
            var mtx         : Matrix3D    = this.parseMatrix3D();
            var name        : String                = this.parseVarStr();
            var parentName  : String                = "Root (TopLevel)";
            var lens        : LensBase;

            this._newBlockBytes.readUnsignedByte(); //set as active camera
            this._newBlockBytes.readShort(); //lengthof lenses - not used yet

            var lenstype    : Number        = this._newBlockBytes.readShort();
            var props       : AWDProperties = this.parseProperties({101:this._propsNrType, 102:this._propsNrType, 103:this._propsNrType, 104:this._propsNrType});

            switch (lenstype)
            {
                case 5001:
                    lens = new PerspectiveLens(props.get(101, 60));
                    break;
                case 5002:
                    lens = new OrthographicLens(props.get(101, 500));
                    break;
                case 5003:
                    lens = new OrthographicOffCenterLens(props.get(101, -400), props.get(102, 400), props.get(103, -300), props.get(104, 300));
                    break;
                default:
                    Window.console.log("unsupportedLenstype");
                    return;
            }

            var camera:Camera3D    = new Camera3D(lens);
                camera.transform                = mtx;

            var returnedArrayParent:Array  = this.getAssetByID(par_id, new <String>[AssetType.CONTAINER, AssetType.LIGHT, AssetType.MESH, AssetType.ENTITY, AssetType.SEGMENT_SET])

            if (returnedArrayParent[0])
            {

                var objC : ObjectContainer3D = (returnedArrayParent[1] as ObjectContainer3D);
                    objC.addChild(camera);

                parentName = objC.name;

            }
            else if (par_id > 0)
            {
                this._blocks[blockID].addError("Could not find a parent for this Camera");
            }

            camera.name         = name;
            props               = this.parseProperties({1:this._matrixNrType, 2:this._matrixNrType, 3:this._matrixNrType, 4:AWDParser.UINT8});
            camera.pivotPoint   = new Vector3D(props.get(1, 0), props.get(2, 0), props.get(3, 0));
            camera.extra        = this.parseUserAttributes();

            this._pFinalizeAsset( (camera as IAsset), name );

            this._blocks[blockID].data = camera

            if (this._debug)
            {
                Window.console.log("Parsed a Camera: Name = '" + name + "' | Lenstype = " + lens + " | Parent-Name = " + parentName);
            }

        }

        //Block ID = 51
        private function parseLightPicker(blockID:Number):void
        {
            var name        : String                            = this.parseVarStr();
            var numLights   : Number                            = this._newBlockBytes.readUnsignedShort();
            var lightsArray : Vector.<LightBase>      = new Vector.<LightBase>();
            var k           : Number                            = 0;
            var lightID     : Number                            = 0;

            var returnedArrayLight  : Array;
            var lightsArrayNames    : Vector.<String>             = VectorInit.Str();

            for (k = 0; k < numLights; k++)
            {
                lightID             = this._newBlockBytes.readUnsignedInt();
                returnedArrayLight  = this.getAssetByID(lightID, new <String>[AssetType.LIGHT])

                if (returnedArrayLight[0])
                {
                    lightsArray.push( (returnedArrayLight[1] as LightBase) );
                    lightsArrayNames.push( ( (returnedArrayLight[1] as LightBase)).name  );

                }
                else
                {
                    this._blocks[blockID].addError("Could not find a Light Nr " + k + " (ID = " + lightID + " ) for this LightPicker");
                }
            }

            if (lightsArray.length == 0)
            {
                this._blocks[blockID].addError("Could not create this LightPicker, cause no Light was found.");
                this.parseUserAttributes();
                return; //return without any more parsing for this block
            }

            var lightPick:LightPickerBase    = new StaticLightPicker(lightsArray);
                lightPick.name                              = name;

            this.parseUserAttributes();
            this._pFinalizeAsset( (lightPick as IAsset), name );

            this._blocks[blockID].data = lightPick
            if (this._debug)
            {
                Window.console.log("Parsed a StaticLightPicker: Name = '" + name + "' | Texture-Name = " + lightsArrayNames.toString());
            }
        }

        //Block ID = 81
        private function parseMaterial(blockID:Number):void
        {
            // TODO: not used
            ////blockLength = block.len;
            var name:String;
            var type:Number;
            var props:AWDProperties;
            var mat:MaterialBase;
            var attributes:Object;
            var finalize:Boolean;
            var num_methods:Number;
            var methods_parsed:Number;
            var returnedArray:Array;

            name = this.parseVarStr();
            type = this._newBlockBytes.readUnsignedByte();
            num_methods = this._newBlockBytes.readUnsignedByte();

            // Read material numerical properties
            // (1=color, 2=bitmap url, 10=alpha, 11=alpha_blending, 12=alpha_threshold, 13=repeat)
            props = this.parseProperties( { 1:AWDParser.INT32, 2:AWDParser.BADDR, 10:this._propsNrType, 11:AWDParser.BOOL, 12:this._propsNrType, 13:AWDParser.BOOL});

            methods_parsed = 0;
            while (methods_parsed < num_methods)
            {
                var method_type:Number;

                method_type = this._newBlockBytes.readUnsignedShort();
                this.parseProperties(null);
                this.parseUserAttributes();
                methods_parsed += 1;
            }
            var debugString:String = "";
            attributes = this.parseUserAttributes();
            if (type === 1) { // Color material
                debugString += "Parsed a ColorMaterial(SinglePass): Name = '" + name + "' | ";
                var color:Number;
                color = props.get(1, 0xcccccc);
                if (this.materialMode < 2)
                    mat = new ColorMaterial(color, props.get(10, 1.0));
                else
                    mat = new ColorMultiPassMaterial(color);

            }
            else if (type === 2)
            {
                var tex_addr:Number = props.get(2, 0);

                returnedArray = this.getAssetByID(tex_addr, new <String>[AssetType.TEXTURE])
                if ((!returnedArray[0]) && (tex_addr > 0))
                {
                    this._blocks[blockID].addError("Could not find the DiffsueTexture (ID = " + tex_addr + " ) for this Material");
                }

                if (this.materialMode < 2)
                {
                    mat = (new TextureMaterial( Texture2DBase(returnedArray[1] ) ) as MaterialBase);

                    var txMaterial : TextureMaterial = (mat as TextureMaterial);

                    txMaterial.alphaBlending = props.get(11, false);
                    txMaterial.alpha = props.get(10, 1.0);
                    debugString += "Parsed a TextureMaterial(SinglePass): Name = '" + name + "' | Texture-Name = " + mat.name;
                }
                else
                {
                    mat = (new TextureMultiPassMaterial(returnedArray[1] ) as MaterialBase);
                    debugString += "Parsed a TextureMaterial(MultipAss): Name = '" + name + "' | Texture-Name = " + mat.name;
                }
            }

            mat.extra = attributes;
            if (this.materialMode < 2)
            {

                var spmb : SinglePassMaterialBase = (mat as SinglePassMaterialBase);
                spmb.alphaThreshold = props.get(12, 0.0);

            }
            else
            {
                var mpmb : MultiPassMaterialBase = (mat as MultiPassMaterialBase);
                mpmb.alphaThreshold = props.get(12, 0.0);
            }


            mat.repeat = props.get(13, false);
            this._pFinalizeAsset( (mat as IAsset), name );
            this._blocks[blockID].data = mat;

            if (this._debug)
            {
                Window.console.log(debugString);

            }
        }

        // Block ID = 81 AWD2.1
        private function parseMaterial_v1(blockID:Number):void
        {
            var mat                 : MaterialBase;
            var normalTexture       : Texture2DBase;
            var specTexture         : Texture2DBase;
            var returnedArray       : Array;

            var name                : String        = this.parseVarStr();
            var type                : Number        = this._newBlockBytes.readUnsignedByte();
            var num_methods         : Number        = this._newBlockBytes.readUnsignedByte();
            var props               : AWDProperties = this.parseProperties({1:AWDParser.UINT32, 2:AWDParser.BADDR, 3:AWDParser.BADDR, 4:AWDParser.UINT8, 5:AWDParser.BOOL, 6:AWDParser.BOOL, 7:AWDParser.BOOL, 8:AWDParser.BOOL, 9:AWDParser.UINT8, 10:this._propsNrType, 11:AWDParser.BOOL, 12:this._propsNrType, 13:AWDParser.BOOL, 15:this._propsNrType, 16:AWDParser.UINT32, 17:AWDParser.BADDR, 18:this._propsNrType, 19:this._propsNrType, 20:AWDParser.UINT32, 21:AWDParser.BADDR, 22:AWDParser.BADDR});
            var spezialType         : Number        = props.get(4, 0);
            var debugString         : String        = "";

            if (spezialType >= 2)//this is no supported material
            {
                this._blocks[blockID].addError("Material-spezialType '" + spezialType + "' is not supported, can only be 0:singlePass, 1:MultiPass !");
                return;
            }

            if (this.materialMode == 1)
            {
                spezialType = 0;
            }
            else if (this.materialMode == 2)
            {
                spezialType = 1;
            }

            if (spezialType < 2)//this is SinglePass or MultiPass
            {
                if (type == 1)// Color material
                {
                    var color : Number = props.get(1, 0xcccccc);//var color : number = color = props.get(1, 0xcccccc);

                    if (spezialType == 1)//	MultiPassMaterial
                    {
                        mat         = new ColorMultiPassMaterial(color);
                        debugString += "Parsed a ColorMaterial(MultiPass): Name = '" + name + "' | ";
                    }
                    else //	SinglePassMaterial
                    {
                        mat = new ColorMaterial(color, props.get(10, 1.0));
                        ((mat as ColorMaterial)).alphaBlending = props.get(11 , false );
                        debugString += "Parsed a ColorMaterial(SinglePass): Name = '" + name + "' | ";
                    }
                }
                else if (type == 2)// texture material
                {

                    var tex_addr    : Number    = props.get(2, 0);
                    returnedArray               = this.getAssetByID(tex_addr, new <String>[AssetType.TEXTURE]);

                    if ((!returnedArray[0]) && (tex_addr > 0))
                    {
                        this._blocks[blockID].addError("Could not find the DiffuseTexture (ID = " + tex_addr + " ) for this TextureMaterial");
                    }
                    var texture         : Texture2DBase = returnedArray[1];
                    var ambientTexture  : Texture2DBase;
                    var ambientTex_addr : Number = props.get(17, 0);

                    returnedArray = this.getAssetByID(ambientTex_addr, new <String>[AssetType.TEXTURE]);

                    if ((!returnedArray[0]) && (ambientTex_addr != 0))
                    {
                        this._blocks[blockID].addError("Could not find the AmbientTexture (ID = " + ambientTex_addr + " ) for this TextureMaterial");
                    }

                    if (returnedArray[0])
                    {
                        ambientTexture = returnedArray[1]
                    }

                    if (spezialType == 1)// MultiPassMaterial
                    {
                        mat         = new TextureMultiPassMaterial(texture);
                        debugString += "Parsed a TextureMaterial(MultiPass): Name = '" + name + "' | Texture-Name = " + texture.name;

                        if (ambientTexture)
                        {
                            ( (mat as TextureMultiPassMaterial)).ambientTexture = ambientTexture;
                            debugString += " | AmbientTexture-Name = " + ambientTexture.name;
                        }
                    }
                    else//	SinglePassMaterial
                    {
                        mat         = new TextureMaterial(texture);
                        debugString += "Parsed a TextureMaterial(SinglePass): Name = '" + name + "' | Texture-Name = " + texture.name;

                        if (ambientTexture)
                        {
                            ((mat as TextureMaterial)).ambientTexture = ambientTexture;
                            debugString += " | AmbientTexture-Name = " + ambientTexture.name;
                        }

                        ((mat as TextureMaterial)).alpha = props.get(10 , 1.0 );
                        ((mat as TextureMaterial)).alphaBlending = props.get(11 , false );
                    }

                }

                var normalTex_addr:Number = props.get(3, 0);

                returnedArray = this.getAssetByID(normalTex_addr, new <String>[AssetType.TEXTURE]);

                if ((!returnedArray[0]) && (normalTex_addr != 0))
                {
                    this._blocks[blockID].addError("Could not find the NormalTexture (ID = " + normalTex_addr + " ) for this TextureMaterial");
                }

                if (returnedArray[0])
                {
                    normalTexture = returnedArray[1];
                    debugString += " | NormalTexture-Name = " + normalTexture.name;
                }

                var specTex_addr : Number = props.get(21, 0);
                returnedArray = this.getAssetByID(specTex_addr, new <String>[AssetType.TEXTURE]);

                if ((!returnedArray[0]) && (specTex_addr != 0))
                {
                    this._blocks[blockID].addError("Could not find the SpecularTexture (ID = " + specTex_addr + " ) for this TextureMaterial");
                }
                if (returnedArray[0])
                {
                    specTexture = returnedArray[1];
                    debugString += " | SpecularTexture-Name = " + specTexture.name;
                }

                var lightPickerAddr : Number = props.get(22, 0);
                returnedArray = this.getAssetByID(lightPickerAddr, new <String>[AssetType.LIGHT_PICKER])

                if ((!returnedArray[0]) && (lightPickerAddr))
                {
                    this._blocks[blockID].addError("Could not find the LightPicker (ID = " + lightPickerAddr + " ) for this TextureMaterial");
                }
                else
                {
                    (MaterialBase(mat)).lightPicker = LightPickerBase(returnedArray[1]) ;
                    //debugString+=" | Lightpicker-Name = "+LightPickerBase(returnedArray[1]).name;
                }

                (MaterialBase(mat)).smooth              = props.get(5, true);
                (MaterialBase(mat)).mipmap              = props.get(6, true);
                (MaterialBase(mat)).bothSides           = props.get(7, false);
                (MaterialBase(mat)).alphaPremultiplied  = props.get(8, false);
                (MaterialBase(mat)).blendMode           = this.blendModeDic[props.get(9, 0)];
                (MaterialBase(mat)).repeat              = props.get(13, false);

                if (spezialType == 0)// this is a SinglePassMaterial
                {
                    if (normalTexture)
                    {
                        ((mat as SinglePassMaterialBase)).normalMap = normalTexture;
                    }
                    if (specTexture)
                    {
                        ((mat as SinglePassMaterialBase)).specularMap = specTexture;
                    }

                    ((mat as SinglePassMaterialBase)).alphaThreshold    = props.get(12 , 0.0 );
                    ((mat as SinglePassMaterialBase)).ambient           = props.get(15 , 1.0 );
                    ((mat as SinglePassMaterialBase)).ambientColor      = props.get(16 , 0xffffff );
                    ((mat as SinglePassMaterialBase)).specular          = props.get(18 , 1.0 );
                    ((mat as SinglePassMaterialBase)).gloss             = props.get(19 , 50 );
                    ((mat as SinglePassMaterialBase)).specularColor     = props.get(20 , 0xffffff );
                }
                else // this is MultiPassMaterial
                {
                    if (normalTexture)
                    {
                        ((mat as MultiPassMaterialBase)).normalMap = normalTexture;
                    }
                    if (specTexture)
                    {
                        ((mat as MultiPassMaterialBase)).specularMap = specTexture;
                    }

                    ((mat as MultiPassMaterialBase)).alphaThreshold = props.get(12 , 0.0 );
                    ((mat as MultiPassMaterialBase)).ambient        = props.get(15 , 1.0 );
                    ((mat as MultiPassMaterialBase)).ambientColor   = props.get(16 , 0xffffff );
                    ((mat as MultiPassMaterialBase)).specular       = props.get(18 , 1.0 );
                    ((mat as MultiPassMaterialBase)).gloss          = props.get(19 , 50 );
                    ((mat as MultiPassMaterialBase)).specularColor  = props.get(20 , 0xffffff );

                }

                var methods_parsed  : Number = 0;
                var targetID        : Number;

                while (methods_parsed < num_methods)
                {
                    var method_type : Number ;
                        method_type = this._newBlockBytes.readUnsignedShort();

                    props = this.parseProperties({1:AWDParser.BADDR, 2:AWDParser.BADDR, 3:AWDParser.BADDR, 101:this._propsNrType, 102:this._propsNrType, 103:this._propsNrType, 201:AWDParser.UINT32, 202:AWDParser.UINT32, 301:AWDParser.UINT16, 302:AWDParser.UINT16, 401:AWDParser.UINT8, 402:AWDParser.UINT8, 601:AWDParser.COLOR, 602:AWDParser.COLOR, 701:AWDParser.BOOL, 702:AWDParser.BOOL, 801:AWDParser.MTX4x4});

                    switch (method_type)
                    {
                        case 999: //wrapper-Methods that will load a previous parsed EffektMethod returned

                            targetID = props.get(1, 0);
                            returnedArray = this.getAssetByID(targetID, new <String>[AssetType.EFFECTS_METHOD]);

                            if (!returnedArray[0])
                            {
                                this._blocks[blockID].addError("Could not find the EffectMethod (ID = " + targetID + " ) for this Material");
                            }
                            else
                            {
                                if (spezialType == 0)
                                {
                                    ((mat as SinglePassMaterialBase)).addMethod(returnedArray[1] );
                                }
                                if (spezialType == 1)
                                {
                                    ((mat as MultiPassMaterialBase)).addMethod(returnedArray[1] );
                                }

                                debugString += " | EffectMethod-Name = " + ((returnedArray[1] as EffectMethodBase)).name;
                            }

                            break;

                        case 998: //wrapper-Methods that will load a previous parsed ShadowMapMethod

                            targetID = props.get(1, 0);
                            returnedArray = this.getAssetByID(targetID, new <String>[AssetType.SHADOW_MAP_METHOD]);

                            if (!returnedArray[0])
                            {
                                this._blocks[blockID].addError("Could not find the ShadowMethod (ID = " + targetID + " ) for this Material");
                            }
                            else
                            {
                                if (spezialType == 0)
                                {
                                    ((mat as SinglePassMaterialBase)).shadowMethod = returnedArray[1];
                                }

                                if (spezialType == 1)
                                {
                                    ((mat as MultiPassMaterialBase)).shadowMethod = returnedArray[1];
                                }

                                debugString += " | ShadowMethod-Name = " + ((returnedArray[1] as ShadowMapMethodBase)).name;

                            }

                            break;

    //						case 1: //EnvMapAmbientMethod
    //							targetID = props.get(1, 0);
    //							returnedArray = getAssetByID(targetID, [AssetType.TEXTURE], "CubeTexture");
    //							if (!returnedArray[0])
    //								_blocks[blockID].addError("Could not find the EnvMap (ID = " + targetID + " ) for this EnvMapAmbientMethodMaterial");
    //							if (spezialType == 0)
    //								SinglePassMaterialBase(mat).ambientMethod = new EnvMapAmbientMethod(returnedArray[1]);
    //							if (spezialType == 1)
    //								MultiPassMaterialBase(mat).ambientMethod = new EnvMapAmbientMethod(returnedArray[1]);
    //							debugString += " | EnvMapAmbientMethod | EnvMap-Name =" + CubeTextureBase(returnedArray[1]).name;
    //							break;
    //
    //						case 51: //DepthDiffuseMethod
    //							if (spezialType == 0)
    //								SinglePassMaterialBase(mat).diffuseMethod = new DepthDiffuseMethod();
    //							if (spezialType == 1)
    //								MultiPassMaterialBase(mat).diffuseMethod = new DepthDiffuseMethod();
    //							debugString += " | DepthDiffuseMethod";
    //							break;
    //						case 52: //GradientDiffuseMethod
    //							targetID = props.get(1, 0);
    //							returnedArray = getAssetByID(targetID, [AssetType.TEXTURE]);
    //							if (!returnedArray[0])
    //								_blocks[blockID].addError("Could not find the GradientDiffuseTexture (ID = " + targetID + " ) for this GradientDiffuseMethod");
    //							if (spezialType == 0)
    //								SinglePassMaterialBase(mat).diffuseMethod = new GradientDiffuseMethod(returnedArray[1]);
    //							if (spezialType == 1)
    //								MultiPassMaterialBase(mat).diffuseMethod = new GradientDiffuseMethod(returnedArray[1]);
    //							debugString += " | GradientDiffuseMethod | GradientDiffuseTexture-Name =" + Texture2DBase(returnedArray[1]).name;
    //							break;
    //						case 53: //WrapDiffuseMethod
    //							if (spezialType == 0)
    //								SinglePassMaterialBase(mat).diffuseMethod = new WrapDiffuseMethod(props.get(101, 5));
    //							if (spezialType == 1)
    //								MultiPassMaterialBase(mat).diffuseMethod = new WrapDiffuseMethod(props.get(101, 5));
    //							debugString += " | WrapDiffuseMethod";
    //							break;
    //						case 54: //LightMapDiffuseMethod
    //							targetID = props.get(1, 0);
    //							returnedArray = getAssetByID(targetID, [AssetType.TEXTURE]);
    //							if (!returnedArray[0])
    //								_blocks[blockID].addError("Could not find the LightMap (ID = " + targetID + " ) for this LightMapDiffuseMethod");
    //							if (spezialType == 0)
    //								SinglePassMaterialBase(mat).diffuseMethod = new LightMapDiffuseMethod(returnedArray[1], blendModeDic[props.get(401, 10)], false, SinglePassMaterialBase(mat).diffuseMethod);
    //							if (spezialType == 1)
    //								MultiPassMaterialBase(mat).diffuseMethod = new LightMapDiffuseMethod(returnedArray[1], blendModeDic[props.get(401, 10)], false, MultiPassMaterialBase(mat).diffuseMethod);
    //							debugString += " | LightMapDiffuseMethod | LightMapTexture-Name =" + Texture2DBase(returnedArray[1]).name;
    //							break;
    //						case 55: //CelDiffuseMethod
    //							if (spezialType == 0) {
    //								SinglePassMaterialBase(mat).diffuseMethod = new CelDiffuseMethod(props.get(401, 3), SinglePassMaterialBase(mat).diffuseMethod);
    //								CelDiffuseMethod(SinglePassMaterialBase(mat).diffuseMethod).smoothness = props.get(101, 0.1);
    //							}
    //							if (spezialType == 1) {
    //								MultiPassMaterialBase(mat).diffuseMethod = new CelDiffuseMethod(props.get(401, 3), MultiPassMaterialBase(mat).diffuseMethod);
    //								CelDiffuseMethod(MultiPassMaterialBase(mat).diffuseMethod).smoothness = props.get(101, 0.1);
    //							}
    //							debugString += " | CelDiffuseMethod";
    //							break;
    //						case 56: //SubSurfaceScatteringMethod
    //							if (spezialType == 0) {
    //								SinglePassMaterialBase(mat).diffuseMethod = new SubsurfaceScatteringDiffuseMethod(); //depthMapSize and depthMapOffset ?
    //								SubsurfaceScatteringDiffuseMethod(SinglePassMaterialBase(mat).diffuseMethod).scattering = props.get(101, 0.2);
    //								SubsurfaceScatteringDiffuseMethod(SinglePassMaterialBase(mat).diffuseMethod).translucency = props.get(102, 1);
    //								SubsurfaceScatteringDiffuseMethod(SinglePassMaterialBase(mat).diffuseMethod).scatterColor = props.get(601, 0xffffff);
    //							}
    //							if (spezialType == 1) {
    //								MultiPassMaterialBase(mat).diffuseMethod = new SubsurfaceScatteringDiffuseMethod(); //depthMapSize and depthMapOffset ?
    //								SubsurfaceScatteringDiffuseMethod(MultiPassMaterialBase(mat).diffuseMethod).scattering = props.get(101, 0.2);
    //								SubsurfaceScatteringDiffuseMethod(MultiPassMaterialBase(mat).diffuseMethod).translucency = props.get(102, 1);
    //								SubsurfaceScatteringDiffuseMethod(MultiPassMaterialBase(mat).diffuseMethod).scatterColor = props.get(601, 0xffffff);
    //							}
    //							debugString += " | SubSurfaceScatteringMethod";
    //							break;
    //
    //						case 101: //AnisotropicSpecularMethod
    //							if (spezialType == 0)
    //								SinglePassMaterialBase(mat).specularMethod = new AnisotropicSpecularMethod();
    //							if (spezialType == 1)
    //								MultiPassMaterialBase(mat).specularMethod = new AnisotropicSpecularMethod();
    //							debugString += " | AnisotropicSpecularMethod";
    //							break;
    //						case 102: //PhongSpecularMethod
    //							if (spezialType == 0)
    //								SinglePassMaterialBase(mat).specularMethod = new PhongSpecularMethod();
    //							if (spezialType == 1)
    //								MultiPassMaterialBase(mat).specularMethod = new PhongSpecularMethod();
    //							debugString += " | PhongSpecularMethod";
    //							break;
    //						case 103: //CellSpecularMethod
    //							if (spezialType == 0) {
    //								SinglePassMaterialBase(mat).specularMethod = new CelSpecularMethod(props.get(101, 0.5), SinglePassMaterialBase(mat).specularMethod);
    //								CelSpecularMethod(SinglePassMaterialBase(mat).specularMethod).smoothness = props.get(102, 0.1);
    //							}
    //							if (spezialType == 1) {
    //								MultiPassMaterialBase(mat).specularMethod = new CelSpecularMethod(props.get(101, 0.5), MultiPassMaterialBase(mat).specularMethod);
    //								CelSpecularMethod(MultiPassMaterialBase(mat).specularMethod).smoothness = props.get(102, 0.1);
    //							}
    //							debugString += " | CellSpecularMethod";
    //							break;
    //						case 104: //FresnelSpecularMethod
    //							if (spezialType == 0) {
    //								SinglePassMaterialBase(mat).specularMethod = new FresnelSpecularMethod(props.get(701, true), SinglePassMaterialBase(mat).specularMethod);
    //								FresnelSpecularMethod(SinglePassMaterialBase(mat).specularMethod).fresnelPower = props.get(101, 5);
    //								FresnelSpecularMethod(SinglePassMaterialBase(mat).specularMethod).normalReflectance = props.get(102, 0.1);
    //							}
    //							if (spezialType == 1) {
    //								MultiPassMaterialBase(mat).specularMethod = new FresnelSpecularMethod(props.get(701, true), MultiPassMaterialBase(mat).specularMethod);
    //								FresnelSpecularMethod(MultiPassMaterialBase(mat).specularMethod).fresnelPower = props.get(101, 5);
    //								FresnelSpecularMethod(MultiPassMaterialBase(mat).specularMethod).normalReflectance = props.get(102, 0.1);
    //							}
    //							debugString += " | FresnelSpecularMethod";
    //							break;
    //						//case 151://HeightMapNormalMethod - thios is not implemented for now, but might appear later
    //						//break;
    //						case 152: //SimpleWaterNormalMethod
    //							targetID = props.get(1, 0);
    //							returnedArray = getAssetByID(targetID, [AssetType.TEXTURE]);
    //							if (!returnedArray[0])
    //								_blocks[blockID].addError("Could not find the SecoundNormalMap (ID = " + targetID + " ) for this SimpleWaterNormalMethod");
    //							if (spezialType == 0) {
    //								if (!SinglePassMaterialBase(mat).normalMap)
    //									_blocks[blockID].addError("Could not find a normal Map on this Material to use with this SimpleWaterNormalMethod");
    //								SinglePassMaterialBase(mat).normalMap = returnedArray[1];
    //								SinglePassMaterialBase(mat).normalMethod = new SimpleWaterNormalMethod(SinglePassMaterialBase(mat).normalMap, returnedArray[1]);
    //							}
    //							if (spezialType == 1) {
    //								if (!MultiPassMaterialBase(mat).normalMap)
    //									_blocks[blockID].addError("Could not find a normal Map on this Material to use with this SimpleWaterNormalMethod");
    //								MultiPassMaterialBase(mat).normalMap = returnedArray[1];
    //								MultiPassMaterialBase(mat).normalMethod = new SimpleWaterNormalMethod(MultiPassMaterialBase(mat).normalMap, returnedArray[1]);
    //							}
    //							debugString += " | SimpleWaterNormalMethod | Second-NormalTexture-Name = " + Texture2DBase(returnedArray[1]).name;
    //							break;
                    }
                    this.parseUserAttributes();
                    methods_parsed += 1;
                }
            }
            (MaterialBase(mat)).extra = this.parseUserAttributes();
            this._pFinalizeAsset( (mat as IAsset), name );

            this._blocks[blockID].data = mat;
            if (this._debug)
            {
                Window.console.log(debugString);
            }
        }

        //Block ID = 82
        private function parseTexture(blockID:Number):void
        {

            var asset:Texture2DBase;

            this._blocks[blockID].name  = this.parseVarStr();

            var type:Number             = this._newBlockBytes.readUnsignedByte();
            var data_len:Number;

            this._texture_users[this._cur_block_id.toString()] = [];

            // External
            if (type == 0)
            {
                data_len = this._newBlockBytes.readUnsignedInt();
                var url:String;
                url = this._newBlockBytes.readUTFBytes(data_len);
                this._pAddDependency( this._cur_block_id.toString(), new URLRequest(url), false, null, true);

            }
            else
            {
                data_len = this._newBlockBytes.readUnsignedInt();

                var data:ByteArray;
                    data = new ByteArray();
                this._newBlockBytes.readBytes( data , 0 , data_len );

	            //
	            // AWDParser - Fix for FireFox Bug: https://bugzilla.mozilla.org/show_bug.cgi?id=715075 .
	            //
	            // Converting data to image here instead of parser - fix FireFox bug where image width / height is 0 when created from data
	            // This gives the browser time to initialise image width / height.

	            this._pAddDependency(this._cur_block_id.toString(), null, false, ParserUtil.byteArrayToImage( data ), true);
	            //this._pAddDependency(this._cur_block_id.toString(), null, false, data, true);

            }

            // Ignore for now
            this.parseProperties(null);
            this._blocks[blockID].extras = this.parseUserAttributes();
            this._pPauseAndRetrieveDependencies();
            this._blocks[blockID].data = asset;

            if (this._debug)
            {
                var textureStylesNames:Array = ["external", "embed"]
                Window.console.log("Start parsing a " + textureStylesNames[type] + " Bitmap for Texture");
            }

        }

        //Block ID = 83
        private function parseCubeTexture(blockID:Number):void
        {
            //blockLength = block.len;
            var data_len    : Number;
            var asset       : CubeTextureBase;
            var i           : Number;

            this._cubeTextures = new Array();
            this._texture_users[ this._cur_block_id.toString() ] = [];

            var type        : Number    = this._newBlockBytes.readUnsignedByte();

            this._blocks[blockID].name  = this.parseVarStr();

            for (i = 0; i < 6; i++)
            {
                this._texture_users[this._cur_block_id.toString()] = [];
                this._cubeTextures.push(null);

                // External
                if (type == 0)
                {
                    data_len    = this._newBlockBytes.readUnsignedInt();
                    var url:String;
                    url         = this._newBlockBytes.readUTFBytes(data_len);

                    this._pAddDependency(  this._cur_block_id.toString() + "#" + i , new URLRequest( url ) , false, null, true);
                }
                else
                {

                    data_len = this._newBlockBytes.readUnsignedInt();
                    var data    : ByteArray;
                        data = new ByteArray();

                    this._newBlockBytes.readBytes(data, 0, data_len);
                    this._pAddDependency(  this._cur_block_id.toString() + "#" + i , null, false, data , true);
                }
            }

            // Ignore for now
            this.parseProperties(null);
            this._blocks[blockID].extras = this.parseUserAttributes();
            this._pPauseAndRetrieveDependencies();
            this._blocks[blockID].data = asset;

            if (this._debug)
            {
                var textureStylesNames:Array = ["external", "embed"]
                Window.console.log("Start parsing 6 " + textureStylesNames[type] + " Bitmaps for CubeTexture");
            }
        }

        //Block ID = 91
        private function parseSharedMethodBlock(blockID:Number):void
        {
            var asset:EffectMethodBase;

            this._blocks[blockID].name = this.parseVarStr();
            asset = this.parseSharedMethodList(blockID);
            this.parseUserAttributes();
            this._blocks[blockID].data = asset;
            this._pFinalizeAsset( (asset as IAsset), this._blocks[blockID].name );
            this._blocks[blockID].data = asset;

            if (this._debug)
            {
                Window.console.log("Parsed a EffectMethod: Name = " + asset.name + " Type = " + asset);
            }
        }
        //Block ID = 92
        private function parseShadowMethodBlock(blockID:Number):void
        {
            var type            : Number;
            var data_len        : Number;
            var asset           : ShadowMapMethodBase;
            var shadowLightID   : Number;
            this._blocks[blockID].name = this.parseVarStr();

            shadowLightID = this._newBlockBytes.readUnsignedInt();
            var returnedArray:Array = this.getAssetByID(shadowLightID, new <String>[AssetType.LIGHT]);

            if (!returnedArray[0])
            {
                this._blocks[blockID].addError("Could not find the TargetLight (ID = " + shadowLightID + " ) for this ShadowMethod - ShadowMethod not created");
                return;
            }

            asset = this.parseShadowMethodList((returnedArray[1] as LightBase) , blockID );

            if (!asset)
                return;

            this.parseUserAttributes(); // Ignore for now
            this._pFinalizeAsset( (asset as IAsset), this._blocks[blockID].name );
            this._blocks[blockID].data = asset;

            if (this._debug)
            {
                Window.console.log("Parsed a ShadowMapMethodMethod: Name = " + asset.name + " | Type = " + asset + " | Light-Name = " , ( (returnedArray[1] as LightBase) ).name  );
            }
        }


        //Block ID = 253
        private function parseCommand(blockID:Number):void
        {
            var hasBlocks       : Boolean               = ( this._newBlockBytes.readUnsignedByte() == 1 );
            var par_id          : Number                = this._newBlockBytes.readUnsignedInt();
            var mtx             : Matrix3D    = this.parseMatrix3D();
            var name            : String                = this.parseVarStr();

            var parentObject    : ObjectContainer3D;
            var targetObject    : ObjectContainer3D;

            var returnedArray:Array = this.getAssetByID(par_id, new <String>[AssetType.CONTAINER, AssetType.LIGHT, AssetType.MESH, AssetType.ENTITY, AssetType.SEGMENT_SET]);

            if (returnedArray[0])
            {
                parentObject = (returnedArray[1] as ObjectContainer3D);
            }

            var numCommands     : Number = this._newBlockBytes.readShort();
            var typeCommand     : Number = this._newBlockBytes.readShort();

            var props           : AWDProperties = this.parseProperties({1:AWDParser.BADDR});

            switch (typeCommand)
            {
                case 1:

                    var targetID : Number = props.get(1, 0);
                    var returnedArrayTarget:Array = this.getAssetByID(targetID, new <String>[AssetType.LIGHT, AssetType.TEXTURE_PROJECTOR]); //for no only light is requested!!!!

                    if ((!returnedArrayTarget[0]) && (targetID != 0))
                    {
                        this._blocks[blockID].addError("Could not find the light (ID = " + targetID + " ( for this CommandBock!");
                        return;
                    }

                    targetObject = returnedArrayTarget[1];

                    if (parentObject)
                    {
                        parentObject.addChild(targetObject);
                    }

                    targetObject.transform = mtx;

                    break;
            }

            if (targetObject)
            {
                props = this.parseProperties({1:this._matrixNrType, 2:this._matrixNrType, 3:this._matrixNrType, 4:AWDParser.UINT8});

                targetObject.pivotPoint = new Vector3D(props.get(1, 0), props.get(2, 0), props.get(3, 0));
                targetObject.extra = this.parseUserAttributes();

            }
            this._blocks[blockID].data = targetObject

            if (this._debug)
            {
                Window.console.log("Parsed a CommandBlock: Name = '" + name);
            }

        }

        //blockID 255
        private function parseMetaData(blockID:Number):void
        {
            var props:AWDProperties = this.parseProperties({1:AWDParser.UINT32, 2:AWDParser.AWDSTRING, 3:AWDParser.AWDSTRING, 4:AWDParser.AWDSTRING, 5:AWDParser.AWDSTRING});

            if (this._debug)
            {
                Window.console.log("Parsed a MetaDataBlock: TimeStamp         = " + props.get(1, 0));
                Window.console.log("                        EncoderName       = " + props.get(2, "unknown"));
                Window.console.log("                        EncoderVersion    = " + props.get(3, "unknown"));
                Window.console.log("                        GeneratorName     = " + props.get(4, "unknown"));
                Window.console.log("                        GeneratorVersion  = " + props.get(5, "unknown"));
            }
        }
        //blockID 254
        private function parseNameSpace(blockID:Number):void
        {
            var id:Number               = this._newBlockBytes.readUnsignedByte();
            var nameSpaceString:String  = this.parseVarStr();
            if (this._debug)
                Window.console.log("Parsed a NameSpaceBlock: ID = " + id + " | String = " + nameSpaceString);
        }

        //--Parser UTILS---------------------------------------------------------------------------

        // this functions reads and creates a ShadowMethodMethod
        private function parseShadowMethodList(light:LightBase, blockID:Number):ShadowMapMethodBase
        {

            var methodType      : Number = this._newBlockBytes.readUnsignedShort();
            var shadowMethod    : ShadowMapMethodBase;
            var props           : AWDProperties = this.parseProperties({1:AWDParser.BADDR, 2:AWDParser.BADDR, 3:AWDParser.BADDR, 101:this._propsNrType, 102:this._propsNrType, 103:this._propsNrType, 201:AWDParser.UINT32, 202:AWDParser.UINT32, 301:AWDParser.UINT16, 302:AWDParser.UINT16, 401:AWDParser.UINT8, 402:AWDParser.UINT8, 601:AWDParser.COLOR, 602:AWDParser.COLOR, 701:AWDParser.BOOL, 702:AWDParser.BOOL, 801:AWDParser.MTX4x4});

            var targetID        : Number;
            var returnedArray   : Array
            switch (methodType)
            {
    //				case 1001: //CascadeShadowMapMethod
    //					targetID = props.get(1, 0);
    //					returnedArray = getAssetByID(targetID, [AssetType.SHADOW_MAP_METHOD]);
    //					if (!returnedArray[0]) {
    //						_blocks[blockID].addError("Could not find the ShadowBaseMethod (ID = " + targetID + " ) for this CascadeShadowMapMethod - ShadowMethod not created");
    //						return shadowMethod;
    //					}
    //					shadowMethod = new CascadeShadowMapMethod(returnedArray[1]);
    //					break;
    //				case 1002: //NearShadowMapMethod
    //					targetID = props.get(1, 0);
    //					returnedArray = getAssetByID(targetID, [AssetType.SHADOW_MAP_METHOD]);
    //					if (!returnedArray[0]) {
    //						_blocks[blockID].addError("Could not find the ShadowBaseMethod (ID = " + targetID + " ) for this NearShadowMapMethod - ShadowMethod not created");
    //						return shadowMethod;
    //					}
    //					shadowMethod = new NearShadowMapMethod(returnedArray[1]);
    //					break;
    //				case 1101: //FilteredShadowMapMethod
    //					shadowMethod = new FilteredShadowMapMethod(DirectionalLight(light));
    //					FilteredShadowMapMethod(shadowMethod).alpha = props.get(101, 1);
    //					FilteredShadowMapMethod(shadowMethod).epsilon = props.get(102, 0.002);
    //					break;
    //				case 1102: //DitheredShadowMapMethod
    //					shadowMethod = new DitheredShadowMapMethod(DirectionalLight(light), props.get(201, 5));
    //					DitheredShadowMapMethod(shadowMethod).alpha = props.get(101, 1);
    //					DitheredShadowMapMethod(shadowMethod).epsilon = props.get(102, 0.002);
    //					DitheredShadowMapMethod(shadowMethod).range = props.get(103, 1);
    //					break;
    //				case 1103: //SoftShadowMapMethod
    //					shadowMethod = new SoftShadowMapMethod(DirectionalLight(light), props.get(201, 5));
    //					SoftShadowMapMethod(shadowMethod).alpha = props.get(101, 1);
    //					SoftShadowMapMethod(shadowMethod).epsilon = props.get(102, 0.002);
    //					SoftShadowMapMethod(shadowMethod).range = props.get(103, 1);
    //					break;
    //				case 1104: //HardShadowMapMethod
    //					shadowMethod = new HardShadowMapMethod(light);
    //					HardShadowMapMethod(shadowMethod).alpha = props.get(101, 1);
    //					HardShadowMapMethod(shadowMethod).epsilon = props.get(102, 0.002);
    //					break;

            }
            this.parseUserAttributes();
            return shadowMethod;
        }

        // this functions reads and creates a EffectMethod
        private function parseSharedMethodList(blockID:Number):EffectMethodBase
        {

            var methodType          : Number = this._newBlockBytes.readUnsignedShort();
            var effectMethodReturn  : EffectMethodBase;

            var props               : AWDProperties = this.parseProperties({1:AWDParser.BADDR, 2:AWDParser.BADDR, 3:AWDParser.BADDR, 101:this._propsNrType, 102:this._propsNrType, 103:this._propsNrType, 104:this._propsNrType, 105:this._propsNrType, 106:this._propsNrType, 107:this._propsNrType, 201:AWDParser.UINT32, 202:AWDParser.UINT32, 301:AWDParser.UINT16, 302:AWDParser.UINT16, 401:AWDParser.UINT8, 402:AWDParser.UINT8, 601:AWDParser.COLOR, 602:AWDParser.COLOR, 701:AWDParser.BOOL, 702:AWDParser.BOOL});
            var targetID            : Number;
            var returnedArray       : Array;
            switch (methodType) {
                // Effect Methods
    //				case 401: //ColorMatrix
    //					effectMethodReturn = new ColorMatrixMethod(props.get(101, new Array(0, 0, 0, 1, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1)));
    //					break;
    //				case 402: //ColorTransform
    //					effectMethodReturn = new ColorTransformMethod();
    //					var offCol:uint = props.get(601, 0x00000000);
    //					var newColorTransform:ColorTransform = new ColorTransform(props.get(102, 1), props.get(103, 1), props.get(104, 1), props.get(101, 1), ((offCol >> 16) & 0xFF), ((offCol >> 8) & 0xFF), (offCol & 0xFF), ((offCol >> 24) & 0xFF));
    //					ColorTransformMethod(effectMethodReturn).colorTransform = newColorTransform;
    //					break;
    //				case 403: //EnvMap
    //					targetID = props.get(1, 0);
    //					returnedArray = getAssetByID(targetID, [AssetType.TEXTURE], "CubeTexture");
    //					if (!returnedArray[0])
    //						_blocks[blockID].addError("Could not find the EnvMap (ID = " + targetID + " ) for this EnvMapMethod");
    //					effectMethodReturn = new EnvMapMethod(returnedArray[1], props.get(101, 1));
    //					targetID = props.get(2, 0);
    //					if (targetID > 0) {
    //						returnedArray = getAssetByID(targetID, [AssetType.TEXTURE]);
    //						if (!returnedArray[0])
    //							_blocks[blockID].addError("Could not find the Mask-texture (ID = " + targetID + " ) for this EnvMapMethod");
    //						EnvMapMethod(effectMethodReturn).mask = returnedArray[1];
    //					}
    //					break;
    //				case 404: //LightMapMethod
    //					targetID = props.get(1, 0);
    //					returnedArray = getAssetByID(targetID, [AssetType.TEXTURE]);
    //					if (!returnedArray[0])
    //						_blocks[blockID].addError("Could not find the LightMap (ID = " + targetID + " ) for this LightMapMethod");
    //					effectMethodReturn = new LightMapMethod(returnedArray[1], blendModeDic[props.get(401, 10)]); //usesecondaryUV not set
    //					break;
    //				case 405: //ProjectiveTextureMethod
    //					targetID = props.get(1, 0);
    //					returnedArray = getAssetByID(targetID, [AssetType.TEXTURE_PROJECTOR]);
    //					if (!returnedArray[0])
    //						_blocks[blockID].addError("Could not find the TextureProjector (ID = " + targetID + " ) for this ProjectiveTextureMethod");
    //					effectMethodReturn = new ProjectiveTextureMethod(returnedArray[1], blendModeDic[props.get(401, 10)]);
    //					break;
    //				case 406: //RimLightMethod
    //					effectMethodReturn = new RimLightMethod(props.get(601, 0xffffff), props.get(101, 0.4), props.get(101, 2)); //blendMode
    //					break;
    //				case 407: //AlphaMaskMethod
    //					targetID = props.get(1, 0);
    //					returnedArray = getAssetByID(targetID, [AssetType.TEXTURE]);
    //					if (!returnedArray[0])
    //						_blocks[blockID].addError("Could not find the Alpha-texture (ID = " + targetID + " ) for this AlphaMaskMethod");
    //					effectMethodReturn = new AlphaMaskMethod(returnedArray[1], props.get(701, false));
    //					break;
    //				case 408: //RefractionEnvMapMethod
    //					targetID = props.get(1, 0);
    //					returnedArray = getAssetByID(targetID, [AssetType.TEXTURE], "CubeTexture");
    //					if (!returnedArray[0])
    //						_blocks[blockID].addError("Could not find the EnvMap (ID = " + targetID + " ) for this RefractionEnvMapMethod");
    //					effectMethodReturn = new RefractionEnvMapMethod(returnedArray[1], props.get(101, 0.1), props.get(102, 0.01), props.get(103, 0.01), props.get(104, 0.01));
    //					RefractionEnvMapMethod(effectMethodReturn).alpha = props.get(104, 1);
    //					break;
    //				case 409: //OutlineMethod
    //					effectMethodReturn = new OutlineMethod(props.get(601, 0x00000000), props.get(101, 1), props.get(701, true), props.get(702, false));
    //					break;
    //				case 410: //FresnelEnvMapMethod
    //					targetID = props.get(1, 0);
    //					returnedArray = getAssetByID(targetID, [AssetType.TEXTURE], "CubeTexture");
    //					if (!returnedArray[0])
    //						_blocks[blockID].addError("Could not find the EnvMap (ID = " + targetID + " ) for this FresnelEnvMapMethod");
    //					effectMethodReturn = new FresnelEnvMapMethod(returnedArray[1], props.get(101, 1));
    //					break;
    //				case 411: //FogMethod
    //					effectMethodReturn = new FogMethod(props.get(101, 0), props.get(102, 1000), props.get(601, 0x808080));
    //					break;

            }
            this.parseUserAttributes();
            return effectMethodReturn;

        }

        private function parseUserAttributes():Object
        {
            var attributes  :Object;
            var list_len    :Number;
            var attibuteCnt :Number;

            list_len = this._newBlockBytes.readUnsignedInt();

            if (list_len > 0)
            {

                var list_end:Number;

                attributes = {};

                list_end = this._newBlockBytes.position + list_len;

                while (this._newBlockBytes.position < list_end)
                {
                    var ns_id:Number;
                    var attr_key:String;
                    var attr_type:Number;
                    var attr_len:Number;
                    var attr_val:*;

                    // TODO: Properly tend to namespaces in attributes
                    ns_id       = this._newBlockBytes.readUnsignedByte();
                    attr_key    = this.parseVarStr();
                    attr_type   = this._newBlockBytes.readUnsignedByte();
                    attr_len    = this._newBlockBytes.readUnsignedInt();

                    if ((this._newBlockBytes.position + attr_len) > list_end)
                    {
                        Window.console.log("           Error in reading attribute # " + attibuteCnt + " = skipped to end of attribute-list");
                        this._newBlockBytes.position = list_end;
                        return attributes;
                    }

                    switch (attr_type)
                    {
                        case AWDParser.AWDSTRING:
                            attr_val = this._newBlockBytes.readUTFBytes(attr_len);
                            break;
                        case AWDParser.INT8:
                            attr_val = this._newBlockBytes.readByte();
                            break;
                        case AWDParser.INT16:
                            attr_val = this._newBlockBytes.readShort();
                            break;
                        case AWDParser.INT32:
                            attr_val = this._newBlockBytes.readInt();
                            break;
                        case AWDParser.BOOL:
                        case AWDParser.UINT8:
                            attr_val = this._newBlockBytes.readUnsignedByte();
                            break;
                        case AWDParser.UINT16:
                            attr_val = this._newBlockBytes.readUnsignedShort();
                            break;
                        case AWDParser.UINT32:
                        case AWDParser.BADDR:
                            attr_val = this._newBlockBytes.readUnsignedInt();
                            break;
                        case AWDParser.FLOAT32:
                            attr_val = this._newBlockBytes.readFloat();
                            break;
                        case AWDParser.FLOAT64:
                            attr_val = this._newBlockBytes.readDouble();
                            break;
                        default:
                            attr_val = 'unimplemented attribute type ' + attr_type;
                            this._newBlockBytes.position += attr_len;
                            break;
                    }

                    if (this._debug)
                    {
                        Window.console.log("attribute = name: " + attr_key + "  / value = " + attr_val);
                    }

                    attributes[attr_key] = attr_val;
                    attibuteCnt += 1;
                }
            }

            return attributes;
        }

        private function parseProperties(expected:Object):AWDProperties
        {
            var list_end:Number;
            var list_len:Number;
            var propertyCnt:Number= 0;
            var props:AWDProperties = new AWDProperties();

            list_len = this._newBlockBytes.readUnsignedInt();
            list_end = this._newBlockBytes.position + list_len;

            if (expected)
            {

                while (this._newBlockBytes.position < list_end)
                {
                    var len:Number;
                    var key:Number;
                    var type:Number;

                    key = this._newBlockBytes.readUnsignedShort();
                    len = this._newBlockBytes.readUnsignedInt();

                    if ((this._newBlockBytes.position + len) > list_end)
                    {
                        Window.console.log("           Error in reading property # " + propertyCnt + " = skipped to end of propertie-list");
                        this._newBlockBytes.position = list_end;
                        return props;
                    }

                    if (expected.hasOwnProperty(key.toString()))
                    {
                        type = expected[key];
                        props.set(key, this.parseAttrValue(type, len));
                    }
                    else
                    {
                        this._newBlockBytes.position += len;
                    }

                    propertyCnt += 1;

                }
            }
            else
            {
                this._newBlockBytes.position = list_end;
            }

            return props;

        }

        private function parseAttrValue(type:Number, len:Number):*
        {
            var elem_len:Number;
            var read_func:Function;

            switch (type)
            {

                case AWDParser.BOOL:
                case AWDParser.INT8:
                    elem_len = 1;
                    read_func = this._newBlockBytes.readByte;
                    break;

                case AWDParser.INT16:
                    elem_len = 2;
                    read_func = this._newBlockBytes.readShort;
                    break;

                case AWDParser.INT32:
                    elem_len = 4;
                    read_func = this._newBlockBytes.readInt;
                    break;

                case AWDParser.UINT8:
                    elem_len = 1;
                    read_func = this._newBlockBytes.readUnsignedByte;
                    break;

                case AWDParser.UINT16:
                    elem_len = 2;
                    read_func = this._newBlockBytes.readUnsignedShort;
                    break;

                case AWDParser.UINT32:
                case AWDParser.COLOR:
                case AWDParser.BADDR:
                    elem_len = 4;
                    read_func = this._newBlockBytes.readUnsignedInt;
                    break;

                case AWDParser.FLOAT32:
                    elem_len = 4;
                    read_func = this._newBlockBytes.readFloat;
                    break;

                case AWDParser.FLOAT64:
                    elem_len = 8;
                    read_func = this._newBlockBytes.readDouble;
                    break;

                case AWDParser.AWDSTRING:
                    return this._newBlockBytes.readUTFBytes(len);

                case AWDParser.VECTOR2x1:
                case AWDParser.VECTOR3x1:
                case AWDParser.VECTOR4x1:
                case AWDParser.MTX3x2:
                case AWDParser.MTX3x3:
                case AWDParser.MTX4x3:
                case AWDParser.MTX4x4:
                    elem_len = 8;
                    read_func = this._newBlockBytes.readDouble;
                    break;

            }

            if (elem_len < len)
            {
                var list      : Array   = [];
                var num_read  : Number       = 0;
                var num_elems : Number       = len/elem_len;

                while (num_read < num_elems)
                {
                    list.push( read_func.apply( this._newBlockBytes ) ); // list.push(read_func());
                    num_read++;
                }

                return list;
            }
            else
            {

                var val:* = read_func.apply( this._newBlockBytes );//read_func();
                return val;
            }
        }

        private function parseHeader():void
        {
            var flags       : Number;
            var body_len    : Number;

            this._byteData.position = 3; // Skip magic string and parse version

            this._version[0] = this._byteData.readUnsignedByte();
            this._version[1] = this._byteData.readUnsignedByte();

            flags = this._byteData.readUnsignedShort(); // Parse bit flags

            this._streaming = bitFlags.test(flags, bitFlags.FLAG1);

            if ((this._version[0] == 2) && (this._version[1] == 1))
            {
                this._accuracyMatrix = bitFlags.test(flags, bitFlags.FLAG2);
                this._accuracyGeo = bitFlags.test(flags, bitFlags.FLAG3);
                this._accuracyProps = bitFlags.test(flags, bitFlags.FLAG4);
            }

            // if we set _accuracyOnBlocks, the precision-values are read from each block-header.

            // set storagePrecision types
            this._geoNrType = AWDParser.FLOAT32;

            if (this._accuracyGeo)
            {
                this._geoNrType = AWDParser.FLOAT64;
            }

            this._matrixNrType = AWDParser.FLOAT32;

            if (this._accuracyMatrix)
            {
                this._matrixNrType = AWDParser.FLOAT64;
            }

            this._propsNrType = AWDParser.FLOAT32;

            if (this._accuracyProps)
            {
                this._propsNrType = AWDParser.FLOAT64;
            }

            this._compression = this._byteData.readUnsignedByte(); // compression

            if (this._debug)
            {
                Window.console.log("Import AWDFile of version = " + this._version[0] + " - " + this._version[1]);
                Window.console.log("Global Settings = Compression = " + this._compression + " | Streaming = " + this._streaming + " | Matrix-Precision = " + this._accuracyMatrix + " | Geometry-Precision = " + this._accuracyGeo + " | Properties-Precision = " + this._accuracyProps);
            }

            // Check file integrity
            body_len = this._byteData.readUnsignedInt();
            if (!this._streaming && body_len != this._byteData.getBytesAvailable() )
            {
                this._pDieWithError('AWD2 body length does not match header integrity field');
            }

        }

        private function parseVarStr():String
        {

            var len:Number = this._newBlockBytes.readUnsignedShort();
            return this._newBlockBytes.readUTFBytes(len);
        }

        private function getAssetByID(assetID:Number, assetTypesToGet:Vector.<String>, extraTypeInfo:String = "SingleTexture"):Array
        {
			extraTypeInfo = extraTypeInfo || "SingleTexture";

            var returnArray:Array = new Array();
            var typeCnt:Number = 0;
            if (assetID > 0)
            {
                if (this._blocks[assetID])
                {
                    if (this._blocks[assetID].data)
                    {
                        while (typeCnt < assetTypesToGet.length)
                        {

                            var iasset : IAsset = (this._blocks[assetID].data as IAsset);

                            if ( iasset.assetType == assetTypesToGet[typeCnt]) {
                                //if the right assetType was found
                                if ((assetTypesToGet[typeCnt] == AssetType.TEXTURE) && (extraTypeInfo == "CubeTexture"))
                                {
                                    if (this._blocks[assetID].data instanceof HTMLImageElementCubeTexture )
                                    {
                                        returnArray.push(true);
                                        returnArray.push(this._blocks[assetID].data);
                                        return returnArray;
                                    }
                                }
                                if ((assetTypesToGet[typeCnt] == AssetType.TEXTURE) && (extraTypeInfo == "SingleTexture"))
                                {
                                    if (this._blocks[assetID].data instanceof HTMLImageElementTexture )
                                    {
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
                            //if ((assetTypesToGet[typeCnt] == away.library.AssetType.GEOMETRY) && (IAsset(_blocks[assetID].data).assetType == AssetType.MESH)) {
                            if ((assetTypesToGet[typeCnt] == AssetType.GEOMETRY) && (iasset.assetType == AssetType.MESH))
                            {

                                var mesh : Mesh = Mesh(this._blocks[assetID].data)
                                returnArray.push(true);
                                returnArray.push( mesh.geometry );
                                return returnArray;

                            }

                            typeCnt++;
                        }
                    }
                }
            }
            // if the function has not returned anything yet, the asset is not found, or the found asset is not the right type.
            returnArray.push(false);
            returnArray.push(this.getDefaultAsset(assetTypesToGet[0], extraTypeInfo));
            return returnArray;
        }

        private function getDefaultAsset(assetType:String, extraTypeInfo:String):IAsset
        {
            switch (true)
            {

                case (assetType == AssetType.TEXTURE):

                    if (extraTypeInfo == "CubeTexture")
                        return this.getDefaultCubeTexture();
                    if (extraTypeInfo == "SingleTexture")
                        return this.getDefaultTexture();
                    break;

                case (assetType == AssetType.MATERIAL):

                    return this.getDefaultMaterial()
                    break;

                default:

                    break;
            }

            return null;

        }

        private function getDefaultMaterial():IAsset
        {
            if (!this._defaultBitmapMaterial)
                this._defaultBitmapMaterial = DefaultMaterialManager.getDefaultMaterial();
            return  (this._defaultBitmapMaterial as IAsset);
        }

        private function getDefaultTexture():IAsset
        {

            if (!this._defaultTexture)
            {
                this._defaultTexture = DefaultMaterialManager.getDefaultTexture();
            }

            return (this._defaultTexture as IAsset);

        }

        private function getDefaultCubeTexture():IAsset
        {
            if (!this._defaultCubeTexture)
            {

                var defaultBitmap:BitmapData = DefaultMaterialManager.createCheckeredBitmapData();//this._defaultTexture.bitmapData;

                this._defaultCubeTexture = new BitmapCubeTexture(defaultBitmap, defaultBitmap, defaultBitmap, defaultBitmap, defaultBitmap, defaultBitmap);
                this._defaultCubeTexture.name = "defaultTexture";
            }

            return (this._defaultCubeTexture as IAsset);
        }

        private function readNumber(precision:Boolean = false):Number
        {
			precision = precision || false;

            if (precision)
                return this._newBlockBytes.readDouble();
            return this._newBlockBytes.readFloat();

        }

        private function parseMatrix3D():Matrix3D
        {
            return new Matrix3D(this.parseMatrix43RawData());
        }

        private function parseMatrix32RawData():Vector.<Number>
        {
            var i:Number;
            var mtx_raw:Vector.<Number> = VectorInit.Num(6);
            for (i = 0; i < 6; i++)
            {
                mtx_raw[i] = this._newBlockBytes.readFloat();
            }

            return mtx_raw;
        }

        private function parseMatrix43RawData():Vector.<Number>
        {
            var mtx_raw:Vector.<Number> = VectorInit.Num(16);

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

            //TODO: fix max exporter to remove NaN values in joint 0 inverse bind pose

            if (isNaN(mtx_raw[0]))
            {
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
        }

    }

}



