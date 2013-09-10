/** * @author Gary Paluk * @created 6/29/13 * @module away.geom */
package away.geom {

    public class Vector3D {

        public static var X_AXIS:Vector3D = new Vector3D( 1 , 0 , 0 );
        public static var Y_AXIS:Vector3D = new Vector3D( 0 , 1 , 0 );
        public static var Z_AXIS:Vector3D = new Vector3D( 0 , 0 , 1 );
        /**         * The first element of a Vector3D object, such as the x coordinate of a point in the three-dimensional space.         */
        public var x:Number;

        /*         *The second element of a Vector3D object, such as the y coordinate of a point in the three-dimensional space.         */
        public var y:Number;

        /**         * The third element of a Vector3D object, such as the y coordinate of a point in the three-dimensional space.         */
        public var z:Number;

        /**         * The fourth element of a Vector3D object (in addition to the x, y, and z properties) can hold data such as         * the angle of rotation.         */
        public var w:Number;

        /**         * Creates an instance of a Vector3D object.         */
        public function Vector3D(x:Number = 0, y:Number = 0, z:Number = 0, w:Number = 0):void {
                    x = x;
            y = y;
            z = z;
            w = w;
        }

        /**         * [read-only] The length, magnitude, of the current Vector3D object from the origin (0,0,0) to the object's         * x, y, and z coordinates.         * @returns The length of the Vector3D         */
        public function get length():Number {
                    return Math.sqrt(x * x + y * y + z * z);
        }

        /**         * [read-only] The square of the length of the current Vector3D object, calculated using the x, y, and z         * properties.         * @returns The squared length of the vector         */
        public function get lengthSquared():Number {
                    return (x * x + y * y + z * z);
        }

        /**         * Adds the value of the x, y, and z elements of the current Vector3D object to the values of the x, y, and z         * elements of another Vector3D object.         */
        public function add(a:Vector3D):Vector3D {
                    return new Vector3D(x + a.x, y + a.y, z + a.z, w + a.w)
        }

        /**         * [static] Returns the angle in radians between two vectors.         */
        public static function angleBetween(a:Vector3D, b:Vector3D):Number {
                    return Math.acos(a.dotProduct(b) / (a.length * b.length));
        }

        /**         * Returns a new Vector3D object that is an exact copy of the current Vector3D object.         */
        public function clone():Vector3D {
                    return new Vector3D(x, y, z, w);
        }

        /**         * Copies all of vector data from the source Vector3D object into the calling Vector3D object.         */
        public function copyFrom(src:Vector3D):void{
        
            x = src.x;
            y = src.y;
            z = src.z;
            w = src.w;

            //return new Vector3D(src.x, src.y, src.z, src.w);
        }

        /**         * Returns a new Vector3D object that is perpendicular (at a right angle) to the current Vector3D and another         * Vector3D object.         */
        public function crossProduct(a:Vector3D):Vector3D {
                    return new Vector3D(
                y * a.z - z * a.y,
                z * a.x - x * a.z,
                x * a.y - y * a.x,
                1
            );
        }

        /**         * Decrements the value of the x, y, and z elements of the current Vector3D object by the values of the x, y,         * and z elements of specified Vector3D object.         */
        public function decrementBy(a:Vector3D):void {
                    x -= a.x;
            y -= a.y;
            z -= a.z;
        }

        /**         * [static] Returns the distance between two Vector3D objects.         */
        public static function distance(pt1:Vector3D, pt2:Vector3D):Number {
                    var x: Number = (pt1.x - pt2.x);
            var y: Number = (pt1.y - pt2.y);
            var z: Number = (pt1.z - pt2.z);
            return Math.sqrt(x*x + y*y + z*z);
        }

        /**         * If the current Vector3D object and the one specified as the parameter are unit vertices, this method returns         * the cosine of the angle between the two vertices.         */
        public function dotProduct(a:Vector3D):Number {
                    return x * a.x + y * a.y + z * a.z;
        }

        /**         * Determines whether two Vector3D objects are equal by comparing the x, y, and z elements of the current         * Vector3D object with a specified Vector3D object.         */
        public function equals(cmp:Vector3D, allFour:Boolean = false):Boolean {
                    return (x == cmp.x && y == cmp.y && z == cmp.z && (!allFour || w == cmp.w ));
        }

        /**         * Increments the value of the x, y, and z elements of the current Vector3D object by the values of the x, y,         * and z elements of a specified Vector3D object.         */
        public function incrementBy(a:Vector3D):void {
                    x += a.x;
            y += a.y;
            z += a.z;
        }

        /**         * Compares the elements of the current Vector3D object with the elements of a specified Vector3D object to         * determine whether they are nearly equal.         */
        public function nearEquals(cmp:Vector3D, epsilon:Number, allFour:Boolean = true):Boolean {
                    return ((Math.abs(x - cmp.x) < epsilon)
                 && (Math.abs(y - cmp.y) < epsilon)
                 && (Math.abs(z - cmp.z) < epsilon)
                 && (!allFour || Math.abs(w - cmp.w) < epsilon));
        }

        /**         * Sets the current Vector3D object to its inverse.         */
        public function negate():void {
                    x = -x;
            y = -y;
            z = -z;
        }

        /**         * Converts a Vector3D object to a unit vector by dividing the first three elements (x, y, z) by the length of         * the vector.         */
        public function normalize():void {
                    var invLength = 1 / length;
            if (invLength != 0)
            {
                x *= invLength;
                y *= invLength;
                z *= invLength;
                return;
            }
            throw "Cannot divide by zero.";
        }

        /**         * Divides the value of the x, y, and z properties of the current Vector3D object by the value of its w         * property.         */
        public function project():void {
                    x /= w;
            y /= w;
            z /= w;
        }

        /**         * Scales the current Vector3D object by a scalar, a magnitude.         */
        public function scaleBy(s:Number):void {
                    x *= s;
            y *= s;
            z *= s;
        }

        /**         * Sets the members of Vector3D to the specified values         */
        public function setTo(xa:Number, ya:Number, za:Number):void {
                    x = xa;
            y = ya;
            z = za;
        }

        /**         * Subtracts the value of the x, y, and z elements of the current Vector3D object from the values of the x, y,         * and z elements of another Vector3D object.         */
        public function subtract(a:Vector3D):Vector3D {
                    return new Vector3D(x - a.x, y - a.y, z - a.z);
        }

        /**         * Returns a string representation of the current Vector3D object.         */
        public function toString():String {
                    return "[Vector3D] (x:" + x + " ,y:" + y + ", z" + z + ", w:" + w + ")";
        }

    }
}