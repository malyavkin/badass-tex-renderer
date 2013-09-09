package {
    // my libs
    import com.am_devcorp.algo.graphics.render.rasterstage.*;
    import com.am_devcorp.algo.processing.TeX.TeX;
    import com.am_devcorp.algo.processing.TeX.TeX_Token;
    import com.am_devcorp.algo.system.Props;
    import flash.display.BitmapData;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.TimerEvent;
    import flash.geom.Point;
    import flash.system.Capabilities;
    import flash.text.TextField;
    import flash.text.TextFieldType;
    import flash.utils.getTimer;
    import flash.utils.Timer;
    import tex_common.*;
    import tex_visual_v2.TeX_Renderer;
    //current project
    // SDK
    /**
     * ...
     * @author Alexey Malyavkin <a@malyavk.in>
     */
    
    [SWF(width=480,height=320,frameRate="60",backgroundColor="#cccccc")]
    
    public class Main extends Sprite {
        ///display
        private var screen:RasterScreen
        private var gridscreen:RasterScreen
        
        ///its contents
        private var raster:RasterSprite
        private var grid:RasterSprite
        private var textfield:TextField;
        
        ///timers ()
        private var now:uint
        private var last:uint
        
        ///properties of the main window
        //!  when changing WIDTH and HEIGHT don't forget to change values in [SWF] tag above ^^
        private const SCALE:uint = 2
        private const WIDTH:uint = 480 / SCALE
        private const HEIGHT:uint = 320 / SCALE
        private const NUM_PIXELS:uint = WIDTH * HEIGHT
        
        ///test subjects
        private var font:TeX_TiledFont
        private var tex_renderer:TeX_Renderer;
        
        public function Main() {
            now = getTimer()
            if (Props.air) {
                setupAIRWindow();
            }
            setupScale()
            var t:Timer;
            new ResourceProvider()
            
            raster = new RasterSprite(WIDTH, HEIGHT)
            screen = new RasterScreen(raster);
            
            grid = new RasterSprite(WIDTH, HEIGHT)
            gridscreen = new RasterScreen(grid);
            grid.tile(ResourceProvider.grid)
            gridscreen.upd()
            
            textfield = new TextField()
            textfield.width = WIDTH
            textfield.height = 16
            textfield.type = TextFieldType.INPUT
            textfield.x = 0
            textfield.y = HEIGHT - textfield.height - 3
            textfield.border = true
            textfield.addEventListener(Event.CHANGE, onTextFieldChange)
            textfield.text = "\\sum{0}{5} \\frac{\\sum{0}{5}x}{2} = \\frac{15}{2} = 7\\frac{1}{2}"; //tnx captain obvious
            
            addChild(gridscreen);
            addChild(screen);
            addChild(textfield)
            
            trace("0:screen init:" + (getTimer() - now) + "ms")
            now = getTimer()
            
            font = new TeX_TiledFont(ResourceProvider.font, ResourceProvider.mapping)
            tex_renderer = new TeX_Renderer(font)
            
            trace("0:tex init:" + (getTimer() - now) + "ms")
            now = getTimer()
            
            onTextFieldChange();
            
            trace("0:initial draw:" + (getTimer() - now) + "ms")
            now = getTimer()
            
            addEventListener(Event.ENTER_FRAME, onEnterFrame);
            t = new Timer(20);
            t.addEventListener(TimerEvent.TIMER, onTimer);
            t.start();
            trace("0:main:" + (getTimer() - now) + "ms")
        }
        
        private function onTextFieldChange(e:Event = null):void {
            now = getTimer()
            var token:TeX_Token = TeX.Parse(textfield.text);
            var product:BitmapData
            for (var i:int = 0; i < 1000; i++) {
                //v1
                //product = tex_renderer.render(token).pixels
                //v2
                product = tex_renderer.rasterize(tex_renderer.form(token))
            }
            raster.loadPicture(product)
            trace((getTimer() - now) / 1000, "ms")
        }
        
        public function onEnterFrame(e:Event):void {
            now = getTimer()
            screen.upd();
            onTimer()
        }
        
        public function onTimer(e:Event = null):void {
        
        }
        
        public function setupAIRWindow():void {
            var screenX:uint = Capabilities.screenResolutionX
            var screenY:uint = Capabilities.screenResolutionY
            stage.nativeWindow.width = WIDTH * SCALE
            stage.nativeWindow.height = HEIGHT * SCALE
            
            var hSystemChrome:uint = stage.nativeWindow.width - stage.stageWidth;
            var vSystemChrome:uint = stage.nativeWindow.height - stage.stageHeight;
            
            stage.nativeWindow.width = WIDTH * SCALE + hSystemChrome
            stage.nativeWindow.height = HEIGHT * SCALE + vSystemChrome;
            
            stage.nativeWindow.minSize = new Point(WIDTH * SCALE + hSystemChrome, HEIGHT * SCALE + vSystemChrome)
            stage.nativeWindow.maxSize = new Point(WIDTH * SCALE + hSystemChrome, HEIGHT * SCALE + vSystemChrome)
            
            stage.nativeWindow.x = (screenX - stage.nativeWindow.width) / 2
            stage.nativeWindow.y = (screenY - stage.nativeWindow.height) / 2
        
        }
        
        public function setupScale():void {
            scaleX = SCALE
            scaleY = SCALE
        }
    
    }

}