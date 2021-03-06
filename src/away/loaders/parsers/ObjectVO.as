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
	public class ObjectVO
	{
		public var name:String = null;
		public var type:String = null;
		public var pivotX:Number = 0;
		public var pivotY:Number = 0;
		public var pivotZ:Number = 0;
		public var transform:Vector.<Number>;
		public var verts:Vector.<Number>;
		public var indices:Vector.<Number>;/*int*/
		public var uvs:Vector.<Number>;
		public var materialFaces:Object;
		public var materials:Vector.<String>;
		public var smoothingGroups:Vector.<Number>;/*int*/
		
		public function ObjectVO():void
		{
		}
	}
	
}



