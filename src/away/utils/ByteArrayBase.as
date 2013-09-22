/** * ... * @author Gary Paluk - http://www.plugin.io */

///<reference path="../_definitions.ts"/>

package away.utils
{
	import away.errors.AbstractMethodError;
	import randori.webkit.page.Window;
	public class ByteArrayBase
	{
		public var position:Number = 0;
		public var length:Number = 0;
		public var _mode:String = "";		
		public var Base64Key = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";		
		public function ByteArrayBase():void
		{
		}
		
		public function writeByte(b:Number):void{ throw 		"Virtual method"; }
		public function readByte():Number{ throw 		"Virtual method"; }
		public function writeUnsignedByte(b:Number):void{ throw 		"Virtual method"; }
		public function readUnsignedByte():Number{ throw 		"Virtual method"; }
		public function writeUnsignedShort(b:Number):void{ throw 		"Virtual method"; }
		public function readUnsignedShort():Number{ throw 		"Virtual method"; }
		public function writeUnsignedInt(b:Number):void{ throw 		"Virtual method"; }
		public function readUnsignedInt():Number{ throw 		"Virtual method"; }
		public function writeFloat(b:Number):void{ throw 		"Virtual method"; }
		public function toFloatBits(x:Number):Number{ throw 		"Virtual method"; }
		public function readFloat():Number{ throw 		"Virtual method"; }
		public function fromFloatBits(x:Number):Number{ throw 		"Virtual method"; }

        public function getBytesAvailable():Number
        {
            throw new AbstractMethodError( 'ByteArrayBase, getBytesAvailable() not implemented ');
        }

		public function toString():String
		{
			return "[ByteArray] ( " + this._mode + " ) position=" + this.position + " length=" + this.length; 
		}
		
		public function compareEqual(other, count):Boolean
		{
			if ( count == undefined || count > this.length - this.position ) 
				count = this.length - this.position;
			if ( count > other.length - other.position )     
				count = other.length - other.position;
			var co0 = count; 
			var r = true; 
			while ( r && count >= 4 ) {
				count-=4; 
				if ( this.readUnsignedInt() != other.readUnsignedInt() ) r = false; 
			}
			while ( r && count >= 1 ) {       
				count--; 
				if ( this.readUnsignedByte() != other.readUnsignedByte() ) r = false; 
			}
			var c0;
			this.position-=(c0-count); 
			other.position-=(c0-count); 
			return r;         
		}
		
		public function writeBase64String(s:String):void
		{
			for ( var i:Number = 0; i < s.length; i++ )
			{
				var v = s.charAt( i ); 
			}
		}
		
		public function dumpToConsole():void
		{
			var oldpos = this.position;     
			this.position = 0;
			var nstep:Number = 8;     
			function asHexString ( x, digits ) {
				var lut:Array = [ "0","1","2","3","4","5","6","7","8","9","a","b","c","d","e","f" ]; 
				var sh:String = "";
				for( var d:Number = 0; d < digits; d++ )
				{
					sh = lut[(x>>(d<<2))&0xf]+sh;
				}
				return sh;
			}
			
			for ( var i=0; i < this.length; i += nstep )
			{
				var s:String = asHexString(i,4)+":"; 
				for ( var j:Number = 0; j < nstep && i+j < this.length; j++ )
				{
					s += " " + asHexString( this.readUnsignedByte(), 2 );
				}
				Window.console.log ( s );
			}
			this.position = oldpos;
		}
		
		public function internalGetBase64String(count, getUnsignedByteFunc, self):String  // return base64 string of the next count bytes		{
			var r = "";
			var b0, b1, b2, enc1, enc2, enc3, enc4;
			var base64Key = this.Base64Key;
			while( count>=3 )
			{                    
				b0 = getUnsignedByteFunc.apply(self);
				b1 = getUnsignedByteFunc.apply(self);
				b2 = getUnsignedByteFunc.apply(self);
				enc1 = b0 >> 2;
				enc2 = ((b0 & 3) << 4) | (b1 >> 4);
				enc3 = ((b1 & 15) << 2) | (b2 >> 6);
				enc4 = b2 & 63;                
				r += base64Key.charAt(enc1) + base64Key.charAt(enc2) + base64Key.charAt(enc3) + base64Key.charAt(enc4);                            
				count -= 3; 
			}
			// pad
			if ( count==2 )
			{        
				b0 = getUnsignedByteFunc.apply(self);
				b1 = getUnsignedByteFunc.apply(self);
				enc1 = b0 >> 2;
				enc2 = ((b0 & 3) << 4) | (b1 >> 4);
				enc3 = ((b1 & 15) << 2);                
				r += base64Key.charAt(enc1) + base64Key.charAt(enc2) + base64Key.charAt(enc3) + "=";                                
			}
			else if( count==1 )
			{
				b0 = getUnsignedByteFunc.apply(self);
				enc1 = b0 >> 2;
				enc2 = ((b0 & 3) << 4);
				r += base64Key.charAt(enc1) + base64Key.charAt(enc2) + "==";
			}  
			return r; 
		}
	}
}