///<reference path="../../_definitions.ts"/>

package away.materials.methods
{
	/**
	public class MethodVO
	{
		public var vertexData:Vector.<Number>;
		public var fragmentData:Vector.<Number>;
		
		// public register indices
		public var texturesIndex:Number;
		public var secondaryTexturesIndex:Number; // sometimes needed for composites
		public var secondaryVertexConstantsIndex:Number; // sometimes needed for composites
		public var secondaryFragmentConstantsIndex:Number; // sometimes needed for composites
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

		/**
		public function MethodVO():void
		{
		
		}

		/**
		public function reset():void
		{
			texturesIndex = -1;
            vertexConstantsIndex = -1;
            fragmentConstantsIndex = -1;

            useMipmapping = true;
            useSmoothTextures = true;
            repeatTextures = false;

            needsProjection = false;
            needsView = false;
            needsNormals = false;
            needsTangents = false;
            needsUV = false;
            needsSecondaryUV = false;
            needsGlobalVertexPos = false;
            needsGlobalFragmentPos = false;

            numLights = 0;
            useLightFallOff = true;
		}
	}
}