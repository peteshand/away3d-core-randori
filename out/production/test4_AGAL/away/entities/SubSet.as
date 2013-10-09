/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package away.entities
{
	import away.core.display3D.Context3D;
	import away.core.display3D.VertexBuffer3D;
	import away.core.display3D.IndexBuffer3D;
	
	public class SubSet
	{
		public var vertices:Vector.<Number>;
		public var numVertices:Number = 0;
		
		public var indices:Vector.<Number>;
		public var numIndices:Number = 0;
		
		public var vertexBufferDirty:Boolean = false;
		public var indexBufferDirty:Boolean = false;
		
		public var vertexContext3D:Context3D;
		public var indexContext3D:Context3D;
		
		public var vertexBuffer:VertexBuffer3D;
		public var indexBuffer:IndexBuffer3D;
		public var lineCount:Number = 0;
		
		public function dispose():void
		{
			this.vertices = null;
			if( this.vertexBuffer )
			{
				this.vertexBuffer.dispose();
			}
			if( this.indexBuffer )
			{
				this.indexBuffer.dispose();
			}
		}
	}
}
