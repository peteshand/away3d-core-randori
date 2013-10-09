/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package away.utils
{
	import away.errors.PartialImplementationError;
	import randori.webkit.page.Window;

    public class Debug
    {

        public static var THROW_ERRORS:Boolean = true;
        public static var ENABLE_LOG:Boolean = true;
        public static var LOG_PI_ERRORS:Boolean = true;

        private static var keyword:String = null;

        public static function breakpoint():void
        {
            Debug['break']();
        }

        public static function throwPIROnKeyWordOnly(str:String, enable:Boolean = true):void
        {

            if ( ! enable )
            {
                Debug.keyword = null;
            }
            else
            {
                Debug.keyword = str;
            }

        }

        public static function throwPIR(clss:String, fnc:String, msg:String):void
        {

            Debug.logPIR( 'PartialImplementationError '  + clss , fnc , msg );

            if ( Debug.THROW_ERRORS )
            {

                if ( Debug.keyword )
                {

                    var e : String = clss + fnc + msg;

                    if ( e.indexOf( Debug.keyword ) == -1 )
                    {
                        return;
                    }

                }

                throw new PartialImplementationError( clss + '.' + fnc + ': ' +  msg );

            }

        }

        private static function logPIR(clss:String, fnc:String, msg:String = ''):void
        {
			msg = msg || '';


            if ( Debug.LOG_PI_ERRORS )
            {

                Window.console.log( clss + '.' + fnc + ': ' +  msg );

            }

        }

        public static function log(...args:Array):void
        {

            if ( Debug.ENABLE_LOG )
            {

                Window.console.log.apply(Window.console, args);

            }

        }

    }

}
