

///<reference path="../_definitions.ts"/>

package away.materials
{
	import away.library.assets.NamedAssetBase;
	import away.library.assets.IAsset;
	import away.animators.IAnimationSet;
	import away.base.IMaterialOwner;
	import away.display.BlendMode;
	import away.materials.passes.MaterialPassBase;
	import away.materials.passes.DepthMapPass;
	import away.materials.passes.DistanceMapPass;
	import away.materials.lightpickers.LightPickerBase;
	import away.display3D.Context3DCompareMode;
	import away.events.Event;
	import away.library.assets.AssetType;
	import away.managers.Stage3DProxy;
	import away.cameras.Camera3D;
	import away.base.IRenderable;
	import away.geom.Matrix3D;
	import away.traverse.EntityCollector;
	import away.display3D.Context3D;

    /**     * MaterialBase forms an abstract base class for any material.     * A material consists of several passes, each of which constitutes at least one render call. Several passes could     * be used for special effects (render lighting for many lights in several passes, render an outline in a separate     * pass) or to provide additional render-to-texture passes (rendering diffuse light to texture for texture-space     * subsurface scattering, or rendering a depth map for specialized self-shadowing).     *     * Away3D provides default materials trough SinglePassMaterialBase and MultiPassMaterialBase, which use modular     * methods to build the shader code. MaterialBase can be extended to build specific and high-performant custom     * shaders, or entire new material frameworks.     */
    public class MaterialBase extends NamedAssetBase implements IAsset
    {
        /**         * A counter used to assign unique ids per material, which is used to sort per material while rendering.         * This reduces state changes.         */
        private static var MATERIAL_ID_COUNT:Number = 0;

        /**         * An object to contain any extra data.         */
        public var extra:Object;

        /**         * A value that can be used by materials that only work with a given type of renderer. The renderer can test the         * classification to choose which render path to use. For example, a deferred material could set this value so         * that the deferred renderer knows not to take the forward rendering path.         *         * @private         */
        public var _iClassification:String//Arcane
        /**         * An id for this material used to sort the renderables by material, which reduces render state changes across         * materials using the same Program3D.         *         * @private         */
        public var _iUniqueId:Number//Arcane
        /**         * An id for this material used to sort the renderables by shader program, which reduces Program3D state changes.         *         * @private         */
        public var _iRenderOrderId:Number//Arcane = 0

        /**         * The same as _renderOrderId, but applied to the depth shader passes.         *         * @private         */
        public var _iDepthPassId:Number//Arcane
        private var _bothSides:Boolean// update = false
        private var _animationSet:IAnimationSet;

        /**         * A list of material owners, renderables or custom Entities.         */


        private var _owners:Vector.<IMaterialOwner>//:Vector.<IMaterialOwner>;
        private var _alphaPremultiplied:Boolean;

        public var _pBlendMode:String = BlendMode.NORMAL;

        private var _numPasses:Number = 0;
        private var _passes:Vector.<MaterialPassBase>//Vector.<MaterialPassBase>;
        public var _pMipmap:Boolean = true;
        private var _smooth:Boolean = true;
        private var _repeat:Boolean// Update = false

        public var _pDepthPass:DepthMapPass;
        public var _pDistancePass:DistanceMapPass;
        public var _pLightPicker:LightPickerBase;

        private var _distanceBasedDepthRender:Boolean;
        public var _pDepthCompareMode:String = Context3DCompareMode.LESS_EQUAL;

        /**         * Creates a new MaterialBase object.         */
            public function MaterialBase():void
        {

            super(null);

            this._owners = new Vector.< IMaterialOwner>();
            this._passes = new Vector.<MaterialPassBase>();
            this._pDepthPass= new DepthMapPass();
            this._pDistancePass = new DistanceMapPass();

            this._pDepthPass.addEventListener(Event.CHANGE, onDepthPassChange, this );
            this._pDistancePass.addEventListener(Event.CHANGE, onDistancePassChange , this);

            this.alphaPremultiplied= true;

            this._iUniqueId = MaterialBase.MATERIAL_ID_COUNT++;

        }

        /**         * @inheritDoc         */
        override public function get assetType():String
        {
            return AssetType.MATERIAL;
        }

        /**         * The light picker used by the material to provide lights to the material if it supports lighting.         *         * @see away3d.materials.lightpickers.LightPickerBase         * @see away3d.materials.lightpickers.StaticLightPicker         */
        public function get lightPicker():LightPickerBase
        {
            return this._pLightPicker;
        }

        public function set lightPicker(value:LightPickerBase):void
        {

            this.setLightPicker( value );

        }

        public function setLightPicker(value:LightPickerBase):void
        {

            if (value != this._pLightPicker)
            {

                this._pLightPicker = value;
                var len:Number = this._passes.length;

                for (var i:Number = 0; i < len; ++i)
                {

                    this._passes[i].lightPicker = this._pLightPicker;

                }

            }

        }

        /**         * Indicates whether or not any used textures should use mipmapping. Defaults to true.         */
        public function get mipmap():Boolean
        {
            return this._pMipmap;
        }

        public function set mipmap(value:Boolean):void
        {

            this.setMipMap( value );

        }

        public function setMipMap(value:Boolean):void
        {

            this._pMipmap = value;

            for (var i:Number = 0; i < this._numPasses; ++i)
            {

                this._passes[i].mipmap = value;

            }

        }

        /**         * Indicates whether or not any used textures should use smoothing.         */
        public function get smooth():Boolean
        {
            return this._smooth;
        }

        public function set smooth(value:Boolean):void
        {
            this._smooth = value;

            for (var i:Number = 0; i < this._numPasses; ++i)
            {

                this._passes[i].smooth = value;

            }


        }

        /**         * The depth compare mode used to render the renderables using this material.         *         * @see flash.display3D.Context3DCompareMode         */

        public function get depthCompareMode():String
        {
            return this._pDepthCompareMode;
        }

        public function set depthCompareMode(value:String):void
        {
            this.setDepthCompareMode( value );
        }

        public function setDepthCompareMode(value:String):void
        {
            this._pDepthCompareMode = value;
        }

        /**         * Indicates whether or not any used textures should be tiled. If set to false, texture samples are clamped to         * the texture's borders when the uv coordinates are outside the [0, 1] interval.         */
        public function get repeat():Boolean
        {
            return this._repeat;
        }

        public function set repeat(value:Boolean):void
        {
            this._repeat = value;


            for (var i:Number = 0; i < this._numPasses; ++i)
            {

                this._passes[i].repeat = value;

            }

        }

        /**         * Cleans up resources owned by the material, including passes. Textures are not owned by the material since they         * could be used by other materials and will not be disposed.         */
        override public function dispose():void
        {
            var i:Number;

            for (i = 0; i < this._numPasses; ++i)
            {
                this._passes[i].dispose();
            }

            this._pDepthPass.dispose();
            this._pDistancePass.dispose();

            this._pDepthPass.removeEventListener(Event.CHANGE, onDepthPassChange , this );
            this._pDistancePass.removeEventListener(Event.CHANGE, onDistancePassChange , this );

        }

        /**         * Defines whether or not the material should cull triangles facing away from the camera.         */
        public function get bothSides():Boolean
        {
            return this._bothSides;
        }

        public function set bothSides(value:Boolean):void
        {
            this._bothSides = value;


            for (var i:Number = 0; i < this._numPasses; ++i)
            {

                this._passes[i].bothSides = value;

            }

            this._pDepthPass.bothSides = value;
            this._pDistancePass.bothSides = value;

        }

        /**         * The blend mode to use when drawing this renderable. The following blend modes are supported:         * <ul>         * <li>BlendMode.NORMAL: No blending, unless the material inherently needs it</li>         * <li>BlendMode.LAYER: Force blending. This will draw the object the same as NORMAL, but without writing depth writes.</li>         * <li>BlendMode.MULTIPLY</li>         * <li>BlendMode.ADD</li>         * <li>BlendMode.ALPHA</li>         * </ul>         */
        public function get blendMode():String
        {
            return this.getBlendMode();
        }

        public function getBlendMode():String
        {
            return this._pBlendMode;
        }

        public function set blendMode(value:String):void
        {
            this.setBlendMode( value );
        }

        public function setBlendMode(value:String):void
        {

            this._pBlendMode = value;

        }

        /**         * Indicates whether visible textures (or other pixels) used by this material have         * already been premultiplied. Toggle this if you are seeing black halos around your         * blended alpha edges.         */
        public function get alphaPremultiplied():Boolean
        {
            return this._alphaPremultiplied;
        }

        public function set alphaPremultiplied(value:Boolean):void
        {
            this._alphaPremultiplied = value;

            for (var i:Number = 0; i < this._numPasses; ++i)
            {
                this._passes[i].alphaPremultiplied = value;
            }

        }

        /**         * Indicates whether or not the material requires alpha blending during rendering.         */
        public function get requiresBlending():Boolean
        {

            return this.getRequiresBlending();

        }

        public function getRequiresBlending():Boolean
        {

            return this._pBlendMode != BlendMode.NORMAL;

        }

        /**         * An id for this material used to sort the renderables by material, which reduces render state changes across         * materials using the same Program3D.         */
        public function get uniqueId():Number
        {
            return this._iUniqueId;
        }

        /**         * The amount of passes used by the material.         *         * @private         */
        public function get _iNumPasses():Number // ARCANE        {
            return this._numPasses;
        }

        /**         * Indicates that the depth pass uses transparency testing to discard pixels.         *         * @private         */

        public function iHasDepthAlphaThreshold():Boolean
        {

            return this._pDepthPass.alphaThreshold > 0;

        }

        /**         * Sets the render state for the depth pass that is independent of the rendered object. Used when rendering         * depth or distances (fe: shadow maps, depth pre-pass).         *         * @param stage3DProxy The Stage3DProxy used for rendering.         * @param camera The camera from which the scene is viewed.         * @param distanceBased Whether or not the depth pass or distance pass should be activated. The distance pass         * is required for shadow cube maps.         *         * @private         */
        public function iActivateForDepth(stage3DProxy:Stage3DProxy, camera:Camera3D, distanceBased:Boolean = false):void // ARCANE        {
			distanceBased = distanceBased || false;



            this._distanceBasedDepthRender = distanceBased;

            if (distanceBased)
            {

                this._pDistancePass.iActivate(stage3DProxy, camera);

            }
            else
            {

                this._pDepthPass.iActivate(stage3DProxy, camera);

            }

        }

        /**         * Clears the render state for the depth pass.         *         * @param stage3DProxy The Stage3DProxy used for rendering.         *         * @private         */
        public function iDeactivateForDepth(stage3DProxy:Stage3DProxy):void
        {


            if (this._distanceBasedDepthRender)
            {

                this._pDistancePass.iDeactivate(stage3DProxy);

            }
            else
            {

                this._pDepthPass.iDeactivate(stage3DProxy);

            }


        }
        /**         * Renders a renderable using the depth pass.         *         * @param renderable The IRenderable instance that needs to be rendered.         * @param stage3DProxy The Stage3DProxy used for rendering.         * @param camera The camera from which the scene is viewed.         * @param viewProjection The view-projection matrix used to project to the screen. This is not the same as         * camera.viewProjection as it includes the scaling factors when rendering to textures.         *         * @private         */
        public function iRenderDepth(renderable:IRenderable, stage3DProxy:Stage3DProxy, camera:Camera3D, viewProjection:Matrix3D):void // ARCANE        {

            if (this._distanceBasedDepthRender)
            {

                if (renderable.animator)
                {

                    this._pDistancePass.iUpdateAnimationState(renderable, stage3DProxy, camera);

                }


                this._pDistancePass.iRender(renderable, stage3DProxy, camera, viewProjection);

            }
            else
            {
                if (renderable.animator)
                {

                    this._pDepthPass.iUpdateAnimationState(renderable, stage3DProxy, camera);

                }


                this._pDepthPass.iRender(renderable, stage3DProxy, camera, viewProjection);

            }


        }
        //*/
        /**         * Indicates whether or not the pass with the given index renders to texture or not.         * @param index The index of the pass.         * @return True if the pass renders to texture, false otherwise.         *         * @private         */

        public function iPassRendersToTexture(index:Number):Boolean
        {

            return this._passes[index].renderToTexture;

        }

        /**         * Sets the render state for a pass that is independent of the rendered object. This needs to be called before         * calling renderPass. Before activating a pass, the previously used pass needs to be deactivated.         * @param index The index of the pass to activate.         * @param stage3DProxy The Stage3DProxy object which is currently used for rendering.         * @param camera The camera from which the scene is viewed.         * @private         */

        public function iActivatePass(index:Number, stage3DProxy:Stage3DProxy, camera:Camera3D):void // ARCANE        {
            this._passes[index].iActivate(stage3DProxy, camera);

        }

        /**         * Clears the render state for a pass. This needs to be called before activating another pass.         * @param index The index of the pass to deactivate.         * @param stage3DProxy The Stage3DProxy used for rendering         *         * @private         */

        public function iDeactivatePass(index:Number, stage3DProxy:Stage3DProxy):void // ARCANE        {
            this._passes[index].iDeactivate(stage3DProxy);
        }

        /**         * Renders the current pass. Before calling renderPass, activatePass needs to be called with the same index.         * @param index The index of the pass used to render the renderable.         * @param renderable The IRenderable object to draw.         * @param stage3DProxy The Stage3DProxy object used for rendering.         * @param entityCollector The EntityCollector object that contains the visible scene data.         * @param viewProjection The view-projection matrix used to project to the screen. This is not the same as         * camera.viewProjection as it includes the scaling factors when rendering to textures.         */
        public function iRenderPass(index:Number, renderable:IRenderable, stage3DProxy:Stage3DProxy, entityCollector:EntityCollector, viewProjection:Matrix3D):void
        {
            if (this._pLightPicker)
            {

                this._pLightPicker.collectLights(renderable, entityCollector);

            }

            var pass:MaterialPassBase = this._passes[index];

            if (renderable.animator)
            {

                pass.iUpdateAnimationState(renderable, stage3DProxy, entityCollector.camera);

            }


            pass.iRender(renderable, stage3DProxy, entityCollector.camera, viewProjection);

        }

        //
        // MATERIAL MANAGEMENT
        //
        /**         * Mark an IMaterialOwner as owner of this material.         * Assures we're not using the same material across renderables with different animations, since the         * Program3Ds depend on animation. This method needs to be called when a material is assigned.         *         * @param owner The IMaterialOwner that had this material assigned         *         * @private         */

        public function iAddOwner(owner:IMaterialOwner):void // ARCANE        {
            this._owners.push(owner);

            if (owner.animator) {

                if (this._animationSet && owner.animator.animationSet != this._animationSet)
                {

                    throw new Error("A Material instance cannot be shared across renderables with different animator libraries");

                }
                else
                {

                    if (this._animationSet != owner.animator.animationSet)
                    {

                        this._animationSet = owner.animator.animationSet;

                        for (var i:Number = 0; i < this._numPasses; ++i){

                            this._passes[i].animationSet = this._animationSet;

                        }

                        this._pDepthPass.animationSet = this._animationSet;
                        this._pDistancePass.animationSet = this._animationSet;

                        this.iInvalidatePasses( null );//this.invalidatePasses(null);

                    }
                }
            }
        }
        //*/
        /**         * Removes an IMaterialOwner as owner.         * @param owner         * @private         */

        public function iRemoveOwner(owner:IMaterialOwner):void // ARCANE        {
            this._owners.splice(this._owners.indexOf(owner), 1);

            if (this._owners.length == 0)
            {
                this._animationSet = null;

                for (var i:Number = 0; i < this._numPasses; ++i)
                {

                    this._passes[i].animationSet = this._animationSet;

                }

                this._pDepthPass.animationSet = this._animationSet;
                this._pDistancePass.animationSet = this._animationSet;
                this.iInvalidatePasses(null);
            }
        }
        //*/
        /**         * A list of the IMaterialOwners that use this material         *         * @private         */
        public function get iOwners():Vector.<IMaterialOwner>//Vector.<IMaterialOwner> // ARCANE        {
            return this._owners;
        }

        /**         * Performs any processing that needs to occur before any of its passes are used.         *         * @private         */
        public function iUpdateMaterial(context:Context3D):void // ARCANE        {
            //throw new away.errors.AbstractMethodError();
        }

        /**         * Deactivates the last pass of the material.         *         * @private         */
        public function iDeactivate(stage3DProxy:Stage3DProxy):void // ARCANE        {

            this._passes[this._numPasses - 1].iDeactivate(stage3DProxy);

        }
        /**         * Marks the shader programs for all passes as invalid, so they will be recompiled before the next use.         * @param triggerPass The pass triggering the invalidation, if any. This is passed to prevent invalidating the         * triggering pass, which would result in an infinite loop.         *         * @private         */

        public function iInvalidatePasses(triggerPass:MaterialPassBase):void
        {
            var owner:IMaterialOwner;

            var l : Number;
            var c : Number;

            this._pDepthPass.iInvalidateShaderProgram();
            this._pDistancePass.iInvalidateShaderProgram();

            // test if the depth and distance passes support animating the animation set in the vertex shader
            // if any object using this material fails to support accelerated animations for any of the passes,
            // we should do everything on cpu (otherwise we have the cost of both gpu + cpu animations)

            if (this._animationSet)
            {

                this._animationSet.resetGPUCompatibility();

                l = this._owners.length;

                for ( c = 0 ; c < l ;c ++ )
                {

                    owner = this._owners[c];

                    if (owner.animator)
                    {

                        owner.animator.testGPUCompatibility(this._pDepthPass);
                        owner.animator.testGPUCompatibility(this._pDistancePass);

                    }

                }

            }

            for (var i:Number = 0; i < this._numPasses; ++i)
            {
                // only invalidate the pass if it wasn't the triggering pass
                if (this._passes[i] != triggerPass)
                {

                    this._passes[i].iInvalidateShaderProgram(false);

                }


                // test if animation will be able to run on gpu BEFORE compiling materials
                // test if the pass supports animating the animation set in the vertex shader
                // if any object using this material fails to support accelerated animations for any of the passes,
                // we should do everything on cpu (otherwise we have the cost of both gpu + cpu animations)
                if (this._animationSet)
                {


                    l = this._owners.length;

                    for ( c = 0 ; c < l ;c ++ )
                    {

                        owner = this._owners[c];

                        if (owner.animator)
                        {

                            owner.animator.testGPUCompatibility(this._passes[i]);

                        }

                    }

                }
            }
        }

        /**         * Removes a pass from the material.         * @param pass The pass to be removed.         */

        public function pRemovePass(pass:MaterialPassBase):void // protected        {
            this._passes.splice(this._passes.indexOf(pass), 1);
            --this._numPasses;
        }

        /**         * Removes all passes from the material         */

        public function pClearPasses():void
        {
            for (var i:Number = 0; i < this._numPasses; ++i)
            {

                this._passes[i].removeEventListener(Event.CHANGE, onPassChange , this );

            }


            this._passes.length = 0;
            this._numPasses = 0;
        }

        /**         * Adds a pass to the material         * @param pass         */

        public function pAddPass(pass:MaterialPassBase):void
        {
            this._passes[this._numPasses++] = pass;
            pass.animationSet = this._animationSet;
            pass.alphaPremultiplied = this._alphaPremultiplied;
            pass.mipmap = this._pMipmap;
            pass.smooth = this._smooth;
            pass.repeat = this._repeat;
            pass.lightPicker = this._pLightPicker;
            pass.bothSides = this._bothSides;
            pass.addEventListener(Event.CHANGE, onPassChange , this );
            this.iInvalidatePasses(null);

        }

        /**         * Listener for when a pass's shader code changes. It recalculates the render order id.         */

        private function onPassChange(event:Event):void
        {
            var mult:Number = 1;
            var ids:Vector.<Number>;////Vector.<int>;
            var len:Number;

            this._iRenderOrderId = 0;

            for (var i:Number = 0; i < this._numPasses; ++i)
            {

                ids = this._passes[i]._iProgram3Dids;
                len = ids.length;

                for (var j:Number = 0; j < len; ++j)
                {

                    if (ids[j] != -1)
                    {

                        this._iRenderOrderId += mult*ids[j];
                        j = len;

                    }

                }

                mult *= 1000;
            }
        }

        /**         * Listener for when the distance pass's shader code changes. It recalculates the depth pass id.         */
        private function onDistancePassChange(event:Event):void
        {

            var ids:Vector.<Number> = this._pDistancePass._iProgram3Dids;
            var len:Number = ids.length;

            this._iDepthPassId = 0;

            for (var j:Number = 0; j < len; ++j)
            {
                if (ids[j] != -1)
                {

                    this._iDepthPassId += ids[j];
                    j = len;

                }

            }


        }

        /**         * Listener for when the depth pass's shader code changes. It recalculates the depth pass id.         */

        private function onDepthPassChange(event:Event):void
        {

            var ids:Vector.<Number> = this._pDepthPass._iProgram3Dids;
            var len:Number = ids.length;

            this._iDepthPassId = 0;

            for (var j:Number = 0; j < len; ++j)
            {

                if (ids[j] != -1)
                {

                    this._iDepthPassId += ids[j];
                    j = len;

                }

            }


        }

    }
}
