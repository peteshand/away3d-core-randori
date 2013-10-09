/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package away.utils
{
	public class ByteArrayBuffer extends ByteArrayBase
	{
		
		/*		public maxlength:number = 0;		public arraybytes; //ArrayBuffer  		public unalignedarraybytestemp; //ArrayBuffer		*/
		
		public var _bytes:Vector.<Number>;
		
		public function ByteArrayBuffer():void
		{
			super();
			this._bytes = new Vector.<Number>();
			this._mode = "Array";
		}
		
		override public function writeByte(b:Number):void
		{
			var bi:Number = ~~b;
			this._bytes[ this.position++ ] = bi;
			if( this.position > this.length )
			{
				this.length = this.position; 
			}
		}
		
		override public function readByte():Number
		{
			if ( this.position >= this.length )
			{
				throw "ByteArray out of bounds read. Position=" + this.position + ", Length=" + this.length;
			}
			return this._bytes[ this.position++ ];
		}
		
		override public function writeUnsignedByte(b:Number):void
		{
			var bi:Number = ~~b;
			this._bytes[this.position++] = bi & 0xff;     
			if ( this.position > this.length )
			{
				this.length = this.position;
			}
		}
		
		override public function readUnsignedByte():Number
		{     
			if ( this.position >= this.length )
			{
				throw "ByteArray out of bounds read. Position="+this.position+", Length="+this.length;
			}
			return this._bytes[ this.position++ ];                
		}
		
		override public function writeUnsignedShort(b:Number):void
		{
			var bi:Number = ~~b;
			this._bytes[ this.position++ ] = bi & 0xff;
			this._bytes[ this.position++ ] = (bi>>8) & 0xff;
			if ( this.position > this.length )
			{
				this.length = this.position;
			}
		}
		
		override public function readUnsignedShort():Number
		{    
			if ( this.position+2 > this.length )
			{
				throw "ByteArray out of bounds read. Position="+this.position+", Length="+this.length;
			}
			var r:Number = this._bytes[ this.position ] | ( this._bytes[ this.position+1 ] << 8 );
			this.position += 2;
			return r;                
		}
		
		override public function writeUnsignedInt(b:Number):void
		{   
			var bi:Number = ~~b; 
			this._bytes[ this.position++ ] = bi & 0xff;     
			this._bytes[ this.position++ ] = (bi>>>8) & 0xff;     
			this._bytes[ this.position++ ] = (bi>>>16) & 0xff;     
			this._bytes[ this.position++ ] = (bi>>>24) & 0xff;     
			if ( this.position > this.length )
			{
				this.length = this.position;
			}
		}
		
		override public function readUnsignedInt():Number
		{    
			if ( this.position+4 > this.length )
			{
				throw "ByteArray out of bounds read. Position=" + this.position + ", Length=" + this.length;
			}
			var r:Number = this._bytes[ this.position ] | ( this._bytes[this.position+1]<<8 )
				| ( this._bytes[this.position+2]<<16 ) | ( this._bytes[this.position+3]<<24 );        
			this.position += 4;
			return r >>> 0;                
		}
		
		override public function writeFloat(b:Number):void {   
					// this is crazy slow and silly, but as a fallback... 
			
			this.writeUnsignedInt( this.toFloatBits(Number(b)));
		}
		
		override public function toFloatBits(x:Number):Number
		{
			// don't handle inf/nan yet
			// special case zero
			if( x == 0 )
			{
				return 0;
			}
			// remove the sign, after this we only deal with positive numbers
			var sign:Number = 0;
			if( x < 0 )
			{
				x =- x;
				sign = 1;
			}
			else
			{
				sign = 0;
			}
			// a float value is now defined as: x = (1+(mantissa*2^-23))*(2^(exponent-127))
			var exponent:Number = Math.log( x ) / Math.log( 2 );  // rough exponent
			exponent = Math.floor( exponent );
			x = x*Math.pow( 2, 23-exponent );             // normalize to 24 bits
			var mantissa = Math.floor( x ) - 0x800000;
			exponent = exponent + 127;
			return( ( sign << 31 ) >>> 0) | ( exponent << 23 ) | mantissa;
		}
		
		override public function readFloat():Number
		{
			return this.fromFloatBits ( this.readUnsignedInt() );
		}
		
		override public function fromFloatBits(x:Number):Number
		{
			if ( x == 0 )
			{
				return 0;
			}
			var exponent:Number = ( x >>> 23 )&0xff;
			var mantissa:Number = ( x & 0x7fffff )| 0x800000;
			var y = Math.pow( 2, ( exponent-127 ) - 23 ) * mantissa;
			if( x >>> 31 != 0 )
			{
				y = -y;
			}
			return y;
		}
		
		/*		public ensureWriteableSpace( n:number )		{			this.ensureSpace( n + this.position ); 		}				private ensureSpace( n:number )		{			if ( n > this.maxlength ) {				var newmaxlength:number = (n+255)&(~255); 				var newarraybuffer = new ArrayBuffer(newmaxlength);                              				var view = new Uint8Array(this.arraybytes, 0, this.length); 				var newview = new Uint8Array(newarraybuffer, 0, this.length); 				newview.set(view);      // memcpy                        				this.arraybytes = newarraybuffer;				this.maxlength = newmaxlength;                         			}		}		*/
		
	}
}