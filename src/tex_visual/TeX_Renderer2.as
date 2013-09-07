package tex_visual {
	import com.am_devcorp.algo.graphics.UIntPoint;
	import com.am_devcorp.algo.processing.TeX.TeX_PlaintextToken;
	import com.am_devcorp.algo.processing.TeX.TeX_Token;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Malyavkin Alexey <a@malyavk.in>
	 */
	public class TeX_Renderer2 {
		var font:TeX_TiledFont
		public function TeX_Renderer2(fnt:TeX_TiledFont) {
			font = fnt
		}
		
		// MERGE
		
		
		/**
		 * Actually draws
		 * @param	Vector
		 */
		public function mergeInLine(Vector):void {
			
		}
		
		
		
		// Formatters
		
		public function formPlainText(token:TeX_Token):Vector.<TeX_Sprite> {
			var text_to_render:String = (token as TeX_PlaintextToken).str
			var arr:Array = text_to_render.split("").map(parse).map(form)
			/**
			 * Wraps TeX_TiledFont.retrieveDataForChar() for using in Array.map()
			 */
			function parse(elem:String, a:*,b:*):TeX_Character {
				return font.retrieveDataForChar(elem)
			}
			/**
			 * Wraps formChar() for using in Array.map()
			 */
			function form(char:TeX_Character, a:*, b:*):TeX_Sprite {
				return formChar(char)
			}
			var vec:Vector.<TeX_Sprite> = new Vector.<TeX_Sprite>
			vec.push.apply(null, arr) // transforming array to Vector.<TeX_Sprite> 
			return vec
		}
		
		public function formChar(c:TeX_Character):TeX_Sprite {
			var tiles:Array = c.tiles.slice()
			var res:TeX_Sprite = new TeX_Sprite(TeX_Sprite.TYPE_CONTAINER)
			for (var i:int = 0; i < c.tilesHeight; i++) {
				for (var j:int = 0; j < c.width; j++) {
					//[row,column]
					var coords:Array = String(tiles.shift()).split(",")
					var sp:TeX_Sprite = new TeX_Sprite(TeX_Sprite.TYPE_RECT)
					sp.initMainValue(new Rectangle(coords[1] * font.tileWidth, coords[0] * font.tileHeight, font.tileWidth, font.tileHeight))
					sp.position = new UIntPoint(j * font.tileWidth, i * font.tileHeight)
					res.pieces.push(sp);
				}
			}
			res._baseline = c.beneathBaseline*font.tileHeight
			
			for each (var xxx:TeX_Sprite in res.pieces) {
				trace(xxx.position, xxx.width)
			}
			
			return res
		}
		
	}

}