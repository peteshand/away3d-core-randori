package examples
{
    import away.containers.ObjectContainer3D;
    import away.containers.View3D;
    import away.entities.Mesh;
    import away.events.AssetEvent;
    import away.events.LoaderEvent;
    import away.geom.Vector3D;
    import away.library.AssetLibrary;
    import away.library.assets.AssetType;
    import away.library.assets.IAsset;
    import away.lights.DirectionalLight;
    import away.loaders.AssetLoader;
    import away.loaders.misc.AssetLoaderToken;
    import away.loaders.parsers.OBJParser;
    import away.materials.TextureMaterial;
    import away.materials.TextureMultiPassMaterial;
    import away.materials.lightpickers.StaticLightPicker;
    import away.net.URLRequest;
    import away.textures.HTMLImageElementTexture;
    import away.utils.Debug;
    import away.utils.RequestAnimationFrame;
    import randori.webkit.page.Window;

/**
     * Created with IntelliJ IDEA.
     * User: pete
     * Date: 10/09/13
     * Time: 9:52 PM
     * To change this template use File | Settings | File Templates.
     */
    public class ObjChiefTestDay
    {
        private var height : Number = 0;

        private var token   : AssetLoaderToken;
        private var view    : View3D;
        private var raf     : RequestAnimationFrame;
        private var mesh    : Mesh;
        private var meshes  : Vector.<Mesh> = new Vector.<Mesh>();
        private var mat     : TextureMaterial;

        private var terrainMaterial:TextureMaterial;

        private var multiMat:TextureMultiPassMaterial;
        private var light   :DirectionalLight;
        private var t800M   :Mesh;

        private var spartan :ObjectContainer3D = new ObjectContainer3D();
        private var terrain :Mesh;

        public function ObjChiefTestDay()
        {
            Debug.LOG_PI_ERRORS    = false;
            Debug.THROW_ERRORS     = false;

            view                  = new View3D( );
            view.camera.z          = -50;
            view.camera.y          = 20;
            view.camera.lens.near  = 0.1;
            view.backgroundColor   = 0xCEC8C6//A0A7DE;//0E0E10;

            //view.backgroundColor   = 0xFF0000;
            raf                    = new RequestAnimationFrame( render , this );

            light                  = new DirectionalLight();
            light.color            = 0xc1582d;//683019;
            light.direction        = new Vector3D( 1 , 0 ,0 );
            light.ambient          = 0.4;//0.05;//.4;
            light.ambientColor     = 0x85b2cd;//4F6877;//313D51;
            light.diffuse          = 2.8;
            light.specular         = 1.8;
            //light.x                = 800;
            //light.y                = 800;

            spartan.scale(.25 );
            spartan.y = 0;

            view.scene.addChild( light );

            AssetLibrary.enableParser( OBJParser ) ;

            token = AssetLibrary.load(new URLRequest('Halo_3_SPARTAN4.obj') );
            token.addEventListener(LoaderEvent.RESOURCE_COMPLETE , onResourceComplete , this );
            token.addEventListener(AssetEvent.ASSET_COMPLETE , onAssetComplete, this );

            token = AssetLibrary.load(new URLRequest('terrain.obj') );
            token.addEventListener(LoaderEvent.RESOURCE_COMPLETE , onResourceComplete , this );
            token.addEventListener(AssetEvent.ASSET_COMPLETE , onAssetComplete, this );


            //*
            //token = AssetLibrary.load(new URLRequest('masterchief_base.png') );
            //token.addEventListener(LoaderEvent.RESOURCE_COMPLETE , onResourceComplete , this );
            //token.addEventListener(AssetEvent.ASSET_COMPLETE , onAssetComplete, this );

            //token = AssetLibrary.load(new URLRequest('stone_tx.jpg' ) );
            //token.addEventListener(LoaderEvent.RESOURCE_COMPLETE , onResourceComplete , this );
            //token.addEventListener(AssetEvent.ASSET_COMPLETE , onAssetComplete, this );

            //window.onresize = resize();
        }


        private var t : Number = 0;

        private function render()
        {
            if ( terrain)
                terrain.rotationY += 0.4;

            spartan.rotationY += 0.4;
            view.render();
        }

        public function onAssetComplete ( e : AssetEvent )
        {

        }

        private var spartanFlag     : Boolean = false;
        private var terrainObjFlag  : Boolean = false;

        public function onResourceComplete ( e : LoaderEvent )
        {

            var loader  : AssetLoader   = (e.target as AssetLoader);
            var l       : Number        = loader.baseDependency.assets.length//dependencies.length;


            Window.console.log( '------------------------------------------------------------------------------');
            Window.console.log( 'away.events.LoaderEvent.RESOURCE_COMPLETE' , e , l , loader );
            Window.console.log( '------------------------------------------------------------------------------');


            //*
            var loader  : AssetLoader   = e.target as AssetLoader;
                var l:Number = loader.baseDependency.assets.length//dependencies.length;

                for ( var c:int = 0; c < l; ++c )
                {

                    var d : IAsset = loader.baseDependency.assets[c];

                    Window.console.log( d.name , e.url );

                    switch (d.assetType)
                    {
                        case AssetType.MESH:
                            if (e.url =='Halo_3_SPARTAN4.obj')
                            {
                                var mesh : Mesh = (AssetLibrary.getAsset( d.name ) as Mesh);
                                spartan.addChild( mesh );
                                raf.start();
                                spartanFlag = true;
                                meshes.push( mesh );
                            }
                            if (e.url =='terrain.obj')
                            {
                                terrainObjFlag = true;
                                terrain = (AssetLibrary.getAsset( d.name ) as Mesh);
                                terrain.y = 98;
                                view.scene.addChild( terrain );
                            }
                        break;
                        case AssetType.TEXTURE :
                            if (e.url == 'masterchief_base.png' )
                            {
                                var lightPicker:StaticLightPicker = new StaticLightPicker( [light] );
                                var tx  : HTMLImageElementTexture = (AssetLibrary.getAsset( d.name ) as HTMLImageElementTexture);
                                mat = new TextureMaterial( tx, true, true, false );
                                mat.lightPicker = lightPicker;
                            }
                            if (e.url == 'stone_tx.jpg')
                            {
                                var lp:StaticLightPicker    = new StaticLightPicker( [light] );
                                var txT  : HTMLImageElementTexture = AssetLibrary.getAsset( d.name ) as HTMLImageElementTexture;

                                terrainMaterial = new TextureMaterial( txT, true, true, false );
                                terrainMaterial.lightPicker = lp;
                            }

                        break;

                    }

                if ( terrainObjFlag && terrainMaterial )
                {
                    terrain.material = terrainMaterial;
                    terrain.geometry.scaleUV( 20 , 20 );
                }
                if ( mat && spartanFlag )
                {
                    for ( var b:int = 0 ; b < meshes.length ; b++ )
                    {
                        meshes[b].material = mat;
                    }
                }

                view.scene.addChild( spartan );
                resize();
            }
        }
        public function resize():void
        {
            view.y         = 0;
            view.x         = 0;

            view.width     = window.innerWidth;
            view.height    = window.innerHeight;
        }
    }
}