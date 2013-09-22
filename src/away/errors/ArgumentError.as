///<reference path="../_definitions.ts"/>

package away.errors
{


	
	/**	 * AbstractMethodError is thrown when an abstract method is called. The method in question should be overridden	 * by a concrete subclass.	 */
	public class ArgumentError extends away.errors.Error
	{
		/**		 * Create a new AbstractMethodError.		 * @param message An optional message to override the default error message.		 * @param id The id of the error.		 */
		public function ArgumentError(message:String = null, id:Number = 0):void
		{
			message = message || null;
			id = id || 0;

			super(message || "ArgumentError", id);
		}
	}
}
