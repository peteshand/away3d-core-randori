///<reference path="../_definitions.ts"/>

package away.geom
{
    /**     * A Quaternion object which can be used to represent rotations.     */
    public class Orientation3D
    {

        public static var AXIS_ANGLE:String//[static] The axis angle orientation uses a combination of an axis and an angle to determine the orientation. = "axisAngle";
        public static var EULER_ANGLES:String//[static] Euler angles, the default orientation for decompose() and recompose() methods, defines the orientation with three separate angles of rotation for each axis. = "eulerAngles";
        public static var QUATERNION:String//[static] The quaternion orientation uses complex numbers. = "quaternion";

    }


}