/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package away.utils
{
	import away.utils.VectorInit;
	public class VectorNumber
	{
		public static function init(length:Number = 0, defaultValue:Number = 0, v:Vector.<Number> = null):Vector.<Number>
        {
			length = length || 0;
			defaultValue = defaultValue || 0;

			if (!v) v = VectorInit.Num(length);
            for (var g:Number = 0; g < length; ++g) v[g] = defaultValue;
            return v;
        }
	}
}
