package tex_visual_v1 {
	import com.am_devcorp.algo.graphics.render.rasterstage.RasterSprite;
	import flash.display.BitmapData;
	/**
	 * ...
	 * @author am_devcorp
	 */
	public class TeX_Sprite{
		public var pixels:BitmapData
		private var _baseline:int
		public function TeX_Sprite(pixels:BitmapData, baseline:int=0) {
			_baseline = baseline
			this.pixels = pixels
		}
		public function get width():uint {
			return pixels.width
		}
		public function get height():uint {
			return pixels.height
		}
		public function get aboveBaseline():int {
			return pixels.height - _baseline;
		}
		
		public function get beneathBaseline():int {
			return _baseline;
		}
		
	}

}