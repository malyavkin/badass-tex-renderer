package tex_visual_v2 {
    import com.am_devcorp.algo.graphics.UIntPoint;
    import com.am_devcorp.algo.graphics.render.rasterstage.RasterSprite;
    import flash.display.BitmapData;
    import flash.geom.Rectangle;
    import com.am_devcorp.mathtricks.mathtricks
    
    /**
     * ...
     * @author am_devcorp
     */
    public class TeX_Sprite extends Rectangle {
        
        public var position:UIntPoint; // position relative to parent
        
        public function TeX_Sprite(x:uint, y:uint, width:uint, height:uint, position:UIntPoint) {
            super(x, y, width, height)
            this.position = position
        }
        
        public function copy():TeX_Sprite {
            return new TeX_Sprite(x, y, width, height, position.copy)
        }
        
        override public function toString():String {
            return super.toString() + "/ TeX Sprite @" + this.position
        }
    
    }

}