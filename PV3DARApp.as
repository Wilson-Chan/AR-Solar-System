﻿package {
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.libspark.flartoolkit.core.transmat.FLARTransMatResult;
	import org.libspark.flartoolkit.pv3d.FLARBaseNode;
	import org.libspark.flartoolkit.pv3d.FLARCamera3D;
	import org.papervision3d.render.LazyRenderEngine;
	import org.papervision3d.scenes.Scene3D;
	import org.papervision3d.view.Viewport3D;
	import org.papervision3d.view.stats.StatsView;
	import org.papervision3d.objects.DisplayObject3D;
	
	public class PV3DARApp extends ARAppBase {
		var marker =1;
		var _Marker;
		protected var _base:Sprite;
		protected var _viewport:Viewport3D;
		protected var _camera3d:FLARCamera3D;
		protected var _scene:Scene3D;
		protected var _renderer:LazyRenderEngine;
		protected var _baseNode:FLARBaseNode;
		protected var markerAdded:Number;
		
		protected var staticContainer:DisplayObject3D;
		
		//protected var _baseNode1:FLARBaseNode;
		//protected var _baseNode2:FLARBaseNode;
		
		protected var _resultMat:FLARTransMatResult = new FLARTransMatResult();
		
		public function PV3DARApp() {
		}
		
		protected override function onInit():void {
			super.onInit();
			
			staticContainer=new DisplayObject3D();
			this._base = this.addChild(new Sprite()) as Sprite;
			
			this._capture.width = 640;
			this._capture.height = 480;
			this._base.addChild(this._capture);
			//this._base.x = 122;
			//this._base.y = 114;
			
			this._viewport = this._base.addChild(new Viewport3D(320, 240)) as Viewport3D;
			this._viewport.scaleX = 640 / 320;
			this._viewport.scaleY = 480 / 240;

			this._viewport.x = -4; // 4pix ???
			
			this._camera3d = new FLARCamera3D(this._param);
			
			this._scene = new Scene3D();
			
			this._baseNode = this._scene.addChild(new FLARBaseNode()) as FLARBaseNode;
			this._scene.addChild(staticContainer);
			this._renderer = new LazyRenderEngine(this._scene, this._camera3d, this._viewport);
//			this.stage.addChild(new StatsView(this._renderer));
			
			this.addEventListener(Event.ENTER_FRAME, this._onEnterFrame);


		}
		
		
		private function _onEnterFrame(e:Event = null):void {
			this._capture.bitmapData.draw(this._video);
				
			if (this._detector.detectMarkerLite(this._raster, 150) && this._detector.getConfidence() > 0.5) {
				this._detector.getTransformMatrix(this._resultMat);
				this._baseNode.setTransformMatrix(this._resultMat);
				this._baseNode.visible = true;
				this.staticContainer.visible=true;
				markerAdded =1;
			}
			else {
				//markerAdded =0;
				this._baseNode.visible = false;
				//this.staticContainer.visible=false;
				}
			this._renderer.render();
		}
		
		public function set mirror(value:Boolean):void {
			if (value) {
				this._base.scaleX = -1;
				this._base.x = 640;
			} else {
				this._base.scaleX = 1;
				this._base.x = 0;
			}
		}
		
		public function get mirror():Boolean {
			return this._base.scaleX < 0;
		}
	}
}