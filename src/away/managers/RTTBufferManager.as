///<reference path="../_definitions.ts"/>

package away.managers
{
	import away.events.EventDispatcher;
	import away.display3D.VertexBuffer3D;
	import away.display3D.IndexBuffer3D;
	import away.geom.Rectangle;
	import away.utils.TextureUtils;
	import away.events.Event;
	import away.display3D.Context3D;

	public class RTTBufferManager extends EventDispatcher
	{
		private static var _instances:Vector.<RTTBufferManagerVO>;
		
		private var _renderToTextureVertexBuffer:VertexBuffer3D;
		private var _renderToScreenVertexBuffer:VertexBuffer3D;
		
		private var _indexBuffer:IndexBuffer3D;
		private var _stage3DProxy:Stage3DProxy;
		private var _viewWidth:Number = -1;
		private var _viewHeight:Number = -1;
		private var _textureWidth:Number = -1;
		private var _textureHeight:Number = -1;
		private var _renderToTextureRect:Rectangle;
		private var _buffersInvalid:Boolean = true;
		
		private var _textureRatioX:Number;
		private var _textureRatioY:Number;
		
		public function RTTBufferManager(se:SingletonEnforcer, stage3DProxy:Stage3DProxy):void
		{

            super();

			if (!se)
            {

                throw new Error("No cheating the multiton!");

            }

			
			_renderToTextureRect = new Rectangle();
			
			_stage3DProxy = stage3DProxy;

		}
		
		public static function getInstance(stage3DProxy:Stage3DProxy):RTTBufferManager
		{
			if (!stage3DProxy)
				throw new Error("stage3DProxy key cannot be null!");

            if ( RTTBufferManager._instances == null )
            {

                RTTBufferManager._instances = new Vector.<RTTBufferManagerVO>();
            }


            var rttBufferManager : RTTBufferManager = RTTBufferManager.getRTTBufferManagerFromStage3DProxy( stage3DProxy );

            if ( rttBufferManager == null )
            {

                rttBufferManager                = new RTTBufferManager( new SingletonEnforcer() , stage3DProxy );

                var vo : RTTBufferManagerVO     = new RTTBufferManagerVO();

                    vo.stage3dProxy             = stage3DProxy;
                    vo.rttbfm                   = rttBufferManager;

                RTTBufferManager._instances.push( vo );

            }

            return rttBufferManager;

		}

        private static function getRTTBufferManagerFromStage3DProxy(stage3DProxy:Stage3DProxy):RTTBufferManager
        {

            var l : Number = RTTBufferManager._instances.length;
            var r : RTTBufferManagerVO;

            for ( var c : Number = 0 ; c < l ; c ++ )
            {

                r = RTTBufferManager._instances[ c ];

                if (r.stage3dProxy === stage3DProxy )
                {

                    return r.rttbfm;

                }

            }

            return null;

        }

        private static function deleteRTTBufferManager(stage3DProxy:Stage3DProxy):void
        {

            var l : Number = RTTBufferManager._instances.length;
            var r : RTTBufferManagerVO;

            for ( var c : Number = 0 ; c < l ; c ++ )
            {

                r = RTTBufferManager._instances[ c ];

                if (r.stage3dProxy === stage3DProxy )
                {

                    RTTBufferManager._instances.splice( c , 1 );
                    return;

                }

            }


        }

		public function get textureRatioX():Number
		{

			if (_buffersInvalid)
            {

                updateRTTBuffers();

            }

			return _textureRatioX;

		}
		
		public function get textureRatioY():Number
		{

			if (_buffersInvalid)
            {

                updateRTTBuffers();

            }

			return _textureRatioY;

		}
		
		public function get viewWidth():Number
		{
			return _viewWidth;
		}
		
		public function set viewWidth(value:Number):void
		{
			if (value == _viewWidth)
            {

                return;

            }

			_viewWidth = value;

            _buffersInvalid = true;

            _textureWidth = TextureUtils.getBestPowerOf2(_viewWidth);
			
			if (_textureWidth > _viewWidth)
            {

                _renderToTextureRect.x = Math.floor( (_textureWidth - _viewWidth)*.5);
                _renderToTextureRect.width = _viewWidth;

			}
            else
            {
				_renderToTextureRect.x = 0;
                _renderToTextureRect.width = _textureWidth;

			}
			
			dispatchEvent( new Event(Event.RESIZE));

		}
		
		public function get viewHeight():Number
		{
			return _viewHeight;
		}

		public function set viewHeight(value:Number):void
		{
			if (value == _viewHeight)
            {

                return;

            }

			_viewHeight = value;

            _buffersInvalid = true;

            _textureHeight = TextureUtils.getBestPowerOf2(_viewHeight);
			
			if ( _textureHeight > _viewHeight)
            {

                _renderToTextureRect.y = Math.floor((_textureHeight - _viewHeight)*.5);
                _renderToTextureRect.height = _viewHeight;

			}
            else
            {

                _renderToTextureRect.y = 0;
                _renderToTextureRect.height = _textureHeight;

			}
			
			dispatchEvent(new Event(Event.RESIZE));

		}
		
		public function get renderToTextureVertexBuffer():VertexBuffer3D
		{

			if (_buffersInvalid)
            {

                updateRTTBuffers();

            }

			return _renderToTextureVertexBuffer;
		}
		
		public function get renderToScreenVertexBuffer():VertexBuffer3D
		{

			if (_buffersInvalid)
            {

                updateRTTBuffers();

            }

			return _renderToScreenVertexBuffer;

		}
		
		public function get indexBuffer():IndexBuffer3D
		{
			return _indexBuffer;
		}
		
		public function get renderToTextureRect():Rectangle
		{

			if (_buffersInvalid)
            {

				updateRTTBuffers();

            }

			return _renderToTextureRect;
		}
		
		public function get textureWidth():Number
		{
			return _textureWidth;
		}
		
		public function get textureHeight():Number
		{
			return _textureHeight;
		}
		
		public function dispose():void
		{

            RTTBufferManager.deleteRTTBufferManager( _stage3DProxy );

			if (_indexBuffer)
            {

                _indexBuffer.dispose();
                _renderToScreenVertexBuffer.dispose();
                _renderToTextureVertexBuffer.dispose();
                _renderToScreenVertexBuffer = null;
                _renderToTextureVertexBuffer = null;
                _indexBuffer = null;

			}
		}
		
		// todo: place all this in a separate model, since it's used all over the place
		// maybe it even has a place in the core (together with screenRect etc)?
		// needs to be stored per view of course
		private function updateRTTBuffers():void
		{
			var context:Context3D = _stage3DProxy._iContext3D;
			var textureVerts:Vector.<Number>;
			var screenVerts:Vector.<Number>;

			var x:Number;
            var y:Number;

            if ( _renderToTextureVertexBuffer  == null )
            {

                _renderToTextureVertexBuffer = context.createVertexBuffer(4, 5);

            }

            if ( _renderToScreenVertexBuffer == null )
            {

                _renderToScreenVertexBuffer = context.createVertexBuffer(4, 5);

            }

			if (!_indexBuffer)
            {

				_indexBuffer = context.createIndexBuffer(6);

                _indexBuffer.uploadFromArray( new <Number>[2, 1, 0, 3, 2, 0], 0, 6);
			}
			
			_textureRatioX = x = Math.min(_viewWidth/_textureWidth, 1);
            _textureRatioY = y = Math.min(_viewHeight/_textureHeight, 1);
			
			var u1:Number = (1 - x)*.5;
			var u2:Number = (x + 1)*.5;
			var v1:Number = (y + 1)*.5;
			var v2:Number = (1 - y)*.5;
			
			// last element contains indices for data per vertex that can be passed to the vertex shader if necessary (ie: frustum corners for deferred rendering)
			textureVerts = new <Number>[    -x, -y, u1, v1, 0,
				                x, -y, u2, v1, 1,
				                x, y, u2, v2, 2,
				                -x, y, u1, v2, 3 ];
			
			screenVerts = new <Number>[     -1, -1, u1, v1, 0,
				                1, -1, u2, v1, 1,
				                1, 1, u2, v2, 2,
				                -1, 1, u1, v2, 3 ];
			
			_renderToTextureVertexBuffer.uploadFromArray(textureVerts, 0, 4);
            _renderToScreenVertexBuffer.uploadFromArray(screenVerts, 0, 4);
			
			_buffersInvalid = false;
			
		}
	}
}