package  {
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
			var sp:TeX_Sprite = renderer.formChar(fnt.retrieveDataForChar("Sigma"))
			trace(sp.width)
			trace(sp.height)
			
		}
		
	}

}