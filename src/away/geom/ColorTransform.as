///<reference path="../_definitions.ts"/>

package away.geom
{
	import away.utils.ColorUtils;


    public class ColorTransform
    {

        public var alphaMultiplier:Number;
        public var alphaOffset:Number;
        public var blueMultiplier:Number;
        public var blueOffset:Number;
        public var greenMultiplier:Number;
        public var greenOffset:Number;
        public var redMultiplier:Number;
        public var redOffset:Number;

        public function ColorTransform(inRedMultiplier:Number = 1.0, inGreenMultiplier:Number = 1.0, inBlueMultiplier:Number = 1.0, inAlphaMultiplier:Number = 1.0, inRedOffset:Number = 0.0, inGreenOffset:Number = 0.0, inBlueOffset:Number = 0.0, inAlphaOffset:Number = 0.0):void
        {

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
            redMultiplier      += second.redMultiplier;
            greenMultiplier    += second.greenMultiplier;
            blueMultiplier     += second.blueMultiplier;
            alphaMultiplier    += second.alphaMultiplier;
        }

        public function get color():Number
        {

            return((redOffset << 16) | ( greenOffset << 8) | blueOffset);

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