package tex_common {
    import com.am_devcorp.algo.graphics.IntPoint;
    import flash.display.BitmapData;
    import flash.geom.Point;
    import flash.geom.Rectangle
    
    /**
     * ...
     * @author am_devcorp
     */
    public class TeX_TiledFont {
        private var _tileHeight:uint;
        private var _tileWidth:uint;
        private var charset:Object; // we will do some smart-ass hakz
        
        private var font_ptr:BitmapData
        
        //private var map_res:XML
        
        public function TeX_TiledFont(fontPtr:BitmapData, mappingPtr:XML) {
            charset = new Object()
            font_ptr = fontPtr;
            //map_res = mappingPtr;
            
            initCharset(mappingPtr)
        }
        
        private function initCharset(map:XML):void {
            _tileWidth = map.attribute("width")
            _tileHeight = map.attribute("height")
            
            //parsing chars
            var processing_chr:TeX_Character
            var mapping_chr:TeX_Character
            for each (var chr:XML in map.char) {
                processing_chr = new TeX_Character()
                processing_chr.beneathBaseline = chr.attribute("baseline")
                processing_chr.tiles = (new String(chr.attribute("tiles"))).split(";")
                
                processing_chr.width = chr.attribute("width")
                
                addToCharset(chr.attribute("code"), processing_chr)
            }
            for each (var mapping:XML in map.map) {
                mapping_chr = new TeX_Character()
                var to:String = mapping.attribute("to")
                if (charset[to]) {
                    addToCharset(mapping.attribute("code"), charset[to])
                } else {
                    trace("2:/!\\ character \"" + mapping.attribute("code") + "\" is incorrectly mapped. omitting")
                }
            }
            //trace(charset["a"])
        }
        
        private function addToCharset(code:String, mapping_chr:TeX_Character):void {
            if (charset[code]) {
                trace("duplicate", code);
            } else {
                charset[code] = mapping_chr;
            }
        }
        
        public function retrieveDataForChar(code:String):TeX_Character {
            return charset[code] || charset["err"] as TeX_Character
        }
        
        public function get tileFormat():Point {
            return new Point(_tileWidth, _tileHeight)
        }
        
        public function get tileFormatInt():IntPoint {
            return new IntPoint(_tileWidth, _tileHeight)
        }
        
        public function get font():BitmapData {
            return font_ptr;
        }
        
        public function get tileWidth():uint {
            return _tileWidth;
        }
        
        public function get tileHeight():uint {
            return _tileHeight;
        }
    
    }

}