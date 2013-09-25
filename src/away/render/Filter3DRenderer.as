/**
 * ...
 * @author Away3D Team - http://away3d.com/team/ (Original Development)
 * @author Karim Beyrouti - http://kurst.co.uk/ (ActionScript to TypeScript port)
 * @author Gary Paluk - http://www.plugin.io/ (ActionScript to TypeScript port)
 * @author Pete Shand - http://www.peteshand.net/ (TypeScript to Randori port)
 */

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
		private var _filters:Vector.<Filter3DBase>;// TODO: check / changed to strongly typed array
		private var _tasks:Vector.<Filter3DTaskBase>;//Vector.<Filter3DTaskBase>
		private var _filterTasksInvalid:Boolean = false;
		private var _mainInputTexture:Texture;
		private var _requireDepthRender:Boolean = false;
		private var _rttManager:RTTBufferManager;
		private var _stage3DProxy:Stage3DProxy;
		private var _filterSizesInvalid:Boolean = true;
		
		public function Filter3DRenderer(stage3DProxy:Stage3DProxy):void
		{

			this._stage3DProxy = stage3DProxy;
            this._rttManager = RTTBufferManager.getInstance(stage3DProxy);
            this._rttManager.addEventListener(Event.RESIZE, onRTTResize , this );

		}
		
		private function onRTTResize(event:Event):void
		{
			this._filterSizesInvalid = true;
		}
		
		public function get requireDepthRender():Boolean
		{
			return this._requireDepthRender;
		}
		
		public function getMainInputTexture(stage3DProxy:Stage3DProxy):Texture
		{
			if (this._filterTasksInvalid)
            {

                this.updateFilterTasks(stage3DProxy);

            }

			return this._mainInputTexture;
		}
		
		public function get filters():Vector.<Filter3DBase>
		{
			return this._filters;
		}
		
		public function set filters(value:Vector.<Filter3DBase>):void
		{
            this._filters = value;

            this._filterTasksInvalid = true;

            this._requireDepthRender = false;

			if (!this._filters)
            {

                return;

            }

			for (var i:Number = 0; i < this._filters.length; ++i)
            {

                // TODO: check logic:
                // this._requireDepthRender ||=  Boolean ( this._filters[i].requireDepthRender )

                var s : * = this._filters[i];
                var b : Boolean = (( s.requireDepthRender == null  ) as Boolean)? false : s.requireDepthRender;

				this._requireDepthRender = this._requireDepthRender || b;

            }

			this._filterSizesInvalid = true;

		}
		
		private function updateFilterTasks(stage3DProxy:Stage3DProxy):void
		{
			var len:Number;
			
			if (this._filterSizesInvalid)
            {

                this.updateFilterSizes();

            }

			if (!this._filters)
            {
				this._tasks = null;
				return;
			}
			
			this._tasks = new Vector.<Filter3DTaskBase>();
			
			len = this._filters.length - 1;
			
			var filter:Filter3DBase;
			
			for (var i:Number = 0; i <= len; ++i)
            {

				// make sure all internal tasks are linked together
				filter = this._filters[i];

                // TODO: check logic
                // filter.setRenderTargets(i == len? null : Filter3DBase(_filters[i + 1]).getMainInputTexture(stage3DProxy), stage3DProxy);

				filter.setRenderTargets(i == len? null : this._filters[i + 1].getMainInputTexture(stage3DProxy), stage3DProxy);

				this._tasks = this._tasks.concat(filter.tasks);

			}
			
			this._mainInputTexture = this._filters[0].getMainInputTexture(stage3DProxy);

		}
		
		public function render(stage3DProxy:Stage3DProxy, camera3D:Camera3D, depthTexture:Texture):void
		{
			var len:Number;
			var i:Number;
			var task:Filter3DTaskBase;
			var context:Context3D = stage3DProxy._iContext3D;

			var indexBuffer:IndexBuffer3D = this._rttManager.indexBuffer;

			var vertexBuffer:VertexBuffer3D = this._rttManager.renderToTextureVertexBuffer;
			
			if (!this._filters)
            {
                return;
            }

			if (this._filterSizesInvalid)
            {
                this.updateFilterSizes();
            }

			if ( this._filterTasksInvalid)
            {
                this.updateFilterTasks(stage3DProxy);
            }

			len = this._filters.length;

			for (i = 0; i < len; ++i)
            {
				this._filters[i].update(stage3DProxy, camera3D);
            }

			len = this._tasks.length;
			
			if (len > 1)
            {
				context.setVertexBufferAt(0, vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_2);
				context.setVertexBufferAt(1, vertexBuffer, 2, Context3DVertexBufferFormat.FLOAT_2);
			}
			
			for (i = 0; i < len; ++i)
            {

				task = this._tasks[i];

				stage3DProxy.setRenderTarget(task.target);
				
				if (!task.target)
                {

					stage3DProxy.scissorRect = null;
					vertexBuffer = this._rttManager.renderToScreenVertexBuffer;
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
			for (var i:Number = 0; i < this._filters.length; ++i)
            {
				this._filters[i].textureWidth = this._rttManager.textureWidth;
                this._filters[i].textureHeight = this._rttManager.textureHeight;
			}

            this._filterSizesInvalid = true;

		}
		
		public function dispose():void
		{
            this._rttManager.removeEventListener(Event.RESIZE, onRTTResize , this );
            this._rttManager = null;
            this._stage3DProxy = null;
		}
	}

}
