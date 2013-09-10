///<reference path="../../_definitions.ts"/>
package away.materials.passes
{
	import away.materials.compilation.ShaderCompiler;
	import away.materials.methods.ShaderMethodSetup;
	import away.materials.MaterialBase;
	import away.managers.Stage3DProxy;
	import away.errors.AbstractMethodError;
	import away.textures.Texture2DBase;
	import away.materials.methods.BasicNormalMethod;
	import away.materials.methods.BasicAmbientMethod;
	import away.materials.methods.ShadowMapMethodBase;
	import away.materials.methods.BasicDiffuseMethod;
	import away.materials.methods.BasicSpecularMethod;
	import away.events.ShadingMethodEvent;
	import away.cameras.Camera3D;
	import away.base.IRenderable;
	import away.geom.Matrix3D;
	import away.display3D.Context3D;
	import away.geom.Matrix;
	import away.math.Matrix3DUtils;
	import away.materials.methods.MethodVOSet;
	import away.display3D.Context3DProgramType;
	import away.materials.LightSources;

    /**
     * CompiledPass forms an abstract base class for the default compiled pass materials provided by Away3D,
     * using material methods to define their appearance.
     */
    public class CompiledPass extends MaterialPassBase
    {
        public var _iPasses:Vector.<MaterialPassBase>;//Vector.<MaterialPassBase>;
        public var _iPassesDirty:Boolean;

        public var _pSpecularLightSources:Number = 0x01;
        public var _pDiffuseLightSources:Number = 0x03;

        private var _vertexCode:String;
        private var _fragmentLightCode:String;
        private var _framentPostLightCode:String;

        public var _pVertexConstantData:Vector.<Number> = new Vector.<Number>();//Vector.<Number>();
        public var _pFragmentConstantData:Vector.<Number> = new Vector.<Number>();//new Vector.<Number>();
        private var _commonsDataIndex:Number;
        public var _pProbeWeightsIndex:Number;
        private var _uvBufferIndex:Number;
        private var _secondaryUVBufferIndex:Number;
        private var _normalBufferIndex:Number;
        private var _tangentBufferIndex:Number;
        private var _sceneMatrixIndex:Number;
        private var _sceneNormalMatrixIndex:Number;
        public var _pLightFragmentConstantIndex:Number;
        public var _pCameraPositionIndex:Number;
        private var _uvTransformIndex:Number;
        public var _pLightProbeDiffuseIndices:Vector.<Number>/*uint*/;
        public var _pLightProbeSpecularIndices:Vector.<Number>/*uint*/;

        public var _pAmbientLightR:Number;
        public var _pAmbientLightG:Number;
        public var _pAmbientLightB:Number;

        public var _pCompiler:ShaderCompiler;

        public var _pMethodSetup:ShaderMethodSetup;

        private var _usingSpecularMethod:Boolean;
        private var _usesNormals:Boolean;
        public var _preserveAlpha:Boolean = true;
        private var _animateUVs:Boolean = false;

        public var _pNumPointLights:Number;
        public var _pNumDirectionalLights:Number;
        public var _pNumLightProbes:Number;

        private var _enableLightFallOff:Boolean = true;

        private var _forceSeparateMVP:Boolean = false;

        /**
         * Creates a new CompiledPass object.
         * @param material The material to which this pass belongs.
         */
            public function CompiledPass(material:MaterialBase):void
        {

            super();
            //away.Debug.throwPIR( "away.materials.CompiledaPass" , 'normalMethod' , 'implement dependency: BasicNormalMethod, BasicAmbientMethod, BasicDiffuseMethod, BasicSpecularMethod');

            _pMaterial = material;

            init();
        }

        /**
         * Whether or not to use fallOff and radius properties for lights. This can be used to improve performance and
         * compatibility for constrained mode.
         */
        public function get enableLightFallOff():Boolean
        {
            return _enableLightFallOff;
        }

        public function set enableLightFallOff(value:Boolean):void
        {
            if (value != _enableLightFallOff)
            {

                iInvalidateShaderProgram( true );//this.invalidateShaderProgram(true);

            }

            _enableLightFallOff = value;

        }

        /**
         * Indicates whether the screen projection should be calculated by forcing a separate scene matrix and
         * view-projection matrix. This is used to prevent rounding errors when using multiple passes with different
         * projection code.
         */
        public function get forceSeparateMVP():Boolean
        {
            return _forceSeparateMVP;
        }

        public function set forceSeparateMVP(value:Boolean):void
        {
            _forceSeparateMVP = value;
        }

        /**
         * The amount of point lights that need to be supported.
         */
        public function get iNumPointLights():Number
        {
            return _pNumPointLights;
        }

        /**
         * The amount of directional lights that need to be supported.
         */
        public function get iNumDirectionalLights():Number
        {
            return _pNumDirectionalLights;
        }

        /**
         * The amount of light probes that need to be supported.
         */
        public function get iNumLightProbes():Number
        {
            return _pNumLightProbes;
        }

        /**
         * @inheritDoc
         */
        override public function iUpdateProgram(stage3DProxy:Stage3DProxy):void
        {
            reset(stage3DProxy.profile);
            super.iUpdateProgram(stage3DProxy);
        }

        /**
         * Resets the compilation state.
         *
         * @param profile The compatibility profile used by the renderer.
         */
        private function reset(profile:String):void
        {
            iInitCompiler( profile);

            pUpdateShaderProperties();//this.updateShaderProperties();
            initConstantData();

            pCleanUp();//this.cleanUp();
        }

        /**
         * Updates the amount of used register indices.
         */
        private function updateUsedOffsets():void
        {
            _pNumUsedVertexConstants= _pCompiler.numUsedVertexConstants;
            _pNumUsedFragmentConstants = _pCompiler.numUsedFragmentConstants;
            _pNumUsedStreams= _pCompiler.numUsedStreams;
            _pNumUsedTextures = _pCompiler.numUsedTextures;
            _pNumUsedVaryings = _pCompiler.numUsedVaryings;
            _pNumUsedFragmentConstants = _pCompiler.numUsedFragmentConstants;
        }

        /**
         * Initializes the unchanging constant data for this material.
         */
        private function initConstantData():void
        {

            _pVertexConstantData.length = _pNumUsedVertexConstants*4;
            _pFragmentConstantData.length = _pNumUsedFragmentConstants*4;

            pInitCommonsData();//this.initCommonsData();

            if (_uvTransformIndex >= 0)
            {

                pInitUVTransformData();//this.initUVTransformData();
            }

            if (_pCameraPositionIndex >= 0)
            {

                _pVertexConstantData[_pCameraPositionIndex + 3] = 1;

            }

            pUpdateMethodConstants();//this.updateMethodConstants();

        }

        /**
         * Initializes the compiler for this pass.
         * @param profile The compatibility profile used by the renderer.
         */
        public function iInitCompiler(profile:String):void
        {
            _pCompiler = pCreateCompiler(profile);
            _pCompiler.forceSeperateMVP = _forceSeparateMVP;
            _pCompiler.numPointLights = _pNumPointLights;
            _pCompiler.numDirectionalLights = _pNumDirectionalLights;
            _pCompiler.numLightProbes =this. _pNumLightProbes;
            _pCompiler.methodSetup = _pMethodSetup;
            _pCompiler.diffuseLightSources = _pDiffuseLightSources;
            _pCompiler.specularLightSources = _pSpecularLightSources;
            _pCompiler.setTextureSampling(_pSmooth, _pRepeat, _pMipmap);
            _pCompiler.setConstantDataBuffers(_pVertexConstantData, _pFragmentConstantData);
            _pCompiler.animateUVs = _animateUVs;
            _pCompiler.alphaPremultiplied = _pAlphaPremultiplied && _pEnableBlending;
            _pCompiler.preserveAlpha = _preserveAlpha && _pEnableBlending;
            _pCompiler.enableLightFallOff = _enableLightFallOff;
            _pCompiler.compile();
        }

        /**
         * Factory method to create a concrete compiler object for this pass.
         * @param profile The compatibility profile used by the renderer.
         */
        public function pCreateCompiler(profile:String):ShaderCompiler
        {
            throw new AbstractMethodError();
        }

        /**
         * Copies the shader's properties from the compiler.
         */
        public function pUpdateShaderProperties():void
        {
            _pAnimatableAttributes = _pCompiler.animatableAttributes;
            _pAnimationTargetRegisters = _pCompiler.animationTargetRegisters;
            _vertexCode = _pCompiler.vertexCode;
            _fragmentLightCode = _pCompiler.fragmentLightCode;
            _framentPostLightCode = _pCompiler.fragmentPostLightCode;
            _pShadedTarget = _pCompiler.shadedTarget;
            _usingSpecularMethod = _pCompiler.usingSpecularMethod;
            _usesNormals = _pCompiler.usesNormals;
            _pNeedUVAnimation = _pCompiler.needUVAnimation;
            _pUVSource = _pCompiler.UVSource;
            _pUVTarget = _pCompiler.UVTarget;

            pUpdateRegisterIndices();
            updateUsedOffsets();
        }

        /**
         * Updates the indices for various registers.
         */
        public function pUpdateRegisterIndices():void
        {
            _uvBufferIndex = _pCompiler.uvBufferIndex;
            _uvTransformIndex = _pCompiler.uvTransformIndex;
            _secondaryUVBufferIndex = _pCompiler.secondaryUVBufferIndex;
            _normalBufferIndex = _pCompiler.normalBufferIndex;
            _tangentBufferIndex = _pCompiler.tangentBufferIndex;
            _pLightFragmentConstantIndex = _pCompiler.lightFragmentConstantIndex;
            _pCameraPositionIndex = _pCompiler.cameraPositionIndex;
            _commonsDataIndex = _pCompiler.commonsDataIndex;
            _sceneMatrixIndex = _pCompiler.sceneMatrixIndex;
            _sceneNormalMatrixIndex = _pCompiler.sceneNormalMatrixIndex;
            _pProbeWeightsIndex = _pCompiler.probeWeightsIndex;
            _pLightProbeDiffuseIndices = _pCompiler.lightProbeDiffuseIndices;
            _pLightProbeSpecularIndices = _pCompiler.lightProbeSpecularIndices;
        }

        /**
         * Indicates whether the output alpha value should remain unchanged compared to the material's original alpha.
         */
        public function get preserveAlpha():Boolean
        {
            return _preserveAlpha;
        }

        public function set preserveAlpha(value:Boolean):void
        {
            if (_preserveAlpha == value)
            {

                return;

            }

            _preserveAlpha = value;
            iInvalidateShaderProgram();//invalidateShaderProgram();

        }

        /**
         * Indicate whether UV coordinates need to be animated using the renderable's transformUV matrix.
         */
        public function get animateUVs():Boolean
        {
            return _animateUVs;
        }

        public function set animateUVs(value:Boolean):void
        {
            _animateUVs = value;

            if ((value && ! _animateUVs) || (!value && _animateUVs))
            {

                iInvalidateShaderProgram();

            }

        }

        /**
         * @inheritDoc
         */
        override public function set mipmap(value:Boolean):void
        {
            if (_pMipmap == value)
                return;

            super.setMipMap( value ); //super.mipmap = value;
        }

        /**
         * The normal map to modulate the direction of the surface for each texel. The default normal method expects
         * tangent-space normal maps, but others could expect object-space maps.
         */
        public function get normalMap():Texture2DBase
        {
            return _pMethodSetup._iNormalMethod.normalMap;
        }

        public function set normalMap(value:Texture2DBase):void
        {

            _pMethodSetup._iNormalMethod.normalMap = value;
        }

        /**
         * The method used to generate the per-pixel normals. Defaults to BasicNormalMethod.
         */

        public function get normalMethod():BasicNormalMethod
        {
            return _pMethodSetup.normalMethod;
        }

        public function set normalMethod(value:BasicNormalMethod):void
        {
            _pMethodSetup.normalMethod = value;
        }

        /**
         * The method that provides the ambient lighting contribution. Defaults to BasicAmbientMethod.
         */

        public function get ambientMethod():BasicAmbientMethod
        {
            return _pMethodSetup.ambientMethod;
        }

        public function set ambientMethod(value:BasicAmbientMethod):void
        {
            _pMethodSetup.ambientMethod = value;
        }

        /**
         * The method used to render shadows cast on this surface, or null if no shadows are to be rendered. Defaults to null.
         */

        public function get shadowMethod():ShadowMapMethodBase
        {
            return _pMethodSetup.shadowMethod;
        }

        public function set shadowMethod(value:ShadowMapMethodBase):void
        {
            _pMethodSetup.shadowMethod = value;
        }

        /**
         * The method that provides the diffuse lighting contribution. Defaults to BasicDiffuseMethod.
         */
        public function get diffuseMethod():BasicDiffuseMethod
        {
            return _pMethodSetup.diffuseMethod;
        }

        public function set diffuseMethod(value:BasicDiffuseMethod):void
        {
            _pMethodSetup.diffuseMethod = value;
        }

        /**
         * The method that provides the specular lighting contribution. Defaults to BasicSpecularMethod.
         */

        public function get specularMethod():BasicSpecularMethod
        {
            return _pMethodSetup.specularMethod;
        }

        public function set specularMethod(value:BasicSpecularMethod):void
        {
            _pMethodSetup.specularMethod = value;
        }

        /**
         * Initializes the pass.
         */
        private function init():void
        {
            _pMethodSetup = new ShaderMethodSetup();

            _pMethodSetup.addEventListener(ShadingMethodEvent.SHADER_INVALIDATED, onShaderInvalidated , this );
        }

        /**
         * @inheritDoc
         */
        override public function dispose():void
        {
            super.dispose();
            _pMethodSetup.removeEventListener(ShadingMethodEvent.SHADER_INVALIDATED, onShaderInvalidated , this );
            _pMethodSetup.dispose();
            _pMethodSetup = null;
        }

        /**
         * @inheritDoc
         */
        override public function iInvalidateShaderProgram(updateMaterial:Boolean = true):void
        {
            var oldPasses : Vector.<MaterialPassBase> = _iPasses;//:Vector.<MaterialPassBase> = _passes;
            _iPasses = new Vector.<MaterialPassBase>();//= new Vector.<MaterialPassBase>();

            if (_pMethodSetup)
            {

                pAddPassesFromMethods();//this.addPassesFromMethods();

            }


            if (!oldPasses || _iPasses.length != oldPasses.length)
            {

                _iPassesDirty = true;
                return;

            }

            for (var i:Number = 0; i < _iPasses.length; ++i)
            {
                if (_iPasses[i] != oldPasses[i]) {
                    _iPassesDirty = true;
                    return;
                }
            }

            super.iInvalidateShaderProgram(updateMaterial);
        }

        /**
         * Adds any possible passes needed by the used methods.
         */
        public function pAddPassesFromMethods():void
        {

            if (_pMethodSetup._iNormalMethod && _pMethodSetup._iNormalMethod.iHasOutput)
                pAddPasses(_pMethodSetup._iNormalMethod.passes);

            if (_pMethodSetup._iAmbientMethod)
                pAddPasses(_pMethodSetup._iAmbientMethod.passes);

            if (_pMethodSetup._iShadowMethod)
                pAddPasses(_pMethodSetup._iShadowMethod.passes);

            if (_pMethodSetup._iDiffuseMethod)
                pAddPasses(_pMethodSetup._iDiffuseMethod.passes);

            if (_pMethodSetup._iSpecularMethod)
                pAddPasses(_pMethodSetup._iSpecularMethod.passes);

        }

        /**
         * Adds internal passes to the material.
         *
         * @param passes The passes to add.
         */
        public function pAddPasses(passes:Vector.<MaterialPassBase>):void //Vector.<MaterialPassBase>)
        {
            if (!passes)
            {

                return;

            }



            var len:Number = passes.length;

            for (var i:Number = 0; i < len; ++i)
            {

                passes[i].material = material;
                passes[i].lightPicker = _pLightPicker;
                _iPasses.push(passes[i]);

            }
        }

        /**
         * Initializes the default UV transformation matrix.
         */
        public function pInitUVTransformData():void
        {
            _pVertexConstantData[_uvTransformIndex] = 1;
            _pVertexConstantData[_uvTransformIndex + 1] = 0;
            _pVertexConstantData[_uvTransformIndex + 2] = 0;
            _pVertexConstantData[_uvTransformIndex + 3] = 0;
            _pVertexConstantData[_uvTransformIndex + 4] = 0;
            _pVertexConstantData[_uvTransformIndex + 5] = 1;
            _pVertexConstantData[_uvTransformIndex + 6] = 0;
            _pVertexConstantData[_uvTransformIndex + 7] = 0;
        }

        /**
         * Initializes commonly required constant values.
         */
        public function pInitCommonsData():void
        {
            _pFragmentConstantData[_commonsDataIndex] = .5;
            _pFragmentConstantData[_commonsDataIndex + 1] = 0;
            _pFragmentConstantData[_commonsDataIndex + 2] = 1/255;
            _pFragmentConstantData[_commonsDataIndex + 3] = 1;
        }

        /**
         * Cleans up the after compiling.
         */
        public function pCleanUp():void
        {
            _pCompiler.dispose();
            _pCompiler = null;

        }

        /**
         * Updates method constants if they have changed.
         */
        public function pUpdateMethodConstants():void
        {
            if (_pMethodSetup._iNormalMethod)
                _pMethodSetup._iNormalMethod.iInitConstants(_pMethodSetup._iNormalMethodVO);

            if (_pMethodSetup._iDiffuseMethod)
                _pMethodSetup._iDiffuseMethod.iInitConstants(_pMethodSetup._iDiffuseMethodVO);

            if (_pMethodSetup._iAmbientMethod)
                _pMethodSetup._iAmbientMethod.iInitConstants(_pMethodSetup._iAmbientMethodVO);

            if (_usingSpecularMethod)
                _pMethodSetup._iSpecularMethod.iInitConstants(_pMethodSetup._iSpecularMethodVO);

            if (_pMethodSetup._iShadowMethod)
                _pMethodSetup._iShadowMethod.iInitConstants(_pMethodSetup._iShadowMethodVO);

        }

        /**
         * Updates constant data render state used by the lights. This method is optional for subclasses to implement.
         */
        public function pUpdateLightConstants():void
        {
            // up to subclasses to optionally implement
        }

        /**
         * Updates constant data render state used by the light probes. This method is optional for subclasses to implement.
         */
        public function pUpdateProbes(stage3DProxy:Stage3DProxy):void
        {

        }

        /**
         * Called when any method's shader code is invalidated.
         */
        private function onShaderInvalidated(event:ShadingMethodEvent):void
        {
            iInvalidateShaderProgram();//invalidateShaderProgram();
        }

        /**
         * @inheritDoc
         */
        override public function iGetVertexCode():String
        {
            return _vertexCode;
        }

        /**
         * @inheritDoc
         */
        override public function iGetFragmentCode(animatorCode:String):String
        {
            //TODO: AGAL <> GLSL conversion
            return _fragmentLightCode + animatorCode + _framentPostLightCode;

        }

        // RENDER LOOP

        /**
         * @inheritDoc
         */
        override public function iActivate(stage3DProxy:Stage3DProxy, camera:Camera3D):void
        {
            super.iActivate(stage3DProxy, camera);

            if (_usesNormals)
            {

                _pMethodSetup._iNormalMethod.iActivate(_pMethodSetup._iNormalMethodVO, stage3DProxy);

            }

            _pMethodSetup._iAmbientMethod.iActivate(_pMethodSetup._iAmbientMethodVO, stage3DProxy);

            if (_pMethodSetup._iShadowMethod)
            {

                _pMethodSetup._iShadowMethod.iActivate(_pMethodSetup._iShadowMethodVO, stage3DProxy);

            }

            _pMethodSetup._iDiffuseMethod.iActivate(_pMethodSetup._iDiffuseMethodVO, stage3DProxy);

            if (_usingSpecularMethod)
            {

                _pMethodSetup._iSpecularMethod.iActivate(_pMethodSetup._iSpecularMethodVO, stage3DProxy);

            }

        }

        /**
         * @inheritDoc
         */
        override public function iRender(renderable:IRenderable, stage3DProxy:Stage3DProxy, camera:Camera3D, viewProjection:Matrix3D):void
        {
            var i:Number;
            var context:Context3D = stage3DProxy._iContext3D;
            if (_uvBufferIndex >= 0)
                renderable.activateUVBuffer(_uvBufferIndex, stage3DProxy);

            if (_secondaryUVBufferIndex >= 0)
                renderable.activateSecondaryUVBuffer(_secondaryUVBufferIndex, stage3DProxy);

            if (_normalBufferIndex >= 0)
                renderable.activateVertexNormalBuffer(_normalBufferIndex, stage3DProxy);

            if (_tangentBufferIndex >= 0)
                renderable.activateVertexTangentBuffer(_tangentBufferIndex, stage3DProxy);


            if (_animateUVs) {
                var uvTransform:Matrix = renderable.uvTransform;

                if (uvTransform)
                {
                    _pVertexConstantData[_uvTransformIndex] = uvTransform.a;
                    _pVertexConstantData[_uvTransformIndex + 1] = uvTransform.b;
                    _pVertexConstantData[_uvTransformIndex + 3] = uvTransform.tx;
                    _pVertexConstantData[_uvTransformIndex + 4] = uvTransform.c;
                    _pVertexConstantData[_uvTransformIndex + 5] = uvTransform.d;
                    _pVertexConstantData[_uvTransformIndex + 7] = uvTransform.ty;
                }
                else
                {
                    _pVertexConstantData[_uvTransformIndex] = 1;
                    _pVertexConstantData[_uvTransformIndex + 1] = 0;
                    _pVertexConstantData[_uvTransformIndex + 3] = 0;
                    _pVertexConstantData[_uvTransformIndex + 4] = 0;
                    _pVertexConstantData[_uvTransformIndex + 5] = 1;
                    _pVertexConstantData[_uvTransformIndex + 7] = 0;
                }
            }

            _pAmbientLightR = _pAmbientLightG = _pAmbientLightB = 0;

            if (pUsesLights())
            {

                pUpdateLightConstants();//this.updateLightConstants();

            }

            if (pUsesProbes())
            {

                pUpdateProbes(stage3DProxy);//this.updateProbes(stage3DProxy);

            }


            if (_sceneMatrixIndex >= 0)
            {

                renderable.getRenderSceneTransform(camera).copyRawDataTo( _pVertexConstantData, _sceneMatrixIndex, true);
                viewProjection.copyRawDataTo( _pVertexConstantData, 0, true);

                //this._pVertexConstantData = renderable.getRenderSceneTransform(camera).copyRawDataTo( this._sceneMatrixIndex, true);
                //this._pVertexConstantData = viewProjection.copyRawDataTo( 0, true);


            }
            else
            {
                var matrix3D:Matrix3D = Matrix3DUtils.CALCULATION_MATRIX;

                matrix3D.copyFrom(renderable.getRenderSceneTransform(camera));
                matrix3D.append(viewProjection);

                matrix3D.copyRawDataTo( _pVertexConstantData, 0, true);
                //this._pVertexConstantData = matrix3D.copyRawDataTo( 0, true);

            }

            if ( _sceneNormalMatrixIndex >= 0){

                renderable.inverseSceneTransform.copyRawDataTo(_pVertexConstantData, _sceneNormalMatrixIndex, false);
                //this._pVertexConstantData = renderable.inverseSceneTransform.copyRawDataTo(this._sceneNormalMatrixIndex, false);

            }


            if (_usesNormals)
            {

                _pMethodSetup._iNormalMethod.iSetRenderState( _pMethodSetup._iNormalMethodVO, renderable, stage3DProxy, camera);

            }

            //away.Debug.throwPIR( 'away.materials.CompiledPass' , 'iRender' , 'implement dependency: BasicAmbientMethod');

            var ambientMethod:BasicAmbientMethod = _pMethodSetup._iAmbientMethod;
            ambientMethod._iLightAmbientR = _pAmbientLightR;
            ambientMethod._iLightAmbientG = _pAmbientLightG;
            ambientMethod._iLightAmbientB = _pAmbientLightB;
            ambientMethod.iSetRenderState(_pMethodSetup._iAmbientMethodVO, renderable, stage3DProxy, camera);


            if (_pMethodSetup._iShadowMethod)
                _pMethodSetup._iShadowMethod.iSetRenderState(_pMethodSetup._iShadowMethodVO, renderable, stage3DProxy, camera);

            _pMethodSetup._iDiffuseMethod.iSetRenderState(_pMethodSetup._iDiffuseMethodVO, renderable, stage3DProxy, camera);


            if (_usingSpecularMethod)
                _pMethodSetup._iSpecularMethod.iSetRenderState(_pMethodSetup._iSpecularMethodVO, renderable, stage3DProxy, camera);

            if (_pMethodSetup._iColorTransformMethod)
                _pMethodSetup._iColorTransformMethod.iSetRenderState(_pMethodSetup._iColorTransformMethodVO, renderable, stage3DProxy, camera);


            //away.Debug.throwPIR( 'away.materials.CompiledPass' , 'iRender' , 'implement dependency: MethodVOSet');

            //Vector.<MethodVOSet>
            var methods: Vector.<MethodVOSet> = _pMethodSetup._iMethods;
            var len:Number = methods.length;

            for (i = 0; i < len; ++i)
            {

                var aset:MethodVOSet = methods[i];

                aset.method.iSetRenderState(aset.data, renderable, stage3DProxy, camera);

            }

            context.setProgramConstantsFromArray(Context3DProgramType.VERTEX, 0, _pVertexConstantData, _pNumUsedVertexConstants);
            context.setProgramConstantsFromArray(Context3DProgramType.FRAGMENT, 0, _pFragmentConstantData, _pNumUsedFragmentConstants);

            renderable.activateVertexBuffer(0, stage3DProxy);
            context.drawTriangles(renderable.getIndexBuffer(stage3DProxy), 0, renderable.numTriangles);
        }

        /**
         * Indicates whether the shader uses any light probes.
         */
        public function pUsesProbes():Boolean
        {
            return _pNumLightProbes > 0 && (( _pDiffuseLightSources | _pSpecularLightSources) & LightSources.PROBES) != 0;
        }

        /**
         * Indicates whether the shader uses any lights.
         */
        public function pUsesLights():Boolean
        {
            return ( _pNumPointLights > 0 || _pNumDirectionalLights > 0) && ((_pDiffuseLightSources | _pSpecularLightSources) & LightSources.LIGHTS) != 0;
        }

        /**
         * @inheritDoc
         */
        override public function iDeactivate(stage3DProxy:Stage3DProxy):void
        {
            super.iDeactivate(stage3DProxy);

            if (_usesNormals)
            {

                _pMethodSetup._iNormalMethod.iDeactivate(_pMethodSetup._iNormalMethodVO, stage3DProxy);

            }

            _pMethodSetup._iAmbientMethod.iDeactivate( _pMethodSetup._iAmbientMethodVO, stage3DProxy);

            if ( _pMethodSetup._iShadowMethod)
            {

                _pMethodSetup._iShadowMethod.iDeactivate(_pMethodSetup._iShadowMethodVO, stage3DProxy);

            }

            _pMethodSetup._iDiffuseMethod.iDeactivate(_pMethodSetup._iDiffuseMethodVO, stage3DProxy);

            if (_usingSpecularMethod)
            {

                _pMethodSetup._iSpecularMethod.iDeactivate(_pMethodSetup._iSpecularMethodVO, stage3DProxy);

            }

        }

        /**
         * Define which light source types to use for specular reflections. This allows choosing between regular lights
         * and/or light probes for specular reflections.
         *
         * @see away3d.materials.LightSources
         */
        public function get specularLightSources():Number
        {
            return _pSpecularLightSources;
        }

        public function set specularLightSources(value:Number):void
        {
            _pSpecularLightSources = value;
        }

        /**
         * Define which light source types to use for diffuse reflections. This allows choosing between regular lights
         * and/or light probes for diffuse reflections.
         *
         * @see away3d.materials.LightSources
         */
        public function get diffuseLightSources():Number
        {
            return _pDiffuseLightSources;
        }

        public function set diffuseLightSources(value:Number):void
        {
            _pDiffuseLightSources = value;
        }

    }

}
// Fix for BOM issue
