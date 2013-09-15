///<reference path="../_definitions.ts"/>

package away.geom
{
    /**     * A Quaternion object which can be used to represent rotations.     */
    public class Orientation3D
    {

        public static var AXIS_ANGLE:String = "axisAngle";      //[static] The axis angle orientation uses a combination of an axis and an angle to determine the orientation.        public static var EULER_ANGLES:String = "eulerAngles";    //[static] Euler angles, the default orientation for decompose() and recompose() methods, defines the orientation with three separate angles of rotation for each axis.        public static var QUATERNION:String = "quaternion";     //[static] The quaternion orientation uses complex numbers.
    }


}