/** * ... * @author Gary Paluk - http://www.plugin.io */

///<reference path="../_definitions.ts"/>

package away.utils
{
	import randori.webkit.html.canvas.ArrayBuffer;
	import randori.webkit.html.canvas.DataView;
	public class ByteArray extends ByteArrayBase
	{
		
		public var maxlength:Number = 0;
		public var arraybytes; //ArrayBuffer  		public var unalignedarraybytestemp; //ArrayBuffer		
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
			this.ensureSpace( n + this.position );
		}

        public function setArrayBuffer(aBuffer:ArrayBuffer):void
        {

            this.ensureSpace( aBuffer.byteLength );

            this.length                     = aBuffer.byteLength;

            var inInt8AView     : Int8Array = new Int8Array( aBuffer );
            var localInt8View   : Int8Array = new Int8Array( this.arraybytes, 0, this.length );

                localInt8View.set( inInt8AView );

            this.position = 0;

        }

        override public function getBytesAvailable():Number
        {
            return ( this.length ) - ( this.position ) ;
        }

		public function ensureSpace(n:Number):void
		{
			if ( n > this.maxlength )
			{
				var newmaxlength:Number = (n+255)&(~255); 
				var newarraybuffer = new ArrayBuffer();                              
				var view = new Uint8Array( this.arraybytes, 0, this.length ); 
				var newview = new Uint8Array( newarraybuffer, 0, this.length ); 
				newview.set( view );      // memcpy                        
				this.arraybytes = newarraybuffer;
				this.maxlength = newmaxlength;                         
			}
		}
		
		override public function writeByte(b:Number):void
		{                    
			this.ensureWriteableSpace( 1 );         
			var view = new Int8Array( this.arraybytes ); 
			view[ this.position++ ] = (~~b); // ~~ is cast to int in js...
			if ( this.position > this.length )
			{
				this.length = this.position;
			}
		}
		
		override public function readByte():Number
		{
			if ( this.position >= this.length )
			{
				throw "ByteArray out of bounds read. Positon="+this.position+", Length="+this.length; 
			}
			var view = new Int8Array(this.arraybytes);

			return view[ this.position++ ];
		}

        public function readBytes(bytes:ByteArray, offset:Number = 0, length:Number = 0):void
        {

            if (length == 0)
            {
                length = bytes.length;
            }

            bytes.ensureWriteableSpace(offset + length);

            var byteView        : Int8Array = new Int8Array( bytes.arraybytes );
            var localByteView   : Int8Array = new Int8Array( this.arraybytes );

            byteView.set( localByteView.subarray( this.position , this.position + length), offset);

            this.position += length;

            if ( length + offset > bytes.length)
            {
                bytes.length += ( length + offset ) - bytes.length;
            }

        }

		override public function writeUnsignedByte(b:Number):void
		{                    
			this.ensureWriteableSpace( 1 );         
			var view = new Uint8Array( this.arraybytes ); 
			view[this.position++] = (~~b) & 0xff; // ~~ is cast to int in js...
			if ( this.position > this.length )
			{
				this.length = this.position;
			}
		}
		override public function readUnsignedByte():Number
		{     
			if ( this.position >= this.length )
			{
				throw "ByteArray out of bounds read. Positon="+this.position+", Length="+this.length; 
			}
			var view = new Uint8Array(this.arraybytes); 
			return view[this.position++];                
		}
		
		override public function writeUnsignedShort(b:Number):void
		{       
			this.ensureWriteableSpace ( 2 );         
			if ( ( this.position & 1 ) == 0 )
			{
				var view = new Uint16Array( this.arraybytes );
				view[ this.position >> 1 ] = (~~b) & 0xffff; // ~~ is cast to int in js...
			} 
			else
			{
				var view = new Uint16Array(this.unalignedarraybytestemp, 0, 1 );
				view[0] = (~~b) & 0xffff;
				var view2 = new Uint8Array( this.arraybytes, this.position, 2 );                         
				var view3 = new Uint8Array( this.unalignedarraybytestemp, 0, 2 ); 
				view2.set(view3);               
			}
			this.position += 2;
			if ( this.position > this.length )
			{
				this.length = this.position;
			}
		}
		
        public function readUTFBytes(len:Number):String {
        
            var value   : String    = "";
            var max     : Number    = this.position + len;
            var data    : DataView  = DataView( this.arraybytes );

            // utf8-encode
            while (this.position < max) {

                var c : Number = data.getUint16(this.position++);

                if (c < 0x80) {

                    if (c == 0) break;
                    value += String.fromCharCode(c);

                } else if (c < 0xE0) {

                    value += String.fromCharCode(((c & 0x3F) << 6) |(data.getUint16(this.position++) & 0x7F));

                } else if (c < 0xF0) {

                    var c2 = data.getUint16(this.position++);
                    value += String.fromCharCode(((c & 0x1F) << 12) |((c2 & 0x7F) << 6) |(data.getUint16(this.position++) & 0x7F));

                } else {

                    var c2 = data.getUint16(this.position++);
                    var c3 = data.getUint16(this.position++);

                    value += String.fromCharCode(((c & 0x0F) << 18) |((c2 & 0x7F) << 12) |((c3 << 6) & 0x7F) |(data.getUint16(this.position++) & 0x7F));

                }

            }

            return value;

        }

        public function readInt():Number
        {

            var data    : DataView      = DataView( this.arraybytes );
            var int     : Number        = data.getInt32( this.position );

            this.position += 4;

            return int;

        }

        public function readShort():Number
        {

            var data    : DataView      = DataView( this.arraybytes );
            var short   : Number        = data.getInt16(this.position );

            this.position += 2;
            return short;

        }

        public function readDouble():Number
        {
            var data    : DataView      = DataView( this.arraybytes );
            var double  : Number        = data.getFloat64( this.position );

            this.position += 8;
            return double;

        }

		override public function readUnsignedShort():Number
		{     
			if ( this.position > this.length + 2 )
			{
				throw "ByteArray out of bounds read. Position=" + this.position + ", Length=" + this.length;
			}
			if ( ( this.position & 1 )==0 )
			{
				var view = new Uint16Array( this.arraybytes );
				var pa:Number = this.position >> 1;
				this.position += 2;
				return view[ pa ];
			}
			else
			{
				var view = new Uint16Array( this.unalignedarraybytestemp, 0, 1 );
				var view2 = new Uint8Array( this.arraybytes,this.position, 2 );
				var view3 = new Uint8Array( this.unalignedarraybytestemp, 0, 2 );
				view3.set( view2 );
				this.position += 2;
				return view[0];
			}
		}
		
		override public function writeUnsignedInt(b:Number):void
		{                    
			this.ensureWriteableSpace( 4 );         
			if ( ( this.position & 3 ) == 0 )
			{
				var view = new Uint32Array( this.arraybytes );
				view[ this.position >> 2 ] = (~~b) & 0xffffffff; // ~~ is cast to int in js...            
			}
			else
			{
				var view = new Uint32Array( this.unalignedarraybytestemp, 0, 1 );
				view[0] = (~~b) & 0xffffffff; 
				var view2 = new Uint8Array( this.arraybytes, this.position, 4 );                         
				var view3 = new Uint8Array( this.unalignedarraybytestemp, 0, 4 ); 
				view2.set( view3 );                 
			}        
			this.position+=4; 
			if ( this.position > this.length )
			{
				this.length = this.position;
			}
		}

        public function readUnsignedInteger():Number
        {

            if ( this.position > this.length + 4 )
            {
                throw "ByteArray out of bounds read. Position=" + this.position + ", Length=" + this.length;
            }

            var view = new Uint32Array( this.unalignedarraybytestemp, 0, 1 );
            var view2 = new Uint8Array( this.arraybytes,this.position, 4 );
            var view3 = new Uint8Array( this.unalignedarraybytestemp, 0, 4 );
            view3.set( view2 );
            this.position += 4;
            return view[0];

        }



		override public function readUnsignedInt():Number
		{
			if ( this.position > this.length + 4 )
			{
				throw "ByteArray out of bounds read. Position=" + this.position + ", Length=" + this.length;
			}
			if ( ( this.position & 3 ) == 0 )
			{
				var view = new Uint32Array( this.arraybytes );
				var pa:Number = this.position >> 2;
				this.position += 4;
				return view[ pa ];
			}
			else
			{
				var view = new Uint32Array( this.unalignedarraybytestemp, 0, 1 );
				var view2 = new Uint8Array( this.arraybytes,this.position, 4 );
				var view3 = new Uint8Array( this.unalignedarraybytestemp, 0, 4 );
				view3.set( view2 );
				this.position += 4;
				return view[0];
			}
		}
		
		override public function writeFloat(b:Number):void
		{                    
			this.ensureWriteableSpace( 4 );         
			if ( ( this.position & 3 ) == 0 ) {
				var view = new Float32Array( this.arraybytes );
				view[ this.position >> 2 ] = b; 
			}
			else
			{
				var view = new Float32Array( this.unalignedarraybytestemp, 0, 1 );
				view[0] = b;
				var view2 = new Uint8Array( this.arraybytes,this.position, 4 );
				var view3 = new Uint8Array( this.unalignedarraybytestemp, 0, 4 );
				view2.set(view3);
			}
			this.position += 4; 
			if ( this.position > this.length )
			{
				this.length = this.position;
			}
		}
		
		override public function readFloat():Number
		{     
			if ( this.position > this.length + 4 )
			{
				throw "ByteArray out of bounds read. Positon="+this.position+", Length="+this.length;         
			}
			if ( (this.position&3) == 0 )
			{
				var view = new Float32Array(this.arraybytes);
				var pa = this.position >> 2;
				this.position += 4;
				return view[pa];
			}
			else
			{
				var view = new Float32Array( this.unalignedarraybytestemp, 0, 1 );
				var view2 = new Uint8Array( this.arraybytes, this.position, 4 );
				var view3 = new Uint8Array( this.unalignedarraybytestemp, 0, 4 );
				view3.set( view2 );
				this.position += 4;
				return view[ 0 ];
			}
		}
	}
}