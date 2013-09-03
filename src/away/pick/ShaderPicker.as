

///<reference path="../_definitions.ts"/>

package away.pick
{
	import away.managers.Stage3DProxy;
	import away.display3D.Context3D;
	import away.display3D.Program3D;
	import away.display.BitmapData;
	import away.base.IRenderable;
	import away.entities.Entity;
	import away.geom.Vector3D;
	import away.geom.Point;
	import away.geom.Rectangle;
	import away.containers.View3D;
	import away.utils.Debug;
	import away.traverse.EntityCollector;
	import away.containers.Scene3D;
	import away.display3D.TextureBase;
	import away.cameras.Camera3D;
	import away.display3D.Context3DBlendFactor;
	import away.display3D.Context3DCompareMode;
	import away.display3D.Context3DProgramType;
	import away.data.RenderableListItem;
	import away.geom.Matrix3D;
	import away.math.Matrix3DUtils;
	import away.display3D.Context3DTriangleFace;
	import aglsl.AGLSLCompiler;
	import away.display3D.Context3DClearMask;
	import away.base.SubMesh;
	import away.base.ISubGeometry;
	import away.utils.GeometryUtils;
	//import away3d.arcane;
	//import away3d.cameras.*;
	//import away3d.containers.*;
	//import away3d.core.base.*;
	//import away3d.core.data.*;
	//import away3d.managers.*;
	//import away3d.core.math.*;
	//import away3d.core.traverse.*;
	//import away3d.entities.*;
	//import away3d.utils.GeometryUtils;
	
	//import flash.display.*;
	//import flash.display3D.*;
	//import flash.display3D.textures.*;
	//import flash.geom.*;
	
	//import com.adobe.utils.*;
	
	//use namespace arcane;
	
	/**

    // TODO: Dependencies needed to before implementing IPicker - EntityCollector
	public class ShaderPicker implements IPicker
	{
		private var _stage3DProxy:Stage3DProxy;
		private var _context:Context3D;
		private var _onlyMouseEnabled:Boolean = true;
		
		private var _objectProgram3D:Program3D;
		private var _triangleProgram3D:Program3D;
		private var _bitmapData:BitmapData;
		private var _viewportData:Vector.<Number>;
		private var _boundOffsetScale:Vector.<Number>;
		private var _id:Vector.<Number>;
		
		private var _interactives:Vector.<IRenderable> = new Vector.<IRenderable>();//Vector.<IRenderable> = new Vector.<IRenderable>();
		private var _hitColor:Number;
		private var _projX:Number;
		private var _projY:Number;
		
		private var _hitRenderable:IRenderable;
		private var _hitEntity:Entity;
		private var _localHitPosition:Vector3D = new Vector3D();
		private var _hitUV:Point = new Point();
		private var _faceIndex:Number;
		private var _subGeometryIndex:Number;
		
		private var _localHitNormal:Vector3D = new Vector3D();
		
		private var _rayPos:Vector3D = new Vector3D();
		private var _rayDir:Vector3D = new Vector3D();
		private var _potentialFound:Boolean;
		private static var MOUSE_SCISSOR_RECT:Rectangle = new Rectangle(0, 0, 1, 1);
		
		/**
		public function get onlyMouseEnabled():Boolean
		{
			return _onlyMouseEnabled;
		}
		
		public function set onlyMouseEnabled(value:Boolean):void
		{
            this._onlyMouseEnabled = value;
		}
		
		/**
		public function ShaderPicker():void
		{
			this._id = new Vector.<Number>( 4 );//new Vector.<Number>(4, true);
			this._viewportData = new Vector.<Number>( 4 );//new Vector.<Number>(4, true); // first 2 contain scale, last 2 translation
			this._boundOffsetScale = new Vector.<Number>( 8 );//new Vector.<Number>(8, true); // first 2 contain scale, last 2 translation
			this._boundOffsetScale[3] = 0;
			this._boundOffsetScale[7] = 1;
		}
		
		/**
        // TODO implement dependency : EntityCollector
        // TODO: GLSL implementation / conversion
		public function getViewCollision(x:Number, y:Number, view:View3D):PickingCollisionVO
		{

            Debug.throwPIR( 'ShaderPicker' , 'getViewCollision' , 'implement' );

            return null;


			var collector:EntityCollector = view.iEntityCollector;
			
			_stage3DProxy = view.stage3DProxy;
			
			if (!_stage3DProxy)
				return null;
			
			_context = _stage3DProxy._iContext3D;
			
			_viewportData[0] = view.width;
            _viewportData[1] = view.height;
            _viewportData[2] = -(_projX = 2*x/view.width - 1);
            _viewportData[3] = _projY = 2*y/view.height - 1;
			
			// _potentialFound will be set to true if any object is actually rendered
			_potentialFound = false;

            pDraw(collector, null);
			
			// clear buffers
			_context.setVertexBufferAt(0, null);
			
			if (!_context || !_potentialFound)
            {
				return null;
            }

			if (!_bitmapData)
                _bitmapData = new BitmapData(1, 1, false, 0);
			
			_context.drawToBitmapData(_bitmapData);
			_hitColor = _bitmapData.getPixel(0, 0);
			
			if (!_hitColor) {
                _context.present();
				return null;
			}

            _hitRenderable = _interactives[_hitColor - 1];
            _hitEntity = _hitRenderable.sourceEntity;
			if (_onlyMouseEnabled && (!_hitEntity._iAncestorsAllowMouseEnabled || !_hitEntity.mouseEnabled))
            {
				return null;
            }

			var _collisionVO:PickingCollisionVO = _hitEntity.pickingCollisionVO;
			if (_hitRenderable.shaderPickingDetails) {
				getHitDetails(view.camera);
				_collisionVO.localPosition = _localHitPosition;
				_collisionVO.localNormal = _localHitNormal;
				_collisionVO.uv = _hitUV;
				_collisionVO.index = _faceIndex;
				_collisionVO.subGeometryIndex = _subGeometryIndex;
				
			} else {
				_collisionVO.localPosition = null;
				_collisionVO.localNormal = null;
				_collisionVO.uv = null;
				_collisionVO.index = 0;
				_collisionVO.subGeometryIndex = 0;
			}
			
			return _collisionVO;
			//*/
		}
		//*/
		/**
		public function getSceneCollision(position:Vector3D, direction:Vector3D, scene:Scene3D):PickingCollisionVO
		{
			return null;
		}
		
		/**
        // TODO: GLSL implementation / conversion
		public function pDraw(entityCollector:EntityCollector, target:TextureBase):void
		{

			var camera:Camera3D = entityCollector.camera;
			
			_context.clear(0, 0, 0, 1);
			_stage3DProxy.scissorRect = ShaderPicker.MOUSE_SCISSOR_RECT;
			
			_interactives.length = _interactiveId = 0;
			
			if (!_objectProgram3D)
            {

                initObjectProgram3D();

            }

			_context.setBlendFactors(Context3DBlendFactor.ONE, Context3DBlendFactor.ZERO);
			_context.setDepthTest(true, Context3DCompareMode.LESS);
			_context.setProgram(_objectProgram3D);
			_context.setProgramConstantsFromArray(Context3DProgramType.VERTEX, 4, _viewportData, 1);
			drawRenderables(entityCollector.opaqueRenderableHead, camera);
			drawRenderables(entityCollector.blendedRenderableHead, camera);

		}

		/**
		private function drawRenderables(item:RenderableListItem, camera:Camera3D):void
		{

            Debug.throwPIR( 'ShaderPicker' , 'drawRenderables' , 'implement' );


			var matrix:Matrix3D = Matrix3DUtils.CALCULATION_MATRIX;
			var renderable:IRenderable;
			var viewProjection:Matrix3D = camera.viewProjection;
			
			while (item)
            {
				renderable = item.renderable;
				
				// it's possible that the renderable was already removed from the scene
				if (!renderable.sourceEntity.scene || (!renderable.mouseEnabled && _onlyMouseEnabled))
                {
					item = item.next;
					continue;
				}
				
				_potentialFound = true;

                _context.setCulling(renderable.material.bothSides? Context3DTriangleFace.NONE : Context3DTriangleFace.BACK);
				
				_interactives[_interactiveId++] = renderable;
				// color code so that reading from bitmapdata will contain the correct value
                _id[1] = (_interactiveId >> 8)/255; // on green channel
                _id[2] = (_interactiveId & 0xff)/255; // on blue channel
				
				matrix.copyFrom(renderable.getRenderSceneTransform(camera));
				matrix.append(viewProjection);
                _context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, matrix, true);
                _context.setProgramConstantsFromArray(Context3DProgramType.FRAGMENT, 0, _id, 1);
				renderable.activateVertexBuffer(0, _stage3DProxy);
                _context.drawTriangles(renderable.getIndexBuffer(_stage3DProxy), 0, renderable.numTriangles);
				
				item = item.next;
			}

		}

		private function updateRay(camera:Camera3D):void
		{

			_rayPos = camera.scenePosition;
            _rayDir = camera.getRay(_projX, _projY, 1);
            _rayDir.normalize();

		}

		/**
		private function initObjectProgram3D():void
		{
			var vertexCode:String;
			var fragmentCode:String;
			
			_objectProgram3D = _context.createProgram();
			
			vertexCode = "m44 vt0, va0, vc0			\n" +
				"mul vt1.xy, vt0.w, vc4.zw	\n" +
				"add vt0.xy, vt0.xy, vt1.xy	\n" +
				"mul vt0.xy, vt0.xy, vc4.xy	\n" +
				"mov op, vt0	\n";
			fragmentCode = "mov oc, fc0"; // write identifier

            Debug.throwPIR( 'ShaderPicker' , 'initTriangleProgram3D' , 'Dependency: initObjectProgram3D')
			//_objectProgram3D.upload(new AGALMiniAssembler().assemble(Context3DProgramType.VERTEX, vertexCode),new AGALMiniAssembler().assemble(Context3DProgramType.FRAGMENT, fragmentCode));
		}
		/**

		private function initTriangleProgram3D():void
		{
			var vertexCode:String;
			var fragmentCode:String;
			
			_triangleProgram3D = _context.createProgram();
			
			// todo: add animation code
			vertexCode = "add vt0, va0, vc5 			\n" +
				"mul vt0, vt0, vc6 			\n" +
				"mov v0, vt0				\n" +
				"m44 vt0, va0, vc0			\n" +
				"mul vt1.xy, vt0.w, vc4.zw	\n" +
				"add vt0.xy, vt0.xy, vt1.xy	\n" +
				"mul vt0.xy, vt0.xy, vc4.xy	\n" +
				"mov op, vt0	\n";
			fragmentCode = "mov oc, v0"; // write identifier

            //away.Debug.throwPIR( 'ShaderPicker' , 'initTriangleProgram3D' , 'Dependency: AGALMiniAssembler')


            var vertCompiler:AGLSLCompiler = new AGLSLCompiler();
            var fragCompiler:AGLSLCompiler = new AGLSLCompiler();

            var vertString : String = vertCompiler.compile( Context3DProgramType.VERTEX, vertexCode );
            var fragString : String = fragCompiler.compile( Context3DProgramType.FRAGMENT, fragmentCode );

            _triangleProgram3D.upload(vertString, fragString);

			//this._triangleProgram3D.upload(new AGALMiniAssembler().assemble(Context3DProgramType.VERTEX, vertexCode), new AGALMiniAssembler().assemble(Context3DProgramType.FRAGMENT, fragmentCode));
		}

		/**
		private function getHitDetails(camera:Camera3D):void
		{
			getApproximatePosition(camera);
			getPreciseDetails(camera);
		}
		/**

		private function getApproximatePosition(camera:Camera3D):void
		{
			var entity:Entity = _hitRenderable.sourceEntity;
			var col:Number;
			var scX:Number, scY:Number, scZ:Number;
			var offsX:Number, offsY:Number, offsZ:Number;
			var localViewProjection:Matrix3D = Matrix3DUtils.CALCULATION_MATRIX;

			localViewProjection.copyFrom(_hitRenderable.getRenderSceneTransform(camera));
			localViewProjection.append(camera.viewProjection);
			if (!_triangleProgram3D)
            {
				initTriangleProgram3D();
            }

			_boundOffsetScale[4] = 1/(scX = entity.maxX - entity.minX);
            _boundOffsetScale[5] = 1/(scY = entity.maxY - entity.minY);
            _boundOffsetScale[6] = 1/(scZ = entity.maxZ - entity.minZ);
            _boundOffsetScale[0] = offsX = -entity.minX;
            _boundOffsetScale[1] = offsY = -entity.minY;
            _boundOffsetScale[2] = offsZ = -entity.minZ;

            _context.setProgram(_triangleProgram3D);
            _context.clear(0, 0, 0, 0, 1, 0, Context3DClearMask.DEPTH);
            _context.setScissorRectangle(ShaderPicker.MOUSE_SCISSOR_RECT);
            _context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, localViewProjection, true);
            _context.setProgramConstantsFromArray(Context3DProgramType.VERTEX, 5, _boundOffsetScale, 2);
            _hitRenderable.activateVertexBuffer(0, _stage3DProxy);
            _context.drawTriangles(_hitRenderable.getIndexBuffer(_stage3DProxy), 0, _hitRenderable.numTriangles);
            _context.drawToBitmapData(_bitmapData);
			
			col = _bitmapData.getPixel(0, 0);
			
			_localHitPosition.x = ((col >> 16) & 0xff)*scX/255 - offsX;
            _localHitPosition.y = ((col >> 8) & 0xff)*scY/255 - offsY;
            _localHitPosition.z = (col & 0xff)*scZ/255 - offsZ;
		}
		/**
		private function getPreciseDetails(camera:Camera3D):void
		{

            var subMesh : SubMesh = SubMesh(_hitRenderable);

			var subGeom:ISubGeometry = subMesh.subGeometry;
			var indices:Vector.<Number> = subGeom.indexData;
			var vertices:Vector.<Number> = subGeom.vertexData;
			var len:Number = indices.length;
			var x1:Number, y1:Number, z1:Number;
			var x2:Number, y2:Number, z2:Number;
			var x3:Number, y3:Number, z3:Number;
			var i:Number = 0, j:Number = 1, k:Number = 2;
			var t1:Number, t2:Number, t3:Number;
			var v0x:Number, v0y:Number, v0z:Number;
			var v1x:Number, v1y:Number, v1z:Number;
			var v2x:Number, v2y:Number, v2z:Number;
			var dot00:Number, dot01:Number, dot02:Number, dot11:Number, dot12:Number;
			var s:Number, t:Number, invDenom:Number;
			var uvs:Vector.<Number> = subGeom.UVData;
			var normals:Vector.<Number> = subGeom.faceNormals;
			var x:Number = _localHitPosition.x, y:Number = _localHitPosition.y, z:Number = _localHitPosition.z;
			var u:Number, v:Number;
			var ui1:Number, ui2:Number, ui3:Number;
			var s0x:Number, s0y:Number, s0z:Number;
			var s1x:Number, s1y:Number, s1z:Number;
			var nl:Number;
			var stride:Number = subGeom.vertexStride;
			var vertexOffset:Number = subGeom.vertexOffset;
			
			updateRay(camera);
			
			while (i < len) {
				t1 = vertexOffset + indices[i]*stride;
				t2 = vertexOffset + indices[j]*stride;
				t3 = vertexOffset + indices[k]*stride;
				x1 = vertices[t1];
				y1 = vertices[t1 + 1];
				z1 = vertices[t1 + 2];
				x2 = vertices[t2];
				y2 = vertices[t2 + 1];
				z2 = vertices[t2 + 2];
				x3 = vertices[t3];
				y3 = vertices[t3 + 1];
				z3 = vertices[t3 + 2];
				
				// if within bounds
				if (!(    (x < x1 && x < x2 && x < x3) ||
					(y < y1 && y < y2 && y < y3) ||
					(z < z1 && z < z2 && z < z3) ||
					(x > x1 && x > x2 && x > x3) ||
					(y > y1 && y > y2 && y > y3) ||
					(z > z1 && z > z2 && z > z3))) {
					
					// calculate barycentric coords for approximated position
					v0x = x3 - x1;
					v0y = y3 - y1;
					v0z = z3 - z1;
					v1x = x2 - x1;
					v1y = y2 - y1;
					v1z = z2 - z1;
					v2x = x - x1;
					v2y = y - y1;
					v2z = z - z1;
					dot00 = v0x*v0x + v0y*v0y + v0z*v0z;
					dot01 = v0x*v1x + v0y*v1y + v0z*v1z;
					dot02 = v0x*v2x + v0y*v2y + v0z*v2z;
					dot11 = v1x*v1x + v1y*v1y + v1z*v1z;
					dot12 = v1x*v2x + v1y*v2y + v1z*v2z;
					invDenom = 1/(dot00*dot11 - dot01*dot01);
					s = (dot11*dot02 - dot01*dot12)*invDenom;
					t = (dot00*dot12 - dot01*dot02)*invDenom;
					
					// if inside the current triangle, fetch details hit information
					if (s >= 0 && t >= 0 && (s + t) <= 1) {
						
						// this is def the triangle, now calculate precise coords
                        getPrecisePosition(_hitRenderable.inverseSceneTransform, normals[i], normals[i + 1], normals[i + 2], x1, y1, z1);
						
						v2x = _localHitPosition.x - x1;
						v2y = _localHitPosition.y - y1;
						v2z = _localHitPosition.z - z1;
						
						s0x = x2 - x1; // s0 = p1 - p0
						s0y = y2 - y1;
						s0z = z2 - z1;
						s1x = x3 - x1; // s1 = p2 - p0
						s1y = y3 - y1;
						s1z = z3 - z1;
                        _localHitNormal.x = s0y*s1z - s0z*s1y; // n = s0 x s1
                        _localHitNormal.y = s0z*s1x - s0x*s1z;
                        _localHitNormal.z = s0x*s1y - s0y*s1x;
						nl = 1/Math.sqrt(
                            _localHitNormal.x*_localHitNormal.x +
                                _localHitNormal.y*_localHitNormal.y +
                                _localHitNormal.z*_localHitNormal.z
							); // normalize n
                        _localHitNormal.x *= nl;
                        _localHitNormal.y *= nl;
                        _localHitNormal.z *= nl;
						
						dot02 = v0x*v2x + v0y*v2y + v0z*v2z;
						dot12 = v1x*v2x + v1y*v2y + v1z*v2z;
						s = (dot11*dot02 - dot01*dot12)*invDenom;
						t = (dot00*dot12 - dot01*dot02)*invDenom;
						
						ui1 = indices[i] << 1;
						ui2 = indices[j] << 1;
						ui3 = indices[k] << 1;
						
						u = uvs[ui1];
						v = uvs[ui1 + 1];
                        _hitUV.x = u + t*(uvs[ui2] - u) + s*(uvs[ui3] - u);
                        _hitUV.y = v + t*(uvs[ui2 + 1] - v) + s*(uvs[ui3 + 1] - v);

                        _faceIndex = i;
                        _subGeometryIndex = GeometryUtils.getMeshSubMeshIndex( subMesh );
						
						return;
					}
				}
				
				i += 3;
				j += 3;
				k += 3;
			}
		}
		/**

		private function getPrecisePosition(invSceneTransform:Matrix3D, nx:Number, ny:Number, nz:Number, px:Number, py:Number, pz:Number):void
		{
			// calculate screen ray and find exact intersection position with triangle
			var rx:Number, ry:Number, rz:Number;
			var ox:Number, oy:Number, oz:Number;
			var t:Number;
			var raw:Vector.<Number> = Matrix3DUtils.RAW_DATA_CONTAINER;
			var cx:Number = _rayPos.x, cy:Number = _rayPos.y, cz:Number = _rayPos.z;
			
			// unprojected projection point, gives ray dir in cam space
			ox = _rayDir.x;
			oy = _rayDir.y;
			oz = _rayDir.z;
			
			// transform ray dir and origin (cam pos) to object space
            //invSceneTransform.copyRawDataTo( raw  );
            invSceneTransform.copyRawDataTo( raw );
			rx = raw[0]*ox + raw[4]*oy + raw[8]*oz;
			ry = raw[1]*ox + raw[5]*oy + raw[9]*oz;
			rz = raw[2]*ox + raw[6]*oy + raw[10]*oz;
			
			ox = raw[0]*cx + raw[4]*cy + raw[8]*cz + raw[12];
			oy = raw[1]*cx + raw[5]*cy + raw[9]*cz + raw[13];
			oz = raw[2]*cx + raw[6]*cy + raw[10]*cz + raw[14];
			
			t = ((px - ox)*nx + (py - oy)*ny + (pz - oz)*nz)/(rx*nx + ry*ny + rz*nz);
			
			_localHitPosition.x = ox + rx*t;
            _localHitPosition.y = oy + ry*t;
            _localHitPosition.z = oz + rz*t;
		}

		public function dispose():void
		{
			_bitmapData.dispose();
			if (_triangleProgram3D)
            {

                _triangleProgram3D.dispose();

            }

			if (_objectProgram3D)
            {

                _objectProgram3D.dispose();

            }

            _triangleProgram3D = null;
            _objectProgram3D = null;
            _bitmapData = null;
            _hitRenderable = null;
            _hitEntity = null;
		}
	}
}