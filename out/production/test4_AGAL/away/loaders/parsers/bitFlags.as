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
	public class bitFlags
	{
		public static var FLAG1:Number = 1;
		public static var FLAG2:Number = 2;
		public static var FLAG3:Number = 4;
		public static var FLAG4:Number = 8;
		public static var FLAG5:Number = 16;
		public static var FLAG6:Number = 32;
		public static var FLAG7:Number = 64;
		public static var FLAG8:Number = 128;
		public static var FLAG9:Number = 256;
		public static var FLAG10:Number = 512;
		public static var FLAG11:Number = 1024;
		public static var FLAG12:Number = 2048;
		public static var FLAG13:Number = 4096;
		public static var FLAG14:Number = 8192;
		public static var FLAG15:Number = 16384;
		public static var FLAG16:Number = 32768;
	
		public static function test(flags:Number, testFlag:Number):Boolean
		{
			return (flags & testFlag) == testFlag;
		}
	}
	
}


