
///<reference path="../_definitions.ts"/>

package away.render
{
	import away.filters.Filter3DBase;
	import away.filters.tasks.Filter3DTaskBase;
	import away.display3D.Texture;
	import away.managers.RTTBufferManager;
	import away.managers.Stage3DProxy;
	import away.events.Event;
	import away.cameras.Camera3D;
	import away.display3D.Context3D;
	import away.display3D.IndexBuffer3D;
	import away.display3D.VertexBuffer3D;
	import away.display3D.Context3DVertexBufferFormat;
	import away.display3D.Context3DBlendFactor;

	public class Filter3DRenderer
	{
		private var _filters:Vector.<Filter3DBase>; // TODO: check / changed to strongly typed array		private var _tasks:Vector.<Filter3DTaskBase>;//Vector.<Filter3DTaskBase>;		private var _filterTasksInvalid:Boolean;
		private var _mainInputTexture:Texture;
		private var _requireDepthRender:Boolean;
		private var _rttManager:RTTBufferManager;
		private var _stage3DProxy:Stage3DProxy;
		private var _filterSizesInvalid:Boolean = true;
		
		public function Filter3DRenderer(stage3DProxy:Stage3DProxy):void
		{

			_stage3DProxy = stage3DProxy;
            _rttManager = RTTBufferManager.getInstance(stage3DProxy);
            _rttManager.addEventListener(Event.RESIZE, onRTTResize , this );

		}
		
		private function onRTTResize(event:Event):void
		{
			_filterSizesInvalid = true;
		}
		
		public function get requireDepthRender():Boolean
		{
			return _requireDepthRender;
		}
		
		public function getMainInputTexture(stage3DProxy:Stage3DProxy):Texture
		{
			if (_filterTasksInvalid)
            {

                updateFilterTasks(stage3DProxy);

            }

			return _mainInputTexture;
		}
		
		public function get filters():Vector.<Filter3DBase>
		{
			return _filters;
		}
		
		public function set filters(value:Vector.<Filter3DBase>):void
		{
            _filters = value;

            _filterTasksInvalid = true;

            _requireDepthRender = false;

			if (!_filters)
            {

                return;

            }

			for (var i:Number = 0; i < _filters.length; ++i)
            {

                // TODO: check logic:
                // this._requireDepthRender ||=  Boolean ( this._filters[i].requireDepthRender )

                var s : * = _filters[i];
                var b : Boolean = (( s.requireDepthRender == null ) as Boolean)? false : s.requireDepthRender;

				_requireDepthRender = _requireDepthRender || b;

            }

			_filterSizesInvalid = true;

		}
		
		private function updateFilterTasks(stage3DProxy:Stage3DProxy):void
		{
			var len:Number;
			
			if (_filterSizesInvalid)
            {

                updateFilterSizes();

            }

			if (!_filters)
            {
				_tasks = null;
				return;
			}
			
			_tasks = new Vector.<Filter3DTaskBase>();
			
			len = _filters.length - 1;
			
			var filter:Filter3DBase;
			
			for (var i:Number = 0; i <= len; ++i)
            {

				// make sure all internal tasks are linked together
				filter = _filters[i];

                // TODO: check logic
                // filter.setRenderTargets(i == len? null : Filter3DBase(_filters[i + 1]).getMainInputTexture(stage3DProxy), stage3DProxy);

				filter.setRenderTargets(i == len? null : _filters[i + 1].getMainInputTexture(stage3DProxy), stage3DProxy);

				_tasks = _tasks.concat(filter.tasks);

			}
			
			_mainInputTexture = _filters[0].getMainInputTexture(stage3DProxy);

		}
		
		public function render(stage3DProxy:Stage3DProxy, camera3D:Camera3D, depthTexture:Texture):void
		{
			var len:Number;
			var i:Number;
			var task:Filter3DTaskBase;
			var context:Context3D = stage3DProxy._iContext3D;

			var indexBuffer:IndexBuffer3D = _rttManager.indexBuffer;

			var vertexBuffer:VertexBuffer3D = _rttManager.renderToTextureVertexBuffer;
			
			if (!_filters)
            {
                return;
            }

			if (_filterSizesInvalid)
            {
                updateFilterSizes();
            }

			if ( _filterTasksInvalid)
            {
                updateFilterTasks(stage3DProxy);
            }

			len = _filters.length;

			for (i = 0; i < len; ++i)
            {
				_filters[i].update(stage3DProxy, camera3D);
            }

			len = _tasks.length;
			
			if (len > 1)
            {
				context.setVertexBufferAt(0, vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_2);
				context.setVertexBufferAt(1, vertexBuffer, 2, Context3DVertexBufferFormat.FLOAT_2);
			}
			
			for (i = 0; i < len; ++i)
            {

				task = _tasks[i];

				stage3DProxy.setRenderTarget(task.target);
				
				if (!task.target)
                {

					stage3DProxy.scissorRect = null;
					vertexBuffer = _rttManager.renderToScreenVertexBuffer;
					context.setVertexBufferAt(0, vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_2);
					context.setVertexBufferAt(1, vertexBuffer, 2, Context3DVertexBufferFormat.FLOAT_2);

				}

				context.setTextureAt(0, task.getMainInputTexture(stage3DProxy));
				context.setProgram(task.getProgram3D(stage3DProxy));
				context.clear(0.0, 0.0, 0.0, 0.0);

				task.activate(stage3DProxy, camera3D, depthTexture);

				context.setBlendFactors(Context3DBlendFactor.ONE, Context3DBlendFactor.ZERO);
				context.drawTriangles(indexBuffer, 0, 2);

				task.deactivate(stage3DProxy);
			}
			
			context.setTextureAt(0, null);
			context.setVertexBufferAt(0, null);
			context.setVertexBufferAt(1, null);
		}
		
		private function updateFilterSizes():void
		{
			for (var i:Number = 0; i < _filters.length; ++i)
            {
				_filters[i].textureWidth = _rttManager.textureWidth;
                _filters[i].textureHeight = _rttManager.textureHeight;
			}

            _filterSizesInvalid = true;

		}
		
		public function dispose():void
		{
            _rttManager.removeEventListener(Event.RESIZE, onRTTResize , this );
            _rttManager = null;
            _stage3DProxy = null;
		}
	}

}
