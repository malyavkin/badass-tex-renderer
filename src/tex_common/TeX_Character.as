package tex_common {
    
    /**
     * Contains information about character: tiles, positioning and so on
     * @author am_devcorp
     */
    public class TeX_Character {
        public var tiles:Array
        private var _width:uint = 1;
        private var _baseline:int = 0;
        
        /**
         * Baseline determines how many pixels below the baseline we should lower the character
         * baseline = 0  baseline = 1
         * above    = 3  above    = 2
         * beneath  = 0  beneath  = 1
         *
         *   OO
         *   OO            OO
         * __OO_________ __OO_______
         *                 OO
         * Above baseline -- position of top border relative to baseline
         * Beneath baseline -- position of bottom border relative to baseline
         */
        
        public function get tilesHeight():uint {
            return Math.ceil(tiles.length / _width) as uint
        }
        
        public function get aboveBaseline():int {
            return tilesHeight - _baseline
        }
        
        public function get beneathBaseline():int {
            return _baseline;
        }
        
        public function get width():uint {
            return _width;
        }
        
        public function set beneathBaseline(value:int):void {
            _baseline = value;
        }
        
        public function set width(value:uint):void {
            _width = value;
        }
    }

}