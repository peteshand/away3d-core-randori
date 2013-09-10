/**
 * ...
 * @author Gary Paluk - http://www.plugin.io
 */
///<reference path="../_definitions.ts"/>

package away.primitives
{
	import away.entities.SegmentSet;
	import away.bounds.BoundingVolumeBase;
	import away.errors.AbstractMethodError;
	import away.geom.Vector3D;
	import away.primitives.data.Segment;
	public class WireframePrimitiveBase extends SegmentSet
	{
		private var _geomDirty:Boolean = true;
		private var _color:Number;
		private var _thickness:Number;
		
		public function WireframePrimitiveBase(color:Number = 0xffffff, thickness:Number = 1):void
		{
			super();
			if( thickness <= 0 )
			{
				thickness = 1;
			}
			_color = color;
			_thickness = thickness;
			mouseEnabled = mouseChildren = false;
		}
		
		public function get color():Number
		{
			return _color;
		}
		
		public function set color(value:Number):void
		{
			_color = value;
			
			for( var segRef in _pSegments )
			{
				segRef.segment.startColor = segRef.segment.endColor = value;
			}
		}
		
		public function get thickness():Number
		{
			return _thickness;
		}
		
		public function set thickness(value:Number):void
		{
			_thickness = value;
			
			for( var segRef in _pSegments)
			{
				segRef.segment.thickness = segRef.segment.thickness = value;
			}
		}
		
		//@override
		override public function removeAllSegments():void
		{
			super.removeAllSegments();
		}
		
		//@override
		override public function getBounds():BoundingVolumeBase
		{
			if( _geomDirty )
			{
				updateGeometry();
			}
			return super.getBounds();
		}
		
		public function pBuildGeometry():void
		{
			throw new AbstractMethodError();
		}
		
		public function pInvalidateGeometry():void
		{
			_geomDirty = true;
			pInvalidateBounds();
		}
		
		private function updateGeometry():void
		{
			pBuildGeometry();
			_geomDirty = false;
		}
		
		public function pUpdateOrAddSegment(index:Number, v0:Vector3D, v1:Vector3D):void
		{
			var segment:Segment;
			var s:Vector3D;
			var e:Vector3D;
			
			if( (segment = getSegment(index)) != null )
			{
				s = segment.start;
				e = segment.end;
				s.x = v0.x;
				s.y = v0.y;
				s.z = v0.z;
				e.x = v1.x;
				e.y = v1.y;
				e.z = v1.z;
				segment.updateSegment(s, e, null, _color, _color, _thickness );
			}
			else
			{
				addSegment( new LineSegment( v0.clone(), v1.clone(), _color, _color, _thickness) );
			}
		}
		
		//@override
		override public function pUpdateMouseChildren():void
		{
			_iAncestorsAllowMouseEnabled = false;
		}
		
	}
}