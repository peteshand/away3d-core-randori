package
{

    /**
     * Created with IntelliJ IDEA.
     * User: pete
     * Date: 21/09/13
     * Time: 2:41 PM
     * To change this template use File | Settings | File Templates.
     */
    [JavaScript(export="false", name="DataView")]
    public class DataView {
        public function DataView(buffer:ArrayBuffer, byteOffset=0, byteLength=0)
        {

        }

        public function getInt8(byteOffset:uint):*
        {
            return null;
        }

        public function getUint8(byteOffset:uint):*
        {
            return null;
        }

        public function getInt16(byteOffset:uint,littleEndian:Boolean = null):int
        {
            return 0;
        }

        public function getUint16(byteOffset:uint,littleEndian:Boolean = null):uint
        {
            return 0;
        }

        public function getInt32(byteOffset:uint,littleEndian:Boolean = null):uint
        {
            return 0;
        }
        public function getUint32(byteOffset:uint,littleEndian:Boolean = null):uint
        {
            return 0;
        }
        public function getFloat32(byteOffset:uint,littleEndian:Boolean = null):Number
        {
            return 0;
        }

        public function getFloat64(byteOffset:uint,littleEndian:Boolean = null):Number
        {
            return 0;
        }

        public function setInt8():void
        {

        }

        public function setUint8():void
        {

        }

        public function setInt16(byteOffset:uint,value:int = null,littleEndian:Boolean = null):void
        {

        }

        public function setUint16(byteOffset:uint,value:uint = null,littleEndian:Boolean = null):void
        {

        }

        public function setUint32(byteOffset:uint,value:uint = null,littleEndian:Boolean = null):void
        {

        }

        public function setFloat32(byteOffset:uint,value:Number = 0,littleEndian:Boolean = null):void
        {

        }

        public function setFloat64(byteOffset:uint,value:Number = 0,littleEndian:Boolean = null):void
        {

        }
    }
}