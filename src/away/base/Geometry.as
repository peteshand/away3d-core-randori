///<reference path="../_definitions.ts"/>
package away.base
{
	import away.library.assets.NamedAssetBase;
	import away.library.assets.IAsset;
	import away.library.assets.AssetType;
	import away.geom.Matrix3D;
	import away.events.GeometryEvent;

	/**	 * Geometry is a collection of SubGeometries, each of which contain the actual geometrical data such as vertices,	 * normals, uvs, etc. It also contains a reference to an animation class, which defines how the geometry moves.	 * A Geometry object is assigned to a Mesh, a scene graph occurence of the geometry, which in turn assigns	 * the SubGeometries to its respective SubMesh objects.	 *	 *	 *	 * @see away3d.core.base.SubGeometry	 * @see away3d.scenegraph.Mesh	 */
	public class Geometry extends NamedAssetBase implements IAsset
	{
        private var _subGeometries:Vector.<ISubGeometry>;//Vector.<ISubGeometry>;//private var _subGeometries:Vector.<ISubGeometry>;		
		override public function get assetType():String
		{

			return AssetType.GEOMETRY;

		}
		
		/**		 * A collection of SubGeometry objects, each of which contain geometrical data such as vertices, normals, etc.		 */
        public function get subGeometries():Vector.<ISubGeometry>//Vector.<ISubGeometry>        {

            return _subGeometries;

        }
        public function getSubGeometries():Vector.<ISubGeometry>//Vector.<ISubGeometry>        {

            return _subGeometries;

        }

        /**		 * Creates a new Geometry object.		 */
		public function Geometry():void
		{
            super();

            this._subGeometries = new Vector.<ISubGeometry>();//Vector.<ISubGeometry>();

		}
		
		public function applyTransformation(transform:Matrix3D):void
		{
			var len:Number = _subGeometries.length;
			for (var i:Number = 0; i < len; ++i)
            {

                _subGeometries[i].applyTransformation(transform);

            }

		}
		
		/**		 * Adds a new SubGeometry object to the list.		 * @param subGeometry The SubGeometry object to be added.		 */
		public function addSubGeometry(subGeometry:ISubGeometry):void
		{
			_subGeometries.push(subGeometry);
			
			subGeometry.parentGeometry = this;

            // TODO: add hasEventListener optimisation;
			//if (hasEventListener(GeometryEvent.SUB_GEOMETRY_ADDED))
			dispatchEvent(new GeometryEvent(GeometryEvent.SUB_GEOMETRY_ADDED, subGeometry));
			
			iInvalidateBounds(subGeometry);

		}
		
		/**		 * Removes a new SubGeometry object from the list.		 * @param subGeometry The SubGeometry object to be removed.		 */
		public function removeSubGeometry(subGeometry:ISubGeometry):void
		{
			_subGeometries.splice(_subGeometries.indexOf(subGeometry), 1);

			subGeometry.parentGeometry = null;

            // TODO: add hasEventListener optimisation;
			//if (hasEventListener(GeometryEvent.SUB_GEOMETRY_REMOVED))
				dispatchEvent(new GeometryEvent(GeometryEvent.SUB_GEOMETRY_REMOVED, subGeometry));

            iInvalidateBounds( subGeometry );
		}
		
		/**		 * Clones the geometry.		 * @return An exact duplicate of the current Geometry object.		 */
		public function clone():Geometry
		{
			var clone:Geometry = new Geometry();
			var len:Number = _subGeometries.length;

			for (var i:Number = 0; i < len; ++i)
            {

                clone.addSubGeometry(_subGeometries[i].clone());

            }

			return clone;
		}
		
		/**		 * Scales the geometry.		 * @param scale The amount by which to scale.		 */
		public function scale(scale:Number):void
		{
			var numSubGeoms:Number = _subGeometries.length;
			for (var i:Number = 0; i < numSubGeoms; ++i)
            {

                _subGeometries[i].scale(scale);

            }

		}
		
		/**		 * Clears all resources used by the Geometry object, including SubGeometries.		 */
		override public function dispose():void
		{

			var numSubGeoms:Number = _subGeometries.length;
			
			for (var i:Number = 0; i < numSubGeoms; ++i)
            {
				var subGeom:ISubGeometry = _subGeometries[0];
                removeSubGeometry(subGeom);
				subGeom.dispose();
			}

		}
		
		/**		 * Scales the uv coordinates (tiling)		 * @param scaleU The amount by which to scale on the u axis. Default is 1;		 * @param scaleV The amount by which to scale on the v axis. Default is 1;		 */
		public function scaleUV(scaleU:Number = 1, scaleV:Number = 1):void
		{
			var numSubGeoms:Number = _subGeometries.length;

			for (var i:Number = 0; i < numSubGeoms; ++i)
            {

                _subGeometries[i].scaleUV(scaleU, scaleV);

            }

		}
		
		/**		 * Updates the SubGeometries so all vertex data is represented in different buffers.		 * Use this for compatibility with Pixel Bender and PBPickingCollider		 */
		public function convertToSeparateBuffers():void
		{
			var subGeom:ISubGeometry;
			var numSubGeoms:Number = _subGeometries.length;
			var _removableCompactSubGeometries:Vector.<CompactSubGeometry> = new Vector.<CompactSubGeometry>();//Vector.<CompactSubGeometry> = new Vector.<CompactSubGeometry>();

			for (var i:Number = 0; i < numSubGeoms; ++i)
            {
				subGeom = _subGeometries[i];

				if (subGeom instanceof SubGeometry)
                {

                    continue;

                }


				_removableCompactSubGeometries.push( CompactSubGeometry(subGeom));

				addSubGeometry(subGeom.cloneWithSeperateBuffers());
			}

            var l : Number = _removableCompactSubGeometries.length;
            var s : CompactSubGeometry;

            for ( var c : Number = 0 ; c  < l ; c++ )
            {

                s = _removableCompactSubGeometries[c];
                removeSubGeometry( s );
                s.dispose();

            }

		}
		
		public function iValidate():void
		{
			// To be overridden when necessary
		}
		
		public function iInvalidateBounds(subGeom:ISubGeometry):void
		{
			//if (hasEventListener(GeometryEvent.BOUNDS_INVALID))
			dispatchEvent(new GeometryEvent(GeometryEvent.BOUNDS_INVALID, subGeom));

		}

	}

}
