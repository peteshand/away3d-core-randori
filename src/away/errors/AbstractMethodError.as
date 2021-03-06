/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package away.errors
{


	
	/**	 * AbstractMethodError is thrown when an abstract method is called. The method in question should be overridden	 * by a concrete subclass.	 */
	public class AbstractMethodError extends away.errors.Error
	{
		/**		 * Create a new AbstractMethodError.		 * @param message An optional message to override the default error message.		 * @param id The id of the error.		 */
		public function AbstractMethodError(message:String = null, id:Number = 0):void
		{
			message = message || null;
			id = id || 0;

			super(message || "An abstract method was called! Either an instance of an abstract class was created, or an abstract method was not overridden by the subclass.", id);
		}
	}
}
