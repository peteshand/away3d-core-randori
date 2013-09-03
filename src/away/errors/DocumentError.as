/** * ... * @author Gary Paluk - http://www.plugin.io */

///<reference path="../_definitions.ts"/>

package away.errors
{
	
	public class DocumentError extends away.errors.Error
	{
		public static var DOCUMENT_DOES_NOT_EXIST:String = "documentDoesNotExist";
		
		public function DocumentError(message:String = "DocumentError", id:Number = 0):void
		{
			super( message, id );
		}
	}
}