

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

    /**
    public class MaterialBase extends NamedAssetBase implements IAsset
    {
        /**
        private static var MATERIAL_ID_COUNT:Number = 0;

        /**
        public var extra:Object;

        /**
        public var _iClassification:String;//Arcane
        /**
        public var _iUniqueId:Number;//Arcane
        /**
        public var _iRenderOrderId:Number = 0;//Arcane
        /**
        public var _iDepthPassId:Number;//Arcane
        private var _bothSides:Boolean = false; // update

        /**


        private var _owners:Vector.<IMaterialOwner>;//:Vector.<IMaterialOwner>;
        private var _alphaPremultiplied:Boolean;

        public var _pBlendMode:String = BlendMode.NORMAL;

        private var _numPasses:Number = 0;
        private var _passes:Vector.<MaterialPassBase>;//Vector.<MaterialPassBase>;
        public var _pMipmap:Boolean = true;
        private var _smooth:Boolean = true;
        private var _repeat:Boolean = false; // Update
        public var _pDepthPass:DepthMapPass;
        public var _pDistancePass:DistanceMapPass;
        public var _pLightPicker:LightPickerBase;

        private var _distanceBasedDepthRender:Boolean;
        public var _pDepthCompareMode:String = Context3DCompareMode.LESS_EQUAL;

        /**
            public function MaterialBase():void
        {

            super();

            this._owners = new Vector.< IMaterialOwner>();
            this._passes = new Vector.<MaterialPassBase>();
            this._pDepthPass= new DepthMapPass();
            this._pDistancePass = new DistanceMapPass();

            this._pDepthPass.addEventListener(Event.CHANGE, this.onDepthPassChange, this );
            this._pDistancePass.addEventListener(Event.CHANGE, this.onDistancePassChange , this);

            this.alphaPremultiplied= true;

            this._iUniqueId = MaterialBase.MATERIAL_ID_COUNT++;

        }

        /**
        override public function get assetType():String
        {
            return AssetType.MATERIAL;
        }

        /**
        public function get lightPicker():LightPickerBase
        {
            return _pLightPicker;
        }

        public function set lightPicker(value:LightPickerBase):void
        {

            this.setLightPicker( value );

        }

        public function setLightPicker(value:LightPickerBase):void
        {

            if (value != _pLightPicker)
            {

                _pLightPicker = value;
                var len:Number = _passes.length;

                for (var i:Number = 0; i < len; ++i)
                {

                    _passes[i].lightPicker = _pLightPicker;

                }

            }

        }

        /**
        public function get mipmap():Boolean
        {
            return _pMipmap;
        }

        public function set mipmap(value:Boolean):void
        {

            this.setMipMap( value );

        }

        public function setMipMap(value:Boolean):void
        {

            _pMipmap = value;

            for (var i:Number = 0; i < _numPasses; ++i)
            {

                _passes[i].mipmap = value;

            }

        }

        /**
        public function get smooth():Boolean
        {
            return _smooth;
        }

        public function set smooth(value:Boolean):void
        {
            this._smooth = value;

            for (var i:Number = 0; i < this._numPasses; ++i)
            {

                this._passes[i].smooth = value;

            }


        }

        /**

        public function get depthCompareMode():String
        {
            return _pDepthCompareMode;
        }

        public function set depthCompareMode(value:String):void
        {
            this.setDepthCompareMode( value );
        }

        public function setDepthCompareMode(value:String):void
        {
            _pDepthCompareMode = value;
        }

        /**
        public function get repeat():Boolean
        {
            return _repeat;
        }

        public function set repeat(value:Boolean):void
        {
            this._repeat = value;


            for (var i:Number = 0; i < this._numPasses; ++i)
            {

                this._passes[i].repeat = value;

            }

        }

        /**
        override public function dispose():void
        {
            var i:Number;

            for (i = 0; i < _numPasses; ++i)
            {
                _passes[i].dispose();
            }

            _pDepthPass.dispose();
            _pDistancePass.dispose();

            _pDepthPass.removeEventListener(Event.CHANGE, onDepthPassChange , this );
            _pDistancePass.removeEventListener(Event.CHANGE, onDistancePassChange , this );

        }

        /**
        public function get bothSides():Boolean
        {
            return _bothSides;
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

        /**
        public function get blendMode():String
        {
            return getBlendMode();
        }

        public function getBlendMode():String
        {
            return _pBlendMode;
        }

        public function set blendMode(value:String):void
        {
            this.setBlendMode( value );
        }

        public function setBlendMode(value:String):void
        {

            _pBlendMode = value;

        }

        /**
        public function get alphaPremultiplied():Boolean
        {
            return _alphaPremultiplied;
        }

        public function set alphaPremultiplied(value:Boolean):void
        {
            this._alphaPremultiplied = value;

            for (var i:Number = 0; i < this._numPasses; ++i)
            {
                this._passes[i].alphaPremultiplied = value;
            }

        }

        /**
        public function get requiresBlending():Boolean
        {

            return getRequiresBlending();

        }

        public function getRequiresBlending():Boolean
        {

            return _pBlendMode != BlendMode.NORMAL;

        }

        /**
        public function get uniqueId():Number
        {
            return _iUniqueId;
        }

        /**
        public function get _iNumPasses():Number // ARCANE
            return _numPasses;
        }

        /**

        public function iHasDepthAlphaThreshold():Boolean
        {

            return _pDepthPass.alphaThreshold > 0;

        }

        /**
        public function iActivateForDepth(stage3DProxy:Stage3DProxy, camera:Camera3D, distanceBased:Boolean = false):void // ARCANE


            _distanceBasedDepthRender = distanceBased;

            if (distanceBased)
            {

                _pDistancePass.iActivate(stage3DProxy, camera);

            }
            else
            {

                _pDepthPass.iActivate(stage3DProxy, camera);

            }

        }

        /**
        public function iDeactivateForDepth(stage3DProxy:Stage3DProxy):void
        {


            if (_distanceBasedDepthRender)
            {

                _pDistancePass.iDeactivate(stage3DProxy);

            }
            else
            {

                _pDepthPass.iDeactivate(stage3DProxy);

            }


        }
        /**
        public function iRenderDepth(renderable:IRenderable, stage3DProxy:Stage3DProxy, camera:Camera3D, viewProjection:Matrix3D):void // ARCANE

            if (_distanceBasedDepthRender)
            {

                if (renderable.animator)
                {

                    _pDistancePass.iUpdateAnimationState(renderable, stage3DProxy, camera);

                }


                _pDistancePass.iRender(renderable, stage3DProxy, camera, viewProjection);

            }
            else
            {
                if (renderable.animator)
                {

                    _pDepthPass.iUpdateAnimationState(renderable, stage3DProxy, camera);

                }


                _pDepthPass.iRender(renderable, stage3DProxy, camera, viewProjection);

            }


        }
        //*/
        /**

        public function iPassRendersToTexture(index:Number):Boolean
        {

            return _passes[index].renderToTexture;

        }

        /**

        public function iActivatePass(index:Number, stage3DProxy:Stage3DProxy, camera:Camera3D):void // ARCANE
            _passes[index].iActivate(stage3DProxy, camera);

        }

        /**

        public function iDeactivatePass(index:Number, stage3DProxy:Stage3DProxy):void // ARCANE
            _passes[index].iDeactivate(stage3DProxy);
        }

        /**
        public function iRenderPass(index:Number, renderable:IRenderable, stage3DProxy:Stage3DProxy, entityCollector:EntityCollector, viewProjection:Matrix3D):void
        {
            if (_pLightPicker)
            {

                _pLightPicker.collectLights(renderable, entityCollector);

            }

            var pass:MaterialPassBase = _passes[index];

            if (renderable.animator)
            {

                pass.iUpdateAnimationState(renderable, stage3DProxy, entityCollector.camera);

            }


            pass.iRender(renderable, stage3DProxy, entityCollector.camera, viewProjection);

        }

        //
        // MATERIAL MANAGEMENT
        //
        /**

        public function iAddOwner(owner:IMaterialOwner):void // ARCANE
            _owners.push(owner);

            if (owner.animator) {

                if (_animationSet && owner.animator.animationSet != _animationSet)
                {

                    throw new Error("A Material instance cannot be shared across renderables with different animator libraries");

                }
                else
                {

                    if (_animationSet != owner.animator.animationSet)
                    {

                        _animationSet = owner.animator.animationSet;

                        for (var i:Number = 0; i < _numPasses; ++i){

                            _passes[i].animationSet = _animationSet;

                        }

                        _pDepthPass.animationSet = _animationSet;
                        _pDistancePass.animationSet = _animationSet;

                        iInvalidatePasses( null );//this.invalidatePasses(null);

                    }
                }
            }
        }
        //*/
        /**

        public function iRemoveOwner(owner:IMaterialOwner):void // ARCANE
            _owners.splice(_owners.indexOf(owner), 1);

            if (_owners.length == 0)
            {
                _animationSet = null;

                for (var i:Number = 0; i < _numPasses; ++i)
                {

                    _passes[i].animationSet = _animationSet;

                }

                _pDepthPass.animationSet = _animationSet;
                _pDistancePass.animationSet = _animationSet;
                iInvalidatePasses(null);
            }
        }
        //*/
        /**
        public function get iOwners():Vector.<IMaterialOwner>//Vector.<IMaterialOwner> // ARCANE
            return _owners;
        }

        /**
        public function iUpdateMaterial(context:Context3D):void // ARCANE
            //throw new away.errors.AbstractMethodError();
        }

        /**
        public function iDeactivate(stage3DProxy:Stage3DProxy):void // ARCANE

            _passes[_numPasses - 1].iDeactivate(stage3DProxy);

        }
        /**

        public function iInvalidatePasses(triggerPass:MaterialPassBase):void
        {
            var owner:IMaterialOwner;

            var l : Number;
            var c : Number;

            _pDepthPass.iInvalidateShaderProgram();
            _pDistancePass.iInvalidateShaderProgram();

            // test if the depth and distance passes support animating the animation set in the vertex shader
            // if any object using this material fails to support accelerated animations for any of the passes,
            // we should do everything on cpu (otherwise we have the cost of both gpu + cpu animations)

            if (_animationSet)
            {

                _animationSet.resetGPUCompatibility();

                l = _owners.length;

                for ( c = 0 ; c < l ;c ++ )
                {

                    owner = _owners[c];

                    if (owner.animator)
                    {

                        owner.animator.testGPUCompatibility(_pDepthPass);
                        owner.animator.testGPUCompatibility(_pDistancePass);

                    }

                }

            }

            for (var i:Number = 0; i < _numPasses; ++i)
            {
                // only invalidate the pass if it wasn't the triggering pass
                if (_passes[i] != triggerPass)
                {

                    _passes[i].iInvalidateShaderProgram(false);

                }


                // test if animation will be able to run on gpu BEFORE compiling materials
                // test if the pass supports animating the animation set in the vertex shader
                // if any object using this material fails to support accelerated animations for any of the passes,
                // we should do everything on cpu (otherwise we have the cost of both gpu + cpu animations)
                if (_animationSet)
                {


                    l = _owners.length;

                    for ( c = 0 ; c < l ;c ++ )
                    {

                        owner = _owners[c];

                        if (owner.animator)
                        {

                            owner.animator.testGPUCompatibility(_passes[i]);

                        }

                    }

                }
            }
        }

        /**

        public function pRemovePass(pass:MaterialPassBase):void // protected
            _passes.splice(_passes.indexOf(pass), 1);
            --_numPasses;
        }

        /**

        public function pClearPasses():void
        {
            for (var i:Number = 0; i < _numPasses; ++i)
            {

                _passes[i].removeEventListener(Event.CHANGE, onPassChange , this );

            }


            _passes.length = 0;
            _numPasses = 0;
        }

        /**

        public function pAddPass(pass:MaterialPassBase):void
        {
            _passes[_numPasses++] = pass;
            pass.animationSet = _animationSet;
            pass.alphaPremultiplied = _alphaPremultiplied;
            pass.mipmap = _pMipmap;
            pass.smooth = _smooth;
            pass.repeat = _repeat;
            pass.lightPicker = _pLightPicker;
            pass.bothSides = _bothSides;
            pass.addEventListener(Event.CHANGE, onPassChange , this );
            iInvalidatePasses(null);

        }

        /**

        private function onPassChange(event:Event):void
        {
            var mult:Number = 1;
            var ids:Vector.<Number>;////Vector.<int>;
            var len:Number;

            _iRenderOrderId = 0;

            for (var i:Number = 0; i < _numPasses; ++i)
            {

                ids = _passes[i]._iProgram3Dids;
                len = ids.length;

                for (var j:Number = 0; j < len; ++j)
                {

                    if (ids[j] != -1)
                    {

                        _iRenderOrderId += mult*ids[j];
                        j = len;

                    }

                }

                mult *= 1000;
            }
        }

        /**
        private function onDistancePassChange(event:Event):void
        {

            var ids:Vector.<Number> = _pDistancePass._iProgram3Dids;
            var len:Number = ids.length;

            _iDepthPassId = 0;

            for (var j:Number = 0; j < len; ++j)
            {
                if (ids[j] != -1)
                {

                    _iDepthPassId += ids[j];
                    j = len;

                }

            }


        }

        /**

        private function onDepthPassChange(event:Event):void
        {

            var ids:Vector.<Number> = _pDepthPass._iProgram3Dids;
            var len:Number = ids.length;

            _iDepthPassId = 0;

            for (var j:Number = 0; j < len; ++j)
            {

                if (ids[j] != -1)
                {

                    _iDepthPassId += ids[j];
                    j = len;

                }

            }


        }

    }
}