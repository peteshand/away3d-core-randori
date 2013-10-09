/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package away.core.base
{
	import away.library.assets.NamedAssetBase;
	import away.library.assets.IAsset;
	import away.library.assets.AssetType;
	import away.core.geom.Matrix3D;
	import away.events.GeometryEvent;
    /**     *	 * Geometry is a collection of SubGeometries, each of which contain the actual geometrical data such as vertices,	 * normals, uvs, etc. It also contains a reference to an animation class, which defines how the geometry moves.	 * A Geometry object is assigned to a Mesh, a scene graph occurence of the geometry, which in turn assigns	 * the SubGeometries to its respective SubMesh objects.	 *	 *	 *	 * @see away3d.core.base.SubGeometry	 * @see away3d.scenegraph.Mesh     *     * @class away.base.Geometry	 */
	public class Geometry extends NamedAssetBase implements IAsset
	{
        private var _subGeometries:Vector.<ISubGeometry>;//Vector.<ISubGeometry>//private var _subGeometries:Vector.<ISubGeometry>
		
		override public function get assetType():String
		{

			return AssetType.GEOMETRY;

		}
		
		/**		 * A collection of SubGeometry objects, each of which contain geometrical data such as vertices, normals, etc.		 */
        public function get subGeometries():Vector.<ISubGeometry>//Vector.<ISubGeometry>        {

            return this._subGeometries;

        }
        public function getSubGeometries():Vector.<ISubGeometry>//Vector.<ISubGeometry>        {

            return this._subGeometries;

        }

        /**		 * Creates a new Geometry object.		 */
		public function Geometry():void
		{
            super(null);

            this._subGeometries = new Vector.<ISubGeometry>();//Vector.<ISubGeometry>();

		}
		
		public function applyTransformation(transform:Matrix3D):void
		{
			var len:Number = this._subGeometries.length;
			for (var i:Number = 0; i < len; ++i)
            {

                this._subGeometries[i].applyTransformation(transform);

            }

		}
		
		/**		 * Adds a new SubGeometry object to the list.		 * @param subGeometry The SubGeometry object to be added.		 */
		public function addSubGeometry(subGeometry:ISubGeometry):void
		{
			this._subGeometries.push(subGeometry);
			
			subGeometry.parentGeometry = this;

            // TODO: add hasEventListener optimisation;
			//if (hasEventListener(GeometryEvent.SUB_GEOMETRY_ADDED))
			this.dispatchEvent(new GeometryEvent(GeometryEvent.SUB_GEOMETRY_ADDED, subGeometry));
			
			this.iInvalidateBounds(subGeometry);

		}
		
		/**		 * Removes a new SubGeometry object from the list.		 * @param subGeometry The SubGeometry object to be removed.		 */
		public function removeSubGeometry(subGeometry:ISubGeometry):void
		{
			this._subGeometries.splice(this._subGeometries.indexOf(subGeometry), 1);

			subGeometry.parentGeometry = null;

            // TODO: add hasEventListener optimisation;
			//if (hasEventListener(GeometryEvent.SUB_GEOMETRY_REMOVED))
				this.dispatchEvent(new GeometryEvent(GeometryEvent.SUB_GEOMETRY_REMOVED, subGeometry));

            this.iInvalidateBounds( subGeometry );
		}
		
		/**		 * Clones the geometry.		 * @return An exact duplicate of the current Geometry object.		 */
		public function clone():Geometry
		{
			var clone:Geometry = new Geometry();
			var len:Number = this._subGeometries.length;

			for (var i:Number = 0; i < len; ++i)
            {

                clone.addSubGeometry(this._subGeometries[i].clone());

            }

			return clone;
		}
		
		/**		 * Scales the geometry.		 * @param scale The amount by which to scale.		 */
		public function scale(scale:Number):void
		{
			var numSubGeoms:Number = this._subGeometries.length;
			for (var i:Number = 0; i < numSubGeoms; ++i)
            {

                this._subGeometries[i].scale(scale);

            }

		}
		
		/**		 * Clears all resources used by the Geometry object, including SubGeometries.		 */
		override public function dispose():void
		{

			var numSubGeoms:Number = this._subGeometries.length;
			
			for (var i:Number = 0; i < numSubGeoms; ++i)
            {
				var subGeom:ISubGeometry = this._subGeometries[0];
                this.removeSubGeometry(subGeom);
				subGeom.dispose();
			}

		}
		
		/**		 * Scales the uv coordinates (tiling)		 * @param scaleU The amount by which to scale on the u axis. Default is 1;		 * @param scaleV The amount by which to scale on the v axis. Default is 1;		 */
		public function scaleUV(scaleU:Number = 1, scaleV:Number = 1):void
		{
			scaleU = scaleU || 1;
			scaleV = scaleV || 1;

			var numSubGeoms:Number = this._subGeometries.length;

			for (var i:Number = 0; i < numSubGeoms; ++i)
            {

                this._subGeometries[i].scaleUV(scaleU, scaleV);

            }

		}
		
		/**		 * Updates the SubGeometries so all vertex data is represented in different buffers.		 * Use this for compatibility with Pixel Bender and PBPickingCollider		 */
		public function convertToSeparateBuffers():void
		{
			var subGeom:ISubGeometry;
			var numSubGeoms:Number = this._subGeometries.length;
			var _removableCompactSubGeometries:Vector.<CompactSubGeometry> = new Vector.<CompactSubGeometry>();//Vector.<CompactSubGeometry> = new Vector.<CompactSubGeometry>();

			for (var i:Number = 0; i < numSubGeoms; ++i)
            {
				subGeom = this._subGeometries[i];

				if (subGeom instanceof SubGeometry)
                {

                    continue;

                }


				_removableCompactSubGeometries.push( (subGeom as CompactSubGeometry));

				this.addSubGeometry(subGeom.cloneWithSeperateBuffers());
			}

            var l : Number = _removableCompactSubGeometries.length;
            var s : CompactSubGeometry;

            for ( var c : Number = 0 ; c  < l ; c++ )
            {

                s = _removableCompactSubGeometries[c];
                this.removeSubGeometry( s );
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
			this.dispatchEvent(new GeometryEvent(GeometryEvent.BOUNDS_INVALID, subGeom));

		}

	}

}
