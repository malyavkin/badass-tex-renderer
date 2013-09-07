package tex_visual {
	import com.am_devcorp.algo.graphics.UIntPoint;
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