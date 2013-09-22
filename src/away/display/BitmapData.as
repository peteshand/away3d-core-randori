///<reference path="../_definitions.ts" />

package away.display {
	import away.geom.Rectangle;
	import away.utils.ColorUtils;
	import away.geom.Matrix;
	import randori.webkit.html.HTMLCanvasElement;
	import randori.webkit.html.canvas.CanvasRenderingContext2D;
	import randori.webkit.html.ImageData;
	import randori.webkit.page.Window;
	import randori.webkit.html.HTMLImageElement;

    /**     *     */
    public class BitmapData
    {

        private var _imageCanvas:HTMLCanvasElement;
        private var _context:CanvasRenderingContext2D;
        private var _imageData:ImageData;
        private var _rect:Rectangle;
        private var _transparent:Boolean;
        private var _alpha:Number = 1;
        private var _locked:Boolean = false;


        /**         *         * @param width         * @param height         * @param transparent         * @param fillColor         */
        public function BitmapData(width:Number, height:Number, transparent:Boolean = true, fillColor:Number = -1):void
        {
			transparent = transparent || true;
			fillColor = fillColor || -1;


            this._transparent           = transparent;
            this._imageCanvas           = HTMLCanvasElement(Window.document.createElement("canvas") );
            this._imageCanvas.width     = width;
            this._imageCanvas.height    = height;
            this._context               = this._imageCanvas.getContext( "2d" );
            this._rect                  = new Rectangle( 0 , 0 , width , height );

            if ( fillColor != -1 )
            {

                if( this._transparent)
                {
                    this._alpha = ColorUtils.float32ColorToARGB( fillColor )[0] / 255;
                }
                else
                {
                    this._alpha = 1;
                }

                this.fillRect( this._rect , fillColor );

            }

        }

        /**         *         */
        public function dispose():void
        {
            this._context = null;
            this._imageCanvas = null
            this._imageData = null;
            this._rect = null;
            this._transparent = null;
            this._locked = null;
        }

        /**         *         */
        public function lock():void
        {
            this._locked    = true;
            this._imageData = this._context.getImageData(0,0,this._rect.width,this._rect.height);
        }

        /**         *         */
        public function unlock():void
        {
            this._locked = false;

            if ( this._imageData )
            {

                this._context.putImageData( this._imageData, 0, 0, 0); // at coords 0,0
                this._imageData = null;

            }
        }

        /**         *         * @param x         * @param y         * @param color         */
        public function getPixel(x, y):Number
        {

            var r : Number;
            var g : Number;
            var b : Number;
            var a : Number;

            var index : Number = (x + y * this._imageCanvas.width) * 4;

            if ( ! this._locked )
            {
                this._imageData = this._context.getImageData(0,0,this._rect.width,this._rect.height);

                r = this._imageData.data[index+0]
                g = this._imageData.data[index+1]
                b = this._imageData.data[index+2]
                a = this._imageData.data[index+3]

            }
            else
            {
                if (  this._imageData )
                {
                    this._context.putImageData( this._imageData, 0, 0, 0);
                }

                this._imageData = this._context.getImageData(0,0,this._rect.width,this._rect.height);

                r = this._imageData.data[index+0]
                g = this._imageData.data[index+1]
                b = this._imageData.data[index+2]
                a = this._imageData.data[index+3]

            }

            if ( ! this._locked )
            {
                this._imageData = null;
            }

            return (a << 24) | (r << 16) | (g << 8) | b;

        }
        /**         *         * @param x         * @param y         * @param color         */
        public function setPixel(x, y, color:Number):void
        {

            var argb : Vector.<Number> = ColorUtils.float32ColorToARGB( color );

            if ( ! this._locked )
            {
                this._imageData = this._context.getImageData(0,0,this._rect.width,this._rect.height);
            }

            if ( this._imageData )
            {
                var index : Number = (x + y * this._imageCanvas.width) * 4;

                this._imageData.data[index+0] = argb[1];
                this._imageData.data[index+1] = argb[2];
                this._imageData.data[index+2] = argb[3];
                this._imageData.data[index+3] = 255;
            }

            if ( ! this._locked )
            {
                this._context.putImageData( this._imageData, 0, 0, 0);
                this._imageData = null;
            }

        }

        /**         *         * @param x         * @param y         * @param color         */
        public function setPixel32(x, y, color:Number):void
        {

            var argb : Vector.<Number> = ColorUtils.float32ColorToARGB( color );

            if ( ! this._locked )
            {
                this._imageData = this._context.getImageData(0,0,this._rect.width,this._rect.height);
            }

            if ( this._imageData )
            {
                var index : Number = (x + y * this._imageCanvas.width) * 4;

                this._imageData.data[index+0] = argb[1];
                this._imageData.data[index+1] = argb[2];
                this._imageData.data[index+2] = argb[3];
                this._imageData.data[index+3] = argb[0];
            }

            if ( ! this._locked )
            {
                this._context.putImageData( this._imageData, 0, 0, 0);
                this._imageData = null;
            }

        }

        /**         * Copy an HTMLImageElement or BitmapData object         *         * @param img {BitmapData} / {HTMLImageElement}         * @param sourceRect - source rectange to copy from         * @param destRect - destinatoin rectange to copy to         */
        public function drawImage(img:*, sourceRect:Rectangle, destRect:Rectangle):void
        {

            if ( this._locked )
            {
                // If canvas is locked:
                //
                //      1) copy image data back to canvas
                //      2) draw object
                //      3) read _imageData back out

                if (  this._imageData )
                {
                    this._context.putImageData( this._imageData, 0, 0, 0); // at coords 0,0
                }

                this._drawImage(img , sourceRect , destRect );

                if (  this._imageData )
                {
                    this._imageData = this._context.getImageData(0,0,this._rect.width,this._rect.height);
                }

            }
            else
            {
                this._drawImage(img , sourceRect , destRect )
            }

        }
        private function _drawImage(img:*, sourceRect:Rectangle, destRect:Rectangle):void
        {
            if ( img instanceof BitmapData )
            {
                this._context.drawImage3(img.canvas , sourceRect.x ,sourceRect.y,sourceRect.width,sourceRect.height,destRect.x,destRect.y,destRect.width,destRect.height );
            }
            else if ( img instanceof HTMLImageElement )
            {
                this._context.drawImage3(img , sourceRect.x ,sourceRect.y,sourceRect.width,sourceRect.height,destRect.x,destRect.y,destRect.width,destRect.height );
            }
        }

        /**         *         * @param bmpd         * @param sourceRect         * @param destRect         */
        public function copyPixels(bmpd:*, sourceRect:Rectangle, destRect:Rectangle):void
        {

            if ( this._locked )
            {

                // If canvas is locked:
                //
                //      1) copy image data back to canvas
                //      2) draw object
                //      3) read _imageData back out

                if (  this._imageData )
                {
                    this._context.putImageData( this._imageData, 0, 0, 0); // at coords 0,0
                }

                this._copyPixels(  bmpd , sourceRect , destRect );

                if (  this._imageData )
                {
                    this._imageData = this._context.getImageData(0,0,this._rect.width,this._rect.height);
                }
            }
            else
            {
                this._copyPixels(  bmpd , sourceRect , destRect );
            }

        }
        private function _copyPixels(bmpd:*, sourceRect:Rectangle, destRect:Rectangle):void
        {

            if ( bmpd instanceof BitmapData )
            {
                this._context.drawImage3( bmpd.canvas , sourceRect.x , sourceRect.y , sourceRect.width , sourceRect.height , destRect.x , destRect.y , destRect.width , destRect.height );
            }
            else if ( bmpd instanceof HTMLImageElement )
            {
                this._context.drawImage3( bmpd , sourceRect.x , sourceRect.y , sourceRect.width , sourceRect.height , destRect.x , destRect.y , destRect.width , destRect.height );
            }

        }

        /**         *         * @param rect         * @param color         */
        public function fillRect(rect:Rectangle, color:Number):void
        {

            if ( this._locked )
            {

                // If canvas is locked:
                //
                //      1) copy image data back to canvas
                //      2) apply fill
                //      3) read _imageData back out

                if (  this._imageData )
                {
                    this._context.putImageData( this._imageData, 0, 0, 0); // at coords 0,0
                }

                this._context.fillStyle = this.hexToRGBACSS( color );
                this._context.fillRect( rect.x , rect.y , rect.width , rect.height );

                if ( this._imageData )
                {
                    this._imageData = this._context.getImageData(0,0,this._rect.width,this._rect.height);
                }

            }
            else
            {
                this._context.fillStyle = this.hexToRGBACSS( color );
                this._context.fillRect( rect.x , rect.y , rect.width , rect.height );
            }


        }

        /**         *         * @param source         * @param matrix         */
        public function draw(source:*, matrix:Matrix):void
        {

            if ( this._locked )
            {

                // If canvas is locked:
                //
                //      1) copy image data back to canvas
                //      2) draw object
                //      3) read _imageData back out

                if (  this._imageData )
                {
                    this._context.putImageData( this._imageData, 0, 0, 0); // at coords 0,0
                }

                this._draw( source , matrix );

                if (  this._imageData )
                {
                    this._imageData = this._context.getImageData(0,0,this._rect.width,this._rect.height);
                }
            }
            else
            {
                this._draw( source , matrix );
            }

        }
        private function _draw(source:*, matrix:Matrix):void
        {

            if ( source instanceof BitmapData )
            {
                this._context.save();
                this._context.setTransform(matrix.a, matrix.b, matrix.c, matrix.d, matrix.tx, matrix.ty);
                this._context.drawImage1(source.canvas, 0, 0)
                this._context.restore();

            }
            else if ( source instanceof HTMLImageElement )
            {
                this._context.save();
                this._context.setTransform(matrix.a, matrix.b, matrix.c, matrix.d, matrix.tx, matrix.ty);
                this._context.drawImage1(source, 0, 0)
                this._context.restore();
            }

        }

        // Get / Set

        /**         *         * @param {ImageData}         */
        public function set imageData(value:ImageData):void
        {
            this._context.putImageData( value , 0 , 0, 0 );
        }

        /**         *         * @returns {ImageData}         */
        public function get imageData():ImageData
        {
            return this._context.getImageData(0,0,this._rect.width,this._rect.height)
        }

        /**         *         * @returns {number}         */
        public function get width():Number
        {
            return (this._imageCanvas.width as Number);
        }

        /**         *         * @param {number}         */
        public function set width(value:Number):void
        {
            this._rect.width = value;
            this._imageCanvas.width = value;
        }

        /**         *         * @returns {number}         */
        public function get height():Number
        {
            return (this._imageCanvas.height as Number);
        }

        /**         *         * @param {number}         */
        public function set height(value:Number):void
        {
            this._rect.height = value;
            this._imageCanvas.height = value;
        }

        /**         *         * @param {away.geom.Rectangle}         */
        public function get rect():Rectangle
        {
            return this._rect;
        }

        /**         *         * @returns {HTMLCanvasElement}         */
        public function get canvas():HTMLCanvasElement
        {
            return this._imageCanvas;
        }

        /**         *         * @returns {HTMLCanvasElement}         */
        public function get context():CanvasRenderingContext2D
        {
            return this._context;
        }

        // Private

        /**         * convert decimal value to Hex         */
        private function hexToRGBACSS(d:Number):String
        {

            var argb : Vector.<Number> = ColorUtils.float32ColorToARGB( d );

            if ( this._transparent == false )
            {

                argb[0] = 1;

                return 'rgba(' + argb[1] + ',' + argb[2]+ ',' + argb[3] +  ',' + argb[0]   +')';

            }

            return 'rgba(' + argb[1] + ',' + argb[2]+ ',' + argb[3]+ ',' + argb[0] /255 + ')';

        }
    }


}