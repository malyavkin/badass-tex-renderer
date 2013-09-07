package {
	import com.am_devcorp.algo.processing.TeX.TeX_PlaintextToken;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import tex_visual.TeX_Renderer2;
	import tex_visual.TeX_SpriteContainer;
	import tex_visual.TeX_TiledFont;
	
	/**
	 * ...
	 * @author Malyavkin Alexey <a@malyavk.in>
	 */
	public class test extends Sprite {
		
		public function test() {
			new ResourceProvider
			var fnt:TeX_TiledFont = new TeX_TiledFont(ResourceProvider.font, ResourceProvider.mapping)
			var renderer:TeX_Renderer2 = new TeX_Renderer2(fnt)
			
			var a:TeX_SpriteContainer = renderer.formPlainText(new TeX_PlaintextToken("Hello"))
			var bm:Bitmap = new Bitmap(renderer.rasterize(a))
			this.scaleX = 2
			this.scaleY = 2
			
			addChild(bm)
			
			
			
		
		}
	
	}

}