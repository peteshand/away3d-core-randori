/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package away.utils
{
	public class VectorInit
	{
		public static function Num(length:Number = 0, defaultValue:Number = 0, v:Vector.<Number> = null):Vector.<Number>
        {
			length = length || 0;
			defaultValue = defaultValue || 0;

			if (!v) v = new Vector.<Number>();
			return VectorInit.Pop(v, defaultValue, length);
        }
		
		public static function Str(length:Number = 0, defaultValue:String = '', v:Vector.<String> = null):Vector.<String>
        {
			length = length || 0;
			defaultValue = defaultValue || '';

			if (!v) v = new Vector.<String>();
            return VectorInit.Pop(v, defaultValue, length);
        }
		
		public static function Bool(length:Number = 0, defaultValue:Boolean = false, v:Vector.<Boolean> = null):Vector.<Boolean>
        {
			length = length || 0;

			if (!v) v = new Vector.<Boolean>();
            return VectorInit.Pop(v, defaultValue, length);
        }
		
		public static function VecNum(length:Number = 0, defaultValue:Number = 0, v:Vector.<Vector.<Number>> = null):Vector.<Vector.<Number>>
        {
			length = length || 0;
			defaultValue = defaultValue || 0;

			if (!v) v = new Vector.<Vector.<Number>>();
            for (var g:Number = 0; g < length; ++g) v.push(VectorInit.Num());
			return v;
        }
		
		public static function StarVec(length:Number = 0, defaultValue:* = ""):Vector.<*>
        {
			length = length || 0;
			defaultValue = defaultValue || "";

			var initVec:Vector.<*> = new Vector.<*>();
            for (var g:Number = 0; g < length; ++g) initVec.push(defaultValue);
			return initVec;
        }

		public static function AnyClass(length:Number = 0):*
        {
			length = length || 0;

			var v:Vector.<*> = new Vector.<*>();
			for (var g:Number = 0; g < length; ++g) v.push(null);
			return v;
        }
		
		public static function VecArray(length:Number = 0):*
        {
			length = length || 0;

			var v:Vector.<*> = new Vector.<*>();
			for (var g:Number = 0; g < length; ++g) v.push(new Array());
			return v;
        }
		
		private static function Pop(v:*, defaultValue:*, length:Number = 0):*
        {
			length = length || 0;

			if (length == 0) return v;
			for (var g:Number = 0; g < length; ++g) v[g] = defaultValue;
            return v;
        }
	}
}
