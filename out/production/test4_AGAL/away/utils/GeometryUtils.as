/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package away.utils
{
	import away.core.base.ISubGeometry;
	import away.core.base.CompactSubGeometry;
	import away.core.base.SkinnedSubGeometry;
	import away.core.base.SubMesh;

	public class GeometryUtils
	{
		/**		 * Build a list of sub-geometries from raw data vectors, splitting them up in		 * such a way that they won't exceed buffer length limits.		 */
		public static function fromVectors(verts:Vector.<Number>, indices:Vector.<Number>/*uint*/, uvs:Vector.<Number>, normals:Vector.<Number>, tangents:Vector.<Number>, weights:Vector.<Number>, jointIndices:Vector.<Number>, triangleOffset:Number = 0):Vector.<ISubGeometry>
		{
			triangleOffset = triangleOffset || 0;

			var LIMIT_VERTS     : Number = 3*0xffff;
            var LIMIT_INDICES   : Number = 15*0xffff;
			
			var subs:Vector.<ISubGeometry> = new Vector.<ISubGeometry>();

			if (uvs && !uvs.length)
				uvs = null;
			
			if (normals && !normals.length)
				normals = null;
			
			if (tangents && !tangents.length)
				tangents = null;
			
			if (weights && !weights.length)
				weights = null;
			
			if (jointIndices && !jointIndices.length)
				jointIndices = null;
			
			if ((indices.length >= LIMIT_INDICES) || (verts.length >= LIMIT_VERTS))
            {

				var i:Number;
                var len:Number;
                var outIndex:Number;
                var j:Number;
				var splitVerts:Vector.<Number> = VectorInit.Num();
				var splitIndices:Vector.<Number> /*uint*/ = VectorInit.Num();
				var splitUvs:Vector.<Number> = (uvs != null)? VectorInit.Num() : null;
				var splitNormals:Vector.<Number> = (normals != null)? VectorInit.Num() : null;
				var splitTangents:Vector.<Number> = (tangents != null)? VectorInit.Num() : null;
				var splitWeights:Vector.<Number> = (weights != null)? VectorInit.Num() : null;
				var splitJointIndices:Vector.<Number> = (jointIndices != null)? VectorInit.Num() : null;
				
				var mappings:Vector.<Number> = VectorInit.Num( verts.length/3 );

				i = mappings.length;

				while (i-- > 0)
                {
					mappings[i] = -1;
                }

				var originalIndex:Number;
				var splitIndex:Number;
				var o0:Number;
                var o1:Number;
                var o2:Number;
                var s0:Number;
                var s1:Number;
                var s2:Number;
                var su:Number;
                var ou:Number;
                var sv:Number;
                var ov:Number;
				// Loop over all triangles
				outIndex = 0;
				len = indices.length;
				
				for (i = 0; i < len; i += 3)
                {

					splitIndex = splitVerts.length + 6;
					
					if (( (outIndex + 2) >= LIMIT_INDICES) || (splitIndex >= LIMIT_VERTS))
                    {
						subs.push(GeometryUtils.constructSubGeometry(splitVerts, splitIndices, splitUvs, splitNormals, splitTangents, splitWeights, splitJointIndices, triangleOffset));
						splitVerts = VectorInit.Num();
						splitIndices = VectorInit.Num();
						splitUvs = (uvs != null) ? VectorInit.Num() : null;
						splitNormals = (normals != null)? VectorInit.Num() : null;
						splitTangents = (tangents != null)? VectorInit.Num() : null;
						splitWeights = (weights != null)? VectorInit.Num() : null;
						splitJointIndices = (jointIndices != null)? VectorInit.Num() : null;
						splitIndex = 0;
						j = mappings.length;

						while (j-- > 0)
                        {
							mappings[j] = -1;
                        }

						outIndex = 0;
					}
					
					// Loop over all vertices in triangle
					for (j = 0; j < 3; j++)
                    {
						
						originalIndex = indices[i + j];
						
						if (mappings[originalIndex] >= 0)
                        {
							splitIndex = mappings[originalIndex];

                        }
						else
                        {
							
							o0 = originalIndex*3 + 0;
							o1 = originalIndex*3 + 1;
							o2 = originalIndex*3 + 2;
							
							// This vertex does not yet exist in the split list and
							// needs to be copied from the long list.
							splitIndex = splitVerts.length/3;
							
							s0 = splitIndex*3 + 0;
							s1 = splitIndex*3 + 1;
							s2 = splitIndex*3 + 2;
							
							splitVerts[s0] = verts[o0];
							splitVerts[s1] = verts[o1];
							splitVerts[s2] = verts[o2];
							
							if (uvs) {
								su = splitIndex*2 + 0;
								sv = splitIndex*2 + 1;
								ou = originalIndex*2 + 0;
								ov = originalIndex*2 + 1;
								
								splitUvs[su] = uvs[ou];
								splitUvs[sv] = uvs[ov];
							}
							
							if (normals) {
								splitNormals[s0] = normals[o0];
								splitNormals[s1] = normals[o1];
								splitNormals[s2] = normals[o2];
							}
							
							if (tangents) {
								splitTangents[s0] = tangents[o0];
								splitTangents[s1] = tangents[o1];
								splitTangents[s2] = tangents[o2];
							}
							
							if (weights) {
								splitWeights[s0] = weights[o0];
								splitWeights[s1] = weights[o1];
								splitWeights[s2] = weights[o2];
							}
							
							if (jointIndices) {
								splitJointIndices[s0] = jointIndices[o0];
								splitJointIndices[s1] = jointIndices[o1];
								splitJointIndices[s2] = jointIndices[o2];
							}
							
							mappings[originalIndex] = splitIndex;
						}
						
						// Store new index, which may have come from the mapping look-up,
						// or from copying a new set of vertex data from the original vector
						splitIndices[outIndex + j] = splitIndex;
					}
					
					outIndex += 3;
				}
				
				if (splitVerts.length > 0) {
					// More was added in the last iteration of the loop.
					subs.push(GeometryUtils.constructSubGeometry(splitVerts, splitIndices, splitUvs, splitNormals, splitTangents, splitWeights, splitJointIndices, triangleOffset));
				}
				
			} else
            {
				subs.push(GeometryUtils.constructSubGeometry(verts, indices, uvs, normals, tangents, weights, jointIndices, triangleOffset));
            }

			return subs;
		}
		
		/**		 * Build a sub-geometry from data vectors.		 */
		public static function constructSubGeometry(verts:Vector.<Number>, indices:Vector.<Number>/*uint*/, uvs:Vector.<Number>, normals:Vector.<Number>, tangents:Vector.<Number>, weights:Vector.<Number>, jointIndices:Vector.<Number>, triangleOffset:Number):CompactSubGeometry
		{
			var sub:CompactSubGeometry;
			
			if (weights && jointIndices)
            {
				// If there were weights and joint indices defined, this
				// is a skinned mesh and needs to be built from skinned
				// sub-geometries.

                //TODO: implement dependency: SkinnedSubGeometry
                Debug.throwPIR( 'GeometryUtils' , 'constructSubGeometry' , 'Dependency: SkinnedSubGeometry');

                //*
				sub = new SkinnedSubGeometry(weights.length/(verts.length/3));

                var ssg : SkinnedSubGeometry = (sub as SkinnedSubGeometry);

                    //ssg.updateJointWeightsData(weights);
                    //ssg.updateJointWeightsData(weights);
                    //ssg.updateJointIndexData(jointIndices);
				//*/
				
			}
            else
            {
				sub = new CompactSubGeometry();

            }

			sub.updateIndexData(indices);
			sub.fromVectors(verts, uvs, normals, tangents);

			return sub;
		}
		
		/*		 * Combines a set of separate raw buffers into an interleaved one, compatible		 * with CompactSubGeometry. SubGeometry uses separate buffers, whereas CompactSubGeometry		 * uses a single, combined buffer.		 * */
		public static function interleaveBuffers(numVertices:Number, vertices:Vector.<Number> = null, normals:Vector.<Number> = null, tangents:Vector.<Number> = null, uvs:Vector.<Number> = null, suvs:Vector.<Number> = null):Vector.<Number>
		{
			
			var i:Number, compIndex:Number, uvCompIndex:Number, interleavedCompIndex:Number;
			var interleavedBuffer:Vector.<Number>;
			
			interleavedBuffer = VectorInit.Num();
			
			/**			 * 0 - 2: vertex position X, Y, Z			 * 3 - 5: normal X, Y, Z			 * 6 - 8: tangent X, Y, Z			 * 9 - 10: U V			 * 11 - 12: Secondary U V			 */
			for (i = 0; i < numVertices; ++i)
            {
				uvCompIndex = i*2;
				compIndex = i*3;
				interleavedCompIndex = i*13;

				interleavedBuffer[ interleavedCompIndex     ] = vertices? vertices[ compIndex       ] : 0;
				interleavedBuffer[ interleavedCompIndex + 1 ] = vertices? vertices[ compIndex + 1   ] : 0;
				interleavedBuffer[ interleavedCompIndex + 2 ] = vertices? vertices[ compIndex + 2   ] : 0;
				interleavedBuffer[ interleavedCompIndex + 3 ] = normals? normals[   compIndex       ] : 0;
				interleavedBuffer[ interleavedCompIndex + 4 ] = normals? normals[   compIndex + 1   ] : 0;
				interleavedBuffer[ interleavedCompIndex + 5 ] = normals? normals[   compIndex + 2   ] : 0;
				interleavedBuffer[ interleavedCompIndex + 6 ] = tangents? tangents[ compIndex       ] : 0;
				interleavedBuffer[ interleavedCompIndex + 7 ] = tangents? tangents[ compIndex + 1   ] : 0;
				interleavedBuffer[ interleavedCompIndex + 8 ] = tangents? tangents[ compIndex + 2   ] : 0;
				interleavedBuffer[ interleavedCompIndex + 9 ] = uvs? uvs[           uvCompIndex     ] : 0;
				interleavedBuffer[ interleavedCompIndex + 10 ] = uvs? uvs[          uvCompIndex + 1 ] : 0;
				interleavedBuffer[ interleavedCompIndex + 11 ] = suvs? suvs[        uvCompIndex      ] : 0;
				interleavedBuffer[ interleavedCompIndex + 12 ] = suvs? suvs[        uvCompIndex + 1 ] : 0;

			}
			
			return interleavedBuffer;
		}
		
		/*		 * returns the subGeometry index in its parent mesh subgeometries vector		 */
		public static function getMeshSubgeometryIndex(subGeometry:ISubGeometry):Number
		{
			var index:Number;
			var subGeometries:Vector.<ISubGeometry> = subGeometry.parentGeometry.subGeometries;

			for (var i:Number = 0; i < subGeometries.length; ++i)
            {
				if (subGeometries[i] == subGeometry)
                {
					index = i;
					break;
				}
			}
			
			return index;
		}
		
		/*		 * returns the subMesh index in its parent mesh subMeshes vector		 */
		public static function getMeshSubMeshIndex(subMesh:SubMesh):Number
		{
			var index:Number;
			var subMeshes:Vector.<SubMesh> = subMesh.iParentMesh.subMeshes;

			for (var i:Number = 0; i < subMeshes.length; ++i)
            {

				if (subMeshes[i] == subMesh)
                {

					index = i;
					break;

				}
			}
			
			return index;
		}
	}
}
