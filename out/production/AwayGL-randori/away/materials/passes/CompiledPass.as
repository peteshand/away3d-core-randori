/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package away.materials.passes
{
	import away.utils.VectorInit;
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
	import away.core.base.IRenderable;
	import away.core.geom.Matrix3D;
	import away.core.display3D.Context3D;
	import away.core.geom.Matrix;
	import away.core.math.Matrix3DUtils;
	import away.materials.methods.MethodVOSet;
	import away.core.display3D.Context3DProgramType;
	import away.materials.LightSources;

    /**     * CompiledPass forms an abstract base class for the default compiled pass materials provided by Away3D,     * using material methods to define their appearance.     */
    public class CompiledPass extends MaterialPassBase
    {
        public var _iPasses:Vector.<MaterialPassBase>;//Vector.<MaterialPassBase>
        public var _iPassesDirty:Boolean = false;

        public var _pSpecularLightSources:Number = 0x01;
        public var _pDiffuseLightSources:Number = 0x03;

        private var _vertexCode:String = null;
        private var _fragmentLightCode:String = null;
        private var _framentPostLightCode:String = null;

        public var _pVertexConstantData:Vector.<Number> = VectorInit.Num();//Vector.<Number>()
        public var _pFragmentConstantData:Vector.<Number> = VectorInit.Num();//new Vector.<Number>()
        private var _commonsDataIndex:Number = 0;
        public var _pProbeWeightsIndex:Number = 0;
        private var _uvBufferIndex:Number = 0;
        private var _secondaryUVBufferIndex:Number = 0;
        private var _normalBufferIndex:Number = 0;
        private var _tangentBufferIndex:Number = 0;
        private var _sceneMatrixIndex:Number = 0;
        private var _sceneNormalMatrixIndex:Number = 0;
        public var _pLightFragmentConstantIndex:Number = 0;
        public var _pCameraPositionIndex:Number = 0;
        private var _uvTransformIndex:Number = 0;
        public var _pLightProbeDiffuseIndices:Vector.<Number>;/*uint*/
        public var _pLightProbeSpecularIndices:Vector.<Number>;/*uint*/

        public var _pAmbientLightR:Number = 0;
        public var _pAmbientLightG:Number = 0;
        public var _pAmbientLightB:Number = 0;

        public var _pCompiler:ShaderCompiler;

        public var _pMethodSetup:ShaderMethodSetup;

        private var _usingSpecularMethod:Boolean = false;
        private var _usesNormals:Boolean = false;
        public var _preserveAlpha:Boolean = true;
        private var _animateUVs:Boolean = false;

        public var _pNumPointLights:Number = 0;
        public var _pNumDirectionalLights:Number = 0;
        public var _pNumLightProbes:Number = 0;

        private var _enableLightFallOff:Boolean = true;

        private var _forceSeparateMVP:Boolean = false;

        /**         * Creates a new CompiledPass object.         * @param material The material to which this pass belongs.         */
            public function CompiledPass(material:MaterialBase):void
        {

            super(false);
            //away.Debug.throwPIR( "away.materials.CompiledaPass" , 'normalMethod' , 'implement dependency: BasicNormalMethod, BasicAmbientMethod, BasicDiffuseMethod, BasicSpecularMethod');

            this._pMaterial = material;

            this.init();
        }

        /**         * Whether or not to use fallOff and radius properties for lights. This can be used to improve performance and         * compatibility for constrained mode.         */
        public function get enableLightFallOff():Boolean
        {
            return this._enableLightFallOff;
        }

        public function set enableLightFallOff(value:Boolean):void
        {
            if (value != this._enableLightFallOff)
            {

                this.iInvalidateShaderProgram( true );//this.invalidateShaderProgram(true);

            }

            this._enableLightFallOff = value;

        }

        /**         * Indicates whether the screen projection should be calculated by forcing a separate scene matrix and         * view-projection matrix. This is used to prevent rounding errors when using multiple passes with different         * projection code.         */
        public function get forceSeparateMVP():Boolean
        {
            return this._forceSeparateMVP;
        }

        public function set forceSeparateMVP(value:Boolean):void
        {
            this._forceSeparateMVP = value;
        }

        /**         * The amount of point lights that need to be supported.         */
        public function get iNumPointLights():Number
        {
            return this._pNumPointLights;
        }

        /**         * The amount of directional lights that need to be supported.         */
        public function get iNumDirectionalLights():Number
        {
            return this._pNumDirectionalLights;
        }

        /**         * The amount of light probes that need to be supported.         */
        public function get iNumLightProbes():Number
        {
            return this._pNumLightProbes;
        }

        /**         * @inheritDoc         */
        override public function iUpdateProgram(stage3DProxy:Stage3DProxy):void
        {
            this.reset(stage3DProxy.profile);
            super.iUpdateProgram(stage3DProxy);
        }

        /**         * Resets the compilation state.         *         * @param profile The compatibility profile used by the renderer.         */
        private function reset(profile:String):void
        {
            this.iInitCompiler( profile);

            this.pUpdateShaderProperties();//this.updateShaderProperties();
            this.initConstantData();

            this.pCleanUp();//this.cleanUp();
        }

        /**         * Updates the amount of used register indices.         */
        private function updateUsedOffsets():void
        {
            this._pNumUsedVertexConstants= this._pCompiler.numUsedVertexConstants;
            this._pNumUsedFragmentConstants = this._pCompiler.numUsedFragmentConstants;
            this._pNumUsedStreams= this._pCompiler.numUsedStreams;
            this._pNumUsedTextures = this._pCompiler.numUsedTextures;
            this._pNumUsedVaryings = this._pCompiler.numUsedVaryings;
            this._pNumUsedFragmentConstants = this._pCompiler.numUsedFragmentConstants;
        }

        /**         * Initializes the unchanging constant data for this material.         */
        private function initConstantData():void
        {

            this._pVertexConstantData.length = this._pNumUsedVertexConstants*4;
            this._pFragmentConstantData.length = this._pNumUsedFragmentConstants*4;

            this.pInitCommonsData();//this.initCommonsData();

            if (this._uvTransformIndex >= 0)
            {

                this.pInitUVTransformData();//this.initUVTransformData();
            }

            if (this._pCameraPositionIndex >= 0)
            {

                this._pVertexConstantData[this._pCameraPositionIndex + 3] = 1;

            }

            this.pUpdateMethodConstants();//this.updateMethodConstants();

        }

        /**         * Initializes the compiler for this pass.         * @param profile The compatibility profile used by the renderer.         */
        public function iInitCompiler(profile:String):void
        {
            this._pCompiler = this.pCreateCompiler(profile);
            this._pCompiler.forceSeperateMVP = this._forceSeparateMVP;
            this._pCompiler.numPointLights = this._pNumPointLights;
            this._pCompiler.numDirectionalLights = this._pNumDirectionalLights;
            this._pCompiler.numLightProbes =this. _pNumLightProbes;
            this._pCompiler.methodSetup = this._pMethodSetup;
            this._pCompiler.diffuseLightSources = this._pDiffuseLightSources;
            this._pCompiler.specularLightSources = this._pSpecularLightSources;
            this._pCompiler.setTextureSampling(this._pSmooth, this._pRepeat, this._pMipmap);
            this._pCompiler.setConstantDataBuffers(this._pVertexConstantData, this._pFragmentConstantData);
            this._pCompiler.animateUVs = this._animateUVs;
            this._pCompiler.alphaPremultiplied = this._pAlphaPremultiplied && this._pEnableBlending;
            this._pCompiler.preserveAlpha = this._preserveAlpha && this._pEnableBlending;
            this._pCompiler.enableLightFallOff = this._enableLightFallOff;
            this._pCompiler.compile();
        }

        /**         * Factory method to create a concrete compiler object for this pass.         * @param profile The compatibility profile used by the renderer.         */
        public function pCreateCompiler(profile:String):ShaderCompiler
        {
            throw new AbstractMethodError();
        }

        /**         * Copies the shader's properties from the compiler.         */
        public function pUpdateShaderProperties():void
        {
            this._pAnimatableAttributes = this._pCompiler.animatableAttributes;
            this._pAnimationTargetRegisters = this._pCompiler.animationTargetRegisters;
            this._vertexCode = this._pCompiler.vertexCode;
            this._fragmentLightCode = this._pCompiler.fragmentLightCode;
            this._framentPostLightCode = this._pCompiler.fragmentPostLightCode;
            this._pShadedTarget = this._pCompiler.shadedTarget;
            this._usingSpecularMethod = this._pCompiler.usingSpecularMethod;
            this._usesNormals = this._pCompiler.usesNormals;
            this._pNeedUVAnimation = this._pCompiler.needUVAnimation;
            this._pUVSource = this._pCompiler.UVSource;
            this._pUVTarget = this._pCompiler.UVTarget;

            this.pUpdateRegisterIndices();
            this.updateUsedOffsets();
        }

        /**         * Updates the indices for various registers.         */
        public function pUpdateRegisterIndices():void
        {
            this._uvBufferIndex = this._pCompiler.uvBufferIndex;
            this._uvTransformIndex = this._pCompiler.uvTransformIndex;
            this._secondaryUVBufferIndex = this._pCompiler.secondaryUVBufferIndex;
            this._normalBufferIndex = this._pCompiler.normalBufferIndex;
            this._tangentBufferIndex = this._pCompiler.tangentBufferIndex;
            this._pLightFragmentConstantIndex = this._pCompiler.lightFragmentConstantIndex;
            this._pCameraPositionIndex = this._pCompiler.cameraPositionIndex;
            this._commonsDataIndex = this._pCompiler.commonsDataIndex;
            this._sceneMatrixIndex = this._pCompiler.sceneMatrixIndex;
            this._sceneNormalMatrixIndex = this._pCompiler.sceneNormalMatrixIndex;
            this._pProbeWeightsIndex = this._pCompiler.probeWeightsIndex;
            this._pLightProbeDiffuseIndices = this._pCompiler.lightProbeDiffuseIndices;
            this._pLightProbeSpecularIndices = this._pCompiler.lightProbeSpecularIndices;
        }

        /**         * Indicates whether the output alpha value should remain unchanged compared to the material's original alpha.         */
        public function get preserveAlpha():Boolean
        {
            return this._preserveAlpha;
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

        /**         * Indicate whether UV coordinates need to be animated using the renderable's transformUV matrix.         */
        public function get animateUVs():Boolean
        {
            return this._animateUVs;
        }

        public function set animateUVs(value:Boolean):void
        {
            this._animateUVs = value;

            if ((value && ! this._animateUVs) || (!value && this._animateUVs))
            {

                this.iInvalidateShaderProgram();

            }

        }

        /**         * @inheritDoc         */
        override public function set mipmap(value:Boolean):void
        {
            if (this._pMipmap == value)
                return;

            super.setMipMap( value ); //super.mipmap = value;
        }

        /**         * The normal map to modulate the direction of the surface for each texel. The default normal method expects         * tangent-space normal maps, but others could expect object-space maps.         */
        public function get normalMap():Texture2DBase
        {
            return this._pMethodSetup._iNormalMethod.normalMap;
        }

        public function set normalMap(value:Texture2DBase):void
        {

            this._pMethodSetup._iNormalMethod.normalMap = value;
        }

        /**         * The method used to generate the per-pixel normals. Defaults to BasicNormalMethod.         */

        public function get normalMethod():BasicNormalMethod
        {
            return this._pMethodSetup.normalMethod;
        }

        public function set normalMethod(value:BasicNormalMethod):void
        {
            this._pMethodSetup.normalMethod = value;
        }

        /**         * The method that provides the ambient lighting contribution. Defaults to BasicAmbientMethod.         */

        public function get ambientMethod():BasicAmbientMethod
        {
            return this._pMethodSetup.ambientMethod;
        }

        public function set ambientMethod(value:BasicAmbientMethod):void
        {
            this._pMethodSetup.ambientMethod = value;
        }

        /**         * The method used to render shadows cast on this surface, or null if no shadows are to be rendered. Defaults to null.         */

        public function get shadowMethod():ShadowMapMethodBase
        {
            return this._pMethodSetup.shadowMethod;
        }

        public function set shadowMethod(value:ShadowMapMethodBase):void
        {
            this._pMethodSetup.shadowMethod = value;
        }

        /**         * The method that provides the diffuse lighting contribution. Defaults to BasicDiffuseMethod.         */
        public function get diffuseMethod():BasicDiffuseMethod
        {
            return this._pMethodSetup.diffuseMethod;
        }

        public function set diffuseMethod(value:BasicDiffuseMethod):void
        {
            this._pMethodSetup.diffuseMethod = value;
        }

        /**         * The method that provides the specular lighting contribution. Defaults to BasicSpecularMethod.         */

        public function get specularMethod():BasicSpecularMethod
        {
            return this._pMethodSetup.specularMethod;
        }

        public function set specularMethod(value:BasicSpecularMethod):void
        {
            this._pMethodSetup.specularMethod = value;
        }

        /**         * Initializes the pass.         */
        private function init():void
        {
            this._pMethodSetup = new ShaderMethodSetup();

            this._pMethodSetup.addEventListener(ShadingMethodEvent.SHADER_INVALIDATED, onShaderInvalidated , this );
        }

        /**         * @inheritDoc         */
        override public function dispose():void
        {
            super.dispose();
            this._pMethodSetup.removeEventListener(ShadingMethodEvent.SHADER_INVALIDATED, onShaderInvalidated , this );
            this._pMethodSetup.dispose();
            this._pMethodSetup = null;
        }

        /**         * @inheritDoc         */
        override public function iInvalidateShaderProgram(updateMaterial:Boolean = true):void
        {
            var oldPasses : Vector.<MaterialPassBase> = this._iPasses;//:Vector.<MaterialPassBase> = _passes;
            this._iPasses = new Vector.<MaterialPassBase>();//= new Vector.<MaterialPassBase>();

            if (this._pMethodSetup)
            {

                this.pAddPassesFromMethods();//this.addPassesFromMethods();

            }


            if (!oldPasses || this._iPasses.length != oldPasses.length)
            {

                this._iPassesDirty = true;
                return;

            }

            for (var i:Number = 0; i < this._iPasses.length; ++i)
            {
                if (this._iPasses[i] != oldPasses[i]) {
                    this._iPassesDirty = true;
                    return;
                }
            }

            super.iInvalidateShaderProgram(updateMaterial);
        }

        /**         * Adds any possible passes needed by the used methods.         */
        public function pAddPassesFromMethods():void
        {

            if (this._pMethodSetup._iNormalMethod && this._pMethodSetup._iNormalMethod.iHasOutput)
                this.pAddPasses(this._pMethodSetup._iNormalMethod.passes);

            if (this._pMethodSetup._iAmbientMethod)
                this.pAddPasses(this._pMethodSetup._iAmbientMethod.passes);

            if (this._pMethodSetup._iShadowMethod)
                this.pAddPasses(this._pMethodSetup._iShadowMethod.passes);

            if (this._pMethodSetup._iDiffuseMethod)
                this.pAddPasses(this._pMethodSetup._iDiffuseMethod.passes);

            if (this._pMethodSetup._iSpecularMethod)
                this.pAddPasses(this._pMethodSetup._iSpecularMethod.passes);

        }

        /**         * Adds internal passes to the material.         *         * @param passes The passes to add.         */
        public function pAddPasses(passes:Vector.<MaterialPassBase>):void //Vector.<MaterialPassBase>)        {
            if (!passes)
            {

                return;

            }



            var len:Number = passes.length;

            for (var i:Number = 0; i < len; ++i)
            {

                passes[i].material = this.material;
                passes[i].lightPicker = this._pLightPicker;
                this._iPasses.push(passes[i]);

            }
        }

        /**         * Initializes the default UV transformation matrix.         */
        public function pInitUVTransformData():void
        {
            this._pVertexConstantData[this._uvTransformIndex] = 1;
            this._pVertexConstantData[this._uvTransformIndex + 1] = 0;
            this._pVertexConstantData[this._uvTransformIndex + 2] = 0;
            this._pVertexConstantData[this._uvTransformIndex + 3] = 0;
            this._pVertexConstantData[this._uvTransformIndex + 4] = 0;
            this._pVertexConstantData[this._uvTransformIndex + 5] = 1;
            this._pVertexConstantData[this._uvTransformIndex + 6] = 0;
            this._pVertexConstantData[this._uvTransformIndex + 7] = 0;
        }

        /**         * Initializes commonly required constant values.         */
        public function pInitCommonsData():void
        {
            this._pFragmentConstantData[this._commonsDataIndex] = .5;
            this._pFragmentConstantData[this._commonsDataIndex + 1] = 0;
            this._pFragmentConstantData[this._commonsDataIndex + 2] = 1/255;
            this._pFragmentConstantData[this._commonsDataIndex + 3] = 1;
        }

        /**         * Cleans up the after compiling.         */
        public function pCleanUp():void
        {
            this._pCompiler.dispose();
            this._pCompiler = null;

        }

        /**         * Updates method constants if they have changed.         */
        public function pUpdateMethodConstants():void
        {
            if (this._pMethodSetup._iNormalMethod)
                this._pMethodSetup._iNormalMethod.iInitConstants(this._pMethodSetup._iNormalMethodVO);

            if (this._pMethodSetup._iDiffuseMethod)
                this._pMethodSetup._iDiffuseMethod.iInitConstants(this._pMethodSetup._iDiffuseMethodVO);

            if (this._pMethodSetup._iAmbientMethod)
                this._pMethodSetup._iAmbientMethod.iInitConstants(this._pMethodSetup._iAmbientMethodVO);

            if (this._usingSpecularMethod)
                this._pMethodSetup._iSpecularMethod.iInitConstants(this._pMethodSetup._iSpecularMethodVO);

            if (this._pMethodSetup._iShadowMethod)
                this._pMethodSetup._iShadowMethod.iInitConstants(this._pMethodSetup._iShadowMethodVO);

        }

        /**         * Updates constant data render state used by the lights. This method is optional for subclasses to implement.         */
        public function pUpdateLightConstants():void
        {
            // up to subclasses to optionally implement
        }

        /**         * Updates constant data render state used by the light probes. This method is optional for subclasses to implement.         */
        public function pUpdateProbes(stage3DProxy:Stage3DProxy):void
        {

        }

        /**         * Called when any method's shader code is invalidated.         */
        private function onShaderInvalidated(event:ShadingMethodEvent):void
        {
            this.iInvalidateShaderProgram();//invalidateShaderProgram();
        }

        /**         * @inheritDoc         */
        override public function iGetVertexCode():String
        {
            return this._vertexCode;
        }

        /**         * @inheritDoc         */
        override public function iGetFragmentCode(animatorCode:String):String
        {
            //TODO: AGAL <> GLSL conversion
            return this._fragmentLightCode + animatorCode + this._framentPostLightCode;

        }

        // RENDER LOOP

        /**         * @inheritDoc         */
        override public function iActivate(stage3DProxy:Stage3DProxy, camera:Camera3D):void
        {
            super.iActivate(stage3DProxy, camera);

            if (this._usesNormals)
            {

                this._pMethodSetup._iNormalMethod.iActivate(this._pMethodSetup._iNormalMethodVO, stage3DProxy);

            }

            this._pMethodSetup._iAmbientMethod.iActivate(this._pMethodSetup._iAmbientMethodVO, stage3DProxy);

            if (this._pMethodSetup._iShadowMethod)
            {

                this._pMethodSetup._iShadowMethod.iActivate(this._pMethodSetup._iShadowMethodVO, stage3DProxy);

            }

            this._pMethodSetup._iDiffuseMethod.iActivate(this._pMethodSetup._iDiffuseMethodVO, stage3DProxy);

            if (this._usingSpecularMethod)
            {

                this._pMethodSetup._iSpecularMethod.iActivate(this._pMethodSetup._iSpecularMethodVO, stage3DProxy);

            }

        }

        /**         * @inheritDoc         */
        override public function iRender(renderable:IRenderable, stage3DProxy:Stage3DProxy, camera:Camera3D, viewProjection:Matrix3D):void
        {
            var i:Number;
            var context:Context3D = stage3DProxy._iContext3D;
            if (this._uvBufferIndex >= 0)
                renderable.activateUVBuffer(this._uvBufferIndex, stage3DProxy);

            if (this._secondaryUVBufferIndex >= 0)
                renderable.activateSecondaryUVBuffer(this._secondaryUVBufferIndex, stage3DProxy);

            if (this._normalBufferIndex >= 0)
                renderable.activateVertexNormalBuffer(this._normalBufferIndex, stage3DProxy);

            if (this._tangentBufferIndex >= 0)
                renderable.activateVertexTangentBuffer(this._tangentBufferIndex, stage3DProxy);


            if (this._animateUVs) {
                var uvTransform:Matrix = renderable.uvTransform;

                if (uvTransform)
                {
                    this._pVertexConstantData[this._uvTransformIndex] = uvTransform.a;
                    this._pVertexConstantData[this._uvTransformIndex + 1] = uvTransform.b;
                    this._pVertexConstantData[this._uvTransformIndex + 3] = uvTransform.tx;
                    this._pVertexConstantData[this._uvTransformIndex + 4] = uvTransform.c;
                    this._pVertexConstantData[this._uvTransformIndex + 5] = uvTransform.d;
                    this._pVertexConstantData[this._uvTransformIndex + 7] = uvTransform.ty;
                }
                else
                {
                    this._pVertexConstantData[this._uvTransformIndex] = 1;
                    this._pVertexConstantData[this._uvTransformIndex + 1] = 0;
                    this._pVertexConstantData[this._uvTransformIndex + 3] = 0;
                    this._pVertexConstantData[this._uvTransformIndex + 4] = 0;
                    this._pVertexConstantData[this._uvTransformIndex + 5] = 1;
                    this._pVertexConstantData[this._uvTransformIndex + 7] = 0;
                }
            }

            this._pAmbientLightB =  0;
            this._pAmbientLightG = this._pAmbientLightB
            this._pAmbientLightR = this._pAmbientLightG

            if (this.pUsesLights())
            {

                this.pUpdateLightConstants();//this.updateLightConstants();

            }

            if (this.pUsesProbes())
            {

                this.pUpdateProbes(stage3DProxy);//this.updateProbes(stage3DProxy);

            }


            if (this._sceneMatrixIndex >= 0)
            {

                renderable.getRenderSceneTransform(camera).copyRawDataTo( this._pVertexConstantData, this._sceneMatrixIndex, true);
                viewProjection.copyRawDataTo( this._pVertexConstantData, 0, true);

                //this._pVertexConstantData = renderable.getRenderSceneTransform(camera).copyRawDataTo( this._sceneMatrixIndex, true);
                //this._pVertexConstantData = viewProjection.copyRawDataTo( 0, true);


            }
            else
            {
                var matrix3D:Matrix3D = Matrix3DUtils.CALCULATION_MATRIX;

                matrix3D.copyFrom(renderable.getRenderSceneTransform(camera));
                matrix3D.append(viewProjection);

                matrix3D.copyRawDataTo( this._pVertexConstantData, 0, true);
                //this._pVertexConstantData = matrix3D.copyRawDataTo( 0, true);

            }

            if ( this._sceneNormalMatrixIndex >= 0){

                renderable.inverseSceneTransform.copyRawDataTo(this._pVertexConstantData, this._sceneNormalMatrixIndex, false);
                //this._pVertexConstantData = renderable.inverseSceneTransform.copyRawDataTo(this._sceneNormalMatrixIndex, false);

            }


            if (this._usesNormals)
            {

                this._pMethodSetup._iNormalMethod.iSetRenderState( this._pMethodSetup._iNormalMethodVO, renderable, stage3DProxy, camera);

            }

            //away.Debug.throwPIR( 'away.materials.CompiledPass' , 'iRender' , 'implement dependency: BasicAmbientMethod');

            var ambientMethod:BasicAmbientMethod = this._pMethodSetup._iAmbientMethod;
            ambientMethod._iLightAmbientR = this._pAmbientLightR;
            ambientMethod._iLightAmbientG = this._pAmbientLightG;
            ambientMethod._iLightAmbientB = this._pAmbientLightB;
            ambientMethod.iSetRenderState(this._pMethodSetup._iAmbientMethodVO, renderable, stage3DProxy, camera);


            if (this._pMethodSetup._iShadowMethod)
                this._pMethodSetup._iShadowMethod.iSetRenderState(this._pMethodSetup._iShadowMethodVO, renderable, stage3DProxy, camera);

            this._pMethodSetup._iDiffuseMethod.iSetRenderState(this._pMethodSetup._iDiffuseMethodVO, renderable, stage3DProxy, camera);


            if (this._usingSpecularMethod)
                this._pMethodSetup._iSpecularMethod.iSetRenderState(this._pMethodSetup._iSpecularMethodVO, renderable, stage3DProxy, camera);

            if (this._pMethodSetup._iColorTransformMethod)
                this._pMethodSetup._iColorTransformMethod.iSetRenderState(this._pMethodSetup._iColorTransformMethodVO, renderable, stage3DProxy, camera);


            //away.Debug.throwPIR( 'away.materials.CompiledPass' , 'iRender' , 'implement dependency: MethodVOSet');

            //Vector.<MethodVOSet>
            var methods: Vector.<MethodVOSet> = this._pMethodSetup._iMethods;
            var len:Number = methods.length;

            for (i = 0; i < len; ++i)
            {

                var aset:MethodVOSet = methods[i];

                aset.method.iSetRenderState(aset.data, renderable, stage3DProxy, camera);

            }

            context.setProgramConstantsFromArray(Context3DProgramType.VERTEX, 0, this._pVertexConstantData, this._pNumUsedVertexConstants);
            context.setProgramConstantsFromArray(Context3DProgramType.FRAGMENT, 0, this._pFragmentConstantData, this._pNumUsedFragmentConstants);

            renderable.activateVertexBuffer(0, stage3DProxy);
            context.drawTriangles(renderable.getIndexBuffer(stage3DProxy), 0, renderable.numTriangles);
        }

        /**         * Indicates whether the shader uses any light probes.         */
        public function pUsesProbes():Boolean
        {
            return this._pNumLightProbes > 0 && (( this._pDiffuseLightSources | this._pSpecularLightSources) & LightSources.PROBES) != 0;
        }

        /**         * Indicates whether the shader uses any lights.         */
        public function pUsesLights():Boolean
        {
            return ( this._pNumPointLights > 0 || this._pNumDirectionalLights > 0) && ((this._pDiffuseLightSources | this._pSpecularLightSources) & LightSources.LIGHTS) != 0;
        }

        /**         * @inheritDoc         */
        override public function iDeactivate(stage3DProxy:Stage3DProxy):void
        {
            super.iDeactivate(stage3DProxy);

            if (this._usesNormals)
            {

                this._pMethodSetup._iNormalMethod.iDeactivate(this._pMethodSetup._iNormalMethodVO, stage3DProxy);

            }

            this._pMethodSetup._iAmbientMethod.iDeactivate( this._pMethodSetup._iAmbientMethodVO, stage3DProxy);

            if ( this._pMethodSetup._iShadowMethod)
            {

                this._pMethodSetup._iShadowMethod.iDeactivate(this._pMethodSetup._iShadowMethodVO, stage3DProxy);

            }

            this._pMethodSetup._iDiffuseMethod.iDeactivate(this._pMethodSetup._iDiffuseMethodVO, stage3DProxy);

            if (this._usingSpecularMethod)
            {

                this._pMethodSetup._iSpecularMethod.iDeactivate(this._pMethodSetup._iSpecularMethodVO, stage3DProxy);

            }

        }

        /**         * Define which light source types to use for specular reflections. This allows choosing between regular lights         * and/or light probes for specular reflections.         *         * @see away3d.materials.LightSources         */
        public function get specularLightSources():Number
        {
            return this._pSpecularLightSources;
        }

        public function set specularLightSources(value:Number):void
        {
            this._pSpecularLightSources = value;
        }

        /**         * Define which light source types to use for diffuse reflections. This allows choosing between regular lights         * and/or light probes for diffuse reflections.         *         * @see away3d.materials.LightSources         */
        public function get diffuseLightSources():Number
        {
            return this._pDiffuseLightSources;
        }

        public function set diffuseLightSources(value:Number):void
        {
            this._pDiffuseLightSources = value;
        }

    }

}
// Fix for BOM issue
