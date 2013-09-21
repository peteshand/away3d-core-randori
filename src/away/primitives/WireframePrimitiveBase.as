/** * ... * @author Gary Paluk - http://www.plugin.io */

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
			this._color = color;
			this._thickness = thickness;
			this.mouseEnabled = false;
			this.mouseChildren = false;

		}
		
		public function get color():Number
		{
			return this._color;
		}
		
		public function set color(value:Number):void
		{
			this._color = value;
			
			for( var segRef in this._pSegments )
			{
				segRef.segment.startColor = value;
				segRef.segment.endColor = value;

			}
		}
		
		public function get thickness():Number
		{
			return this._thickness;
		}
		
		public function set thickness(value:Number):void
		{
			this._thickness = value;
			
			for( var segRef in this._pSegments)
			{
				segRef.segment.thickness = value;
				segRef.segment.thickness = value;

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
			if( this._geomDirty )
			{
				this.updateGeometry();
			}
			return super.getBounds();
		}
		
		public function pBuildGeometry():void
		{
			throw new AbstractMethodError();
		}
		
		public function pInvalidateGeometry():void
		{
			this._geomDirty = true;
			this.pInvalidateBounds();
		}
		
		private function updateGeometry():void
		{
			this.pBuildGeometry();
			this._geomDirty = false;
		}
		
		public function pUpdateOrAddSegment(index:Number, v0:Vector3D, v1:Vector3D):void
		{
			var segment:Segment;
			var s:Vector3D;
			var e:Vector3D;
			
			if( (segment = this.getSegment(index)) != null )
			{
				s = segment.start;
				e = segment.end;
				s.x = v0.x;
				s.y = v0.y;
				s.z = v0.z;
				e.x = v1.x;
				e.y = v1.y;
				e.z = v1.z;
				segment.updateSegment(s, e, null, this._color, this._color, this._thickness );
			}
			else
			{
				this.addSegment( new LineSegment( v0.clone(), v1.clone(), this._color, this._color, this._thickness) );
			}
		}
		
		//@override
		override public function pUpdateMouseChildren():void
		{
			this._iAncestorsAllowMouseEnabled = false;
		}
		
	}
}