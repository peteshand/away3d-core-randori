/** * ... * @author Gary Paluk - http://www.plugin.io */

///<reference path="../../_definitions.ts"/>

package away.primitives.data
{
	import away.entities.SegmentSet;
	import away.geom.Vector3D;
	public class Segment
	{
		public var _pSegmentsBase:SegmentSet;
		public var _pThickness:Number;
		public var _pStart:Vector3D;
		public var _pEnd:Vector3D;
		public var _pStartR:Number;
		public var _pStartG:Number;
		public var _pStartB:Number;
		public var _pEndR:Number;
		public var _pEndG:Number;
		public var _pEndB:Number;
		
		private var _index:Number = -1;
		private var _subSetIndex:Number = -1;
		private var _startColor:Number;
		private var _endColor:Number;
		
		public function Segment(start:Vector3D, end:Vector3D, anchor:Vector3D, colorStart:Number = 0x333333, colorEnd:Number = 0x333333, thickness:Number = 1):void
		{
			// TODO: not yet used: for CurveSegment support
			anchor = null;
			
			this._pThickness = thickness * 0.5;
			// TODO: add support for curve using anchor v1
			// Prefer removing v1 from this, and make Curve a separate class extending Segment? (- David)
			this._pStart = start;
			this._pEnd = end;
			this.startColor = colorStart;
			this.endColor = colorEnd;
		}
		
		public function updateSegment(start:Vector3D, end:Vector3D, anchor:Vector3D, colorStart:Number = 0x333333, colorEnd:Number = 0x333333, thickness:Number = 1):void
		{
			// TODO: not yet used: for CurveSegment support
			anchor = null;
			_pStart = start;
			_pEnd = end;
			
			if( _startColor != colorStart )
			{
				startColor = colorStart;
			}
			if( _endColor != colorEnd )
			{
				endColor = colorEnd;
			}
			_pThickness = thickness * 0.5;
			update();
		}
		
		public function get start():Vector3D
		{
			return _pStart;
		}
		
		
		public function set start(value:Vector3D):void
		{
			this._pStart = value;
			this.update();
		}
		
		public function get end():Vector3D
		{
			return _pEnd;
		}
		
		public function set end(value:Vector3D):void
		{
			this._pEnd = value;
			this.update();
		}
		
		public function get thickness():Number
		{
			return _pThickness * 2;
		}
		
		public function set thickness(value:Number):void
		{
			this._pThickness = value * 0.5;
			this.update();
		}
		
		public function get startColor():Number
		{
			return _startColor;
		}
		
		public function set startColor(color:Number):void
		{
			this._pStartR = ( ( color >> 16 ) & 0xff )/255;
			this._pStartG = ( ( color >> 8 ) & 0xff )/255;
			this._pStartB = ( color & 0xff )/255;
			
			this._startColor = color;
			
			this.update();
		}
		
		public function get endColor():Number
		{
			return _endColor;
		}
		
		public function set endColor(color:Number):void
		{
			this._pEndR = ( ( color >> 16 ) & 0xff )/255;
			this._pEndG = ( ( color >> 8 ) & 0xff )/255;
			this._pEndB = ( color & 0xff )/255;
			
			this._endColor = color;
			
			this.update();
		}
		
		public function dispose():void
		{
			_pStart = null;
			_pEnd = null;
		}
		
		public function get iIndex():Number
		{
			return _index;
		}
		
		public function set iIndex(ind:Number):void
		{
			this._index = ind;
		}
		
		public function get iSubSetIndex():Number
		{
			return _subSetIndex;
		}
		
		public function set iSubSetIndex(ind:Number):void
		{
			this._subSetIndex = ind;
		}
		
		public function set iSegmentsBase(segBase:SegmentSet):void
		{
			this._pSegmentsBase = segBase;
		}
		
		private function update():void
		{
			if( !_pSegmentsBase )
			{
				return;
			}
			_pSegmentsBase.iUpdateSegment( this );
		}
	}
}