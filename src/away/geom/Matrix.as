
///<reference path="../_definitions.ts"/>

package away.geom
{
	import away.errors.ArgumentError;

    public class Matrix {

        public var a:Number;
        public var b:Number;
        public var c:Number;
        public var d:Number;
        public var tx:Number;
        public var ty:Number;

        public function Matrix(a:Number = 1, b:Number = 0, c:Number = 0, d:Number = 1, tx:Number = 0, ty:Number = 0):void
        {

            a      = a;
            b      = b;
            c      = c;
            d      = d;
            tx     = tx;
            ty     = ty;

        }

        /**         *         * @returns {away.geom.Matrix}         */
        public function clone():Matrix
        {

            return new Matrix ( a , b , c , d , tx , ty );

        }

        /**         *         * @param m         */
        public function concat(m:Matrix):void
        {

            var a1 = a * m.a + b * m.c;
            b = a * m.b + b * m.d;
            a = a1;

            var c1 = c * m.a + d * m.c;
            d = c * m.b + d * m.d;

            c = c1;

            var tx1 = tx * m.a + ty * m.c + m.tx;
            ty = tx * m.b + ty * m.d + m.ty;
            tx = tx1;

        }

        /**         *         * @param column         * @param vector3D         */
        public function copyColumnFrom(column:Number, vector3D:Vector3D):void
        {

            if (column > 2)
            {

                throw "Column " + column + " out of bounds (2)";

            }
            else if (column == 0)
            {

                a = vector3D.x;
                c = vector3D.y;

            }
            else if (column == 1)
            {

                b = vector3D.x;
                d = vector3D.y;

            }
            else
            {

                tx = vector3D.x;
                ty = vector3D.y;

            }

        }

        /**         *         * @param column         * @param vector3D         */
        public function copyColumnTo(column:Number, vector3D:Vector3D):void
        {

            if (column > 2)
            {

                throw new away.errors.ArgumentError( "ArgumentError, Column " + column + " out of bounds [0, ..., 2]");

            }
            else if (column == 0)
            {

                vector3D.x = a;
                vector3D.y = c;
                vector3D.z = 0;

            }
            else if (column == 1)
            {

                vector3D.x = b;
                vector3D.y = d;
                vector3D.z = 0;

            }
            else
            {

                vector3D.x = tx;
                vector3D.y = ty;
                vector3D.z = 1;

            }

        }

        /**         *         * @param other         */
        public function copyFrom(other:Matrix):void
        {

            a  = other.a;
            b  = other.b;
            c  = other.c;
            d  = other.d;
            tx = other.tx;
            ty = other.ty;

        }

        /**         *         * @param row         * @param vector3D         */
        public function copyRowFrom(row:Number, vector3D:Vector3D):void {
        
            if (row > 2)
            {

                throw new away.errors.ArgumentError( "ArgumentError, Row " + row + " out of bounds [0, ..., 2]");

            }
            else if (row == 0)
            {

                a = vector3D.x;
                c = vector3D.y;

            }
            else if (row == 1)
            {

                b = vector3D.x;
                d = vector3D.y;

            }
            else
            {

                tx = vector3D.x;
                ty = vector3D.y;

            }

        }

        /**         *         * @param row         * @param vector3D         */
        public function copyRowTo(row:Number, vector3D:Vector3D):void
        {

            if ( row > 2 )
            {

                throw new away.errors.ArgumentError( "ArgumentError, Row " + row + " out of bounds [0, ..., 2]");

            }
            else if (row == 0)
            {

                vector3D.x = a;
                vector3D.y = b;
                vector3D.z = tx;

            }
            else if (row == 1)
            {

                vector3D.x = c;
                vector3D.y = d;
                vector3D.z = ty;

            }
            else
            {

                vector3D.setTo (0, 0, 1);

            }

        }

        /**         *         * @param scaleX         * @param scaleY         * @param rotation         * @param tx         * @param ty         */
        public function createBox(scaleX:Number, scaleY:Number, rotation:Number = 0, tx:Number = 0, ty:Number = 0):void
        {

            a = scaleX;
            d = scaleY;
            b = rotation;
            tx = tx;
            ty = ty;

        }

        /**         *         * @param width         * @param height         * @param rotation         * @param tx         * @param ty         */
        public function createGradientBox(width:Number, height:Number, rotation:Number = 0, tx:Number = 0, ty:Number = 0):void
        {

            a = width / 1638.4;
            d = height / 1638.4;

            if (rotation != 0.0)
            {

                var cos = Math.cos (rotation);
                var sin = Math.sin (rotation);

                b = sin * d;
                c = -sin * a;
                a *= cos;
                d *= cos;

            }
            else
            {

                b = c = 0;

            }

            tx = tx + width / 2;
            ty = ty + height / 2;

        }

        /**         *         * @param point         * @returns {away.geom.Point}         */
        public function deltaTransformPoint(point:Point):Point
        {

            return new Point ( point.x * a + point.y * c, point.x * b + point.y * d );

        }

        /**         *         */
        public function identity():void
        {

            a = 1;
            b = 0;
            c = 0;
            d = 1;
            tx = 0;
            ty = 0;

        }

        /**         *         * @returns {away.geom.Matrix}         */
        public function invert():Matrix {
        
            var norm = a * d - b * c;

            if (norm == 0)
            {

                a = b = c = d = 0;
                tx = -tx;
                ty = -ty;

            }
            else
            {

                norm = 1.0 / norm;
                var a1 = d * norm;
                d = a * norm;
                a = a1;
                b *= -norm;
                c *= -norm;

                var tx1 = - a * tx - c * ty;
                ty = - b * tx - d * ty;
                tx = tx1;

            }

            return this;

        }

        /**         *         * @param m         * @returns {away.geom.Matrix}         */
        public function mult(m:Matrix):Matrix
        {

            var result = new Matrix ();

                result.a = a * m.a + b * m.c;
                result.b = a * m.b + b * m.d;
                result.c = c * m.a + d * m.c;
                result.d = c * m.b + d * m.d;

                result.tx = tx * m.a + ty * m.c + m.tx;
                result.ty = tx * m.b + ty * m.d + m.ty;

            return result;

        }

        /**         *         * @param angle         */
        public function rotate(angle:Number):void
        {

            var cos = Math.cos (angle);
            var sin = Math.sin (angle);

            var a1 = a * cos - b * sin;
            b = a * sin + b * cos;
            a = a1;

            var c1 = c * cos - d * sin;
            d = c * sin + d * cos;
            c = c1;

            var tx1 = tx * cos - ty * sin;
            ty = tx * sin + ty * cos;
            tx = tx1;

        }

        /**         *         * @param x         * @param y         */
        public function scale(x:Number, y:Number):void
        {

            a *= x;
            b *= y;

            c *= x;
            d *= y;

            tx *= x;
            ty *= y;

        }

        /**         *         * @param angle         * @param scale         */
        public function setRotation(angle:Number, scale:Number = 1):void
        {

            a = Math.cos (angle) * scale;
            c = Math.sin (angle) * scale;
            b = -c;
            d = a;

        }

        /**         *         * @param a         * @param b         * @param c         * @param d         * @param tx         * @param ty         */
        public function setTo(a:Number, b:Number, c:Number, d:Number, tx:Number, ty:Number):void
        {

            a = a;
            b = b;
            c = c;
            d = d;
            tx = tx;
            ty = ty;

        }

        /**         *         * @returns {string}         */
        public function toString():String
        {

            return "[Matrix] (a=" + a + ", b=" + b + ", c=" + c + ", d=" + d + ", tx=" + tx + ", ty=" + ty + ")";

        }

        /**         *         * @param point         * @returns {away.geom.Point}         */
        public function transformPoint(point:Point):Point
        {

            return new Point ( point.x * a + point.y * c + tx, point.x * b + point.y * d + ty );

        }

        /**         *         * @param x         * @param y         */
        public function translate(x:Number, y:Number):void
        {

            tx += x;
            ty += y;

        }


    }
}
