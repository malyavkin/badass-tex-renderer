package tex_visual {
	import com.am_devcorp.algo.graphics.render.rasterstage.RasterSprite;
	import com.am_devcorp.algo.graphics.UIntPoint;
	import com.am_devcorp.algo.processing.TeX.TeX_PlaintextToken;
	import com.am_devcorp.algo.processing.TeX.TeX_Token;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import com.am_devcorp.mathtricks.mathtricks
	/**
	 * TeX_Sprite -- 1 piece(tile) of a character
	 * TeX_SpriteContainer -- 1 character, consists of Vector.<TeX_Sprite>
	 * Vector.<TeX_SpriteContainer> -- string
	 * @author Malyavkin Alexey <a@malyavk.in>
	 */
	public class TeX_Renderer2 {
		private var font:TeX_TiledFont
		public function TeX_Renderer2(fnt:TeX_TiledFont) {
			font = fnt
		}
		public function rasterize(group:TeX_SpriteContainer):BitmapData {
			var bd:BitmapData = new BitmapData(group.width, group.height);
			bd.lock()
			for each (var piece:TeX_Sprite in group.pieces) {
				bd.copyPixels(font.font,piece,piece.position.as_point,null,null,true)
			}
			bd.unlock()
			return bd
			
		}
		
		
		// MERGE
		/**
		 * 
		 * @param	Vector
		 *  Character:
		 *
		 *    OO ↑ up=2
		 *  __OO_________
		 *    OO ↓ down=1 ( =baseline )
		 */
		private function mergeInLine(vec:Vector.<TeX_SpriteContainer>):TeX_SpriteContainer {
			var global_above_baseline:int// отступ сверху до baseline 
			var global_height:uint
			global_above_baseline = mathtricks.Max(function (a:TeX_SpriteContainer):int {
				return a.aboveBaseline
			},vec) [1];
			
			var hcaret:uint = 0// in pixels of course
			var res: Vector.<TeX_Sprite> = new Vector.<TeX_Sprite>;
			for each (var container:TeX_SpriteContainer in vec) {
				var new_hcaret:uint
				var container_offset:UIntPoint = new UIntPoint(hcaret, global_above_baseline-container.aboveBaseline);
				for each (var sprite:TeX_Sprite in container.pieces) {
					sprite.position.x += container_offset.x
					sprite.position.y += container_offset.y
					res.push(sprite)
					if (sprite.width+sprite.position.x > new_hcaret) {
						new_hcaret = sprite.width+sprite.position.x
					}
					if (sprite.height+sprite.position.y > global_height) {
						global_height = sprite.height+sprite.position.y
					}
				}
				hcaret = new_hcaret
				
			}
			return new TeX_SpriteContainer(res, global_height - global_above_baseline);
			
		}
		
		
		
		// Formatters
		
		public function formPlainText(token:TeX_Token):TeX_SpriteContainer {
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
			function form(char:TeX_Character, a:*, b:*):TeX_SpriteContainer {
				return formChar(char)
			}
			var vec:Vector.<TeX_SpriteContainer> = new Vector.<TeX_SpriteContainer>
			vec.push.apply(null, arr)// transforming array to Vector.<TeX_Sprite> 
			
			return mergeInLine(vec)
		}
		
		public function formChar(c:TeX_Character):TeX_SpriteContainer {
			var tiles:Array = c.tiles.slice()
			var pcs:Vector.<TeX_Sprite> = new Vector.<TeX_Sprite>
			for (var i:int = 0; i < c.tilesHeight; i++) {
				for (var j:int = 0; j < c.width; j++) {
					//[row,column]
					var coords:Array = String(tiles.shift()).split(",")
					var sp:TeX_Sprite = new TeX_Sprite(coords[1] * font.tileWidth, coords[0] * font.tileHeight, font.tileWidth, font.tileHeight,new UIntPoint(j * font.tileWidth, i * font.tileHeight))
					pcs.push(sp);
				}
			}
			
			
			for each (var xxx:TeX_Sprite in pcs) {
				trace(xxx.position, xxx.width)
			}
			trace("---")
			return new TeX_SpriteContainer(pcs,c.beneathBaseline*font.tileHeight)
		}
		
	}

}