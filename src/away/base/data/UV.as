
///<reference path="../../_definitions.ts"/>

package away.base.data
{

    /**     * Texture coordinates value object.     */
    public class UV
    {
        private var _u:Number;
        private var _v:Number;

        /**         * Creates a new <code>UV</code> object.         *         * @param    u        [optional]    The horizontal coordinate of the texture value. Defaults to 0.         * @param    v        [optional]    The vertical coordinate of the texture value. Defaults to 0.         */
        public function UV(u:Number = 0, v:Number = 0):void
        {
            this._u = u;
            this._v = v;
        }

        /**         * Defines the vertical coordinate of the texture value.         */
        public function get v():Number
        {
            return this._v;
        }

        public function set v(value:Number):void
        {
            this._v = value;
        }

        /**         * Defines the horizontal coordinate of the texture value.         */
        public function get u():Number
        {
            return this._u;
        }

        public function set u(value:Number):void
        {
            this._u = value;
        }

        /**         * returns a new UV value Object         */
        public function clone():UV
        {
            return new UV(this._u, this._v);
        }

        /**         * returns the value object as a string for trace/debug purpose         */
        public function toString():String
        {
            return this._u + "," + this._v;
        }

    }

}
