

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
	
	/**	 * Picks a 3d object from a view or scene by performing a separate render pass on the scene around the area being picked using key color values,	 * then reading back the color value of the pixel in the render representing the picking ray. Requires multiple passes and readbacks for retriving details	 * on an entity that has its shaderPickingDetails property set to true.	 *	 * A read-back operation from any GPU is not a very efficient process, and the amount of processing used can vary significantly between different hardware.	 *	 * @see away3d.entities.Entity#shaderPickingDetails	 */

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
		
		private var _interactives:Vector.<IRenderable> = new Vector.<IRenderable>();//Vector.<IRenderable> = new Vector.<IRenderable>();		private var _interactiveId:Number;
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
		
		/**		 * @inheritDoc		 */
		public function get onlyMouseEnabled():Boolean
		{
			return this._onlyMouseEnabled;
		}
		
		public function set onlyMouseEnabled(value:Boolean):void
		{
            this._onlyMouseEnabled = value;
		}
		
		/**		 * Creates a new <code>ShaderPicker</code> object.		 */
		public function ShaderPicker():void
		{
			this._id = new Vector.<Number>( 4 );//new Vector.<Number>(4, true);
			this._viewportData = new Vector.<Number>( 4 );//new Vector.<Number>(4, true); // first 2 contain scale, last 2 translation
			this._boundOffsetScale = new Vector.<Number>( 8 );//new Vector.<Number>(8, true); // first 2 contain scale, last 2 translation
			this._boundOffsetScale[3] = 0;
			this._boundOffsetScale[7] = 1;
		}
		
		/**		 * @inheritDoc		 */
        // TODO implement dependency : EntityCollector
        // TODO: GLSL implementation / conversion
		public function getViewCollision(x:Number, y:Number, view:View3D):PickingCollisionVO
		{

            Debug.throwPIR( 'ShaderPicker' , 'getViewCollision' , 'implement' );

            return null;


			var collector:EntityCollector = view.iEntityCollector;
			
			this._stage3DProxy = view.stage3DProxy;
			
			if (!this._stage3DProxy)
				return null;
			
			this._context = this._stage3DProxy._iContext3D;
			
			this._viewportData[0] = view.width;
            this._viewportData[1] = view.height;
			this._projX = 2*x/view.width - 1;
            this._viewportData[2] = -this._projX;
            this._viewportData[3] = 2*y/view.height - 1;
            this._projY = 2*y/view.height - 1;

			
			// _potentialFound will be set to true if any object is actually rendered
			this._potentialFound = false;

            this.pDraw(collector, null);
			
			// clear buffers
			this._context.setVertexBufferAt(0, null);
			
			if (!this._context || !this._potentialFound)
            {
				return null;
            }

			if (!this._bitmapData)
                this._bitmapData = new BitmapData(1, 1, false, 0);
			
			this._context.drawToBitmapData(this._bitmapData);
			this._hitColor = this._bitmapData.getPixel(0, 0);
			
			if (!this._hitColor) {
                this._context.present();
				return null;
			}

            this._hitRenderable = this._interactives[this._hitColor - 1];
            this._hitEntity = this._hitRenderable.sourceEntity;
			if (this._onlyMouseEnabled && (!this._hitEntity._iAncestorsAllowMouseEnabled || !this._hitEntity.mouseEnabled))
            {
				return null;
            }

			var _collisionVO:PickingCollisionVO = this._hitEntity.pickingCollisionVO;
			if (this._hitRenderable.shaderPickingDetails) {
				this.getHitDetails(view.camera);
				_collisionVO.localPosition = this._localHitPosition;
				_collisionVO.localNormal = this._localHitNormal;
				_collisionVO.uv = this._hitUV;
				_collisionVO.index = this._faceIndex;
				_collisionVO.subGeometryIndex = this._subGeometryIndex;
				
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
		/**		 * @inheritDoc		 */
		public function getSceneCollision(position:Vector3D, direction:Vector3D, scene:Scene3D):PickingCollisionVO
		{
			return null;
		}
		
		/**		 * @inheritDoc		 */
        // TODO: GLSL implementation / conversion
		public function pDraw(entityCollector:EntityCollector, target:TextureBase):void
		{

			var camera:Camera3D = entityCollector.camera;
			
			this._context.clear(0, 0, 0, 1);
			this._stage3DProxy.scissorRect = ShaderPicker.MOUSE_SCISSOR_RECT;
			
			this._interactives.length = 0;
			this._interactiveId = 0;

			
			if (!this._objectProgram3D)
            {

                this.initObjectProgram3D();

            }

			this._context.setBlendFactors(Context3DBlendFactor.ONE, Context3DBlendFactor.ZERO);
			this._context.setDepthTest(true, Context3DCompareMode.LESS);
			this._context.setProgram(this._objectProgram3D);
			this._context.setProgramConstantsFromArray(Context3DProgramType.VERTEX, 4, this._viewportData, 1);
			this.drawRenderables(entityCollector.opaqueRenderableHead, camera);
			this.drawRenderables(entityCollector.blendedRenderableHead, camera);

		}

		/**		 * Draw a list of renderables.		 * @param renderables The renderables to draw.		 * @param camera The camera for which to render.		 */
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
				if (!renderable.sourceEntity.scene || (!renderable.mouseEnabled && this._onlyMouseEnabled))
                {
					item = item.next;
					continue;
				}
				
				this._potentialFound = true;

                this._context.setCulling(renderable.material.bothSides? Context3DTriangleFace.NONE : Context3DTriangleFace.BACK);
				
				this._interactives[this._interactiveId++] = renderable;
				// color code so that reading from bitmapdata will contain the correct value
                this._id[1] = (this._interactiveId >> 8)/255; // on green channel
                this._id[2] = (this._interactiveId & 0xff)/255; // on blue channel
				
				matrix.copyFrom(renderable.getRenderSceneTransform(camera));
				matrix.append(viewProjection);
                this._context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, matrix, true);
                this._context.setProgramConstantsFromArray(Context3DProgramType.FRAGMENT, 0, this._id, 1);
				renderable.activateVertexBuffer(0, this._stage3DProxy);
                this._context.drawTriangles(renderable.getIndexBuffer(this._stage3DProxy), 0, renderable.numTriangles);
				
				item = item.next;
			}

		}

		private function updateRay(camera:Camera3D):void
		{

			this._rayPos = camera.scenePosition;
            this._rayDir = camera.getRay(this._projX, this._projY, 1);
            this._rayDir.normalize();

		}

		/**		 * Creates the Program3D that color-codes objects.		 */
		private function initObjectProgram3D():void
		{
			var vertexCode:String;
			var fragmentCode:String;
			
			this._objectProgram3D = this._context.createProgram();
			
			vertexCode = "m44 vt0, va0, vc0			\n" +
				"mul vt1.xy, vt0.w, vc4.zw	\n" +
				"add vt0.xy, vt0.xy, vt1.xy	\n" +
				"mul vt0.xy, vt0.xy, vc4.xy	\n" +
				"mov op, vt0	\n";
			fragmentCode = "mov oc, fc0"; // write identifier

            Debug.throwPIR( 'ShaderPicker' , 'initTriangleProgram3D' , 'Dependency: initObjectProgram3D')
			//_objectProgram3D.upload(new AGALMiniAssembler().assemble(Context3DProgramType.VERTEX, vertexCode),new AGALMiniAssembler().assemble(Context3DProgramType.FRAGMENT, fragmentCode));
		}
		/**		 * Creates the Program3D that renders positions.		 */

		private function initTriangleProgram3D():void
		{
			var vertexCode:String;
			var fragmentCode:String;
			
			this._triangleProgram3D = this._context.createProgram();
			
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

            this._triangleProgram3D.upload(vertString, fragString);

			//this._triangleProgram3D.upload(new AGALMiniAssembler().assemble(Context3DProgramType.VERTEX, vertexCode), new AGALMiniAssembler().assemble(Context3DProgramType.FRAGMENT, fragmentCode));
		}

		/**		 * Gets more detailed information about the hir position, if required.		 * @param camera The camera used to view the hit object.		 */
		private function getHitDetails(camera:Camera3D):void
		{
			this.getApproximatePosition(camera);
			this.getPreciseDetails(camera);
		}
		/**		 * Finds a first-guess approximate position about the hit position.		 * @param camera The camera used to view the hit object.		 */

		private function getApproximatePosition(camera:Camera3D):void
		{
			var entity:Entity = this._hitRenderable.sourceEntity;
			var col:Number;
			var scX:Number, scY:Number, scZ:Number;
			var offsX:Number, offsY:Number, offsZ:Number;
			var localViewProjection:Matrix3D = Matrix3DUtils.CALCULATION_MATRIX;

			localViewProjection.copyFrom(this._hitRenderable.getRenderSceneTransform(camera));
			localViewProjection.append(camera.viewProjection);
			if (!this._triangleProgram3D)
            {
				this.initTriangleProgram3D();
            }
			
			scX = entity.maxX - entity.minX;
			scY = entity.maxY - entity.minY;
			scZ = entity.maxZ - entity.minZ;
			
			this._boundOffsetScale[4] = 1/scX;
            this._boundOffsetScale[5] = 1/scY;
            this._boundOffsetScale[6] = 1/scZ;
            this._boundOffsetScale[0] = -entity.minX;
            offsX = -entity.minX;

            this._boundOffsetScale[1] = -entity.minY;
            offsY = -entity.minY;

            this._boundOffsetScale[2] = -entity.minZ;
            offsZ = -entity.minZ;


            this._context.setProgram(this._triangleProgram3D);
            this._context.clear(0, 0, 0, 0, 1, 0, Context3DClearMask.DEPTH);
            this._context.setScissorRectangle(ShaderPicker.MOUSE_SCISSOR_RECT);
            this._context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, localViewProjection, true);
            this._context.setProgramConstantsFromArray(Context3DProgramType.VERTEX, 5, this._boundOffsetScale, 2);
            this._hitRenderable.activateVertexBuffer(0, this._stage3DProxy);
            this._context.drawTriangles(this._hitRenderable.getIndexBuffer(this._stage3DProxy), 0, this._hitRenderable.numTriangles);
            this._context.drawToBitmapData(this._bitmapData);
			
			col = this._bitmapData.getPixel(0, 0);
			
			this._localHitPosition.x = ((col >> 16) & 0xff)*scX/255 - offsX;
            this._localHitPosition.y = ((col >> 8) & 0xff)*scY/255 - offsY;
            this._localHitPosition.z = (col & 0xff)*scZ/255 - offsZ;
		}
		/**		 * Use the approximate position info to find the face under the mouse position from which we can derive the precise		 * ray-face intersection point, then use barycentric coordinates to figure out the uv coordinates, etc.		 * @param camera The camera used to view the hit object.		 */
		private function getPreciseDetails(camera:Camera3D):void
		{

            var subMesh : SubMesh = (this._hitRenderable as SubMesh);

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
			var x:Number = this._localHitPosition.x, y:Number = this._localHitPosition.y, z:Number = this._localHitPosition.z;
			var u:Number, v:Number;
			var ui1:Number, ui2:Number, ui3:Number;
			var s0x:Number, s0y:Number, s0z:Number;
			var s1x:Number, s1y:Number, s1z:Number;
			var nl:Number;
			var stride:Number = subGeom.vertexStride;
			var vertexOffset:Number = subGeom.vertexOffset;
			
			this.updateRay(camera);
			
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
                        this.getPrecisePosition(this._hitRenderable.inverseSceneTransform, normals[i], normals[i + 1], normals[i + 2], x1, y1, z1);
						
						v2x = this._localHitPosition.x - x1;
						v2y = this._localHitPosition.y - y1;
						v2z = this._localHitPosition.z - z1;
						
						s0x = x2 - x1; // s0 = p1 - p0
						s0y = y2 - y1;
						s0z = z2 - z1;
						s1x = x3 - x1; // s1 = p2 - p0
						s1y = y3 - y1;
						s1z = z3 - z1;
                        this._localHitNormal.x = s0y*s1z - s0z*s1y; // n = s0 x s1
                        this._localHitNormal.y = s0z*s1x - s0x*s1z;
                        this._localHitNormal.z = s0x*s1y - s0y*s1x;
						nl = 1/Math.sqrt(
                            this._localHitNormal.x*this._localHitNormal.x +
                                this._localHitNormal.y*this._localHitNormal.y +
                                this._localHitNormal.z*this._localHitNormal.z
							); // normalize n
                        this._localHitNormal.x *= nl;
                        this._localHitNormal.y *= nl;
                        this._localHitNormal.z *= nl;
						
						dot02 = v0x*v2x + v0y*v2y + v0z*v2z;
						dot12 = v1x*v2x + v1y*v2y + v1z*v2z;
						s = (dot11*dot02 - dot01*dot12)*invDenom;
						t = (dot00*dot12 - dot01*dot02)*invDenom;
						
						ui1 = indices[i] << 1;
						ui2 = indices[j] << 1;
						ui3 = indices[k] << 1;
						
						u = uvs[ui1];
						v = uvs[ui1 + 1];
                        this._hitUV.x = u + t*(uvs[ui2] - u) + s*(uvs[ui3] - u);
                        this._hitUV.y = v + t*(uvs[ui2 + 1] - v) + s*(uvs[ui3 + 1] - v);

                        this._faceIndex = i;
                        this._subGeometryIndex = GeometryUtils.getMeshSubMeshIndex( subMesh );
						
						return;
					}
				}
				
				i += 3;
				j += 3;
				k += 3;
			}
		}
		/**		 * Finds the precise hit position by unprojecting the screen coordinate back unto the hit face's plane and		 * calculating the intersection point.		 * @param camera The camera used to render the object.		 * @param invSceneTransform The inverse scene transformation of the hit object.		 * @param nx The x-coordinate of the face's plane normal.		 * @param ny The y-coordinate of the face plane normal.		 * @param nz The z-coordinate of the face plane normal.		 * @param px The x-coordinate of a point on the face's plane (ie a face vertex)		 * @param py The y-coordinate of a point on the face's plane (ie a face vertex)		 * @param pz The z-coordinate of a point on the face's plane (ie a face vertex)		 */

		private function getPrecisePosition(invSceneTransform:Matrix3D, nx:Number, ny:Number, nz:Number, px:Number, py:Number, pz:Number):void
		{
			// calculate screen ray and find exact intersection position with triangle
			var rx:Number, ry:Number, rz:Number;
			var ox:Number, oy:Number, oz:Number;
			var t:Number;
			var raw:Vector.<Number> = Matrix3DUtils.RAW_DATA_CONTAINER;
			var cx:Number = this._rayPos.x, cy:Number = this._rayPos.y, cz:Number = this._rayPos.z;
			
			// unprojected projection point, gives ray dir in cam space
			ox = this._rayDir.x;
			oy = this._rayDir.y;
			oz = this._rayDir.z;
			
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
			
			this._localHitPosition.x = ox + rx*t;
            this._localHitPosition.y = oy + ry*t;
            this._localHitPosition.z = oz + rz*t;
		}

		public function dispose():void
		{
			this._bitmapData.dispose();
			if (this._triangleProgram3D)
            {

                this._triangleProgram3D.dispose();

            }

			if (this._objectProgram3D)
            {

                this._objectProgram3D.dispose();

            }

            this._triangleProgram3D = null;
            this._objectProgram3D = null;
            this._bitmapData = null;
            this._hitRenderable = null;
            this._hitEntity = null;
		}
	}
}
