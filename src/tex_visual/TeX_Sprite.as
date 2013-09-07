package tex_visual {
	import com.am_devcorp.algo.graphics.UIntPoint;
	import com.am_devcorp.algo.graphics.render.rasterstage.RasterSprite;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import com.am_devcorp.mathtricks.mathtricks
	/**
	 * ...
	 * @author am_devcorp
	 */
	public class TeX_Sprite  {
		
		public static const TYPE_RECT:uint = 0 
		public static const TYPE_CONTAINER:uint = 1 
		private var _type:uint;
		public var position:UIntPoint; // position relative to parent
		public var rect:Rectangle;// sector of pixels; if needed
		public var pieces:Vector.<TeX_Sprite> 
		public var _baseline:int;
		
		
		
		public function TeX_Sprite(type:uint) {
			_type = type;
			switch (type) {
				case TeX_Sprite.TYPE_CONTAINER:
					pieces = new Vector.<TeX_Sprite>
				break;
				case TeX_Sprite.TYPE_RECT:
					rect = new Rectangle()
				break;
				default:
			}
		}
		public function initMainValue(arg:*):Boolean {
			if (type == TYPE_RECT && arg is Rectangle) {
				rect = arg as Rectangle
			} else if (type == TYPE_CONTAINER && arg is Vector.<TeX_Sprite>) {
				pieces = (arg as Vector.<TeX_Sprite>).slice();
			} else {
				return false;
			}
			return true;
		}
	
		
		
		public function get width():uint {
			var w:uint
			if (type == TYPE_CONTAINER) {
				
				w= mathtricks.Max(	function (elem:TeX_Sprite):uint {
										return elem.position.x + elem.width
									}
									,pieces) [1]
			} else if (type == TYPE_RECT) {
				w= rect.width
			}
			return w
			
		}
		public function get height():uint {
			var h:uint
			if (type == TYPE_CONTAINER) {
				h= mathtricks.Max(	function (elem:TeX_Sprite):uint {
										return elem.position.y+elem.height
									}
									,pieces) [1]
			} else if (type == TYPE_RECT) {
				h= rect.height
			}
			return h
		}
		public function get aboveBaseline():int {
			return height - _baseline;
		}
		
		public function get beneathBaseline():int {
			return _baseline;
		}
		
		public function get type():uint {
			return _type;
		}
		
		public function toString():String {
			return "TeX Sprite\n"+this._type+"\n"+this.pieces
		}

	}

}