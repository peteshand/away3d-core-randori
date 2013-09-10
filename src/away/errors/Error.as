
package away.errors
{

    public class Error
    {

        private var _errorID:Number = 0;   //Contains the reference number associated with the specific error message.        private var _messsage:String = '';  //Contains the message associated with the Error object.        private var _name:String = '';  // Contains the name of the Error object.
        public function Error(message:String = '', id:Number = 0, _name:String = ''):void
        {

            _messsage  = message;
            _name      = name;
            _errorID   = id;

        }

        /**         *         * @returns {string}         */
        public function get message():String
        {

            return _messsage;

        }

        /**         *         * @param value         */
        public function set message(value:String):void
        {

            _messsage = value;

        }

        /**         *         * @returns {string}         */
        public function get name():String
        {

            return _name;

        }

        /**         *         * @param value         */
        public function set name(value:String):void
        {

            _name = value;

        }

        /**         *         * @returns {number}         */
        public function get errorID():Number
        {

            return _errorID;

        }

    }

}