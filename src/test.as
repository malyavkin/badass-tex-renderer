package  {
	import com.am_devcorp.algo.processing.TeX.TeX_PlaintextToken;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import tex_visual.TeX_Renderer2;
	import tex_visual.TeX_Sprite;
	import tex_visual.TeX_TiledFont;
	/**
	 * ...
	 * @author Malyavkin Alexey <a@malyavk.in>
	 */
	public class test extends Sprite{
		
		public function test() {
			new ResourceProvider
			var fnt:TeX_TiledFont = new TeX_TiledFont(ResourceProvider.font,ResourceProvider.mapping)
			var renderer:TeX_Renderer2 = new TeX_Renderer2(fnt)
			
			var a:Vector.<TeX_Sprite> = renderer.formPlainText(new TeX_PlaintextToken("Hello"))
			trace(a.length)

		}
		
	}

}