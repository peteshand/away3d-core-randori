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
	public class AWDBlock
	{
		public var id:Number = 0;
		public var name:String = null;
		public var data:*;
		public var len:*;
		public var geoID:Number = 0;
		public var extras:Object;
		public var bytes:ByteArray;
		public var errorMessages:Vector.<String>;
		public var uvsForVertexAnimation:Vector.<Vector.<Number>>;
	
		public function AWDBlock():void
		{
		}
	
	    public function dispose():void
	    {
	
	        this.id = null;
	        this.bytes = null;
	        this.errorMessages = null;
	        this.uvsForVertexAnimation = null;
	
	    }
	
		public function addError(errorMsg:String):void
		{
			if (!this.errorMessages)
				this.errorMessages = VectorInit.Str();
			this.errorMessages.push(errorMsg);
		}
	}
	
}


