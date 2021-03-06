

package examples
{
import away.containers.View3D;
import away.controllers.HoverController;
import away.core.geom.Vector3D;
import away.core.net.URLRequest;
import away.entities.Mesh;
import away.events.AssetEvent;
import away.events.LoaderEvent;
import away.library.AssetLibrary;
import away.library.assets.AssetType;
import away.library.assets.IAsset;
import away.lights.DirectionalLight;
import away.loaders.AssetLoader;
import away.loaders.misc.AssetLoaderToken;
import away.loaders.parsers.AWDParser;
import away.materials.lightpickers.StaticLightPicker;
import away.utils.Debug;

import randori.webkit.page.Window;

/**
     * Created with IntelliJ IDEA.
     * User: pete
     * Date: 23/09/13
     * Time: 7:52 AM
     * To change this template use File | Settings | File Templates.
     */
    public class AWDSuzanne extends BaseExample
    {
        private var token          : AssetLoaderToken;
        private var suzane         : Mesh;
        private var light          : DirectionalLight;
        private var lightPicker    : StaticLightPicker;
        private var hoverControl   : HoverController;
    
        private var move           : Boolean = false;
        private var lastPanAngle   : Number;
        private var lastTiltAngle  : Number;
        private var lastMouseX     : Number;
        private var lastMouseY     : Number;
        
        public function AWDSuzanne(_index:int)
        {
            super(_index);

            Debug.LOG_PI_ERRORS = true;
            Debug.THROW_ERRORS = false;

            AssetLibrary.enableParser( AWDParser ) ;

            token = AssetLibrary.load(new URLRequest('assets/suzanne.awd') );
            token.addEventListener( LoaderEvent.RESOURCE_COMPLETE , onResourceComplete , this );
            token.addEventListener(AssetEvent.ASSET_COMPLETE , onAssetComplete, this );

            view = new View3D();
            view.backgroundColor = 0x666666;
        }

        override protected function resize():void
        {
            if (view){
                view.y         = 0;
                view.x         = 0;
                view.width     = window.innerWidth;
                view.height    = window.innerHeight;
            }
        }

        override protected function tick(dt:Number):void
        {
            Window.console.log( 'tick');
            if ( suzane )
            {
                suzane.rotationY += 1;
                view.render();
            }



            if ( hoverControl  )
            {
                hoverControl.update(false);
            }

        }

        public function onAssetComplete ( e : AssetEvent )
        {

            Window.console.log( '------------------------------------------------------------------------------');
            Window.console.log( 'AssetEvent.ASSET_COMPLETE' , AssetLibrary.getAsset(e.asset.name) );
            Window.console.log( '------------------------------------------------------------------------------');

        }

        public function onResourceComplete ( e : LoaderEvent )
        {

            Window.console.log( '------------------------------------------------------------------------------');
            Window.console.log( 'LoaderEvent.RESOURCE_COMPLETE' , e  );
            Window.console.log( '------------------------------------------------------------------------------');

            var loader			: AssetLoader   	= e.target as AssetLoader;
            var numAssets		: Number = loader.baseDependency.assets.length;

            for( var i : Number = 0; i < numAssets; ++i )
            {
                var asset: IAsset = loader.baseDependency.assets[ i ];

                switch ( asset.assetType )
                {
                    case AssetType.MESH:

                    var mesh : Mesh = asset as Mesh;
                    mesh.scale( 400 );

                    suzane = mesh;
                    suzane.y = -100;

                    view.scene.addChild( mesh );

                    resize();

                    break;

                    case AssetType.GEOMETRY:
                    break;

                    case AssetType.MATERIAL:
                    break;
                }
            }

            resize();
        }
    }
}