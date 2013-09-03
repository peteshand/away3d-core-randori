/** * ... * @author Gary Paluk - http://www.plugin.io */

///<reference path="../_definitions.ts"/>


package away.entities
{
	import away.display3D.Context3D;
	import away.display3D.VertexBuffer3D;
	import away.display3D.IndexBuffer3D;
	
	public class SubSet
	{
		public var vertices:Vector.<Number>;
		public var numVertices:Number;
		
		public var indices:Vector.<Number>;
		public var numIndices:Number;
		
		public var vertexBufferDirty:Boolean;
		public var indexBufferDirty:Boolean;
		
		public var vertexContext3D:Context3D;
		public var indexContext3D:Context3D;
		
		public var vertexBuffer:VertexBuffer3D;
		public var indexBuffer:IndexBuffer3D;
		public var lineCount:Number;
		
		public function dispose():void
		{
			vertices = null;
			if( vertexBuffer )
			{
				vertexBuffer.dispose();
			}
			if( indexBuffer )
			{
				indexBuffer.dispose();
			}
		}
	}
}
