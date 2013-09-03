/**

///<reference path="../_definitions.ts"/>

package away.utils
{
	import randori.webkit.html.canvas.ArrayBuffer;
	public class ByteArray extends ByteArrayBase
	{
		
		public var maxlength:Number = 0;
		public var arraybytes; //ArrayBuffer  
		public function ByteArray():void
		{
			super();
			this._mode = "Typed array";
			this.maxlength = 4;
			this.arraybytes = new ArrayBuffer();// this.maxlength );
			this.unalignedarraybytestemp = new ArrayBuffer();
		}
		
		public function ensureWriteableSpace(n:Number):void
		{
			ensureSpace( n + position );
		}
		
		public function ensureSpace(n:Number):void
		{
			if ( n > maxlength )
			{
				var newmaxlength:Number = (n+255)&(~255); 
				var newarraybuffer = new ArrayBuffer();                              
				var view = new Uint8Array( arraybytes, 0, length ); 
				var newview = new Uint8Array( newarraybuffer, 0, length ); 
				newview.set( view );      // memcpy                        
				arraybytes = newarraybuffer;
				maxlength = newmaxlength;                         
			}
		}
		
		override public function writeByte(b:Number):void
		{                    
			ensureWriteableSpace( 1 );         
			var view = new Int8Array( arraybytes ); 
			view[ position++ ] = (~~b); // ~~ is cast to int in js...
			if ( position > length )
			{
				length = position;
			}
		}
		
		override public function readByte():Number
		{     
			if ( position >= length )
			{
				throw "ByteArray out of bounds read. Positon="+position+", Length="+length; 
			}
			var view = new Int8Array(arraybytes); 
			return view[ position++ ];                
		}
		
		override public function writeUnsignedByte(b:Number):void
		{                    
			ensureWriteableSpace( 1 );         
			var view = new Uint8Array( arraybytes ); 
			view[position++] = (~~b) & 0xff; // ~~ is cast to int in js...
			if ( position > length )
			{
				length = position;
			}
		}
		
		override public function readUnsignedByte():Number
		{     
			if ( position >= length )
			{
				throw "ByteArray out of bounds read. Positon="+position+", Length="+length; 
			}
			var view = new Uint8Array(arraybytes); 
			return view[position++];                
		}
		
		override public function writeUnsignedShort(b:Number):void
		{       
			ensureWriteableSpace ( 2 );         
			if ( ( position & 1 ) == 0 )
			{
				var view = new Uint16Array( arraybytes );
				view[ position >> 1 ] = (~~b) & 0xffff; // ~~ is cast to int in js...
			} 
			else
			{
				var view = new Uint16Array(unalignedarraybytestemp, 0, 1 );
				view[0] = (~~b) & 0xffff;
				var view2 = new Uint8Array( arraybytes, position, 2 );                         
				var view3 = new Uint8Array( unalignedarraybytestemp, 0, 2 ); 
				view2.set(view3);               
			}
			position += 2;
			if ( position > length )
			{
				length = position;
			}
		}
		
		override public function readUnsignedShort():Number
		{     
			if ( position > length + 2 )
			{
				throw "ByteArray out of bounds read. Positon=" + position + ", Length=" + length;         
			}
			if ( ( position & 1 )==0 )
			{
				var view = new Uint16Array( arraybytes );
				var pa:Number = position >> 1;
				position += 2;
				return view[ pa ];
			}
			else
			{
				var view = new Uint16Array( unalignedarraybytestemp, 0, 1 );
				var view2 = new Uint8Array( arraybytes,position, 2 );
				var view3 = new Uint8Array( unalignedarraybytestemp, 0, 2 );
				view3.set( view2 );
				position += 2;
				return view[0];
			}
		}
		
		override public function writeUnsignedInt(b:Number):void
		{                    
			ensureWriteableSpace( 4 );         
			if ( ( position & 3 ) == 0 )
			{
				var view = new Uint32Array( arraybytes );
				view[ position >> 2 ] = (~~b) & 0xffffffff; // ~~ is cast to int in js...            
			}
			else
			{
				var view = new Uint32Array( unalignedarraybytestemp, 0, 1 );
				view[0] = (~~b) & 0xffffffff; 
				var view2 = new Uint8Array( arraybytes, position, 4 );                         
				var view3 = new Uint8Array( unalignedarraybytestemp, 0, 4 ); 
				view2.set( view3 );                 
			}        
			position+=4; 
			if ( position > length )
			{
				length = position;
			}
		}
		
		override public function readUnsignedInt():Number
		{     
			if ( position > length + 4 )
			{
				throw "ByteArray out of bounds read. Positon=" + position + ", Length=" + length;
			}
			if ( ( position & 3 ) == 0 )
			{
				var view = new Uint32Array( arraybytes );
				var pa:Number = position >> 2;
				position += 4;
				return view[ pa ];
			}
			else
			{
				var view = new Uint32Array( unalignedarraybytestemp, 0, 1 );
				var view2 = new Uint8Array( arraybytes,position, 4 );
				var view3 = new Uint8Array( unalignedarraybytestemp, 0, 4 );
				view3.set( view2 );
				position += 4;
				return view[0];
			}
		}
		
		override public function writeFloat(b:Number):void
		{                    
			ensureWriteableSpace( 4 );         
			if ( ( position & 3 ) == 0 ) {
				var view = new Float32Array( arraybytes );
				view[ position >> 2 ] = b; 
			}
			else
			{
				var view = new Float32Array( unalignedarraybytestemp, 0, 1 );
				view[0] = b;
				var view2 = new Uint8Array( arraybytes,position, 4 );
				var view3 = new Uint8Array( unalignedarraybytestemp, 0, 4 );
				view2.set(view3);
			}
			position += 4; 
			if ( position > length )
			{
				length = position;
			}
		}
		
		override public function readFloat(b:Number):Number
		{     
			if ( position > length + 4 )
			{
				throw "ByteArray out of bounds read. Positon="+position+", Length="+length;         
			}
			if ( (position&3) == 0 )
			{
				var view = new Float32Array(arraybytes);
				var pa = position >> 2;
				position += 4;
				return view[pa];
			}
			else
			{
				var view = new Float32Array( unalignedarraybytestemp, 0, 1 );
				var view2 = new Uint8Array( arraybytes, position, 4 );
				var view3 = new Uint8Array( unalignedarraybytestemp, 0, 4 );
				view3.set( view2 );
				position += 4;
				return view[ 0 ];
			}
		}
	}
}