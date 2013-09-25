/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package away.materials.methods
{
	/**	 * MethodVO contains data for a given method for the use within a single material.	 * This allows methods to be shared across materials while their non-public state differs.	 */
	public class MethodVO
	{
		public var vertexData:Vector.<Number>;
		public var fragmentData:Vector.<Number>;
		
		// public register indices
		public var texturesIndex:Number = 0;
		public var secondaryTexturesIndex:Number = 0;// sometimes needed for composites
		public var vertexConstantsIndex:Number = 0;
		public var secondaryVertexConstantsIndex:Number = 0;// sometimes needed for composites
		public var fragmentConstantsIndex:Number = 0;
		public var secondaryFragmentConstantsIndex:Number = 0;// sometimes needed for composites
		
		public var useMipmapping:Boolean = false;
		public var useSmoothTextures:Boolean = false;
		public var repeatTextures:Boolean = false;
		
		// internal stuff for the material to know before assembling code
		public var needsProjection:Boolean = false;
		public var needsView:Boolean = false;
		public var needsNormals:Boolean = false;
		public var needsTangents:Boolean = false;
		public var needsUV:Boolean = false;
		public var needsSecondaryUV:Boolean = false;
		public var needsGlobalVertexPos:Boolean = false;
		public var needsGlobalFragmentPos:Boolean = false;
		
		public var numLights:Number = 0;
		public var useLightFallOff:Boolean = true;

		/**		 * Creates a new MethodVO object.		 */
		public function MethodVO():void
		{
		
		}

		/**		 * Resets the values of the value object to their "unused" state.		 */
		public function reset():void
		{
			this.texturesIndex = -1;
            this.vertexConstantsIndex = -1;
            this.fragmentConstantsIndex = -1;

            this.useMipmapping = true;
            this.useSmoothTextures = true;
            this.repeatTextures = false;

            this.needsProjection = false;
            this.needsView = false;
            this.needsNormals = false;
            this.needsTangents = false;
            this.needsUV = false;
            this.needsSecondaryUV = false;
            this.needsGlobalVertexPos = false;
            this.needsGlobalFragmentPos = false;

            this.numLights = 0;
            this.useLightFallOff = true;
		}
	}
}
