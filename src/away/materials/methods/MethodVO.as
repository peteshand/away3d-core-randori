///<reference path="../../_definitions.ts"/>

package away.materials.methods
{
	/**	 * MethodVO contains data for a given method for the use within a single material.	 * This allows methods to be shared across materials while their non-public state differs.	 */
	public class MethodVO
	{
		public var vertexData:Vector.<Number>;
		public var fragmentData:Vector.<Number>;
		
		// public register indices
		public var texturesIndex:Number;
		public var secondaryTexturesIndex:Number// sometimes needed for composites		public var vertexConstantsIndex:Number;
		public var secondaryVertexConstantsIndex:Number// sometimes needed for composites		public var fragmentConstantsIndex:Number;
		public var secondaryFragmentConstantsIndex:Number// sometimes needed for composites		
		public var useMipmapping:Boolean;
		public var useSmoothTextures:Boolean;
		public var repeatTextures:Boolean;
		
		// internal stuff for the material to know before assembling code
		public var needsProjection:Boolean;
		public var needsView:Boolean;
		public var needsNormals:Boolean;
		public var needsTangents:Boolean;
		public var needsUV:Boolean;
		public var needsSecondaryUV:Boolean;
		public var needsGlobalVertexPos:Boolean;
		public var needsGlobalFragmentPos:Boolean;
		
		public var numLights:Number;
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
