/** * ... * @author Gary Paluk - http://www.plugin.io */

///<reference path="../_definitions.ts"/>

package away.geom
{
	import away.errors.ArgumentError;
	
	public class Matrix3D
	{
		
		/**		 * A Vector of 16 Numbers, where every four elements is a column of a 4x4 matrix.		 *		 * <p>An exception is thrown if the rawData property is set to a matrix that is not invertible. The Matrix3D 		 * object must be invertible. If a non-invertible matrix is needed, create a subclass of the Matrix3D object.</p>		 */
		public var rawData:Vector.<Number>;
		
		/**		 * Creates a Matrix3D object.		 */
		public function Matrix3D(v:Vector.<Number> = null):void
		{
			if( v != null && v.length == 16 )
			{

				rawData = v;
			}
			else
			{
				rawData = new <Number>[ 1, 0, 0, 0,
								 0, 1, 0, 0,
								 0, 0, 1, 0,
								 0, 0, 0, 1 ];
			}
		}
		
		/**		 * Appends the matrix by multiplying another Matrix3D object by the current Matrix3D object.		 */
		public function append(lhs:Matrix3D):void
		{

            // Initial Tests - OK

			var m111:Number = rawData[0], m121:Number = rawData[4], m131:Number = rawData[8], m141:Number = rawData[12],
			m112:Number = rawData[1], m122:Number = rawData[5], m132:Number = rawData[9], m142:Number = rawData[13],
			m113:Number = rawData[2], m123:Number = rawData[6], m133:Number = rawData[10], m143:Number = rawData[14],
			m114:Number = rawData[3], m124:Number = rawData[7], m134:Number = rawData[11], m144:Number = rawData[15],
			m211:Number = lhs.rawData[0], m221:Number = lhs.rawData[4], m231:Number = lhs.rawData[8], m241:Number = lhs.rawData[12],
			m212:Number = lhs.rawData[1], m222:Number = lhs.rawData[5], m232:Number = lhs.rawData[9], m242:Number = lhs.rawData[13],
			m213:Number = lhs.rawData[2], m223:Number = lhs.rawData[6], m233:Number = lhs.rawData[10], m243:Number = lhs.rawData[14],
			m214:Number = lhs.rawData[3], m224:Number = lhs.rawData[7], m234:Number = lhs.rawData[11], m244:Number = lhs.rawData[15];
			
			rawData[0] = m111 * m211 + m112 * m221 + m113 * m231 + m114 * m241;
			rawData[1] = m111 * m212 + m112 * m222 + m113 * m232 + m114 * m242;
			rawData[2] = m111 * m213 + m112 * m223 + m113 * m233 + m114 * m243;
			rawData[3] = m111 * m214 + m112 * m224 + m113 * m234 + m114 * m244;
			
			rawData[4] = m121 * m211 + m122 * m221 + m123 * m231 + m124 * m241;
			rawData[5] = m121 * m212 + m122 * m222 + m123 * m232 + m124 * m242;
			rawData[6] = m121 * m213 + m122 * m223 + m123 * m233 + m124 * m243;
			rawData[7] = m121 * m214 + m122 * m224 + m123 * m234 + m124 * m244;
			
			rawData[8] = m131 * m211 + m132 * m221 + m133 * m231 + m134 * m241;
			rawData[9] = m131 * m212 + m132 * m222 + m133 * m232 + m134 * m242;
			rawData[10] = m131 * m213 + m132 * m223 + m133 * m233 + m134 * m243;
			rawData[11] = m131 * m214 + m132 * m224 + m133 * m234 + m134 * m244;
			
			rawData[12] = m141 * m211 + m142 * m221 + m143 * m231 + m144 * m241;
			rawData[13] = m141 * m212 + m142 * m222 + m143 * m232 + m144 * m242;
			rawData[14] = m141 * m213 + m142 * m223 + m143 * m233 + m144 * m243;
			rawData[15] = m141 * m214 + m142 * m224 + m143 * m234 + m144 * m244;
		}
		
		/**		 * Appends an incremental rotation to a Matrix3D object.		 */
		public function appendRotation(degrees:Number, axis:Vector3D):void //, pivotPoint:Vector3D = null )		{

            // Initial Tests - OK

			var m:Matrix3D = Matrix3D.getAxisRotation( axis.x, axis.y, axis.z, degrees );

            /*			if (pivotPoint != null) 			{				var p:Vector3D = pivotPoint;				m.appendTranslation( p.x, p.y, p.z );			}            */
			append(m);
		}
		
		/**		 * Appends an incremental scale change along the x, y, and z axes to a Matrix3D object.		 */
		public function appendScale(xScale:Number, yScale:Number, zScale:Number):void
		{

            // Initial Tests - OK

			append(new Matrix3D( new <Number>[ xScale, 0.0, 0.0, 0.0, 0.0, yScale, 0.0, 0.0, 0.0, 0.0, zScale, 0.0, 0.0, 0.0, 0.0, 1.0 ] ));
		}
		
		/**		 * Appends an incremental translation, a repositioning along the x, y, and z axes, to a Matrix3D object.		 */
		public function appendTranslation(x:Number, y:Number, z:Number):void 
		{

            // Initial Tests - OK

			rawData[12] += x;
			rawData[13] += y;
			rawData[14] += z;
		}
		
		/**		 * Returns a new Matrix3D object that is an exact copy of the current Matrix3D object.		 */
		public function clone():Matrix3D
		{

            // Initial Tests - OK

			return new Matrix3D( rawData.slice( 0 ) );
		}
		
		/**		 * Copies a Vector3D object into specific column of the calling Matrix3D object.		 */
		public function copyColumnFrom(column:Number, vector3D:Vector3D):void
		{

            // Initial Tests - OK

            switch( column )
            {
                case 0:
                    rawData[ 0 ] = vector3D.x;
                    rawData[ 1 ] = vector3D.y;
                    rawData[ 2 ] = vector3D.z;
                    rawData[ 3 ] = vector3D.w;
                    break;
                case 1:
                    rawData[ 4 ] = vector3D.x;
                    rawData[ 5 ] = vector3D.y;
                    rawData[ 6 ] = vector3D.z;
                    rawData[ 7 ] = vector3D.w;
                    break;
                case 2:
                    rawData[ 8 ] = vector3D.x;
                    rawData[ 9 ] = vector3D.y;
                    rawData[ 10 ] = vector3D.z;
                    rawData[ 11 ] = vector3D.w;
                    break;
                case 3:
                    rawData[ 12 ] = vector3D.x;
                    rawData[ 13 ] = vector3D.y;
                    rawData[ 14 ] = vector3D.z;
                    rawData[ 15 ] = vector3D.w;
                    break;
                default:
                    throw new away.errors.ArgumentError( "ArgumentError, Column " + column + " out of bounds [0, ..., 3]");
            }

		}
		
		/**		 * Copies specific column of the calling Matrix3D object into the Vector3D object.		 */
		public function copyColumnTo(column:Number, vector3D:Vector3D):void
		{

            // Initial Tests - OK

            switch( column )
            {
                case 0:
                    vector3D.x = rawData[ 0 ];
                    vector3D.y = rawData[ 1 ];
                    vector3D.z = rawData[ 2 ];
                    vector3D.w = rawData[ 3 ];
                    break;
                case 1:
                    vector3D.x = rawData[ 4 ];
                    vector3D.y = rawData[ 5 ];
                    vector3D.z = rawData[ 6 ];
                    vector3D.w = rawData[ 7 ];
                    break;
                case 2:
                    vector3D.x = rawData[ 8 ];
                    vector3D.y = rawData[ 9 ];
                    vector3D.z = rawData[ 10 ];
                    vector3D.w = rawData[ 11 ];
                    break;
                case 3:
                    vector3D.x = rawData[ 12 ];
                    vector3D.y = rawData[ 13 ];
                    vector3D.z = rawData[ 14 ];
                    vector3D.w = rawData[ 15 ];
                    break;
                default:
                    throw new away.errors.ArgumentError( "ArgumentError, Column " + column + " out of bounds [0, ..., 3]");
            }
		}
		
		/**		 * Copies all of the matrix data from the source Matrix3D object into the calling Matrix3D object.		 */
		public function copyFrom(sourceMatrix3D:Matrix3D):void
		{

            // Initial Tests - OK

            var l : Number = sourceMatrix3D.rawData.length;

            for ( var c : Number = 0 ; c < l ; c ++ )
            {
                rawData[c] = sourceMatrix3D.rawData[c];
            }

			//this.rawData = sourceMatrix3D.rawData.slice( 0 );
		}
		
		public function copyRawDataFrom(vector:Vector.<Number>, index:Number = 0, transposeThis:Boolean = false):void
		{
			// Initial Tests - OK
			if ( transposeThis )
            {
                transpose();
            }
			
            var l : Number = vector.length - index;
            for ( var c : Number = 0 ; c < l ; c ++ )
            {
                rawData[c] = vector[c+index];
            }
			
			if ( transposeThis )
            {
                transpose();
            }
		}
		
		public function copyRawDataTo(vector:Vector.<Number>, index:Number = 0, transposeThis:Boolean = false):void
		{

            // Initial Tests - OK


            if ( transposeThis )
            {
                transpose();
            }

            var l : Number = rawData.length
            for ( var c : Number = 0; c < l ; c ++ )
            {

                vector[c + index ] = rawData[c];

            }

            if ( transposeThis )
            {
                transpose();
            }

		}
		
		/**		 * Copies a Vector3D object into specific row of the calling Matrix3D object.		 */
		public function copyRowFrom(row:Number, vector3D:Vector3D):void
		{

            // Initial Tests - OK

            switch( row )
            {
                case 0:
                    rawData[ 0 ] = vector3D.x;
                    rawData[ 4 ] = vector3D.y;
                    rawData[ 8 ] = vector3D.z;
                    rawData[ 12 ] = vector3D.w;
                    break;
                case 1:
                    rawData[ 1 ] = vector3D.x;
                    rawData[ 5 ] = vector3D.y;
                    rawData[ 9 ] = vector3D.z;
                    rawData[ 13 ] = vector3D.w;
                    break;
                case 2:
                    rawData[ 2 ] = vector3D.x;
                    rawData[ 6 ] = vector3D.y;
                    rawData[ 10 ] = vector3D.z;
                    rawData[ 14 ] = vector3D.w;
                    break;
                case 3:
                    rawData[ 3 ] = vector3D.x;
                    rawData[ 7 ] = vector3D.y;
                    rawData[ 11 ] = vector3D.z;
                    rawData[ 15 ] = vector3D.w;
                    break;
                default:
                    throw new away.errors.ArgumentError( "ArgumentError, Row " + row + " out of bounds [0, ..., 3]");
            }
		}
		
		/**		 * Copies specific row of the calling Matrix3D object into the Vector3D object.		 */
		public function copyRowTo(row:Number, vector3D:Vector3D):void
		{

            // Initial Tests - OK

            switch( row )
            {
                case 0:
                    vector3D.x = rawData[ 0 ];
                    vector3D.y = rawData[ 4 ];
                    vector3D.z = rawData[ 8 ];
                    vector3D.w = rawData[ 12 ];
                    break;
                case 1:
                    vector3D.x = rawData[ 1 ];
                    vector3D.y = rawData[ 5 ];
                    vector3D.z = rawData[ 9 ];
                    vector3D.w = rawData[ 13 ];
                    break;
                case 2:
                    vector3D.x = rawData[ 2 ];
                    vector3D.y = rawData[ 6 ];
                    vector3D.z = rawData[ 10 ];
                    vector3D.w = rawData[ 14 ];
                    break;
                case 3:
                    vector3D.x = rawData[ 3 ];
                    vector3D.y = rawData[ 7 ];
                    vector3D.z = rawData[ 11 ];
                    vector3D.w = rawData[ 15 ]
                    break;
                default:
                    throw new away.errors.ArgumentError( "ArgumentError, Row " + row + " out of bounds [0, ..., 3]");
            }
		}
		
		/**		 * Copies this Matrix3D object into a destination Matrix3D object.		 */
		public function copyToMatrix3D(dest:Matrix3D):void
		{

            // Initial Tests - OK

			dest.rawData = rawData.slice(0);
		}
		
		// TODO orientationStyle:string = "eulerAngles"
		/**		 * Returns the transformation matrix's translation, rotation, and scale settings as a Vector of three Vector3D objects.		 */
		public function decompose():Vector.<Vector3D>
		{

            // Initial Tests - Not OK

			var vec:Vector.<Vector3D> = new Vector.<Vector3D>();
			var m = clone();
			var mr = m.rawData;

			var pos: Vector3D = new Vector3D( mr[12], mr[13], mr[14] );
			mr[12] = 0;
			mr[13] = 0;
			mr[14] = 0;
			
			var scale: Vector3D = new Vector3D();
			
			scale.x = Math.sqrt (mr[0] * mr[0] + mr[1] * mr[1] + mr[2] * mr[2]);
			scale.y = Math.sqrt (mr[4] * mr[4] + mr[5] * mr[5] + mr[6] * mr[6]);
			scale.z = Math.sqrt (mr[8] * mr[8] + mr[9] * mr[9] + mr[10] * mr[10]);
			
			if (mr[0] * (mr[5] * mr[10] - mr[6] * mr[9]) - mr[1] * (mr[4] * mr[10] - mr[6] * mr[8]) + mr[2] * (mr[4] * mr[9] - mr[5] * mr[8]) < 0)
			{
				scale.z = -scale.z;
			}
			
			mr[0] /= scale.x; 
			mr[1] /= scale.x; 
			mr[2] /= scale.x; 
			mr[4] /= scale.y; 
			mr[5] /= scale.y; 
			mr[6] /= scale.y; 
			mr[8] /= scale.z; 
			mr[9] /= scale.z; 
			mr[10] /= scale.z;
			
			var rot = new Vector3D ();
                rot.y = Math.asin( -mr[2]);

			var cos:Number = Math.cos(rot.y);
			
			if (cos > 0)
			{
				rot.x = Math.atan2 (mr[6], mr[10]);
				rot.z = Math.atan2 (mr[1], mr[0]);
			}
			else
			{
				rot.z = 0;
				rot.x = Math.atan2 (mr[4], mr[5]);
			} 
			
			vec.push(pos);
			vec.push(rot);
			vec.push(scale);

			return vec;
		}
		
		/**		 * Uses the transformation matrix without its translation elements to transform a Vector3D object from one space		 * coordinate to another.		 */
		public function deltaTransformVector(v:Vector3D):Vector3D
		{
			var x:Number = v.x, y:Number = v.y, z:Number = v.z;
			return new Vector3D (
						(x * rawData[0] + y * rawData[1] + z * rawData[2] + rawData[3]),
						(x * rawData[4] + y * rawData[5] + z * rawData[6] + rawData[7]),
						(x * rawData[8] + y * rawData[9] + z * rawData[10] + rawData[11]),
					0);
		}
		
		/**		 * Converts the current matrix to an identity or unit matrix.		 */
		public function identity():void
		{
			rawData = new <Number>[1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 ];
		}
		
		/**		 * [static] Interpolates the translation, rotation, and scale transformation of one matrix toward those of the target matrix.		 */
		public static function interpolate(thisMat:Matrix3D, toMat:Matrix3D, percent:Number):Matrix3D
		{
			var m:Matrix3D = new Matrix3D();
			for( var i: Number = 0; i < 16; ++i )
			{
				m.rawData[i] = thisMat.rawData[i] + (toMat.rawData[i] - thisMat.rawData[i]) * percent;
			}
			return m;
		}
		
		/**		 * Interpolates this matrix towards the translation, rotation, and scale transformations of the target matrix.		 */
		public function interpolateTo(toMat:Matrix3D, percent:Number):void
		{
            for( var i: Number = 0; i < 16; ++i )
            {
                rawData[i] = rawData[i] + (toMat.rawData[i] - rawData[i]) * percent;
            }
		}
		
		/**		 * Inverts the current matrix.		 */
		public function invert():Boolean
		{

            // Initial Tests - OK

			var d = determinant;
			var invertable = Math.abs (d) > 0.00000000001;
			
			if (invertable)
			{
				d = 1 / d;
				var m11:Number = rawData[0]; var m21:Number = rawData[4]; var m31:Number = rawData[8]; var m41:Number = rawData[12];
				var m12:Number = rawData[1]; var m22:Number = rawData[5]; var m32:Number = rawData[9]; var m42:Number = rawData[13];
				var m13:Number = rawData[2]; var m23:Number = rawData[6]; var m33:Number = rawData[10]; var m43:Number = rawData[14];
				var m14:Number = rawData[3]; var m24:Number = rawData[7]; var m34:Number = rawData[11]; var m44:Number = rawData[15];
				
				rawData[0] = d * (m22 * (m33 * m44 - m43 * m34) - m32 * (m23 * m44 - m43 * m24) + m42 * (m23 * m34 - m33 * m24));
				rawData[1] = -d * (m12 * (m33 * m44 - m43 * m34) - m32 * (m13 * m44 - m43 * m14) + m42 * (m13 * m34 - m33 * m14));
				rawData[2] = d * (m12 * (m23 * m44 - m43 * m24) - m22 * (m13 * m44 - m43 * m14) + m42 * (m13 * m24 - m23 * m14));
				rawData[3] = -d * (m12 * (m23 * m34 - m33 * m24) - m22 * (m13 * m34 - m33 * m14) + m32 * (m13 * m24 - m23 * m14));
				rawData[4] = -d * (m21 * (m33 * m44 - m43 * m34) - m31 * (m23 * m44 - m43 * m24) + m41 * (m23 * m34 - m33 * m24));
				rawData[5] = d * (m11 * (m33 * m44 - m43 * m34) - m31 * (m13 * m44 - m43 * m14) + m41 * (m13 * m34 - m33 * m14));
				rawData[6] = -d * (m11 * (m23 * m44 - m43 * m24) - m21 * (m13 * m44 - m43 * m14) + m41 * (m13 * m24 - m23 * m14));
				rawData[7] = d * (m11 * (m23 * m34 - m33 * m24) - m21 * (m13 * m34 - m33 * m14) + m31 * (m13 * m24 - m23 * m14));
				rawData[8] = d * (m21 * (m32 * m44 - m42 * m34) - m31 * (m22 * m44 - m42 * m24) + m41 * (m22 * m34 - m32 * m24));
				rawData[9] = -d * (m11 * (m32 * m44 - m42 * m34) - m31 * (m12 * m44 - m42 * m14) + m41 * (m12 * m34 - m32 * m14));
				rawData[10] = d * (m11 * (m22 * m44 - m42 * m24) - m21 * (m12 * m44 - m42 * m14) + m41 * (m12 * m24 - m22 * m14));
				rawData[11] = -d * (m11 * (m22 * m34 - m32 * m24) - m21 * (m12 * m34 - m32 * m14) + m31 * (m12 * m24 - m22 * m14));
				rawData[12] = -d * (m21 * (m32 * m43 - m42 * m33) - m31 * (m22 * m43 - m42 * m23) + m41 * (m22 * m33 - m32 * m23));
				rawData[13] = d * (m11 * (m32 * m43 - m42 * m33) - m31 * (m12 * m43 - m42 * m13) + m41 * (m12 * m33 - m32 * m13));
				rawData[14] = -d * (m11 * (m22 * m43 - m42 * m23) - m21 * (m12 * m43 - m42 * m13) + m41 * (m12 * m23 - m22 * m13));
				rawData[15] = d * (m11 * (m22 * m33 - m32 * m23) - m21 * (m12 * m33 - m32 * m13) + m31 * (m12 * m23 - m22 * m13));
			}
			return invertable;
		}
		
		/* TODO implement pointAt		public pointAt( pos:Vector3D, at:Vector3D = null, up:Vector3D = null )		{		}		*/
		
		/**		 * Prepends a matrix by multiplying the current Matrix3D object by another Matrix3D object.		 */
		public function prepend(rhs:Matrix3D):void
		{

            // Initial Tests - OK

			var m111:Number = rhs.rawData[0], m121:Number = rhs.rawData[4], m131:Number = rhs.rawData[8], m141:Number = rhs.rawData[12],
			m112:Number = rhs.rawData[1], m122:Number = rhs.rawData[5], m132:Number = rhs.rawData[9], m142:Number = rhs.rawData[13],
			m113:Number = rhs.rawData[2], m123:Number = rhs.rawData[6], m133:Number = rhs.rawData[10], m143:Number = rhs.rawData[14],
			m114:Number = rhs.rawData[3], m124:Number = rhs.rawData[7], m134:Number = rhs.rawData[11], m144:Number = rhs.rawData[15],
			m211:Number = rawData[0], m221:Number = rawData[4], m231:Number = rawData[8], m241:Number = rawData[12],
			m212:Number = rawData[1], m222:Number = rawData[5], m232:Number = rawData[9], m242:Number = rawData[13],
			m213:Number = rawData[2], m223:Number = rawData[6], m233:Number = rawData[10], m243:Number = rawData[14],
			m214:Number = rawData[3], m224:Number = rawData[7], m234:Number = rawData[11], m244:Number = rawData[15];
			
			rawData[0] = m111 * m211 + m112 * m221 + m113 * m231 + m114 * m241;
			rawData[1] = m111 * m212 + m112 * m222 + m113 * m232 + m114 * m242;
			rawData[2] = m111 * m213 + m112 * m223 + m113 * m233 + m114 * m243;
			rawData[3] = m111 * m214 + m112 * m224 + m113 * m234 + m114 * m244;
			
			rawData[4] = m121 * m211 + m122 * m221 + m123 * m231 + m124 * m241;
			rawData[5] = m121 * m212 + m122 * m222 + m123 * m232 + m124 * m242;
			rawData[6] = m121 * m213 + m122 * m223 + m123 * m233 + m124 * m243;
			rawData[7] = m121 * m214 + m122 * m224 + m123 * m234 + m124 * m244;
			
			rawData[8] = m131 * m211 + m132 * m221 + m133 * m231 + m134 * m241;
			rawData[9] = m131 * m212 + m132 * m222 + m133 * m232 + m134 * m242;
			rawData[10] = m131 * m213 + m132 * m223 + m133 * m233 + m134 * m243;
			rawData[11] = m131 * m214 + m132 * m224 + m133 * m234 + m134 * m244;
			
			rawData[12] = m141 * m211 + m142 * m221 + m143 * m231 + m144 * m241;
			rawData[13] = m141 * m212 + m142 * m222 + m143 * m232 + m144 * m242;
			rawData[14] = m141 * m213 + m142 * m223 + m143 * m233 + m144 * m243;
			rawData[15] = m141 * m214 + m142 * m224 + m143 * m234 + m144 * m244;
		}
		
		/**		 * Prepends an incremental rotation to a Matrix3D object.		 */
		public function prependRotation(degrees:Number, axis:Vector3D):void //, pivotPoint:Vector3D = null )		{

            // Initial Tests - OK

			var m: Matrix3D = Matrix3D.getAxisRotation( axis.x, axis.y, axis.z, degrees );

            /*			if ( pivotPoint != null )			{				var p:Vector3D = pivotPoint;				m.appendTranslation( p.x, p.y, p.z );			}			*/
			prepend( m );
		}
		
		/**		 * Prepends an incremental scale change along the x, y, and z axes to a Matrix3D object.		 */
		public function prependScale(xScale:Number, yScale:Number, zScale:Number):void
		{

            // Initial Tests - OK

			prepend(new Matrix3D( new <Number>[ xScale, 0, 0, 0, 0, yScale, 0, 0, 0, 0, zScale, 0, 0, 0, 0, 1 ] ));
		}
		
		/**		 * Prepends an incremental translation, a repositioning along the x, y, and z axes, to a Matrix3D object.		 */
		public function prependTranslation(x:Number, y:Number, z:Number):void
		{

            // Initial Tests - OK

			var m = new Matrix3D();
			m.position = new Vector3D( x, y, z );
			prepend( m );
		}
		
		// TODO orientationStyle
		/**		 * Sets the transformation matrix's translation, rotation, and scale settings.		 */
		public function recompose(components:Vector.<Vector3D>):Boolean
		{

            // Initial Tests - OK

			if (components.length < 3 ) return false

            //components[2].x == 0 || components[2].y == 0 || components[2].z == 0) return false;
			
			identity();
			appendScale (components[2].x, components[2].y, components[2].z);
			
			var angle:Number;
			angle = -components[1].x;
			append (new Matrix3D( new <Number>[1, 0, 0, 0, 0, Math.cos(angle), -Math.sin(angle), 0, 0, Math.sin(angle), Math.cos(angle), 0, 0, 0, 0 , 0]));
			angle = -components[1].y;
			append (new Matrix3D( new <Number>[Math.cos(angle), 0, Math.sin(angle), 0, 0, 1, 0, 0, -Math.sin(angle), 0, Math.cos(angle), 0, 0, 0, 0, 0]));
			angle = -components[1].z;
			append (new Matrix3D( new <Number>[Math.cos(angle), -Math.sin(angle), 0, 0, Math.sin(angle), Math.cos(angle), 0, 0, 0, 0, 1, 0, 0, 0, 0, 0]));
			
			position = components[0];
			rawData[15] = 1;
			
			return true;
		}

		public function transformVector(v:Vector3D):Vector3D
		{

            // Initial Tests - OK

			var x:Number = v.x;
			var y:Number = v.y;
			var z:Number = v.z;
			return new Vector3D(
				(x * rawData[0] + y * rawData[4] + z * rawData[8] + rawData[12]),
				(x * rawData[1] + y * rawData[5] + z * rawData[9] + rawData[13]),
                (x * rawData[2] + y * rawData[6] + z * rawData[10] + rawData[14]),
                (x * rawData[3] + y * rawData[7] + z * rawData[11] + rawData[15]));
			
		}

		/**		 * Uses the transformation matrix to transform a Vector of Numbers from one coordinate space to another.		 */
		public function transformVectors(vin:Vector.<Number>, vout:Vector.<Number>):void
		{

            // Initial Tests - OK

			var i:Number = 0;
			var x:Number = 0, y:Number = 0, z:Number = 0;
			
			while( i + 3 <= vin.length )
			{
				x = vin[i];
				y = vin[i + 1];
				z = vin[i + 2];
				vout[i] = x * rawData[0] + y * rawData[4] + z * rawData[8] + rawData[12];
				vout[i + 1] = x * rawData[1] + y * rawData[5] + z * rawData[9] + rawData[13];
				vout[i + 2] = x * rawData[2] + y * rawData[6] + z * rawData[10] + rawData[14];
				i += 3;
			}
		}

		/**		 * Converts the current Matrix3D object to a matrix where the rows and columns are swapped.		 */
		public function transpose():void
		{

            // Initial Tests - OK

			var oRawData:Vector.<Number> = rawData.slice( 0 );
			
			rawData[1] = oRawData[4];
			rawData[2] = oRawData[8];
			rawData[3] = oRawData[12];
			rawData[4] = oRawData[1];
			rawData[6] = oRawData[9];
			rawData[7] = oRawData[13];
			rawData[8] = oRawData[2];
			rawData[9] = oRawData[6];
			rawData[11] = oRawData[14];
			rawData[12] = oRawData[3];
			rawData[13] = oRawData[7];
			rawData[14] = oRawData[11];
		}
		
		public static function getAxisRotation(x:Number, y:Number, z:Number, degrees:Number):Matrix3D
		{

            // internal class use by rotations which have been tested

			var m:Matrix3D = new Matrix3D();
			
			var a1:Vector3D = new Vector3D( x, y, z );
			var rad = -degrees * ( Math.PI / 180 );
			var c:Number = Math.cos( rad );
			var s:Number = Math.sin( rad );
			var t:Number = 1.0 - c;
			
			m.rawData[0] = c + a1.x * a1.x * t;
			m.rawData[5] = c + a1.y * a1.y * t;
			m.rawData[10] = c + a1.z * a1.z * t;
			
			var tmp1 = a1.x * a1.y * t;
			var tmp2 = a1.z * s;
			m.rawData[4] = tmp1 + tmp2;
			m.rawData[1] = tmp1 - tmp2;
			tmp1 = a1.x * a1.z * t;
			tmp2 = a1.y * s;
			m.rawData[8] = tmp1 - tmp2;
			m.rawData[2] = tmp1 + tmp2;
			tmp1 = a1.y * a1.z * t;
			tmp2 = a1.x*s;
			m.rawData[9] = tmp1 + tmp2;
			m.rawData[6] = tmp1 - tmp2;
			
			return m;
		}
		
		/**		 * [read-only] A Number that determines whether a matrix is invertible.		 */
		public function get determinant():Number
		{

            // Initial Tests - OK

			return	((rawData[0] * rawData[5] - rawData[4] * rawData[1]) * (rawData[10] * rawData[15] - rawData[14] * rawData[11])
				- (rawData[0] * rawData[9] - rawData[8] * rawData[1]) * (rawData[6] * rawData[15] - rawData[14] * rawData[7])
				+ (rawData[0] * rawData[13] - rawData[12] * rawData[1]) * (rawData[6] * rawData[11] - rawData[10] * rawData[7])
				+ (rawData[4] * rawData[9] - rawData[8] * rawData[5]) * (rawData[2] * rawData[15] - rawData[14] * rawData[3])
				- (rawData[4] * rawData[13] - rawData[12] * rawData[5]) * (rawData[2] * rawData[11] - rawData[10] * rawData[3])
				+ (rawData[8] * rawData[13] - rawData[12] * rawData[9]) * (rawData[2] * rawData[7] - rawData[6] * rawData[3]));
		}
		
		/**		 * A Vector3D object that holds the position, the 3D coordinate (x,y,z) of a display object within the		 * transformation's frame of reference.		 */
		public function get position():Vector3D
		{

            // Initial Tests - OK

			return new Vector3D( rawData[12], rawData[13], rawData[14] );
		}
		
		public function set position(value:Vector3D):void
		{

            // Initial Tests - OK

			rawData[12] = value.x;
			rawData[13] = value.y;
			rawData[14] = value.z;
		}
	}
}