package tex_visual {
	import com.am_devcorp.algo.graphics.UIntPoint;
	import com.am_devcorp.algo.processing.TeX.TeX_PlaintextToken;
	import com.am_devcorp.algo.processing.TeX.TeX_Token;
	import com.am_devcorp.algo.processing.TeX.TeX_TokenType;
	import com.am_devcorp.mathtricks.mathtricks;
	import flash.display.BitmapData;
	import flash.text.TextFormatAlign;
	/**
	 * TeX_Sprite -- 1 piece(tile) of a character
	 * TeX_SpriteContainer -- 1 character, consists of Vector.<TeX_Sprite>
	 * Vector.<TeX_SpriteContainer> -- string
	 * @author Malyavkin Alexey <a@malyavk.in>
	 */
	public class TeX_Renderer2 {
		private var font:TeX_TiledFont
		private var renderSettings:Object;
		public function TeX_Renderer2(fnt:TeX_TiledFont) {
			font = fnt
			renderSettings = new Object()
			renderSettings[TeX_TokenType.ROOT] = formRoot
			renderSettings[TeX_TokenType.PLAIN] = formPlainText
			renderSettings[TeX_TokenType.SUM] = formSum 
			//renderSettings[TeX_TokenType.FRACTION] = formFrac 
		}
		public function toString():String {
			var s:String = ""
			for each (var i:String in renderSettings) {
				s+=i+" "
			}
			
			return "tiles: "+font.tileFormatInt+" supported tokens: "+s
		}
		
		public function rasterize(group:TeX_SpriteContainer):BitmapData {
			var bd:BitmapData = new BitmapData(group.width, group.height,true,0);
			bd.lock()
			for each (var piece:TeX_Sprite in group.pieces) {
				bd.copyPixels(font.font,piece,piece.position.as_point,null,null,true)
			}
			bd.unlock()
			return bd
			
		}
		
		
		// MERGE
		
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
		/**
		 * 
		 * @param	vec
		 * @param	align
		 * @param	snap_grid_width
		 * @return
		 */
		private function mergeVertically(vec:Vector.<TeX_SpriteContainer>,
										  baselineOriginIndex:uint,
										  align:String = TextFormatAlign.LEFT,
										  snap_grid_width:uint = 1):TeX_SpriteContainer {
			var global_width:uint
			var widths:Vector.<uint> = new Vector.<uint>
			var offsets:Vector.<uint> = new Vector.<uint>
			var res:Vector.<TeX_Sprite> =  new Vector.<TeX_Sprite>
			var global_above_baseline:int=0
			for each (var sc:TeX_SpriteContainer in vec) {
				var wt:uint = sc.width
				if (wt > global_width) global_width = wt;
				widths.push(wt)
			}

			switch (align) {
				case TextFormatAlign.LEFT:
				case TextFormatAlign.JUSTIFY:
				case TextFormatAlign.START:
				default:
					offsets = widths.map(function (val:uint,i:*,a:*):uint {
						return 0
					})
					break;
				case TextFormatAlign.CENTER:
					offsets = widths.map(function (val:uint,i:*,a:*):uint {
						var offset:uint = (global_width - val) / 2
						offset -= offset%snap_grid_width
						return offset
						
					})
					break;
				case TextFormatAlign.RIGHT:
				case TextFormatAlign.END:
					offsets = widths.map(function (val:uint,i:*,a:*):uint {
						return global_width-val
					})
				break;
			}
			var vcaret:uint = 0
			for (var j:int = 0; j < vec.length; j++) {
				if (j == baselineOriginIndex) {
					global_above_baseline = vcaret+vec[j].aboveBaseline
				}
				var new_vcaret:uint
				var container_offset:UIntPoint = new UIntPoint(offsets[j],vcaret)
				for each (var sprite:TeX_Sprite in vec[j].pieces) {
					sprite.position.x += container_offset.x
					sprite.position.y += container_offset.y
					res.push(sprite)
					if (sprite.position.y+sprite.height > new_vcaret) {
						new_vcaret = sprite.position.y + sprite.height;
					}
				}
				vcaret = new_vcaret
			}
			
			return new TeX_SpriteContainer(res,vcaret-global_above_baseline)
		}
		
		// Formatters
		/**
		 * Selects proper function to form a container
		 * @param	token
		 * @return
		 */
		public function form(token:TeX_Token):TeX_SpriteContainer {
			var result:TeX_SpriteContainer
			var settings:Function = renderSettings[token.type];
			if (settings!=null) {
				result = settings(token)
			}else {
				trace("missing render settings for", token.type)
				result = formChar(font.retrieveDataForChar("err"))
			}
			
			return result;

		}
		/**
		 * Use this for batch token forming
		 * @param	tokens Vector of tokens to be rendered
		 * @return vector of formed tokens
		 */
		private function batchForm(tokens:Vector.<TeX_Token>):Vector.<TeX_SpriteContainer> {
			var res:Vector.<TeX_SpriteContainer> = new Vector.<TeX_SpriteContainer>
			for each (var tk: TeX_Token in tokens) {
				res.push(form(tk))
			}
			return res
		}
		
		
		
		private function formRoot(token:TeX_Token):TeX_SpriteContainer {
			var children:Vector.<TeX_Token> = token.args[0];
			return mergeInLine(batchForm(children))
		}
		private function formSum(token:TeX_Token):TeX_SpriteContainer {
			var down:TeX_SpriteContainer = mergeInLine(batchForm(token.args[0]))
			var up:TeX_SpriteContainer= mergeInLine(batchForm(token.args[1]))
			var sigma:TeX_SpriteContainer = formChar(font.retrieveDataForChar("Sigma"))
			return mergeVertically(new <TeX_SpriteContainer>[up,sigma,down],1,TextFormatAlign.CENTER,font.tileWidth)
			
		}
		
		private function formPlainText(token:TeX_Token):TeX_SpriteContainer {
			var text_to_render:String = (token as TeX_PlaintextToken).str
			var arr:Array = text_to_render.split("").map(parse).map(formc)
			///Wraps TeX_TiledFont.retrieveDataForChar() for using in Array.map()
			function parse(elem:String, a:*,b:*):TeX_Character {
				return font.retrieveDataForChar(elem)
			}
			///Wraps formChar() for using in Array.map()
			function formc(char:TeX_Character, a:*, b:*):TeX_SpriteContainer {
				return formChar(char)
			}
			var vec:Vector.<TeX_SpriteContainer> = new Vector.<TeX_SpriteContainer>
			vec.push.apply(null, arr)// transforming array to Vector.<TeX_Sprite> 
			return mergeInLine(vec)
		}
		
		private function formChar(c:TeX_Character):TeX_SpriteContainer {
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
			return new TeX_SpriteContainer(pcs,c.beneathBaseline*font.tileHeight)
		}
	}
}