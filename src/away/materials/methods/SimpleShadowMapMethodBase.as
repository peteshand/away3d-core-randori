/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package away.materials.methods
{
	import away.materials.compilation.ShaderRegisterElement;
	import away.lights.LightBase;
	import away.lights.PointLight;
	import away.materials.compilation.ShaderRegisterCache;
	import away.errors.AbstractMethodError;
	import away.core.base.IRenderable;
	import away.managers.Stage3DProxy;
	import away.cameras.Camera3D;
	import away.lights.shadowmaps.DirectionalShadowMapper;
	import away.core.geom.Vector3D;
    /**     * SimpleShadowMapMethodBase provides an abstract method for simple (non-wrapping) shadow map methods.     */
    public class SimpleShadowMapMethodBase extends ShadowMapMethodBase
    {
        public var _pDepthMapCoordReg:ShaderRegisterElement;
        public var _pUsePoint:Boolean = false;

        /**         * Creates a new SimpleShadowMapMethodBase object.         * @param castingLight The light used to cast shadows.         */
        public function SimpleShadowMapMethodBase(castingLight:LightBase):void
        {
            this._pUsePoint = (castingLight instanceof PointLight);
            super(castingLight);
        }

        /**         * @inheritDoc         */
        override public function iInitVO(vo:MethodVO):void
        {
            vo.needsView = true;
            vo.needsGlobalVertexPos = true;
            vo.needsGlobalFragmentPos = this._pUsePoint;
            vo.needsNormals = vo.numLights > 0;
        }

        /**         * @inheritDoc         */
        override public function iInitConstants(vo:MethodVO):void
        {
            var fragmentData:Vector.<Number> = vo.fragmentData;
            var vertexData:Vector.<Number> = vo.vertexData;
            var index:Number /*int*/ = vo.fragmentConstantsIndex;
            fragmentData[index] = 1.0;
            fragmentData[index + 1] = 1/255.0;
            fragmentData[index + 2] = 1/65025.0;
            fragmentData[index + 3] = 1/16581375.0;

            fragmentData[index + 6] = 0;
            fragmentData[index + 7] = 1;

            if (this._pUsePoint) {
                fragmentData[index + 8] = 0;
                fragmentData[index + 9] = 0;
                fragmentData[index + 10] = 0;
                fragmentData[index + 11] = 1;
            }

            index = vo.vertexConstantsIndex;
            if (index != -1) {
                vertexData[index] = .5;
                vertexData[index + 1] = -.5;
                vertexData[index + 2] = 0.0;
                vertexData[index + 3] = 1.0;
            }
        }

        /**         * Wrappers that override the vertex shader need to set this explicitly         */
        public function get _iDepthMapCoordReg():ShaderRegisterElement
        {
            return this._pDepthMapCoordReg;
        }

        public function set _iDepthMapCoordReg(value:ShaderRegisterElement):void
        {
            this._pDepthMapCoordReg = value;
        }

        /**         * @inheritDoc         */
        override public function iCleanCompilationData():void
        {
            super.iCleanCompilationData();

            this._pDepthMapCoordReg = null;
        }

        /**         * @inheritDoc         */
        override public function iGetVertexCode(vo:MethodVO, regCache:ShaderRegisterCache):String
        {
            return this._pUsePoint? this._pGetPointVertexCode(vo, regCache) : this.pGetPlanarVertexCode(vo, regCache);
        }

        /**         * Gets the vertex code for shadow mapping with a point light.         *         * @param vo The MethodVO object linking this method with the pass currently being compiled.         * @param regCache The register cache used during the compilation.         */
        public function _pGetPointVertexCode(vo:MethodVO, regCache:ShaderRegisterCache):String
        {
            vo.vertexConstantsIndex = -1;
            return "";
        }

        /**         * Gets the vertex code for shadow mapping with a planar shadow map (fe: directional lights).         *         * @param vo The MethodVO object linking this method with the pass currently being compiled.         * @param regCache The register cache used during the compilation.         */
        public function pGetPlanarVertexCode(vo:MethodVO, regCache:ShaderRegisterCache):String
        {
            var code:String = "";
            var temp:ShaderRegisterElement = regCache.getFreeVertexVectorTemp();
            var dataReg:ShaderRegisterElement = regCache.getFreeVertexConstant();
            var depthMapProj:ShaderRegisterElement = regCache.getFreeVertexConstant();
            regCache.getFreeVertexConstant();
            regCache.getFreeVertexConstant();
            regCache.getFreeVertexConstant();
            this._pDepthMapCoordReg = regCache.getFreeVarying();
            vo.vertexConstantsIndex = dataReg.index*4;

            // todo: can epsilon be applied here instead of fragment shader?

            code += "m44 " + temp + ", " + this._sharedRegisters.globalPositionVertex + ", " + depthMapProj + "\n" +
                "div " + temp + ", " + temp + ", " + temp + ".w\n" +
                "mul " + temp + ".xy, " + temp + ".xy, " + dataReg + ".xy\n" +
                "add " + this._pDepthMapCoordReg + ", " + temp + ", " + dataReg + ".xxwz\n";

            return code;
        }

        /**         * @inheritDoc         */
        override public function iGetFragmentCode(vo:MethodVO, regCache:ShaderRegisterCache, targetReg:ShaderRegisterElement):String
        {
            var code:String = this._pUsePoint? this._pGetPointFragmentCode(vo, regCache, targetReg) : this._pGetPlanarFragmentCode(vo, regCache, targetReg);
            code += "add " + targetReg + ".w, " + targetReg + ".w, fc" + (vo.fragmentConstantsIndex/4 + 1) + ".y\n" +
                "sat " + targetReg + ".w, " + targetReg + ".w\n";
            return code;
        }

        /**         * Gets the fragment code for shadow mapping with a planar shadow map.         * @param vo The MethodVO object linking this method with the pass currently being compiled.         * @param regCache The register cache used during the compilation.         * @param targetReg The register to contain the shadow coverage         * @return         */
        public function _pGetPlanarFragmentCode(vo:MethodVO, regCache:ShaderRegisterCache, targetReg:ShaderRegisterElement):String
        {
            throw new AbstractMethodError();
            return "";
        }

        /**         * Gets the fragment code for shadow mapping with a point light.         * @param vo The MethodVO object linking this method with the pass currently being compiled.         * @param regCache The register cache used during the compilation.         * @param targetReg The register to contain the shadow coverage         * @return         */
        public function _pGetPointFragmentCode(vo:MethodVO, regCache:ShaderRegisterCache, targetReg:ShaderRegisterElement):String
        {
            throw new AbstractMethodError();
            return "";
        }

        /**         * @inheritDoc         */
        override public function iSetRenderState(vo:MethodVO, renderable:IRenderable, stage3DProxy:Stage3DProxy, camera:Camera3D):void
        {
            if (!this._pUsePoint)
                ((this._pShadowMapper as DirectionalShadowMapper)).iDepthProjection.copyRawDataTo(vo.vertexData , vo.vertexConstantsIndex + 4 , true );
        }

        /**         * Gets the fragment code for combining this method with a cascaded shadow map method.         * @param vo The MethodVO object linking this method with the pass currently being compiled.         * @param regCache The register cache used during the compilation.         * @param decodeRegister The register containing the data to decode the shadow map depth value.         * @param depthTexture The texture containing the shadow map.         * @param depthProjection The projection of the fragment relative to the light.         * @param targetRegister The register to contain the shadow coverage         * @return         */
        public function _iGetCascadeFragmentCode(vo:MethodVO, regCache:ShaderRegisterCache, decodeRegister:ShaderRegisterElement, depthTexture:ShaderRegisterElement, depthProjection:ShaderRegisterElement, targetRegister:ShaderRegisterElement):String
        {
            throw new Error("This shadow method is incompatible with cascade shadows");
        }

        /**         * @inheritDoc         */
        override public function iActivate(vo:MethodVO, stage3DProxy:Stage3DProxy):void
        {
            var fragmentData:Vector.<Number> = vo.fragmentData;
            var index:Number /*int*/ = vo.fragmentConstantsIndex;

            if (this._pUsePoint)
                fragmentData[index + 4] = -Math.pow(1/(((this._pCastingLight as PointLight)).fallOff*this._pEpsilon ) , 2 );
            else
                vo.vertexData[vo.vertexConstantsIndex + 3] = -1/(((this._pShadowMapper as DirectionalShadowMapper)).depth*this._pEpsilon );

            fragmentData[index + 5] = 1 - this._pAlpha;
            if (this._pUsePoint) {
                var pos:Vector3D = this._pCastingLight.scenePosition;
                fragmentData[index + 8] = pos.x;
                fragmentData[index + 9] = pos.y;
                fragmentData[index + 10] = pos.z;
                // used to decompress distance
                var f:Number = ((this._pCastingLight as PointLight)).fallOff;
                fragmentData[index + 11] = 1/(2*f*f);
            }
            stage3DProxy._iContext3D.setTextureAt(vo.texturesIndex, this._pCastingLight.shadowMapper.depthMap.getTextureForStage3D(stage3DProxy));
        }

        /**         * Sets the method state for cascade shadow mapping.         */
        public function iActivateForCascade(vo:MethodVO, stage3DProxy:Stage3DProxy):void
        {
            throw new Error("This shadow method is incompatible with cascade shadows");
        }
    }
}
