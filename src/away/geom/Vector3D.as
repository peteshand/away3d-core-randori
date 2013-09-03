/**
package away.geom {

    public class Vector3D {

        public static var X_AXIS:Vector3D = new Vector3D( 1 , 0 , 0 );
        public static var Y_AXIS:Vector3D = new Vector3D( 0 , 1 , 0 );
        public static var Z_AXIS:Vector3D = new Vector3D( 0 , 0 , 1 );
        /**
        public var x:Number;

        /*
        public var y:Number;

        /**
        public var z:Number;

        /**
        public var w:Number;

        /**
        public function Vector3D(x:Number = 0, y:Number = 0, z:Number = 0, w:Number = 0):void {
                    this.x = x;
            this.y = y;
            this.z = z;
            this.w = w;
        }

        /**
        public function get length():Number {
                    return Math.sqrt(x * x + y * y + z * z);
        }

        /**
        public function get lengthSquared():Number {
                    return (x * x + y * y + z * z);
        }

        /**
        public function add(a:Vector3D):Vector3D {
                    return new Vector3D(x + a.x, y + a.y, z + a.z, w + a.w)
        }

        /**
        public static function angleBetween(a:Vector3D, b:Vector3D):Number {
                    return Math.acos(a.dotProduct(b) / (a.length * b.length));
        }

        /**
        public function clone():Vector3D {
                    return new Vector3D(x, y, z, w);
        }

        /**
        public function copyFrom(src:Vector3D):void{
        
            x = src.x;
            y = src.y;
            z = src.z;
            w = src.w;

            //return new Vector3D(src.x, src.y, src.z, src.w);
        }

        /**
        public function crossProduct(a:Vector3D):Vector3D {
                    return new Vector3D(
                y * a.z - z * a.y,
                z * a.x - x * a.z,
                x * a.y - y * a.x,
                1
            );
        }

        /**
        public function decrementBy(a:Vector3D):void {
                    x -= a.x;
            y -= a.y;
            z -= a.z;
        }

        /**
        public static function distance(pt1:Vector3D, pt2:Vector3D):Number {
                    var x: Number = (pt1.x - pt2.x);
            var y: Number = (pt1.y - pt2.y);
            var z: Number = (pt1.z - pt2.z);
            return Math.sqrt(x*x + y*y + z*z);
        }

        /**
        public function dotProduct(a:Vector3D):Number {
                    return x * a.x + y * a.y + z * a.z;
        }

        /**
        public function equals(cmp:Vector3D, allFour:Boolean = false):Boolean {
                    return (x == cmp.x && y == cmp.y && z == cmp.z && (!allFour || w == cmp.w ));
        }

        /**
        public function incrementBy(a:Vector3D):void {
                    x += a.x;
            y += a.y;
            z += a.z;
        }

        /**
        public function nearEquals(cmp:Vector3D, epsilon:Number, allFour:Boolean = true):Boolean {
                    return ((Math.abs(x - cmp.x) < epsilon)
                 && (Math.abs(y - cmp.y) < epsilon)
                 && (Math.abs(z - cmp.z) < epsilon)
                 && (!allFour || Math.abs(w - cmp.w) < epsilon));
        }

        /**
        public function negate():void {
                    x = -x;
            y = -y;
            z = -z;
        }

        /**
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

        /**
        public function project():void {
                    x /= w;
            y /= w;
            z /= w;
        }

        /**
        public function scaleBy(s:Number):void {
                    x *= s;
            y *= s;
            z *= s;
        }

        /**
        public function setTo(xa:Number, ya:Number, za:Number):void {
                    x = xa;
            y = ya;
            z = za;
        }

        /**
        public function subtract(a:Vector3D):Vector3D {
                    return new Vector3D(x - a.x, y - a.y, z - a.z);
        }

        /**
        public function toString():String {
                    return "[Vector3D] (x:" + x + " ,y:" + y + ", z" + z + ", w:" + w + ")";
        }

    }
}