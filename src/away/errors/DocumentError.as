/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package away.errors
{
	
	public class DocumentError extends away.errors.Error
	{
		public static var DOCUMENT_DOES_NOT_EXIST:String = "documentDoesNotExist";
		
		public function DocumentError(message:String = "DocumentError", id:Number = 0):void
		{
			message = message || "DocumentError";
			id = id || 0;

			super( message, id );
		}
	}
}