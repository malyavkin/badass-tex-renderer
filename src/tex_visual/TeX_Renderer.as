package tex_visual {
	
	import com.am_devcorp.algo.graphics.IntPoint;
	import com.am_devcorp.algo.graphics.render.rasterstage.RasterSprite;
	import com.am_devcorp.algo.processing.TeX.TeX_PlaintextToken;
	import com.am_devcorp.algo.processing.TeX.TeX_Token;
	import com.am_devcorp.algo.processing.TeX.TeX_TokenType;
	import com.am_devcorp.algo.tools.Assert;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author am_devcorp
	 */
	public class TeX_Renderer {
		private var renderSettings:Object
		private var font:TeX_TiledFont;
		
		public function TeX_Renderer(font:TeX_TiledFont) {
			this.font = font
			renderSettings = new Object()
			renderSettings[TeX_TokenType.ROOT] = renderRoot
			renderSettings[TeX_TokenType.PLAIN] = renderPlainText
			renderSettings[TeX_TokenType.SUM] = renderSum 
			renderSettings[TeX_TokenType.FRACTION] = renderFrac 
		}
		
		private function renderFrac(token:TeX_Token):TeX_Sprite {
			var up:TeX_Sprite = mergeGroup(renderGroup(token.args[0]))
			var down:TeX_Sprite = mergeGroup(renderGroup(token.args[1]))
			var frac:TeX_Sprite = renderChar(font.retrieveDataForChar("fraction_bar"))
			var frac_merged:TeX_Sprite = renderChar(font.retrieveDataForChar("fraction_bar"))
			while (frac_merged.width< Math.max(up.width,down.width)) {
				frac_merged = mergeGroup(new<TeX_Sprite>[frac_merged, frac]);
				
			}
			
			var bl:int = down.height ;
			var ht:uint = down.height + frac_merged.height + up.height;
			var wt:uint = frac_merged.width;
			var rs:RasterSprite = new RasterSprite(wt, ht);
			var vcaret:uint = 0
			function calcOffset(s:TeX_Sprite):int {
				var freespace:int = (wt - s.width)
				freespace /= 2
				freespace -= freespace % font.tileWidth
				return freespace
				
			}
			
			rs.paste(up.pixels, new IntPoint(calcOffset(up), vcaret))
			vcaret += up.height
			rs.paste(frac_merged.pixels, new IntPoint(0, vcaret))
			vcaret += frac_merged.height
			rs.paste(down.pixels, new IntPoint(calcOffset(down), vcaret))
			vcaret += down.height
			
			return new TeX_Sprite(rs.getPicture(),bl)
			
		}
		
		private function renderPlainText(token:TeX_Token):TeX_Sprite {
			var chars:Array = (token as TeX_PlaintextToken).str.split("").map(totex).map(draw)
					function totex(ch:String, b:*, c:*):TeX_Character {
						return font.retrieveDataForChar(ch)
					}
					function draw(ch:TeX_Character, b:*, c:*):TeX_Sprite {
						return renderChar(ch)
					}
					var sprites:Vector.<TeX_Sprite> = new Vector.<TeX_Sprite>
					for each (var sp:TeX_Sprite in chars) {
						sprites.push(sp)
					}
			return mergeGroup(sprites)
		}
		/**
		 * 
		 * @param	token
		 * @return
		 */
		public function render(token:TeX_Token):TeX_Sprite {
			var result:TeX_Sprite
			try {
				var settings:Function = renderSettings[token.type];
				if (settings!=null) {
					result = settings(token)
				}else {
					trace("missing render settings for", token.type)
					result = renderChar(font.retrieveDataForChar("err"))
				}
				
			} catch (err:Error){
				result = renderChar(font.retrieveDataForChar("err"))
			}
			
			return result;
		}
		public function renderGroup(tokens:Vector.<TeX_Token>):Vector.<TeX_Sprite> {
			var res:Vector.<TeX_Sprite> = new Vector.<TeX_Sprite>
			for each (var tk: TeX_Token in tokens) {
				res.push(render(tk))
			}
			return res
		}
		
		private function renderSum(token:TeX_Token):TeX_Sprite {
			var down:TeX_Sprite = mergeGroup(renderGroup(token.args[0]))
			var up:TeX_Sprite = mergeGroup(renderGroup(token.args[1]))
			var sigma:TeX_Sprite = renderChar(font.retrieveDataForChar("Sigma"))
			var bl:int = down.height + sigma.beneathBaseline
			var ht:uint = down.height + sigma.height + up.height
			var wt:uint = Math.max(down.width, sigma.width, up.width)
			var rs:RasterSprite = new RasterSprite(wt, ht);
			var vcaret:uint = 0
			function calcOffset(s:TeX_Sprite):int {
				var freespace:int = (wt - s.width)
				freespace /= 2
				freespace -= freespace % font.tileWidth
				return freespace
				
			}
			
			rs.paste(up.pixels, new IntPoint(calcOffset(up), vcaret))
			vcaret += up.height
			rs.paste(sigma.pixels, new IntPoint(calcOffset(sigma), vcaret))
			vcaret += sigma.height
			rs.paste(down.pixels, new IntPoint(calcOffset(down), vcaret))
			vcaret += down.height
			
			return new TeX_Sprite(rs.getPicture(),bl)
			
		}
		private function renderRoot(root:TeX_Token):TeX_Sprite {
			new Assert(root.type == TeX_TokenType.ROOT)
			var tokens:Vector.<TeX_Token> = root.args[0]
			var drawn:Vector.<TeX_Sprite> = new Vector.<TeX_Sprite>;
			for each (var t:TeX_Token in tokens) {
				drawn.push(render(t))
			}
			return mergeGroup(drawn)
		}
		
		private function mergeGroup(sprites:Vector.<TeX_Sprite>):TeX_Sprite {
			/*
			 *  Character:
			 *
			 *    OO ↑ up=2
			 *  __OO_________
			 *    OO ↓ down=1 ( =baseline )
			 */
			// Part 0: Shortcut
			if (sprites.length == 0) {
				return renderChar(font.retrieveDataForChar("err"))
			}
			if (sprites.length == 1) {
				return sprites[0]
			}
			// Part I: Calculating bitmap size
			var group_up:int = 0;
			var group_down:int = 0;
			var width:int = 0;
			for each (var dr:TeX_Sprite in sprites) {
				var up:int = dr.aboveBaseline
				var down:int = dr.beneathBaseline
				
				width += dr.width
				new Assert(up > -down)
				if (up > group_up) {
					group_up = up
				}
				if (down > group_down) {
					group_down = down
				}
				
			}
			// Part II: Create a bitmap
			var rs:RasterSprite = new RasterSprite(width, group_up + group_down)
			var hcaret:uint
			for each (var sp:TeX_Sprite in sprites) {
				var offset:uint = group_up - sp.height + sp.beneathBaseline
				rs.paste(sp.pixels, new IntPoint(hcaret, offset))
				hcaret += sp.width;
			}
			return new TeX_Sprite(rs.getPicture(), group_down)
		}
		
		private function renderChar(c:TeX_Character):TeX_Sprite {
			var bd:BitmapData = new BitmapData(c.width * font.tileWidth, c.tilesHeight * font.tileHeight);
			var tiles:Array = c.tiles.slice()
			for (var i:int = 0; i < c.tilesHeight; i++) {
				for (var j:int = 0; j < c.width; j++) {
					//[row,column]
					var coords:Array = String(tiles.shift()).split(",")
					bd.copyPixels(font.font, new Rectangle(coords[1] * font.tileWidth, coords[0] * font.tileHeight, font.tileWidth, font.tileHeight), new Point(j * font.tileWidth, i * font.tileHeight));
				}
			}
			return new TeX_Sprite(bd,c.beneathBaseline*font.tileWidth)
		}
	
	}

}