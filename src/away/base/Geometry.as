///<reference path="../_definitions.ts"/>
package away.base
{
	import away.library.assets.NamedAssetBase;
	import away.library.assets.IAsset;
	import away.library.assets.AssetType;
	import away.geom.Matrix3D;
	import away.events.GeometryEvent;

	/**
	public class Geometry extends NamedAssetBase implements IAsset
	{
        private var _subGeometries:Vector.<ISubGeometry>;//Vector.<ISubGeometry>;//private var _subGeometries:Vector.<ISubGeometry>;
		override public function get assetType():String
		{

			return AssetType.GEOMETRY;

		}
		
		/**
        public function get subGeometries():Vector.<ISubGeometry>//Vector.<ISubGeometry>

            return _subGeometries;

        }
        public function getSubGeometries():Vector.<ISubGeometry>//Vector.<ISubGeometry>

            return _subGeometries;

        }

        /**
		public function Geometry():void
		{
            super();

            this._subGeometries = new Vector.<ISubGeometry>();//Vector.<ISubGeometry>();

		}
		
		public function applyTransformation(transform:Matrix3D):void
		{
			var len:Number = _subGeometries.length;
			for (var i:Number = 0; i < len; ++i)
            {

                _subGeometries[i].applyTransformation(transform);

            }

		}
		
		/**
		public function addSubGeometry(subGeometry:ISubGeometry):void
		{
			_subGeometries.push(subGeometry);
			
			subGeometry.parentGeometry = this;

            // TODO: add hasEventListener optimisation;
			//if (hasEventListener(GeometryEvent.SUB_GEOMETRY_ADDED))
			dispatchEvent(new GeometryEvent(GeometryEvent.SUB_GEOMETRY_ADDED, subGeometry));
			
			iInvalidateBounds(subGeometry);

		}
		
		/**
		public function removeSubGeometry(subGeometry:ISubGeometry):void
		{
			_subGeometries.splice(_subGeometries.indexOf(subGeometry), 1);

			subGeometry.parentGeometry = null;

            // TODO: add hasEventListener optimisation;
			//if (hasEventListener(GeometryEvent.SUB_GEOMETRY_REMOVED))
				dispatchEvent(new GeometryEvent(GeometryEvent.SUB_GEOMETRY_REMOVED, subGeometry));

            iInvalidateBounds( subGeometry );
		}
		
		/**
		public function clone():Geometry
		{
			var clone:Geometry = new Geometry();
			var len:Number = _subGeometries.length;

			for (var i:Number = 0; i < len; ++i)
            {

                clone.addSubGeometry(_subGeometries[i].clone());

            }

			return clone;
		}
		
		/**
		public function scale(scale:Number):void
		{
			var numSubGeoms:Number = _subGeometries.length;
			for (var i:Number = 0; i < numSubGeoms; ++i)
            {

                _subGeometries[i].scale(scale);

            }

		}
		
		/**
		override public function dispose():void
		{

			var numSubGeoms:Number = _subGeometries.length;
			
			for (var i:Number = 0; i < numSubGeoms; ++i)
            {
				var subGeom:ISubGeometry = _subGeometries[0];
                removeSubGeometry(subGeom);
				subGeom.dispose();
			}

		}
		
		/**
		public function scaleUV(scaleU:Number = 1, scaleV:Number = 1):void
		{
			var numSubGeoms:Number = _subGeometries.length;

			for (var i:Number = 0; i < numSubGeoms; ++i)
            {

                _subGeometries[i].scaleUV(scaleU, scaleV);

            }

		}
		
		/**
		public function convertToSeparateBuffers():void
		{
			var subGeom:ISubGeometry;
			var numSubGeoms:Number = _subGeometries.length;
			var _removableCompactSubGeometries:Vector.<CompactSubGeometry> = new Vector.<CompactSubGeometry>();//Vector.<CompactSubGeometry> = new Vector.<CompactSubGeometry>();

			for (var i:Number = 0; i < numSubGeoms; ++i)
            {
				subGeom = _subGeometries[i];

				if (subGeom instanceof SubGeometry)
                {

                    continue;

                }


				_removableCompactSubGeometries.push( CompactSubGeometry(subGeom));

				addSubGeometry(subGeom.cloneWithSeperateBuffers());
			}

            var l : Number = _removableCompactSubGeometries.length;
            var s : CompactSubGeometry;

            for ( var c : Number = 0 ; c  < l ; c++ )
            {

                s = _removableCompactSubGeometries[c];
                removeSubGeometry( s );
                s.dispose();

            }

		}
		
		public function iValidate():void
		{
			// To be overridden when necessary
		}
		
		public function iInvalidateBounds(subGeom:ISubGeometry):void
		{
			//if (hasEventListener(GeometryEvent.BOUNDS_INVALID))
			dispatchEvent(new GeometryEvent(GeometryEvent.BOUNDS_INVALID, subGeom));

		}

	}

}