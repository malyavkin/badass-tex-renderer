package {
    import com.am_devcorp.algo.processing.TeX.TeX_PlaintextToken;
    import com.am_devcorp.algo.processing.TeX.TeX_Token;
    import flash.display.Bitmap;
    import flash.display.Sprite;
    import tex_visual.TeX_Renderer2;
    import tex_visual.TeX_SpriteContainer;
    import tex_visual.TeX_TiledFont;
    import com.am_devcorp.algo.processing.TeX.TeX;
    
    /**
     * ...
     * @author Malyavkin Alexey <a@malyavk.in>
     */
    [SWF(width=480,height=320,frameRate="60",backgroundColor="#cccccc")]
    
    public class test extends Sprite {
        
        public function test() {
            new ResourceProvider();
            var fnt:TeX_TiledFont = new TeX_TiledFont(ResourceProvider.font, ResourceProvider.mapping)
            var renderer:TeX_Renderer2 = new TeX_Renderer2(fnt)
            
            var tk:TeX_Token = TeX.Parse("hello world\\frac{1}{2}")
            var tc:TeX_SpriteContainer = renderer.form(tk)
            var bm:Bitmap = new Bitmap(renderer.rasterize(tc))
            this.scaleX = 2
            this.scaleY = 2
            
            addChild(bm)
            trace(renderer)
        
        }
    
    }

}