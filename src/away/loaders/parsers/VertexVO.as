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
	import away.loaders.parsers.utils.ParserUtil;
	import away.loaders.misc.ResourceDependency;
	import away.library.assets.IAsset;
	import away.library.assets.AssetType;
	import away.textures.Texture2DBase;
	import away.utils.VectorInit;
	import away.containers.ObjectContainer3D;
	import away.core.net.URLRequest;
	import away.core.geom.Vector3D;
	import away.core.base.ISubGeometry;
	import away.core.base.Geometry;
	import away.materials.MaterialBase;
	import away.entities.Mesh;
	import away.core.geom.Matrix3D;
	import away.utils.GeometryUtils;
	import away.materials.TextureMaterial;
	import away.materials.utils.DefaultMaterialManager;
	import away.materials.ColorMaterial;
	import away.materials.SinglePassMaterialBase;
	import away.materials.TextureMultiPassMaterial;
	import away.materials.ColorMultiPassMaterial;
	import away.materials.MultiPassMaterialBase;
	import randori.webkit.page.Window;
	/**	 * Max3DSParser provides a parser for the 3ds data type.	 */
	public class VertexVO
	{
		public var x:Number = 0;
		public var y:Number = 0;
		public var z:Number = 0;
		public var u:Number = 0;
		public var v:Number = 0;
		public var normal:Vector3D;
		public var tangent:Vector3D;
		
		public function VertexVO():void
		{
		}
	}
	
}



