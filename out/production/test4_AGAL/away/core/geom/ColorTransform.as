/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

package away.core.geom
{
	import away.utils.ColorUtils;


    public class ColorTransform
    {

        public var alphaMultiplier:Number = 0;
        public var alphaOffset:Number = 0;
        public var blueMultiplier:Number = 0;
        public var blueOffset:Number = 0;
        public var greenMultiplier:Number = 0;
        public var greenOffset:Number = 0;
        public var redMultiplier:Number = 0;
        public var redOffset:Number = 0;

        public function ColorTransform(inRedMultiplier:Number = 1.0, inGreenMultiplier:Number = 1.0, inBlueMultiplier:Number = 1.0, inAlphaMultiplier:Number = 1.0, inRedOffset:Number = 0.0, inGreenOffset:Number = 0.0, inBlueOffset:Number = 0.0, inAlphaOffset:Number = 0.0):void
        {
			inRedMultiplier = inRedMultiplier || 1.0;
			inGreenMultiplier = inGreenMultiplier || 1.0;
			inBlueMultiplier = inBlueMultiplier || 1.0;
			inAlphaMultiplier = inAlphaMultiplier || 1.0;
			inRedOffset = inRedOffset || 0.0;
			inGreenOffset = inGreenOffset || 0.0;
			inBlueOffset = inBlueOffset || 0.0;
			inAlphaOffset = inAlphaOffset || 0.0;


            this.redMultiplier      = inRedMultiplier;
            this.greenMultiplier    = inGreenMultiplier;
            this.blueMultiplier     = inBlueMultiplier;
            this.alphaMultiplier    = inAlphaMultiplier;
            this.redOffset          = inRedOffset;
            this.greenOffset        = inGreenOffset;
            this.blueOffset         = inBlueOffset;
            this.alphaOffset        = inAlphaOffset;

        }

        public function concat(second:ColorTransform):void
        {
            this.redMultiplier      += second.redMultiplier;
            this.greenMultiplier    += second.greenMultiplier;
            this.blueMultiplier     += second.blueMultiplier;
            this.alphaMultiplier    += second.alphaMultiplier;
        }

        public function get color():Number
        {

            return((this.redOffset << 16) | ( this.greenOffset << 8) | this.blueOffset);

        }

        public function set color(value:Number):void
        {

            var argb : Vector.<Number> = ColorUtils.float32ColorToARGB( value );

            this.redOffset          = argb[1];  //(value >> 16) & 0xFF;
            this.greenOffset        = argb[2];  //(value >> 8) & 0xFF;
            this.blueOffset         = argb[3];  //value & 0xFF;

            this.redMultiplier      = 0;
            this.greenMultiplier    = 0;
            this.blueMultiplier     = 0;

        }

    }
}