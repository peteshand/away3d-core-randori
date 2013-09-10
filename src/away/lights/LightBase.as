/** * ... * @author Gary Paluk - http://www.plugin.io */

///<reference path="../_definitions.ts" />

package away.lights
{
	import away.entities.Entity;
	import away.lights.shadowmaps.ShadowMapperBase;
	import away.events.LightEvent;
	import away.errors.AbstractMethodError;
	import away.base.IRenderable;
	import away.geom.Matrix3D;
	import away.partition.EntityNode;
	import away.partition.LightNode;
	import away.library.assets.AssetType;
	public class LightBase extends Entity
	{
		
		private var _color:Number = 0xffffff;
		private var _colorR:Number = 1;
		private var _colorG:Number = 1;
		private var _colorB:Number = 1;
		
		private var _ambientColor:Number = 0xffffff;
		private var _ambient:Number = 0;
		public var _iAmbientR:Number = 0;
		public var _iAmbientG:Number = 0;
		public var _iAmbientB:Number = 0;
		
		private var _specular:Number = 1;
		public var _iSpecularR:Number = 1;
		public var _iSpecularG:Number = 1;
		public var _iSpecularB:Number = 1;
		
		private var _diffuse:Number = 1;
		public var _iDiffuseR:Number = 1;
		public var _iDiffuseG:Number = 1;
		public var _iDiffuseB:Number = 1;
		
		private var _castsShadows:Boolean = false;
		
		private var _shadowMapper:ShadowMapperBase;
		
		public function LightBase():void
		{
			super();
		}
		
		public function get castsShadows():Boolean
		{
			return _castsShadows;
		}
		
		public function set castsShadows(value:Boolean):void
		{
			if( _castsShadows == value )
			{
				return;
			}
			
			_castsShadows = value;
			
			if( value )
			{

                if ( _shadowMapper == null )
                {

                    _shadowMapper = pCreateShadowMapper();

                }

				_shadowMapper.light = this;
			} else {
                _shadowMapper.dispose();
                _shadowMapper = null;
			}
			//*/
			dispatchEvent(new LightEvent( LightEvent.CASTS_SHADOW_CHANGE) );
		}
		
		public function pCreateShadowMapper():ShadowMapperBase
		{
			throw new AbstractMethodError();
		}

		public function get specular():Number
		{
			return _specular;
		}
		
		public function set specular(value:Number):void
		{
			if( value < 0 )
			{
				value = 0;
			}
			_specular = value;
			updateSpecular();
		}
		
		public function get diffuse():Number
		{
			return _diffuse;
		}
		
		public function set diffuse(value:Number):void
		{
			if (value < 0)
			{
				value = 0;
			}
			_diffuse = value;
			updateDiffuse();
		}
		
		public function get color():Number
		{
			return _color;
		}
		
		public function set color(value:Number):void
		{
			_color = value;
			_colorR = ((_color >> 16) & 0xff)/0xff;
			_colorG = ((_color >> 8) & 0xff)/0xff;
			_colorB = (_color & 0xff)/0xff;
			updateDiffuse();
			updateSpecular();
		}
		
		public function get ambient():Number
		{
			return _ambient;
		}
		
		public function set ambient(value:Number):void
		{
			if( value < 0 )
			{
				value = 0;
			}
			else if( value > 1 )
			{
				value = 1;
			}
			_ambient = value;
			updateAmbient();
		}
		
		public function get ambientColor():Number
		{
			return _ambientColor;
		}
		
		public function set ambientColor(value:Number):void
		{
			_ambientColor = value;
			updateAmbient();
		}
		
		private function updateAmbient():void
		{
			_iAmbientR = ((_ambientColor >> 16) & 0xff)/0xff*_ambient;
			_iAmbientG = ((_ambientColor >> 8) & 0xff)/0xff*_ambient;
			_iAmbientB = (_ambientColor & 0xff)/0xff*_ambient;
		}
		
		public function iGetObjectProjectionMatrix(renderable:IRenderable, target:Matrix3D = null):Matrix3D
		{
			throw new AbstractMethodError();
		}
		
		//@override
		override public function pCreateEntityPartitionNode():EntityNode
		{
			return new LightNode( this );
		}
		
		//@override
		override public function get assetType():String
		{
			return AssetType.LIGHT;
		}
		
		private function updateSpecular():void
		{
			_iSpecularR = _colorR*_specular;
			_iSpecularG = _colorG*_specular;
			_iSpecularB = _colorB*_specular;
		}
		
		private function updateDiffuse():void
		{
			_iDiffuseR = _colorR*_diffuse;
			_iDiffuseG = _colorG*_diffuse;
			_iDiffuseB = _colorB*_diffuse;
		}
		
		public function get shadowMapper():ShadowMapperBase
		{
			return _shadowMapper;
		}

		public function set shadowMapper(value:ShadowMapperBase):void
		{
			_shadowMapper = value;
			_shadowMapper.light = this;
		}
	}
}