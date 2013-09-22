package away.utils
{
	public class VectorNumber
	{
		public static function init(length:Number = 0, defaultValue:Number = 0, v:Vector.<Number> = null):Vector.<Number>
        {
			length = length || 0;
			defaultValue = defaultValue || 0;

			if (!v) v = VectorNumber.init(length);
            for (var g:Number = 0; g < length; ++g) v[g] = defaultValue;
            return v;
        }
	}
}
