/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package away.materials.methods
{
	//import away3d.arcane;

	/**	 * MethodVOSet provides a EffectMethodBase and MethodVO combination to be used by a material, allowing methods	 * to be shared across different materials while their internal state changes.	 */
	public class MethodVOSet
	{
		//use namespace arcane;

		/**		 * An instance of a concrete EffectMethodBase subclass.		 */
		public var method:EffectMethodBase;

		/**		 * The MethodVO data for the given method containing the material-specific data for a given material/method combination.		 */
		public var data:MethodVO;

		/**		 * Creates a new MethodVOSet object.		 * @param method The method for which we need to store a MethodVO object.		 */
		public function MethodVOSet(method:EffectMethodBase):void
		{
			this.method = method;
			this.data = method.iCreateMethodVO();
		}
	}
}
