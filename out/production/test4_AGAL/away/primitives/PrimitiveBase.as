/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package away.primitives
{
	import away.core.base.Geometry;
	import away.core.base.CompactSubGeometry;
	import away.core.base.ISubGeometry;
	import away.core.geom.Matrix3D;
	import away.errors.AbstractMethodError;
	//import away3d.arcane;
	//import away3d.core.base.CompactSubGeometry;
	//import away3d.core.base.Geometry;
	//import away3d.core.base.ISubGeometry;
	//import away3d.errors.AbstractMethodError;
	
	//import flash.geom.Matrix3D;
	
	//use namespace arcane;
	
	/**	 * PrimitiveBase is an abstract base class for mesh primitives, which are prebuilt simple meshes.	 */
	public class PrimitiveBase extends Geometry
	{
		private var _geomDirty:Boolean = true;
		private var _uvDirty:Boolean = true;
		
		private var _subGeometry:CompactSubGeometry;
		
		/**		 * Creates a new PrimitiveBase object.		 * @param material The material with which to render the object		 */
		public function PrimitiveBase():void
		{
            super();

			this._subGeometry = new CompactSubGeometry();
			this._subGeometry.autoGenerateDummyUVs = false;
			this.addSubGeometry( this._subGeometry );
		}
		
		/**		 * @inheritDoc		 */
		override public function get subGeometries():Vector.<ISubGeometry>
		{
			if (this._geomDirty)
            {

                this.updateGeometry();

            }

			if ( this._uvDirty )
            {

                this.updateUVs();
            }

			
			return super.getSubGeometries();
		}
		
		/**		 * @inheritDoc		 */
		override public function clone():Geometry
		{
			if (this._geomDirty)
            {

                this.updateGeometry();

            }

			if ( this._uvDirty )
            {
                this.updateUVs();
            }

			
			return super.clone();
		}
		
		/**		 * @inheritDoc		 */
		override public function scale(scale:Number):void
		{
			if ( this._geomDirty)
            {
                this.updateGeometry();
            }

			
			super.scale(scale);
		}
		
		/**		 * @inheritDoc		 */
		override public function scaleUV(scaleU:Number = 1, scaleV:Number = 1):void
		{
			scaleU = scaleU || 1;
			scaleV = scaleV || 1;

			if (this._uvDirty)
            {

                this.updateUVs();

            }

			
			super.scaleUV(scaleU, scaleV);
		}
		
		/**		 * @inheritDoc		 */
		override public function applyTransformation(transform:Matrix3D):void
		{
			if (this._geomDirty)
            {

                this.updateGeometry();

            }

			super.applyTransformation(transform);

		}
		
		/**		 * Builds the primitive's geometry when invalid. This method should not be called directly. The calling should		 * be triggered by the invalidateGeometry method (and in turn by updateGeometry).		 */
		public function pBuildGeometry(target:CompactSubGeometry):void
		{
			throw new AbstractMethodError();
		}
		
		/**		 * Builds the primitive's uv coordinates when invalid. This method should not be called directly. The calling		 * should be triggered by the invalidateUVs method (and in turn by updateUVs).		 */
		public function pBuildUVs(target:CompactSubGeometry):void
		{
			throw new AbstractMethodError();
		}
		
		/**		 * Invalidates the primitive's geometry, causing it to be updated when requested.		 */
		public function pInvalidateGeometry():void
		{
			this._geomDirty = true;
		}
		
		/**		 * Invalidates the primitive's uv coordinates, causing them to be updated when requested.		 */
		public function pInvalidateUVs():void
		{
			this._uvDirty = true;
		}
		
		/**		 * Updates the geometry when invalid.		 */
		private function updateGeometry():void
		{
			this.pBuildGeometry(this._subGeometry);
			this._geomDirty = false;
		}
		
		/**		 * Updates the uv coordinates when invalid.		 */
		private function updateUVs():void
		{
			this.pBuildUVs(this._subGeometry);
			this._uvDirty = false;
		}
		
		override public function iValidate():void
		{
			if (this._geomDirty)
            {

                this.updateGeometry();

            }

			if (this._uvDirty)
            {

                this.updateUVs();

            }

		}
	}
}
