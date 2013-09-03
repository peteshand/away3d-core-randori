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
    public class CompiledPass extends MaterialPassBase
    {
        public var _iPasses:Vector.<MaterialPassBase>;//Vector.<MaterialPassBase>;

        public var _pSpecularLightSources:Number = 0x01;
        public var _pDiffuseLightSources:Number = 0x03;

        private var _vertexCode:String;
        private var _fragmentLightCode:String;
        private var _framentPostLightCode:String;

        public var _pVertexConstantData:Vector.<Number> = new Vector.<Number>();//Vector.<Number>();
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
            public function CompiledPass(material:MaterialBase):void
        {

            super();
            //away.Debug.throwPIR( "away.materials.CompiledaPass" , 'normalMethod' , 'implement dependency: BasicNormalMethod, BasicAmbientMethod, BasicDiffuseMethod, BasicSpecularMethod');

            this._pMaterial = material;

            this.init();
        }

        /**
        public function get enableLightFallOff():Boolean
        {
            return _enableLightFallOff;
        }

        public function set enableLightFallOff(value:Boolean):void
        {
            if (value != this._enableLightFallOff)
            {

                this.iInvalidateShaderProgram( true );//this.invalidateShaderProgram(true);

            }

            this._enableLightFallOff = value;

        }

        /**
        public function get forceSeparateMVP():Boolean
        {
            return _forceSeparateMVP;
        }

        public function set forceSeparateMVP(value:Boolean):void
        {
            this._forceSeparateMVP = value;
        }

        /**
        public function get iNumPointLights():Number
        {
            return _pNumPointLights;
        }

        /**
        public function get iNumDirectionalLights():Number
        {
            return _pNumDirectionalLights;
        }

        /**
        public function get iNumLightProbes():Number
        {
            return _pNumLightProbes;
        }

        /**
        override public function iUpdateProgram(stage3DProxy:Stage3DProxy):void
        {
            reset(stage3DProxy.profile);
            super.iUpdateProgram(stage3DProxy);
        }

        /**
        private function reset(profile:String):void
        {
            iInitCompiler( profile);

            pUpdateShaderProperties();//this.updateShaderProperties();
            initConstantData();

            pCleanUp();//this.cleanUp();
        }

        /**
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
        public function pCreateCompiler(profile:String):ShaderCompiler
        {
            throw new AbstractMethodError();
        }

        /**
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
        public function get preserveAlpha():Boolean
        {
            return _preserveAlpha;
        }

        public function set preserveAlpha(value:Boolean):void
        {
            if (this._preserveAlpha == value)
            {

                return;

            }

            this._preserveAlpha = value;
            this.iInvalidateShaderProgram();//invalidateShaderProgram();

        }

        /**
        public function get animateUVs():Boolean
        {
            return _animateUVs;
        }

        public function set animateUVs(value:Boolean):void
        {
            this._animateUVs = value;

            if ((value && ! this._animateUVs) || (!value && this._animateUVs))
            {

                this.iInvalidateShaderProgram();

            }

        }

        /**
        override public function set mipmap(value:Boolean):void
        {
            if (this._pMipmap == value)
                return;

            super.setMipMap( value ); //super.mipmap = value;
        }

        /**
        public function get normalMap():Texture2DBase
        {
            return _pMethodSetup._iNormalMethod.normalMap;
        }

        public function set normalMap(value:Texture2DBase):void
        {

            this._pMethodSetup._iNormalMethod.normalMap = value;
        }

        /**

        public function get normalMethod():BasicNormalMethod
        {
            return _pMethodSetup.normalMethod;
        }

        public function set normalMethod(value:BasicNormalMethod):void
        {
            this._pMethodSetup.normalMethod = value;
        }

        /**

        public function get ambientMethod():BasicAmbientMethod
        {
            return _pMethodSetup.ambientMethod;
        }

        public function set ambientMethod(value:BasicAmbientMethod):void
        {
            this._pMethodSetup.ambientMethod = value;
        }

        /**

        public function get shadowMethod():ShadowMapMethodBase
        {
            return _pMethodSetup.shadowMethod;
        }

        public function set shadowMethod(value:ShadowMapMethodBase):void
        {
            this._pMethodSetup.shadowMethod = value;
        }

        /**
        public function get diffuseMethod():BasicDiffuseMethod
        {
            return _pMethodSetup.diffuseMethod;
        }

        public function set diffuseMethod(value:BasicDiffuseMethod):void
        {
            this._pMethodSetup.diffuseMethod = value;
        }

        /**

        public function get specularMethod():BasicSpecularMethod
        {
            return _pMethodSetup.specularMethod;
        }

        public function set specularMethod(value:BasicSpecularMethod):void
        {
            this._pMethodSetup.specularMethod = value;
        }

        /**
        private function init():void
        {
            _pMethodSetup = new ShaderMethodSetup();

            _pMethodSetup.addEventListener(ShadingMethodEvent.SHADER_INVALIDATED, onShaderInvalidated , this );
        }

        /**
        override public function dispose():void
        {
            super.dispose();
            _pMethodSetup.removeEventListener(ShadingMethodEvent.SHADER_INVALIDATED, onShaderInvalidated , this );
            _pMethodSetup.dispose();
            _pMethodSetup = null;
        }

        /**
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
        public function pAddPasses(passes:Vector.<MaterialPassBase>):void //Vector.<MaterialPassBase>)
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
        public function pInitCommonsData():void
        {
            _pFragmentConstantData[_commonsDataIndex] = .5;
            _pFragmentConstantData[_commonsDataIndex + 1] = 0;
            _pFragmentConstantData[_commonsDataIndex + 2] = 1/255;
            _pFragmentConstantData[_commonsDataIndex + 3] = 1;
        }

        /**
        public function pCleanUp():void
        {
            _pCompiler.dispose();
            _pCompiler = null;

        }

        /**
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
        public function pUpdateLightConstants():void
        {
            // up to subclasses to optionally implement
        }

        /**
        public function pUpdateProbes(stage3DProxy:Stage3DProxy):void
        {

        }

        /**
        private function onShaderInvalidated(event:ShadingMethodEvent):void
        {
            iInvalidateShaderProgram();//invalidateShaderProgram();
        }

        /**
        override public function iGetVertexCode():String
        {
            return _vertexCode;
        }

        /**
        override public function iGetFragmentCode(animatorCode:String):String
        {
            //TODO: AGAL <> GLSL conversion
            return _fragmentLightCode + animatorCode + _framentPostLightCode;

        }

        // RENDER LOOP

        /**
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
        public function pUsesProbes():Boolean
        {
            return _pNumLightProbes > 0 && (( _pDiffuseLightSources | _pSpecularLightSources) & LightSources.PROBES) != 0;
        }

        /**
        public function pUsesLights():Boolean
        {
            return ( _pNumPointLights > 0 || _pNumDirectionalLights > 0) && ((_pDiffuseLightSources | _pSpecularLightSources) & LightSources.LIGHTS) != 0;
        }

        /**
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
        public function get specularLightSources():Number
        {
            return _pSpecularLightSources;
        }

        public function set specularLightSources(value:Number):void
        {
            this._pSpecularLightSources = value;
        }

        /**
        public function get diffuseLightSources():Number
        {
            return _pDiffuseLightSources;
        }

        public function set diffuseLightSources(value:Number):void
        {
            this._pDiffuseLightSources = value;
        }

    }

}
// Fix for BOM issue