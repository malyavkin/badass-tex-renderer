package tex_visual {
	import com.am_devcorp.algo.graphics.IntPoint;
	import com.am_devcorp.algo.graphics.render.rasterstage.RasterSprite;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author am_devcorp
	 */
	public class TeX_Sprite {
		public var position:IntPoint; // position relative to parent
		public var rect:Rectangle; // sector of pixels
		private var _baseline:int
		public function TeX_Sprite(rect:Rectangle, pos:IntPoint, baseline:int=0) {
			_baseline = baseline;
			this.position = pos;
			this.rect = rect;
		}
		public function get width():uint {
			return rect.width
		}
		public function get height():uint {
			return rect.height
		}
		public function get aboveBaseline():int {
			return rect.height - _baseline;
		}
		
		public function get beneathBaseline():int {
			return _baseline;
		}
		
	}

}