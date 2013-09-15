///<reference path="../_definitions.ts"/>
/** * @module away.base */
package away.base
{
	import away.managers.Stage3DProxy;
	import away.display3D.IndexBuffer3D;
	import away.geom.Matrix3D;
	//import away3d.managers.Stage3DProxy;
	
	//import flash.display3D.IndexBuffer3D;
	//import flash.geom.Matrix3D;

    /**     * @interface away.base.ISubGeometry     */
	public interface ISubGeometry
	{
		/**		 * The total amount of vertices in the SubGeometry.		 */
		function get numVertices():Number;//GET		
		/**		 * The amount of triangles that comprise the IRenderable geometry.		 */
		function get numTriangles():Number;//GET		
		/**		 * The distance between two consecutive vertex, normal or tangent elements		 * This always applies to vertices, normals and tangents.		 */
		function get vertexStride():Number;//GET		
		/**		 * The distance between two consecutive normal elements		 * This always applies to vertices, normals and tangents.		 */
		function get vertexNormalStride():Number;//GET		
		/**		 * The distance between two consecutive tangent elements		 * This always applies to vertices, normals and tangents.		 */
		function get vertexTangentStride():Number;//GET		
		/**		 * The distance between two consecutive UV elements		 */
		function get UVStride():Number;//GET		
		/**		 * The distance between two secondary UV elements		 */
		function get secondaryUVStride():Number;//GET		
		/**		 * Assigns the attribute stream for vertex positions.		 * @param index The attribute stream index for the vertex shader		 * @param stage3DProxy The Stage3DProxy to assign the stream to		 */
		function activateVertexBuffer(index:Number, stage3DProxy:Stage3DProxy):void;
		
		/**		 * Assigns the attribute stream for UV coordinates		 * @param index The attribute stream index for the vertex shader		 * @param stage3DProxy The Stage3DProxy to assign the stream to		 */
		function activateUVBuffer(index:Number, stage3DProxy:Stage3DProxy):void;
		
		/**		 * Assigns the attribute stream for a secondary set of UV coordinates		 * @param index The attribute stream index for the vertex shader		 * @param stage3DProxy The Stage3DProxy to assign the stream to		 */
		function activateSecondaryUVBuffer(index:Number, stage3DProxy:Stage3DProxy):void;
		
		/**		 * Assigns the attribute stream for vertex normals		 * @param index The attribute stream index for the vertex shader		 * @param stage3DProxy The Stage3DProxy to assign the stream to		 */
		function activateVertexNormalBuffer(index:Number, stage3DProxy:Stage3DProxy):void;
		
		/**		 * Assigns the attribute stream for vertex tangents		 * @param index The attribute stream index for the vertex shader		 * @param stage3DProxy The Stage3DProxy to assign the stream to		 */
		function activateVertexTangentBuffer(index:Number, stage3DProxy:Stage3DProxy):void;
		
		/**		 * Retrieves the IndexBuffer3D object that contains triangle indices.		 * @param context The Context3D for which we request the buffer		 * @return The VertexBuffer3D object that contains triangle indices.		 */

		function getIndexBuffer(stage3DProxy:Stage3DProxy):IndexBuffer3D;
		
		/**		 * Retrieves the object's vertices as a Number array.		 */
		function get vertexData():Vector.<Number>;//GET		
		/**		 * Retrieves the object's normals as a Number array.		 */
		function get vertexNormalData():Vector.<Number>;//GET		
		/**		 * Retrieves the object's tangents as a Number array.		 */
		function get vertexTangentData():Vector.<Number>;//GET		
		/**		 * The offset into vertexData where the vertices are placed		 */
		function get vertexOffset():Number;//GET		
		/**		 * The offset into vertexNormalData where the normals are placed		 */
		function get vertexNormalOffset():Number;//GET		
		/**		 * The offset into vertexTangentData where the tangents are placed		 */
		function get vertexTangentOffset():Number;//GET		
		/**		 * The offset into UVData vector where the UVs are placed		 */
		function get UVOffset():Number;//GET		
		/**		 * The offset into SecondaryUVData vector where the UVs are placed		 */
		function get secondaryUVOffset():Number;//GET		
		/**		 * Retrieves the object's indices as a uint array.		 */
		function get indexData():Vector.<Number> /*uint*///GET		
		/**		 * Retrieves the object's uvs as a Number array.		 */
		function get UVData():Vector.<Number>;//GET		
		function applyTransformation(transform:Matrix3D):void;
		
		function scale(scale:Number):void;
		
		function dispose():void;
		
		function clone():ISubGeometry;
		
		function get scaleU():Number;//GET		
		function get scaleV():Number;//GET		
		function scaleUV(scaleU:Number = 1, scaleV:Number = 1):void; //scaleUV(scaleU:number = 1, scaleV:number = 1);		
		function get parentGeometry():Geometry;//GET / SET		function set parentGeometry(value:Geometry):void;//GET / SET
		function get faceNormals():Vector.<Number>;//GET		
		function cloneWithSeperateBuffers():SubGeometry;
		
		function get autoDeriveVertexNormals():Boolean;//GET / SET		function set autoDeriveVertexNormals(value:Boolean):void;//GET / SET
		function get autoDeriveVertexTangents():Boolean;//GET / SET		function set autoDeriveVertexTangents(value:Boolean):void;//GET / SET
		function fromVectors(vertices:Vector.<Number>, uvs:Vector.<Number>, normals:Vector.<Number>, tangents:Vector.<Number>):void;
		
		function get vertexPositionData():Vector.<Number>;//GET	}
}
