/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package away.core.base
{
	import away.managers.Stage3DProxy;
	import away.core.display3D.IndexBuffer3D;
	import away.core.geom.Matrix3D;
	//import away3d.managers.Stage3DProxy;
	
	//import flash.display3D.IndexBuffer3D;
	//import flash.geom.Matrix3D;

    /**
	public interface ISubGeometry
	{
		/**
		function get numVertices():Number;//GET
		/**
		function get numTriangles():Number;//GET
		/**
		function get vertexStride():Number;//GET
		/**
		function get vertexNormalStride():Number;//GET
		/**
		function get vertexTangentStride():Number;//GET
		/**
		function get UVStride():Number;//GET
		/**
		function get secondaryUVStride():Number;//GET
		/**
		function activateVertexBuffer(index:Number, stage3DProxy:Stage3DProxy):void;
		
		/**
		function activateUVBuffer(index:Number, stage3DProxy:Stage3DProxy):void;
		
		/**
		function activateSecondaryUVBuffer(index:Number, stage3DProxy:Stage3DProxy):void;
		
		/**
		function activateVertexNormalBuffer(index:Number, stage3DProxy:Stage3DProxy):void;
		
		/**
		function activateVertexTangentBuffer(index:Number, stage3DProxy:Stage3DProxy):void;
		
		/**

		function getIndexBuffer(stage3DProxy:Stage3DProxy):IndexBuffer3D;
		
		/**
		function get vertexData():Vector.<Number>;//GET
		/**
		function get vertexNormalData():Vector.<Number>;//GET
		/**
		function get vertexTangentData():Vector.<Number>;//GET
		/**
		function get vertexOffset():Number;//GET
		/**
		function get vertexNormalOffset():Number;//GET
		/**
		function get vertexTangentOffset():Number;//GET
		/**
		function get UVOffset():Number;//GET
		/**
		function get secondaryUVOffset():Number;//GET
		/**
		function get indexData():Vector.<Number> /*uint*///GET
		/**
		function get UVData():Vector.<Number>;//GET
		function applyTransformation(transform:Matrix3D):void;
		
		function scale(scale:Number):void;
		
		function dispose():void;
		
		function clone():ISubGeometry;
		
		function get scaleU():Number;//GET
		function get scaleV():Number;//GET
		function scaleUV(scaleU:Number = 1, scaleV:Number = 1):void; //scaleUV(scaleU:number = 1, scaleV:number = 1);
		function get parentGeometry():Geometry;//GET / SET
		function get faceNormals():Vector.<Number>;//GET
		function cloneWithSeperateBuffers():SubGeometry;
		
		function get autoDeriveVertexNormals():Boolean;//GET / SET
		function get autoDeriveVertexTangents():Boolean;//GET / SET
		function fromVectors(vertices:Vector.<Number>, uvs:Vector.<Number>, normals:Vector.<Number>, tangents:Vector.<Number>):void;
		
		function get vertexPositionData():Vector.<Number>;//GET
}