/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package away.errors
{

    public class Error
    {

        private var _errorID:Number = 0;//Contains the reference number associated with the specific error message.
        private var _messsage:String = '';//Contains the message associated with the Error object.
        private var _name:String = '';// Contains the name of the Error object.

        public function Error(message:String = '', id:Number = 0, _name:String = ''):void
        {
			message = message || '';
			id = id || 0;
			_name = _name || '';


            this._messsage  = message;
            this._name      = name;
            this._errorID   = id;

        }

        /**         *         * @returns {string}         */
        public function get message():String
        {

            return this._messsage;

        }

        /**         *         * @param value         */
        public function set message(value:String):void
        {

            this._messsage = value;

        }

        /**         *         * @returns {string}         */
        public function get name():String
        {

            return this._name;

        }

        /**         *         * @param value         */
        public function set name(value:String):void
        {

            this._name = value;

        }

        /**         *         * @returns {number}         */
        public function get errorID():Number
        {

            return this._errorID;

        }

    }

}