/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package away.loaders.misc
{
	import away.events.IEventDispatcher;
	import away.net.URLRequest;
    /**     * Interface between SingleFileLoader, and a TypeScript / JavaScript system. JS Does not gracefully convert loaded ByteArrays, BufferArrays, or Blobs to     * Bitmaps. ]     *     * So we have two Types of loaders which need a common interface :     *     *      IMGLoader ( for images )     *      URLLoader ( for data - XMLHttpRequest: text / variables / blobs / Array Buffers / binary data )     *     * Which kind of loader a Parser is going to require will need to be specified in ParserBase.     *     */
    public interface ISingleFileTSLoader extends IEventDispatcher {

        function get data():*; // GET        function get dataFormat():String;
        function set dataFormat(value:String):void;
        function load(rep:URLRequest):void;
        function dispose():void;


    }

}
